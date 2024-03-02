#!/bin/bash

result_folder="results/new_results_feb27/"
declare -a res_time
# declare -A res_goodput
# declare -A Timeout

touch result_height result_vid
echo "hgt con tt gp minrtt avgrtt maxrtt" > result_height
echo "hgt con tt gp minrtt avgrtt maxrtt" > result_vid

for hnum in 3 5 7 9;
do
    height="height"$hnum
    for consumer in $(ls $result_folder/$height); do
        # each of these height will have 2...14 consumers
        log_file_h=$result_folder$height/$consumer/*/chunk_cipher_Height-$hnum.txt_height_*.log
        res_time=$(cat $log_file_h | grep "Time el" | awk '{ sum += $3 } END { if (NR > 0) print sum / NR }')
        res_goodput=$(cat $log_file_h | grep "Good" | awk '{ if ($3 ~ /Mbit/) {a=$2*1020} else {a=$2}; sum += a} END { if (NR > 0) print sum / NR}')
        
        res_rtt_min=$(cat $log_file_h | grep RTT | awk '{split($4,a,"/"); sum+=a[1];} END {if (NR > 0) print sum / NR}')
        res_rrt_avg=$(cat $log_file_h | grep RTT | awk '{split($4,a,"/"); sum+=a[2];} END {if (NR > 0) print sum / NR}')
        res_rrt_max=$(cat $log_file_h | grep RTT | awk '{split($4,a,"/"); sum+=a[3];} END {if (NR > 0) print sum / NR}')

        echo $height $consumer $res_time $res_goodput $res_rtt_min $res_rrt_avg $res_rrt_max >> result_height

        log_file_vid=$result_folder$height/$consumer/*/chunk_video_1.webm.enc_video_*.log
        
        res_time=$(cat $log_file_vid | grep "Time el" | awk '{ sum += $3 } END { if (NR > 0) print sum / NR }')
        res_goodput=$(cat $log_file_vid | grep "Good" | awk '{ if ($3 ~ /Mbit/) {a=$2*1024} else {a=$2}; sum += a} END { if (NR > 0) print sum / NR}')
        res_rtt_min=$(cat $log_file_vid | grep RTT | awk '{split($4,a,"/"); sum+=a[1];} END {if (NR > 0) print sum / NR}')
        res_rrt_avg=$(cat $log_file_vid | grep RTT | awk '{split($4,a,"/"); sum+=a[2];} END {if (NR > 0) print sum / NR}')
        res_rrt_max=$(cat $log_file_vid | grep RTT | awk '{split($4,a,"/"); sum+=a[3];} END {if (NR > 0) print sum / NR}')

        echo $height $consumer $res_time $res_goodput $res_rtt_min $res_rrt_avg $res_rrt_max >> result_vid

    done
done

# consumer x ----- height 3, 5, 7, 9
# asdf