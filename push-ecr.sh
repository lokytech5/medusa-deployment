#!/bin/sh
set -e

IMAGE_TAG="v2"
ECR_REPO="061039798341.dkr.ecr.us-east-1.amazonaws.com/medusa-app"

echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region us-east-1 \
| docker login --username AWS --password-stdin 061039798341.dkr.ecr.us-east-1.amazonaws.com

echo "Tagging tested Docker image..."
docker tag medusa-app:test ${ECR_REPO}:${IMAGE_TAG}

echo "Pushing image to Amazon ECR..."
docker push ${ECR_REPO}:${IMAGE_TAG}

echo "Done. Image pushed successfully: ${ECR_REPO}:${IMAGE_TAG}"