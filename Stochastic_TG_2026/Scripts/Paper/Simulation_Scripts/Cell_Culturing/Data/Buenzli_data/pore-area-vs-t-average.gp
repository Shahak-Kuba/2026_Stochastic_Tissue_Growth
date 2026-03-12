# set term x11

set term pdfcairo enhanced
set output "pore-area-vs-t-average.pdf"

# set term png enhanced
# set output "pore-area-vs-t-average.png"

set size ratio 0.6
set xrange [0:30]
set yrange [-0.05:1]
set xlabel 't [day]'
set ylabel 'Pore area/initial pore area [-]'

set dummy t
L1(t) = a1 + b1*t + c1*t**2
fit L1(t) 'pore-coverage-average.dat' using 1:(1-0.01*$2) every ::2:0:4:0 via a1,b1,c1

A1(t) = (1 - t/tb1)**nu1
fit A1(t) 'pore-coverage-average.dat' using 1:(1-0.01*$2) every ::2:0:6:0 via tb1,nu1 

B1(t) = 1-(t/btb1)**bnu1
fit B1(t) 'pore-coverage-average.dat' using 1:(1-0.01*$2) every ::2:0:4:0 via btb1,bnu1

B2(t) = 1-(t/btb2)**bnu2
fit B2(t) 'pore-coverage-average.dat' using 1:(1-0.01*$2) every ::0:1:4:1 via btb2,bnu2

B3(t) = 1-(t/btb3)**bnu3
fit B3(t) 'pore-coverage-average.dat' using 1:(1-0.01*$2) every ::0:2:5:2 via btb3,bnu3

B4(t) = 1-(t/btb4)**bnu4
fit B4(t) 'pore-coverage-average.dat' using 1:(1-0.01*$2) every ::1:3:6:3 via btb4,bnu4

B5(t) = 1-(t/btb5)**bnu5
fit B5(t) 'pore-coverage-average.dat' using 1:(1-0.01*$2) every ::1:4:7:4 via btb5,bnu5 # ::1:4:6:4


# set dummy L
# Tb(L) = t0 + m0*L
# Tb_orig(L) = m1*L
# fit Tb(L) 'Tbridge_vs_L_exp.dat' using 1:2 via t0, m0
# fit Tb_orig(L) 'Tbridge_vs_L_exp.dat' using 1:2 via m1

# set title 'Fits: T_b(L) = t_0 + m L'
set key top right Left reverse font "default,10"
plot 'pore-coverage-average.dat' using 1:(1-0.01*$2):($3/100) with linespoints title '' lc variable pt 6 pi 1 ps 0.7,\
	 B1(t) with lines title sprintf('L=200: 1-(T/%g)^{%g}', btb1, bnu1) dt 2 lc 2,\
	 B2(t) with lines title sprintf('L=300: 1-(T/%g)^{%g}', btb2, bnu2) dt 2 lc 3,\
	 B3(t) with lines title sprintf('L=400: 1-(T/%g)^{%g}', btb3, bnu3) dt 2 lc 4,\
	 B4(t) with lines title sprintf('L=500: 1-(T/%g)^{%g}', btb4, bnu4) dt 2 lc 5,\
	 B5(t) with lines title sprintf('L=600: 1-(T/%g)^{%g}', btb5, bnu5) dt 2 lc 6
	 # L1(t) with lines title sprintf('fit: %g + %g*t + %g*t^2', a1,b1,c1) lc rgb 'blue',\
	 # A1(t) with lines title sprintf('fit: (1-T/%g)**{%g}', tb1, nu1) lc rgb 'black',\

unset output