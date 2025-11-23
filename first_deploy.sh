#!/bin/bash
set -e

echo "=== Phase 0: Setting up Terraform Backend ==="

# Create S3 bucket
aws s3 mb s3://eloquent-ai-app-tfstate --region us-east-1

# Enable S3 bucket versioning
aws s3api put-bucket-versioning \
    --bucket eloquent-ai-app-tfstate \
    --versioning-configuration Status=Enabled \

# Create DynamoDB table for Terraform state locking
aws dynamodb create-table \
    --table-name eloquent-ai-app-tfstate-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region us-east-1 \


# Verify S3 bucket
aws s3 ls s3://eloquent-ai-app-tfstate/

echo "=== Phase 1: Creating ECR ==="
cd terraform
terraform state list || echo "No existing state found, proceeding..."
terraform init
terraform apply -target=aws_ecr_repository.app -auto-approve

ECR_URL=$(terraform output -raw ecr_repository_url)
echo "ECR criado: $ECR_URL"

echo "=== Phase 2: Image's Build and Push ==="
cd ..
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL
docker build -t $ECR_URL:latest .
docker push $ECR_URL:latest

echo "=== Phase 3: Complete Terraform Creation ==="
cd terraform
terraform apply -auto-approve