# Setup zsh with oh-my-zsh because it's the best shell in the world :)
# To Do:
#   * Don't make assumptions about a users home directory
{% for user in pillar['ohmyzsh'] %}
{% if not salt['file.directory_exists']('/home/' + user + '/.oh-my-zsh') or (user == 'root' and not salt['file.directory_exists']('/' + user + '/.oh-my-zsh')) %}
{% if user == 'root' %}
  {% set HOME = '/root' %}
{% else %}
  {% set HOME = '/home/' + user %}
{% endif %}
{% if salt['pillar.get']('zshTheme') %}
    {% set zshtheme = pillar['zshTheme'] %}
{% else %}
  {% set zshtheme = 'agnoster' %}
{% endif %}
ohmyzsh_{{ user }}:
  cmd.run:
    - name: |
        sudo su {{ user }} bash -c "set -e; cd {{ HOME }}; curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh > ./install.sh && chmod +x ./install.sh && sed -i 's/.*env zsh//g' ./install.sh && ./install.sh && rm ./install.sh && exit" &> /dev/null 2&>1
        sudo su {{ user }} bash -c 'set -e; cd {{ HOME }}; sed -i "s/robbyrussell/{{ zshtheme }}/g" ./.zshrc && exit'
        chsh {{ user }} -s /bin/zsh
    - cwd: {{ HOME }}
{% endif %}
{% endfor %}
