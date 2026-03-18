# Sync Tags in Documentation :label:

This GitHub Action updates GitHub action tags in documentation files to match the current version. It scans specified
file types for `uses: org/repo/action@vX` patterns and replaces the tag with the provided full semantic version.

> [!IMPORTANT]
> The `current-tag` input must be a full semantic version with `v` prefix (e.g., `v1.10.2`). All existing tag
> references will be replaced with this exact tag regardless of their current format (`@v1`, `@v1.2`, `@v1.2.3`).

## :rocket: Usage

```yaml
name: Update Documentation Tags
on:
  workflow_dispatch:
    inputs:
      tag:
        description: 'Tag to update to'
        required: true
        type: string

jobs:
  sync-docs:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Sync tags in documentation
        uses: alchemaxinc/composite-toolbox/sync-tags-in-docs@v1
        with:
          github-repo-path: 'alchemaxinc/my-action'
          current-tag: ${{ inputs.tag }}
```

## :gear: Inputs

| Input              | Description                                              | Required           | Default |
| ------------------ | -------------------------------------------------------- | ------------------ | ------- |
| `current-tag`      | Full semantic version tag to update to (e.g., `v1.10.2`) | :white_check_mark: | -       |
| `github-repo-path` | GitHub repository path (e.g., `alchemaxinc/update-deps`) | :white_check_mark: | -       |
| `file-extensions`  | Space-separated list of file extensions to scan          | :x:                | `.md`   |
| `folder`           | Folder to scan for files                                 | :x:                | `.`     |

## :outbox_tray: Outputs

| Output          | Description                                          |
| --------------- | ---------------------------------------------------- |
| `files_updated` | Space-separated list of file paths that were updated |

## :warning: Notes

- Matches patterns like `org/repo/action@v1`, `org/repo/action@v1.2`, `org/repo/action@v1.2.3`
- All matched references are updated to the exact `current-tag` value
- Files are updated in-place — use with a PR-creation step to commit changes
- The action will log a notice if no matching files or patterns are found
