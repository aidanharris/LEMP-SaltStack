{% from "firewall/disable-firewall.jinja" import firewall with context %}
include:
  - mysql
  - remote-mysql
  - LEMP.create-site-directories
  - nginx.ng
  - php.ng
  - php.ng.mysqlnd
  {% if pillar['salt_env'] == 'development' %}
  - php.ng.xdebug
  {% endif %}
  - php.ng.xml
  - php.ng.mbstring
  - php.ng.redis
  - php.ng.fpm
# CentOS / RHEL ships with an older version
# of php (5.1.6) so we need to add a third-party
# repository to upgrade to PHP 7.
{% if grains['os'] == 'CentOS' or grains['os'] == 'RedHat' %}
  - LEMP.php7
{% endif %}
enable_phpFpm:
  service.running:
    - name: php-fpm
    - enable: True
enable_nginx:
  service.running:
    - name: nginx
    - enable: True
{% if firewall.disabled == False %}
allow_web_access:
  {% if pillar['firewall'] == 'firewalld' %}
  cmd.run:
    - name: |
        sudo firewall-cmd --add-service=http --zone=public --permanent
        sudo firewall-cmd --add-service=https --zone=public --permanent
        sudo firewall-cmd --reload
  {% elif pillar['firewall'] == 'ufw' %}
  cmd.run:
    - name: |
        sudo ufw allow http
        sudo ufw allow https
        sudo ufw reload
  {% endif %}
{% endif %}
