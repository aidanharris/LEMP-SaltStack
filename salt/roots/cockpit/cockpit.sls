{% from "firewall/disable-firewall.jinja" import firewall with context %}
include:
  - firewall
install_and_enable_cockpit:
  pkg.installed:
    - pkgs:
      - cockpit
  service.running:
    - name: cockpit
    - enable: True
  {% if firewall.disabled == False %}
  {% if pillar['firewall'] == 'firewalld' %}
  cmd.run:
    - name: |
        firewall-cmd --add-service=cockpit --permanent
        firewall-cmd --reload
  {% elif pillar['firewall'] == 'ufw' %}
  cmd.run:
    - name: |
        ufw allow cockpit
        ufw reload
  {% endif %}
  {% endif %}
