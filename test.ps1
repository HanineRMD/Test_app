# test.ps1 - Tester l'infrastructure Le Café
$EP = "http://localhost:4566"

Write-Host "=== Test de l'infrastructure Le Café ===" -ForegroundColor Green

# Récupérer l'ARN du topic
$TOPIC_ARN = aws --endpoint-url $EP cloudformation describe-stacks `
    --stack-name lecafe-stack `
    --query "Stacks[0].Outputs[?OutputKey=='OrdersTopicArn'].OutputValue" `
    --output text

Write-Host "Topic ARN: $TOPIC_ARN" -ForegroundColor Cyan

# Envoyer une commande test
Write-Host "`nEnvoi d'une commande test..." -ForegroundColor Yellow
aws --endpoint-url $EP sns publish `
    --topic-arn $TOPIC_ARN `
    --message '{"orderId":"TEST-GITHUB","table":1,"items":[{"product":"Café","quantity":1,"price":3.50}]}' `
    --message-attributes '{"Priority":{"DataType":"String","StringValue":"high"}}'

Start-Sleep -Seconds 2

# Vérifier les queues
Write-Host "`nVérification des messages:" -ForegroundColor Yellow
$queues = @(
    "lecafe-inventory-updates-development",
    "lecafe-loyalty-points-development",
    "lecafe-manager-alerts-development"
)

foreach ($queue in $queues) {
    $url = "http://localhost:4566/000000000000/$queue"
    $count = aws --endpoint-url $EP sqs get-queue-attributes --queue-url $url --attribute-names ApproximateNumberOfMessages --query "Attributes.ApproximateNumberOfMessages" --output text
    Write-Host "  $queue : $count message(s)" -ForegroundColor Green
}

Write-Host "`n✅ Test réussi!" -ForegroundColor Green
