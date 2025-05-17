#!/bin/bash

# Exit on error
set -e

# Create and activate virtual environment
echo "Creating virtual environment..."
python3 -m venv .venv
source .venv/bin/activate

# Install dependencies
echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt
pip install -e .

# Bootstrap CDK (if needed)
echo "Bootstrapping CDK environment..."
cdk bootstrap

# Deploy the stack
echo "Deploying CDK stack..."
cdk deploy --require-approval never

echo "Deployment complete!"
