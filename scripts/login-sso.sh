#!/usr/bin/env bash
set -euo pipefail

if ! command -v aws >/dev/null 2>&1; then
  echo "AWS CLI not found"; exit 1
fi

aws configure sso
aws sts get-caller-identity
