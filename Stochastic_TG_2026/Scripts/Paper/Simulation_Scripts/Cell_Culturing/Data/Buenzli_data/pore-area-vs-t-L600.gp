# set term x11

# set term pdfcairo enhanced size 3.76in,2.5in
# set output "pore-area-vs-t-L600.pdf"
# set xlabel '{/Times-Italic t} [day]'
# set ylabel 'Pore area/initial pore area [-]'
# set title '{/Times-Italic L} = 600 {/Symbol m}m'

# set term png enhanced
# set output "pore-area-vs-t-L600.png"

set term cairolatex pdf standalone color size 3.6,2.4 transparent font "default, 10" rounded header '\usepackage{amsmath}\usepackage{amssymb}\usepackage[utopia,greekuppercase=italicized]{mathdesign}\usepackage{newtxtext}\edef\partial{\mathchar\number\partial\noexpand\!}\usepackage[T1]{fontenc}\usepackage[expproduct=tighttimes]{siunitx}'

set output "pore-area-vs-t-L600.tex"
set format '\footnotesize $%g$' # latex command may offset the ylabel. Use offset in set ylabel and adjust margins

set border lw 1.5

set title '$L=600\,\um$' offset 0,-0.8
set xlabel '$t$ [day]'
set ylabel 'Experimental $A(t)/A(0)\ \ [-]$' offset 2,0

set size ratio 0.6
set margins at screen 0.105, at screen 0.98, at screen 0.15, at screen 0.94
set key at graph 0.58, 0.95 left reverse Left spacing 1.5

set xrange [0:30]
set yrange [-0.05:1]

set dummy t

B(t) = 1-(t/tb)**nu
fit B(t) 'pore-coverage-L600.dat' using 1:(1-0.01*$2) every :::0::6 via tb,nu

N = 1000

set samples N

plot 'pore-coverage-L600.dat' using 1:(1-0.01*$2) with points title '' lc rgb 'black' pt 6 pi 1 ps 0.4,\
	 [0:tb] B(t) with lines title sprintf('\small $T_\text{b} = %.2f \pm %.2f$' . "\n" . '\small $\nu = %.2f \pm %.2f$', tb, tb_err, nu, nu_err) lc rgb 'black' lw 2,\
	 0 with lines title '' lc 0 dt 3	 

unset output