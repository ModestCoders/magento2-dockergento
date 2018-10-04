# Magento 2 Dockergento Console

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](juan.jalogut@gmail.com)

Bash script to simplify execution of docker commands when using [magento2-dockergento](https://github.com/ModestCoders/magento2-dockergento) setup. 

Since it is a pure bash script, it does not have any external dependencies.

## Installation

Install it globally in your computer using one of the following methods.

### Install with git

1. Clone this repo

    ```
    git clone https://github.com/ModestCoders/magento2-dockergento-console.git
    ```

2. Add `dockergento` bin into your `$PATH`

    ```
    sudo ln -s $(pwd)/magento2-dockergento-console/bin/dockergento /usr/local/bin/
    ```

### Install with Composer

1. Install tool	
	
	```
	composer global require "modestcoders/magento2-dockergento-console"
	```

2. Add composer `bin` dir in your `$PATH`

	* Get composer `bin` directory
	
		```
		composer global config bin-dir --absolute
		```
		
	* Add previous path in your shell profile. In `bash` for example:

		```
		echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bash_profile
		```

**NOTE:** After installation, you need to open a new terminal tab/window to start using it.

## Usage

1. List commands available

	```
	dockergento --help
	```
	
2. Execute desired command

	```
	dockergento <command>
	```

## Workflow

See detailed documentation about development workflow with dockergento

* [Development Workflow](../docs/workflow.md)

## Custom Configuration

There are some properties that can be customised if your project setup differs from default one. You can do so by adding a file in one of the following paths and setting your custom values. 

### Custom properties paths

* `<PROJECT_ROOT>/config/dockergento/properties`
* `<PROJECT_ROOT>/../config/dockergento/properties`
* `<PROJECT_ROOT>/../../config/dockergento/properties`

### Default properties

Default list of properties that can be customised:

* [properties/dockergento_properties](properties/dockergento_properties)

### Examples

* If you have the magento code in a subfolder called for example `magento`. 

	```
	# <PROJECT_ROOT>/config/dockergento/properties
	MAGENTO_DIR="magento"
	```
	
* if your magento version is `<=2.1`

	```
	# <PROJECT_ROOT>/config/dockergento/properties
    GENERATED_DIR="var/generation"
	```

## ChangeLog

* [CHANGELOG.md](CHANGELOG.md)

## Developers

* [Juan Alonso](https://github.com/jalogut)
* [Daniel Lozano](https://github.com/danielozano)
* [Contributors](https://github.com/ModestCoders/dockergento-console/graphs/contributors)

## Licence

[GNU General Public License, version 3 (GPLv3)](http://opensource.org/licenses/gpl-3.0)

## Copyright
(c) ModestCoders