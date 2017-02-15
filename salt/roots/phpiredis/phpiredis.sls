include:
  - redis
  - php.ng.redis
phpiredis_dependencies:
  pkg.installed:
    - pkgs:
      - hiredis-devel
      - php-devel
      - git
      - make
      - gcc-c++
phpiredis_clone:
  cmd.run:
    - name: |
        cd /tmp
        git clone https://github.com/nrk/phpiredis.git /tmp/phpiredis || true
phpiredis_build:
  cmd.run:
    - name: |
        cd /tmp/phpiredis
        phpize && ./configure --enable-phpiredis
        make
phpiredis_install:
  cmd.run:
    - name: |
        cd /tmp/phpiredis
        make install
phpiredis_enable:
  cmd.run:
    - name: |
        bash -c 'printf "; Enable phpiredis extension module\nextension=phpiredis.so\n" > /etc/php.d/phpiredis.ini'
