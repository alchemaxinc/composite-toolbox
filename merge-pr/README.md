# Enable Pull Request Automerge

A GitHub action to enable auto-merge on a pull request with built-in protection against race conditions with required status checks.

## Problem This Solves

By default, GitHub's `gh pr merge --auto` can execute too quickly, before GitHub has registered that required status checks will run on the pull request. This causes the PR to merge before required checks can be executed, bypassing your CI/CD pipeline and branch protection rules.

This action solves this by waiting for GitHub to detect and register required status checks before enabling auto-merge.

## Usage

```yaml
- name: Enable automerge
  uses: alchemaxinc/composite-toolbox/merge-pr@main
  with:
    pull-request-number: ${{ github.event.pull_request.number }}
    merge-method: squash
```

## Inputs

| Input                 | Description                                                                 | Default                    | Required |
| --------------------- | --------------------------------------------------------------------------- | -------------------------- | -------- |
| `token`               | GITHUB_TOKEN or a `repo` scoped Personal Access Token (PAT)                 | `${{ github.token }}`      | No       |
| `repository`          | The target GitHub repository containing the pull request                    | `${{ github.repository }}` | No       |
| `pull-request-number` | The number of the target pull request                                       | N/A                        | Yes      |
| `merge-method`        | The merge method to use. Options: `merge`, `rebase`, or `squash`            | `merge`                    | No       |
| `wait-for-checks`     | Wait for required status checks to be registered before enabling auto-merge | `true`                     | No       |
| `check-timeout`       | Maximum time in seconds to wait for required checks to appear               | `60`                       | No       |
| `poll-interval`       | Time in seconds to wait between polling attempts                            | `2`                        | No       |

## How It Works

1. **Waits for Status Checks**: If `wait-for-checks` is enabled (default), the action polls the GitHub API to check if required status checks have been registered on the PR
2. **Configurable Timeout**: You can adjust `check-timeout` and `poll-interval` based on your CI/CD setup:
   - Fast CI pipelines: Use lower values (e.g., `check-timeout: 30`, `poll-interval: 1`)
   - Slow CI pipelines: Use higher values (e.g., `check-timeout: 120`, `poll-interval: 5`)
3. **Enables Auto-Merge**: Once checks are detected (or timeout is reached with a warning), the action enables auto-merge with your specified method

## Example Workflows

### Basic Usage

```yaml
name: Auto-merge PRs

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  automerge:
    runs-on: ubuntu-latest
    steps:
      - uses: alchemaxinc/composite-toolbox/merge-pr@main
        with:
          pull-request-number: ${{ github.event.pull_request.number }}
```

### With Custom Timeout

```yaml
- uses: alchemaxinc/composite-toolbox/merge-pr@main
  with:
    pull-request-number: ${{ github.event.pull_request.number }}
    merge-method: squash
    check-timeout: 120
    poll-interval: 5
```

### Skip Waiting for Checks

```yaml
- uses: alchemaxinc/composite-toolbox/merge-pr@main
  with:
    pull-request-number: ${{ github.event.pull_request.number }}
    wait-for-checks: false
```

## Troubleshooting

### "Timeout waiting for required checks"

If you see this warning, it means the action waited for the specified timeout but GitHub hadn't registered the required checks yet. This can happen if:

- Your CI/CD pipeline takes longer to start
- GitHub is experiencing delays in registering checks

Solutions:

- Increase `check-timeout` value
- Verify that your repository's branch protection rules actually require status checks
- Check your GitHub Actions workflow configuration

### Auto-merge not enabled

Ensure that:

- You have push permissions on the repository
- The pull request is open (not already merged or closed)
- The token has appropriate scopes (`repo` scope for PAT, or default `GITHUB_TOKEN`)
- Auto-merge is enabled in your repository settings

## Notes

- The action uses `gh` CLI which is pre-installed in GitHub Actions runners
- Requires write access to the pull request repository
- GitHub's `statusCheckRollup` API is used to detect required checks, which includes all check runs and status checks
