# Magento 2 Dockergento

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](juan.jalogut@gmail.com)

## Performance Comparison

#### Native performance in all OS systems (Linux, Mac and Windows)
#### Up to 7x faster development experience on Mac and Windows compare to standard docker setups.

<a href="https://youtu.be/qdUBuDCzHaA" target="_blank">
  <img src="docs/img/benchmark_comparison_video.png" alt="Dockergento speed comparison" width="320" height="180" border="5" />
</a>

#### Check out all benchmarks

* [Benchmarks: Dockergento vs Standard Docker](docs/benchmarks.md)

## Motivation

This project aims to offer native performance on all OS systems for users that want to use docker on development. That means same speed as local setups even on Mac and Windows.

## Main Features 
	
### Overcome Docker for Mac and Windows performance issues

<details>
<summary>Open to read issue explanation</summary>

From docker for mac documentation: https://docs.docker.com/docker-for-mac/troubleshoot/#known-issues

There are a number of issues with the performance of directories bind-mounted with osxfs. In particular, writes of small blocks, and traversals of large directories are currently slow. Additionally, containers that perform large numbers of directory operations, such as repeated scans of large directory trees, may suffer from poor performance. Applications that behave in this way include:

* rake
* ember build
* Symfony
* Magento
* Zend Framework
* PHP applications that use Composer to install dependencies in a vendor folder

As a work-around for this behavior, you can put vendor or third-party library directories in Docker volumes, perform temporary file system operations outside of osxfs mounts, and use third-party tools like Unison or rsync to synchronize between container directories and bind-mounted directories. We are actively working on osxfs performance using a number of different techniques. To learn more, see the topic on Performance issues, solutions, and roadmap.

</details>

**Solution:**

* Set full magento app inside a named volume `magento`
* Synchronise only git repository files between host and container.
* Everything else is not synchronised, so performance is same as in local setups.

**How do you get the code that is not synchronised in your host?**

Even if not synchronised, it is needed to have magento and vendor code in your host. Not only for developing but also for xdebug.

To sync that code seamlessly, [magento2-dockergento-console](https://github.com/ModestCoders/magento2-dockergento-console) uses `docker cp` automatically when you execute relevant commands like `dockergento composer` or `dockergento start`, so you do not need to care about that.

On the other hand, for those that implement modules inside vendor, we also provide a `unison` container that watches and syncs changes in background when you develop inside vendor.

See [dockergento workflow](#workflow) for a better understanding about whole development process with dockergento.


## Preconditions

1. Configure your docker `File Sharing` settings

	* `/Users/<user>/Sites`

#### System detailed info 

<details>
<summary>Mac</summary>
	
![File Sharing Configuration](docs/img/file_sharing.png)
	
Optionally you can also apply these performance tweaks

* [http://markshust.com/2018/01/30/performance-tuning-docker-mac](http://markshust.com/2018/01/30/performance-tuning-docker-mac)

</details>

<details>
<summary>Windows</summary>
	
TODO
![File Sharing Configuration](docs/img/todo)
	
</details>
	
<details>
<summary>Linux</summary>
	
TODO
![File Sharing Configuration](docs/img/todo)
	
</details>

## Installation

1. Install [magento2-dockergento-console](https://github.com/ModestCoders/magento2-dockergento-console)

2. Setup docker in your project:

    ```
    cd <path_to_your_project>
    dockergento setup
    ```

3. [Optional] If you have a multi-store magento, you need to add your website codes to the ngnix configuration as follows:

	<details>
	<summary>Open info about ngnix configuration</summary>

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

## Usage

### Start Application

```
dockergento start
dockergento composer install
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
