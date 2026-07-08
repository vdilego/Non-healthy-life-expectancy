
# IMaCh-0.99r45
# FRFadl.gp
set datafile missing 'NaNq'
cd "C:/Users/mmusz/Dropbox/gender_paradox/data/IMACHnew" 

#Diagram of the model 

delta=0.03;delta2=0.07;unset arrow;
yoff=(2 > 2? 0:1);

#Peripheral arrows
set for [i=1:2] for [j=1:2] arrow i*10+j from cos(pi*((1-(2/2)*2./2)/2+(i-1)*2./2))-(i!=j?(i-j)/abs(i-j)*delta:0), yoff +sin(pi*((1-(2/2)*2./2)/2+(i-1)*2./2)) + (i!=j?(i-j)/abs(i-j)*delta:0) rto -0.95*(cos(pi*((1-(2/2)*2./2)/2+(i-1)*2./2))+(i!=j?(i-j)/abs(i-j)*delta:0) - cos(pi*((1-(2/2)*2./2)/2+(j-1)*2./2)) + (i!=j?(i-j)/abs(i-j)*delta2:0)), -0.95*(sin(pi*((1-(2/2)*2./2)/2+(i-1)*2./2)) + (i!=j?(i-j)/abs(i-j)*delta:0) - sin(pi*((1-(2/2)*2./2)/2+(j-1)*2./2))+( i!=j?(i-j)/abs(i-j)*delta2:0)) ls (i < j? 1:2)

#Centripete arrows (turning in other direction (1-i) instead of (i-1)) 
set for [i=1:2] for [j=1:2] arrow (2+1)*10+i from cos(pi*((1-(2/2)*2./2)/2+(1-i)*2./2))-(i!=j?(i-j)/abs(i-j)*delta:0), yoff +sin(pi*((1-(2/2)*2./2)/2+(1-i)*2./2)) + (i!=j?(i-j)/abs(i-j)*delta:0) rto -0.80*(cos(pi*((1-(2/2)*2./2)/2+(1-i)*2./2))+(i!=j?(i-j)/abs(i-j)*delta:0)  ), -0.80*(sin(pi*((1-(2/2)*2./2)/2+(1-i)*2./2)) + (i!=j?(i-j)/abs(i-j)*delta:0) + yoff ) ls 4

#show arrow
unset label

#States labels, starting from 2 (2-i) instead of (1-i), was (i-1)
set for [i=1:2] label i sprintf("State %d",i) center at cos(pi*((1-(2/2)*2./2)/2+(2-i)*2./2)), yoff+sin(pi*((1-(2/2)*2./2)/2+(2-i)*2./2)) font "helvetica, 16" tc rgbcolor "blue"

set label 2+1 sprintf("State %d",2+1) center at 0.,0.  font "helvetica, 16" tc rgbcolor "red"

#show label
unset border;unset xtics; unset ytics;


set ter svg size 640, 480;set out "FRFadl/D_FRFadl_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "FRFadl/ILK_FRFadl-dest.png";
set log y;plot  "FRFadl/ILK_FRFadl.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "FRFadl/ILK_FRFadl-ori.png";
set log y;plot  "FRFadl/ILK_FRFadl.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "FRFadl/ILK_FRFadl-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "FRFadl/ILK_FRFadl.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "FRFadl/ILK_FRFadl-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "FRFadl/ILK_FRFadl.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "FRFadl/V_FRFadl_1-1-1.svg" 

#set out "V_FRFadl_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "FRFadl/VPL_FRFadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"FRFadl/VPL_FRFadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"FRFadl/VPL_FRFadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"FRFadl/P_FRFadl.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "FRFadl/V_FRFadl_2-1-1.svg" 

