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
- **[detect-changed-files](./detect-changed-files/)** - Check if files matching given pathspecs changed between a base ref and HEAD
- **[find-or-create-issue](./find-or-create-issue/)** - Idempotently find an existing issue by title, or create a new one
- **[merge-pr](./merge-pr/)** - Enable auto-merge on a pull request
- **[semantic-release](./semantic-release/)** - Run semantic-release with caching and optional backmerge support
- **[sync-tags-in-docs](./sync-tags-in-docs/)** - Update GitHub action tags in documentation files to match the current version
- **[validate-merge-method](./validate-merge-method/)** - Validate merge-method input (`merge`, `squash`, `rebase`)

## 🤝 Contributing

Contributions are welcome. If you have an idea for a new composite action
that other projects can use, read the [contributing guide](./CONTRIBUTING.md).
Then open a pull request.

## 📄 License

This project is available under the [MIT License](./LICENSE).
