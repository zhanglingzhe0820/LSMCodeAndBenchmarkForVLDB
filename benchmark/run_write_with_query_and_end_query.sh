#!/bin/bash
echo "===lsm=="
for delta in 50 10; do
  for mu in 4.0 5.0; do
    for sigma in 1.5 1.75 2.0; do
      for query_length in 500 1000 5000; do
        echo "${delta}_${mu}_${sigma}_${query_length}"
        cp lsm_compaction.properties ../iotdb-without_seperation_policy_no_deletion/apache-iotdb-0.12.1-SNAPSHOT-all-bin/conf/iotdb-engine.properties
        ./run_lsm_with_query.sh ${delta} ${mu} ${sigma} ${query_length}
        old_compaction_log_status="`ls -l ../iotdb-without_seperation_policy_no_deletion/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data/data/unsequence/root.sg1/0/0/ | wc -l`"
        while [[ true ]]; do
            sleep 10s
            new_compaction_log_status="`ls -l ../iotdb-without_seperation_policy_no_deletion/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data/data/unsequence/root.sg1/0/0/ | wc -l`"
            if [[ `echo ${old_compaction_log_status}` == `echo ${new_compaction_log_status}` ]]; then
                break
            fi
            old_compaction_log_status=$new_compaction_log_status
        done
        sleep 5
      done
    done
  done
done

echo "===tlsm=="
for delta in 50 10; do
  for mu in 4.0 5.0; do
    for sigma in 1.5 1.75 2.0; do
      for query_length in 500 1000 5000; do
        echo "${delta}_${mu}_${sigma}_${query_length}"
        cp tlsm_compaction.properties ../iotdb-with_seperation_policy_no_deletion/apache-iotdb-0.12.1-SNAPSHOT-all-bin/conf/iotdb-engine.properties
        ./run_tlsm_with_query.sh ${delta} ${mu} ${sigma} ${query_length}
        old_compaction_log_status="`ls -l ../iotdb-with_seperation_policy_no_deletion/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data/data/unsequence/root.sg1/0/0/ | wc -l`"
        while [[ true ]]; do
            sleep 10s
            new_compaction_log_status="`ls -l ../iotdb-with_seperation_policy_no_deletion/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data/data/unsequence/root.sg1/0/0/ | wc -l`"
            if [[ `echo ${old_compaction_log_status}` == `echo ${new_compaction_log_status}` ]]; then
                break
            fi
            old_compaction_log_status=$new_compaction_log_status
        done
        sleep 5
      done
    done
  done
done
