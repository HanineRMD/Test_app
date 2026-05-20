# Le Cafe AWS Labs - Hanin

## Description
Infrastructure AWS complete pour Le Cafe deployee sur LocalStack.
Serie de 5 labs couvrant IAM, S3, EC2, SQS/SNS et CloudFormation.

## Labs
| Lab | Sujet | Statut |
|-----|-------|--------|
| Lab 00 | LocalStack setup | Termine |
| Lab 01 | IAM - users, groups, roles, policies | Termine |
| Lab 02 | S3 - buckets, versioning, lifecycle | Termine |
| Lab 03 | EC2 - keypair, security group, instance | Termine |
| Lab 04 | SQS + SNS - queues, topics, fan-out | Termine |
| Lab 05 | CloudFormation - Infrastructure as Code | Termine |

## Architecture Lab 05
- IAM Role + Instance Profile
- 2 buckets S3 avec versioning et lifecycle
- 5 queues SQS dont 1 DLQ
- 1 topic SNS avec 3 abonnements et filtre Priority=high
- Stack CloudFormation complete deployee en 1 commande

## Deploiement
aws --endpoint-url http://localhost:4566 cloudformation create-stack --stack-name lecafe-stack --template-body file://lab-05-cloudformation/lecafe-stack.yaml --parameters ParameterKey=EnvironmentName,ParameterValue=development --capabilities CAPABILITY_NAMED_IAM
