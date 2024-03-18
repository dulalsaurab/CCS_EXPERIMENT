
set terminal png
set output 'goodput.png'

set xdata time
set timefmt "%S"
set xlabel "time"

set autoscale

set ylabel "highest seq number"
set format y "%s"

set title "seq number over time"
set key reverse Left outside
set grid

set style data linespoints

set multiplot layout 2,2

plot "result_height/result_height_goodput_3" using 3:2
