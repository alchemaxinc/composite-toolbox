#!/usr/bin/env bash
# Resolves the git committer identity from the GH_TOKEN environment variable.
# Supports PATs, GitHub App installation tokens, and the default GITHUB_TOKEN.
#
# Usage: GH_TOKEN=<token> source configure-git-identity.sh [--global|--local]
#        Defaults to --local if no argument is provided.

set -euo pipefail

GIT_CONFIG_SCOPE="${1:---local}"

if USER_JSON=$(gh api /user 2>/dev/null); then
  GIT_USER=$(echo "$USER_JSON" | jq -r '.login')
  GIT_ID=$(echo "$USER_JSON" | jq -r '.id')
elif APP_JSON=$(gh api /app 2>/dev/null); then
  APP_SLUG=$(echo "$APP_JSON" | jq -r '.slug')
  GIT_USER="${APP_SLUG}[bot]"
  if BOT_JSON=$(gh api "/users/${APP_SLUG}%5Bbot%5D" 2>/dev/null); then
    GIT_ID=$(echo "$BOT_JSON" | jq -r '.id')
  else
    GIT_ID=$(echo "$APP_JSON" | jq -r '.id')
  fi
else
  GIT_USER="github-actions[bot]"
  GIT_ID="41898282"
fi

git config "$GIT_CONFIG_SCOPE" user.name "$GIT_USER"
git config "$GIT_CONFIG_SCOPE" user.email "${GIT_ID}+${GIT_USER}@users.noreply.github.com"
echo "::notice::Git identity configured as ${GIT_USER} (${GIT_CONFIG_SCOPE})"
