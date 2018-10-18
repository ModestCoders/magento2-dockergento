# Overcoming Docker for Mac performance issues

## Issue

From docker for mac documentation: 

* [https://docs.docker.com/docker-for-mac/troubleshoot/#known-issues](https://docs.docker.com/docker-for-mac/troubleshoot/#known-issues)

There are a number of issues with the performance of directories bind-mounted with osxfs. In particular, writes of small blocks, and traversals of large directories are currently slow. Additionally, containers that perform large numbers of directory operations, such as repeated scans of large directory trees, may suffer from poor performance. Applications that behave in this way include:

* rake
* ember build
* Symfony
* Magento
* Zend Framework
* PHP applications that use Composer to install dependencies in a vendor folder

As a work-around for this behavior, you can put vendor or third-party library directories in Docker volumes, perform temporary file system operations outside of osxfs mounts, and use third-party tools like Unison or rsync to synchronize between container directories and bind-mounted directories. We are actively working on osxfs performance using a number of different techniques. To learn more, see the topic on Performance issues, solutions, and roadmap.

</details>

## Solution:

* Set full magento app inside a named volume `workspace`
* Synchronise only git repository files between host and container.
* Everything else is not synchronised, so performance is same as in local setups.
* `vendor` cannot be a bind mount.

### How do you get the code that is not synchronised in your host?

Even if not synchronised, it is needed to have magento and `vendor` code in your host. Not only for developing but also for xdebug.

To sync that code seamlessly, dockergento uses `docker cp` automatically when you execute relevant commands like `dockergento composer`, so you do not need to care about that.

On the other hand, for those that implement modules inside vendor, we also provide a `unison` container that watches and syncs changes in background when you develop inside vendor.

See [dockergento workflow](./workflow.md) for a better understanding about whole development process with dockergento.
