#!/bin/bash

START_DATE=$(date)

while read p; do
  DOMAIN=$(echo $p | awk -F/ '{print $3}')
  echo "TESTS START FOR $DOMAIN"
  # TEST 1 : WPSCAN
  docker run --rm wpscanteam/wpscan --url $p 2>&1 > wpscan_test/$DOMAIN
  # TEST 2 : SSLABS REQUEST
  curl https://api.ssllabs.com/api/v3/analyze/?host=$DOMAIN
  # ADD DELAY
done < websites.txt

echo "GO AND TAKE A COFFEE ..."
sleep 300
echo "GO AND TAKE A COFFEE ..."
sleep 300

while read p; do
  DOMAIN=$(echo $p | awk -F/ '{print $3}')
  curl https://api.ssllabs.com/api/v3/analyze/?host=$DOMAIN > ssllabs_test/$DOMAIN
done < websites.txt
