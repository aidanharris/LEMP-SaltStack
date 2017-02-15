install_openssl:
  pkg.installed:
    - pkgs:
      - openssl
{% if not salt['file.directory_exists' ]('/etc/ssl/private') %}
create_private_certificate_directory:
  file.directory:
    - user: root
    - name: /etc/ssl/private
{% endif %}
{% if not salt['file.directory_exists']('/etc/ssl/certs') %}
create_certs_certificate_directory:
  file.directory:
    - user: root
    - name: /etc/ssl/certs
{% endif %}
generate_certs:
  cmd.run:
    - name: openssl req -nodes -x509 -newkey rsa:4096 -keyout /etc/ssl/private/nginx-key.pem -out /etc/ssl/private/nginx-cert.crt -days 356 -subj "/C=/ST=/L=/O=/CN={{ salt['network.get_hostname']() }}"
generate_diffie_hellman:
  cmd.run:
    - name: openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
