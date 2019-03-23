#!/bin/bash

# TAKING THE PKEY FROM ENV AND SAVE IN TMP

eval $(ssh-agent)
echo $PRIVATE_SSH_KEY | base64 --decode > /tmp/.ssh_private
echo "Host *\n\tUseKeychain yes\n\tAddKeysToAgent yes" > ~/.ssh/config
chmod 600 /tmp/.ssh_private

# ADDING THE TEST RESULTS

git add wpscan_test/*
git add ssllabs_test/*

# DEPLOY TO TRAVIS

git checkout -b testsresults/$TRAVIS_BUILD_NUMBER
git commit -m "Autotests results $TRAVIS_BUILD_NUMBER"
git config user.email "travis@hostersecurity.tld"
git config user.name "Auto-test"
git remote set-url origin git@github.com:hostersecurity/automated-tests.git

ssh-agent bash -c 'ssh-add /tmp/.ssh_private; git push origin testsresults/$TRAVIS_BUILD_NUMBER'
