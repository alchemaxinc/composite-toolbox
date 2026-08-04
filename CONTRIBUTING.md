# Contributing to Composite Toolbox

Thanks for your interest in improving this repository.

## What to Contribute

Contributions are welcome for bug fixes, documentation improvements, and
composite actions that are useful across multiple projects.

## Before Opening a Pull Request

- Keep changes focused and scoped to a single improvement when possible.
- Update documentation for any behavior or interface changes.
- Use commit messages that follow the
  [Conventional Commits](https://www.conventionalcommits.org/) specification
  (for example, `fix: ...`, `feat: ...`, `docs: ...`); commit messages are
  checked with commitlint.
- Run the same checks the CI lint workflow runs before submitting:

  ```sh
  # Formatting
  npx prettier@3 --check .

  # Spelling (covers *.md, *.yml, and *.sh files)
  npx cspell@10

  # Commit message style (compares against origin/main)
  npx --package @commitlint/cli@21 --package @commitlint/config-conventional@21 \
    commitlint --from origin/main --to HEAD --verbose

  # Workflow and composite action YAML, plus embedded shell scripts
  # (requires actionlint: https://github.com/rhysd/actionlint, and
  # shellcheck: https://github.com/koalaman/shellcheck, on your PATH)
  actionlint
  ```

## Pull Requests

- Use clear commit messages that follow conventional commit style.
- Describe the problem being solved and summarize the changes made.
- Include examples or README updates when adding or changing an action.

By contributing to this repository, you agree that your contributions will be
licensed under the same [MIT License](./LICENSE) that covers the project.
