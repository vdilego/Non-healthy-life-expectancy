
# IMaCh-0.99r45
# HRFchr.gp
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


set ter svg size 640, 480;set out "HRFchr/D_HRFchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "HRFchr/ILK_HRFchr-dest.png";
set log y;plot  "HRFchr/ILK_HRFchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "HRFchr/ILK_HRFchr-ori.png";
set log y;plot  "HRFchr/ILK_HRFchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "HRFchr/ILK_HRFchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "HRFchr/ILK_HRFchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "HRFchr/ILK_HRFchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "HRFchr/ILK_HRFchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "HRFchr/V_HRFchr_1-1-1.svg" 

#set out "V_HRFchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "HRFchr/VPL_HRFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"HRFchr/VPL_HRFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"HRFchr/VPL_HRFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"HRFchr/P_HRFchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "HRFchr/V_HRFchr_2-1-1.svg" 

#set out "V_HRFchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "HRFchr/VPL_HRFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"HRFchr/VPL_HRFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"HRFchr/VPL_HRFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"HRFchr/P_HRFchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "HRFchr/E_HRFchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "HRFchr/T_HRFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"HRFchr/T_HRFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"HRFchr/T_HRFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"HRFchr/T_HRFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"HRFchr/T_HRFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"HRFchr/T_HRFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"HRFchr/T_HRFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"HRFchr/T_HRFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"HRFchr/T_HRFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "HRFchr/E_HRFchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "HRFchr/EXP_HRFchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "HRFchr/E_HRFchr.txt" every :::0::0 u 1:2 t "e11" w l ,"HRFchr/E_HRFchr.txt" every :::0::0 u 1:3 t "e12" w l ,"HRFchr/E_HRFchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "HRFchr/EXP_HRFchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "HRFchr/E_HRFchr.txt" every :::0::0 u 1:5 t "e21" w l ,"HRFchr/E_HRFchr.txt" every :::0::0 u 1:6 t "e22" w l ,"HRFchr/E_HRFchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "HRFchr/LIJ_HRFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFchr/PIJ_HRFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "HRFchr/LIJ_HRFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFchr/PIJ_HRFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "HRFchr/LIJT_HRFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFchr/PIJ_HRFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "HRFchr/LIJT_HRFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFchr/PIJ_HRFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "HRFchr/P_HRFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFchr/PIJ_HRFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "HRFchr/P_HRFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFchr/PIJ_HRFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-5.370180; p2=0.088546; 
#   current state 3
p3=-15.927497; p4=0.193644; 
# initial state 2
#   current state 1
p5=0.925146; p6=-0.052478; 
#   current state 3
p7=-12.866143; p8=0.145651; 
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

set out "HRFchr/PE_HRFchr_1-1-1.svg" 
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

set out "HRFchr/PE_HRFchr_1-2-1.svg" 
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

set out "HRFchr/PE_HRFchr_1-3-1.svg" 
set key outside 
set title "()" font "Helvetica,12"

set ter svg size 640, 480 
set ylabel "Quasi-incidence per year"

set log y
plot  [50:90]  (1.)/(1+exp(p1+p2*x)+exp(p3+p4*x)) w l lw 2 lt (3*1+1)%3+1 dt 1 t "i11" , 0.500000*exp(p1+p2*x)/(1+exp(p1+p2*x)+exp(p3+p4*x)) w l lw 2 lt (3*1+2)%3+1 dt 1 t "i12" , 0.500000*exp(p3+p4*x)/(1+exp(p1+p2*x)+exp(p3+p4*x)) w l lw 2 lt (3*1+3)%3+1 dt 1 t "i13" , 0.500000*exp(p5+p6*x)/(1+exp(p5+p6*x)+exp(p7+p8*x)) w l lw 2 lt (3*2+1)%3+1 dt 2 t "i21" , (1.)/(1+exp(p5+p6*x)+exp(p7+p8*x)) w l lw 2 lt (3*2+2)%3+1 dt 2 t "i22" , 0.500000*exp(p7+p8*x)/(1+exp(p5+p6*x)+exp(p7+p8*x)) w l lw 2 lt (3*2+3)%3+1 dt 2 t "i23" 
 set out; unset title;set key default;

