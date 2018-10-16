We’ve worked very hard to implement this tool. If you find it useful and want to invite us for a beer, just click on the donation button. Thanks! 🍺 

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](juan.jalogut@gmail.com)

# Magento 2 Dockergento

Plug and play Magento 2 dev environments with docker. This tool is just a bash script ready to use in Linux and Mac to be able to use docker with best native performance.

While performance might no be a problem for Linux, using this tool is the only way you can overcome performance issues on Mac. Dockergento allows you to have different configuration for each system while using the same workflow. So your whole team can work the same way no matter which computer they are using. It just works!

## Supported Systems

* Mac
* Linux

## Performance Comparison

#### Native performance in Linux and Mac
#### Up to 7x faster development experience on Mac compare to standard docker setups.

<a href="https://youtu.be/qdUBuDCzHaA" target="_blank">
  <img src="docs/img/benchmark_comparison_video.png" alt="Dockergento speed comparison" width="320" height="180" border="5" />
</a>

#### Check out all benchmarks

* [Benchmarks: Dockergento vs Standard Docker](docs/benchmarks.md)

#### Learn more about how that is achieved

* [Overcoming Docker for Mac performance issues](docs/overcome_performance_issues.md)


## Installation

You only need 3 things on your local machine: `git`, `docker` and `dockergento`

### Install Docker

Follow the installation steps for your system.

<details>
<summary>Mac</summary>
	
1. Install Docker on [Mac](https://docs.docker.com/docker-for-mac/install/)

2. Configure `File Sharing` settings for the folder that contains your projects

	![File Sharing Configuration](docs/img/file_sharing.png)
	
3. Optionally you can also apply these performance tweaks

	* [http://markshust.com/2018/01/30/performance-tuning-docker-mac](http://markshust.com/2018/01/30/performance-tuning-docker-mac)

</details>
	
<details>
<summary>Linux</summary>
	
1. Install docker

	* Install Docker on [Debian](https://docs.docker.com/engine/installation/linux/docker-ce/debian/)
	* Install Docker on [Ubuntu](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/)
	* Install Docker on [CentOS](https://docs.docker.com/engine/installation/linux/docker-ce/centos/)

2. Configure permissions
	
	* [Manage Docker as a non-root user](https://docs.docker.com/install/linux/linux-postinstall/)

</details>

### Install dockergento console

1. Clone this repo

    ```
    git clone https://github.com/ModestCoders/magento2-dockergento.git
    ```

2. Add `dockergento` bin into your `$PATH`

    ```
    sudo ln -s $(pwd)/magento2-dockergento/bin/dockergento /usr/local/bin/
    ```
    
3. Open a new terminal tab/window and check that `dockergento` works

	```
	which dockergento
	dockergento
	```

</details>


## Project Setup

Depending the type of project, you can use one of the following setups:

### Dockerize existing project

```
cd <your_project>
dockergento setup
```

### New project

```
mkdir <new_project_name> && cd <new_project_name>
dockergento setup
dockergento create-project
```

### Magento 2 github for contribution

```
git clone https://github.com/magento/magento2.git
cd magento2
dockergento setup
```

## Usage

### Start Application

```
dockergento start
dockergento composer install
sudo vim /etc/hosts
// Add -> 127.0.0.1 <your-domain>
```

Open `<your-domain>` in the browser 🎉

### <a name="workflow"></a> Workflow

See detailed documentation about development workflow with dockergento

* [Development Workflow](docs/workflow.md)

## Multi Store

If you have a multi-store magento, you need to add your website codes to the ngnix configuration as follows:

<details>
<summary>Open info about ngnix configuration</summary>

Edit `config/dockergento/nginx/conf/default.conf`
	
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
	
You need to restart dockergento to apply the new configuration:
	
```
dockergento restart
```
	
</details>

## Xdebug

* [PHPStorm + Xdebug Setup](docs/xdebug_phpstorm.md)

## Grumphp

* [Grumphp Setup](docs/grumphp_setup.md)

## Docker Images

* [Docker Images List](docs/docker_images.md)

## Customizations

* [Customizations](docs/customizations.md)

## Troubleshooting

* [Troubleshooting](docs/troubleshooting.md)

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
