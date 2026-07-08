
# IMaCh-0.99r45
# EEMchr.gp
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


set ter svg size 640, 480;set out "EEMchr/D_EEMchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "EEMchr/ILK_EEMchr-dest.png";
set log y;plot  "EEMchr/ILK_EEMchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "EEMchr/ILK_EEMchr-ori.png";
set log y;plot  "EEMchr/ILK_EEMchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "EEMchr/ILK_EEMchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "EEMchr/ILK_EEMchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "EEMchr/ILK_EEMchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "EEMchr/ILK_EEMchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "EEMchr/V_EEMchr_1-1-1.svg" 

#set out "V_EEMchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "EEMchr/VPL_EEMchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"EEMchr/VPL_EEMchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"EEMchr/VPL_EEMchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"EEMchr/P_EEMchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "EEMchr/V_EEMchr_2-1-1.svg" 

#set out "V_EEMchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "EEMchr/VPL_EEMchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"EEMchr/VPL_EEMchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"EEMchr/VPL_EEMchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"EEMchr/P_EEMchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "EEMchr/E_EEMchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "EEMchr/T_EEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"EEMchr/T_EEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"EEMchr/T_EEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"EEMchr/T_EEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"EEMchr/T_EEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"EEMchr/T_EEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"EEMchr/T_EEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"EEMchr/T_EEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"EEMchr/T_EEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "EEMchr/E_EEMchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "EEMchr/EXP_EEMchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "EEMchr/E_EEMchr.txt" every :::0::0 u 1:2 t "e11" w l ,"EEMchr/E_EEMchr.txt" every :::0::0 u 1:3 t "e12" w l ,"EEMchr/E_EEMchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "EEMchr/EXP_EEMchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "EEMchr/E_EEMchr.txt" every :::0::0 u 1:5 t "e21" w l ,"EEMchr/E_EEMchr.txt" every :::0::0 u 1:6 t "e22" w l ,"EEMchr/E_EEMchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "EEMchr/LIJ_EEMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEMchr/PIJ_EEMchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "EEMchr/LIJ_EEMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEMchr/PIJ_EEMchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "EEMchr/LIJT_EEMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEMchr/PIJ_EEMchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "EEMchr/LIJT_EEMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEMchr/PIJ_EEMchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "EEMchr/P_EEMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEMchr/PIJ_EEMchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "EEMchr/P_EEMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEMchr/PIJ_EEMchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-3.519495; p2=0.058527; 
#   current state 3
p3=-12.020153; p4=0.143196; 
# initial state 2
#   current state 1
p5=-0.062036; p6=-0.030689; 
#   current state 3
p7=-7.134123; p8=0.075185; 
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

set out "EEMchr/PE_EEMchr_1-1-1.svg" 
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

set out "EEMchr/PE_EEMchr_1-2-1.svg" 
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

