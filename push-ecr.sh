#!/bin/sh
set -e

IMAGE_TAG="v3"
ECR_REPO="061039798341.dkr.ecr.us-east-1.amazonaws.com/medusa-app"

echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region us-east-1 \
| docker login --username AWS --password-stdin 061039798341.dkr.ecr.us-east-1.amazonaws.com

echo "Building and pushing ARM64 image..."
docker buildx build \
  --platform linux/arm64 \
  -t ${ECR_REPO}:${IMAGE_TAG} \
  --push .

echo "Done. Image pushed successfully: ${ECR_REPO}:${IMAGE_TAG}"
