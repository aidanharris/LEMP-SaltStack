include:
  - firewall
install_and_enable_cockpit:
  pkg.installed:
    - pkgs:
      - cockpit
  service.running:
    - name: cockpit
    - enable: True
  cmd.run:
    - name: |
        sudo firewall-cmd --add-service=cockpit --permanent
        sudo firewall-cmd --reload
