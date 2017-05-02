{% set dbuser = 'root' %}
{% from "mysql.sls" import root_password as dbpass %}

wordpress:
    lookup:
        www_group: root
        www_user: root
    cli:
        source: https://github.com/wp-cli/wp-cli/releases/download/v1.1.0/wp-cli-1.1.0.phar
        hash: https://github.com/wp-cli/wp-cli/releases/download/v1.1.0/wp-cli-1.1.0.phar.sha512
        allowroot: True
    sites:
        sitename:
          username: admin
          password: admin
          database: wordpress
          dbuser: {{ dbuser }}
          dbpass: {{ dbpass }}
          dbhost: localhost
          url: https://www.localdomain
          title: 'Just another Wordpress site'
          email: 'mail@example.com'
