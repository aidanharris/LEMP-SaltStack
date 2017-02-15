{% set firewall = {
  'RedHat': 'firewalld',
  'Debian': 'ufw',
  'Arch': 'ufw'
}.get(grains.os_family) %}

include:
  - firewall.{{ firewall }}
