./stop_server.sh
sudo rm -rf ../iotdb-without_seperation_policy_no_deletion/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data &&
time=$(date "+%Y%m%d-%H%M%S")
nohup ../iotdb-without_seperation_policy_no_deletion/apache-iotdb-0.12.1-SNAPSHOT-all-bin/sbin/start-server.sh > lsm_$1_$2_$3_$4_server.log &
sleep 5
csv_path="mu-${2}-sigma-${3}-interval-${1}-num-1000000.csv"
java -jar -Djava.ext.dirs=../iotdb-with_seperation_policy/apache-iotdb-0.12.1-SNAPSHOT-all-bin/lib write_while_query.jar ${csv_path} $4 100
../iotdb-without_seperation_policy_no_deletion/apache-iotdb-0.12.1-SNAPSHOT-all-bin/sbin/start-cli.sh -e "flush"
sleep 5