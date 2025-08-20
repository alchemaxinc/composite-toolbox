# Check Changes :mag:

This GitHub Action checks if specified files have changes in the working directory using git diff.

> [!IMPORTANT]  
> This action only checks for uncommitted changes in the working directory. It does not compare between different commits or branches.

## :rocket: Usage

```yaml
name: Check for Changes
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  check-changes:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Check for changes
        uses: alchemaxinc/composite-toolbox/check-changes@v1
        id: check-changes
        with:
          files: 'package.json yarn.lock'

      - name: Run only if changes detected
        if: steps.check-changes.outputs.has_changes == 'true'
        run: echo "Dependencies have changed!"
```

## :gear: Inputs

| Input   | Description                            | Required           | Default |
| ------- | -------------------------------------- | ------------------ | ------- |
| `files` | Space-separated list of files to check | :white_check_mark: | `''`    |

## :outbox_tray: Outputs

| Output        | Description                             |
| ------------- | --------------------------------------- |
| `has_changes` | Whether files have changed (true/false) |

## :warning: Prerequisites

- The repository must be checked out before using this action
- Git must be available in the runner environment
