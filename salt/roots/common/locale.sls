generate_locales:
  cmd.run:
    - name: sh -c 'localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || true &> /dev/null 2>&1'
