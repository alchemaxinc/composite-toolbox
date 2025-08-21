# Sync Tags in Documentation :label:

This GitHub Action automatically updates GitHub action tags in documentation files to match the current version. It
scans specified file types for repository usage patterns and updates them to use the latest semantic version tag.

> [!IMPORTANT]  
> This action requires semantic versioning tags (v1, v1.0, v1.0.0) and will fail if the input tag doesn't follow this
> pattern.

## :rocket: Usage

```yaml
name: Update Documentation Tags
on:
  release:
    types: [published]

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
          current-tag: ${{ github.event.release.tag_name }}
          folder: 'docs'
          file-extensions: '.md .txt'
```

## :gear: Inputs

| Input              | Description                                                       | Required           | Default |
| ------------------ | ----------------------------------------------------------------- | ------------------ | ------- |
| `current-tag`      | Current GitHub tag to update to (must follow semantic versioning) | :white_check_mark: | -       |
| `github-repo-path` | GitHub repository path (e.g., "alchemaxinc/update-deps")          | :white_check_mark: | -       |
| `file-extensions`  | Space-separated list of file extensions to scan                   | :x:                | `.md`   |
| `folder`           | Folder to scan for files (defaults to repository root)            | :x:                | `.`     |

## :outbox_tray: Outputs

| Output          | Description                       |
| --------------- | --------------------------------- |
| `files_updated` | Number of files that were updated |

## :warning: Notes

- The action looks for patterns like `repo-path/folder@version` in your documentation
- It maintains the same version format precision as found in the existing documentation
- Files are updated in-place, so make sure to commit changes if needed
- The action will warn if no matching files or patterns are found
