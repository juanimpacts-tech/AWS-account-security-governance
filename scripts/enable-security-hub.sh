#!/usr/bin/env bash
set -euo pipefail

: "${AWS_REGION:?Set AWS_REGION}"

# Enable Security Hub
aws securityhub enable-security-hub --region "$AWS_REGION" || true

# Enable standards (AWS Foundational, CIS Foundations, PCI optional)
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ARN_PREFIX="arn:aws:securityhub:${AWS_REGION}:${ACCOUNT_ID}:subscription"

FOUNDATIONAL_ARN="${ARN_PREFIX}/aws-foundational-security-best-practices/v/1.0.0"
CIS_ARN="${ARN_PREFIX}/cis-aws-foundations-benchmark/v/1.2.0"
PCI_ARN="${ARN_PREFIX}/pci-dss/v/3.2.1"

aws securityhub batch-enable-standards --region "$AWS_REGION" --standards-subscription-requests \
  standardsArn="arn:aws:securityhub:::ruleset/aws-foundational-security-best-practices/v/1.0.0" \
  standardsArn="arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0" || true

# Note: Add PCI only if applicable; uncomment if needed:
# aws securityhub batch-enable-standards --region "$AWS_REGION" --standards-subscription-requests \
#   standardsArn="arn:aws:securityhub:::ruleset/pci-dss/v/3.2.1" || true

echo "Security Hub enabled. Review in console for findings."
