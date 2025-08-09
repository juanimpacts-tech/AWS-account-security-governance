#!/usr/bin/env bash
set -euo pipefail

: "${AWS_REGION:?Set AWS_REGION}"
: "${TRAIL_NAME:=AccountTrail}"
: "${TRAIL_BUCKET_NAME:?Set TRAIL_BUCKET_NAME (globally-unique S3 name)}"
: "${KMS_ALIAS:=alias/cloudtrail-key}"

STACK_NAME="cloudtrail-governance"

aws cloudformation deploy \
  --region "$AWS_REGION" \
  --stack-name "$STACK_NAME" \
  --template-file templates/cloudtrail.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
      TrailName="$TRAIL_NAME" \
      TrailBucketName="$TRAIL_BUCKET_NAME" \
      KmsAliasName="$KMS_ALIAS"

aws cloudformation describe-stacks --region "$AWS_REGION" --stack-name "$STACK_NAME" \
  --query "Stacks[0].StackStatus" --output text
