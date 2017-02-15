install_and_enable_firewalld:
  pkg.installed:
    - pkgs:
      - firewalld
  service.running:
    - name: firewalld
    - enable: True
    - reload: True
