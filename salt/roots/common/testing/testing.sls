{% if grains['os_family'] == 'RedHat' and grains['os'] != 'Fedora' %}
epel_release:
  pkg.installed:
    - pkgs:
      - epel-release
{% endif %}
testing_packages:
  pkg.installed:
    - pkgs:
      - zip
      - unzip
      - sudo
      - curl
      - wget
      - git
