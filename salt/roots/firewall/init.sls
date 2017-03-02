{% from "firewall/disable-firewall.jinja" import firewall with context %}
{% if firewall.disabled == False %}
{% set firewall = {
  'RedHat': 'firewalld',
  'Debian': 'ufw',
  'Arch': 'ufw'
}.get(grains.os_family) %}

include:
  - firewall.{{ firewall }}
{% endif %}
