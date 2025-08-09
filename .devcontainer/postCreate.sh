#!/usr/bin/env bash
set -euo pipefail

# Core tooling
sudo apt-get update -y
sudo apt-get install -y jq unzip curl python3-pip awscli

# cfn-lint
pip3 install --upgrade cfn-lint

# Show versions for troubleshooting
echo "=== Versions ==="
aws --version || true
cfn-lint --version || true
jq --version || true
