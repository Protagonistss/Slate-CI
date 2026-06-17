#!/usr/bin/env bash
# 解析 workflow 输入，写入 GITHUB_OUTPUT（ref / ref_slug / release_tag / version / prerelease）
set -euo pipefail

: "${GITHUB_OUTPUT:?GITHUB_OUTPUT is required}"
: "${GH_EVENT_NAME:?GH_EVENT_NAME is required}"
: "${SLATE_REPO:?SLATE_REPO is required}"

if [ "$GH_EVENT_NAME" = "repository_dispatch" ]; then
  REF="${CLIENT_REF:-}"
  RELEASE_TAG="${CLIENT_RELEASE_TAG:-}"
  PRERELEASE="${CLIENT_PRERELEASE:-}"
else
  REF="${INPUT_REF:-}"
  RELEASE_TAG="${INPUT_RELEASE_TAG:-}"
  PRERELEASE="${INPUT_PRERELEASE:-}"
fi

[ -z "$REF" ] && REF="dev"
[ -z "$PRERELEASE" ] && PRERELEASE="false"

REF_SLUG="$REF"
REF_SLUG="${REF_SLUG//\//-}"
REF_SLUG="${REF_SLUG//\\/-}"
REF_SLUG="${REF_SLUG//:/-}"
REF_SLUG="${REF_SLUG//\"/-}"
REF_SLUG="${REF_SLUG//</-}"
REF_SLUG="${REF_SLUG//>/-}"
REF_SLUG="${REF_SLUG//|/-}"
REF_SLUG="${REF_SLUG//\*/-}"
REF_SLUG="${REF_SLUG//\?/-}"
while [ "${REF_SLUG#*--}" != "$REF_SLUG" ]; do REF_SLUG="${REF_SLUG//--/-}"; done
REF_SLUG="${REF_SLUG#-}"
REF_SLUG="${REF_SLUG%-}"

VERSION="${RELEASE_TAG#v}"

{
  echo "ref=$REF"
  echo "ref_slug=$REF_SLUG"
  echo "release_tag=$RELEASE_TAG"
  echo "version=$VERSION"
  echo "prerelease=$PRERELEASE"
} >> "$GITHUB_OUTPUT"

echo "Building ${REF} from ${SLATE_REPO}"
if [ -n "$RELEASE_TAG" ]; then
  echo "Will publish release: ${RELEASE_TAG}"
fi
