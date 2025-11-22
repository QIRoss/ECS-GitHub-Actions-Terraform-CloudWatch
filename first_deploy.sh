#!/bin/bash
set -e

echo "=== Fase 1: Criando ECR ==="
cd terraform
terraform init
terraform apply -target=aws_ecr_repository.app -auto-approve

ECR_URL=$(terraform output -raw ecr_repository_url)
echo "ECR criado: $ECR_URL"

echo "=== Fase 2: Build e Push da Imagem ==="
cd ..
aws --profile qiross ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL
docker build -t $ECR_URL:latest .
docker push $ECR_URL:latest

echo "=== Fase 3: Criando Resto da Infra ==="
cd terraform
terraform apply -auto-approve

echo "=== Deploy Completo! ==="
ALB_URL=$(terraform output -raw alb_dns_name)
echo "URL da aplicação: http://$ALB_URL"