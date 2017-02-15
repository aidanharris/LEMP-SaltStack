{% for dir in ['/etc/nginx/sites-enabled', '/etc/nginx/sites-available'] %}
{{ dir }}:
  file.directory:
      - name: {{ dir }}
      - user: root
      - group: root
      - mode: 755
      - makedirs: True
      - recurse:
        - user
        - group
        - mode
{% endfor %}
