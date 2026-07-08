
# IMaCh-0.99r45
# FRMadl.gp
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


set ter svg size 640, 480;set out "FRMadl/D_FRMadl_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "FRMadl/ILK_FRMadl-dest.png";
set log y;plot  "FRMadl/ILK_FRMadl.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "FRMadl/ILK_FRMadl-ori.png";
set log y;plot  "FRMadl/ILK_FRMadl.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "FRMadl/ILK_FRMadl-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "FRMadl/ILK_FRMadl.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "FRMadl/ILK_FRMadl-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "FRMadl/ILK_FRMadl.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "FRMadl/V_FRMadl_1-1-1.svg" 

#set out "V_FRMadl_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "FRMadl/VPL_FRMadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"FRMadl/VPL_FRMadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"FRMadl/VPL_FRMadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"FRMadl/P_FRMadl.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "FRMadl/V_FRMadl_2-1-1.svg" 

#set out "V_FRMadl_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "FRMadl/VPL_FRMadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"FRMadl/VPL_FRMadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"FRMadl/VPL_FRMadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"FRMadl/P_FRMadl.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "FRMadl/E_FRMadl_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "FRMadl/T_FRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"FRMadl/T_FRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"FRMadl/T_FRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"FRMadl/T_FRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"FRMadl/T_FRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"FRMadl/T_FRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"FRMadl/T_FRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"FRMadl/T_FRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"FRMadl/T_FRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "FRMadl/E_FRMadl_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "FRMadl/EXP_FRMadl_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "FRMadl/E_FRMadl.txt" every :::0::0 u 1:2 t "e11" w l ,"FRMadl/E_FRMadl.txt" every :::0::0 u 1:3 t "e12" w l ,"FRMadl/E_FRMadl.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "FRMadl/EXP_FRMadl_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "FRMadl/E_FRMadl.txt" every :::0::0 u 1:5 t "e21" w l ,"FRMadl/E_FRMadl.txt" every :::0::0 u 1:6 t "e22" w l ,"FRMadl/E_FRMadl.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "FRMadl/LIJ_FRMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRMadl/PIJ_FRMadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "FRMadl/LIJ_FRMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRMadl/PIJ_FRMadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "FRMadl/LIJT_FRMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRMadl/PIJ_FRMadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "FRMadl/LIJT_FRMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRMadl/PIJ_FRMadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "FRMadl/P_FRMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRMadl/PIJ_FRMadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "FRMadl/P_FRMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRMadl/PIJ_FRMadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-10.698148; p2=0.094222; 
#   current state 3
p3=-11.104452; p4=0.090123; 
# initial state 2
#   current state 1
p5=-0.140347; p6=-0.021124; 
#   current state 3
p7=-13.361532; p8=0.136902; 
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

set out "FRMadl/PE_FRMadl_1-1-1.svg" 
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

set out "FRMadl/PE_FRMadl_1-2-1.svg" 
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

