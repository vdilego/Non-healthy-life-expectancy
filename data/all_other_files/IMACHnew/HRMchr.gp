
# IMaCh-0.99r45
# HRMchr.gp
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


set ter svg size 640, 480;set out "HRMchr/D_HRMchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "HRMchr/ILK_HRMchr-dest.png";
set log y;plot  "HRMchr/ILK_HRMchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "HRMchr/ILK_HRMchr-ori.png";
set log y;plot  "HRMchr/ILK_HRMchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "HRMchr/ILK_HRMchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "HRMchr/ILK_HRMchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "HRMchr/ILK_HRMchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "HRMchr/ILK_HRMchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "HRMchr/V_HRMchr_1-1-1.svg" 

#set out "V_HRMchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "HRMchr/VPL_HRMchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"HRMchr/VPL_HRMchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"HRMchr/VPL_HRMchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"HRMchr/P_HRMchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "HRMchr/V_HRMchr_2-1-1.svg" 

#set out "V_HRMchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "HRMchr/VPL_HRMchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"HRMchr/VPL_HRMchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"HRMchr/VPL_HRMchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"HRMchr/P_HRMchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "HRMchr/E_HRMchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "HRMchr/T_HRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"HRMchr/T_HRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"HRMchr/T_HRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"HRMchr/T_HRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"HRMchr/T_HRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"HRMchr/T_HRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"HRMchr/T_HRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"HRMchr/T_HRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"HRMchr/T_HRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "HRMchr/E_HRMchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "HRMchr/EXP_HRMchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "HRMchr/E_HRMchr.txt" every :::0::0 u 1:2 t "e11" w l ,"HRMchr/E_HRMchr.txt" every :::0::0 u 1:3 t "e12" w l ,"HRMchr/E_HRMchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "HRMchr/EXP_HRMchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "HRMchr/E_HRMchr.txt" every :::0::0 u 1:5 t "e21" w l ,"HRMchr/E_HRMchr.txt" every :::0::0 u 1:6 t "e22" w l ,"HRMchr/E_HRMchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "HRMchr/LIJ_HRMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMchr/PIJ_HRMchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "HRMchr/LIJ_HRMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMchr/PIJ_HRMchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "HRMchr/LIJT_HRMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMchr/PIJ_HRMchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "HRMchr/LIJT_HRMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMchr/PIJ_HRMchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "HRMchr/P_HRMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMchr/PIJ_HRMchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "HRMchr/P_HRMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMchr/PIJ_HRMchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=0.075645; p2=0.003153; 
#   current state 3
p3=-6.860204; p4=0.064143; 
# initial state 2
#   current state 1
p5=0.209527; p6=-0.034903; 
#   current state 3
p7=-9.682799; p8=0.110011; 
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

set out "HRMchr/PE_HRMchr_1-1-1.svg" 
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

set out "HRMchr/PE_HRMchr_1-2-1.svg" 
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

