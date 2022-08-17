#!/bin/bash -eu
IMAGE_TAG=${1:-latest}

echo "Building image..."
IMAGE_TAG=${IMAGE_TAG} docker compose build

echo "Pushing image..."
IMAGE_TAG=${IMAGE_TAG} docker compose push

echo "Done!"
