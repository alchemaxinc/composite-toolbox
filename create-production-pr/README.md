# Create Production PR :ship:

This action opens a pull request that promotes one branch into another, for
example `develop` into `main`. If the two branches differ, the action opens
the pull request. It reuses an existing open pull request with the same
title and head branch instead of creating a duplicate. It can also enable
auto-merge on the result.

> [!IMPORTANT]  
> Check out the head branch (for example `develop`) with full history
> (`fetch-depth: 0`) before this action runs. It does not check out the
> repository itself.

## :rocket: Usage

```yaml
name: Automatic Production PR
on:
  schedule:
    - cron: '0 0 * * 0' # Runs every Sunday at midnight UTC
  workflow_dispatch:

permissions:
  contents: write
  pull-requests: write

jobs:
  create-prod-pr:
    runs-on: ubuntu-latest
    steps:
      - name: Create temporary GitHub App Token
        id: app
        uses: actions/create-github-app-token@v3
        with:
          owner: ${{ github.repository_owner }}
          client-id: ${{ vars.HOUSEKEEPING_BOT_APP_ID }}
          private-key: ${{ secrets.HOUSEKEEPING_BOT_PRIVATE_KEY }}

      - name: Checkout repository
        uses: actions/checkout@v7
        with:
          ref: develop
          fetch-depth: 0
          token: ${{ steps.app.outputs.token }}

      - name: Create production PR
        uses: alchemaxinc/composite-toolbox/create-production-pr@v1.23.0
        with:
          token: ${{ steps.app.outputs.token }}
          pr-title: 'chore: to prod'
          pr-body: 'Automated weekly production release from `develop` to `main`.'
```

## :gear: Inputs

| Input               | Description                                                              | Required           | Default            |
| ------------------- | ------------------------------------------------------------------------ | ------------------ | ------------------ |
| `token`             | GitHub token used for git fetch, pull request, and auto-merge operations | :white_check_mark: | -                  |
| `base-branch`       | Branch to open the pull request against                                  | :x:                | `'main'`           |
| `head-branch`       | Branch to promote into the base branch (must already be checked out)     | :x:                | `'develop'`        |
| `pr-title`          | Title of the pull request                                                | :x:                | `'chore: to prod'` |
| `pr-body`           | The Markdown-supported body for the pull request                         | :x:                | `''`               |
| `enable-auto-merge` | Whether to enable auto-merge on the pull request (`true`/`false`)        | :x:                | `'true'`           |
| `merge-method`      | Merge method to use for auto-merge (`merge`, `squash`, or `rebase`)      | :x:                | `'merge'`          |

## :outbox_tray: Outputs

| Output        | Description                                                                                  |
| ------------- | -------------------------------------------------------------------------------------------- |
| `has_changes` | Whether the head branch has changes not yet in the base branch (`true`/`false`)              |
| `pr_number`   | Number of the created or reused pull request. If there are no changes, this output is empty. |

## :warning: Prerequisites

- Check out the head branch with full history (`fetch-depth: 0`) before this
  action runs. This makes the base branch's history reachable once fetched.
- The token must have permission to fetch, read pull requests, and create
  pull requests. When `enable-auto-merge` is `true`, the token must also have
  permission to update pull requests.
- When `enable-auto-merge` is `true`, the repository must have auto-merge
  enabled (**Settings → General → Allow auto-merge**).
- The GitHub CLI must be available in the runner environment.

## :bulb: How It Works

This action composes three other toolbox actions:

- [detect-changed-files](../detect-changed-files/) to check whether the head
  branch has commits the base branch does not.
- [check-existing-pr](../check-existing-pr/) to avoid opening a duplicate
  pull request on repeat runs.
- [merge-pr](../merge-pr/) to enable auto-merge.
