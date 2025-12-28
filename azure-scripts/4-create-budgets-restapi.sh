#!/bin/bash

# Configuration
BUDGET_NAME=$1
AMOUNT=$2
EMAIL_ADDRESS=$3

if [ -z "$BUDGET_NAME" ] || [ -z "$AMOUNT" ] || [ -z "$EMAIL_ADDRESS" ]; then
    echo "Usage: $0 <BUDGET_NAME> <AMOUNT> <EMAIL_ADDRESS>"
    exit 1
fi

START_DATE=$(date +%Y-%m-01T00:00:00Z)
END_DATE=$(date -d "+2 years" +%Y-%m-01T00:00:00Z)

echo "Step 1: Identifying Subscription..."
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

echo "Step 2: Creating Budget via REST API (Bypassing CLI Bug)..."

# Construct the URI
URI="https://management.azure.com/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Consumption/budgets/${BUDGET_NAME}?api-version=2019-10-01"

# Create the JSON body
BODY=$(cat <<EOF
{
  "properties": {
    "category": "Cost",
    "amount": $AMOUNT,
    "timeGrain": "Monthly",
    "timePeriod": {
      "startDate": "$START_DATE",
      "endDate": "$END_DATE"
    },
    "notifications": {
      "Actual_80_Percent": {
        "enabled": true,
        "operator": "GreaterThan",
        "threshold": 80,
        "contactEmails": ["$EMAIL_ADDRESS"],
        "thresholdType": "Actual"
      }
    }
  }
}
EOF
)

# Execute the request
az rest --method put --url "$URI" --body "$BODY"

echo "------------------------------------------------"
echo "Verification: Checking budget status..."
az consumption budget show --budget-name "$BUDGET_NAME" -o table