#!/usr/bin/env bash
set -euo pipefail

: "${AWS_REGION:?Set AWS_REGION}"

# Disable Security Hub (keeps findings history per AWS retention)
aws securityhub disable-security-hub --region "$AWS_REGION" || true

# Delete CFN stacks (does not remove S3 objects)
for STACK in cloudtrail-governance config-security-rules; do
  aws cloudformation delete-stack --region "$AWS_REGION" --stack-name "$STACK" || true
  aws cloudformation wait stack-delete-complete --region "$AWS_REGION" --stack-name "$STACK" || true
done

echo "Stacks deleted. If you created S3 buckets, empty and delete them manually to avoid charges."
