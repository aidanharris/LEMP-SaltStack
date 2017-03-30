{% set dbuser = 'root' %}
{% set dbpass = salt['cmd.shell']('cat /srv/pillar/mysql.sls | grep -E "root_password: " | sed "s/.*: //g" | sed "s/ //g"') %}
wordpress:
    cli:
        source: https://github.com/wp-cli/wp-cli/releases/download/v1.1.0/wp-cli-1.1.0.phar
        hash: https://github.com/wp-cli/wp-cli/releases/download/v1.1.0/wp-cli-1.1.0.phar.sha512
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
