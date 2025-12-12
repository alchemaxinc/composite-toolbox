````markdown
# Semantic Release :package:

This GitHub Action runs semantic-release with caching support for npm dependencies and optional backmerge functionality to keep your develop branch in sync with releases.

> [!IMPORTANT]
> This action requires a `.releaserc.json` (or other semantic-release configuration file) in your repository root. It automatically handles checkout, caching of semantic-release dependencies, and can optionally backmerge releases to your develop branch.

## :rocket: Usage

### Basic Usage

```yaml
name: Semantic Versioning and Release
on:
  push:
    branches:
      - main

jobs:
  semantic-release:
    name: Semantic Versioning and Release
    runs-on: ubuntu-latest

    permissions:
      issues: write
      contents: write
      id-token: write
      pull-requests: write

    steps:
      - name: Run semantic-release
        uses: alchemaxinc/composite-toolbox/semantic-release@v1
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
```

### With Backmerge to Develop

```yaml
name: Semantic Versioning and Release
on:
  push:
    branches:
      - main
      - develop
  workflow_dispatch:

jobs:
  semantic-release:
    name: Semantic Versioning and Release
    runs-on: ubuntu-latest

    permissions:
      issues: write
      contents: write
      id-token: write
      pull-requests: write

    steps:
      - name: Run semantic-release
        uses: alchemaxinc/composite-toolbox/semantic-release@v1
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          enable-backmerge: 'true'
          backmerge-target-branch: 'develop'
          source-branch: 'main'
```

### With Custom Cache Key

```yaml
name: Semantic Versioning and Release
on:
  push:
    branches:
      - main

jobs:
  semantic-release:
    name: Semantic Versioning and Release
    runs-on: ubuntu-latest

    permissions:
      issues: write
      contents: write
      id-token: write
      pull-requests: write

    steps:
      - name: Run semantic-release
        uses: alchemaxinc/composite-toolbox/semantic-release@v1
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          npm-cache-key: "npm-sr-${{ runner.os }}-${{ hashFiles('**/package.json') }}"
```

## :gear: Inputs

| Input                     | Description                                                        | Required | Default                                         |
| ------------------------- | ------------------------------------------------------------------ | -------- | ----------------------------------------------- |
| `token`                   | GitHub token for authentication                                    | :x:      | `${{ github.token }}`                           |
| `npm-cache-key`           | Custom cache key for npm dependencies                              | :x:      | `npm-sr-${{ runner.os }}-${{ hashFiles(...) }}` |
| `enable-backmerge`        | Enable backmerge from source to target branch after release        | :x:      | `false`                                         |
| `backmerge-target-branch` | Target branch for backmerge (only used when enable-backmerge=true) | :x:      | `develop`                                       |
| `source-branch`           | Source branch for semantic-release (typically main)                | :x:      | `main`                                          |

## :warning: Prerequisites

### Required Permissions

The workflow must have the following permissions:

```yaml
permissions:
  issues: write # For commenting on issues
  contents: write # For creating releases and pushing tags
  id-token: write # For OIDC token if needed
  pull-requests: write # For commenting on PRs
```

### Semantic Release Configuration

Your repository must have a semantic-release configuration file (e.g., `.releaserc.json`). Example:

```json
{
  "branches": ["main"],
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/github"
  ]
}
```

### Commit Message Convention

This action uses semantic-release which requires commits to follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` - New features (triggers minor version bump)
- `fix:` - Bug fixes (triggers patch version bump)
- `BREAKING CHANGE:` - Breaking changes (triggers major version bump)
- `chore:`, `docs:`, `style:`, `refactor:`, `test:` - No version bump

## :bulb: Features

- **Automatic Caching**: Caches semantic-release and its plugins to speed up subsequent runs
- **Full Git History**: Fetches all history and tags needed for semantic-release
- **Backmerge Support**: Optionally backmerges releases from main to develop (or custom branches)
- **Customizable**: Supports custom cache keys and branch configurations

## :books: Related Actions

- [checkout-and-setup](../checkout-and-setup/) - Common repository checkout and Git configuration
- [create-pr](../create-pr/) - Create a new branch, commit files, and open a pull request
````
