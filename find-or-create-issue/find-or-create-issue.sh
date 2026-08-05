#!/usr/bin/env bash
# Finds an existing issue by exact title, or creates a new one.
#
# This is the backing script for the action.yml composite action in this
# directory. Use `alchemaxinc/composite-toolbox/find-or-create-issue@v1`
# instead of calling this script directly. See that action's README for how
# to file one issue per item found at runtime, using a matrix job.
#
# Requires GH_TOKEN (or GITHUB_TOKEN) in the environment, as `gh` uses it.
# Prints the resulting issue URL to stdout. Progress goes to stderr as
# workflow annotations.
#
# Usage:
#   find-or-create-issue.sh --title TITLE --body BODY \
#     [--label LABEL] [--type TYPE] [--state open|all]
set -euo pipefail

title=""
body=""
label=""
type=""
state="open"

while [ $# -gt 0 ]; do
  case "$1" in
    --title)
      if [ $# -lt 2 ]; then
        echo "::error::find-or-create-issue.sh: --title requires a value" >&2
        exit 1
      fi
      title="$2"
      shift 2
      ;;
    --body)
      if [ $# -lt 2 ]; then
        echo "::error::find-or-create-issue.sh: --body requires a value" >&2
        exit 1
      fi
      body="$2"
      shift 2
      ;;
    --label)
      if [ $# -lt 2 ]; then
        echo "::error::find-or-create-issue.sh: --label requires a value" >&2
        exit 1
      fi
      label="$2"
      shift 2
      ;;
    --type)
      if [ $# -lt 2 ]; then
        echo "::error::find-or-create-issue.sh: --type requires a value" >&2
        exit 1
      fi
      type="$2"
      shift 2
      ;;
    --state)
      if [ $# -lt 2 ]; then
        echo "::error::find-or-create-issue.sh: --state requires a value" >&2
        exit 1
      fi
      state="$2"
      shift 2
      ;;
    *)
      echo "::error::find-or-create-issue.sh: unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if [ -z "$title" ] || [ -z "$body" ]; then
  echo "::error::find-or-create-issue.sh: --title and --body are required" >&2
  exit 1
fi

# Pass --repo explicitly instead of relying on gh inferring it from the
# current directory's git remote, so this script works even when the
# caller has not checked out the repository.
repo_args=()
[ -n "${GITHUB_REPOSITORY:-}" ] && repo_args+=(--repo "$GITHUB_REPOSITORY")

# Omit the free-text --search filter and let jq do exact matching
# instead: GitHub's search query syntax treats characters like '"' and
# ':' specially, so an unescaped title containing them could return
# zero candidates and cause a duplicate issue to be filed.
url=$(gh issue list "${repo_args[@]}" --state "$state" --limit 1000 --json title,url \
  | jq -r --arg title "$title" '[.[] | select(.title == $title)][0].url // empty')

if [ -z "$url" ]; then
  args=("${repo_args[@]}" --title "$title" --body "$body")
  [ -n "$label" ] && args+=(--label "$label")
  [ -n "$type" ] && args+=(--type "$type")
  url=$(gh issue create "${args[@]}")
  echo "::notice::Opened issue: $url" >&2
else
  echo "::notice::Reusing existing issue: $url" >&2
fi

echo "$url"