#set out "V_FRFadl_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "FRFadl/VPL_FRFadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"FRFadl/VPL_FRFadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"FRFadl/VPL_FRFadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"FRFadl/P_FRFadl.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "FRFadl/E_FRFadl_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "FRFadl/T_FRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"FRFadl/T_FRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"FRFadl/T_FRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"FRFadl/T_FRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"FRFadl/T_FRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"FRFadl/T_FRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"FRFadl/T_FRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"FRFadl/T_FRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"FRFadl/T_FRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "FRFadl/E_FRFadl_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "FRFadl/EXP_FRFadl_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "FRFadl/E_FRFadl.txt" every :::0::0 u 1:2 t "e11" w l ,"FRFadl/E_FRFadl.txt" every :::0::0 u 1:3 t "e12" w l ,"FRFadl/E_FRFadl.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "FRFadl/EXP_FRFadl_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "FRFadl/E_FRFadl.txt" every :::0::0 u 1:5 t "e21" w l ,"FRFadl/E_FRFadl.txt" every :::0::0 u 1:6 t "e22" w l ,"FRFadl/E_FRFadl.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "FRFadl/LIJ_FRFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFadl/PIJ_FRFadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "FRFadl/LIJ_FRFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFadl/PIJ_FRFadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "FRFadl/LIJT_FRFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFadl/PIJ_FRFadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "FRFadl/LIJT_FRFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFadl/PIJ_FRFadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "FRFadl/P_FRFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFadl/PIJ_FRFadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "FRFadl/P_FRFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFadl/PIJ_FRFadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-6.980739; p2=0.045458; 
#   current state 3
p3=-17.862141; p4=0.167446; 
# initial state 2
#   current state 1
p5=0.096495; p6=-0.022640; 
#   current state 3
p7=-4.685942; p8=0.016363; 
##############
#

##############
#10eme Graphics of probabilities or incidences
#############
# logi(p12/p11)=a12+b12*age+c12age*age+d12*V1+e12*V1*age
# logi(p12/p11)=p1 +p2*age +p3*age*age+ p4*V1+ p5*V1*age
# logi(p13/p11)=a13+b13*age+c13age*age+d13*V1+e13*V1*age
# logi(p13/p11)=p6 +p7*age +p8*age*age+ p9*V1+ p10*V1*age
# p12+p13+p14+p11=1=p11(1+exp(a12+b12*age+c12age*age+d12*V1+e12*V1*age)
#                      +exp(a13+b13*age+c13age*age+d13*V1+e13*V1*age)+...)
# p11=1/(1+exp(a12+b12*age+c12age*age+d12*V1+e12*V1*age)
#                      +exp(a13+b13*age+c13age*age+d13*V1+e13*V1*age)+...)
# p12=exp(a12+b12*age+c12age*age+d12*V1+e12*V1*age)/
#     (1+exp(a12+b12*age+c12age*age+d12*V1+e12*V1*age)
#       +exp(a13+b13*age+c13age*age+d13*V1+e13*V1*age))
#       +exp(a14+b14*age+c14age*age+d14*V1+e14*V1*age)+...)
#
#Number of graphics: first is logit, 2nd is probabilities, third is incidences per year
#model=1+age+ 
# Type of graphic ng=1
#   k1=1 to 2^0=1


# Resultline k1=1 
#

set out "FRFadl/PE_FRFadl_1-1-1.svg" 
set key outside 
set title "()" font "Helvetica,12"

set ter svg size 640, 480 
set ylabel "Value of the logit of the model"

unset log y
plot  [50:90]  p1+p2*x w l lw 2 lt (3*1+2)%3+1 dt 1 t "logit(p12)" , p3+p4*x w l lw 2 lt (3*1+3)%3+1 dt 1 t "logit(p13)" , p5+p6*x w l lw 2 lt (3*2+1)%3+1 dt 2 t "logit(p21)" , p7+p8*x w l lw 2 lt (3*2+3)%3+1 dt 2 t "logit(p23)" 
 set out; unset title;set key default;
#Number of graphics: first is logit, 2nd is probabilities, third is incidences per year
#model=1+age+ 
# Type of graphic ng=2
#   k1=1 to 2^0=1


# Resultline k1=1 
#

set out "FRFadl/PE_FRFadl_1-2-1.svg" 
set key outside 
set title "()" font "Helvetica,12"

set ter svg size 640, 480 
set ylabel "Probability"

set log y
plot  [50:90]  (1.)/(1+exp(p1+p2*x)+exp(p3+p4*x)) w l lw 2 lt (3*1+1)%3+1 dt 1 t "p11" , exp(p1+p2*x)/(1+exp(p1+p2*x)+exp(p3+p4*x)) w l lw 2 lt (3*1+2)%3+1 dt 1 t "p12" , exp(p3+p4*x)/(1+exp(p1+p2*x)+exp(p3+p4*x)) w l lw 2 lt (3*1+3)%3+1 dt 1 t "p13" , exp(p5+p6*x)/(1+exp(p5+p6*x)+exp(p7+p8*x)) w l lw 2 lt (3*2+1)%3+1 dt 2 t "p21" , (1.)/(1+exp(p5+p6*x)+exp(p7+p8*x)) w l lw 2 lt (3*2+2)%3+1 dt 2 t "p22" , exp(p7+p8*x)/(1+exp(p5+p6*x)+exp(p7+p8*x)) w l lw 2 lt (3*2+3)%3+1 dt 2 t "p23" 
 set out; unset title;set key default;
