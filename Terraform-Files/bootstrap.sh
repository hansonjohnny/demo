#!/bin/bash
# ─────────────────────────────────────────
# BOOTSTRAP SCRIPT
# run this ONCE before terraform init
# creates the S3 bucket and DynamoDB table
# that backend.tf depends on
# ─────────────────────────────────────────

set -e

AWS_REGION="us-east-2"
BUCKET_NAME="todo-app-save"
DYNAMODB_TABLE="todo-app-lockFiles"

echo "─── Creating S3 bucket for Terraform state ───"
aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
  --region "$AWS_REGION" \
  --create-bucket-configuration LocationConstraint="$AWS_REGION"

# enable versioning — lets you recover old state files if needed
echo "─── Enabling versioning on S3 bucket ───"
aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --versioning-configuration Status=Enabled

# enable server-side encryption on the bucket
echo "─── Enabling encryption on S3 bucket ───"
aws s3api put-bucket-encryption \
  --bucket "$BUCKET_NAME" \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

# block all public access to the state bucket
echo "─── Blocking public access on S3 bucket ───"
aws s3api put-public-access-block \
  --bucket "$BUCKET_NAME" \
  --public-access-block-configuration '{
    "BlockPublicAcls": true,
    "IgnorePublicAcls": true,
    "BlockPublicPolicy": true,
    "RestrictPublicBuckets": true
  }'

echo "─── Creating DynamoDB table for state locking ───"
aws dynamodb create-table \
  --table-name "$DYNAMODB_TABLE" \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "$AWS_REGION"

echo ""
echo "✅ Bootstrap complete. Now run:"
echo "   terraform init"
echo "   terraform plan"
echo "   terraform apply"
