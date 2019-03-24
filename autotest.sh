#!/bin/bash
START_DATE=$(date)

# DEPENDENCY
git clone https://github.com/nachoparker/progress_bar.sh dependencies_progressbar

# DIRECTORIES
mkdir -p ssllabs_test/

echo "STARTED SCRIPT AT $START_DATE"

function        test_for_wpscan()
{
        docker run --rm wpscanteam/wpscan --url $1 2>&1 > wpscan_test/$2
}

function        start_ssl_check()
{
        curl --silent https://api.ssllabs.com/api/v3/analyze/?host=$1 > /dev/null
}

function        test_ssl()
{
        curl --silent https://api.ssllabs.com/api/v3/analyze/?host=$1 > ssllabs_test/$1
}

function        getdomainfromurl()
{
        return $(echo $1 | awk -F/ '{print $3}')
}

while read URL; do

  DOMAIN=$(echo $URL | awk -F/ '{print $3}')

  test_for_wpscan $URL $DOMAIN
  start_ssl_check $DOMAIN

done < websites.txt

source dependencies_progressbar/progress_bar.sh
progress_bar 600

while read URL; do
  DOMAIN=$(echo $URL | awk -F/ '{print $3}')
  test_ssl $DOMAIN
done < websites.txt
