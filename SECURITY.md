# Security Policy

## Reporting a Vulnerability

If you find a security vulnerability in this repository, report it
privately instead of opening a public issue.

Use GitHub's
[private vulnerability reporting](https://github.com/alchemaxinc/composite-toolbox/security/advisories/new)
feature for this repository. Include:

- A description of the vulnerability and its potential impact.
- Steps to reproduce it, including an affected action and version.
- Any suggested fix, if you have one.

We acknowledge new reports within 5 business days.

## Supported Versions

Only the latest major version (the current `v1` floating tag) receives
security fixes. Pin your workflows to the latest released tag and update
promptly when a fix is published.

## Scope

This repository publishes composite GitHub Actions. In scope for security
reports:

- Shell injection or code execution through action inputs.
- Token or credential leakage.
- Logic that could let an action push, merge, or tag unintended commits.

Out of scope: vulnerabilities in the `actions/*`, `gh`, or other third-party
tools this repository depends on. Report those to their own maintainers.
