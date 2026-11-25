# Composite Toolbox

![Composite Toolbox](./docs/logo.png)

A helper toolbox of composite GitHub Actions and reusable workflows that you
can compose into your own workflows. Contributions and use by other projects
are welcome.

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
`uses: alchemaxinc/composite-toolbox/.github/workflows/<name>.yml@v1.26.1`. The
calling workflow owns the trigger (for example, a `pull_request` event or a
`schedule`). Secrets are passed by name; the workflows do not use
`secrets: inherit`.

A called workflow reports its status check as `<calling job> / <called job>`.
A check that branch protection requires by name must therefore be a job in
the calling workflow. Keep a small gate job with that name next to the job that
calls the shared workflow, as the examples below show.

Every job in these workflows sets least-privilege `permissions` and a
`timeout-minutes`. Writes go through a GitHub App token, so the caller's `GITHUB_TOKEN` needs no more
than `contents: read`. The calling workflow owns `concurrency`.

- **[prod-pr](./.github/workflows/prod-pr.yml)** - Open or reuse the pull request that promotes `develop` into `main` and enable auto-merge on it, with the [create-production-pr](./create-production-pr/) action.
- **[backmerge](./.github/workflows/backmerge.yml)** - Merge `main` into `develop` and push. On a merge conflict, open a pull request from `main` into `develop` instead of failing silently.
- **[pr-title-lint](./.github/workflows/pr-title-lint.yml)** - Lint the pull request title against Conventional Commits with a pinned commitlint and one shared config (Git merge titles ignored, lines up to 150 characters).
- **[rust-ci](./.github/workflows/rust-ci.yml)** - Check a Cargo workspace: rustfmt (on nightly by default, for unstable `.rustfmt.toml` options), clippy with `-D warnings`, the tests with cargo-nextest, and optionally a build or check per cross target, a static-link check and a Prettier check.
- **[rust-release](./.github/workflows/rust-release.yml)** - Release a Cargo workspace: semantic-release creates a draft, each target builds the binaries with a `.sha256` checksum, a separate job uploads them so the App token never meets the build, and the draft is published. A rerun resumes an unpublished draft. Optionally it sends a `repository_dispatch` of a given event type on a stable release, and it merges `main` back into `develop`.

Example: the weekly production pull request. `prod-pr` and `backmerge` both
take the GitHub App client ID as the `app-client-id` input and its private
key as the `app-private-key` secret.

```yaml
name: Automatic Production PR
on:
  schedule:
    - cron: '0 3 * * 1'
  workflow_dispatch:

jobs:
  prod-pr:
    uses: alchemaxinc/composite-toolbox/.github/workflows/prod-pr.yml@v1.26.1
    with:
      app-client-id: ${{ vars.APP_CLIENT_ID }}
    secrets:
      app-private-key: ${{ secrets.APP_PRIVATE_KEY }}
```

Example: the pull request title lint. The `pr-title` gate keeps the
check name that branch protection requires.

```yaml
name: PR Title Lint
on:
  pull_request:
    types: [opened, edited, reopened, synchronize]

permissions: {}

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  lint:
    uses: alchemaxinc/composite-toolbox/.github/workflows/pr-title-lint.yml@v1.26.1

  pr-title:
    name: pr-title
    if: always()
    needs: [lint]
    runs-on: ubuntu-latest
    timeout-minutes: 5
    steps:
      - name: Require the title lint to pass
        env:
          RESULT: ${{ needs.lint.result }}
        run: '[ "$RESULT" = "success" ]'
```

Example: Rust CI with a static musl build, a repository-specific extra job,
and the `required-checks` gate. The gate fails when any job it needs failed or was
cancelled.

```yaml
name: CI
on:
  pull_request:
  push:
    branches: [develop] # saves the Cargo caches that pull requests restore

permissions:
  contents: read

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  rust:
    uses: alchemaxinc/composite-toolbox/.github/workflows/rust-ci.yml@v1.26.1
    with:
      targets: x86_64-unknown-linux-musl
      static-binaries: my-binary
      prettier-version: '3.9.9'

  extra-check:
    runs-on: ubuntu-latest
    timeout-minutes: 20
    steps:
      - uses: actions/checkout@v7
      - run: make check

  required-checks:
    name: required-checks
    if: always()
    needs: [rust, extra-check]
    runs-on: ubuntu-latest
    timeout-minutes: 5
    steps:
      - name: Require every job to pass or be skipped
        env:
          RESULTS: ${{ join(needs.*.result, ' ') }}
        run: |
          for result in $RESULTS; do
            if [ "$result" = "failure" ] || [ "$result" = "cancelled" ]; then
              echo "::error::A required job ended with $result"
              exit 1
            fi
          done
```

Example: the release. The calling repository's `.releaserc.json` must set
`draftRelease: true` on `@semantic-release/github`.

```yaml
name: Semantic Versioning and Release
on:
  push:
    branches: [main, develop]
  workflow_dispatch:

permissions:
  contents: read

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: false

jobs:
  release:
    uses: alchemaxinc/composite-toolbox/.github/workflows/rust-release.yml@v1.26.1
    with:
      app-client-id: ${{ vars.APP_CLIENT_ID }}
      app-slug: my-github-app
      binaries: my-binary
      targets: aarch64-unknown-linux-gnu x86_64-unknown-linux-musl
      release-tag-env: MY_RELEASE_TAG
      dispatch-repository: my-downstream-repo # optional
      dispatch-event-type: release-published
    secrets:
      app-private-key: ${{ secrets.APP_PRIVATE_KEY }}
```

## 🤝 Contributing

Contributions are welcome. If you have an idea for a new composite action
that other projects can use, read the [contributing guide](./CONTRIBUTING.md).
Then open a pull request.

## 📄 License

This project is available under the [MIT License](./LICENSE).
