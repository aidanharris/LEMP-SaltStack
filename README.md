# LEMP-SaltStack
An opinionated LEMP stack for use with Vagrant as a local dev environment.

## Symfony

### Usage

Bring the environment up as usual using Vagrant:

#### Docker

```bash
sudo -E vagrant up --provider docker # Sudo is needed to run docker commands as root
```

Note: You'll need to prefix all other vagrant commands (e.g `vagrant provision`) with `sudo -E` too, since you'll get "permission denied" errors if you don't execute the commands as root.

#### VirtualBox

```bash
vagrant up --provider virtualbox
```

#### Others

Other vagrant providers should work in theory, but are untested. If you have had success using another provider, you are welcome to submit any changes as a pull request.

### Symfony Cli

Once the environment is up and running the Symfony CLI tool is located at `/usr/local/bin/symfony`

#### Creating a project

You can create a new project using the `symfony new project_name`

In addition to the above there is also a sample salt state located in the [salt/roots/symfony](https://github.com/aidanharris/LEMP-SaltStack/blob/symfony/salt/roots/symfony) directory (See: [sample_project.sls](https://github.com/aidanharris/LEMP-SaltStack/blob/symfony/salt/roots/symfony/sample_project.sls))

You can use this state to get started immediatly as follows:

`salt-call state.apply symfony.sample_project`

After running the above command and following the presented instructions you can point your browser at the IP address of the machine in question since nginx is configured as a reverse proxy (See: [salt/pillar/nginx-dev.sls](https://github.com/aidanharris/LEMP-SaltStack/blob/symfony/salt/pillar/nginx-dev.sls))
