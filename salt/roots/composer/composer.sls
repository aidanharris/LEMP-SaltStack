include:
  - php.ng.composer
{% if not salt['file.file_exists']('/var/www/composer.json') %}
composer_init:
  cmd.run:
    - name: composer init -n
    - cwd: /var/www
{% endif %}
composer_install:
  cmd.run:
    - name: composer install
    - cwd: /var/www
composer_update:
  cmd.run:
    - name: composer update
    - cwd: /var/www
