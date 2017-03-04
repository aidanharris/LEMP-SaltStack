{% from "firewall/disable-firewall.jinja" import firewall with context %}
{% if pillar['salt_env'] == 'development' %}
{% set root_password=pillar['mysql']['server']['root_password'] %}
create_remote_root_user:
  cmd.run:
    - name: |
        mysql -uroot -p'{{root_password}}' --execute="CREATE USER 'root'@'%' IDENTIFIED BY '{{root_password}}';"
grant_all_privileges_to_remote_root_user:
  cmd.run:
    - name: |
        mysql -uroot -p'{{root_password}}' --execute="GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
flush_mysql_privileges:
  cmd.run:
    - name: |
        mysql -uroot -p'{{root_password}}' --execute="FLUSH PRIVILEGES;"
restart_mysqld:
  module.run:
    - name: service.restart
    - m_name: {{pillar['mysql']['lookup']['service']}}
{% if firewall.disabled == False %}
allow_remote_access:
  {% if pillar['firewall'] == 'firewalld' %}
  cmd.run:
    - name: |
        sudo firewall-cmd --permanent --zone=public --add-port 3306/tcp
        sudo firewall-cmd --reload
  {% elif pillar['firewall'] == 'ufw' %}
  cmd.run:
    - name: |
        sudo ufw allow mysql
        sudo ufw reload
  {% endif %}
{% endif %}
{% else %}
refusing_to_run_in_production_environment:
  cmd.run:
    - name: |
        echo "Refusing to run in a production environment" | logger -s
        exit 0
{% endif %}
