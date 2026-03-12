my_font = "default"
# my_font = "Times New Roman"

my_font_size = my_font . ",10"
# my_font_size = "Times New Roman,10"

################# choose terminal #####################
# set term x11

set term pdfcairo enhanced size 5.5in,2.5in
set output "pore-area-vs-t-all.pdf"

# set term png enhanced
# set output "pore-area-vs-t-L200.png"
#######################################################

set size ratio 0.6
set xrange [0:30]
set yrange [-0.05:1]
set xlabel 't [day]'
set ylabel 'Pore area/initial pore area [-]'
set title ''

set dummy t
set fit errorvariables # errors of the fit are the fitted parameters appended with _err
# set fit prescale

B200(t) = 1-(t/tb200)**nu200
fit B200(t) 'pore-coverage-L200.dat' using 1:(1-0.01*$2) every ::0::4 via tb200,nu200

B300(t) = 1-(t/tb300)**nu300
fit B300(t) 'pore-coverage-L300.dat' using 1:(1-0.01*$2) every :::0::5 via tb300,nu300

B400(t) = 1-(t/tb400)**nu400
fit B400(t) 'pore-coverage-L400.dat' using 1:(1-0.01*$2) every :::0::5 via tb400,nu400

B500(t) = 1-(t/tb500)**nu500
fit B500(t) 'pore-coverage-L500.dat' using 1:(1-0.01*$2) every :::0::5 via tb500,nu500

B600(t) = 1-(t/tb600)**nu600
fit B600(t) 'pore-coverage-L600.dat' using 1:(1-0.01*$2) every :::0::6 via tb600,nu600

N = 1000

set samples N

# set title 'Fits: T_b(L) = t_0 + m L'
set key outside Left reverse spacing 2 font my_font_size
plot 'pore-coverage-L200.dat' using 1:(1-0.01*$2) with points title 'L=200' lc 0 pi 1 ps 0.2,\
	 [0:tb200] B200(t) with lines title sprintf("T_b = %g +/- %g;\n nu=%g +/- %g", tb200, tb200_err, nu200, nu200_err) lc 0,\
'pore-coverage-L300.dat' using 1:(1-0.01*$2) with points title 'L=300' lc 1 pi 1 ps 0.2,\
	 [0:tb300] B300(t) with lines title sprintf("T_b = %g +/- %g;\n nu=%g +/- %g", tb300, tb300_err, nu300, nu300_err) lc 1,\
'pore-coverage-L400.dat' using 1:(1-0.01*$2) with points title 'L=400' lc 2 pi 1 ps 0.2,\
	 [0:tb400] B400(t) with lines title sprintf("T_b = %g +/- %g;\n nu=%g +/- %g", tb400, tb400_err, nu400, nu400_err) lc 2,\
'pore-coverage-L500.dat' using 1:(1-0.01*$2) with points title 'L=500' lc 3 pt 6 pi 1 ps 0.2,\
	 [0:tb500] B500(t) with lines title sprintf("T_b = %g +/- %g;\n nu=%g +/- %g", tb500, tb500_err, nu500, nu500_err) lc 3,\
'pore-coverage-L600.dat' using 1:(1-0.01*$2) with points title 'L=600' lc 4 pi 1 ps 0.2,\
	 [0:tb600] B600(t) with lines title sprintf("T_b = %g +/- %g;\n nu=%g +/- %g", tb600, tb600_err, nu600, nu600_err) lc 4						 

unset output