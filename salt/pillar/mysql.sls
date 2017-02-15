# https://github.com/saltstack-formulas/mysql-formula
mysql:
  server:
    root_password: 'password'
    mysqld:
      bind-address: 0.0.0.0
  database:
    - www
  lookup:
    service: 'mariadb'
