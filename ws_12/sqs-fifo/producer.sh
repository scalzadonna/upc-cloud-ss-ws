#!/bin/sh

if [ $# -eq 0 ]; then
    echo "syntax: producer.sh NAME_OF_THE_PRODUCER"
    exit 1
fi

URL=$(aws sqs get-queue-url --queue-name report-requests.fifo --query QueueUrl --output text --region us-east-1)
echo Qeueu URL: $URL
for i in `seq 1 100`; do
  echo Producer $1 creating message $i.
  aws sqs send-message \
	  --queue-url $URL \
	  --message-body "This message was created by producer $1, with the number $i." \
      --message-group-id $1 \
      --message-deduplication-id $1_$i \
	  --region=us-east-1
  sleep 1
done
