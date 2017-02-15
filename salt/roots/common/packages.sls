{% if grains['os_family'] == 'RedHat' and grains['os'] != 'Fedora' %}
epel_release:
  pkg.installed:
    - pkgs:
      - epel-release
{% endif %}
common_packages:
  pkg.installed:
    - pkgs:
      {% if grains['os_family'] == 'RedHat' %}
      {% if not salt['file.file_exists']('/usr/bin/chsh') %}
      - util-linux-user
      {% endif %}
      - vim-enhanced
      {% endif %}
      {% if grains['os_family'] == 'Debian' %}
      - secure-delete
      - vim
      {% else %}
      - srm
      {% endif %}
      - zip
      - unzip
      - sudo
      - curl
      - wget
      - rsync
      - htop
      - screen
      - tmux
      - zsh
      - git
      - bzr
      - ruby
      - python
      - apg
