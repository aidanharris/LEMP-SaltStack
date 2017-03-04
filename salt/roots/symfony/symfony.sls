{% if not salt['file.file_exists']('/usr/local/bin/symfony') %}
install_dependencies:
  pkg.installed:
    - pkgs:
      - curl
install_symfony:
  cmd.run:
    - name: |
        curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
        chmod a+x /usr/local/bin/symfony
{% endif %}


