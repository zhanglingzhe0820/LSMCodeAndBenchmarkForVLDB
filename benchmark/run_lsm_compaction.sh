./stop_server.sh
time=$(date "+%Y%m%d-%H%M%S")
nohup ../iotdb-without_seperation_policy/apache-iotdb-0.12.1-SNAPSHOT-all-bin/sbin/start-server.sh > lsm_compaction_$1_$2_$3_server.log &