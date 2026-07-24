# Find or Create Issue :mag:

This GitHub Action idempotently finds an existing issue by exact title, or
creates a new one. Use it in scheduled workflows that alert on a recurring
condition (e.g. a failing dependency audit) so repeated runs reuse one issue
instead of filing a duplicate every time.

> [!IMPORTANT]  
> Composite actions can only be invoked via a `uses:` step, which can't be
> looped inline within a single job step. If you need to file one issue per
> item in a bash loop, check out this repository and invoke
> `find-or-create-issue/find-or-create-issue.sh` directly by path instead —
> see [Looping over multiple items](#looping-over-multiple-items) below.

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
        uses: alchemaxinc/composite-toolbox/find-or-create-issue@v1.19.0
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          state: open
          label: bug
          title: 'Scheduled check failing'
          body: 'The scheduled check failed. See the workflow run for details.'
```

## :gear: Inputs

| Input   | Description                                                           | Required           | Default |
| ------- | --------------------------------------------------------------------- | ------------------ | ------- |
| `title` | Exact issue title to search for and, if not found, create             | :white_check_mark: | -       |
| `body`  | Markdown body to use when creating a new issue                        | :white_check_mark: | -       |
| `token` | Token passed to `gh` as `GH_TOKEN` for issue list/create calls        | :white_check_mark: | -       |
| `label` | Label to apply when creating a new issue                              | :x:                | `''`    |
| `type`  | Issue type to apply when creating a new issue (e.g. `Feature`, `Bug`) | :x:                | `''`    |
| `state` | Issue state to search within (`open` or `all`)                        | :x:                | `'all'` |

## :outbox_tray: Outputs

| Output | Description                                |
| ------ | ------------------------------------------ |
| `url`  | URL of the existing or newly created issue |

## :warning: Prerequisites

- The `gh` CLI must be available in the runner environment (preinstalled on
  GitHub-hosted runners)
- `GH_TOKEN` (via the `token` input) must have permission to list and create
  issues in the target repository

## :repeat: Looping over multiple items

To file one issue per item detected in a bash loop, check out this repository
into a subdirectory and call the script directly instead of using `uses:`:

```yaml
- name: Checkout composite-toolbox
  uses: actions/checkout@v7
  with:
    repository: alchemaxinc/composite-toolbox
    ref: v1
    path: .composite-toolbox

- name: File one issue per detected item
  env:
    GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  run: |
    for item in $ITEMS; do
      .composite-toolbox/find-or-create-issue/find-or-create-issue.sh \
        --title "Support for $item" \
        --body "Detected $item; needs support." \
        --label enhancement
    done
```
