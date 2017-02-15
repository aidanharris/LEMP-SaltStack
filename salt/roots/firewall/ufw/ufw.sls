install_and_enable_ufw:
  pkg.installed:
    - pkgs:
      - ufw
  service.running:
    - name: ufw
    - enable: True
