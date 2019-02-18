grafana:
  pkg.installed:
    - sources:
      - grafana: https://dl.grafana.com/oss/release/grafana_5.4.3_amd64.deb

grafana-server:
  service.running:
    - enable: True
    - reload: True

graphite_dashboard:
  file.managed:
    - name: /opt/binaries/graphite.json
    - source: salt://files/graphite.json
    - user: root
    - group: root
    - mode: '755'

prometheus_dashboard:
  file.managed:
    - name: /opt/binaries/prometheus.json
    - source: salt://files/prometheus.json
    - user: root
    - group: root
    - mode: '755'


cmd-install: 
  cmd.run: 
    - name: |
        until nc -z localhost 3000; do sleep 1; done
        curl -X PUT -H "Content-Type: application/json" -d '{ "oldPassword": "admin", "newPassword": "pass123", "confirmNew": "pass123" }' http://admin:admin@localhost:3000/api/user/password
        curl --user admin:pass123 'http://localhost:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"Graphite","isDefault":true ,"type":"graphite","url":"http://localhost:80","access":"proxy","basicAuth":false}](http://localhost:9090%22,%22access%22:%22proxy%22,%22basicAuth%22:false%7D)'
        curl -k -X POST http://localhost:3000/api/dashboards/db -H 'Content-Type: application/json' -H 'Accept: application/json' --user admin:pass@123 -d "$(cat /opt/binaries/graphite.json)"
        curl --user admin:pass123 'http://localhost:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"Prometheus","isDefault":true ,"type":"prometheus","url":"http://localhost:9090","access":"proxy","basicAuth":false}](http://localhost:9090%22,%22access%22:%22proxy%22,%22basicAuth%22:false%7D)'
        curl -k -X POST http://localhost:3000/api/dashboards/db -H 'Content-Type: application/json' -H 'Accept: application/json' --user admin:pass123 -d "$(cat /opt/binaries/prometheus.json)"



