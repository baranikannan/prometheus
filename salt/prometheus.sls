server-download:
  archive.extracted:
    - name: /opt/prometheus
    - source: https://github.com/prometheus/prometheus/releases/download/v2.7.1/prometheus-2.7.1.linux-amd64.tar.gz
    - skip_verify: True
    - user: prometheus
    - group: prometheus
    - trim_output: 20

node-download:
  archive.extracted:
    - name: /opt/prometheus
    - source: https://github.com/prometheus/node_exporter/releases/download/v0.17.0/node_exporter-0.17.0.linux-amd64.tar.gz
    - skip_verify: True
    - user: prometheus
    - group: prometheus
    - trim_output: 20 
    
install: 
  cmd.run: 
    - name: |
        mv /opt/prometheus/prometheus-2.7.1.linux-amd64 /opt/prometheus/server
        mv /opt/prometheus/node_exporter-0.17.0.linux-amd64  /opt/prometheus/node

config_replace:
  file.managed:
    - name: /opt/prometheus/server/prometheus.yml
    - source: salt://files/prometheus.yml
    - user: prometheus
    - group: prometheus
    - mode: '644'        

server_start:
  file.managed:
    - name: /etc/init.d/prometheus
    - source: salt://files/server.sh
    - user: root
    - group: root
    - mode: '755'

node_start:
  file.managed:
    - name: /etc/init.d/prometheus_node
    - source: salt://files/node.sh
    - user: root
    - group: root
    - mode: '755'

prometheus_server_service:
  service:
    - running
    - name: prometheus
    - enable: True

prometheus_node_service:
  service:
    - running
    - name: prometheus_node
    - enable: True