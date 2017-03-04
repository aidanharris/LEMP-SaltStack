{% from "firewall/disable-firewall.jinja" import firewall with context %}

{% set pkg = {
  'RedHat': 'firewalld',
  'Debian': 'ufw',
  'Arch': 'ufw'
}.get(grains.os_family) %}

{% if firewall.disabled == False %}
include:
  - firewall.{{ pkg }}
{% else %}
disable_firewall:
  module.run:
    - name: service.disabled
    - m_name: service.disabled
    - kwargs: {{ pkg }}
{% endif %}
