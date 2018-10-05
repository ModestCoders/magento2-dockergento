# Workflow

The following guide shows you the normal workflow using [magento2-dockergento-console](https://github.com/ModestCoders/magento2-dockergento-console). If you want to see the real docker commands that are executed, just open `Docker commands` info at each section.


#### 1. Start containers

```
dockergento start
```
	
#### 2. Install/update dependecies with composer

```
dockergento composer <install/update>
```

#### 3. Develop code normally inside `magento/app`

While developing you might need to execute magento commands like `cache:clear` for example

```
dockergento magento <command>
```

#### 4. Working on frontend

```
dockergento grunt exec:<theme>
dockergento grunt watch
```

#### 5. Working on vendor modules [Mac and Windows only]

If you are developing code in a vendor module, you need to start unison watcher to sync files between host and container.

```
dockergento watch vendor/<vendor_name>/<module_name>
```

#### 6. xdebug

* Enable xdebug

	```
	dockergento debug-enable
	```
		
* Configure xdebug in PHPStorm (Only first time)

	* [PHPStorm + Xdebug Setup](https://github.com/ModestCoders/magento2-dockergento/blob/master/docs/xdebug_phpstorm.md)

* Sync generated **[Mac and Windows only]** 

	Because this folder is not binded for performance reasons, you need to sync it manually, so debugger finds the code in your host.

	```
	dockergento mirror-container generated
	```
		
	If you edit vendor files while debugging, you have to manually transfer the files into the container
		
	```
	dockergento mirror-host vendor/<subfolder_path>
	```
		
* Disable xdebug when finish 

	Environment is 10x slower when xdebug is enabled!

	```
	dockergento debug-disable
	```
 
#### 7. Execute tests

* All tests

	```
	dockergento test-unit
	dockergento test-integration
	```
	
* Only specific files

	```
	dockergento test-unit <test-file-path>
	dockergento test-integration <test-file-path>
	```
