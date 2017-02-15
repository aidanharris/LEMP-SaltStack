include:
  - common.packages

{% if pillar['salt_env'] == 'development' %}
# Set SELinux to permissive in a development environment - i.e monitor but don't enforce
{% if pillar['selinux'] and salt['file.file_exists']('/etc/selinux/config') %}
{% set regex = "'s/SELINUX=.*/SELINUX=" + pillar['selinux'] + "/g'" %}
disableSELinux:
  cmd.run:
    - name: |
        setenforce permissive
        sed -i {{ regex }} /etc/selinux/config
{% endif %}
{% endif %}
