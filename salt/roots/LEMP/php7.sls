{% if grains['os_family'] == 'RedHat' and grains['os'] != 'Fedora' %}
install_and_enable_remirepo_repository_for_php7:
  pkg.installed:
    - pkgs:
      - wget
  cmd.run:
    - name: |
        wget -O /tmp/remi-release-7.rpm http://rpms.remirepo.net/enterprise/remi-release-7.rpm
        rpm -Uvh /tmp/remi-release-7.rpm
        yum-config-manager --enable remi-php70
refresh_remirepo:
  module.run:
    - name: pkg.refresh_db
upgrade_packages_from_remirepo:
  module.run:
    - name: pkg.upgrade
{% endif %}
