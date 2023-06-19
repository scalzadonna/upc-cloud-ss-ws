#!/bin/bash

URL=$(aws sqs get-queue-url --queue-name report-requests --query QueueUrl --output text --region us-east-1)
echo Queue url: $URL
while true; do
    msg=$(aws sqs receive-message \
            --queue-url $URL \
            --max-number-of-message 1 \
            --wait-time-seconds 20 \
            --attribute-names MessageGroupId \
            --region=us-east-1)
    if [ -n "$msg" ]; then
        handler=$(echo "$msg" | jq -r .Messages[0].ReceiptHandle)
        body=$(echo "$msg" | jq -r .Messages[0].Body)
        echo "Main consumer is processing: $body"
        if (($body % 2 == 1)); then 
            aws sqs delete-message --queue-url $URL --receipt-handle $handler --region us-east-1 
        else
            echo "Skipped message deletion for $body."; 
            continue; 
        fi    
    else
        echo "No message received after 20 seconds."
    fi
done
