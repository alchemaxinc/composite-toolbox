# Sync Terraform Provider Version :package:

This action keeps a Terraform provider version constraint (a plain `~> N`
major-version pin) in sync across a set of files, such as a `README.md` and
an `examples/provider/provider.tf` that both document the same
`required_providers` block.

> [!IMPORTANT]
> This action only understands a plain `~> N` constraint (major version
> only, for example `~> 2`). It fails with an error if a file uses a
> different constraint shape (`~> 2.1`, `>= 2.0, < 3.0`, `= 2.1.0`, and so
> on), or if a file does not contain exactly one matching
> `source = "..."` / `version = "..."` pair.

## :rocket: Usage

Check that files agree (for example, in a pull request lint job):

```yaml
- name: Check provider version constraints are in sync
  uses: alchemaxinc/composite-toolbox/sync-terraform-version-in-docs@v1.23.0
  with:
    mode: 'check'
    provider-source: 'alchemaxinc/balena'
    files: 'README.md examples/provider/provider.tf'
```

Update files to a released version (for example, after a release):

```yaml
- name: Sync provider version examples
  uses: alchemaxinc/composite-toolbox/sync-terraform-version-in-docs@v1.23.0
  with:
    mode: 'set'
    provider-source: 'alchemaxinc/balena'
    files: 'README.md examples/provider/provider.tf'
    version: '2.0.0'
```

## :gear: Inputs

| Input             | Description                                                              | Required           | Default |
| ----------------- | ------------------------------------------------------------------------ | ------------------ | ------- |
| `mode`            | `check` (fail on disagreement) or `set` (rewrite to a new major version) | :white_check_mark: | -       |
| `provider-source` | Provider source address to match, for example `alchemaxinc/balena`       | :white_check_mark: | -       |
| `files`           | Space-separated list of files to check or update                         | :white_check_mark: | -       |
| `version`         | Full semantic version to pin to, for example `2.0.0`. Required for `set` | :x:                | `''`    |

## :outbox_tray: Outputs

| Output          | Description                                                       |
| --------------- | ----------------------------------------------------------------- |
| `files_updated` | Space-separated list of files that were updated (`set` mode only) |

## :warning: Notes

- This action does not commit or push changes. Pair it with
  [`create-pr`](../create-pr/) or your own `git commit`/`git push` step.
- Each file must contain exactly one
  `source = "<provider-source>"` line immediately followed on the next line
  by a `version = "..."` line. The action fails loudly instead of guessing
  if it finds zero or more than one match.
- This action uses `perl` for multi-line matching. Run it on a Linux
  runner, for example `ubuntu-latest`.
