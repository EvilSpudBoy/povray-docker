#!/usr/bin/env bash
set -euo pipefail

IMAGE="${IMAGE:-povray:3.7}"
ROOT="$(pwd)"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <scene.pov> [output.png]" >&2
  exit 1
fi

SCENE="$1"
OUTPUT="${2:-output.png}"

docker run --rm \
  -v "${ROOT}":/scenes \
  -w /scenes \
  "${IMAGE}" \
  +I"${SCENE}" \
  +O"${OUTPUT}" \
  +W800 +H600 +FN
