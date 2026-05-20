# deploy.ps1 - Déploiement Le Café Stack
param(
    [string]$Environment = "development",
    [int]$RetentionDays = 30,
    [int]$Timeout = 30
)

$EP = "http://localhost:4566"
$StackName = "lecafe-stack"

Write-Host "=== Déploiement Le Café ===" -ForegroundColor Green

# Configurer AWS pour LocalStack
$env:AWS_ACCESS_KEY_ID = "test"
$env:AWS_SECRET_ACCESS_KEY = "test"
$env:AWS_DEFAULT_REGION = "us-east-1"

# Valider
Write-Host "Validation du template..." -ForegroundColor Yellow
aws --endpoint-url $EP cloudformation validate-template --template-body "file://lecafe-stack.yaml"

if ($LASTEXITCODE -ne 0) { exit 1 }

# Déployer
Write-Host "Déploiement du stack..." -ForegroundColor Yellow
aws --endpoint-url $EP cloudformation create-stack --stack-name $StackName --template-body "file://lecafe-stack.yaml" --parameters ParameterKey=EnvironmentName,ParameterValue=$Environment ParameterKey=LogRetentionDays,ParameterValue=$RetentionDays ParameterKey=OrderQueueVisibilityTimeout,ParameterValue=$Timeout --capabilities CAPABILITY_NAMED_IAM 2>$null

if ($LASTEXITCODE -eq 255) {
    Write-Host "Stack existe, mise à jour..." -ForegroundColor Yellow
    aws --endpoint-url $EP cloudformation update-stack --stack-name $StackName --template-body "file://lecafe-stack.yaml" --parameters ParameterKey=EnvironmentName,ParameterValue=$Environment ParameterKey=LogRetentionDays,ParameterValue=$RetentionDays ParameterKey=OrderQueueVisibilityTimeout,ParameterValue=$Timeout --capabilities CAPABILITY_NAMED_IAM
}

Write-Host "Terminé!" -ForegroundColor Green
