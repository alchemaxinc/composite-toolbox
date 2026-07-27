# Composite Toolbox

![Composite Toolbox](./docs/logo.png)

A collection of reusable GitHub Actions designed to simplify common workflow tasks. This repository serves as a toolbox of composite actions that you can easily integrate into your own workflows for convenience.

## 🎯 Purpose

This is a helper toolbox for [alchemaxinc/update-deps](https://github.com/alchemaxinc/update-deps); contributions and usage are welcome.

## 📦 Available Actions

- **[check-changes](./check-changes/)** - Check if specified files have changes in the working directory
- **[check-existing-pr](./check-existing-pr/)** - Check whether an open pull request with exact title already exists
- **[checkout-and-setup](./checkout-and-setup/)** - Common repository checkout and Git configuration in one step
- **[create-pr](./create-pr/)** - Create a new branch, commit files, and open a pull request
- **[detect-changed-files](./detect-changed-files/)** - Check if files matching given pathspecs changed between a base ref and HEAD
- **[find-or-create-issue](./find-or-create-issue/)** - Idempotently find an existing issue by title, or create a new one
- **[merge-pr](./merge-pr/)** - Enable auto-merge on a pull request
- **[semantic-release](./semantic-release/)** - Run semantic-release with caching and optional backmerge support
- **[validate-merge-method](./validate-merge-method/)** - Validate merge-method input (`merge`, `squash`, `rebase`)

## 🤝 Contributing

Contributions are welcome! If you have ideas for additional composite actions
that would be useful across multiple projects, please review the
[contributing guide](./CONTRIBUTING.md) and open a pull request.

## 📄 License

This project is available under the [MIT License](./LICENSE).
