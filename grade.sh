#!/bin/bash

set -u

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
IMAGE_NAME="${IMAGE_NAME:-diagnostic}"

if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is required to grade this assignment." >&2
    exit 2
fi

echo "Building Docker image: $IMAGE_NAME"
if ! docker build --tag "$IMAGE_NAME" "$ROOT_DIR"; then
    echo "Image build failed." >&2
    exit 1
fi

echo "Running CLI tests"
if IMAGE_NAME="$IMAGE_NAME" bash "$ROOT_DIR/test.sh"; then
    echo "Grade: PASS"
    exit 0
fi

echo "Grade: FAIL" >&2
exit 1
