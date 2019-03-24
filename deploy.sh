# SETTING UP KEY

echo $PRIVATE_SSH_KEY | base64 --decode > /tmp/.ssh_private
chmod 600 /tmp/.ssh_private

eval $(ssh-agent)

ssh-add /tmp/.ssh_private

git clone git@github.com:hostersecurity/hostersecurity.github.io.git

mkdir -p hostersecurity.github.io/ssllabs_test/
mkdir -p hostersecurity.github.io/wpscan_test/
mkdir -p hostersecurity.github.io/intrusion_tests/

cp ssllabs_test/* hostersecurity.github.io/ssllabs_test/
cp wpscan_test/* hostersecurity.github.io/wpscan_test/
cp intrusion_tests/* hostersecurity.github.io/intrusion_tests/

cd hostersecurity.github.io
git checkout -b testsresults/$TRAVIS_BUILD_NUMBER
git add ssllabs_test/* wpscan_test/* intrusion_tests/*
git commit -m "Updated test results for build $TRAVIS_BUILD_NUMBER"
git config user.email "travis@hostersecurity.tld"
git config user.name "Auto-test"
git push origin testsresults/$TRAVIS_BUILD_NUMBER

