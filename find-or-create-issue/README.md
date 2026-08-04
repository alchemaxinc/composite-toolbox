# Find or Create Issue :mag:

This action finds an existing issue by exact title, or creates a new one. The
search is idempotent: repeated runs reuse one issue instead of filing a new
one each time. Use it in scheduled workflows that alert on a recurring
condition, for example, a failing dependency audit.

> [!IMPORTANT]
> A `uses:` step is static. It cannot run inside a Bash loop. If you need to
> file one issue per item found at runtime, use a matrix job instead. See
> [Filing one issue per detected item](#repeat-filing-one-issue-per-detected-item)
> below.

## :rocket: Usage

```yaml
name: Scheduled Check
on:
  workflow_dispatch:
  schedule:
    - cron: '0 6 * * *'

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - name: Run a check that might fail
        id: check
        run: some-command-that-may-fail

      - name: File or reuse tracking issue
        if: failure() && steps.check.outcome == 'failure'
        uses: alchemaxinc/composite-toolbox/find-or-create-issue@v1.21.0
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          state: open
          label: bug
          title: 'Scheduled check failing'
          body: 'The scheduled check failed. See the workflow run for details.'
```

## :gear: Inputs

| Input   | Description                                                                     | Required           | Default |
| ------- | ------------------------------------------------------------------------------- | ------------------ | ------- |
| `title` | Exact issue title to search for and, if not found, create                       | :white_check_mark: | -       |
| `body`  | Markdown body to use when creating a new issue                                  | :white_check_mark: | -       |
| `token` | Token passed to `gh` as `GH_TOKEN` for issue list/create calls                  | :white_check_mark: | -       |
| `label` | Label to apply when creating a new issue                                        | :x:                | `''`    |
| `type`  | Issue type to apply when creating a new issue (for example, `Feature` or `Bug`) | :x:                | `''`    |
| `state` | Issue state to search within (`open` or `all`)                                  | :x:                | `'all'` |

## :outbox_tray: Outputs

| Output | Description                                |
| ------ | ------------------------------------------ |
| `url`  | URL of the existing or newly created issue |

## :warning: Prerequisites

- The `gh` CLI must be available in the runner environment (preinstalled on
  GitHub-hosted runners)
- `GH_TOKEN` (via the `token` input) must have permission to list and create
  issues in the target repository

## :repeat: Filing one issue per detected item

A `uses:` step is static and cannot run inside a Bash loop. To file one issue
per item found at runtime, use a matrix job instead: one job instance per
item, and each instance calls this action directly, like any other `uses:`
step:

```yaml
jobs:
  detect:
    runs-on: ubuntu-latest
    outputs:
      items: ${{ steps.detect.outputs.items }} # JSON array, for example, '["a","b"]'
    steps:
      - name: Detect items
        id: detect
        run: echo 'items=["a","b"]' >> "$GITHUB_OUTPUT"

  file-issues:
    needs: detect
    runs-on: ubuntu-latest
    strategy:
      matrix:
        item: ${{ fromJson(needs.detect.outputs.items) }}
    steps:
      - name: File or reuse tracking issue
        uses: alchemaxinc/composite-toolbox/find-or-create-issue@v1.21.0
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          title: 'Support for ${{ matrix.item }}'
          body: 'Detected ${{ matrix.item }}; needs support.'
          label: enhancement
```

If a later job needs the filed issue URLs, for example to update a support
matrix file, have each matrix job upload its result as an artifact with a
unique name per item. Then download and merge them in the downstream job with
[`actions/download-artifact`](https://github.com/actions/download-artifact)'s
`pattern` and `merge-multiple` inputs. Matrix job outputs are not aggregated
across instances, so `needs.<job>.outputs` alone does not expose every
result.
