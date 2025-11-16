#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG="${IMAGE_TAG:-povray:test}"
SCENE_FILE="test/sample.pov"
OUTPUT_FILE="test/output.png"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TEST_DIR="${REPO_ROOT}/test"
SCENE_BASENAME="$(basename "${SCENE_FILE}")"
OUTPUT_BASENAME="$(basename "${OUTPUT_FILE}")"

cd "${REPO_ROOT}"

echo "Building image ${IMAGE_TAG}..."
docker build -t "${IMAGE_TAG}" .

echo "Rendering sample scene into ${OUTPUT_FILE}..."
rm -f "${OUTPUT_FILE}"
docker run --rm \
  -v "${TEST_DIR}":/scenes \
  -w /scenes \
  "${IMAGE_TAG}" \
  +I"${SCENE_BASENAME}" \
  +O"${OUTPUT_BASENAME}" \
  +FN +W320 +H240 -D

echo "Rendered image written to ${OUTPUT_FILE}"
