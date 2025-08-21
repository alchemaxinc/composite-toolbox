# Create Pull Request :arrows_counterclockwise:

This GitHub Action creates a new branch, commits specified files, and opens a pull request with the changes.

> [!IMPORTANT]
> This action creates a unique branch name using timestamp and run ID to avoid conflicts. It requires the GitHub CLI to
> be available in the runner environment.

## :rocket: Usage

```yaml
name: Create Pull Request
on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  create-pr:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Make changes
        run: |
          # Your changes here
          npm update

      - name: Create Pull Request
        uses: alchemaxinc/composite-toolbox/create-pr@v1
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          base-branch: 'main'
          branch-prefix: 'automated-updates'
          files: 'package.json package-lock.json'
          commit-message: 'chore: automated dependency updates'
          pr-title: 'Automated Dependency Updates'
          pr-body: |
            ## 🤖 Automated Updates

            This PR contains automated updates.
```

## :gear: Inputs

| Input            | Description                            | Required           |
| ---------------- | -------------------------------------- | ------------------ |
| `token`          | GitHub token for authentication        | :white_check_mark: |
| `base-branch`    | Base branch for the pull request       | :white_check_mark: |
| `branch-prefix`  | Prefix for the new branch name         | :white_check_mark: |
| `files`          | Files to commit (space-separated)      | :white_check_mark: |
| `commit-message` | Commit message                         | :white_check_mark: |
| `pr-title`       | Pull request title                     | :white_check_mark: |
| `pr-body`        | Pull request body (Markdown supported) | :white_check_mark: |

## :warning: Prerequisites

- The repository must be checked out before using this action
- Git must be configured with user credentials
- The token must have permissions to create branches and pull requests
- GitHub CLI must be available in the runner environment
