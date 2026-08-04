# Contributing to Composite Toolbox

Thanks for your interest in improving this repository.

## What to Contribute

You can contribute bug fixes, documentation improvements, and composite
actions that other projects can use.

## Before Opening a Pull Request

- Keep each change focused on a single improvement.
- Update the documentation for any change in behavior or interface.
- Write commit messages in the
  [Conventional Commits](https://www.conventionalcommits.org/) format (for
  example, `fix: ...`, `feat: ...`, `docs: ...`). Commitlint checks this
  format.
- Run the same checks the CI lint workflow runs, before you submit the pull
  request:

  ```sh
  # Formatting
  npx prettier@3 --check .

  # Spelling (covers *.md, *.yml, and *.sh files)
  npx cspell@10

  # Commit message style (compares against origin/main)
  npx --package @commitlint/cli@21 --package @commitlint/config-conventional@21 \
    commitlint --from origin/main --to HEAD --verbose

  # Workflow and composite action YAML, plus embedded shell scripts
  # (needs actionlint: https://github.com/rhysd/actionlint, and
  # shellcheck: https://github.com/koalaman/shellcheck, on your PATH)
  actionlint
  ```

## Pull Requests

- Write a clear commit message in the Conventional Commits format.
- Describe the problem and summarize your change.
- Add an example or a README update when you add or change an action.

By contributing to this repository, you agree that the project's
[MIT License](./LICENSE) covers your contribution.
