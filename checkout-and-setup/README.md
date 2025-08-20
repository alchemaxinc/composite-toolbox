# Checkout and Setup :wrench:

This GitHub Action performs common repository checkout and Git configuration tasks in a single step.

> [!IMPORTANT]  
> This action combines checkout and Git configuration, eliminating the need to set up these common steps separately in your workflows.

## :rocket: Usage

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

## :gear: Inputs

| Input   | Description                     | Required | Default               |
| ------- | ------------------------------- | -------- | --------------------- |
| `token` | GitHub token for authentication | :x:      | `${{ github.token }}` |

## :warning: Prerequisites

- The workflow must have appropriate permissions to access the repository
- The token must have sufficient permissions for the intended operations
