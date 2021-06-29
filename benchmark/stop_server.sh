iotdb_pids=`lsof -t -i:6667`
write_pids=`pgrep write_iotdb-1.0-SNAPSHOT.jar`
iostat_pids=`pgrep iostat`
jps_pids=`jps -q`
echo '601tif'|sudo -S kill -9 ${write_pids}
echo '601tif'|sudo -S kill -9 ${iotdb_pids}
echo '601tif'|sudo -S kill -9 ${iostat_pids}
echo '601tif'|sudo -S kill -9 ${jps_pids}
