# Semantic Release :package:

This action runs semantic-release. It caches npm dependencies. It can also
backmerge releases to keep your develop branch in sync with main.

> [!IMPORTANT]
> This action needs a `.releaserc.json` (or other semantic-release
> configuration file) in your repository root. It handles checkout and
> caching of semantic-release dependencies. It can also backmerge releases to
> your develop branch.

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
      pull-requests: write

    steps:
      - name: Run semantic-release
        uses: alchemaxinc/composite-toolbox/semantic-release@v1.22.0
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
      pull-requests: write

    steps:
      - name: Run semantic-release
        uses: alchemaxinc/composite-toolbox/semantic-release@v1.22.0
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          enable-backmerge: 'true'
          backmerge-target-branch: 'develop'
          source-branch: 'main'
          merge-strategy: 'merge'
```

## :gear: Inputs

| Input                     | Description                                                        | Required | Default               |
| ------------------------- | ------------------------------------------------------------------ | -------- | --------------------- |
| `token`                   | GitHub token for authentication                                    | :x:      | `${{ github.token }}` |
| `enable-backmerge`        | Enable backmerge from source to target branch after release        | :x:      | `false`               |
| `backmerge-target-branch` | Target branch for backmerge (only used when enable-backmerge=true) | :x:      | `develop`             |
| `source-branch`           | Source branch for semantic-release (typically main)                | :x:      | `main`                |
| `merge-strategy`          | Merge strategy for backmerge: `merge`, `squash`, or `rebase`       | :x:      | `merge`               |

## :outbox_tray: Outputs

| Output    | Description                                                                 |
| --------- | --------------------------------------------------------------------------- |
| `version` | The version of the new release (for example, `1.2.3`), empty if no release  |
| `tag`     | The git tag of the new release (for example, `v1.2.3`), empty if no release |

### Example: Using Outputs

```yaml
steps:
  - name: Run semantic-release
    id: release
    uses: alchemaxinc/composite-toolbox/semantic-release@v1.22.0
    with:
      token: ${{ secrets.GITHUB_TOKEN }}

  - name: Use release outputs
    if: steps.release.outputs.version != ''
    run: |
      echo "New version: ${{ steps.release.outputs.version }}"
      echo "New tag: ${{ steps.release.outputs.tag }}"
```

## :warning: Prerequisites

### Required Permissions

The workflow must have the following permissions:

```yaml
permissions:
  issues: write # For commenting on issues
  contents: write # For creating releases and pushing tags
  pull-requests: write # For commenting on PRs
```

### Semantic Release Configuration

Your repository must have a semantic-release configuration file, for example
`.releaserc.json`. Example:

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

This action uses semantic-release. Your commits must follow the
[Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` - New features. Triggers a minor version bump.
- `fix:` - Bug fixes. Triggers a patch version bump.
- `BREAKING CHANGE:` - Breaking changes. Triggers a major version bump.
- `chore:`, `docs:`, `style:`, `refactor:`, `test:` - No version bump.

## :bulb: Features

- **Automatic Caching**: Caches semantic-release and its plugins based on
  `package.json`, `package-lock.json`, and any `.releaserc*` file to speed up
  later runs.
- **Dynamic Git Identity**: Resolves the git committer identity from the
  provided token. Supports GitHub App tokens, PATs, and the default
  `GITHUB_TOKEN`.
- **Full Git History**: Fetches all history and tags that semantic-release
  needs.
- **Backmerge Support**: Can backmerge releases from main to develop, or to
  custom branches.
- **Flexible Configuration**: Supports custom source and target branch
  settings.

## :books: Related Actions

- [checkout-and-setup](../checkout-and-setup/) - Common repository checkout and Git configuration
- [create-pr](../create-pr/) - Create a new branch, commit files, and open a pull request
