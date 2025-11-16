#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG="${IMAGE_TAG:-povray:test}"
OUTPUT_FILE="test/output.png"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${REPO_ROOT}"

echo "Building image ${IMAGE_TAG}..."
docker build -t "${IMAGE_TAG}" .

echo "Rendering sample scene via stdin/stdout..."
cat test/sample.pov | docker run --rm -i "${IMAGE_TAG}" \
  +I- +O- +FN +W320 +H240 > "${OUTPUT_FILE}"

echo "Rendered image written to ${OUTPUT_FILE}"
