{% if not salt['file.directory_exists']('/opt/n') %}
install_dependencies:
  pkg.installed:
    - pkgs:
      - curl
      - git
      - make
install_nodejs:
  cmd.run:
    - name: curl -s -L https://git.io/n-install | N_PREFIX=/opt/n bash -s -- -y lts
{% else %}
already_installed:
  cmd.run:
    - name: echo "Nodejs is already installed into /opt/n"
{% endif %}