#Number of graphics: first is logit, 2nd is probabilities, third is incidences per year
#model=1+age+ 
# Type of graphic ng=3
#   k1=1 to 2^0=1


# Resultline k1=1 
#

set out "FRFadl/PE_FRFadl_1-3-1.svg" 
set key outside 
set title "()" font "Helvetica,12"

set ter svg size 640, 480 
set ylabel "Quasi-incidence per year"

set log y
plot  [50:90]  (1.)/(1+exp(p1+p2*x)+exp(p3+p4*x)) w l lw 2 lt (3*1+1)%3+1 dt 1 t "i11" , 2.000000*exp(p1+p2*x)/(1+exp(p1+p2*x)+exp(p3+p4*x)) w l lw 2 lt (3*1+2)%3+1 dt 1 t "i12" , 2.000000*exp(p3+p4*x)/(1+exp(p1+p2*x)+exp(p3+p4*x)) w l lw 2 lt (3*1+3)%3+1 dt 1 t "i13" , 2.000000*exp(p5+p6*x)/(1+exp(p5+p6*x)+exp(p7+p8*x)) w l lw 2 lt (3*2+1)%3+1 dt 2 t "i21" , (1.)/(1+exp(p5+p6*x)+exp(p7+p8*x)) w l lw 2 lt (3*2+2)%3+1 dt 2 t "i22" , 2.000000*exp(p7+p8*x)/(1+exp(p5+p6*x)+exp(p7+p8*x)) w l lw 2 lt (3*2+3)%3+1 dt 2 t "i23" 
 set out; unset title;set key default;

