# Merge Pull Request :twisted_rightwards_arrows:

This GitHub Action enables auto-merge on a pull request, so it merges
automatically once its required checks and reviews pass.

## :rocket: Usage

```yaml
name: Enable Auto-merge
on:
  pull_request:
    types: [opened]

jobs:
  enable-automerge:
    runs-on: ubuntu-latest
    steps:
      - name: Enable auto-merge
        uses: alchemaxinc/composite-toolbox/merge-pr@v1.22.0
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          pull-request-number: ${{ github.event.pull_request.number }}
          merge-method: 'squash'
```

## :gear: Inputs

| Input                 | Description                                                   | Required           | Default                    |
| --------------------- | ------------------------------------------------------------- | ------------------ | -------------------------- |
| `token`               | `GITHUB_TOKEN` or a `repo`-scoped Personal Access Token (PAT) | :x:                | `${{ github.token }}`      |
| `repository`          | Target repository containing the pull request                 | :x:                | `${{ github.repository }}` |
| `pull-request-number` | Number of the target pull request                             | :white_check_mark: | -                          |
| `merge-method`        | Merge method to use (`merge`, `squash`, or `rebase`)          | :x:                | `'merge'`                  |

## :warning: Prerequisites

- The repository must have auto-merge enabled (**Settings → General → Allow
  auto-merge**).
- The token must have permission to update the pull request.
- Pair this action with
  [validate-merge-method](../validate-merge-method/) to check the
  `merge-method` input before use.