set out "FRMadl/PE_FRMadl_1-3-1.svg" 
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
set out "FRMadl/VARPIJGR_FRMadl_113-12.svg"
set label "50" at  2.715e-003, 5.003e-003 center
# Age 50, p13 - p12
plot [-pi:pi]  2.715e-003+ 2.000*( 9.557e-002* 2.069e-003*cos(t)+ 9.954e-001* 1.330e-003*sin(t)),  5.003e-003 +2.000*(-9.954e-001* 2.069e-003*cos(t)+ 9.557e-002* 1.330e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  4.251e-003, 7.995e-003 center
replot  4.251e-003+ 2.000*( 7.108e-002* 2.687e-003*cos(t)+ 9.975e-001* 1.682e-003*sin(t)),  7.995e-003 +2.000*(-9.975e-001* 2.687e-003*cos(t)+ 7.108e-002* 1.682e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  6.646e-003, 1.276e-002 center
replot  6.646e-003+ 2.000*( 4.489e-002* 3.363e-003*cos(t)+ 9.990e-001* 2.046e-003*sin(t)),  1.276e-002 +2.000*(-9.990e-001* 3.363e-003*cos(t)+ 4.489e-002* 2.046e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.037e-002, 2.032e-002 center
replot  1.037e-002+ 2.000*( 2.791e-002* 4.094e-003*cos(t)+ 9.996e-001* 2.434e-003*sin(t)),  2.032e-002 +2.000*(-9.996e-001* 4.094e-003*cos(t)+ 2.791e-002* 2.434e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.613e-002, 3.226e-002 center
replot  1.613e-002+ 2.000*( 6.731e-002* 5.214e-003*cos(t)+ 9.977e-001* 3.130e-003*sin(t)),  3.226e-002 +2.000*(-9.977e-001* 5.214e-003*cos(t)+ 6.731e-002* 3.130e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.495e-002, 5.094e-002 center
replot  2.495e-002+ 2.000*( 1.965e-001* 8.238e-003*cos(t)+ 9.805e-001* 5.030e-003*sin(t)),  5.094e-002 +2.000*(-9.805e-001* 8.238e-003*cos(t)+ 1.965e-001* 5.030e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.830e-002, 7.981e-002 center
replot  3.830e-002+ 2.000*( 2.814e-001* 1.601e-002*cos(t)+ 9.596e-001* 9.512e-003*sin(t)),  7.981e-002 +2.000*(-9.596e-001* 1.601e-002*cos(t)+ 2.814e-001* 9.512e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  5.807e-002, 1.235e-001 center
replot  5.807e-002+ 2.000*( 3.106e-001* 3.192e-002*cos(t)+ 9.506e-001* 1.834e-002*sin(t)),  1.235e-001 +2.000*(-9.506e-001* 3.192e-002*cos(t)+ 3.106e-001* 1.834e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  8.649e-002, 1.878e-001 center
replot  8.649e-002+ 2.000*( 3.339e-001* 6.036e-002*cos(t)+ 9.426e-001* 3.353e-002*sin(t)),  1.878e-001 +2.000*(-9.426e-001* 6.036e-002*cos(t)+ 3.339e-001* 3.353e-002*sin(t)) not
set out;
set out "FRMadl/VARPIJGR_FRMadl_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "FRMadl/VARPIJGR_FRMadl_121-12.svg"
set label "50" at  4.636e-001, 5.003e-003 center
# Age 50, p21 - p12
plot [-pi:pi]  4.636e-001+ 2.000*( 1.000e+000* 1.024e-001*cos(t)+-4.232e-003* 2.018e-003*sin(t)),  5.003e-003 +2.000*( 4.232e-003* 1.024e-001*cos(t)+ 1.000e+000* 2.018e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  4.266e-001, 7.995e-003 center
replot  4.266e-001+ 2.000*( 1.000e+000* 7.787e-002*cos(t)+-6.998e-003* 2.627e-003*sin(t)),  7.995e-003 +2.000*( 6.998e-003* 7.787e-002*cos(t)+ 1.000e+000* 2.627e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.913e-001, 1.276e-002 center
replot  3.913e-001+ 2.000*( 9.999e-001* 5.804e-002*cos(t)+-1.142e-002* 3.295e-003*sin(t)),  1.276e-002 +2.000*( 1.142e-002* 5.804e-002*cos(t)+ 9.999e-001* 3.295e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.575e-001, 2.032e-002 center
replot  3.575e-001+ 2.000*( 9.998e-001* 4.476e-002*cos(t)+-1.849e-002* 4.009e-003*sin(t)),  2.032e-002 +2.000*( 1.849e-002* 4.476e-002*cos(t)+ 9.998e-001* 4.009e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  3.245e-001, 3.226e-002 center
replot  3.245e-001+ 2.000*( 9.995e-001* 3.992e-002*cos(t)+-3.125e-002* 5.057e-003*sin(t)),  3.226e-002 +2.000*( 3.125e-002* 3.992e-002*cos(t)+ 9.995e-001* 5.057e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.913e-001, 5.094e-002 center
replot  2.913e-001+ 2.000*( 9.984e-001* 4.233e-002*cos(t)+-5.639e-002* 7.792e-003*sin(t)),  5.094e-002 +2.000*( 5.639e-002* 4.233e-002*cos(t)+ 9.984e-001* 7.792e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.565e-001, 7.981e-002 center
replot  2.565e-001+ 2.000*( 9.944e-001* 4.759e-002*cos(t)+-1.061e-001* 1.484e-002*sin(t)),  7.981e-002 +2.000*( 1.061e-001* 4.759e-002*cos(t)+ 9.944e-001* 1.484e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  2.182e-001, 1.235e-001 center
replot  2.182e-001+ 2.000*( 9.716e-001* 5.217e-002*cos(t)+-2.367e-001* 2.912e-002*sin(t)),  1.235e-001 +2.000*( 2.367e-001* 5.217e-002*cos(t)+ 9.716e-001* 2.912e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.751e-001, 1.878e-001 center
replot  1.751e-001+ 2.000*( 5.271e-001* 6.167e-002*cos(t)+-8.498e-001* 4.711e-002*sin(t)),  1.878e-001 +2.000*( 8.498e-001* 6.167e-002*cos(t)+ 5.271e-001* 4.711e-002*sin(t)) not
set out;
set out "FRMadl/VARPIJGR_FRMadl_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "FRMadl/VARPIJGR_FRMadl_123-12.svg"
set label "50" at  2.269e-003, 5.003e-003 center
# Age 50, p23 - p12
plot [-pi:pi]  2.269e-003+ 2.000*( 9.866e-001* 2.327e-003*cos(t)+-1.631e-001* 2.056e-003*sin(t)),  5.003e-003 +2.000*( 1.631e-001* 2.327e-003*cos(t)+ 9.866e-001* 2.056e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  4.600e-003, 7.995e-003 center
replot  4.600e-003+ 2.000*( 9.989e-001* 4.023e-003*cos(t)+-4.681e-002* 2.679e-003*sin(t)),  7.995e-003 +2.000*( 4.681e-002* 4.023e-003*cos(t)+ 9.989e-001* 2.679e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  9.299e-003, 1.276e-002 center
replot  9.299e-003+ 2.000*( 9.997e-001* 6.756e-003*cos(t)+-2.535e-002* 3.357e-003*sin(t)),  1.276e-002 +2.000*( 2.535e-002* 6.756e-003*cos(t)+ 9.997e-001* 3.357e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.872e-002, 2.032e-002 center
replot  1.872e-002+ 2.000*( 9.998e-001* 1.088e-002*cos(t)+-1.753e-002* 4.089e-003*sin(t)),  2.032e-002 +2.000*( 1.753e-002* 1.088e-002*cos(t)+ 9.998e-001* 4.089e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  3.745e-002, 3.226e-002 center
replot  3.745e-002+ 2.000*( 9.998e-001* 1.649e-002*cos(t)+-1.780e-002* 5.199e-003*sin(t)),  3.226e-002 +2.000*( 1.780e-002* 1.649e-002*cos(t)+ 9.998e-001* 5.199e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  7.409e-002, 5.094e-002 center
replot  7.409e-002+ 2.000*( 9.994e-001* 2.313e-002*cos(t)+-3.382e-002* 8.104e-003*sin(t)),  5.094e-002 +2.000*( 3.382e-002* 2.313e-002*cos(t)+ 9.994e-001* 8.104e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.438e-001, 7.981e-002 center
replot  1.438e-001+ 2.000*( 9.951e-001* 3.136e-002*cos(t)+-9.861e-002* 1.536e-002*sin(t)),  7.981e-002 +2.000*( 9.861e-002* 3.136e-002*cos(t)+ 9.951e-001* 1.536e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  2.695e-001, 1.235e-001 center
replot  2.695e-001+ 2.000*( 9.852e-001* 5.314e-002*cos(t)+-1.717e-001* 2.993e-002*sin(t)),  1.235e-001 +2.000*( 1.717e-001* 5.314e-002*cos(t)+ 9.852e-001* 2.993e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  4.765e-001, 1.878e-001 center
replot  4.765e-001+ 2.000*( 9.913e-001* 1.115e-001*cos(t)+-1.314e-001* 5.660e-002*sin(t)),  1.878e-001 +2.000*( 1.314e-001* 1.115e-001*cos(t)+ 9.913e-001* 5.660e-002*sin(t)) not
set out;
set out "FRMadl/VARPIJGR_FRMadl_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "FRMadl/VARPIJGR_FRMadl_121-13.svg"
set label "50" at  4.636e-001, 2.715e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  4.636e-001+ 2.000*( 1.000e+000* 1.024e-001*cos(t)+-1.011e-004* 1.339e-003*sin(t)),  2.715e-003 +2.000*( 1.011e-004* 1.024e-001*cos(t)+ 1.000e+000* 1.339e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  4.266e-001, 4.251e-003 center
replot  4.266e-001+ 2.000*( 1.000e+000* 7.787e-002*cos(t)+-8.927e-005* 1.688e-003*sin(t)),  4.251e-003 +2.000*( 8.927e-005* 7.787e-002*cos(t)+ 1.000e+000* 1.688e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.913e-001, 6.646e-003 center
replot  3.913e-001+ 2.000*( 1.000e+000* 5.803e-002*cos(t)+-6.561e-005* 2.050e-003*sin(t)),  6.646e-003 +2.000*( 6.561e-005* 5.803e-002*cos(t)+ 1.000e+000* 2.050e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.575e-001, 1.037e-002 center
replot  3.575e-001+ 2.000*( 1.000e+000* 4.475e-002*cos(t)+-4.220e-004* 2.436e-003*sin(t)),  1.037e-002 +2.000*( 4.220e-004* 4.475e-002*cos(t)+ 1.000e+000* 2.436e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  3.245e-001, 1.613e-002 center
replot  3.245e-001+ 2.000*( 1.000e+000* 3.990e-002*cos(t)+-2.508e-003* 3.141e-003*sin(t)),  1.613e-002 +2.000*( 2.508e-003* 3.990e-002*cos(t)+ 1.000e+000* 3.141e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.913e-001, 2.495e-002 center
replot  2.913e-001+ 2.000*( 1.000e+000* 4.227e-002*cos(t)+-7.252e-003* 5.181e-003*sin(t)),  2.495e-002 +2.000*( 7.252e-003* 4.227e-002*cos(t)+ 1.000e+000* 5.181e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.565e-001, 3.830e-002 center
replot  2.565e-001+ 2.000*( 9.999e-001* 4.735e-002*cos(t)+-1.583e-002* 1.015e-002*sin(t)),  3.830e-002 +2.000*( 1.583e-002* 4.735e-002*cos(t)+ 9.999e-001* 1.015e-002*sin(t)) not
# Age 85, p21 - p13
set label "85" at  2.182e-001, 5.807e-002 center
replot  2.182e-001+ 2.000*( 9.993e-001* 5.118e-002*cos(t)+-3.675e-002* 1.998e-002*sin(t)),  5.807e-002 +2.000*( 3.675e-002* 5.118e-002*cos(t)+ 9.993e-001* 1.998e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.751e-001, 8.649e-002 center
replot  1.751e-001+ 2.000*( 9.901e-001* 5.182e-002*cos(t)+-1.404e-001* 3.714e-002*sin(t)),  8.649e-002 +2.000*( 1.404e-001* 5.182e-002*cos(t)+ 9.901e-001* 3.714e-002*sin(t)) not
set out;
set out "FRMadl/VARPIJGR_FRMadl_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "FRMadl/VARPIJGR_FRMadl_123-13.svg"
set label "50" at  2.269e-003, 2.715e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  2.269e-003+ 2.000*( 9.981e-001* 2.323e-003*cos(t)+ 6.215e-002* 1.334e-003*sin(t)),  2.715e-003 +2.000*(-6.215e-002* 2.323e-003*cos(t)+ 9.981e-001* 1.334e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  4.600e-003, 4.251e-003 center
replot  4.600e-003+ 2.000*( 9.993e-001* 4.023e-003*cos(t)+ 3.675e-002* 1.683e-003*sin(t)),  4.251e-003 +2.000*(-3.675e-002* 4.023e-003*cos(t)+ 9.993e-001* 1.683e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  9.299e-003, 6.646e-003 center
replot  9.299e-003+ 2.000*( 9.997e-001* 6.756e-003*cos(t)+ 2.522e-002* 2.043e-003*sin(t)),  6.646e-003 +2.000*(-2.522e-002* 6.756e-003*cos(t)+ 9.997e-001* 2.043e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.872e-002, 1.037e-002 center
replot  1.872e-002+ 2.000*( 9.998e-001* 1.088e-002*cos(t)+ 2.066e-002* 2.426e-003*sin(t)),  1.037e-002 +2.000*(-2.066e-002* 1.088e-002*cos(t)+ 9.998e-001* 2.426e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  3.745e-002, 1.613e-002 center
replot  3.745e-002+ 2.000*( 9.997e-001* 1.649e-002*cos(t)+ 2.337e-002* 3.120e-003*sin(t)),  1.613e-002 +2.000*(-2.337e-002* 1.649e-002*cos(t)+ 9.997e-001* 3.120e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  7.409e-002, 2.495e-002 center
replot  7.409e-002+ 2.000*( 9.992e-001* 2.314e-002*cos(t)+ 4.121e-002* 5.106e-003*sin(t)),  2.495e-002 +2.000*(-4.121e-002* 2.314e-002*cos(t)+ 9.992e-001* 5.106e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.438e-001, 3.830e-002 center
replot  1.438e-001+ 2.000*( 9.955e-001* 3.137e-002*cos(t)+ 9.465e-002* 9.780e-003*sin(t)),  3.830e-002 +2.000*(-9.465e-002* 3.137e-002*cos(t)+ 9.955e-001* 9.780e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  2.695e-001, 5.807e-002 center
replot  2.695e-001+ 2.000*( 9.909e-001* 5.302e-002*cos(t)+ 1.347e-001* 1.891e-002*sin(t)),  5.807e-002 +2.000*(-1.347e-001* 5.302e-002*cos(t)+ 9.909e-001* 1.891e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  4.765e-001, 8.649e-002 center
replot  4.765e-001+ 2.000*( 9.950e-001* 1.113e-001*cos(t)+ 1.002e-001* 3.597e-002*sin(t)),  8.649e-002 +2.000*(-1.002e-001* 1.113e-001*cos(t)+ 9.950e-001* 3.597e-002*sin(t)) not
set out;
set out "FRMadl/VARPIJGR_FRMadl_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "FRMadl/VARPIJGR_FRMadl_123-21.svg"
set label "50" at  2.269e-003, 4.636e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  2.269e-003+ 2.000*( 3.796e-004* 1.024e-001*cos(t)+ 1.000e+000* 2.320e-003*sin(t)),  4.636e-001 +2.000*(-1.000e+000* 1.024e-001*cos(t)+ 3.796e-004* 2.320e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  4.600e-003, 4.266e-001 center
replot  4.600e-003+ 2.000*( 9.456e-004* 7.787e-002*cos(t)+ 1.000e+000* 4.020e-003*sin(t)),  4.266e-001 +2.000*(-1.000e+000* 7.787e-002*cos(t)+ 9.456e-004* 4.020e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  9.299e-003, 3.913e-001 center
replot  9.299e-003+ 2.000*( 3.412e-003* 5.803e-002*cos(t)+ 1.000e+000* 6.752e-003*sin(t)),  3.913e-001 +2.000*(-1.000e+000* 5.803e-002*cos(t)+ 3.412e-003* 6.752e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.872e-002, 3.575e-001 center
replot  1.872e-002+ 2.000*( 1.388e-002* 4.476e-002*cos(t)+ 9.999e-001* 1.086e-002*sin(t)),  3.575e-001 +2.000*(-9.999e-001* 4.476e-002*cos(t)+ 1.388e-002* 1.086e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  3.745e-002, 3.245e-001 center
replot  3.745e-002+ 2.000*( 4.308e-002* 3.994e-002*cos(t)+ 9.991e-001* 1.641e-002*sin(t)),  3.245e-001 +2.000*(-9.991e-001* 3.994e-002*cos(t)+ 4.308e-002* 1.641e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  7.409e-002, 2.913e-001 center
replot  7.409e-002+ 2.000*( 8.318e-002* 4.237e-002*cos(t)+ 9.965e-001* 2.293e-002*sin(t)),  2.913e-001 +2.000*(-9.965e-001* 4.237e-002*cos(t)+ 8.318e-002* 2.293e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.438e-001, 2.565e-001 center
replot  1.438e-001+ 2.000*( 1.274e-001* 4.757e-002*cos(t)+ 9.919e-001* 3.091e-002*sin(t)),  2.565e-001 +2.000*(-9.919e-001* 4.757e-002*cos(t)+ 1.274e-001* 3.091e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  2.695e-001, 2.182e-001 center
replot  2.695e-001+ 2.000*( 7.793e-001* 5.515e-002*cos(t)+ 6.266e-001* 4.839e-002*sin(t)),  2.182e-001 +2.000*(-6.266e-001* 5.515e-002*cos(t)+ 7.793e-001* 4.839e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  4.765e-001, 1.751e-001 center
replot  4.765e-001+ 2.000*( 9.916e-001* 1.115e-001*cos(t)+ 1.291e-001* 4.994e-002*sin(t)),  1.751e-001 +2.000*(-1.291e-001* 1.115e-001*cos(t)+ 9.916e-001* 4.994e-002*sin(t)) not
set out;
set out "FRMadl/VARPIJGR_FRMadl_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "FRMadl/VARMUPTJGR--STABLBASED_FRMadl1.svg";
 plot "FRMadl/PRMORPREV-1-STABLBASED_FRMadl.txt"  u 1:($3) not w l lt 1 
 replot "FRMadl/PRMORPREV-1-STABLBASED_FRMadl.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "FRMadl/PRMORPREV-1-STABLBASED_FRMadl.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "FRMadl/VARMUPTJGR--STABLBASED_FRMadl1.svg";replot;set out;
