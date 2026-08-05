#!/usr/bin/env python3
"""Run ShellCheck against the run: blocks of composite action.yml files.

actionlint only understands GitHub Actions workflow syntax, so it cannot
parse standalone composite action.yml files (see CONTRIBUTING.md). This
script extracts each bash "run:" step from every action.yml in the repo
and pipes it through shellcheck, so the shell embedded in composite
actions gets the same coverage as the shell embedded in workflow files.
"""

from __future__ import annotations

import glob
import subprocess
import sys
import tempfile
from pathlib import Path

import yaml


def is_bash_step(step: dict) -> bool:
    shell = step.get("shell", "bash")
    return isinstance(shell, str) and shell.split()[0] == "bash"


def main() -> int:
    action_files = sorted(glob.glob("*/action.yml"))
    if not action_files:
        print("No action.yml files found.")
        return 0

    failures = 0
    for action_path in action_files:
        with open(action_path, encoding="utf-8") as f:
            data = yaml.safe_load(f)

        steps = ((data or {}).get("runs") or {}).get("steps") or []
        for index, step in enumerate(steps):
            script = step.get("run")
            if not script or not is_bash_step(step):
                continue

            name = step.get("name", f"step {index}")
            with tempfile.NamedTemporaryFile(
                "w", suffix=".sh", delete=False, encoding="utf-8"
            ) as tmp:
                tmp.write("#!/usr/bin/env bash\n")
                tmp.write(script)
                tmp_path = tmp.name

            try:
                result = subprocess.run(
                    ["shellcheck", tmp_path], capture_output=True, text=True
                )
            finally:
                Path(tmp_path).unlink(missing_ok=True)

            if result.returncode != 0:
                failures += 1
                print(f"::group::{action_path} - {name}")
                print(result.stdout.replace(tmp_path, action_path))
                print(result.stderr.replace(tmp_path, action_path))
                print("::endgroup::")

    if failures:
        print(f"ShellCheck found issues in {failures} step(s).", file=sys.stderr)
        return 1

    print(
        f"ShellCheck passed for all bash steps in {len(action_files)} action.yml file(s)."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
