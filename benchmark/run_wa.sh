#!/bin/bash
echo "===lsm=="
for delta in 10; do
  for mu in 4.0 5.0; do
    for sigma in 1.0 1.25 1.5 1.75 2.0; do
      echo "${delta}_${mu}_${sigma}"
      cp lsm_write.properties ../iotdb-without_seperation_policy/apache-iotdb-0.12.1-SNAPSHOT-all-bin/conf/iotdb-engine.properties
      ./run_lsm.sh ${delta} ${mu} ${sigma}
      du -smh ../iotdb-without_seperation_policy/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data
      cp lsm_compaction.properties ../iotdb-without_seperation_policy/apache-iotdb-0.12.1-SNAPSHOT-all-bin/conf/iotdb-engine.properties
      ./run_lsm_compaction.sh ${delta} ${mu} ${sigma} &&
      old_compaction_log_status="`ls -l ../iotdb-without_seperation_policy/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data/data/unsequence/root.sg1/0/0/ | wc -l`"
      while [[ true ]]; do
          sleep 10s
          new_compaction_log_status="`ls -l ../iotdb-without_seperation_policy/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data/data/unsequence/root.sg1/0/0/ | wc -l`"
          if [[ `echo ${old_compaction_log_status}` == `echo ${new_compaction_log_status}` ]]; then
              break
          fi
          old_compaction_log_status=$new_compaction_log_status
      done
      sleep 5
      du -smh ../iotdb-without_seperation_policy/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data
    done
  done
done

echo "===tlsm=="
for delta in 10; do
  for mu in 4.0 5.0; do
    for sigma in 1.0 1.25 1.5 1.75 2.0; do
      echo "${delta}_${mu}_${sigma}"
      cp tlsm_write.properties ../iotdb-with_seperation_policy/apache-iotdb-0.12.1-SNAPSHOT-all-bin/conf/iotdb-engine.properties
      ./run_tlsm.sh ${delta} ${mu} ${sigma}
      du -smh ../iotdb-with_seperation_policy/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data
      cp lsm_compaction.properties ../iotdb-with_seperation_policy/apache-iotdb-0.12.1-SNAPSHOT-all-bin/conf/iotdb-engine.properties
      ./run_tlsm_compaction.sh ${delta} ${mu} ${sigma} &&
      old_compaction_log_status="`ls -l ../iotdb-with_seperation_policy/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data/data/unsequence/root.sg1/0/0/ | wc -l`"
      while [[ true ]]; do
          sleep 10s
          new_compaction_log_status="`ls -l ../iotdb-with_seperation_policy/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data/data/unsequence/root.sg1/0/0/ | wc -l`"
          if [[ `echo ${old_compaction_log_status}` == `echo ${new_compaction_log_status}` ]]; then
              break
          fi
          old_compaction_log_status=$new_compaction_log_status
      done
      sleep 5
      du -smh ../iotdb-with_seperation_policy/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data
    done
  done
done