#!/bin/sh
set -e

echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region us-east-1 \
| docker login --username AWS --password-stdin 061039798341.dkr.ecr.us-east-1.amazonaws.com

echo "Building Docker image..."
docker build -t medusa-app .

echo "Tagging Docker image..."
docker tag medusa-app:latest 061039798341.dkr.ecr.us-east-1.amazonaws.com/medusa-app:latest

echo "Pushing image to Amazon ECR..."
docker push 061039798341.dkr.ecr.us-east-1.amazonaws.com/medusa-app:latest

echo "Done. Image pushed successfully."