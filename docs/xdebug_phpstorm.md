# PHPStorm + Xdebug Setup

## Configuration Steps

1. `Build, Execution, Deployment > Docker`

	* Add new docker profile (i.e dockergento)

2. `PHPStorm > Preferences > Languages & Frameworks > PHP`

	* Add new CLI interpreter

	![cli_new_interpreter](img/cli_new_interpreter.png)
	
	* Select CLI Interpreter from Docker

	![interpreter_from_docker](img/interpreter_from_docker.png)
	
	* Select `phpfpm` docker image

	![interpreter_phpfpm_image](img/interpreter_phpfpm_image.png)

3. `PHPStorm > Preferences > Languages & Frameworks > PHP > Debug`	
	* Debug Port: 9001

	![debug_port](img/debug_port.png)

4. `PHPStorm > Preferences > Languages & Frameworks > PHP > Debug > DBGp Proxy`

	* Host must match with the `REMOTE_HOST_IP` set on the [Xdebug configuration](xdebug.md)

	![debug_dbgp](img/debug_dbgp.png)

5. `PHPStorm > Preferences > Languages & Frameworks > PHP > Servers`

	* Name: `localhost` (Same as `PHP_IDE_CONFIG` in `docker-compose.yml`)
	* Port: 8000
	* Mapping: `/Users/<username>/Sites/<project> -> /var/www/html`

	![debug_server_mapping](img/debug_server_mapping.png)
	
6. Start Listening for PHP Debug connections

	**NOTE**: Be sure to activate that only after setting the right debug port. Changes in Debug port are ignored once the listener has started.
	
	![PHPStorm Debug Listener](img/phpstorm_debug_listener.png)

	
7. Install and enable `Xdebug helper` plugin in Chrome

	* [https://chrome.google.com/webstore/detail/xdebug-helper](https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc)
	
	![Xdebug Helper Config](img/xdebug_helper_config.png)
	![Xdebug Helper Enable](img/xdebug_helper_enable.png)

	
	
	
	