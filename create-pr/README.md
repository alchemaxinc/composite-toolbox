# Create Pull Request :arrows_counterclockwise:

This action creates a new branch, commits the files you list, and opens a
pull request with the changes.

> [!IMPORTANT]
> The branch name combines `branch-prefix` with either a custom
> `branch-postfix` or a unique timestamp and run ID. The unique default
> avoids name conflicts. `branch-prefix` and `branch-postfix` can only
> contain letters, digits, `.`, `_`, `/`, or `-`. This action needs the
> GitHub CLI in the runner environment. The action pushes the branch with
> `--force-with-lease`. If a branch with the same name already has commits
> from another source, the push fails instead of overwriting them.

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
        uses: actions/checkout@v7

      - name: Make changes
        run: |
          # Your changes here
          npm update

      - name: Create Pull Request
        uses: alchemaxinc/composite-toolbox/create-pr@v1.21.0
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
  uses: alchemaxinc/composite-toolbox/create-pr@v1.21.0
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
| `files`          | Files to commit (space-separated)                                                 | :white_check_mark: |
| `commit-message` | Commit message                                                                    | :white_check_mark: |
| `pr-title`       | Pull request title                                                                | :white_check_mark: |
| `pr-body`        | Pull request body (Markdown supported)                                            | :white_check_mark: |

## :warning: Prerequisites

- The repository must be checked out before you use this action.
- Git must have user credentials set.
- The token must have permission to create branches and pull requests.
- The GitHub CLI must be available in the runner environment.
