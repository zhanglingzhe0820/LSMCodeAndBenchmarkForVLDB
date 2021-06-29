raw_file_size=$((`cat $1 | wc -l` * 24))
total_io=$((`python io_analyzer.py $2` * 1024))
echo "raw_size:${raw_file_size}"
echo "total_io:${total_io}"
ratio=`echo "scale=2; $total_io/$raw_file_size" | bc`
echo "amplification ratio:${ratio}"
