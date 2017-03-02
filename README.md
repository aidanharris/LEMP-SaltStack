# LEMP-SaltStack
An opinionated LEMP stack for use with Vagrant as a local dev environment.

## What's in the Box?

* Support for both Debian and RedHat based OS's
* Docker provider support (See: [c7-systemd-vagrant](https://github.com/aidanharris/c7-systemd-vagrant))
* A full LEMP stack comprised of Linux, Nginx, MariaDB and PHP
* [Composer](https://getcomposer.org/)
* [Mailcatcher](https://mailcatcher.me/)
* [Redis](https://redis.io/) and [phpiredis](https://github.com/nrk/phpiredis) - This is the default for PHP session storage
* NodeJS - Provided by the excellent [n-install](https://github.com/mklement0/n-install) with the current LTS version used by default

