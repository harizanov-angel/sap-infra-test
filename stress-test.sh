#!/bin/bash

# Function to fetch and parse ECS service status
check_ecs_status() {
  echo "Checking ECS Service auto-scaling status..."

  # Fetch the ECS service status
  ecs_status=$(aws ecs describe-services --cluster $CLUSTER_NAME --services $SERVICE_NAME --region eu-central-1 --query "services[0].deployments[0]")

  # Extract various task counts
  running_tasks=$(echo $ecs_status | jq '.runningCount // 0')
  pending_tasks=$(echo $ecs_status | jq '.pendingCount // 0')
  provisioning_tasks=$(echo $ecs_status | jq '.provisioningCount // 0')
  activating_tasks=$(echo $ecs_status | jq '.activatingCount // 0')
  deactivating_tasks=$(echo $ecs_status | jq '.deactivatingCount // 0')

  # Output the task status
  echo "Running tasks: $running_tasks"
  echo "Pending tasks: $pending_tasks"
  echo "Provisioning tasks: $provisioning_tasks"
  echo "Activating tasks: $activating_tasks"
  echo "Deactivating tasks: $deactivating_tasks"
}

# Check if ab (Apache Benchmark) is installed
if ! command -v ab &> /dev/null
then
    echo "Error: ab (Apache Benchmark) is not installed. Please install it and try again."
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null
then
    echo "Error: jq is not installed. Please install it and try again."
    exit 1
fi

# Fetch the ALB URL from Terraform output
URL=$(terraform output -raw app_url)/
CLUSTER_NAME=$(terraform output -raw ecs_cluster_name)
SERVICE_NAME=$(terraform output -raw ecs_service_name)

# Check if URL is empty
if [ -z "$URL" ]; then
  echo "Error: URL is empty. Value is {$URL}. Please ensure Terraform has been applied successfully."
  exit 1
fi

# Configuration for the stress test
REQUESTS=5000   # Total number of requests to simulate
CONCURRENT=1000   # Number of concurrent requests per iteration

# Call the function to check ECS status before stress test
check_ecs_status

# Run Apache Benchmark for the load test
echo "Starting load test..."
ab -n $REQUESTS -c $CONCURRENT $URL

# Call the function to check ECS status after stress test
check_ecs_status

echo "Load test finished."
