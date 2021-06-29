./stop_server.sh
sudo rm -rf /data/zlz/tlsm/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data &&
time=$(date "+%Y%m%d-%H%M%S")
nohup iostat -d -k 5 > tlsm_$2_$3.log &
nohup /data/zlz/tlsm/apache-iotdb-0.12.1-SNAPSHOT-all-bin/sbin/start-server.sh > tlsm_$2_$3_server.log &
sleep 5
java -jar write_iotdb-1.0-SNAPSHOT.jar 127.0.0.1 6667 root.storage_group $1 > tlsm_$2_$3_write.log
/data/zlz/tlsm/apache-iotdb-0.12.1-SNAPSHOT-all-bin/sbin/start-cli.sh -e "flush"
sleep 5
