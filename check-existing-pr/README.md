# Check for Existing Pull Request :mag:

This GitHub Action checks whether an open pull request with an exact title
already exists on a target base branch.

Use it to prevent duplicate automation PRs.

## :rocket: Usage

```yaml
name: Check Existing PR
on:
  workflow_dispatch:

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - name: Check for existing PR
        id: check-pr
        uses: alchemaxinc/composite-toolbox/check-existing-pr@v1.21.0
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          pr-title: 'chore: update dependencies'
          base-branch: 'main'

      - name: Print result
        run: echo "Exists? ${{ steps.check-pr.outputs.exists }}"
```

## :gear: Inputs

| Input         | Description                                 | Required           |
| ------------- | ------------------------------------------- | ------------------ |
| `token`       | GitHub token used to query pull requests    | :white_check_mark: |
| `pr-title`    | Exact pull request title to search for      | :white_check_mark: |
| `base-branch` | Base branch to search open pull requests on | :white_check_mark: |

## :outbox_tray: Outputs

| Output   | Description                                                     |
| -------- | --------------------------------------------------------------- |
| `exists` | Whether a matching open pull request exists (`true` or `false`) |

## :warning: Prerequisites

- The token must have at least `pull-requests: read` permission on the
  target repository, for example:

  ```yaml
  permissions:
    pull-requests: read
  ```