# Routine varprob
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p13 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "FRFadl/VARPIJGR_FRFadl_113-12.svg"
set label "50" at  1.499e-004, 1.789e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  1.499e-004+ 2.000*( 8.003e-004* 4.795e-003*cos(t)+ 1.000e+000* 1.405e-004*sin(t)),  1.789e-002 +2.000*(-1.000e+000* 4.795e-003*cos(t)+ 8.003e-004* 1.405e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  3.454e-004, 2.240e-002 center
replot  3.454e-004+ 2.000*( 1.803e-003* 4.892e-003*cos(t)+ 1.000e+000* 2.762e-004*sin(t)),  2.240e-002 +2.000*(-1.000e+000* 4.892e-003*cos(t)+ 1.803e-003* 2.762e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  7.953e-004, 2.803e-002 center
replot  7.953e-004+ 2.000*( 4.237e-003* 4.850e-003*cos(t)+ 1.000e+000* 5.280e-004*sin(t)),  2.803e-002 +2.000*(-1.000e+000* 4.850e-003*cos(t)+ 4.237e-003* 5.280e-004*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.830e-003, 3.503e-002 center
replot  1.830e-003+ 2.000*( 1.015e-002* 4.775e-003*cos(t)+ 9.999e-001* 9.717e-004*sin(t)),  3.503e-002 +2.000*(-9.999e-001* 4.775e-003*cos(t)+ 1.015e-002* 9.717e-004*sin(t)) not
# Age 70, p13 - p12
set label "70" at  4.203e-003, 4.373e-002 center
replot  4.203e-003+ 2.000*( 2.177e-002* 5.077e-003*cos(t)+ 9.998e-001* 1.701e-003*sin(t)),  4.373e-002 +2.000*(-9.998e-001* 5.077e-003*cos(t)+ 2.177e-002* 1.701e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  9.628e-003, 5.443e-002 center
replot  9.628e-003+ 2.000*( 3.326e-002* 6.560e-003*cos(t)+ 9.994e-001* 2.826e-003*sin(t)),  5.443e-002 +2.000*(-9.994e-001* 6.560e-003*cos(t)+ 3.326e-002* 2.826e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  2.195e-002, 6.743e-002 center
replot  2.195e-002+ 2.000*( 4.322e-002* 9.888e-003*cos(t)+ 9.991e-001* 4.842e-003*sin(t)),  6.743e-002 +2.000*(-9.991e-001* 9.888e-003*cos(t)+ 4.322e-002* 4.842e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  4.956e-002, 8.274e-002 center
replot  4.956e-002+ 2.000*( 1.191e-001* 1.533e-002*cos(t)+ 9.929e-001* 1.106e-002*sin(t)),  8.274e-002 +2.000*(-9.929e-001* 1.533e-002*cos(t)+ 1.191e-001* 1.106e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.098e-001, 9.957e-002 center
replot  1.098e-001+ 2.000*( 9.870e-001* 3.244e-002*cos(t)+ 1.609e-001* 2.244e-002*sin(t)),  9.957e-002 +2.000*(-1.609e-001* 3.244e-002*cos(t)+ 9.870e-001* 2.244e-002*sin(t)) not
set out;
set out "FRFadl/VARPIJGR_FRFadl_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "FRFadl/VARPIJGR_FRFadl_121-12.svg"
set label "50" at  5.161e-001, 1.789e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  5.161e-001+ 2.000*( 9.999e-001* 1.069e-001*cos(t)+-1.417e-002* 4.550e-003*sin(t)),  1.789e-002 +2.000*( 1.417e-002* 1.069e-001*cos(t)+ 9.999e-001* 4.550e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  4.733e-001, 2.240e-002 center
replot  4.733e-001+ 2.000*( 9.998e-001* 8.396e-002*cos(t)+-1.867e-002* 4.635e-003*sin(t)),  2.240e-002 +2.000*( 1.867e-002* 8.396e-002*cos(t)+ 9.998e-001* 4.635e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  4.330e-001, 2.803e-002 center
replot  4.330e-001+ 2.000*( 9.997e-001* 6.423e-002*cos(t)+-2.462e-002* 4.587e-003*sin(t)),  2.803e-002 +2.000*( 2.462e-002* 6.423e-002*cos(t)+ 9.997e-001* 4.587e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.952e-001, 3.503e-002 center
replot  3.952e-001+ 2.000*( 9.995e-001* 4.862e-002*cos(t)+-3.246e-002* 4.509e-003*sin(t)),  3.503e-002 +2.000*( 3.246e-002* 4.862e-002*cos(t)+ 9.995e-001* 4.509e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  3.598e-001, 4.373e-002 center
replot  3.598e-001+ 2.000*( 9.991e-001* 3.847e-002*cos(t)+-4.298e-002* 4.803e-003*sin(t)),  4.373e-002 +2.000*( 4.298e-002* 3.847e-002*cos(t)+ 9.991e-001* 4.803e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  3.270e-001, 5.443e-002 center
replot  3.270e-001+ 2.000*( 9.983e-001* 3.495e-002*cos(t)+-5.817e-002* 6.245e-003*sin(t)),  5.443e-002 +2.000*( 5.817e-002* 3.495e-002*cos(t)+ 9.983e-001* 6.245e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.965e-001, 6.743e-002 center
replot  2.965e-001+ 2.000*( 9.967e-001* 3.708e-002*cos(t)+-8.089e-002* 9.446e-003*sin(t)),  6.743e-002 +2.000*( 8.089e-002* 3.708e-002*cos(t)+ 9.967e-001* 9.446e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  2.684e-001, 8.274e-002 center
replot  2.684e-001+ 2.000*( 9.935e-001* 4.209e-002*cos(t)+-1.139e-001* 1.460e-002*sin(t)),  8.274e-002 +2.000*( 1.139e-001* 4.209e-002*cos(t)+ 9.935e-001* 1.460e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  2.425e-001, 9.957e-002 center
replot  2.425e-001+ 2.000*( 9.868e-001* 4.782e-002*cos(t)+-1.616e-001* 2.169e-002*sin(t)),  9.957e-002 +2.000*( 1.616e-001* 4.782e-002*cos(t)+ 9.868e-001* 2.169e-002*sin(t)) not
set out;
set out "FRFadl/VARPIJGR_FRFadl_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "FRFadl/VARPIJGR_FRFadl_123-12.svg"
set label "50" at  3.039e-002, 1.789e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  3.039e-002+ 2.000*( 1.000e+000* 2.068e-002*cos(t)+-1.342e-005* 4.795e-003*sin(t)),  1.789e-002 +2.000*( 1.342e-005* 2.068e-002*cos(t)+ 1.000e+000* 4.795e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  3.387e-002, 2.240e-002 center
replot  3.387e-002+ 2.000*( 1.000e+000* 1.927e-002*cos(t)+-4.538e-004* 4.892e-003*sin(t)),  2.240e-002 +2.000*( 4.538e-004* 1.927e-002*cos(t)+ 1.000e+000* 4.892e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.765e-002, 2.803e-002 center
replot  3.765e-002+ 2.000*( 1.000e+000* 1.747e-002*cos(t)+-1.291e-003* 4.850e-003*sin(t)),  2.803e-002 +2.000*( 1.291e-003* 1.747e-002*cos(t)+ 1.000e+000* 4.850e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  4.177e-002, 3.503e-002 center
replot  4.177e-002+ 2.000*( 1.000e+000* 1.547e-002*cos(t)+-3.691e-003* 4.774e-003*sin(t)),  3.503e-002 +2.000*( 3.691e-003* 1.547e-002*cos(t)+ 1.000e+000* 4.774e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  4.622e-002, 4.373e-002 center
replot  4.622e-002+ 2.000*( 9.999e-001* 1.379e-002*cos(t)+-1.135e-002* 5.074e-003*sin(t)),  4.373e-002 +2.000*( 1.135e-002* 1.379e-002*cos(t)+ 9.999e-001* 5.074e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  5.105e-002, 5.443e-002 center
replot  5.105e-002+ 2.000*( 9.995e-001* 1.355e-002*cos(t)+-3.122e-002* 6.547e-003*sin(t)),  5.443e-002 +2.000*( 3.122e-002* 1.355e-002*cos(t)+ 9.995e-001* 6.547e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  5.626e-002, 6.743e-002 center
replot  5.626e-002+ 2.000*( 9.980e-001* 1.601e-002*cos(t)+-6.319e-002* 9.849e-003*sin(t)),  6.743e-002 +2.000*( 6.319e-002* 1.601e-002*cos(t)+ 9.980e-001* 9.849e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  6.189e-002, 8.274e-002 center
replot  6.189e-002+ 2.000*( 9.951e-001* 2.146e-002*cos(t)+-9.883e-002* 1.520e-002*sin(t)),  8.274e-002 +2.000*( 9.883e-002* 2.146e-002*cos(t)+ 9.951e-001* 1.520e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  6.796e-002, 9.957e-002 center
replot  6.796e-002+ 2.000*( 9.893e-001* 2.948e-002*cos(t)+-1.458e-001* 2.259e-002*sin(t)),  9.957e-002 +2.000*( 1.458e-001* 2.948e-002*cos(t)+ 9.893e-001* 2.259e-002*sin(t)) not
set out;
set out "FRFadl/VARPIJGR_FRFadl_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "FRFadl/VARPIJGR_FRFadl_121-13.svg"
set label "50" at  5.161e-001, 1.499e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  5.161e-001+ 2.000*( 1.000e+000* 1.069e-001*cos(t)+-4.806e-005* 1.405e-004*sin(t)),  1.499e-004 +2.000*( 4.806e-005* 1.069e-001*cos(t)+ 1.000e+000* 1.405e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  4.733e-001, 3.454e-004 center
replot  4.733e-001+ 2.000*( 1.000e+000* 8.394e-002*cos(t)+-1.131e-004* 2.762e-004*sin(t)),  3.454e-004 +2.000*( 1.131e-004* 8.394e-002*cos(t)+ 1.000e+000* 2.762e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  4.330e-001, 7.953e-004 center
replot  4.330e-001+ 2.000*( 1.000e+000* 6.421e-002*cos(t)+-2.621e-004* 5.281e-004*sin(t)),  7.953e-004 +2.000*( 2.621e-004* 6.421e-002*cos(t)+ 1.000e+000* 5.281e-004*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.952e-001, 1.830e-003 center
replot  3.952e-001+ 2.000*( 1.000e+000* 4.859e-002*cos(t)+-6.001e-004* 9.724e-004*sin(t)),  1.830e-003 +2.000*( 6.001e-004* 4.859e-002*cos(t)+ 1.000e+000* 9.724e-004*sin(t)) not
# Age 70, p21 - p13
set label "70" at  3.598e-001, 4.203e-003 center
replot  3.598e-001+ 2.000*( 1.000e+000* 3.844e-002*cos(t)+-1.445e-003* 1.703e-003*sin(t)),  4.203e-003 +2.000*( 1.445e-003* 3.844e-002*cos(t)+ 1.000e+000* 1.703e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  3.270e-001, 9.628e-003 center
replot  3.270e-001+ 2.000*( 1.000e+000* 3.489e-002*cos(t)+-4.027e-003* 2.829e-003*sin(t)),  9.628e-003 +2.000*( 4.027e-003* 3.489e-002*cos(t)+ 1.000e+000* 2.829e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.965e-001, 2.195e-002 center
replot  2.965e-001+ 2.000*( 9.999e-001* 3.697e-002*cos(t)+-1.172e-002* 4.837e-003*sin(t)),  2.195e-002 +2.000*( 1.172e-002* 3.697e-002*cos(t)+ 9.999e-001* 4.837e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  2.684e-001, 4.956e-002 center
replot  2.684e-001+ 2.000*( 9.995e-001* 4.187e-002*cos(t)+-3.283e-002* 1.105e-002*sin(t)),  4.956e-002 +2.000*( 3.283e-002* 4.187e-002*cos(t)+ 9.995e-001* 1.105e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  2.425e-001, 1.098e-001 center
replot  2.425e-001+ 2.000*( 9.909e-001* 4.756e-002*cos(t)+-1.349e-001* 3.187e-002*sin(t)),  1.098e-001 +2.000*( 1.349e-001* 4.756e-002*cos(t)+ 9.909e-001* 3.187e-002*sin(t)) not
set out;
set out "FRFadl/VARPIJGR_FRFadl_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "FRFadl/VARPIJGR_FRFadl_123-13.svg"
set label "50" at  3.039e-002, 1.499e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  3.039e-002+ 2.000*( 1.000e+000* 2.068e-002*cos(t)+ 1.303e-003* 1.379e-004*sin(t)),  1.499e-004 +2.000*(-1.303e-003* 2.068e-002*cos(t)+ 1.000e+000* 1.379e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  3.387e-002, 3.454e-004 center
replot  3.387e-002+ 2.000*( 1.000e+000* 1.927e-002*cos(t)+ 2.738e-003* 2.713e-004*sin(t)),  3.454e-004 +2.000*(-2.738e-003* 1.927e-002*cos(t)+ 1.000e+000* 2.713e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.765e-002, 7.953e-004 center
replot  3.765e-002+ 2.000*( 1.000e+000* 1.747e-002*cos(t)+ 5.763e-003* 5.187e-004*sin(t)),  7.953e-004 +2.000*(-5.763e-003* 1.747e-002*cos(t)+ 1.000e+000* 5.187e-004*sin(t)) not
# Age 65, p23 - p13
set label "65" at  4.177e-002, 1.830e-003 center
replot  4.177e-002+ 2.000*( 9.999e-001* 1.547e-002*cos(t)+ 1.205e-002* 9.549e-004*sin(t)),  1.830e-003 +2.000*(-1.205e-002* 1.547e-002*cos(t)+ 9.999e-001* 9.549e-004*sin(t)) not
# Age 70, p23 - p13
set label "70" at  4.622e-002, 4.203e-003 center
replot  4.622e-002+ 2.000*( 9.997e-001* 1.380e-002*cos(t)+ 2.441e-002* 1.671e-003*sin(t)),  4.203e-003 +2.000*(-2.441e-002* 1.380e-002*cos(t)+ 9.997e-001* 1.671e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  5.105e-002, 9.628e-003 center
replot  5.105e-002+ 2.000*( 9.989e-001* 1.356e-002*cos(t)+ 4.610e-002* 2.766e-003*sin(t)),  9.628e-003 +2.000*(-4.610e-002* 1.356e-002*cos(t)+ 9.989e-001* 2.766e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  5.626e-002, 2.195e-002 center
replot  5.626e-002+ 2.000*( 9.963e-001* 1.605e-002*cos(t)+ 8.575e-002* 4.675e-003*sin(t)),  2.195e-002 +2.000*(-8.575e-002* 1.605e-002*cos(t)+ 9.963e-001* 4.675e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  6.189e-002, 4.956e-002 center
replot  6.189e-002+ 2.000*( 9.807e-001* 2.173e-002*cos(t)+ 1.956e-001* 1.049e-002*sin(t)),  4.956e-002 +2.000*(-1.956e-001* 2.173e-002*cos(t)+ 9.807e-001* 1.049e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  6.796e-002, 1.098e-001 center
replot  6.796e-002+ 2.000*( 5.815e-001* 3.498e-002*cos(t)+ 8.135e-001* 2.600e-002*sin(t)),  1.098e-001 +2.000*(-8.135e-001* 3.498e-002*cos(t)+ 5.815e-001* 2.600e-002*sin(t)) not
set out;
set out "FRFadl/VARPIJGR_FRFadl_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "FRFadl/VARPIJGR_FRFadl_123-21.svg"
set label "50" at  3.039e-002, 5.161e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  3.039e-002+ 2.000*( 1.872e-002* 1.069e-001*cos(t)+ 9.998e-001* 2.058e-002*sin(t)),  5.161e-001 +2.000*(-9.998e-001* 1.069e-001*cos(t)+ 1.872e-002* 2.058e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  3.387e-002, 4.733e-001 center
replot  3.387e-002+ 2.000*( 1.968e-002* 8.396e-002*cos(t)+ 9.998e-001* 1.920e-002*sin(t)),  4.733e-001 +2.000*(-9.998e-001* 8.396e-002*cos(t)+ 1.968e-002* 1.920e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.765e-002, 4.330e-001 center
replot  3.765e-002+ 2.000*( 2.074e-002* 6.422e-002*cos(t)+ 9.998e-001* 1.742e-002*sin(t)),  4.330e-001 +2.000*(-9.998e-001* 6.422e-002*cos(t)+ 2.074e-002* 1.742e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  4.177e-002, 3.952e-001 center
replot  4.177e-002+ 2.000*( 2.368e-002* 4.861e-002*cos(t)+ 9.997e-001* 1.543e-002*sin(t)),  3.952e-001 +2.000*(-9.997e-001* 4.861e-002*cos(t)+ 2.368e-002* 1.543e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  4.622e-002, 3.598e-001 center
replot  4.622e-002+ 2.000*( 3.483e-002* 3.846e-002*cos(t)+ 9.994e-001* 1.374e-002*sin(t)),  3.598e-001 +2.000*(-9.994e-001* 3.846e-002*cos(t)+ 3.483e-002* 1.374e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  5.105e-002, 3.270e-001 center
replot  5.105e-002+ 2.000*( 6.072e-002* 3.495e-002*cos(t)+ 9.982e-001* 1.340e-002*sin(t)),  3.270e-001 +2.000*(-9.982e-001* 3.495e-002*cos(t)+ 6.072e-002* 1.340e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  5.626e-002, 2.965e-001 center
replot  5.626e-002+ 2.000*( 9.330e-002* 3.710e-002*cos(t)+ 9.956e-001* 1.568e-002*sin(t)),  2.965e-001 +2.000*(-9.956e-001* 3.710e-002*cos(t)+ 9.330e-002* 1.568e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  6.189e-002, 2.684e-001 center
replot  6.189e-002+ 2.000*( 1.288e-001* 4.211e-002*cos(t)+ 9.917e-001* 2.089e-002*sin(t)),  2.684e-001 +2.000*(-9.917e-001* 4.211e-002*cos(t)+ 1.288e-001* 2.089e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  6.796e-002, 2.425e-001 center
replot  6.796e-002+ 2.000*( 1.800e-001* 4.783e-002*cos(t)+ 9.837e-001* 2.852e-002*sin(t)),  2.425e-001 +2.000*(-9.837e-001* 4.783e-002*cos(t)+ 1.800e-001* 2.852e-002*sin(t)) not
set out;
set out "FRFadl/VARPIJGR_FRFadl_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "FRFadl/VARMUPTJGR--STABLBASED_FRFadl1.svg";
 plot "FRFadl/PRMORPREV-1-STABLBASED_FRFadl.txt"  u 1:($3) not w l lt 1 
 replot "FRFadl/PRMORPREV-1-STABLBASED_FRFadl.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "FRFadl/PRMORPREV-1-STABLBASED_FRFadl.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "FRFadl/VARMUPTJGR--STABLBASED_FRFadl1.svg";replot;set out;
