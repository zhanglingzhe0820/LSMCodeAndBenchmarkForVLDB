#!/bin/bash
data_file_list=(data_for_iotdb_ty_10000000_50.csv data_for_iotdb_ty_10000000_100.csv data_for_iotdb_ty_10000000_500.csv data_for_iotdb_ty_10000000_1000.csv data_for_iotdb_ty_10000000_5000.csv)
point_num_list=(10000000 10000000 10000000 10000000 10000000)
time_interval_list=(50 100 500 1000 5000)
tlsm_list=(1000 2000 3000 4000)
for i in 3 4; do
    echo "${point_num_list[i]}_${time_interval_list[i]}"
    cp lsm_write.properties /data/zlz/lsm/apache-iotdb-0.12.1-SNAPSHOT-all-bin/conf/iotdb-engine.properties
    ./run_lsm.sh ${data_file_list[i]} ${point_num_list[i]} ${time_interval_list[i]}
    du -smh /data/zlz/lsm/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data
    cp lsm_compaction.properties /data/zlz/lsm/apache-iotdb-0.12.1-SNAPSHOT-all-bin/conf/iotdb-engine.properties
    ./run_lsm_compaction.sh ${point_num_list[i]} ${time_interval_list[i]} &&
    old_compaction_log_status="`ls -l /data/zlz/lsm/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data/data/unsequence/root.storage_group/0/0/ | wc -l`"
    while [[ true ]]; do
        sleep 10s
        new_compaction_log_status="`ls -l /data/zlz/lsm/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data/data/unsequence/root.storage_group/0/0/ | wc -l`"
        if [[ `echo ${old_compaction_log_status}` == `echo ${new_compaction_log_status}` ]]; then
            break
        fi
        old_compaction_log_status=$new_compaction_log_status
    done
    sleep 5
    ./query_lsm.sh ${point_num_list[i]} ${time_interval_list[i]}
    du -smh /data/zlz/lsm/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data
done
