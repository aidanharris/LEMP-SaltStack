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

## Usage

### Docker

sudo -E vagrant up --provider docker # Sudo is needed to run docker commands as root

### VirtualBox

vagrant up --provider virtualbox

### Others

Other vagrant providers should work in theory, but are untested. If you have had success using another provider, you are welcome to submit any changes as a pull request.

## To Do:

- [ ] Describe LetsEncrypt Integration (or lack of)
- [ ] Describe Yum caching
- [ ] Describe SaltStack integration (Detail all of the states and how to use them)
- [ ] Describe Docker provider support
