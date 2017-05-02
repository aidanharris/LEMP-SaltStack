# https://github.com/saltstack-formulas/mysql-formula
{% set root_password = 'password' %}
mysql:
  server:
    root_password: {{ root_password }}
    mysqld:
      bind-address: 0.0.0.0
  database:
    - www
    - wordpress
  lookup:
    service: 'mariadb'
