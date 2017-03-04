# -*- mode: ruby -*-
# vi: set ft=ruby :

DEFAULT_PROCESSOR_COUNT = 4
DEFAULT_RAM_AMOUNT = "8024"
PKG_CACHE = '.pkgcache'

Dir.mkdir(PKG_CACHE) unless File.exists?(PKG_CACHE)

# Create private directories if they don't exist so shared folders don't fail
Dir.mkdir('.private') unless Dir.exists?('.private')
Dir.mkdir('.private/letsencrypt-etc/') unless Dir.exists?('.private/letsencrypt-etc/')

Dir.mkdir('www') unless Dir.exists?('www')
Dir.mkdir('www/html') unless Dir.exists?('www/html')

# Used to get the number of CPU cores - Credit: https://stackoverflow.com/a/6250054
module System
  extend self
  def cpu_count
    return Java::Java.lang.Runtime.getRuntime.availableProcessors if defined? Java::Java
    return File.read('/proc/cpuinfo').scan(/^processor\s*:/).size if File.exist? '/proc/cpuinfo'
    return DEFAULT_PROCESSOR_COUNT
  end
end

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure('2') do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  # This Vagrantfile should work with most GNU / Linux operating systems from
  # the RedHat family such as CentOS or RHEL. Fedora 25 is used by default since
  # batteries are included (no third-party repos need to be added).
  #config.vm.box = 'centos/7'
  #config.vm.box = 'fedora/25-cloud-base'

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  #config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  #config.vm.network "public_network", type: "dhcp"
  config.vm.network "private_network", type: "dhcp"

  config.vm.hostname = "www.localdomain"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder '.pkgcache', '/var/cache/yum/x86_64/7', owner: 'root', group: 'root'
  config.vm.synced_folder 'salt/conf', '/tmp/salt/conf'
  config.vm.synced_folder 'salt/roots/', '/srv/salt/'
  config.vm.synced_folder 'salt/pillar', '/srv/pillar'
  config.vm.synced_folder 'salt/formulas', '/srv/formulas'
  config.vm.synced_folder '.private', '/root/.private', owner: 'root', group: 'root'
  config.vm.synced_folder '.private/letsencrypt-etc/', '/etc/letsencrypt', type: 'rsync', owner: 'root', group: 'root'
  config.vm.synced_folder 'www/html', '/var/www', owner: 'root', group: 'root'

  # Instead of downloading the VirtualBox Guest additions from the Internet a
  # local file path can be specified instead. Uses the vagrant-vbguest plugin
  # https://github.com/dotless-de/vagrant-vbguest
  #config.vbguest.iso_path = "/usr/share/virtualbox/VBoxGuestAdditions.iso"

  # Set this to false if you have not downloaded the virtualbox guest additions
  # to the appropriate location (See: https://github.com/dotless-de/vagrant-vbguest#iso-autodetection)
  #config.vbguest.no_remote = true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb,override|
    override.vm.box = 'boxcutter/centos73'
    # Install the vagrant-hostmanager plugin (https://github.com/devopsgroup-io/vagrant-hostmanager)
    # to update your hosts file automatically
    if Vagrant.has_plugin?("vagrant-hostmanager")
      override.hostmanager.ip_resolver = proc do |vm, resolving_vm|
        if vm.id
        # Work around weird bug with either CentOS, Vagrant, or Virtualbox (not sure which) whereby interfaces
        # eth0 and eth1 change between `vagrant up` and `vagrant halt`
          if `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1][0..1] === '10'
            `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/0/V4/IP"`.split()[1]
          else
            `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
          end
        end
        override.hostmanager.enabled = true
        override.hostmanager.manage_host = true
        override.hostmanager.ignore_private_ip = false
        override.hostmanager.include_offline = true
        override.hostmanager.aliases = [ "www.localdomain" ]
      end
    end

    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
    # Number of CPU cores / 2 e.g a system with 8 cores will allocate 4
    # of those cores for the VM.
    vb.cpus = "#{((System.cpu_count/2)<=0) ? 1 : System.cpu_count / 2}"
    # Customize the amount of memory on the VM:
    vb.memory = DEFAULT_RAM_AMOUNT
  end

  config.vm.provider "docker" do |docker, override|
    # Install the vagrant-hostmanager plugin (https://github.com/devopsgroup-io/vagrant-hostmanager)
    # to update your hosts file automatically (assuming your using VirtualBox)
    if Vagrant.has_plugin?("vagrant-hostmanager")
      override.hostmanager.ip_resolver = proc do |vm, resolving_vm|
        if vm.id
          `sudo -E docker inspect #{vm.id} | grep -ohE '"IPAddress": ".*"' | head -n1 | sed 's/.*: //g' | cut -c2- | rev | cut -c2- | rev`
        end
      end

      override.hostmanager.enabled = true
      override.hostmanager.manage_host = true
      override.hostmanager.ignore_private_ip = false
      override.hostmanager.include_offline = true
      override.hostmanager.aliases = [ "www.localdomain" ]
    end
    docker.image = "local/c7-systemd-vagrant"
    docker.create_args = [
      "-d",
      "--rm",
      "--privileged"
    ]
    docker.remains_running = true
    docker.has_ssh = true
    docker.volumes = [
      "/sys/fs/cgroup:/sys/fs/cgroup:ro",
      "/var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket"
    ]
  end


  # Deploy to DigitalOcean (https://github.com/devopsgroup-io/vagrant-digitalocean)
  config.vm.provider :digital_ocean do |digitalocean, override|
    override.nfs.functional = false # Let vagrant know NFS is disabled to force it to use rsync instead
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    override.vm.box = 'digtal_ocean'
    override.vm.box_url = 'https://github.com/devopsgroup-io/vagrant-digitalocean/raw/master/box/digital_ocean.box'

    # Don't sync the local package cache...
    override.vm.synced_folder '.pkgcache', '/var/cache/yum/x86_64/7', disabled: true
    # Use rsync to sync folders...
    override.vm.synced_folder 'salt/conf', '/tmp/salt/conf', type: 'rsync', rsync__args: ["--verbose", "--archive", "--delete", "-z"]
    override.vm.synced_folder 'salt/roots/', '/srv/salt/', type: 'rsync', rsync__args: ["--verbose", "--archive", "--delete", "-z"]
    override.vm.synced_folder 'salt/pillar', '/srv/pillar', type: 'rsync', rsync__args: ["--verbose", "--archive", "--delete", "-z"]
    override.vm.synced_folder 'salt/formulas', '/srv/formulas', type: 'rsync', rsync__args: ["--verbose", "--archive", "--delete", "-z"]
    override.vm.synced_folder 'www/html', '/var/www', type: 'rsync', owner: 'root', group: 'root', rsync__exclude: 'vendor/', rsync__args: ["--verbose", "--archive", "--delete", "-z"]
    override.vm.synced_folder '.private', '/root/.private', owner: 'root', group: 'root', rsync__args: ["--verbose", "--archive", "--delete", "-z"]
    override.vm.synced_folder '.private/letsencrypt-etc/', '/etc/letsencrypt', type: 'rsync', owner: 'root', group: 'root', rsync__args: ["--verbose", "--archive", "--delete", "-z"]

    # Put the api token in the 'DIGITALOCEAN_TOKEN' environment variable or replace the string
    # below with a string containing the API token to use.
    digitalocean.token = "#{ENV['DIGITALOCEAN_TOKEN']}"
    digitalocean.image = 'centos-7-x64'
    digitalocean.region = 'lon1'
    digitalocean.size = '1gb'

    # Ensure we don't override any existing droplets by concatonating the current time onto the end of the hostname
    # After testing the hostname should probably be set to something more permanent...
    override.vm.hostname = "www-#{Time.now.to_i}"
  end

  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.

  # Use my CentOS Mirror if available since this is infinitely faster in my LAN
  config.vm.provision "file", source: "salt/conf/yum.conf", destination: "/tmp/yum.conf"
  config.vm.provision "shell", inline: "if [[ $(curl -s -o /dev/null -L -w '%{http_code}' https://aidanharris.me/centos) == '200' && \"$(ping -c 4 aidanharris.me | tail -1| awk '{print $4}' | cut -d '/' -f 2 | sed 's/\..*//g')\" -lt 10 ]]; then sudo mv /tmp/yum.conf /etc/yum.conf && sudo yum clean all && sed -i 's/- Base/- Base\\nenabled=0/g' /etc/yum.repos.d/CentOS-Base.repo && sed -i 's/- Updates/- Updates\\nenabled=0/g' /etc/yum.repos.d/CentOS-Base.repo; fi"

  # Add hosts entries
  config.vm.provision "shell", inline: "echo '127.0.0.1 redis' >> /etc/hosts"

  config.vm.provision "shell", path: "salt/conf/bootstrap_salt.sh"

  config.vm.provision "shell", inline: "echo 'Copying Salt config files...';sudo cp /tmp/salt/conf/minion /etc/salt"
  config.vm.provision "shell", inline: "echo 'Setting ownership of Salt config files to root';sudo chown root:root /etc/salt/minion"

  config.vm.provision "shell", inline: "echo 'Refreshing package database...';salt-call pkg.refresh_db"
  config.vm.provision "shell", inline: "echo 'Updating system packages';salt-call pkg.upgrade"

  # Provision the machine using SaltStack (https://docs.saltstack.com/en/latest/)
  config.vm.provision :salt do |salt|
    salt.masterless = true
    salt.run_highstate = true
    salt.verbose = true
    salt.log_level = "warning"
  end

  # Change the root password to a random one. Useful for boxes that don't have a vagrant
  # user e.g the digitalocean provider (it also has the benefit of increasing security).
  config.vm.provision "shell", inline: <<-SHELL
    password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;) &> /dev/null 2>&1
    echo "$password" | passwd --stdin root &> /dev/null 2>&1
    printf "Root Password: \033[1m$password\033[0m"
  SHELL
end
