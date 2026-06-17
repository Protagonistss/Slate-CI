#!/usr/bin/env bash
# GitHub Release 会自动附加 Source code 压缩包，本仓库无应用源码，发布后删除
set -euo pipefail

: "${TAG:?TAG is required}"
: "${GH_TOKEN:?GH_TOKEN is required}"
: "${GITHUB_REPOSITORY:?GITHUB_REPOSITORY is required}"

gh release view "$TAG" --repo "$GITHUB_REPOSITORY" --json assets \
  --jq '.assets[] | select(.name | startswith("Source code")) | .id' \
  | while read -r asset_id; do
      if [ -n "$asset_id" ]; then
        echo "Deleting release asset ${asset_id}"
        gh api --method DELETE \
          "/repos/${GITHUB_REPOSITORY}/releases/assets/${asset_id}"
      fi
    done
