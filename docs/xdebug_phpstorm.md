# PHPStorm + Xdebug Setup

## Enable Xdebug

Xdebug needs to be enabled inside the `phpfpm` container. 

```
dockergento debug-on
```

## PHPStorm configuration

1. `PHPStorm > Preferences > Languages & Frameworks > PHP > Debug`	
	* Debug Port: 9001

	![debug_port](img/debug_port.png)

2. `PHPStorm > Preferences > Languages & Frameworks > PHP > Servers`

	* Name: `localhost` (Same as `PHP_IDE_CONFIG` in `docker-compose.yml`)
	* Port: 8000
	* Mapping: `/Users/<username>/Sites/<project> -> /var/www/html`

	![debug_server_mapping](img/debug_server_mapping.png)
	
3. Start Listening for PHP Debug connections

	**NOTE**: Be sure to activate that only after setting the right debug port. Changes in Debug port are ignored once the listener has started.
	
	![PHPStorm Debug Listener](img/phpstorm_debug_listener.png)

4. Install and enable `Xdebug helper` plugin in Chrome

	* [https://chrome.google.com/webstore/detail/xdebug-helper](https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc)
	
	![Xdebug Helper Config](img/xdebug_helper_config.png)
	![Xdebug Helper Enable](img/xdebug_helper_enable.png)

	
	
	
	
