#!/bin/bash

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

# Check if ALB_URL is empty
if [ -z "$URL" ]; then
  echo "Error: URL is empty. Value is {$URL}. Please ensure Terraform has been applied successfully."
  exit 1
fi

# Configuration for the stress test
REQUESTS=10000   # Total number of requests to simulate
CONCURRENT=1000   # Number of concurrent requests per iteration
ITERATIONS=$((REQUESTS / CONCURRENT))  # Number of iterations based on total requests

echo "Starting load test to simulate traffic..."

# Loop to send requests in smaller chunks
for ((i=1; i<=ITERATIONS; i++))
do
    echo "Running iteration $i of $ITERATIONS"
    ab -n $CONCURRENT -c $CONCURRENT $URL

    # Call the function to check ECS status
    check_ecs_status
done

echo "Load test finished. Traffic sent to ALB at $URL."

# Function to fetch and parse ECS service status
check_ecs_status() {
  echo "Checking ECS Service auto-scaling status..."
  
  # Fetch the ECS service status
  ecs_status=$(aws ecs describe-services --cluster $CLUSTER_NAME --services $SERVICE_NAME --region eu-central-1 --query "services[0].deployments[0]")

  # Extract running and pending task counts
  running_tasks=$(echo $ecs_status | jq '.runningCount')
  pending_tasks=$(echo $ecs_status | jq '.pendingCount')

  # Output the task status
  echo "Running tasks: $running_tasks"
  echo "Pending tasks: $pending_tasks"
}

