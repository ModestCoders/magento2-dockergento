# Xdebug

Xdebug is disabled by default in order to improve performance. It can be enabled/disabled at any time by doing the following.

## Enable Xdebug

1. First we need to know our `IP` for `xdebug.remote_host`

	<details>
	<summary>Mac</summary>
	
	Manually set it to `10.254.254.254`

	```
	sudo ifconfig lo0 alias 10.254.254.254 255.255.255.0
	```
	
	You can read why that is needed [here](http://jamescowie.me/blog/2016/12/all-hail-xdebug-and-lets-let-var-dump-die/#networking)

	</details>

	<details>
	<summary>Linux</summary>
	
	Copy and execute this script to know your remote host IP
	
	```
	#!/bin/bash
	if grep -q Microsoft /proc/version; then # WSL
    	REMOTE_HOST_IP=10.0.75.1
	else
    	if [ "$(command -v ip)" ]; then
 			REMOTE_HOST_IP =$(ip addr show docker0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
		else
    		REMOTE_HOST_IP =$(ifconfig docker0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1)
    	fi
	fi
	echo $REMOTE_HOST_IP
	```
	
	</details>
		
	<details>
	<summary>Windows</summary>
	
	`10.0.75.1`
	
	</details>

2. Enable Xdebug in `phpfpm` service 
	
	* **NOTE:** replace `$REMOTE_HOST_IP ` with corresponding `IP` from previous step. 
		
	```
	docker-compose exec phpfpm sed -i -e 's/^\;zend_extension/zend_extension/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
	docker-compose exec -u root phpfpm sed -i "s/xdebug\.remote_host\s\=\s.*/xdebug\.remote_host \= $REMOTE_HOST_IP/g" /usr/local/etc/php/php.ini
	```

3. Restart `app` and `phpfpm` services

	```
	docker-compose stop app phpfpm
	docker-compose up -d app
	```
	
## Disable Xdebug

1. Disable Xdebug in `phpfpm` service

	```
	docker-compose exec phpfpm sed -i -e 's/^\zend_extension/;zend_extension/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
	```

2. Restart `app` and `phpfpm` services

	```
	docker-compose stop app phpfpm
	docker-compose up -d app
	```
	
## Configure PHPSTORM

Check [PHPStorm + Xdebug Setup](xdebug_phpstorm.md) documentation