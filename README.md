# Composite Toolbox

![Composite Toolbox](./docs/logo.png)

This repository is a collection of reusable GitHub Actions. Each action is a
composite action you can add to your own workflows to handle a common task.

## 🎯 Purpose

This repository is a helper toolbox for
[alchemaxinc/update-deps](https://github.com/alchemaxinc/update-deps).
Contributions and use by other projects are welcome.

## 📦 Available Actions

- **[check-changes](./check-changes/)** - Check if specified files have changes in the working directory
- **[check-existing-pr](./check-existing-pr/)** - Check whether an open pull request with exact title already exists
- **[checkout-and-setup](./checkout-and-setup/)** - Common repository checkout and Git configuration in one step
- **[create-pr](./create-pr/)** - Create a new branch, commit files, and open a pull request
- **[create-production-pr](./create-production-pr/)** - Open a pull request that promotes one branch into another, with duplicate detection and optional auto-merge
- **[detect-changed-files](./detect-changed-files/)** - Check if files matching given pathspecs changed between a base ref and HEAD
- **[find-or-create-issue](./find-or-create-issue/)** - Idempotently find an existing issue by title, or create a new one
- **[merge-pr](./merge-pr/)** - Enable auto-merge on a pull request
- **[semantic-release](./semantic-release/)** - Run semantic-release with caching and optional backmerge support
- **[sync-action-tag-in-docs](./sync-action-tag-in-docs/)** - Update GitHub action tags in documentation files to match the current version
- **[sync-tags-in-docs](./sync-tags-in-docs/)** - _Deprecated, use sync-action-tag-in-docs instead_
- **[sync-terraform-version-in-docs](./sync-terraform-version-in-docs/)** - Check or update a Terraform provider version constraint across documentation files
- **[validate-merge-method](./validate-merge-method/)** - Validate merge-method input (`merge`, `squash`, `rebase`)

## 🔁 Reusable Workflows

These workflows are called as jobs with
`uses: alchemaxinc/composite-toolbox/.github/workflows/<name>.yml@v1.25.0`. The
calling workflow owns the trigger (for example, a `pull_request` event or a
`schedule`). Secrets are passed by name; the workflows do not use
`secrets: inherit`. Third-party actions inside them are pinned to commit SHAs.

- **[ci-passed](./.github/workflows/ci-passed.yml)** - Gate job for branch protection. Pass `toJSON(needs)` as `results`; it fails when a listed job failed or was cancelled and passes when they all succeeded or were skipped.
- **[pr-title-lint](./.github/workflows/pr-title-lint.yml)** - Lint the pull request title against Conventional Commits with the shared commitlint config (header up to 150 characters) and a pinned commitlint version.
- **[prod-pr](./.github/workflows/prod-pr.yml)** - Open or reuse the pull request that promotes `develop` into `main` and enable auto-merge on it, with the [create-production-pr](./create-production-pr/) action.
- **[backmerge](./.github/workflows/backmerge.yml)** - Merge `main` into `develop` and push. On a merge conflict, open a pull request from `main` into `develop` instead of failing silently.

Example: a CI gate and a PR title check.

```yaml
name: CI
on:
  pull_request:
    types: [opened, edited, reopened, synchronize]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: make build

  lint-pr-title:
    uses: alchemaxinc/composite-toolbox/.github/workflows/pr-title-lint.yml@v1.25.0

  ci-passed:
    if: always()
    needs: [build]
    uses: alchemaxinc/composite-toolbox/.github/workflows/ci-passed.yml@v1.25.0
    with:
      results: ${{ toJSON(needs) }}
```

Example: the weekly production pull request. `prod-pr` and `backmerge` both
take the GitHub App client ID as the `app-client-id` input and its private
key as the `app-private-key` secret.

```yaml
name: Automatic Production PR
on:
  schedule:
    - cron: '30 1 * * 0' # Sunday 01:30 UTC, after the dependency bumps
  workflow_dispatch:

jobs:
  prod-pr:
    uses: alchemaxinc/composite-toolbox/.github/workflows/prod-pr.yml@v1.25.0
    with:
      app-client-id: ${{ vars.HOUSEKEEPING_BOT_APP_ID }}
    secrets:
      app-private-key: ${{ secrets.HOUSEKEEPING_BOT_PRIVATE_KEY }}
```

## 🤝 Contributing

Contributions are welcome. If you have an idea for a new composite action
that other projects can use, read the [contributing guide](./CONTRIBUTING.md).
Then open a pull request.

## 📄 License

This project is available under the [MIT License](./LICENSE).