set out "EEMchr/PE_EEMchr_1-3-1.svg" 
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
set out "EEMchr/VARPIJGR_EEMchr_113-12.svg"
set label "50" at  2.483e-003, 1.771e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  2.483e-003+ 2.000*( 4.499e-003* 2.194e-002*cos(t)+-1.000e+000* 1.727e-003*sin(t)),  1.771e-001 +2.000*( 1.000e+000* 2.194e-002*cos(t)+ 4.499e-003* 1.727e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  4.513e-003, 2.108e-001 center
replot  4.513e-003+ 2.000*( 4.172e-003* 1.655e-002*cos(t)+ 1.000e+000* 2.508e-003*sin(t)),  2.108e-001 +2.000*(-1.000e+000* 1.655e-002*cos(t)+ 4.172e-003* 2.508e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  8.011e-003, 2.450e-001 center
replot  8.011e-003+ 2.000*( 3.290e-002* 1.358e-002*cos(t)+ 9.995e-001* 3.435e-003*sin(t)),  2.450e-001 +2.000*(-9.995e-001* 1.358e-002*cos(t)+ 3.290e-002* 3.435e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.385e-002, 2.774e-001 center
replot  1.385e-002+ 2.000*( 4.756e-002* 1.575e-002*cos(t)+ 9.989e-001* 4.667e-003*sin(t)),  2.774e-001 +2.000*(-9.989e-001* 1.575e-002*cos(t)+ 4.756e-002* 4.667e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  2.328e-002, 3.053e-001 center
replot  2.328e-002+ 2.000*( 6.697e-002* 2.055e-002*cos(t)+ 9.978e-001* 7.024e-003*sin(t)),  3.053e-001 +2.000*(-9.978e-001* 2.055e-002*cos(t)+ 6.697e-002* 7.024e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  3.792e-002, 3.257e-001 center
replot  3.792e-002+ 2.000*( 2.022e-001* 2.577e-002*cos(t)+ 9.793e-001* 1.200e-002*sin(t)),  3.257e-001 +2.000*(-9.793e-001* 2.577e-002*cos(t)+ 2.022e-001* 1.200e-002*sin(t)) not
# Age 80, p13 - p12
set label "80" at  5.964e-002, 3.355e-001 center
replot  5.964e-002+ 2.000*( 5.453e-001* 3.580e-002*cos(t)+ 8.382e-001* 1.751e-002*sin(t)),  3.355e-001 +2.000*(-8.382e-001* 3.580e-002*cos(t)+ 5.453e-001* 1.751e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  9.021e-002, 3.323e-001 center
replot  9.021e-002+ 2.000*( 7.084e-001* 5.885e-002*cos(t)+ 7.058e-001* 1.839e-002*sin(t)),  3.323e-001 +2.000*(-7.058e-001* 5.885e-002*cos(t)+ 7.084e-001* 1.839e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.305e-001, 3.147e-001 center
replot  1.305e-001+ 2.000*( 7.384e-001* 9.414e-002*cos(t)+ 6.743e-001* 1.634e-002*sin(t)),  3.147e-001 +2.000*(-6.743e-001* 9.414e-002*cos(t)+ 7.384e-001* 1.634e-002*sin(t)) not
set out;
set out "EEMchr/VARPIJGR_EEMchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "EEMchr/VARPIJGR_EEMchr_121-12.svg"
set label "50" at  8.190e-002, 1.771e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  8.190e-002+ 2.000*( 5.395e-004* 2.194e-002*cos(t)+-1.000e+000* 1.179e-002*sin(t)),  1.771e-001 +2.000*( 1.000e+000* 2.194e-002*cos(t)+ 5.395e-004* 1.179e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  7.101e-002, 2.108e-001 center
replot  7.101e-002+ 2.000*( 4.698e-004* 1.655e-002*cos(t)+-1.000e+000* 8.004e-003*sin(t)),  2.108e-001 +2.000*( 1.000e+000* 1.655e-002*cos(t)+ 4.698e-004* 8.004e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  6.101e-002, 2.450e-001 center
replot  6.101e-002+ 2.000*( 3.608e-004* 1.357e-002*cos(t)+-1.000e+000* 5.477e-003*sin(t)),  2.450e-001 +2.000*( 1.000e+000* 1.357e-002*cos(t)+ 3.608e-004* 5.477e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  5.182e-002, 2.774e-001 center
replot  5.182e-002+ 2.000*( 2.608e-004* 1.574e-002*cos(t)+ 1.000e+000* 4.453e-003*sin(t)),  2.774e-001 +2.000*(-1.000e+000* 1.574e-002*cos(t)+ 2.608e-004* 4.453e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  4.340e-002, 3.053e-001 center
replot  4.340e-002+ 2.000*( 1.243e-003* 2.051e-002*cos(t)+ 1.000e+000* 4.589e-003*sin(t)),  3.053e-001 +2.000*(-1.000e+000* 2.051e-002*cos(t)+ 1.243e-003* 4.589e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  3.568e-002, 3.257e-001 center
replot  3.568e-002+ 2.000*( 2.655e-003* 2.535e-002*cos(t)+ 1.000e+000* 5.032e-003*sin(t)),  3.257e-001 +2.000*(-1.000e+000* 2.535e-002*cos(t)+ 2.655e-003* 5.032e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.867e-002, 3.355e-001 center
replot  2.867e-002+ 2.000*( 4.015e-003* 3.149e-002*cos(t)+ 1.000e+000* 5.284e-003*sin(t)),  3.355e-001 +2.000*(-1.000e+000* 3.149e-002*cos(t)+ 4.015e-003* 5.284e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  2.240e-002, 3.323e-001 center
replot  2.240e-002+ 2.000*( 3.879e-003* 4.353e-002*cos(t)+ 1.000e+000* 5.208e-003*sin(t)),  3.323e-001 +2.000*(-1.000e+000* 4.353e-002*cos(t)+ 3.879e-003* 5.208e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.694e-002, 3.147e-001 center
replot  1.694e-002+ 2.000*( 2.675e-003* 6.462e-002*cos(t)+ 1.000e+000* 4.827e-003*sin(t)),  3.147e-001 +2.000*(-1.000e+000* 6.462e-002*cos(t)+ 2.675e-003* 4.827e-003*sin(t)) not
set out;
set out "EEMchr/VARPIJGR_EEMchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "EEMchr/VARPIJGR_EEMchr_123-12.svg"
set label "50" at  1.383e-002, 1.771e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  1.383e-002+ 2.000*( 1.181e-004* 2.194e-002*cos(t)+-1.000e+000* 3.053e-003*sin(t)),  1.771e-001 +2.000*( 1.000e+000* 2.194e-002*cos(t)+ 1.181e-004* 3.053e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.037e-002, 2.108e-001 center
replot  2.037e-002+ 2.000*( 2.587e-004* 1.655e-002*cos(t)+-1.000e+000* 3.616e-003*sin(t)),  2.108e-001 +2.000*( 1.000e+000* 1.655e-002*cos(t)+ 2.587e-004* 3.616e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  2.971e-002, 2.450e-001 center
replot  2.971e-002+ 2.000*( 7.896e-004* 1.357e-002*cos(t)+-1.000e+000* 4.088e-003*sin(t)),  2.450e-001 +2.000*( 1.000e+000* 1.357e-002*cos(t)+ 7.896e-004* 4.088e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  4.285e-002, 2.774e-001 center
replot  4.285e-002+ 2.000*( 1.524e-003* 1.574e-002*cos(t)+-1.000e+000* 4.451e-003*sin(t)),  2.774e-001 +2.000*( 1.000e+000* 1.574e-002*cos(t)+ 1.524e-003* 4.451e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  6.091e-002, 3.053e-001 center
replot  6.091e-002+ 2.000*( 2.421e-003* 2.051e-002*cos(t)+-1.000e+000* 5.002e-003*sin(t)),  3.053e-001 +2.000*( 1.000e+000* 2.051e-002*cos(t)+ 2.421e-003* 5.002e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  8.503e-002, 3.257e-001 center
replot  8.503e-002+ 2.000*( 4.336e-003* 2.535e-002*cos(t)+-1.000e+000* 6.659e-003*sin(t)),  3.257e-001 +2.000*( 1.000e+000* 2.535e-002*cos(t)+ 4.336e-003* 6.659e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.160e-001, 3.355e-001 center
replot  1.160e-001+ 2.000*( 7.516e-003* 3.149e-002*cos(t)+-1.000e+000* 1.031e-002*sin(t)),  3.355e-001 +2.000*( 1.000e+000* 3.149e-002*cos(t)+ 7.516e-003* 1.031e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.539e-001, 3.323e-001 center
replot  1.539e-001+ 2.000*( 9.380e-003* 4.353e-002*cos(t)+-1.000e+000* 1.589e-002*sin(t)),  3.323e-001 +2.000*( 1.000e+000* 4.353e-002*cos(t)+ 9.380e-003* 1.589e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.976e-001, 3.147e-001 center
replot  1.976e-001+ 2.000*( 8.375e-003* 6.462e-002*cos(t)+-1.000e+000* 2.250e-002*sin(t)),  3.147e-001 +2.000*( 1.000e+000* 6.462e-002*cos(t)+ 8.375e-003* 2.250e-002*sin(t)) not
set out;
set out "EEMchr/VARPIJGR_EEMchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "EEMchr/VARPIJGR_EEMchr_121-13.svg"
set label "50" at  8.190e-002, 2.483e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  8.190e-002+ 2.000*( 1.000e+000* 1.179e-002*cos(t)+-1.018e-003* 1.729e-003*sin(t)),  2.483e-003 +2.000*( 1.018e-003* 1.179e-002*cos(t)+ 1.000e+000* 1.729e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  7.101e-002, 4.513e-003 center
replot  7.101e-002+ 2.000*( 1.000e+000* 8.004e-003*cos(t)+-1.293e-003* 2.509e-003*sin(t)),  4.513e-003 +2.000*( 1.293e-003* 8.004e-003*cos(t)+ 1.000e+000* 2.509e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  6.101e-002, 8.011e-003 center
replot  6.101e-002+ 2.000*( 1.000e+000* 5.477e-003*cos(t)+-2.801e-003* 3.462e-003*sin(t)),  8.011e-003 +2.000*( 2.801e-003* 5.477e-003*cos(t)+ 1.000e+000* 3.462e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  5.182e-002, 1.385e-002 center
replot  5.182e-002+ 2.000*( 9.044e-002* 4.723e-003*cos(t)+-9.959e-001* 4.451e-003*sin(t)),  1.385e-002 +2.000*( 9.959e-001* 4.723e-003*cos(t)+ 9.044e-002* 4.451e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  4.340e-002, 2.328e-002 center
replot  4.340e-002+ 2.000*( 2.950e-002* 7.144e-003*cos(t)+-9.996e-001* 4.586e-003*sin(t)),  2.328e-002 +2.000*( 9.996e-001* 7.144e-003*cos(t)+ 2.950e-002* 4.586e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  3.568e-002, 3.792e-002 center
replot  3.568e-002+ 2.000*( 1.725e-002* 1.286e-002*cos(t)+-9.999e-001* 5.029e-003*sin(t)),  3.792e-002 +2.000*( 9.999e-001* 1.286e-002*cos(t)+ 1.725e-002* 5.029e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.867e-002, 5.964e-002 center
replot  2.867e-002+ 2.000*( 9.023e-003* 2.442e-002*cos(t)+-1.000e+000* 5.282e-003*sin(t)),  5.964e-002 +2.000*( 1.000e+000* 2.442e-002*cos(t)+ 9.023e-003* 5.282e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  2.240e-002, 9.021e-002 center
replot  2.240e-002+ 2.000*( 4.759e-003* 4.366e-002*cos(t)+-1.000e+000* 5.207e-003*sin(t)),  9.021e-002 +2.000*( 1.000e+000* 4.366e-002*cos(t)+ 4.759e-003* 5.207e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.694e-002, 1.305e-001 center
replot  1.694e-002+ 2.000*( 2.640e-003* 7.039e-002*cos(t)+-1.000e+000* 4.826e-003*sin(t)),  1.305e-001 +2.000*( 1.000e+000* 7.039e-002*cos(t)+ 2.640e-003* 4.826e-003*sin(t)) not
set out;
set out "EEMchr/VARPIJGR_EEMchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "EEMchr/VARPIJGR_EEMchr_123-13.svg"
set label "50" at  1.383e-002, 2.483e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  1.383e-002+ 2.000*( 1.000e+000* 3.053e-003*cos(t)+ 5.123e-003* 1.729e-003*sin(t)),  2.483e-003 +2.000*(-5.123e-003* 3.053e-003*cos(t)+ 1.000e+000* 1.729e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.037e-002, 4.513e-003 center
replot  2.037e-002+ 2.000*( 1.000e+000* 3.616e-003*cos(t)+ 7.422e-003* 2.509e-003*sin(t)),  4.513e-003 +2.000*(-7.422e-003* 3.616e-003*cos(t)+ 1.000e+000* 2.509e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  2.971e-002, 8.011e-003 center
replot  2.971e-002+ 2.000*( 9.998e-001* 4.089e-003*cos(t)+ 1.801e-002* 3.462e-003*sin(t)),  8.011e-003 +2.000*(-1.801e-002* 4.089e-003*cos(t)+ 9.998e-001* 3.462e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  4.285e-002, 1.385e-002 center
replot  4.285e-002+ 2.000*( 8.226e-002* 4.723e-003*cos(t)+ 9.966e-001* 4.449e-003*sin(t)),  1.385e-002 +2.000*(-9.966e-001* 4.723e-003*cos(t)+ 8.226e-002* 4.449e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  6.091e-002, 2.328e-002 center
replot  6.091e-002+ 2.000*( 2.605e-002* 7.144e-003*cos(t)+ 9.997e-001* 5.000e-003*sin(t)),  2.328e-002 +2.000*(-9.997e-001* 7.144e-003*cos(t)+ 2.605e-002* 5.000e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  8.503e-002, 3.792e-002 center
replot  8.503e-002+ 2.000*( 1.879e-002* 1.286e-002*cos(t)+ 9.998e-001* 6.657e-003*sin(t)),  3.792e-002 +2.000*(-9.998e-001* 1.286e-002*cos(t)+ 1.879e-002* 6.657e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.160e-001, 5.964e-002 center
replot  1.160e-001+ 2.000*( 1.361e-002* 2.442e-002*cos(t)+ 9.999e-001* 1.031e-002*sin(t)),  5.964e-002 +2.000*(-9.999e-001* 2.442e-002*cos(t)+ 1.361e-002* 1.031e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.539e-001, 9.021e-002 center
replot  1.539e-001+ 2.000*( 9.926e-003* 4.366e-002*cos(t)+ 1.000e+000* 1.589e-002*sin(t)),  9.021e-002 +2.000*(-1.000e+000* 4.366e-002*cos(t)+ 9.926e-003* 1.589e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.976e-001, 1.305e-001 center
replot  1.976e-001+ 2.000*( 7.490e-003* 7.039e-002*cos(t)+ 1.000e+000* 2.250e-002*sin(t)),  1.305e-001 +2.000*(-1.000e+000* 7.039e-002*cos(t)+ 7.490e-003* 2.250e-002*sin(t)) not
set out;
set out "EEMchr/VARPIJGR_EEMchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "EEMchr/VARPIJGR_EEMchr_123-21.svg"
set label "50" at  1.383e-002, 8.190e-002 center
# Age 50, p23 - p21
plot [-pi:pi]  1.383e-002+ 2.000*( 2.190e-002* 1.179e-002*cos(t)+ 9.998e-001* 3.043e-003*sin(t)),  8.190e-002 +2.000*(-9.998e-001* 1.179e-002*cos(t)+ 2.190e-002* 3.043e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.037e-002, 7.101e-002 center
replot  2.037e-002+ 2.000*( 4.385e-002* 8.010e-003*cos(t)+ 9.990e-001* 3.602e-003*sin(t)),  7.101e-002 +2.000*(-9.990e-001* 8.010e-003*cos(t)+ 4.385e-002* 3.602e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  2.971e-002, 6.101e-002 center
replot  2.971e-002+ 2.000*( 1.455e-001* 5.504e-003*cos(t)+ 9.894e-001* 4.052e-003*sin(t)),  6.101e-002 +2.000*(-9.894e-001* 5.504e-003*cos(t)+ 1.455e-001* 4.052e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  4.285e-002, 5.182e-002 center
replot  4.285e-002+ 2.000*( 7.056e-001* 4.681e-003*cos(t)+ 7.086e-001* 4.211e-003*sin(t)),  5.182e-002 +2.000*(-7.086e-001* 4.681e-003*cos(t)+ 7.056e-001* 4.211e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  6.091e-002, 4.340e-002 center
replot  6.091e-002+ 2.000*( 8.963e-001* 5.129e-003*cos(t)+ 4.435e-001* 4.446e-003*sin(t)),  4.340e-002 +2.000*(-4.435e-001* 5.129e-003*cos(t)+ 8.963e-001* 4.446e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  8.503e-002, 3.568e-002 center
replot  8.503e-002+ 2.000*( 9.798e-001* 6.722e-003*cos(t)+ 2.002e-001* 4.950e-003*sin(t)),  3.568e-002 +2.000*(-2.002e-001* 6.722e-003*cos(t)+ 9.798e-001* 4.950e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.160e-001, 2.867e-002 center
replot  1.160e-001+ 2.000*( 9.954e-001* 1.035e-002*cos(t)+ 9.619e-002* 5.216e-003*sin(t)),  2.867e-002 +2.000*(-9.619e-002* 1.035e-002*cos(t)+ 9.954e-001* 5.216e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.539e-001, 2.240e-002 center
replot  1.539e-001+ 2.000*( 9.979e-001* 1.592e-002*cos(t)+ 6.467e-002* 5.119e-003*sin(t)),  2.240e-002 +2.000*(-6.467e-002* 1.592e-002*cos(t)+ 9.979e-001* 5.119e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.976e-001, 1.694e-002 center
replot  1.976e-001+ 2.000*( 9.987e-001* 2.253e-002*cos(t)+ 5.113e-002* 4.696e-003*sin(t)),  1.694e-002 +2.000*(-5.113e-002* 2.253e-002*cos(t)+ 9.987e-001* 4.696e-003*sin(t)) not
set out;
set out "EEMchr/VARPIJGR_EEMchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "EEMchr/VARMUPTJGR--STABLBASED_EEMchr1.svg";
 plot "EEMchr/PRMORPREV-1-STABLBASED_EEMchr.txt"  u 1:($3) not w l lt 1 
 replot "EEMchr/PRMORPREV-1-STABLBASED_EEMchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "EEMchr/PRMORPREV-1-STABLBASED_EEMchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "EEMchr/VARMUPTJGR--STABLBASED_EEMchr1.svg";replot;set out;
