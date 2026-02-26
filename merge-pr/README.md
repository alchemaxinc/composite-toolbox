# Enable Pull Request Automerge :twisted_rightwards_arrows:

This GitHub Action enables auto-merge on a pull request using the GitHub CLI.

> [!IMPORTANT]
> Auto-merge must be enabled in the repository settings for this action to work. The pull request must also pass all required status checks before it will be merged.

## :rocket: Usage

```yaml
name: Auto-merge
on:
  pull_request:
    types: [opened]

jobs:
  auto-merge:
    runs-on: ubuntu-latest
    steps:
      - name: Enable auto-merge
        uses: alchemaxinc/composite-toolbox/merge-pr@v1
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          pull-request-number: ${{ github.event.pull_request.number }}
          merge-method: squash
```

## :gear: Inputs

| Input                 | Description                                               | Required | Default                  |
| --------------------- | --------------------------------------------------------- | -------- | ------------------------ |
| `token`               | GitHub token for authentication                           | :x:      | `${{ github.token }}`    |
| `repository`          | The target GitHub repository containing the pull request  | :x:      | `${{ github.repository}}` |
| `pull-request-number` | The number of the target pull request                     | :white_check_mark: | -             |
| `merge-method`        | The merge method: `merge`, `rebase`, or `squash`          | :x:      | `merge`                  |

## :warning: Prerequisites

- Auto-merge must be enabled in the repository settings
- The token must have permissions to merge pull requests
- GitHub CLI must be available in the runner environment
