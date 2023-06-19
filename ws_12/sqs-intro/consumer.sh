#!/bin/sh

if [ $# -eq 0 ]; then
    echo "syntax: producer.sh NAME_OF_THE_CONSUMER"
    exit 1
fi

URL=$(aws sqs get-queue-url --queue-name report-requests --query QueueUrl --output text --region us-east-1)
echo Queue url: $URL
while true; do
    msg=$(aws sqs receive-message \
            --queue-url $URL \
            --max-number-of-message 1 \
            --region=us-east-1)
    handler=$(echo "$msg" | jq -r .Messages[0].ReceiptHandle)
    body=$(echo "$msg" | jq -r .Messages[0].Body)
    echo "Consumer $1 is processing: $body"
    sleep 2
    aws sqs delete-message --queue-url $URL --receipt-handle $handler --region us-east-1 
done