# Routine varprob
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p13 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "HRFchr/VARPIJGR_HRFchr_113-12.svg"
set label "50" at  6.970e-004, 1.400e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  6.970e-004+ 2.000*( 2.350e-003* 3.112e-002*cos(t)+-1.000e+000* 1.208e-003*sin(t)),  1.400e-001 +2.000*( 1.000e+000* 3.112e-002*cos(t)+ 2.350e-003* 1.208e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.585e-003, 1.882e-001 center
replot  1.585e-003+ 2.000*( 2.171e-003* 2.543e-002*cos(t)+ 1.000e+000* 2.289e-003*sin(t)),  1.882e-001 +2.000*(-1.000e+000* 2.543e-002*cos(t)+ 2.171e-003* 2.289e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  3.435e-003, 2.412e-001 center
replot  3.435e-003+ 2.000*( 2.137e-002* 2.271e-002*cos(t)+ 9.998e-001* 3.987e-003*sin(t)),  2.412e-001 +2.000*(-9.998e-001* 2.271e-002*cos(t)+ 2.137e-002* 3.987e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  7.068e-003, 2.934e-001 center
replot  7.068e-003+ 2.000*( 3.616e-002* 2.778e-002*cos(t)+ 9.993e-001* 6.411e-003*sin(t)),  2.934e-001 +2.000*(-9.993e-001* 2.778e-002*cos(t)+ 3.616e-002* 6.411e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.379e-002, 3.384e-001 center
replot  1.379e-002+ 2.000*( 5.146e-002* 3.435e-002*cos(t)+ 9.987e-001* 9.667e-003*sin(t)),  3.384e-001 +2.000*(-9.987e-001* 3.435e-002*cos(t)+ 5.146e-002* 9.667e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.553e-002, 3.705e-001 center
replot  2.553e-002+ 2.000*( 1.258e-001* 3.762e-002*cos(t)+ 9.921e-001* 1.453e-002*sin(t)),  3.705e-001 +2.000*(-9.921e-001* 3.762e-002*cos(t)+ 1.258e-001* 1.453e-002*sin(t)) not
# Age 80, p13 - p12
set label "80" at  4.494e-002, 3.856e-001 center
replot  4.494e-002+ 2.000*( 4.537e-001* 4.324e-002*cos(t)+ 8.912e-001* 2.082e-002*sin(t)),  3.856e-001 +2.000*(-8.912e-001* 4.324e-002*cos(t)+ 4.537e-001* 2.082e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  7.507e-002, 3.808e-001 center
replot  7.507e-002+ 2.000*( 6.943e-001* 7.228e-002*cos(t)+ 7.197e-001* 1.973e-002*sin(t)),  3.808e-001 +2.000*(-7.197e-001* 7.228e-002*cos(t)+ 6.943e-001* 1.973e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.184e-001, 3.552e-001 center
replot  1.184e-001+ 2.000*( 7.233e-001* 1.297e-001*cos(t)+ 6.906e-001* 1.465e-002*sin(t)),  3.552e-001 +2.000*(-6.906e-001* 1.297e-001*cos(t)+ 7.233e-001* 1.465e-002*sin(t)) not
set out;
set out "HRFchr/VARPIJGR_HRFchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "HRFchr/VARPIJGR_HRFchr_121-12.svg"
set label "50" at  7.707e-002, 1.400e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  7.707e-002+ 2.000*( 5.413e-004* 3.112e-002*cos(t)+-1.000e+000* 1.770e-002*sin(t)),  1.400e-001 +2.000*( 1.000e+000* 3.112e-002*cos(t)+ 5.413e-004* 1.770e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  6.125e-002, 1.882e-001 center
replot  6.125e-002+ 2.000*( 3.120e-004* 2.543e-002*cos(t)+-1.000e+000* 1.102e-002*sin(t)),  1.882e-001 +2.000*( 1.000e+000* 2.543e-002*cos(t)+ 3.120e-004* 1.102e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  4.813e-002, 2.412e-001 center
replot  4.813e-002+ 2.000*( 1.203e-005* 2.271e-002*cos(t)+-1.000e+000* 6.851e-003*sin(t)),  2.412e-001 +2.000*( 1.000e+000* 2.271e-002*cos(t)+ 1.203e-005* 6.851e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.728e-002, 2.934e-001 center
replot  3.728e-002+ 2.000*( 1.967e-004* 2.776e-002*cos(t)+ 1.000e+000* 5.113e-003*sin(t)),  2.934e-001 +2.000*(-1.000e+000* 2.776e-002*cos(t)+ 1.967e-004* 5.113e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.825e-002, 3.384e-001 center
replot  2.825e-002+ 2.000*( 2.662e-004* 3.431e-002*cos(t)+ 1.000e+000* 4.877e-003*sin(t)),  3.384e-001 +2.000*(-1.000e+000* 3.431e-002*cos(t)+ 2.662e-004* 4.877e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.065e-002, 3.705e-001 center
replot  2.065e-002+ 2.000*( 2.948e-004* 3.736e-002*cos(t)+ 1.000e+000* 4.816e-003*sin(t)),  3.705e-001 +2.000*(-1.000e+000* 3.736e-002*cos(t)+ 2.948e-004* 4.816e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.419e-002, 3.856e-001 center
replot  1.419e-002+ 2.000*( 2.074e-004* 3.967e-002*cos(t)+ 1.000e+000* 4.340e-003*sin(t)),  3.856e-001 +2.000*(-1.000e+000* 3.967e-002*cos(t)+ 2.074e-004* 4.340e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  8.862e-003, 3.808e-001 center
replot  8.862e-003+ 2.000*( 7.541e-005* 5.380e-002*cos(t)+ 1.000e+000* 3.429e-003*sin(t)),  3.808e-001 +2.000*(-1.000e+000* 5.380e-002*cos(t)+ 7.541e-005* 3.429e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  4.881e-003, 3.552e-001 center
replot  4.881e-003+ 2.000*( 7.048e-005* 9.020e-002*cos(t)+ 1.000e+000* 2.341e-003*sin(t)),  3.552e-001 +2.000*(-1.000e+000* 9.020e-002*cos(t)+ 7.048e-005* 2.341e-003*sin(t)) not
set out;
set out "HRFchr/VARPIJGR_HRFchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "HRFchr/VARPIJGR_HRFchr_123-12.svg"
set label "50" at  1.584e-003, 1.400e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  1.584e-003+ 2.000*( 1.541e-004* 3.112e-002*cos(t)+-1.000e+000* 7.985e-004*sin(t)),  1.400e-001 +2.000*( 1.000e+000* 3.112e-002*cos(t)+ 1.541e-004* 7.985e-004*sin(t)) not
# Age 55, p23 - p12
set label "55" at  3.390e-003, 1.882e-001 center
replot  3.390e-003+ 2.000*( 7.062e-004* 2.543e-002*cos(t)+-1.000e+000* 1.419e-003*sin(t)),  1.882e-001 +2.000*( 1.000e+000* 2.543e-002*cos(t)+ 7.062e-004* 1.419e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  7.173e-003, 2.412e-001 center
replot  7.173e-003+ 2.000*( 2.325e-003* 2.271e-002*cos(t)+-1.000e+000* 2.398e-003*sin(t)),  2.412e-001 +2.000*( 1.000e+000* 2.271e-002*cos(t)+ 2.325e-003* 2.398e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.496e-002, 2.934e-001 center
replot  1.496e-002+ 2.000*( 3.502e-003* 2.776e-002*cos(t)+-1.000e+000* 3.789e-003*sin(t)),  2.934e-001 +2.000*( 1.000e+000* 2.776e-002*cos(t)+ 3.502e-003* 3.789e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  3.054e-002, 3.384e-001 center
replot  3.054e-002+ 2.000*( 4.238e-003* 3.431e-002*cos(t)+-1.000e+000* 5.489e-003*sin(t)),  3.384e-001 +2.000*( 1.000e+000* 3.431e-002*cos(t)+ 4.238e-003* 5.489e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  6.011e-002, 3.705e-001 center
replot  6.011e-002+ 2.000*( 4.695e-003* 3.736e-002*cos(t)+-1.000e+000* 7.570e-003*sin(t)),  3.705e-001 +2.000*( 1.000e+000* 3.736e-002*cos(t)+ 4.695e-003* 7.570e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.112e-001, 3.856e-001 center
replot  1.112e-001+ 2.000*( 2.332e-003* 3.967e-002*cos(t)+-1.000e+000* 1.214e-002*sin(t)),  3.856e-001 +2.000*( 1.000e+000* 3.967e-002*cos(t)+ 2.332e-003* 1.214e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.871e-001, 3.808e-001 center
replot  1.871e-001+ 2.000*( 3.289e-004* 5.380e-002*cos(t)+ 1.000e+000* 2.168e-002*sin(t)),  3.808e-001 +2.000*(-1.000e+000* 5.380e-002*cos(t)+ 3.289e-004* 2.168e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.774e-001, 3.552e-001 center
replot  2.774e-001+ 2.000*( 2.349e-003* 9.020e-002*cos(t)+-1.000e+000* 3.130e-002*sin(t)),  3.552e-001 +2.000*( 1.000e+000* 9.020e-002*cos(t)+ 2.349e-003* 3.130e-002*sin(t)) not
set out;
set out "HRFchr/VARPIJGR_HRFchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "HRFchr/VARPIJGR_HRFchr_121-13.svg"
set label "50" at  7.707e-002, 6.970e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  7.707e-002+ 2.000*( 1.000e+000* 1.770e-002*cos(t)+-2.160e-004* 1.211e-003*sin(t)),  6.970e-004 +2.000*( 2.160e-004* 1.770e-002*cos(t)+ 1.000e+000* 1.211e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  6.125e-002, 1.585e-003 center
replot  6.125e-002+ 2.000*( 1.000e+000* 1.102e-002*cos(t)+-1.067e-003* 2.290e-003*sin(t)),  1.585e-003 +2.000*( 1.067e-003* 1.102e-002*cos(t)+ 1.000e+000* 2.290e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  4.813e-002, 3.435e-003 center
replot  4.813e-002+ 2.000*( 1.000e+000* 6.851e-003*cos(t)+-7.133e-003* 4.016e-003*sin(t)),  3.435e-003 +2.000*( 7.133e-003* 6.851e-003*cos(t)+ 1.000e+000* 4.016e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.728e-002, 7.068e-003 center
replot  3.728e-002+ 2.000*( 2.283e-002* 6.486e-003*cos(t)+-9.997e-001* 5.112e-003*sin(t)),  7.068e-003 +2.000*( 9.997e-001* 6.486e-003*cos(t)+ 2.283e-002* 5.112e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.825e-002, 1.379e-002 center
replot  2.825e-002+ 2.000*( 7.289e-003* 9.815e-003*cos(t)+-1.000e+000* 4.877e-003*sin(t)),  1.379e-002 +2.000*( 1.000e+000* 9.815e-003*cos(t)+ 7.289e-003* 4.877e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.065e-002, 2.553e-002 center
replot  2.065e-002+ 2.000*( 2.956e-003* 1.517e-002*cos(t)+-1.000e+000* 4.816e-003*sin(t)),  2.553e-002 +2.000*( 1.000e+000* 1.517e-002*cos(t)+ 2.956e-003* 4.816e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.419e-002, 4.494e-002 center
replot  1.419e-002+ 2.000*( 6.975e-004* 2.700e-002*cos(t)+-1.000e+000* 4.340e-003*sin(t)),  4.494e-002 +2.000*( 1.000e+000* 2.700e-002*cos(t)+ 6.975e-004* 4.340e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  8.862e-003, 7.507e-002 center
replot  8.862e-003+ 2.000*( 1.340e-004* 5.216e-002*cos(t)+-1.000e+000* 3.429e-003*sin(t)),  7.507e-002 +2.000*( 1.000e+000* 5.216e-002*cos(t)+ 1.340e-004* 3.429e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  4.881e-003, 1.184e-001 center
replot  4.881e-003+ 2.000*( 7.938e-005* 9.436e-002*cos(t)+-1.000e+000* 2.341e-003*sin(t)),  1.184e-001 +2.000*( 1.000e+000* 9.436e-002*cos(t)+ 7.938e-005* 2.341e-003*sin(t)) not
set out;
set out "HRFchr/VARPIJGR_HRFchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "HRFchr/VARPIJGR_HRFchr_123-13.svg"
set label "50" at  1.584e-003, 6.970e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  1.584e-003+ 2.000*( 7.794e-002* 1.213e-003*cos(t)+ 9.970e-001* 7.953e-004*sin(t)),  6.970e-004 +2.000*(-9.970e-001* 1.213e-003*cos(t)+ 7.794e-002* 7.953e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  3.390e-003, 1.585e-003 center
replot  3.390e-003+ 2.000*( 7.021e-002* 2.293e-003*cos(t)+ 9.975e-001* 1.413e-003*sin(t)),  1.585e-003 +2.000*(-9.975e-001* 2.293e-003*cos(t)+ 7.021e-002* 1.413e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  7.173e-003, 3.435e-003 center
replot  7.173e-003+ 2.000*( 6.776e-002* 4.022e-003*cos(t)+ 9.977e-001* 2.389e-003*sin(t)),  3.435e-003 +2.000*(-9.977e-001* 4.022e-003*cos(t)+ 6.776e-002* 2.389e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.496e-002, 7.068e-003 center
replot  1.496e-002+ 2.000*( 6.655e-002* 6.495e-003*cos(t)+ 9.978e-001* 3.774e-003*sin(t)),  7.068e-003 +2.000*(-9.978e-001* 6.495e-003*cos(t)+ 6.655e-002* 3.774e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  3.054e-002, 1.379e-002 center
replot  3.054e-002+ 2.000*( 5.745e-002* 9.826e-003*cos(t)+ 9.983e-001* 5.471e-003*sin(t)),  1.379e-002 +2.000*(-9.983e-001* 9.826e-003*cos(t)+ 5.745e-002* 5.471e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  6.011e-002, 2.553e-002 center
replot  6.011e-002+ 2.000*( 3.029e-002* 1.518e-002*cos(t)+ 9.995e-001* 7.562e-003*sin(t)),  2.553e-002 +2.000*(-9.995e-001* 1.518e-002*cos(t)+ 3.029e-002* 7.562e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.112e-001, 4.494e-002 center
replot  1.112e-001+ 2.000*( 4.798e-003* 2.700e-002*cos(t)+ 1.000e+000* 1.214e-002*sin(t)),  4.494e-002 +2.000*(-1.000e+000* 2.700e-002*cos(t)+ 4.798e-003* 1.214e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.871e-001, 7.507e-002 center
replot  1.871e-001+ 2.000*( 1.053e-004* 5.216e-002*cos(t)+ 1.000e+000* 2.168e-002*sin(t)),  7.507e-002 +2.000*(-1.000e+000* 5.216e-002*cos(t)+ 1.053e-004* 2.168e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.774e-001, 1.184e-001 center
replot  2.774e-001+ 2.000*( 2.572e-003* 9.437e-002*cos(t)+ 1.000e+000* 3.130e-002*sin(t)),  1.184e-001 +2.000*(-1.000e+000* 9.437e-002*cos(t)+ 2.572e-003* 3.130e-002*sin(t)) not
set out;
set out "HRFchr/VARPIJGR_HRFchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "HRFchr/VARPIJGR_HRFchr_123-21.svg"
set label "50" at  1.584e-003, 7.707e-002 center
# Age 50, p23 - p21
plot [-pi:pi]  1.584e-003+ 2.000*( 2.660e-003* 1.770e-002*cos(t)+ 1.000e+000* 7.971e-004*sin(t)),  7.707e-002 +2.000*(-1.000e+000* 1.770e-002*cos(t)+ 2.660e-003* 7.971e-004*sin(t)) not
# Age 55, p23 - p21
set label "55" at  3.390e-003, 6.125e-002 center
replot  3.390e-003+ 2.000*( 5.479e-003* 1.102e-002*cos(t)+ 1.000e+000* 1.417e-003*sin(t)),  6.125e-002 +2.000*(-1.000e+000* 1.102e-002*cos(t)+ 5.479e-003* 1.417e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  7.173e-003, 4.813e-002 center
replot  7.173e-003+ 2.000*( 1.577e-002* 6.852e-003*cos(t)+ 9.999e-001* 2.397e-003*sin(t)),  4.813e-002 +2.000*(-9.999e-001* 6.852e-003*cos(t)+ 1.577e-002* 2.397e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.496e-002, 3.728e-002 center
replot  1.496e-002+ 2.000*( 8.537e-002* 5.122e-003*cos(t)+ 9.963e-001* 3.778e-003*sin(t)),  3.728e-002 +2.000*(-9.963e-001* 5.122e-003*cos(t)+ 8.537e-002* 3.778e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  3.054e-002, 2.825e-002 center
replot  3.054e-002+ 2.000*( 9.689e-001* 5.531e-003*cos(t)+ 2.475e-001* 4.831e-003*sin(t)),  2.825e-002 +2.000*(-2.475e-001* 5.531e-003*cos(t)+ 9.689e-001* 4.831e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  6.011e-002, 2.065e-002 center
replot  6.011e-002+ 2.000*( 9.972e-001* 7.585e-003*cos(t)+ 7.483e-002* 4.796e-003*sin(t)),  2.065e-002 +2.000*(-7.483e-002* 7.585e-003*cos(t)+ 9.972e-001* 4.796e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.112e-001, 1.419e-002 center
replot  1.112e-001+ 2.000*( 9.993e-001* 1.215e-002*cos(t)+ 3.652e-002* 4.320e-003*sin(t)),  1.419e-002 +2.000*(-3.652e-002* 1.215e-002*cos(t)+ 9.993e-001* 4.320e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.871e-001, 8.862e-003 center
replot  1.871e-001+ 2.000*( 9.997e-001* 2.168e-002*cos(t)+ 2.532e-002* 3.385e-003*sin(t)),  8.862e-003 +2.000*(-2.532e-002* 2.168e-002*cos(t)+ 9.997e-001* 3.385e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.774e-001, 4.881e-003 center
replot  2.774e-001+ 2.000*( 9.998e-001* 3.131e-002*cos(t)+ 1.990e-002* 2.257e-003*sin(t)),  4.881e-003 +2.000*(-1.990e-002* 3.131e-002*cos(t)+ 9.998e-001* 2.257e-003*sin(t)) not
set out;
set out "HRFchr/VARPIJGR_HRFchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "HRFchr/VARMUPTJGR--STABLBASED_HRFchr1.svg";
 plot "HRFchr/PRMORPREV-1-STABLBASED_HRFchr.txt"  u 1:($3) not w l lt 1 
 replot "HRFchr/PRMORPREV-1-STABLBASED_HRFchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "HRFchr/PRMORPREV-1-STABLBASED_HRFchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "HRFchr/VARMUPTJGR--STABLBASED_HRFchr1.svg";replot;set out;
