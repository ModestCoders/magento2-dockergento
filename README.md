# Magento 2 Dockergento

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](juan.jalogut@gmail.com)

## Performance Comparison

<a href="https://youtu.be/sGmXc_lzTNM" target="_blank">
  <img src="docs/img/comparison_speed_video.png" alt="Dockergento speed comparison" width="240" height="180" border="10" />
</a>

## Motivation

This project aims to offer a good performance solution for Mac users that want to use docker on development.
This is a docker setup optimised for Magento 2 on Mac. It has same performance as Linux or local setups.

## Main Features

### Overcome Docker for Mac performance issue

<details>
<summary>Open to read issue explanation</summary>

From docker for mac documentation: https://docs.docker.com/docker-for-mac/troubleshoot/#known-issues

There are a number of issues with the performance of directories bind-mounted with osxfs. In particular, writes of small blocks, and traversals of large directories are currently slow. Additionally, containers that perform large numbers of directory operations, such as repeated scans of large directory trees, may suffer from poor performance. Applications that behave in this way include:

rake
ember build
Symfony
Magento
Zend Framework
PHP applications that use Composer to install dependencies in a vendor folder

As a work-around for this behavior, you can put vendor or third-party library directories in Docker volumes, perform temporary file system operations outside of osxfs mounts, and use third-party tools like Unison or rsync to synchronize between container directories and bind-mounted directories. We are actively working on osxfs performance using a number of different techniques. To learn more, see the topic on Performance issues, solutions, and roadmap.

</details>

**Solution:**

* Use docker volumes for following directories:

	* vendor
	* generated
	* var
	* pub/static
	* pub/media

