# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Version](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added

### Changed

### Fixed

## [4.0.1] - 2019-11-22
### Fixed
 * Linux: permission fix not running on rebuild
 * Linux: now correct permissions are set when UID is not 1000

## [4.0.0] - 2019-09-26
### Added
 * Added elasticsearch service

### Changed
 * Speed up debug-on and debug-off commands
 * Changed naming convention for fpm images in order to have always the last version
 * Updated nginx conf file

### Fixed
 * Fixed large product imports increasing php `max_input_vars` value
 * Fixed link to php image in docs

## [3.5.0] - 08-03-2019
### Added

* Fix permission on linux machines automatically when containers start
* Added bind path `../.composer:/var/www/html/var/composer_home` so composer cache is kept in host.

## [3.4.0] - 13-02-2019
### Added

* Added php version: 7.2.

## [3.3.1] - 01-02-2019
### Change

* Fix bug when executing `debug-on` command on linux machine

## [3.3.0] - 09-11-2018
### Added

* Automatically set `--working-dir=${COMPOSER_DIR}` option for `composer` commands.

## [3.2.0] - 01-11-2018
### Added

* Support for Livereload in google Chrome.

## [3.1.1] - 26-10-2018
### Added

* Documentation updates and Video tutorials section.

## [3.1.0] - 17-10-2018
### Added

* Command descriptions added to `dockergento` console.

## [3.0.0] - 16-10-2018
### Added

* Multiple OS compatibility (Linux, Mac)
* Include `magento2-dockergento-console` directly in this repository.

### Fixed

* Projects with vendor in repository were not working on Mac
* Magento 2 github project was not working on Mac

### Backward incompatible changes

* `dockergento` needs now 2 `docker-compose` files. The base one and the OS specific.
* `app` service has been renamed to `nginx`
* `magento2-dockergento-console` repository has been removed and its code has been added directly into this repo.
* Debug commands have been renamed to `debug-on` and `debug-off`
* `app-volumes` service has been removed.
* New images used for `nginx` and `php`
	* `modestcoders/nginx:1.13`
	* `modestcoders/php:7.1-fpm-1` 

### Upgrade steps
1. Create a backup of your current config:
	
	```
	mv config/dockergento config/dockergento-backup
	mv docker-compose.yml docker-compose.yml.backup
	```

2. Run `dockergento setup` inside your project
3. Edit volumes in `docker-compose.dev.mac.yml` as you had it before. 
4. Edit `nginx` configuration in `config/dockergento/nginx/conf/default.conf`
5. Edit `config/dockergento/properties` if needed.

## [2.1.0] - 21-09-2018
### Changed

* Easier install documentation using `dockergento setup` command
* Set all configuration settings inside `config/dockergento` folder
* Change `docker-compose.yml` filename to `docker-compose.sample.yml` as this file needs to be copied and edited per project.

## [2.0.0] - 13-09-2018
### Changed

* Set whole magento application in a named volume `magento` instead of using 6 volumes:

	```
	app-vendor
	app-generated
	app-var
	pub-static
	pub-media
	integration-test-sandbox
	```

    * Reason: Bug when having volumes inside a file bind mount: [#26157](https://github.com/moby/moby/issues/26157#issuecomment-419722589)

## [1.3.0] - 05-09-2018
### Changed
* Documentation about how to sync `vendor` and `generated` volumes according to latest changes on [magento2-dockergento-console](https://github.com/ModestCoders/magento2-dockergento-console) 

### Removed

* Remove first 2 steps to configure xdebug in PHPStorm are not longer needed because it is enough by just setting the debug port and server configuration
* Remove bind mount of `generated` folder in `unison container. Unison container is now only meant to be used for `watch` command inside vendor modules.

## [1.2.0] - 30-08-2018
### Added

* Development workflow documentation
* Troubleshooting section with info about broken volumes

### Changed

* Use updated node image with right user `app` by default
* Use `modestcoders/php` image
* Xdebug uses now `xdebug.remote_host=host.docker.internal` as it is defined on `modescoders/php` images

### Removed

* Remove not needed `NPM_CONFIG_PREFIX` because default user is now app
* Remove phpstorm xdebug `DBGp` configuration step that is no longer needed

## [1.1] - 24-08-2018
### Changed

* Use `modestcoders/unison:2.51.2` image for unison container
* Update `markoshust/magento-php` images to PHP `7.1` using tag `7.1-fpm-3`
* Update docker setup with fixes for node and integration tests
* Update dependencies and `app-volumes` configuration to avoid issues when `app-volumes` is started several times in same `docker-compose up` execution
* Execute Dockerfile run commands for `app-volumes` in only one layer as it is best practise
* Update README with `node` and `unison` commands to use `run` instead of `exec`
* Update `xdebug + phpstorm` documentation

## [1.0.1] - 15-08-2018
### Changed

* Use `modestcoders/node-php:node8-php7.0` image for node container
