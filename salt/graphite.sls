graphite:
  archive.extracted:
    - name: /opt/binaries
    - source: https://github.com/graphite-project/graphite-web/archive/master.zip
    - skip_verify: True
    - user: prometheus
    - group: prometheus
    - trim_output: 20
    - enforce_toplevel: False

bridge_binary:
  archive.extracted:
    - name: /opt/binaries
    - source: https://github.com/stuart-c/prometheus-graphite-bridge/archive/master.zip
    - skip_verify: True
    - user: prometheus
    - group: prometheus
    - trim_output: 20
    - enforce_toplevel: False

cmd-cli-install: 
  cmd.run: 
    - name: |
        pip install humanfriendly requests prometheus_client
        docker run -d --name graphite --restart=always -p 80:80 -p 2003-2004:2003-2004 -p 2023-2024:2023-2024 -p 8125:8125/udp -p 8126:8126 -v /opt/graphite/conf:/opt/graphite/conf -v /opt/graphite/storage:/opt/graphite/storage -v /opt/graphite/statsd/config:/opt/statsd/config -v /opt/graphite/log:/var/log graphiteapp/graphite-statsd 

bridge_copy:
  file.managed:
    - name: /opt/prometheus/bridge/prometheus-graphite-bridge.py
    - source: /opt/binaries/prometheus-graphite-bridge-master/prometheus-graphite-bridge.py
    - skip_verify: True
    - mode: '755'
    - user: prometheus
    - group: prometheus
    - makedirs: True

/opt/prometheus/bridge/bridge.sh:
  file.managed:  
    - contents:
        /opt/prometheus/bridge/prometheus-graphite-bridge.py --scrape-target http://localhost:9100/metrics --graphite-host localhost --scrape-interval 5 --graphite-port 2003 --graphite-prefix barani > /opt/prometheus/bridge/output.log 2>&1
    - user: prometheus
    - group: prometheus
    - mode: '755' 

#bridge_conf:
#  file.managed:
#    - name: /etc/init/bridge.conf
#    - source: salt://files/bridge.conf
#    - user: root
#    - group: root
#    - mode: '755'

bridge:
  file.managed:
    - name: /etc/init.d/bridge
    - source: salt://files/bridge.sh
    - user: root
    - group: root
    - mode: '755'

bridge_service:
  service:
    - running
    - name: bridge
    - enable: True

restart_bridge:
  cron.present:
    - name: service bridge restart
    - user: root
    - minute: 10
    - hour: '*'
    - daymonth: '*'
    - month: '*'
    - dayweek: '*'
   