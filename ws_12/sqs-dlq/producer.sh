#!/bin/sh

URL=$(aws sqs get-queue-url --queue-name report-requests --query QueueUrl --output text --region us-east-1)
echo Qeueu URL: $URL
for i in `seq 1 10`; do
  echo Producer creating message $i.
  aws sqs send-message \
	  --queue-url $URL \
	  --message-body "$i" \
	  --region=us-east-1
done
