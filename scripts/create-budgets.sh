#!/usr/bin/env bash
set -euo pipefail

: "${AWS_REGION:?Set AWS_REGION}"
: "${BUDGET_AMOUNT:?Set BUDGET_AMOUNT, e.g., 50}"
: "${ALERT_EMAIL:?Set ALERT_EMAIL}"

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

read -r -d '' BUDGET_PAYLOAD <<JSON
{
  "BudgetName": "MonthlyCostBudget",
  "BudgetLimit": { "Amount": "${BUDGET_AMOUNT}", "Unit": "USD" },
  "TimeUnit": "MONTHLY",
  "BudgetType": "COST",
  "CostFilters": {},
  "CostTypes": {
    "IncludeTax": true, "IncludeSubscription": true, "UseAmortized": false, "UseBlended": false
  }
}
JSON

for THRESHOLD in 50 80 100; do
  aws budgets create-notification \
    --account-id "$ACCOUNT_ID" \
    --budget-name "MonthlyCostBudget" \
    --notification \
      ComparisonOperator=GREATER_THAN,NotificationType=ACTUAL,ThresholdType=PERCENTAGE,Threshold="$THRESHOLD" \
    --subscribers \
      SubscriptionType=EMAIL,Address="$ALERT_EMAIL" \
    >/dev/null 2>&1 || true
done

aws budgets create-budget \
  --account-id "$ACCOUNT_ID" \
  --budget "$BUDGET_PAYLOAD" || true

echo "AWS Budget created with 50/80/100% alerts to $ALERT_EMAIL."
