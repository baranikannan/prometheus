#! /bin/sh 
### BEGIN INIT INFO
# Provides: prometheus-graphite-bridge
# Required-Start: $remote_fs $syslog
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: prometheus-graphite-bridge
# Description: This file starts and stops prometheus-graphite-bridge process
# 
### END INIT INFO

BRIDGE_DIR=/opt/prometheus/bridge
PID=$(ps -ef | grep prometheus-graphite-bridge.py | grep -v grep | awk {'print $2'})


case "$1" in
 start)
   if [ -z $PID ]; then
   $BRIDGE_DIR/bridge.sh &
   echo $(ps aux | grep 'prometheus-graphite-bridge.py' | grep -v grep | awk '{print $2}') > $BRIDGE_DIR/bridge.pid 
   else echo 'Already Running' $PID ;fi
   ;;
 stop)
   kill -9 $PID
   echo "bridge stopped"
   ;;
 status)
   if [ -z $PID ]; then  echo 'bridge Not running'; else  echo 'Running' $PID ;fi
   ;;   
 restart)
   if [ -z $PID ]; then  echo 'bridge Not running'; else  kill -9 $PID ; echo stopped ;fi
   sleep 2 
   $BRIDGE_DIR/bridge.sh &
   echo $(ps aux | grep 'prometheus-graphite-bridge.py' | grep -v grep | awk '{print $2}') > $BRIDGE_DIR/bridge.pid
   echo started $(ps aux | grep 'prometheus-graphite-bridge.py' | grep -v grep | awk '{print $2}')
   ;;
 *)
   echo "Usage: bridge {start|stop|status|restart}" >&2
   exit 3
   ;;
esac
