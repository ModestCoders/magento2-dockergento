# Magento 2 Dockergento

Plug and play Magento 2 dev environments with docker. **Fastest performance ever** on Mac and Linux.

## Performance Comparison

#### Up to 7x faster development experience on Mac compare to standard docker setups.

<a href="https://www.youtube.com/watch?v=qdUBuDCzHaA&list=PLBt8dizedSZBhcjTL8SM2PS2HEy0mFf5F" target="_blank">
  <img src="docs/img/benchmark_comparison_video.png" alt="Dockergento speed comparison" width="320" height="180" border="5" />
</a>

#### Check out all benchmarks

* [Benchmarks: Dockergento vs Standard Docker](docs/benchmarks.md)

#### Learn more about how that is achieved

* [Overcoming Docker for Mac performance issues](docs/overcome_performance_issues.md)

---

## What is dockergento?

Dockergento is just a bash script ready to use in Linux and Mac to be able to use docker with best native performance.

While performance might no be a problem for Linux, using this tool is the only way you can overcome performance issues on Mac. Dockergento allows you to have different configuration for each system while using the same workflow. So your whole team can work the same way no matter which computer they are using. It just works!

## Supported Systems

* Mac
* Linux

---

## Video Tutorials

If you do not like reading and prefer watching videos. Check out all video tutorials here:

* [Video Tutorials](./docs/video_tutorials.md)

---

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
**Disclaimer:** Performance on Mac is slower here due to the huge amount of files in `app` (~20.000 files)

<details>
<summary>Workaround to improve performance on Mac</summary>
	
1. Remove these lines on `docker-compose.dev.mac.yml`
    
    ```
        - ./app:/var/www/html/app:delegated
        - ./dev:/var/www/html/dev:delegated
        - ./generated:/var/www/html/generated:delegated
        - ./pub:/var/www/html/pub:delegated
        - ./var:/var/www/html/var:delegated
    ```
 
2. Sync `app` using `unison` container. Add this in `docker-compose.dev.mac.yml`
     
    ```
    unison:
      volumes:
        - ./app:/sync/app
    ```

3. Mirror not synced folders before executing composer the first time

	```
	dockergento start
	dockergento mirror-host app dev generated pub var
	```

4. If you are editing code in `app`, you need to start unison watcher to sync files between host and container.

	```
	dockergento watch app/code/Magento/<module_name>
	```
    
</details>

```
git clone https://github.com/magento/magento2.git
cd magento2
dockergento setup
```

---

## Usage

### Installing Magento 2.4

For a new store with Magento 2.4, you will need to install Magento via the command line before you can use it. Follow the instructions at https://devdocs.magento.com/guides/v2.4/install-gde/install-quick-ref.html, using `db` as the database host and `elasticsearch` as the Elasticsearch host.

For example:

```
dockergento magento setup:install --base-url=http://local.magento.com --db-host=db --db-name=magento --db-user=magento --db-password=magento \
--admin-firstname=Magento --admin-lastname=User --admin-email=user@example.com \
--admin-user=admin --admin-password=admin123 --language=en_US \
--currency=USD --timezone=America/Chicago --use-rewrites=1 \
--elasticsearch-host=elasticsearch
```

Make a note of the admin URL it prints out, e.g. `[SUCCESS]: Magento Admin URI: /admin_5gdsve`.

You also need to disable 2FA, as the Docker image is not configured to send the necessary email:

`dockergento bin/magento module:disable Magento_TwoFactorAuth`

You can now access your admin at http://<your-domain>/<admin_uri> e.g. http://127.0.0.1/admin_5gdsve and login with the details you gave on the command line, e.g. admin/admin123.

### Start Application

```
dockergento start
dockergento composer install
sudo vim /etc/hosts
// Add -> 127.0.0.1 <your-domain>
```

Open `http://<your-domain>` in the browser 🎉

### Workflow

See detailed documentation about development workflow with dockergento

* [Development Workflow](docs/workflow.md)

---

## More Documentation

* [Multi store configuration](docs/multi_store.md)
* [PHPStorm + Xdebug Setup](docs/xdebug_phpstorm.md)
* [Grumphp setup](docs/grumphp_setup.md)
* [Docker images list](docs/docker_images.md)
* [Other customizations](docs/customizations.md)

## Troubleshooting

* [Troubleshooting](docs/troubleshooting.md)

---

## ChangeLog

* [CHANGELOG.md](CHANGELOG.md)

## Developers

* [Juan Alonso](https://github.com/jalogut)
* [Daniel Lozano](https://github.com/danielozano)
* [Contributors](https://github.com/ModestCoders/magento2-dockergento/graphs/contributors)

## Donations 🙏

We’ve worked very hard to implement this tool. If you find it useful and want to invite us for a beer, just click on the donation button. Thanks! 🍺 

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](juan.jalogut@gmail.com)

## Resources

This project has been possible thanks to the following resources:

* [docker-magento](https://github.com/markoshust/docker-magento) by [@markshust](https://twitter.com/markshust)
* [Getting Started with Docker for Magento](https://nomadmage.com/product/getting-started-with-docker-for-magento-2/) by [@mostlymagic](https://twitter.com/mostlymagic)
* [Docker Background Sync](https://github.com/cweagans/docker-bg-sync) by [@cweagans](https://twitter.com/cweagans)

## Licence

* [GNU General Public License, version 3 (GPLv3)](http://opensource.org/licenses/gpl-3.0)

## Copyright
(c) ModestCoders
