aws cloudformation deploy \
    --stack-name terraform-backend \
    --template-file backend.yaml

s3_bucket=$(aws cloudformation describe-stacks --stack terraform-backend --output text --query "Stacks[*].Outputs[?OutputKey=='S3Bucket'].OutputValue" | xargs)
dynamodb_table=$(aws cloudformation describe-stacks --stack terraform-backend --output text --query "Stacks[*].Outputs[?OutputKey=='DynamoDBTable'].OutputValue" | xargs)

echo
echo "S3 bucket: ${s3_bucket}"
echo "DynamoDB Table: ${dynamodb_table}"
echo "*** Please, add these two values in your Backend block ***"