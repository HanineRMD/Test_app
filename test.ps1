# test.ps1 - Test Le Café Stack
$EP = "http://localhost:4566"

Write-Host "=== Test Le Café ===" -ForegroundColor Green

$TOPIC_ARN = aws --endpoint-url $EP cloudformation describe-stacks --stack-name lecafe-stack --query "Stacks[0].Outputs[?OutputKey=='OrdersTopicArn'].OutputValue" --output text

Write-Host "Topic: $TOPIC_ARN" -ForegroundColor Cyan

aws --endpoint-url $EP sns publish --topic-arn $TOPIC_ARN --message '{"orderId":"TEST","totalAmount":10}' --message-attributes '{"Priority":{"DataType":"String","StringValue":"high"}}'

Start-Sleep -Seconds 2

Write-Host "Test terminé!" -ForegroundColor Green
