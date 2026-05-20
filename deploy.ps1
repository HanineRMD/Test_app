# deploy.ps1 - Script de déploiement Le Café
param(
    [string]$EnvironmentName = "development",
    [int]$LogRetentionDays = 30,
    [int]$VisibilityTimeout = 30
)

$EP = "http://localhost:4566"
$StackName = "lecafe-stack"
$TemplateFile = "lecafe-stack.yaml"

Write-Host "=== Déploiement Le Café Stack ===" -ForegroundColor Green

# Configurer AWS pour LocalStack
$env:AWS_ACCESS_KEY_ID = "test"
$env:AWS_SECRET_ACCESS_KEY = "test"  
$env:AWS_DEFAULT_REGION = "us-east-1"

# Valider le template
Write-Host "Validation du template..." -ForegroundColor Yellow
aws --endpoint-url $EP cloudformation validate-template --template-body "file://$TemplateFile"

if ($LASTEXITCODE -ne 0) { exit 1 }

# Créer/Mettre à jour le stack
Write-Host "Déploiement du stack..." -ForegroundColor Yellow
aws --endpoint-url $EP cloudformation create-stack `
    --stack-name $StackName `
    --template-body "file://$TemplateFile" `
    --parameters `
        ParameterKey=EnvironmentName,ParameterValue=$EnvironmentName `
        ParameterKey=LogRetentionDays,ParameterValue=$LogRetentionDays `
        ParameterKey=OrderQueueVisibilityTimeout,ParameterValue=$VisibilityTimeout `
    --capabilities CAPABILITY_NAMED_IAM 2>$null

if ($LASTEXITCODE -eq 255) {
    Write-Host "Stack existe déjà, mise à jour..." -ForegroundColor Yellow
    aws --endpoint-url $EP cloudformation update-stack `
        --stack-name $StackName `
        --template-body "file://$TemplateFile" `
        --parameters `
            ParameterKey=EnvironmentName,ParameterValue=$EnvironmentName `
            ParameterKey=LogRetentionDays,ParameterValue=$LogRetentionDays `
            ParameterKey=OrderQueueVisibilityTimeout,ParameterValue=$VisibilityTimeout `
        --capabilities CAPABILITY_NAMED_IAM
}

Write-Host "Déploiement terminé!" -ForegroundColor Green
