# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Version](http://semver.org/spec/v2.0.0.html).

## [future-version] - 00-00-2018
### Added

### Changed

### Removed

## [1.3] - 05-09-2018

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
* Use `modescoders/php` image
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