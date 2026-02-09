# Checkout and Setup :wrench:

This GitHub Action performs common repository checkout and Git configuration tasks in a single step.

> [!IMPORTANT]  
> This action combines checkout and Git configuration, eliminating the need to set up these common steps separately in your workflows.

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
        uses: alchemaxinc/composite-toolbox/checkout-and-setup@v1
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
        uses: alchemaxinc/composite-toolbox/checkout-and-setup@v1
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          app-slug: my-github-app

      - name: Make changes as bot
        run: |
          echo "Repository is configured with app bot credentials"
          # Commits will be attributed to my-github-app[bot]
```

## :gear: Inputs

| Input      | Description                                                                                     | Required | Default               |
| ---------- | ----------------------------------------------------------------------------------------------- | -------- | --------------------- |
| `token`    | GitHub token for authentication                                                                 | :x:      | `${{ github.token }}` |
| `app-slug` | GitHub App slug (e.g., `my-app`). If provided, configures git as the app bot instead of default | :x:      | `''`                  |

## :warning: Prerequisites

- The workflow must have appropriate permissions to access the repository
- The token must have sufficient permissions for the intended operations
