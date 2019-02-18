
# Unix socket connection backlog size
net.core.somaxconn:
  sysctl.present:
    - value: 4096

# Maximum number of open files, system wide
fs.file-max:
  sysctl.present:
    - value: 2097152

# Per user hard and soft limits
/etc/security/limits.conf:
  file.append:
    - text:
      - "*         hard    nofile      500000"
      - "*         soft    nofile      500000"
      - "root      hard    nofile      500000"
      - "root      soft    nofile      500000"

Asia/Singapore:
  timezone.system

group_prometheus:
  group:
    - present
    - name: prometheus
    - system: True

user_prometheus:
  user:
    - present
    - name: prometheus
    - groups:
      - prometheus
    - home: /opt/prometheus
    - createhome: True
    - shell: /bin/false
    - system: True

ntp:
  pkg:
    - installed
  service:
    - name: ntp
    - running

ntp_conf:
  file.managed:
    - name: //etc/ntp.conf
    - source: salt://files/ntp.conf
    - user: root
    - group: root
    - mode: '644' 
           