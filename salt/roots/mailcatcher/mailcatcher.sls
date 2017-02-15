{% if pillar['salt_env'] == 'development' %}
# This probably won't work on other OS's due to different packages.
# To Do:
#     * Fix me
mailcatcher_install_ruby_gems:
  pkg.installed:
    - pkgs:
      - ruby-devel
      - rubygems
      - gcc-c++
      - sqlite
      - sqlite-devel
      {% if grains['os'] == 'Fedora' %}
      - redhat-rpm-config
      {% endif %}
mailcatcher_install:
  cmd.run:
    - name: |
        gem install mailcatcher
mailcatcher_allow_web_access:
{% if pillar['firewall'] == 'firewalld' %}
  service.running:
    - name: firewalld
  cmd.run:
    - name: |
        firewall-cmd --permanent --zone=public --add-port=1080/tcp
        firewall-cmd --permanent --zone=public --add-port=1025/tcp
        firewall-cmd --reload
{% endif %}
mailcatcher_copy_systemd_unit:
  cmd.run:
    - name: cp /srv/salt/mailcatcher/mailcatcher.service /usr/lib/systemd/system
  service.running:
    - name: mailcatcher
    - enable: True
{% endif %}
