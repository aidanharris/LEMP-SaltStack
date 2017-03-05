{% set project = "myProject" %}
{% if not salt['file.directory_exists']('/var/www/' + project) %}
create_project:
  cmd.run:
    - name: |
        /usr/local/bin/symfony new {{ project }}
        cd {{ project }}
        sed -i 's/^    header(/    \/\/header(/g' /var/www/{{ project }}/web/app_dev.php
        sed -i 's/^    exit(/    \/\/exit(/g' /var/www/{{ project }}/web/app_dev.php
    - cwd: /var/www
{% endif %}


