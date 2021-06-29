./stop_server.sh
time=$(date "+%Y%m%d-%H%M%S")
nohup iostat -d -k 5 > lsm_compaction_$1_$2.log &
nohup /data/zlz/lsm/apache-iotdb-0.12.1-SNAPSHOT-all-bin/sbin/start-server.sh > lsm_compaction_$1_$2_server.log &