* Synchronise `vendor` and `generated` volumes using a specific `unison` container. 

	<details>
	<summary>How to sync volumes between host and container</summary>
	
	See [dockergento workflow](#workflow) for a better understanding about whole development process with dockergento.
	
	There are 2 options to sync the volumes `vendor` and `generated`

	**Option 1: One time sync**

	This option must be used most of the times. You should only need to sync `vendor` and `generated` from time to time for debugging purposes

	```
	docker-compose run --rm unison sync -path vendor -path generated
	```

	NOTE: For faster and more specific syncs, you can specify a subfolder like `sync -path vendor/<company_name>`.

	**Option 2: Watch**

	This option is only recommended if you are implementing code in a vendor module.

	```
	docker-compose run --rm unison watch -path vendor/<company_name>/<module_name>`
	```	
	
	</details>
	

## Preconditions

1. Configure your docker `File Sharing` settings

	![File Sharing Configuration](docs/img/file_sharing.png)
	
	NOTE: You do not need to have `Composer` installed. You only need to create a `.composer` folder in your computer, so it can be used by containers to cache composer dependecies instead of downloading them everytime.

2. Optionally you can also apply these performance tweaks

	* [http://markshust.com/2018/01/30/performance-tuning-docker-mac](http://markshust.com/2018/01/30/performance-tuning-docker-mac)

## Installation

1. Copy this docker configuration repository in your project

	```
	cd <path_to_your_project>
	curl -L https://api.github.com/repos/ModestCoders/magento2-dockergento/tarball | tar xz --strip=1
	```

2. Edit binded paths or nginx configuration if needed

	<details>
	<summary>More info about custom configurations</summary>
	
	**Binded Paths:**
	
	If you install magento code in a different folder than your project root, you might need to replace `<magento_dir>` on the following files: 
	
	* `docker-compose.yml`
	
	```
	app-volumes:
		build: ./config/docker/image/app-volumes
		volumes: &appvolumes
  			- .:/var/www/html:delegated
  			- ~/.composer:/var/www/.composer:delegated
  			- sockdata:/sock
  			- app-vendor:/var/www/html/<magento_dir>/vendor
  			- app-generated:/var/www/html/<magento_dir>/generated
  			- app-var:/var/www/html/<magento_dir>/var
  			- pub-static:/var/www/html/<magento_dir>/pub/static
  			- pub-media:/var/www/html/<magento_dir>/pub/media
  			- integration-test-sandbox:/var/www/html/<magento_dir>/dev/tests/integration/tmp

	unison:
		image: modestcoders/unison:2.51.2
		volumes:
  			- app-vendor:/var/www/html/<magento_dir>/vendor
  			- app-generated:/var/www/html/<magento_dir>/generated
  			- ./vendor:/sync/vendor
  			- ./generated:/sync/generated
		environment:
  			- SYNC_SOURCE_BASE_PATH=/sync
  			- SYNC_DESTINATION_BASE_PATH=/var/www/html/<magento_dir>
  			- SYNC_MAX_INOTIFY_WATCHES=60000
	```
	
	* `config/docker/image/app-volumes/Dockerfile`
	
	```
	RUN mkdir -p /var/www/html/<magento_dir>/vendor \
		/var/www/html/<magento_dir>/generated \
		/var/www/html/<magento_dir>/var \
		/var/www/html/<magento_dir>/pub/static \
		/var/www/html/<magento_dir>/pub/media \
		/var/www/html/<magento_dir>/dev/tests/integration/tmp \
		&& chown -R 1000:1000 /var/www/html/<magento_dir>
	```	
	
	* `config/docker/image/nginx/conf/default.conf`
	
	```
	server {
		# ...
		set $MAGE_ROOT /var/www/html/<magento_dir>;
		# ...
	```
	
	**Nginx Multi-store:**
	
	If you have a multi-store magento, you need to add your website codes to the ngnix configuration as follows:  
	
	* `config/docker/image/nginx/conf/default.conf`
	
	```
	# WEBSITES MAPPING
	map $http_host $MAGE_RUN_CODE {

		default    base;
		## For multi-store configuration add here your domain-website codes
		dominio-es.lo    es;
		dominio-ch.lo    ch;
		dominio-de.lo    de;
	}
	```
	</details>

3. (Recommended) Install [magento2-dockergento-console](https://github.com/ModestCoders/magento2-dockergento-console)

	It is recommended to use this bash script tool for easier development workflow. See [dockergento workflow](#workflow) 

## Usage

### Video Demos

<a href="https://www.youtube.com/watch?v=rtr8waq7DHo&list=PLBt8dizedSZBhcjTL8SM2PS2HEy0mFf5F" target="_blank">
  <img src="docs/img/wizard_install_video.png" alt="Dockergento video demos" width="240px" height="180px" border="10" />
</a>

### Start Application

```
docker-compose up app
docker-compose exec phpfpm composer install
sudo vim /etc/hosts
// Add -> 127.0.0.1 <your-domain>
```

### <a name="workflow"></a> Workflow

See detailed documentation about development workflow with dockergento

* `magento2-dockergento-console` > [Development Workflow](https://github.com/ModestCoders/magento2-dockergento-console/blob/master/docs/workflow.md)

## Xdebug

* [PHPStorm + Xdebug Setup](docs/xdebug_phpstorm.md)

## Grumphp

* [Grumphp Setup](docs/grumphp_setup.md)

## Docker Images

* [Docker Images List](docs/docker_images.md)

## ChangeLog

* [CHANGELOG.md](CHANGELOG.md)

## Developers

* [Juan Alonso](https://github.com/jalogut)
* [Daniel Lozano](https://github.com/danielozano)
* [Contributors](https://github.com/ModestCoders/magento2-dockergento/graphs/contributors)

## Resources

This project has been possible thanks to the following resources:

* [docker-magento](https://github.com/markoshust/docker-magento) by [@markshust](https://twitter.com/markshust)
* [Getting Started with Docker for Magento](https://nomadmage.com/product/getting-started-with-docker-for-magento-2/) by [@mostlymagic](https://twitter.com/mostlymagic)
* [Docker Background Sync](https://github.com/cweagans/docker-bg-sync) by [@cweagans](https://twitter.com/cweagans)

## Licence

[GNU General Public License, version 3 (GPLv3)](http://opensource.org/licenses/gpl-3.0)

## Copyright
(c) ModestCoders
