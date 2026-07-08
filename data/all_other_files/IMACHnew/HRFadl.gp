
# IMaCh-0.99r45
# HRFadl.gp
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


set ter svg size 640, 480;set out "HRFadl/D_HRFadl_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "HRFadl/ILK_HRFadl-dest.png";
set log y;plot  "HRFadl/ILK_HRFadl.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "HRFadl/ILK_HRFadl-ori.png";
set log y;plot  "HRFadl/ILK_HRFadl.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "HRFadl/ILK_HRFadl-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "HRFadl/ILK_HRFadl.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "HRFadl/ILK_HRFadl-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "HRFadl/ILK_HRFadl.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "HRFadl/V_HRFadl_1-1-1.svg" 

#set out "V_HRFadl_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "HRFadl/VPL_HRFadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"HRFadl/VPL_HRFadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"HRFadl/VPL_HRFadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"HRFadl/P_HRFadl.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "HRFadl/V_HRFadl_2-1-1.svg" 

#set out "V_HRFadl_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "HRFadl/VPL_HRFadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"HRFadl/VPL_HRFadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"HRFadl/VPL_HRFadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"HRFadl/P_HRFadl.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "HRFadl/E_HRFadl_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "HRFadl/T_HRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"HRFadl/T_HRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"HRFadl/T_HRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"HRFadl/T_HRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"HRFadl/T_HRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"HRFadl/T_HRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"HRFadl/T_HRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"HRFadl/T_HRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"HRFadl/T_HRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "HRFadl/E_HRFadl_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "HRFadl/EXP_HRFadl_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "HRFadl/E_HRFadl.txt" every :::0::0 u 1:2 t "e11" w l ,"HRFadl/E_HRFadl.txt" every :::0::0 u 1:3 t "e12" w l ,"HRFadl/E_HRFadl.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "HRFadl/EXP_HRFadl_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "HRFadl/E_HRFadl.txt" every :::0::0 u 1:5 t "e21" w l ,"HRFadl/E_HRFadl.txt" every :::0::0 u 1:6 t "e22" w l ,"HRFadl/E_HRFadl.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "HRFadl/LIJ_HRFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFadl/PIJ_HRFadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "HRFadl/LIJ_HRFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFadl/PIJ_HRFadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "HRFadl/LIJT_HRFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFadl/PIJ_HRFadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "HRFadl/LIJT_HRFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFadl/PIJ_HRFadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "HRFadl/P_HRFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFadl/PIJ_HRFadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "HRFadl/P_HRFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFadl/PIJ_HRFadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-9.186877; p2=0.088563; 
#   current state 3
p3=-12.521141; p4=0.109074; 
# initial state 2
#   current state 1
p5=0.851186; p6=-0.029178; 
#   current state 3
p7=-9.516274; p8=0.097561; 
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

set out "HRFadl/PE_HRFadl_1-1-1.svg" 
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

set out "HRFadl/PE_HRFadl_1-2-1.svg" 
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

