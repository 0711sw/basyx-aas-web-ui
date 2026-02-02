#!/bin/bash
set -e

export AWS_PROFILE="sandbox"
S3_BUCKET="s3://basyx.durablox.net"

echo "=== BaSyx AAS Web UI Build & Deploy ==="
echo

# 1. Install dependencies
echo "[1/4] Installing dependencies..."
npm install

# 2. Build (skip prebuild hooks - external project, just build & deploy)
echo "[2/4] Building production bundle..."
BASE=/ npx vite build

# 3. Check AWS SSO session
echo "[3/4] Checking AWS credentials..."
if ! aws sts get-caller-identity &>/dev/null; then
    echo "No valid AWS session found. Starting SSO login..."
    aws sso login
fi

# 4. Deploy to S3
echo "[4/4] Deploying to S3..."
aws s3 sync dist/ "$S3_BUCKET" --delete

echo
echo "=== Done! ==="
echo "Deployed to: $S3_BUCKET"
