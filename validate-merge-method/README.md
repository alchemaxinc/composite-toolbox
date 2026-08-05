# Validate Merge Method ✅

This action checks that a given merge method is one of the supported
values: `merge`, `squash`, or `rebase`.

## :rocket: Usage

```yaml
name: Validate Merge Method
on:
  workflow_dispatch:

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - name: Validate merge method input
        uses: alchemaxinc/composite-toolbox/validate-merge-method@v1.22.0
        with:
          merge-method: 'squash'
```

## :gear: Inputs

| Input          | Description                                               | Required           |
| -------------- | --------------------------------------------------------- | ------------------ |
| `merge-method` | Merge method to validate (`merge`, `squash`, or `rebase`) | :white_check_mark: |
