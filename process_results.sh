#!/bin/bash

result_folder="results/new_results_feb27/"
declare -a res_time
# declare -A res_goodput
# declare -A Timeout

touch result_height result_vid
echo "hgt con tt(sec) gp(Mbit/s) minrtt(ms) avgrtt(ms) maxrtt(ms)" > result_height
echo "hgt con tt(sec) gp(Mbit/s) minrtt(ms) avgrtt(ms) maxrtt(ms)" > result_vid
echo "hgt con mean min max perc_5 perc_25 perc_95 stddev rtt_min rtt_avg rtt_max" > result_height_time
echo "hgt con mean min max perc_5 perc_25 perc_95 stddev rtt_min rtt_avg rtt_max" > result_height_goodput
echo "hgt con mean min max perc_5 perc_25 perc_95 stddev rtt_min rtt_avg rtt_max" > result_vid_time
echo "hgt con mean min max perc_5 perc_25 perc_95 stddev rtt_min rtt_avg rtt_max" > result_vid_goodput

for hnum in 3 5 7 9;
do
    height="height"$hnum
    for consumer in $(ls $result_folder/$height); do
        # each of these height will have 2...14 consumers
        log_file_h=$result_folder$height/$consumer/*/chunk_cipher_Height-$hnum.txt_height_*.log
        cat $log_file_h | grep "Time el" | awk '{print $3}' > res_time_tmp 
        cat $log_file_h | grep "Good" | awk '{ if ($3 ~ /Kbit/) {a=$2/1024} else {a=$2}; print a}' > res_goodput_tmp

        res_time=$(datamash mean 1 min 1 max 1 perc:5 1 perc:25 1 perc:95 1 sstdev 1 < res_time_tmp)
        res_goodput=$(datamash mean 1 min 1 max 1 perc:5 1 perc:25 1 perc:95 1 sstdev 1 < res_goodput_tmp)
                
        res_rtt_min=$(cat $log_file_h | grep RTT | awk '{split($4,a,"/"); sum+=a[1];} END {if (NR > 0) print sum / NR}')
        res_rrt_avg=$(cat $log_file_h | grep RTT | awk '{split($4,a,"/"); sum+=a[2];} END {if (NR > 0) print sum / NR}')
        res_rrt_max=$(cat $log_file_h | grep RTT | awk '{split($4,a,"/"); sum+=a[3];} END {if (NR > 0) print sum / NR}')

        echo $height $consumer $res_time $res_rtt_min $res_rrt_avg $res_rrt_max >> result_height_time
        echo $height $consumer $res_goodput $res_rtt_min $res_rrt_avg $res_rrt_max >> result_height_goodput

        rm res_goodput_tmp res_time_tmp

        log_file_vid=$result_folder$height/$consumer/*/chunk_video_1.webm.enc_video_*
        
        cat $log_file_vid | grep "Time el" | awk '{print $3}' > res_time_tmp 
        cat $log_file_vid | grep "Good" | awk '{ if ($3 ~ /Kbit/) {a=$2/1024} else {a=$2}; print a}' > res_goodput_tmp

        res_time=$(datamash mean 1 min 1 max 1 perc:5 1 perc:25 1 perc:95 1 sstdev 1 < res_time_tmp)
        res_goodput=$(datamash mean 1 min 1 max 1 perc:5 1 perc:25 1 perc:95 1 sstdev 1 < res_goodput_tmp)

        res_rtt_min=$(cat $log_file_vid | grep RTT | awk '{split($4,a,"/"); sum+=a[1];} END {if (NR > 0) print sum / NR}')
        res_rrt_avg=$(cat $log_file_vid | grep RTT | awk '{split($4,a,"/"); sum+=a[2];} END {if (NR > 0) print sum / NR}')
        res_rrt_max=$(cat $log_file_vid | grep RTT | awk '{split($4,a,"/"); sum+=a[3];} END {if (NR > 0) print sum / NR}')

        echo $height $consumer $res_time $res_rtt_min $res_rrt_avg $res_rrt_max >> result_vid_time
        echo $height $consumer $res_goodput $res_rtt_min $res_rrt_avg $res_rrt_max >> result_vid_goodput

        rm res_goodput_tmp res_time_tmp

    done
done

# consumer x ----- height 3, 5, 7, 9
# asdf
