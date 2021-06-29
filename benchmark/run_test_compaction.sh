data_file_list=(data_for_iotdb_ty_100000000_1000.csv data_for_iotdb_ty_100000000_100.csv data_for_iotdb_ty_100000000_500.csv data_for_iotdb_ty_100000000_50.csv data_for_iotdb_ty_10000000_1000.csv data_for_iotdb_ty_10000000_100.csv data_for_iotdb_ty_10000000_500.csv data_for_iotdb_ty_10000000_50.csv)
point_num_list=(10000000 10000000 100000000 100000000 10000000 10000000 10000000 10000000)
time_interval_list=(1000 100 500 50 1000 100 500 50)

for i in 0; do
    cp lsm_compaction.properties /data/zlz/lsm/apache-iotdb-0.12.1-SNAPSHOT-all-bin/conf/iotdb-engine.properties
    ./run_lsm_compaction.sh ${point_num_list[i]} ${time_interval_list[i]} &&
    old_compaction_log_status="`stat lsm_compaction_${point_num_list[i]}_${time_interval_list[i]}_server.log|grep Modify`"
    while [[ true ]]; do
        sleep 2s
        new_compaction_log_status="`stat lsm_compaction_${point_num_list[i]}_${time_interval_list[i]}_server.log|grep Modify`"
        echo $new_compaction_log_status
        if [[ `echo ${old_compaction_log_status}` == `echo ${new_compaction_log_status}` ]]; then
            break
        fi
        old_compaction_log_status=new_compaction_log_status
    done
    echo "${point_num_list[i]}_${time_interval_list[i]}"
    ./analyze_io.sh ${data_file_list[i]} lsm_${point_num_list[i]}_${time_interval_list[i]}.log
done
