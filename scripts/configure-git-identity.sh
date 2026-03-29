#!/usr/bin/env bash
# Resolves the git committer identity from the GH_TOKEN environment variable.
# Supports PATs, GitHub App installation tokens, and the default GITHUB_TOKEN.
#
# Usage: GH_TOKEN=<token> source configure-git-identity.sh [--global|--local]
#        Defaults to --local if no argument is provided.

set -euo pipefail

GIT_CONFIG_SCOPE="${1:---local}"

if USER_JSON=$(gh api /user 2>/dev/null); then
  # PAT or fine-grained token
  GIT_USER=$(echo "$USER_JSON" | jq -r '.login')
  GIT_ID=$(echo "$USER_JSON" | jq -r '.id')
elif VIEWER_JSON=$(gh api graphql -f query='{ viewer { login databaseId } }' 2>/dev/null); then
  # App installation token or default GITHUB_TOKEN: REST /user returns 403
  # for these token types, but GraphQL viewer query resolves the bot identity.
  GIT_USER=$(echo "$VIEWER_JSON" | jq -r '.data.viewer.login')
  GIT_ID=$(echo "$VIEWER_JSON" | jq -r '.data.viewer.databaseId')
else
  GIT_USER="github-actions[bot]"
  GIT_ID="41898282"
fi

git config "$GIT_CONFIG_SCOPE" user.name "$GIT_USER"
git config "$GIT_CONFIG_SCOPE" user.email "${GIT_ID}+${GIT_USER}@users.noreply.github.com"
echo "::notice::Git identity configured as ${GIT_USER} (${GIT_CONFIG_SCOPE})"
