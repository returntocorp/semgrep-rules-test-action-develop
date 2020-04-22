# [develop] semgrep-rules-test-develop action

This action runs the tests for semgrep rules repos. Runs `make test`

## Inputs

None

## Outputs

### `results`

The test results

### `exit_code`

The exit code of `make test`

### `output_dir`

The directory of STDOUT and STDERROR files. Useful for uploading artifacts

## Example usage

Put in `.github/workflows/semgrep-rules-test.yml`

```yaml

name: semgrep-rules-test

on: [push]

jobs:
  self_test:
    runs-on: ubuntu-latest
    name: run semgrep rules tests
    steps:
      - uses: actions/checkout@v2
      - name: run tests
        id: semgrep-tests
        uses: returntocorp/semgrep-rules-test-action-develop@master
      - uses: actions/upload-artifact@v1
        if: always()
        with:
          name: tests
          path: ${{ steps.semgrep-tests.outputs.output_dir }}
```
