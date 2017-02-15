install_and_enable_redis:
  pkg.installed:
    - pkgs:
      - redis
  service.running:
    - name: redis
    - enable: true
configure_redis:
  cmd.run:
    # Enable Append-only- file for strong consistency / data integrity (See: https://redis.io/topics/persistence)
    - name: |
        sed -i 's/appendonly no/appendonly yes/g' /etc/redis.conf
restart_redis:
  module.run:
    - name: service.restart
    - m_name: redis
