# ========
# nginx.ng
# ========
# https://github.com/saltstack-formulas/nginx-formula
# To Do:
#     * Find away of removing the duplication of phpVersion in the nginx and php pillars.
{% from "php.sls" import phpVersion as phpVersion %}
nginx:
  ng:
    # PPA install
    install_from_ppa: True
    # Set to 'stable', 'development' (mainline), 'community', or 'nightly' for each build accordingly ( https://launchpad.net/~nginx )
    ppa_version: 'stable'

    # Source compilation is not currently a part of nginx.ng
    from_source: False

    lookup:
      server_available: /etc/nginx/sites-available
      server_enabled: /etc/nginx/sites-enabled
      server_use_symlink: True

    source:
      opts: {}

    package:
      opts: {} # this partially exposes parameters of pkg.installed

    service:
      enable: True # Whether or not the service will be enabled/running or dead
      opts: {} # this partially exposes parameters of service.running / service.dead

    server:
      opts: {} # this partially exposes file.managed parameters as they relate to the main nginx.conf file

      # nginx.conf (main server) declarations
      # dictionaries map to blocks {} and lists cause the same declaration to repeat with different values
      config:
        worker_processes: 4
        pid: /run/nginx.pid
        events:
          worker_connections: 768
        http:
          sendfile: 'on'
          include:
            - /etc/nginx/mime.types
            - /etc/nginx/conf.d/*.conf
            - /etc/nginx/sites-enabled/*

    servers:
      disabled_postfix: .disabled # a postfix appended to files when doing non-symlink disabling
      symlink_opts: {} # partially exposes file.symlink params when symlinking enabled sites
      rename_opts: {} # partially exposes file.rename params when not symlinking disabled/enabled sites
      managed_opts: {} # partially exposes file.managed params for managed server files
      dir_opts: {} # partially exposes file.directory params for site available/enabled dirs

      # server declarations
      # servers will default to being placed in server_available
      managed:
        www: # relative pathname of the server file
          # may be True, False, or None where True is enabled, False, disabled, and None indicates no action
          available_dir: /etc/nginx/sites-available # an alternate directory (not sites-available) where this server may be found
          enabled_dir: /etc/nginx/sites-enabled # an alternate directory (not sites-enabled) where this server may be found
          enabled: True
          overwrite: True # overwrite an existing server file or not
          # May be a list of config options or None, if None, no server file will be managed/templated
          # Take server directives as lists of dictionaries. If the dictionary value is another list of
          # dictionaries a block {} will be started with the dictionary key name
          config:
            - server:
              - server_name: www.localdomain localhost 127.0.0.1
              - listen:
                - 80
              - return: 301 https://$host$request_uri
            - server:
              - listen:
                - 443 ssl http2
              - server_name: www.localdomain localhost 127.0.0.1
              - ssl_certificate: /etc/ssl/private/nginx-cert.crt
              - ssl_certificate_key: /etc/ssl/private/nginx-key.pem
              # Uncomment for letsencrypt after configuring...
              #- ssl_certificate: /etc/letsencrypt/live/my.tld/fullchain.pem
              #- ssl_certificate_key: /etc/letsencrypt/live/my.tld/privkey.pem
              - ssl_protocols: TLSv1 TLSv1.1 TLSv1.2
              - ssl_prefer_server_ciphers: "on"
              - ssl_dhparam: /etc/ssl/certs/dhparam.pem
              - ssl_ciphers: 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA'
              - ssl_session_timeout: 1d
              - ssl_session_cache: shared:SSL:50m
              - ssl_stapling: "on"
              - ssl_stapling_verify: "on"
              - add_header: Strict-Transport-Security "max-age=15768000; includeSubDomains" always
              - root: /var/www/html/sitename
              - index:
                - index.php
                - index.html
                - index.htm
              - location ~* \.(?:svg|gif|png|html|css|js|ttf|woff|ico|jpg|jpeg)$:
                - try_files: $uri $uri/ =404
              - location ~ /(docs):
                - try_files: $uri $uri/ =404
              - location ~ \.php$:
                - fastcgi_split_path_info: ^(.+\.php)(/.+)$
                - fastcgi_pass: unix:/run/php-fpm/php{{ phpVersion }}-fpm.sock
                - fastcgi_index: index.php
                - include: fastcgi.conf
              - location /phpMyAdmin:
                - root: /usr/share/
                - index: index.php
                - location ~ ^/phpMyAdmin/(.+\.php)$:
                  - try_files: $uri =404
                  - root: /usr/share/
                  - fastcgi_pass: unix:/run/php-fpm/php{{ phpVersion }}-fpm.sock
                  - fastcgi_index: index.php
                  - fastcgi_param: SCRIPT_FILENAME $document_root$fastcgi_script_name
                  - include: /etc/nginx/fastcgi_params
                - location ~* ^/phpMyAdmin/(.+\.(jpg|jpeg|gif|css|png|js|json|ico|html|xml|txt))$:
                  - root: /usr/share/
              - location /phpmyadmin:
                - rewrite: ^/* /phpMyAdmin last
          # The above outputs:
          # server {
          #    server_name localhost;
          #    listen 80 default_server;
          #    index index.html index.htm;
          #    location ~ .htm {
          #        try_files $uri $uri/ =404;
          #        test something else;
          #    }
          # }