set out "HRMchr/PE_HRMchr_1-3-1.svg" 
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
set out "HRMchr/VARPIJGR_HRMchr_113-12.svg"
set label "50" at  5.661e-003, 2.759e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  5.661e-003+ 2.000*( 7.659e-003* 3.299e-002*cos(t)+ 1.000e+000* 4.669e-003*sin(t)),  2.759e-001 +2.000*(-1.000e+000* 3.299e-002*cos(t)+ 7.659e-003* 4.669e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  7.701e-003, 2.766e-001 center
replot  7.701e-003+ 2.000*( 1.984e-002* 2.466e-002*cos(t)+ 9.998e-001* 5.050e-003*sin(t)),  2.766e-001 +2.000*(-9.998e-001* 2.466e-002*cos(t)+ 1.984e-002* 5.050e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.046e-002, 2.770e-001 center
replot  1.046e-002+ 2.000*( 3.988e-002* 1.968e-002*cos(t)+ 9.992e-001* 5.385e-003*sin(t)),  2.770e-001 +2.000*(-9.992e-001* 1.968e-002*cos(t)+ 3.988e-002* 5.385e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.418e-002, 2.768e-001 center
replot  1.418e-002+ 2.000*( 4.785e-002* 2.039e-002*cos(t)+ 9.989e-001* 6.108e-003*sin(t)),  2.768e-001 +2.000*(-9.989e-001* 2.039e-002*cos(t)+ 4.785e-002* 6.108e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.916e-002, 2.758e-001 center
replot  1.916e-002+ 2.000*( 5.213e-002* 2.614e-002*cos(t)+ 9.986e-001* 8.245e-003*sin(t)),  2.758e-001 +2.000*(-9.986e-001* 2.614e-002*cos(t)+ 5.213e-002* 8.245e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.581e-002, 2.738e-001 center
replot  2.581e-002+ 2.000*( 8.338e-002* 3.442e-002*cos(t)+ 9.965e-001* 1.300e-002*sin(t)),  2.738e-001 +2.000*(-9.965e-001* 3.442e-002*cos(t)+ 8.338e-002* 1.300e-002*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.459e-002, 2.705e-001 center
replot  3.459e-002+ 2.000*( 1.665e-001* 4.416e-002*cos(t)+ 9.860e-001* 2.103e-002*sin(t)),  2.705e-001 +2.000*(-9.860e-001* 4.416e-002*cos(t)+ 1.665e-001* 2.103e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  4.607e-002, 2.656e-001 center
replot  4.607e-002+ 2.000*( 3.388e-001* 5.623e-002*cos(t)+ 9.409e-001* 3.198e-002*sin(t)),  2.656e-001 +2.000*(-9.409e-001* 5.623e-002*cos(t)+ 3.388e-001* 3.198e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  6.086e-002, 2.586e-001 center
replot  6.086e-002+ 2.000*( 5.703e-001* 7.413e-002*cos(t)+ 8.214e-001* 4.326e-002*sin(t)),  2.586e-001 +2.000*(-8.214e-001* 7.413e-002*cos(t)+ 5.703e-001* 4.326e-002*sin(t)) not
set out;
set out "HRMchr/VARPIJGR_HRMchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "HRMchr/VARPIJGR_HRMchr_121-12.svg"
set label "50" at  8.749e-002, 2.759e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  8.749e-002+ 2.000*( 4.252e-004* 3.299e-002*cos(t)+-1.000e+000* 1.953e-002*sin(t)),  2.759e-001 +2.000*( 1.000e+000* 3.299e-002*cos(t)+ 4.252e-004* 1.953e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  7.489e-002, 2.766e-001 center
replot  7.489e-002+ 2.000*( 3.230e-004* 2.466e-002*cos(t)+-1.000e+000* 1.288e-002*sin(t)),  2.766e-001 +2.000*( 1.000e+000* 2.466e-002*cos(t)+ 3.230e-004* 1.288e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  6.340e-002, 2.770e-001 center
replot  6.340e-002+ 2.000*( 2.956e-004* 1.967e-002*cos(t)+-1.000e+000* 8.495e-003*sin(t)),  2.770e-001 +2.000*( 1.000e+000* 1.967e-002*cos(t)+ 2.956e-004* 8.495e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  5.284e-002, 2.768e-001 center
replot  5.284e-002+ 2.000*( 7.999e-005* 2.037e-002*cos(t)+-1.000e+000* 6.843e-003*sin(t)),  2.768e-001 +2.000*( 1.000e+000* 2.037e-002*cos(t)+ 7.999e-005* 6.843e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  4.303e-002, 2.758e-001 center
replot  4.303e-002+ 2.000*( 2.635e-004* 2.610e-002*cos(t)+ 1.000e+000* 7.145e-003*sin(t)),  2.758e-001 +2.000*(-1.000e+000* 2.610e-002*cos(t)+ 2.635e-004* 7.145e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  3.386e-002, 2.738e-001 center
replot  3.386e-002+ 2.000*( 5.199e-004* 3.431e-002*cos(t)+ 1.000e+000* 7.695e-003*sin(t)),  2.738e-001 +2.000*(-1.000e+000* 3.431e-002*cos(t)+ 5.199e-004* 7.695e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.537e-002, 2.705e-001 center
replot  2.537e-002+ 2.000*( 6.624e-004* 4.368e-002*cos(t)+ 1.000e+000* 7.635e-003*sin(t)),  2.705e-001 +2.000*(-1.000e+000* 4.368e-002*cos(t)+ 6.624e-004* 7.635e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.782e-002, 2.656e-001 center
replot  1.782e-002+ 2.000*( 6.894e-004* 5.400e-002*cos(t)+ 1.000e+000* 6.844e-003*sin(t)),  2.656e-001 +2.000*(-1.000e+000* 5.400e-002*cos(t)+ 6.894e-004* 6.844e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.160e-002, 2.586e-001 center
replot  1.160e-002+ 2.000*( 6.069e-004* 6.570e-002*cos(t)+ 1.000e+000* 5.546e-003*sin(t)),  2.586e-001 +2.000*(-1.000e+000* 6.570e-002*cos(t)+ 6.069e-004* 5.546e-003*sin(t)) not
set out;
set out "HRMchr/VARPIJGR_HRMchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "HRMchr/VARPIJGR_HRMchr_123-12.svg"
set label "50" at  6.202e-003, 2.759e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  6.202e-003+ 2.000*( 1.062e-005* 3.299e-002*cos(t)+-1.000e+000* 2.490e-003*sin(t)),  2.759e-001 +2.000*( 1.000e+000* 3.299e-002*cos(t)+ 1.062e-005* 2.490e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.096e-002, 2.766e-001 center
replot  1.096e-002+ 2.000*( 3.736e-005* 2.466e-002*cos(t)+-1.000e+000* 3.556e-003*sin(t)),  2.766e-001 +2.000*( 1.000e+000* 2.466e-002*cos(t)+ 3.736e-005* 3.556e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  1.915e-002, 2.770e-001 center
replot  1.915e-002+ 2.000*( 1.006e-004* 1.967e-002*cos(t)+-1.000e+000* 4.812e-003*sin(t)),  2.770e-001 +2.000*( 1.000e+000* 1.967e-002*cos(t)+ 1.006e-004* 4.812e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  3.293e-002, 2.768e-001 center
replot  3.293e-002+ 2.000*( 1.756e-004* 2.037e-002*cos(t)+-1.000e+000* 6.128e-003*sin(t)),  2.768e-001 +2.000*( 1.000e+000* 2.037e-002*cos(t)+ 1.756e-004* 6.128e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  5.534e-002, 2.758e-001 center
replot  5.534e-002+ 2.000*( 2.647e-004* 2.610e-002*cos(t)+-1.000e+000* 7.649e-003*sin(t)),  2.758e-001 +2.000*( 1.000e+000* 2.610e-002*cos(t)+ 2.647e-004* 7.649e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  8.987e-002, 2.738e-001 center
replot  8.987e-002+ 2.000*( 4.655e-004* 3.431e-002*cos(t)+-1.000e+000* 1.086e-002*sin(t)),  2.738e-001 +2.000*( 1.000e+000* 3.431e-002*cos(t)+ 4.655e-004* 1.086e-002*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.390e-001, 2.705e-001 center
replot  1.390e-001+ 2.000*( 8.744e-004* 4.368e-002*cos(t)+-1.000e+000* 1.806e-002*sin(t)),  2.705e-001 +2.000*( 1.000e+000* 4.368e-002*cos(t)+ 8.744e-004* 1.806e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  2.015e-001, 2.656e-001 center
replot  2.015e-001+ 2.000*( 1.536e-003* 5.400e-002*cos(t)+-1.000e+000* 2.853e-002*sin(t)),  2.656e-001 +2.000*( 1.000e+000* 5.400e-002*cos(t)+ 1.536e-003* 2.853e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.707e-001, 2.586e-001 center
replot  2.707e-001+ 2.000*( 2.100e-003* 6.570e-002*cos(t)+-1.000e+000* 3.791e-002*sin(t)),  2.586e-001 +2.000*( 1.000e+000* 6.570e-002*cos(t)+ 2.100e-003* 3.791e-002*sin(t)) not
set out;
set out "HRMchr/VARPIJGR_HRMchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "HRMchr/VARPIJGR_HRMchr_121-13.svg"
set label "50" at  8.749e-002, 5.661e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  8.749e-002+ 2.000*( 1.000e+000* 1.953e-002*cos(t)+-1.002e-003* 4.675e-003*sin(t)),  5.661e-003 +2.000*( 1.002e-003* 1.953e-002*cos(t)+ 1.000e+000* 4.675e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  7.489e-002, 7.701e-003 center
replot  7.489e-002+ 2.000*( 1.000e+000* 1.288e-002*cos(t)+-1.172e-003* 5.072e-003*sin(t)),  7.701e-003 +2.000*( 1.172e-003* 1.288e-002*cos(t)+ 1.000e+000* 5.072e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  6.340e-002, 1.046e-002 center
replot  6.340e-002+ 2.000*( 1.000e+000* 8.495e-003*cos(t)+-2.675e-003* 5.438e-003*sin(t)),  1.046e-002 +2.000*( 2.675e-003* 8.495e-003*cos(t)+ 1.000e+000* 5.438e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  5.284e-002, 1.418e-002 center
replot  5.284e-002+ 2.000*( 9.994e-001* 6.844e-003*cos(t)+-3.563e-002* 6.177e-003*sin(t)),  1.418e-002 +2.000*( 3.563e-002* 6.844e-003*cos(t)+ 9.994e-001* 6.177e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  4.303e-002, 1.916e-002 center
replot  4.303e-002+ 2.000*( 4.542e-002* 8.348e-003*cos(t)+-9.990e-001* 7.143e-003*sin(t)),  1.916e-002 +2.000*( 9.990e-001* 8.348e-003*cos(t)+ 4.542e-002* 7.143e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  3.386e-002, 2.581e-002 center
replot  3.386e-002+ 2.000*( 1.521e-002* 1.327e-002*cos(t)+-9.999e-001* 7.693e-003*sin(t)),  2.581e-002 +2.000*( 9.999e-001* 1.327e-002*cos(t)+ 1.521e-002* 7.693e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.537e-002, 3.459e-002 center
replot  2.537e-002+ 2.000*( 7.088e-003* 2.201e-002*cos(t)+-1.000e+000* 7.633e-003*sin(t)),  3.459e-002 +2.000*( 1.000e+000* 2.201e-002*cos(t)+ 7.088e-003* 7.633e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.782e-002, 4.607e-002 center
replot  1.782e-002+ 2.000*( 3.527e-003* 3.562e-002*cos(t)+-1.000e+000* 6.843e-003*sin(t)),  4.607e-002 +2.000*( 1.000e+000* 3.562e-002*cos(t)+ 3.527e-003* 6.843e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.160e-002, 6.086e-002 center
replot  1.160e-002+ 2.000*( 1.734e-003* 5.523e-002*cos(t)+-1.000e+000* 5.545e-003*sin(t)),  6.086e-002 +2.000*( 1.000e+000* 5.523e-002*cos(t)+ 1.734e-003* 5.545e-003*sin(t)) not
set out;
set out "HRMchr/VARPIJGR_HRMchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "HRMchr/VARPIJGR_HRMchr_123-13.svg"
set label "50" at  6.202e-003, 5.661e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  6.202e-003+ 2.000*( 2.199e-003* 4.676e-003*cos(t)+ 1.000e+000* 2.490e-003*sin(t)),  5.661e-003 +2.000*(-1.000e+000* 4.676e-003*cos(t)+ 2.199e-003* 2.490e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.096e-002, 7.701e-003 center
replot  1.096e-002+ 2.000*( 3.847e-003* 5.072e-003*cos(t)+ 1.000e+000* 3.556e-003*sin(t)),  7.701e-003 +2.000*(-1.000e+000* 5.072e-003*cos(t)+ 3.847e-003* 3.556e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  1.915e-002, 1.046e-002 center
replot  1.915e-002+ 2.000*( 1.198e-002* 5.438e-003*cos(t)+ 9.999e-001* 4.812e-003*sin(t)),  1.046e-002 +2.000*(-9.999e-001* 5.438e-003*cos(t)+ 1.198e-002* 4.812e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  3.293e-002, 1.418e-002 center
replot  3.293e-002+ 2.000*( 2.161e-001* 6.181e-003*cos(t)+ 9.764e-001* 6.125e-003*sin(t)),  1.418e-002 +2.000*(-9.764e-001* 6.181e-003*cos(t)+ 2.161e-001* 6.125e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  5.534e-002, 1.916e-002 center
replot  5.534e-002+ 2.000*( 3.267e-002* 8.347e-003*cos(t)+ 9.995e-001* 7.648e-003*sin(t)),  1.916e-002 +2.000*(-9.995e-001* 8.347e-003*cos(t)+ 3.267e-002* 7.648e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  8.987e-002, 2.581e-002 center
replot  8.987e-002+ 2.000*( 1.777e-002* 1.327e-002*cos(t)+ 9.998e-001* 1.086e-002*sin(t)),  2.581e-002 +2.000*(-9.998e-001* 1.327e-002*cos(t)+ 1.777e-002* 1.086e-002*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.390e-001, 3.459e-002 center
replot  1.390e-001+ 2.000*( 1.713e-002* 2.201e-002*cos(t)+ 9.999e-001* 1.806e-002*sin(t)),  3.459e-002 +2.000*(-9.999e-001* 2.201e-002*cos(t)+ 1.713e-002* 1.806e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  2.015e-001, 4.607e-002 center
replot  2.015e-001+ 2.000*( 1.322e-002* 3.562e-002*cos(t)+ 9.999e-001* 2.853e-002*sin(t)),  4.607e-002 +2.000*(-9.999e-001* 3.562e-002*cos(t)+ 1.322e-002* 2.853e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.707e-001, 6.086e-002 center
replot  2.707e-001+ 2.000*( 6.736e-003* 5.523e-002*cos(t)+ 1.000e+000* 3.791e-002*sin(t)),  6.086e-002 +2.000*(-1.000e+000* 5.523e-002*cos(t)+ 6.736e-003* 3.791e-002*sin(t)) not
set out;
set out "HRMchr/VARPIJGR_HRMchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "HRMchr/VARPIJGR_HRMchr_123-21.svg"
set label "50" at  6.202e-003, 8.749e-002 center
# Age 50, p23 - p21
plot [-pi:pi]  6.202e-003+ 2.000*( 8.196e-003* 1.953e-002*cos(t)+ 1.000e+000* 2.485e-003*sin(t)),  8.749e-002 +2.000*(-1.000e+000* 1.953e-002*cos(t)+ 8.196e-003* 2.485e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.096e-002, 7.489e-002 center
replot  1.096e-002+ 2.000*( 1.707e-002* 1.289e-002*cos(t)+ 9.999e-001* 3.550e-003*sin(t)),  7.489e-002 +2.000*(-9.999e-001* 1.289e-002*cos(t)+ 1.707e-002* 3.550e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  1.915e-002, 6.340e-002 center
replot  1.915e-002+ 2.000*( 5.704e-002* 8.505e-003*cos(t)+ 9.984e-001* 4.795e-003*sin(t)),  6.340e-002 +2.000*(-9.984e-001* 8.505e-003*cos(t)+ 5.704e-002* 4.795e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  3.293e-002, 5.284e-002 center
replot  3.293e-002+ 2.000*( 3.337e-001* 6.940e-003*cos(t)+ 9.427e-001* 6.018e-003*sin(t)),  5.284e-002 +2.000*(-9.427e-001* 6.940e-003*cos(t)+ 3.337e-001* 6.018e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  5.534e-002, 4.303e-002 center
replot  5.534e-002+ 2.000*( 8.862e-001* 7.830e-003*cos(t)+ 4.632e-001* 6.947e-003*sin(t)),  4.303e-002 +2.000*(-4.632e-001* 7.830e-003*cos(t)+ 8.862e-001* 6.947e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  8.987e-002, 3.386e-002 center
replot  8.987e-002+ 2.000*( 9.891e-001* 1.093e-002*cos(t)+ 1.470e-001* 7.608e-003*sin(t)),  3.386e-002 +2.000*(-1.470e-001* 1.093e-002*cos(t)+ 9.891e-001* 7.608e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.390e-001, 2.537e-002 center
replot  1.390e-001+ 2.000*( 9.974e-001* 1.810e-002*cos(t)+ 7.260e-002* 7.541e-003*sin(t)),  2.537e-002 +2.000*(-7.260e-002* 1.810e-002*cos(t)+ 9.974e-001* 7.541e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  2.015e-001, 1.782e-002 center
replot  2.015e-001+ 2.000*( 9.986e-001* 2.857e-002*cos(t)+ 5.351e-002* 6.681e-003*sin(t)),  1.782e-002 +2.000*(-5.351e-002* 2.857e-002*cos(t)+ 9.986e-001* 6.681e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.707e-001, 1.160e-002 center
replot  2.707e-001+ 2.000*( 9.990e-001* 3.795e-002*cos(t)+ 4.447e-002* 5.288e-003*sin(t)),  1.160e-002 +2.000*(-4.447e-002* 3.795e-002*cos(t)+ 9.990e-001* 5.288e-003*sin(t)) not
set out;
set out "HRMchr/VARPIJGR_HRMchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "HRMchr/VARMUPTJGR--STABLBASED_HRMchr1.svg";
 plot "HRMchr/PRMORPREV-1-STABLBASED_HRMchr.txt"  u 1:($3) not w l lt 1 
 replot "HRMchr/PRMORPREV-1-STABLBASED_HRMchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "HRMchr/PRMORPREV-1-STABLBASED_HRMchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "HRMchr/VARMUPTJGR--STABLBASED_HRMchr1.svg";replot;set out;
