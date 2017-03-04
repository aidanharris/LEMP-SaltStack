# To Do:
#   * Alter the config so that it's inline with the default PHP config and tweak things as necessary
# https://github.com/saltstack-formulas/php-formula
{% set phpVersion = 7 %}
phpVersion: 7
{% set mailcatcher = True %}
mailcatcher: {{ mailcatcher }}
php:
  ng:
    fpm:
      pools:
        'www.conf':
          enabled: True
          settings:
            www:
              user: nginx
              group: nginx
              listen: /run/php-fpm/php{{ phpVersion }}-fpm.sock
              listen.owner: nginx
              listen.group: nginx
              pm: dynamic
              pm.max_children: 5
              pm.start_servers: 2
              pm.min_spare_servers: 1
              pm.max_spare_servers: 3
              security.limit_extensions: .php
    ini:
      defaults:
        PHP:
          display_errors: On
          display_startup_errors: On
          # pcntl_fork has been removed from the disabled functions as Symfony needs it
          # If you do not need to use this function you may consider adding it back!
          disable_functions: pcntl_alarm,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority
          {% if mailcatcher %}
          sendmail_path: /usr/local/bin/catchmail -f mail@localhost
          {% endif %}
          cgi.fix_pathinfo: 1
        Date:
          date.timezone: Europe/London
        Session:
          session.cookie_lifetime: 3600
          session.save_handler: redis
          session.save_path: '"tcp://127.0.0.1:6379?weight=1&persistent=1"'
