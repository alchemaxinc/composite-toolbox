# Create Pull Request :arrows_counterclockwise:

This GitHub Action creates a new branch, commits specified files, and opens a pull request with the changes.

> [!IMPORTANT]
> This action creates a branch name by combining the `branch-prefix` with either a custom `branch-postfix` (if provided) or a unique timestamp and run ID (to avoid conflicts). It requires the GitHub CLI to be available in the runner environment.

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
        uses: actions/checkout@v6

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

### With Custom Branch Name

```yaml
- name: Create Pull Request with Custom Branch
  uses: alchemaxinc/composite-toolbox/create-pr@v1
  with:
    token: ${{ secrets.GITHUB_TOKEN }}
    base-branch: 'main'
    branch-prefix: 'feature'
    branch-postfix: 'my-custom-feature' # Branch will be named: feature-my-custom-feature
    files: 'package.json package-lock.json'
    commit-message: 'feat: add new feature'
    pr-title: 'Add New Feature'
    pr-body: |
      ## ✨ New Feature

      This PR adds a new feature.
```

## :gear: Inputs

| Input            | Description                                                                       | Required           |
| ---------------- | --------------------------------------------------------------------------------- | ------------------ |
| `token`          | GitHub token for authentication                                                   | :white_check_mark: |
| `base-branch`    | Base branch for the pull request                                                  | :white_check_mark: |
| `branch-prefix`  | Prefix for the new branch name                                                    | :white_check_mark: |
| `branch-postfix` | Postfix for the new branch name (defaults to `YYYYMMDD-{run_id}` if not provided) | :x:                |
| `files`          | Files to commit (space-separated). If empty, no commit is made (useful for backmerge PRs) | :x:                |
| `commit-message` | Commit message (required when files is provided)                                  | :x:                |
| `pr-title`       | Pull request title                                                                | :white_check_mark: |
| `pr-body`        | Pull request body (Markdown supported)                                            | :white_check_mark: |

## :warning: Prerequisites

- The repository must be checked out before using this action
- Git must be configured with user credentials
- The token must have permissions to create branches and pull requests
- GitHub CLI must be available in the runner environment
