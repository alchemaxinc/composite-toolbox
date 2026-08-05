# Checkout and Setup :wrench:

This action performs a repository checkout and a Git configuration step
together.

> [!IMPORTANT]  
> This action combines checkout and Git configuration in one step. You do not
> need to set up these steps on your own.

## :rocket: Usage

### Basic Usage

```yaml
name: Setup Repository
on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  setup:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout and setup
        uses: alchemaxinc/composite-toolbox/checkout-and-setup@v1.21.0
        with:
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Make changes
        run: |
          echo "Repository is now checked out and configured"
          # Your workflow steps here
```

### Using with GitHub App Bot

```yaml
name: Setup with App Bot
on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  setup:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout and setup as app bot
        uses: alchemaxinc/composite-toolbox/checkout-and-setup@v1.21.0
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          app-slug: my-github-app

      - name: Make changes as bot
        run: |
          echo "Repository is configured with app bot credentials"
          # Commits will be attributed to my-github-app[bot]
```

### Using with Full History

```yaml
name: Setup with Full History
on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  setup:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout with full history
        uses: alchemaxinc/composite-toolbox/checkout-and-setup@v1.21.0
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          shallow: false

      - name: Work with git history
        run: |
          echo "Full git history and tags are available"
          git log --oneline | head -10
          git tag -l
```

## :gear: Inputs

| Input      | Description                                                                                            | Required | Default               |
| ---------- | ------------------------------------------------------------------------------------------------------ | -------- | --------------------- |
| `token`    | GitHub token for authentication                                                                        | :x:      | `${{ github.token }}` |
| `app-slug` | GitHub App slug (for example, `my-app`). If provided, configures git as the app bot instead of default | :x:      | `''`                  |
| `ref`      | Git ref (branch, tag, or SHA) to check out. Defaults to `actions/checkout`'s own behavior              | :x:      | `''`                  |
| `shallow`  | If `true`, performs shallow checkout. If `false`, fetches full history with tags                       | :x:      | `'true'`              |

## :warning: Prerequisites

- The workflow must have permission to access the repository.
- The token must have enough permission for the operations you run.

## :bulb: How Git Identity Works

When no `app-slug` is given, the action resolves the git committer identity
from the token you provide:

- **GitHub App tokens** → Commits are attributed to the app's bot account (for example, `my-app[bot]`)
- **Personal Access Tokens** → Commits are attributed to the token owner
- **Default `GITHUB_TOKEN`** → Commits are attributed to `github-actions[bot]`

If the token cannot be resolved to an identity (for example, it is invalid
or expired), the step fails instead of falling back to a default identity.

When you give `app-slug`, the action sets the identity from the slug
directly.
