
# IMaCh-0.99r45
# EEMsr.gp
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


set ter svg size 640, 480;set out "EEMsr/D_EEMsr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "EEMsr/ILK_EEMsr-dest.png";
set log y;plot  "EEMsr/ILK_EEMsr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "EEMsr/ILK_EEMsr-ori.png";
set log y;plot  "EEMsr/ILK_EEMsr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "EEMsr/ILK_EEMsr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "EEMsr/ILK_EEMsr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "EEMsr/ILK_EEMsr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "EEMsr/ILK_EEMsr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "EEMsr/V_EEMsr_1-1-1.svg" 

#set out "V_EEMsr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "EEMsr/VPL_EEMsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"EEMsr/VPL_EEMsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"EEMsr/VPL_EEMsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"EEMsr/P_EEMsr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "EEMsr/V_EEMsr_2-1-1.svg" 

#set out "V_EEMsr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "EEMsr/VPL_EEMsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"EEMsr/VPL_EEMsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"EEMsr/VPL_EEMsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"EEMsr/P_EEMsr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "EEMsr/E_EEMsr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "EEMsr/T_EEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"EEMsr/T_EEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"EEMsr/T_EEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"EEMsr/T_EEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"EEMsr/T_EEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"EEMsr/T_EEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"EEMsr/T_EEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"EEMsr/T_EEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"EEMsr/T_EEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "EEMsr/E_EEMsr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "EEMsr/EXP_EEMsr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "EEMsr/E_EEMsr.txt" every :::0::0 u 1:2 t "e11" w l ,"EEMsr/E_EEMsr.txt" every :::0::0 u 1:3 t "e12" w l ,"EEMsr/E_EEMsr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "EEMsr/EXP_EEMsr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "EEMsr/E_EEMsr.txt" every :::0::0 u 1:5 t "e21" w l ,"EEMsr/E_EEMsr.txt" every :::0::0 u 1:6 t "e22" w l ,"EEMsr/E_EEMsr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "EEMsr/LIJ_EEMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEMsr/PIJ_EEMsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "EEMsr/LIJ_EEMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEMsr/PIJ_EEMsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "EEMsr/LIJT_EEMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEMsr/PIJ_EEMsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "EEMsr/LIJT_EEMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEMsr/PIJ_EEMsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "EEMsr/P_EEMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEMsr/PIJ_EEMsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "EEMsr/P_EEMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEMsr/PIJ_EEMsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-4.704379; p2=0.046381; 
#   current state 3
p3=-13.127657; p4=0.122258; 
# initial state 2
#   current state 1
p5=-1.553760; p6=-0.020076; 
#   current state 3
p7=-8.086785; p8=0.067532; 
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

set out "EEMsr/PE_EEMsr_1-1-1.svg" 
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

set out "EEMsr/PE_EEMsr_1-2-1.svg" 
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

