# Detect Changed Files :mag:

This GitHub Action checks whether files matching the given pathspecs changed
between a base ref and `HEAD` — for example, across a pull request. Use it to
gate slow jobs so they only run when relevant files change.

> [!IMPORTANT]  
> This action compares against a base commit, so the repository must be checked
> out with full history (`fetch-depth: 0`) so that the base commit is reachable.

## :rocket: Usage

```yaml
name: CI
on:
  pull_request:

jobs:
  detect-changes:
    runs-on: ubuntu-latest
    outputs:
      has_changes: ${{ steps.detect.outputs.has_changes }}
    steps:
      - name: Checkout code
        uses: actions/checkout@v5
        with:
          fetch-depth: 0

      - name: Detect changed files
        uses: alchemaxinc/composite-toolbox/detect-changed-files@v1.17.0
        id: detect
        with:
          files: '*.go go.mod go.sum'

  test:
    needs: detect-changes
    if: needs.detect-changes.outputs.has_changes == 'true'
    runs-on: ubuntu-latest
    steps:
      - run: echo 'Go files changed!'
```

## :gear: Inputs

| Input   | Description                                                                         | Required | Default |
| ------- | ----------------------------------------------------------------------------------- | -------- | ------- |
| `files` | Space-separated list of git pathspecs to check; if left empty, any change counts    | :x:      | `''`    |
| `base`  | Base ref or SHA to compare `HEAD` against; defaults to the pull request base commit | :x:      | `''`    |

## :outbox_tray: Outputs

| Output          | Description                                                        |
| --------------- | ------------------------------------------------------------------ |
| `has_changes`   | Whether any matching files changed between the base ref and `HEAD` |
| `changed_files` | Newline-separated list of changed files matching the pathspecs     |

## :warning: Prerequisites

- The repository must be checked out with full history (`fetch-depth: 0`) so
  the base commit is reachable
- Git must be available in the runner environment
- On events other than `pull_request`, provide the `base` input explicitly
