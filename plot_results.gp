set terminal postscript eps enhanced colour size 5, 4 font ",18"
set output "results.eps"


set yrange [0.95:3.5]

set xtics out nomirror rotate by 35 right 1, 4, 9 format ""
set x2tics out scale 0 format "" 2,3,42


set grid x2 y

set ylabel "Speedup"

set key top left

set boxwidth 1
set style data errorbars 
set style fill solid border -1

set object rectangle from 26,0 to 44,3.5 behind fillcolor rgb '#CCCCCC' fillstyle solid noborder

plot 'EXAMPLE_results.txt' using ($0*3):4 with boxes lc rgb '#5060D0' title "Recorded", \
     'COLLECTED_results.txt' using ($0*3+1):(0):xtic(1) with boxes title "Actual",\
     '' using ($0*3+1):4 with boxes lc rgb  '#AAFFAA' title "",\
                                     1  lc rgb '#444444' linetype 1 title ""
