#!/bin/bash
echo "===lsm=="
for delta in 50 10; do
  for mu in 4.0 5.0; do
    for sigma in 1.5 1.75 2.0; do
      echo "${delta}_${mu}_${sigma}"
      cp lsm_compaction.properties ../iotdb-without_seperation_policy_no_deletion/apache-iotdb-0.12.1-SNAPSHOT-all-bin/conf/iotdb-engine.properties
      ./run_lsm_with_deletion.sh ${delta} ${mu} ${sigma}
      sleep 5
      du -smh ../iotdb-without_seperation_policy_no_deletion/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data
    done
  done
done

echo "===tlsm=="
for delta in 50 10; do
  for mu in 4.0 5.0; do
    for sigma in 1.5 1.75 2.0; do
      echo "${delta}_${mu}_${sigma}"
      cp tlsm_compaction.properties ../iotdb-with_seperation_policy_no_deletion/apache-iotdb-0.12.1-SNAPSHOT-all-bin/conf/iotdb-engine.properties
      ./run_tlsm_with_deletion.sh ${delta} ${mu} ${sigma}
      sleep 5
      du -smh ../iotdb-with_seperation_policy_no_deletion/apache-iotdb-0.12.1-SNAPSHOT-all-bin/data
    done
  done
done