set out "HRFadl/PE_HRFadl_1-3-1.svg" 
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
set out "HRFadl/VARPIJGR_HRFadl_113-12.svg"
set label "50" at  1.689e-003, 1.699e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  1.689e-003+ 2.000*( 5.864e-002* 5.622e-003*cos(t)+ 9.983e-001* 1.389e-003*sin(t)),  1.699e-002 +2.000*(-9.983e-001* 5.622e-003*cos(t)+ 5.864e-002* 1.389e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  2.898e-003, 2.632e-002 center
replot  2.898e-003+ 2.000*( 6.308e-002* 7.014e-003*cos(t)+ 9.980e-001* 1.954e-003*sin(t)),  2.632e-002 +2.000*(-9.980e-001* 7.014e-003*cos(t)+ 6.308e-002* 1.954e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  4.959e-003, 4.064e-002 center
replot  4.959e-003+ 2.000*( 6.656e-002* 8.380e-003*cos(t)+ 9.978e-001* 2.640e-003*sin(t)),  4.064e-002 +2.000*(-9.978e-001* 8.380e-003*cos(t)+ 6.656e-002* 2.640e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  8.444e-003, 6.246e-002 center
replot  8.444e-003+ 2.000*( 6.932e-002* 9.655e-003*cos(t)+ 9.976e-001* 3.417e-003*sin(t)),  6.246e-002 +2.000*(-9.976e-001* 9.655e-003*cos(t)+ 6.932e-002* 3.417e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.428e-002, 9.531e-002 center
replot  1.428e-002+ 2.000*( 8.293e-002* 1.165e-002*cos(t)+ 9.966e-001* 4.405e-003*sin(t)),  9.531e-002 +2.000*(-9.966e-001* 1.165e-002*cos(t)+ 8.293e-002* 4.405e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.387e-002, 1.438e-001 center
replot  2.387e-002+ 2.000*( 1.319e-001* 1.771e-002*cos(t)+ 9.913e-001* 6.598e-003*sin(t)),  1.438e-001 +2.000*(-9.913e-001* 1.771e-002*cos(t)+ 1.319e-001* 6.598e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.927e-002, 2.136e-001 center
replot  3.927e-002+ 2.000*( 1.974e-001* 3.278e-002*cos(t)+ 9.803e-001* 1.255e-002*sin(t)),  2.136e-001 +2.000*(-9.803e-001* 3.278e-002*cos(t)+ 1.974e-001* 1.255e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  6.310e-002, 3.097e-001 center
replot  6.310e-002+ 2.000*( 2.734e-001* 6.097e-002*cos(t)+ 9.619e-001* 2.542e-002*sin(t)),  3.097e-001 +2.000*(-9.619e-001* 6.097e-002*cos(t)+ 2.734e-001* 2.542e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  9.815e-002, 4.348e-001 center
replot  9.815e-002+ 2.000*( 3.740e-001* 1.064e-001*cos(t)+ 9.274e-001* 4.746e-002*sin(t)),  4.348e-001 +2.000*(-9.274e-001* 1.064e-001*cos(t)+ 3.740e-001* 4.746e-002*sin(t)) not
set out;
set out "HRFadl/VARPIJGR_HRFadl_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "HRFadl/VARPIJGR_HRFadl_121-12.svg"
set label "50" at  7.008e-001, 1.699e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  7.008e-001+ 2.000*( 9.999e-001* 1.732e-001*cos(t)+-1.199e-002* 5.215e-003*sin(t)),  1.699e-002 +2.000*( 1.199e-002* 1.732e-001*cos(t)+ 9.999e-001* 5.215e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  6.333e-001, 2.632e-002 center
replot  6.333e-001+ 2.000*( 9.998e-001* 1.333e-001*cos(t)+-1.879e-002* 6.539e-003*sin(t)),  2.632e-002 +2.000*( 1.879e-002* 1.333e-001*cos(t)+ 9.998e-001* 6.539e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  5.679e-001, 4.064e-002 center
replot  5.679e-001+ 2.000*( 9.996e-001* 9.868e-002*cos(t)+-2.908e-002* 7.859e-003*sin(t)),  4.064e-002 +2.000*( 2.908e-002* 9.868e-002*cos(t)+ 9.996e-001* 7.859e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  5.046e-001, 6.246e-002 center
replot  5.046e-001+ 2.000*( 9.990e-001* 7.223e-002*cos(t)+-4.482e-002* 9.083e-003*sin(t)),  6.246e-002 +2.000*( 4.482e-002* 7.223e-002*cos(t)+ 9.990e-001* 9.083e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  4.429e-001, 9.531e-002 center
replot  4.429e-001+ 2.000*( 9.972e-001* 5.778e-002*cos(t)+-7.503e-002* 1.081e-002*sin(t)),  9.531e-002 +2.000*( 7.503e-002* 5.778e-002*cos(t)+ 9.972e-001* 1.081e-002*sin(t)) not
# Age 75, p21 - p12
set label "75" at  3.824e-001, 1.438e-001 center
replot  3.824e-001+ 2.000*( 9.894e-001* 5.619e-002*cos(t)+-1.451e-001* 1.574e-002*sin(t)),  1.438e-001 +2.000*( 1.451e-001* 5.619e-002*cos(t)+ 9.894e-001* 1.574e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  3.225e-001, 2.136e-001 center
replot  3.225e-001+ 2.000*( 9.552e-001* 6.211e-002*cos(t)+-2.959e-001* 2.771e-002*sin(t)),  2.136e-001 +2.000*( 2.959e-001* 6.211e-002*cos(t)+ 9.552e-001* 2.771e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  2.632e-001, 3.097e-001 center
replot  2.632e-001+ 2.000*( 7.631e-001* 7.358e-002*cos(t)+-6.463e-001* 4.590e-002*sin(t)),  3.097e-001 +2.000*( 6.463e-001* 7.358e-002*cos(t)+ 7.631e-001* 4.590e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  2.056e-001, 4.348e-001 center
replot  2.056e-001+ 2.000*( 3.374e-001* 1.046e-001*cos(t)+-9.414e-001* 5.604e-002*sin(t)),  4.348e-001 +2.000*( 9.414e-001* 1.046e-001*cos(t)+ 3.374e-001* 5.604e-002*sin(t)) not
set out;
set out "HRFadl/VARPIJGR_HRFadl_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "HRFadl/VARPIJGR_HRFadl_123-12.svg"
set label "50" at  1.245e-002, 1.699e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  1.245e-002+ 2.000*( 9.956e-001* 1.075e-002*cos(t)+-9.339e-002* 5.547e-003*sin(t)),  1.699e-002 +2.000*( 9.339e-002* 1.075e-002*cos(t)+ 9.956e-001* 5.547e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.120e-002, 2.632e-002 center
replot  2.120e-002+ 2.000*( 9.970e-001* 1.547e-002*cos(t)+-7.768e-002* 6.918e-003*sin(t)),  2.632e-002 +2.000*( 7.768e-002* 1.547e-002*cos(t)+ 9.970e-001* 6.918e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.583e-002, 4.064e-002 center
replot  3.583e-002+ 2.000*( 9.979e-001* 2.138e-002*cos(t)+-6.504e-002* 8.264e-003*sin(t)),  4.064e-002 +2.000*( 6.504e-002* 2.138e-002*cos(t)+ 9.979e-001* 8.264e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  6.000e-002, 6.246e-002 center
replot  6.000e-002+ 2.000*( 9.985e-001* 2.798e-002*cos(t)+-5.493e-002* 9.525e-003*sin(t)),  6.246e-002 +2.000*( 5.493e-002* 2.798e-002*cos(t)+ 9.985e-001* 9.525e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  9.926e-002, 9.531e-002 center
replot  9.926e-002+ 2.000*( 9.987e-001* 3.387e-002*cos(t)+-5.023e-002* 1.151e-002*sin(t)),  9.531e-002 +2.000*( 5.023e-002* 3.387e-002*cos(t)+ 9.987e-001* 1.151e-002*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.615e-001, 1.438e-001 center
replot  1.615e-001+ 2.000*( 9.973e-001* 3.717e-002*cos(t)+-7.314e-002* 1.741e-002*sin(t)),  1.438e-001 +2.000*( 7.314e-002* 3.717e-002*cos(t)+ 9.973e-001* 1.741e-002*sin(t)) not
# Age 80, p23 - p12
set label "80" at  2.566e-001, 2.136e-001 center
replot  2.566e-001+ 2.000*( 9.420e-001* 4.100e-002*cos(t)+-3.356e-001* 3.094e-002*sin(t)),  2.136e-001 +2.000*( 3.356e-001* 4.100e-002*cos(t)+ 9.420e-001* 3.094e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  3.948e-001, 3.097e-001 center
replot  3.948e-001+ 2.000*( 7.570e-001* 6.736e-002*cos(t)+-6.534e-001* 5.203e-002*sin(t)),  3.097e-001 +2.000*( 6.534e-001* 6.736e-002*cos(t)+ 7.570e-001* 5.203e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  5.812e-001, 4.348e-001 center
replot  5.812e-001+ 2.000*( 8.597e-001* 1.235e-001*cos(t)+-5.108e-001* 9.059e-002*sin(t)),  4.348e-001 +2.000*( 5.108e-001* 1.235e-001*cos(t)+ 8.597e-001* 9.059e-002*sin(t)) not
set out;
set out "HRFadl/VARPIJGR_HRFadl_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "HRFadl/VARPIJGR_HRFadl_121-13.svg"
set label "50" at  7.008e-001, 1.689e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  7.008e-001+ 2.000*( 1.000e+000* 1.732e-001*cos(t)+ 1.396e-004* 1.425e-003*sin(t)),  1.689e-003 +2.000*(-1.396e-004* 1.732e-001*cos(t)+ 1.000e+000* 1.425e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  6.333e-001, 2.898e-003 center
replot  6.333e-001+ 2.000*( 1.000e+000* 1.333e-001*cos(t)+ 2.517e-005* 2.000e-003*sin(t)),  2.898e-003 +2.000*(-2.517e-005* 1.333e-001*cos(t)+ 1.000e+000* 2.000e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  5.679e-001, 4.959e-003 center
replot  5.679e-001+ 2.000*( 1.000e+000* 9.864e-002*cos(t)+-5.991e-004* 2.692e-003*sin(t)),  4.959e-003 +2.000*( 5.991e-004* 9.864e-002*cos(t)+ 1.000e+000* 2.692e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  5.046e-001, 8.444e-003 center
replot  5.046e-001+ 2.000*( 1.000e+000* 7.216e-002*cos(t)+-2.550e-003* 3.469e-003*sin(t)),  8.444e-003 +2.000*( 2.550e-003* 7.216e-002*cos(t)+ 1.000e+000* 3.469e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  4.429e-001, 1.428e-002 center
replot  4.429e-001+ 2.000*( 1.000e+000* 5.763e-002*cos(t)+-5.014e-003* 4.486e-003*sin(t)),  1.428e-002 +2.000*( 5.014e-003* 5.763e-002*cos(t)+ 1.000e+000* 4.486e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  3.824e-001, 2.387e-002 center
replot  3.824e-001+ 2.000*( 1.000e+000* 5.564e-002*cos(t)+-1.568e-003* 6.945e-003*sin(t)),  2.387e-002 +2.000*( 1.568e-003* 5.564e-002*cos(t)+ 1.000e+000* 6.945e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  3.225e-001, 3.927e-002 center
replot  3.225e-001+ 2.000*( 9.999e-001* 5.989e-002*cos(t)+ 1.009e-002* 1.389e-002*sin(t)),  3.927e-002 +2.000*(-1.009e-002* 5.989e-002*cos(t)+ 9.999e-001* 1.389e-002*sin(t)) not
# Age 85, p21 - p13
set label "85" at  2.632e-001, 6.310e-002 center
replot  2.632e-001+ 2.000*( 9.996e-001* 6.352e-002*cos(t)+ 2.880e-002* 2.955e-002*sin(t)),  6.310e-002 +2.000*(-2.880e-002* 6.352e-002*cos(t)+ 9.996e-001* 2.955e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  2.056e-001, 9.815e-002 center
replot  2.056e-001+ 2.000*( 9.853e-001* 6.359e-002*cos(t)+ 1.706e-001* 5.920e-002*sin(t)),  9.815e-002 +2.000*(-1.706e-001* 6.359e-002*cos(t)+ 9.853e-001* 5.920e-002*sin(t)) not
set out;
set out "HRFadl/VARPIJGR_HRFadl_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "HRFadl/VARPIJGR_HRFadl_123-13.svg"
set label "50" at  1.245e-002, 1.689e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  1.245e-002+ 2.000*( 9.986e-001* 1.073e-002*cos(t)+ 5.251e-002* 1.311e-003*sin(t)),  1.689e-003 +2.000*(-5.251e-002* 1.073e-002*cos(t)+ 9.986e-001* 1.311e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.120e-002, 2.898e-003 center
replot  2.120e-002+ 2.000*( 9.986e-001* 1.545e-002*cos(t)+ 5.209e-002* 1.833e-003*sin(t)),  2.898e-003 +2.000*(-5.209e-002* 1.545e-002*cos(t)+ 9.986e-001* 1.833e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.583e-002, 4.959e-003 center
replot  3.583e-002+ 2.000*( 9.987e-001* 2.137e-002*cos(t)+ 5.182e-002* 2.458e-003*sin(t)),  4.959e-003 +2.000*(-5.182e-002* 2.137e-002*cos(t)+ 9.987e-001* 2.458e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  6.000e-002, 8.444e-003 center
replot  6.000e-002+ 2.000*( 9.986e-001* 2.798e-002*cos(t)+ 5.204e-002* 3.158e-003*sin(t)),  8.444e-003 +2.000*(-5.204e-002* 2.798e-002*cos(t)+ 9.986e-001* 3.158e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  9.926e-002, 1.428e-002 center
replot  9.926e-002+ 2.000*( 9.985e-001* 3.388e-002*cos(t)+ 5.445e-002* 4.105e-003*sin(t)),  1.428e-002 +2.000*(-5.445e-002* 3.388e-002*cos(t)+ 9.985e-001* 4.105e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.615e-001, 2.387e-002 center
replot  1.615e-001+ 2.000*( 9.977e-001* 3.717e-002*cos(t)+ 6.820e-002* 6.481e-003*sin(t)),  2.387e-002 +2.000*(-6.820e-002* 3.717e-002*cos(t)+ 9.977e-001* 6.481e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  2.566e-001, 3.927e-002 center
replot  2.566e-001+ 2.000*( 9.910e-001* 4.032e-002*cos(t)+ 1.342e-001* 1.293e-002*sin(t)),  3.927e-002 +2.000*(-1.342e-001* 4.032e-002*cos(t)+ 9.910e-001* 1.293e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  3.948e-001, 6.310e-002 center
replot  3.948e-001+ 2.000*( 9.747e-001* 6.257e-002*cos(t)+ 2.236e-001* 2.675e-002*sin(t)),  6.310e-002 +2.000*(-2.236e-001* 6.257e-002*cos(t)+ 9.747e-001* 2.675e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  5.812e-001, 9.815e-002 center
replot  5.812e-001+ 2.000*( 9.710e-001* 1.186e-001*cos(t)+ 2.391e-001* 5.367e-002*sin(t)),  9.815e-002 +2.000*(-2.391e-001* 1.186e-001*cos(t)+ 9.710e-001* 5.367e-002*sin(t)) not
set out;
set out "HRFadl/VARPIJGR_HRFadl_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "HRFadl/VARPIJGR_HRFadl_123-21.svg"
set label "50" at  1.245e-002, 7.008e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.245e-002+ 2.000*( 3.748e-003* 1.732e-001*cos(t)+ 1.000e+000* 1.070e-002*sin(t)),  7.008e-001 +2.000*(-1.000e+000* 1.732e-001*cos(t)+ 3.748e-003* 1.070e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.120e-002, 6.333e-001 center
replot  2.120e-002+ 2.000*( 7.317e-003* 1.333e-001*cos(t)+ 1.000e+000* 1.540e-002*sin(t)),  6.333e-001 +2.000*(-1.000e+000* 1.333e-001*cos(t)+ 7.317e-003* 1.540e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.583e-002, 5.679e-001 center
replot  3.583e-002+ 2.000*( 1.784e-002* 9.865e-002*cos(t)+ 9.998e-001* 2.128e-002*sin(t)),  5.679e-001 +2.000*(-9.998e-001* 9.865e-002*cos(t)+ 1.784e-002* 2.128e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  6.000e-002, 5.046e-001 center
replot  6.000e-002+ 2.000*( 5.122e-002* 7.224e-002*cos(t)+ 9.987e-001* 2.773e-002*sin(t)),  5.046e-001 +2.000*(-9.987e-001* 7.224e-002*cos(t)+ 5.122e-002* 2.773e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  9.926e-002, 4.429e-001 center
replot  9.926e-002+ 2.000*( 1.297e-001* 5.795e-002*cos(t)+ 9.916e-001* 3.327e-002*sin(t)),  4.429e-001 +2.000*(-9.916e-001* 5.795e-002*cos(t)+ 1.297e-001* 3.327e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.615e-001, 3.824e-001 center
replot  1.615e-001+ 2.000*( 1.587e-001* 5.605e-002*cos(t)+ 9.873e-001* 3.647e-002*sin(t)),  3.824e-001 +2.000*(-9.873e-001* 5.605e-002*cos(t)+ 1.587e-001* 3.647e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  2.566e-001, 3.225e-001 center
replot  2.566e-001+ 2.000*( 8.456e-002* 6.001e-002*cos(t)+ 9.964e-001* 3.982e-002*sin(t)),  3.225e-001 +2.000*(-9.964e-001* 6.001e-002*cos(t)+ 8.456e-002* 3.982e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  3.948e-001, 2.632e-001 center
replot  3.948e-001+ 2.000*( 4.276e-001* 6.413e-002*cos(t)+ 9.040e-001* 6.063e-002*sin(t)),  2.632e-001 +2.000*(-9.040e-001* 6.413e-002*cos(t)+ 4.276e-001* 6.063e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  5.812e-001, 2.056e-001 center
replot  5.812e-001+ 2.000*( 9.949e-001* 1.163e-001*cos(t)+ 1.011e-001* 6.268e-002*sin(t)),  2.056e-001 +2.000*(-1.011e-001* 1.163e-001*cos(t)+ 9.949e-001* 6.268e-002*sin(t)) not
set out;
set out "HRFadl/VARPIJGR_HRFadl_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "HRFadl/VARMUPTJGR--STABLBASED_HRFadl1.svg";
 plot "HRFadl/PRMORPREV-1-STABLBASED_HRFadl.txt"  u 1:($3) not w l lt 1 
 replot "HRFadl/PRMORPREV-1-STABLBASED_HRFadl.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "HRFadl/PRMORPREV-1-STABLBASED_HRFadl.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "HRFadl/VARMUPTJGR--STABLBASED_HRFadl1.svg";replot;set out;
