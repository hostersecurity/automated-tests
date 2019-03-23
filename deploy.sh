#!/bin/bash

# TAKING THE PKEY FROM ENV AND SAVE IN TMP

eval $(ssh-agent)
echo $PRIVATE_SSH_KEY | base64 --decode > /tmp/.ssh_private
echo "Host *\n\tUseKeychain yes\n\tAddKeysToAgent yes" > ~/.ssh/config
chmod 600 /tmp/.ssh_private

# CLONE GIT REPO
rm -rf .git

ssh-agent bash -c 'ssh-add /tmp/.ssh_private; git clone git@github.com:hostersecurity/hostersecurity.github.io.git'
cd hostersecurity.github.io

mkdir -p wpscan_test ssllabs_test

cp ../wpscan_test/* wpscan_test
cp ../ssllabs_test/* ssllabs_test

git add wpscan_test/*
git add ssllabs_test/*

git checkout -b testsresults/$TRAVIS_BUILD_NUMBER
git commit -m "Autotests results $TRAVIS_BUILD_NUMBER"
git config user.email "travis@hostersecurity.tld"
git config user.name "Auto-test"
git remote set-url origin git@github.com:hostersecurity/hostersecurity.github.io.git

ssh-agent bash -c 'ssh-add /tmp/.ssh_private; git push origin testsresults/$TRAVIS_BUILD_NUMBER'
