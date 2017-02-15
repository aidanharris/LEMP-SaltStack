{% if pillar['salt_env'] == 'development' %}
phpMyAdmin_install:
  pkg.installed:
    - pkgs:
      - phpMyAdmin
phpMyAdmin_restart_phpFPM:
  cmd.run:
    - name: systemctl restart php-fpm
{% endif %}
