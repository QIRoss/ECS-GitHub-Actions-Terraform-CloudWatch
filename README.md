CLONE TFVARS EXAMPLE

ECR_URL=$(cd terraform && terraform output -raw ecr_repository_url)

docker build -t $ECR_URL:latest .

docker push $(cd terraform && terraform output -raw ecr_repository_url):latest

sudo rm -rf .terraform* tfplan

```
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
```

# Criar S3 bucket
aws s3 mb s3://eloquent-ai-app-tfstate --region us-east-1 --profile qiross

# Habilitar versioning no bucket
aws s3api put-bucket-versioning \
    --bucket eloquent-ai-app-tfstate \
    --versioning-configuration Status=Enabled \
    --profile qiross

# Criar DynamoDB table para lock
aws dynamodb create-table \
    --table-name eloquent-ai-app-tfstate-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region us-east-1 \
    --profile qiross

terraform state list

# Verifique no S3
aws s3 ls s3://eloquent-ai-app-tfstate/ --profile qiross