set out "EEMsr/PE_EEMsr_1-3-1.svg" 
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
set out "EEMsr/VARPIJGR_EEMsr_113-12.svg"
set label "50" at  1.644e-003, 1.685e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  1.644e-003+ 2.000*( 6.204e-004* 2.308e-002*cos(t)+ 1.000e+000* 1.497e-003*sin(t)),  1.685e-001 +2.000*(-1.000e+000* 2.308e-002*cos(t)+ 6.204e-004* 1.497e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  2.963e-003, 2.077e-001 center
replot  2.963e-003+ 2.000*( 2.780e-003* 2.074e-002*cos(t)+ 1.000e+000* 2.174e-003*sin(t)),  2.077e-001 +2.000*(-1.000e+000* 2.074e-002*cos(t)+ 2.780e-003* 2.174e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  5.309e-003, 2.547e-001 center
replot  5.309e-003+ 2.000*( 1.068e-002* 1.897e-002*cos(t)+ 9.999e-001* 3.083e-003*sin(t)),  2.547e-001 +2.000*(-9.999e-001* 1.897e-002*cos(t)+ 1.068e-002* 3.083e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  9.449e-003, 3.102e-001 center
replot  9.449e-003+ 2.000*( 2.569e-002* 2.191e-002*cos(t)+ 9.997e-001* 4.482e-003*sin(t)),  3.102e-001 +2.000*(-9.997e-001* 2.191e-002*cos(t)+ 2.569e-002* 4.482e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.667e-002, 3.745e-001 center
replot  1.667e-002+ 2.000*( 3.921e-002* 3.273e-002*cos(t)+ 9.992e-001* 7.493e-003*sin(t)),  3.745e-001 +2.000*(-9.992e-001* 3.273e-002*cos(t)+ 3.921e-002* 7.493e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.910e-002, 4.472e-001 center
replot  2.910e-002+ 2.000*( 6.296e-002* 5.046e-002*cos(t)+ 9.980e-001* 1.493e-002*sin(t)),  4.472e-001 +2.000*(-9.980e-001* 5.046e-002*cos(t)+ 6.296e-002* 1.493e-002*sin(t)) not
# Age 80, p13 - p12
set label "80" at  5.008e-002, 5.268e-001 center
replot  5.008e-002+ 2.000*( 1.287e-001* 7.393e-002*cos(t)+ 9.917e-001* 3.140e-002*sin(t)),  5.268e-001 +2.000*(-9.917e-001* 7.393e-002*cos(t)+ 1.287e-001* 3.140e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  8.468e-002, 6.095e-001 center
replot  8.468e-002+ 2.000*( 3.303e-001* 1.052e-001*cos(t)+ 9.439e-001* 6.164e-002*sin(t)),  6.095e-001 +2.000*(-9.439e-001* 1.052e-001*cos(t)+ 3.303e-001* 6.164e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.399e-001, 6.891e-001 center
replot  1.399e-001+ 2.000*( 6.889e-001* 1.636e-001*cos(t)+ 7.249e-001* 9.749e-002*sin(t)),  6.891e-001 +2.000*(-7.249e-001* 1.636e-001*cos(t)+ 6.889e-001* 9.749e-002*sin(t)) not
set out;
set out "EEMsr/VARPIJGR_EEMsr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "EEMsr/VARPIJGR_EEMsr_121-12.svg"
set label "50" at  1.426e-001, 1.685e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  1.426e-001+ 2.000*( 6.304e-001* 2.541e-002*cos(t)+-7.763e-001* 1.900e-002*sin(t)),  1.685e-001 +2.000*( 7.763e-001* 2.541e-002*cos(t)+ 6.304e-001* 1.900e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  1.295e-001, 2.077e-001 center
replot  1.295e-001+ 2.000*( 3.391e-001* 2.145e-002*cos(t)+-9.408e-001* 1.420e-002*sin(t)),  2.077e-001 +2.000*( 9.408e-001* 2.145e-002*cos(t)+ 3.391e-001* 1.420e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  1.173e-001, 2.547e-001 center
replot  1.173e-001+ 2.000*( 1.995e-001* 1.925e-002*cos(t)+-9.799e-001* 1.012e-002*sin(t)),  2.547e-001 +2.000*( 9.799e-001* 1.925e-002*cos(t)+ 1.995e-001* 1.012e-002*sin(t)) not
# Age 65, p21 - p12
set label "65" at  1.060e-001, 3.102e-001 center
replot  1.060e-001+ 2.000*( 1.415e-001* 2.209e-002*cos(t)+-9.899e-001* 8.207e-003*sin(t)),  3.102e-001 +2.000*( 9.899e-001* 2.209e-002*cos(t)+ 1.415e-001* 8.207e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  9.546e-002, 3.745e-001 center
replot  9.546e-002+ 2.000*( 1.090e-001* 3.289e-002*cos(t)+-9.940e-001* 8.663e-003*sin(t)),  3.745e-001 +2.000*( 9.940e-001* 3.289e-002*cos(t)+ 1.090e-001* 8.663e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  8.564e-002, 4.472e-001 center
replot  8.564e-002+ 2.000*( 8.340e-002* 5.054e-002*cos(t)+-9.965e-001* 1.029e-002*sin(t)),  4.472e-001 +2.000*( 9.965e-001* 5.054e-002*cos(t)+ 8.340e-002* 1.029e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  7.640e-002, 5.268e-001 center
replot  7.640e-002+ 2.000*( 6.322e-002* 7.357e-002*cos(t)+-9.980e-001* 1.205e-002*sin(t)),  5.268e-001 +2.000*( 9.980e-001* 7.357e-002*cos(t)+ 6.322e-002* 1.205e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  6.768e-002, 6.095e-001 center
replot  6.768e-002+ 2.000*( 4.647e-002* 1.015e-001*cos(t)+-9.989e-001* 1.355e-002*sin(t)),  6.095e-001 +2.000*( 9.989e-001* 1.015e-001*cos(t)+ 4.647e-002* 1.355e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  5.940e-002, 6.891e-001 center
replot  5.940e-002+ 2.000*( 3.109e-002* 1.364e-001*cos(t)+-9.995e-001* 1.468e-002*sin(t)),  6.891e-001 +2.000*( 9.995e-001* 1.364e-001*cos(t)+ 3.109e-002* 1.468e-002*sin(t)) not
set out;
set out "EEMsr/VARPIJGR_EEMsr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "EEMsr/VARPIJGR_EEMsr_123-12.svg"
set label "50" at  1.657e-002, 1.685e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  1.657e-002+ 2.000*( 3.012e-004* 2.308e-002*cos(t)+ 1.000e+000* 3.700e-003*sin(t)),  1.685e-001 +2.000*(-1.000e+000* 2.308e-002*cos(t)+ 3.012e-004* 3.700e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.331e-002, 2.077e-001 center
replot  2.331e-002+ 2.000*( 7.418e-004* 2.074e-002*cos(t)+-1.000e+000* 4.274e-003*sin(t)),  2.077e-001 +2.000*( 1.000e+000* 2.074e-002*cos(t)+ 7.418e-004* 4.274e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.272e-002, 2.547e-001 center
replot  3.272e-002+ 2.000*( 3.939e-003* 1.897e-002*cos(t)+-1.000e+000* 4.773e-003*sin(t)),  2.547e-001 +2.000*( 1.000e+000* 1.897e-002*cos(t)+ 3.939e-003* 4.773e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  4.582e-002, 3.102e-001 center
replot  4.582e-002+ 2.000*( 8.256e-003* 2.190e-002*cos(t)+-1.000e+000* 5.185e-003*sin(t)),  3.102e-001 +2.000*( 1.000e+000* 2.190e-002*cos(t)+ 8.256e-003* 5.185e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  6.396e-002, 3.745e-001 center
replot  6.396e-002+ 2.000*( 9.422e-003* 3.271e-002*cos(t)+-1.000e+000* 5.771e-003*sin(t)),  3.745e-001 +2.000*( 1.000e+000* 3.271e-002*cos(t)+ 9.422e-003* 5.771e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  8.892e-002, 4.472e-001 center
replot  8.892e-002+ 2.000*( 1.032e-002* 5.037e-002*cos(t)+-9.999e-001* 7.506e-003*sin(t)),  4.472e-001 +2.000*( 9.999e-001* 5.037e-002*cos(t)+ 1.032e-002* 7.506e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.229e-001, 5.268e-001 center
replot  1.229e-001+ 2.000*( 1.319e-002* 7.344e-002*cos(t)+-9.999e-001* 1.196e-002*sin(t)),  5.268e-001 +2.000*( 9.999e-001* 7.344e-002*cos(t)+ 1.319e-002* 1.196e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.688e-001, 6.095e-001 center
replot  1.688e-001+ 2.000*( 1.958e-002* 1.014e-001*cos(t)+-9.998e-001* 2.042e-002*sin(t)),  6.095e-001 +2.000*( 9.998e-001* 1.014e-001*cos(t)+ 1.958e-002* 2.042e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.295e-001, 6.891e-001 center
replot  2.295e-001+ 2.000*( 3.108e-002* 1.364e-001*cos(t)+-9.995e-001* 3.392e-002*sin(t)),  6.891e-001 +2.000*( 9.995e-001* 1.364e-001*cos(t)+ 3.108e-002* 3.392e-002*sin(t)) not
set out;
set out "EEMsr/VARPIJGR_EEMsr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "EEMsr/VARPIJGR_EEMsr_121-13.svg"
set label "50" at  1.426e-001, 1.644e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  1.426e-001+ 2.000*( 1.000e+000* 2.178e-002*cos(t)+-3.808e-003* 1.495e-003*sin(t)),  1.644e-003 +2.000*( 3.808e-003* 2.178e-002*cos(t)+ 1.000e+000* 1.495e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  1.295e-001, 2.963e-003 center
replot  1.295e-001+ 2.000*( 1.000e+000* 1.521e-002*cos(t)+-5.311e-003* 2.173e-003*sin(t)),  2.963e-003 +2.000*( 5.311e-003* 1.521e-002*cos(t)+ 1.000e+000* 2.173e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  1.173e-001, 5.309e-003 center
replot  1.173e-001+ 2.000*( 1.000e+000* 1.063e-002*cos(t)+-6.052e-003* 3.089e-003*sin(t)),  5.309e-003 +2.000*( 6.052e-003* 1.063e-002*cos(t)+ 1.000e+000* 3.089e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  1.060e-001, 9.449e-003 center
replot  1.060e-001+ 2.000*( 9.997e-001* 8.707e-003*cos(t)+-2.249e-002* 4.513e-003*sin(t)),  9.449e-003 +2.000*( 2.249e-002* 8.707e-003*cos(t)+ 9.997e-001* 4.513e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  9.546e-002, 1.667e-002 center
replot  9.546e-002+ 2.000*( 9.810e-001* 9.391e-003*cos(t)+-1.942e-001* 7.518e-003*sin(t)),  1.667e-002 +2.000*( 1.942e-001* 9.391e-003*cos(t)+ 9.810e-001* 7.518e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  8.564e-002, 2.910e-002 center
replot  8.564e-002+ 2.000*( 1.846e-001* 1.537e-002*cos(t)+-9.828e-001* 1.090e-002*sin(t)),  2.910e-002 +2.000*( 9.828e-001* 1.537e-002*cos(t)+ 1.846e-001* 1.090e-002*sin(t)) not
# Age 80, p21 - p13
set label "80" at  7.640e-002, 5.008e-002 center
replot  7.640e-002+ 2.000*( 6.529e-002* 3.261e-002*cos(t)+-9.979e-001* 1.274e-002*sin(t)),  5.008e-002 +2.000*( 9.979e-001* 3.261e-002*cos(t)+ 6.529e-002* 1.274e-002*sin(t)) not
# Age 85, p21 - p13
set label "85" at  6.768e-002, 8.468e-002 center
replot  6.768e-002+ 2.000*( 3.129e-002* 6.781e-002*cos(t)+-9.995e-001* 1.419e-002*sin(t)),  8.468e-002 +2.000*( 9.995e-001* 6.781e-002*cos(t)+ 3.129e-002* 1.419e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  5.940e-002, 1.399e-001 center
replot  5.940e-002+ 2.000*( 1.625e-002* 1.330e-001*cos(t)+-9.999e-001* 1.512e-002*sin(t)),  1.399e-001 +2.000*( 9.999e-001* 1.330e-001*cos(t)+ 1.625e-002* 1.512e-002*sin(t)) not
set out;
set out "EEMsr/VARPIJGR_EEMsr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "EEMsr/VARPIJGR_EEMsr_123-13.svg"
set label "50" at  1.657e-002, 1.644e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  1.657e-002+ 2.000*( 9.983e-001* 3.706e-003*cos(t)+ 5.861e-002* 1.484e-003*sin(t)),  1.644e-003 +2.000*(-5.861e-002* 3.706e-003*cos(t)+ 9.983e-001* 1.484e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.331e-002, 2.963e-003 center
replot  2.331e-002+ 2.000*( 9.966e-001* 4.284e-003*cos(t)+ 8.180e-002* 2.154e-003*sin(t)),  2.963e-003 +2.000*(-8.180e-002* 4.284e-003*cos(t)+ 9.966e-001* 2.154e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.272e-002, 5.309e-003 center
replot  3.272e-002+ 2.000*( 9.907e-001* 4.800e-003*cos(t)+ 1.357e-001* 3.048e-003*sin(t)),  5.309e-003 +2.000*(-1.357e-001* 4.800e-003*cos(t)+ 9.907e-001* 3.048e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  4.582e-002, 9.449e-003 center
replot  4.582e-002+ 2.000*( 9.178e-001* 5.331e-003*cos(t)+ 3.971e-001* 4.346e-003*sin(t)),  9.449e-003 +2.000*(-3.971e-001* 5.331e-003*cos(t)+ 9.178e-001* 4.346e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  6.396e-002, 1.667e-002 center
replot  6.396e-002+ 2.000*( 3.076e-001* 7.781e-003*cos(t)+ 9.515e-001* 5.528e-003*sin(t)),  1.667e-002 +2.000*(-9.515e-001* 7.781e-003*cos(t)+ 3.076e-001* 5.528e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  8.892e-002, 2.910e-002 center
replot  8.892e-002+ 2.000*( 1.577e-001* 1.539e-002*cos(t)+ 9.875e-001* 7.212e-003*sin(t)),  2.910e-002 +2.000*(-9.875e-001* 1.539e-002*cos(t)+ 1.577e-001* 7.212e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.229e-001, 5.008e-002 center
replot  1.229e-001+ 2.000*( 1.083e-001* 3.272e-002*cos(t)+ 9.941e-001* 1.153e-002*sin(t)),  5.008e-002 +2.000*(-9.941e-001* 3.272e-002*cos(t)+ 1.083e-001* 1.153e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.688e-001, 8.468e-002 center
replot  1.688e-001+ 2.000*( 8.013e-002* 6.797e-002*cos(t)+ 9.968e-001* 1.984e-002*sin(t)),  8.468e-002 +2.000*(-9.968e-001* 6.797e-002*cos(t)+ 8.013e-002* 1.984e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.295e-001, 1.399e-001 center
replot  2.295e-001+ 2.000*( 6.177e-002* 1.333e-001*cos(t)+ 9.981e-001* 3.323e-002*sin(t)),  1.399e-001 +2.000*(-9.981e-001* 1.333e-001*cos(t)+ 6.177e-002* 3.323e-002*sin(t)) not
set out;
set out "EEMsr/VARPIJGR_EEMsr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "EEMsr/VARPIJGR_EEMsr_123-21.svg"
set label "50" at  1.657e-002, 1.426e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.657e-002+ 2.000*( 5.720e-003* 2.178e-002*cos(t)+ 1.000e+000* 3.698e-003*sin(t)),  1.426e-001 +2.000*(-1.000e+000* 2.178e-002*cos(t)+ 5.720e-003* 3.698e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.331e-002, 1.295e-001 center
replot  2.331e-002+ 2.000*( 8.381e-003* 1.521e-002*cos(t)+ 1.000e+000* 4.272e-003*sin(t)),  1.295e-001 +2.000*(-1.000e+000* 1.521e-002*cos(t)+ 8.381e-003* 4.272e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.272e-002, 1.173e-001 center
replot  3.272e-002+ 2.000*( 1.466e-002* 1.063e-002*cos(t)+ 9.999e-001* 4.771e-003*sin(t)),  1.173e-001 +2.000*(-9.999e-001* 1.063e-002*cos(t)+ 1.466e-002* 4.771e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  4.582e-002, 1.060e-001 center
replot  4.582e-002+ 2.000*( 2.979e-002* 8.708e-003*cos(t)+ 9.996e-001* 5.184e-003*sin(t)),  1.060e-001 +2.000*(-9.996e-001* 8.708e-003*cos(t)+ 2.979e-002* 5.184e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  6.396e-002, 9.546e-002 center
replot  6.396e-002+ 2.000*( 4.738e-002* 9.333e-003*cos(t)+ 9.989e-001* 5.768e-003*sin(t)),  9.546e-002 +2.000*(-9.989e-001* 9.333e-003*cos(t)+ 4.738e-002* 5.768e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  8.892e-002, 8.564e-002 center
replot  8.892e-002+ 2.000*( 8.010e-002* 1.110e-002*cos(t)+ 9.968e-001* 7.495e-003*sin(t)),  8.564e-002 +2.000*(-9.968e-001* 1.110e-002*cos(t)+ 8.010e-002* 7.495e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.229e-001, 7.640e-002 center
replot  1.229e-001+ 2.000*( 3.923e-001* 1.308e-002*cos(t)+ 9.198e-001* 1.179e-002*sin(t)),  7.640e-002 +2.000*(-9.198e-001* 1.308e-002*cos(t)+ 3.923e-001* 1.179e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.688e-001, 6.768e-002 center
replot  1.688e-001+ 2.000*( 9.935e-001* 2.059e-002*cos(t)+ 1.138e-001* 1.424e-002*sin(t)),  6.768e-002 +2.000*(-1.138e-001* 2.059e-002*cos(t)+ 9.935e-001* 1.424e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.295e-001, 5.940e-002 center
replot  2.295e-001+ 2.000*( 9.984e-001* 3.421e-002*cos(t)+ 5.593e-002* 1.517e-002*sin(t)),  5.940e-002 +2.000*(-5.593e-002* 3.421e-002*cos(t)+ 9.984e-001* 1.517e-002*sin(t)) not
set out;
set out "EEMsr/VARPIJGR_EEMsr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "EEMsr/VARMUPTJGR--STABLBASED_EEMsr1.svg";
 plot "EEMsr/PRMORPREV-1-STABLBASED_EEMsr.txt"  u 1:($3) not w l lt 1 
 replot "EEMsr/PRMORPREV-1-STABLBASED_EEMsr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "EEMsr/PRMORPREV-1-STABLBASED_EEMsr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "EEMsr/VARMUPTJGR--STABLBASED_EEMsr1.svg";replot;set out;
