
# IMaCh-0.99r45
# DKFchr.gp
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


set ter svg size 640, 480;set out "DKFchr/D_DKFchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "DKFchr/ILK_DKFchr-dest.png";
set log y;plot  "DKFchr/ILK_DKFchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "DKFchr/ILK_DKFchr-ori.png";
set log y;plot  "DKFchr/ILK_DKFchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "DKFchr/ILK_DKFchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "DKFchr/ILK_DKFchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "DKFchr/ILK_DKFchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "DKFchr/ILK_DKFchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "DKFchr/V_DKFchr_1-1-1.svg" 

#set out "V_DKFchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "DKFchr/VPL_DKFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"DKFchr/VPL_DKFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"DKFchr/VPL_DKFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"DKFchr/P_DKFchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "DKFchr/V_DKFchr_2-1-1.svg" 

#set out "V_DKFchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "DKFchr/VPL_DKFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"DKFchr/VPL_DKFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"DKFchr/VPL_DKFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"DKFchr/P_DKFchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "DKFchr/E_DKFchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "DKFchr/T_DKFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"DKFchr/T_DKFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"DKFchr/T_DKFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"DKFchr/T_DKFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"DKFchr/T_DKFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"DKFchr/T_DKFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"DKFchr/T_DKFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"DKFchr/T_DKFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"DKFchr/T_DKFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "DKFchr/E_DKFchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "DKFchr/EXP_DKFchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "DKFchr/E_DKFchr.txt" every :::0::0 u 1:2 t "e11" w l ,"DKFchr/E_DKFchr.txt" every :::0::0 u 1:3 t "e12" w l ,"DKFchr/E_DKFchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "DKFchr/EXP_DKFchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "DKFchr/E_DKFchr.txt" every :::0::0 u 1:5 t "e21" w l ,"DKFchr/E_DKFchr.txt" every :::0::0 u 1:6 t "e22" w l ,"DKFchr/E_DKFchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "DKFchr/LIJ_DKFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKFchr/PIJ_DKFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "DKFchr/LIJ_DKFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKFchr/PIJ_DKFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "DKFchr/LIJT_DKFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKFchr/PIJ_DKFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "DKFchr/LIJT_DKFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKFchr/PIJ_DKFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "DKFchr/P_DKFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKFchr/PIJ_DKFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "DKFchr/P_DKFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKFchr/PIJ_DKFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-3.171991; p2=0.040127; 
#   current state 3
p3=-15.669389; p4=0.176678; 
# initial state 2
#   current state 1
p5=0.667846; p6=-0.042409; 
#   current state 3
p7=-10.218293; p8=0.103979; 
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

set out "DKFchr/PE_DKFchr_1-1-1.svg" 
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

set out "DKFchr/PE_DKFchr_1-2-1.svg" 
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

set out "DKFchr/PE_DKFchr_1-3-1.svg" 
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
set out "DKFchr/VARPIJGR_DKFchr_113-12.svg"
set label "50" at  4.094e-004, 1.187e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  4.094e-004+ 2.000*( 1.433e-004* 1.866e-002*cos(t)+-1.000e+000* 4.946e-004*sin(t)),  1.187e-001 +2.000*( 1.000e+000* 1.866e-002*cos(t)+ 1.433e-004* 4.946e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  9.397e-004, 1.377e-001 center
replot  9.397e-004+ 2.000*( 5.177e-004* 1.542e-002*cos(t)+ 1.000e+000* 9.383e-004*sin(t)),  1.377e-001 +2.000*(-1.000e+000* 1.542e-002*cos(t)+ 5.177e-004* 9.383e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  2.137e-003, 1.582e-001 center
replot  2.137e-003+ 2.000*( 4.372e-003* 1.283e-002*cos(t)+ 1.000e+000* 1.702e-003*sin(t)),  1.582e-001 +2.000*(-1.000e+000* 1.283e-002*cos(t)+ 4.372e-003* 1.702e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  4.803e-003, 1.796e-001 center
replot  4.803e-003+ 2.000*( 1.623e-002* 1.312e-002*cos(t)+ 9.999e-001* 2.932e-003*sin(t)),  1.796e-001 +2.000*(-9.999e-001* 1.312e-002*cos(t)+ 1.623e-002* 2.932e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.063e-002, 2.007e-001 center
replot  1.063e-002+ 2.000*( 3.667e-002* 1.722e-002*cos(t)+ 9.993e-001* 4.881e-003*sin(t)),  2.007e-001 +2.000*(-9.993e-001* 1.722e-002*cos(t)+ 3.667e-002* 4.881e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.296e-002, 2.192e-001 center
replot  2.296e-002+ 2.000*( 9.469e-002* 2.351e-002*cos(t)+ 9.955e-001* 8.711e-003*sin(t)),  2.192e-001 +2.000*(-9.955e-001* 2.351e-002*cos(t)+ 9.469e-002* 8.711e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  4.778e-002, 2.304e-001 center
replot  4.778e-002+ 2.000*( 3.579e-001* 3.235e-002*cos(t)+ 9.338e-001* 1.734e-002*sin(t)),  2.304e-001 +2.000*(-9.338e-001* 3.235e-002*cos(t)+ 3.579e-001* 1.734e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  9.337e-002, 2.275e-001 center
replot  9.337e-002+ 2.000*( 7.430e-001* 5.716e-002*cos(t)+ 6.693e-001* 2.469e-002*sin(t)),  2.275e-001 +2.000*(-6.693e-001* 5.716e-002*cos(t)+ 7.430e-001* 2.469e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.653e-001, 2.035e-001 center
replot  1.653e-001+ 2.000*( 8.155e-001* 1.047e-001*cos(t)+ 5.787e-001* 2.442e-002*sin(t)),  2.035e-001 +2.000*(-5.787e-001* 1.047e-001*cos(t)+ 8.155e-001* 2.442e-002*sin(t)) not
set out;
set out "DKFchr/VARPIJGR_DKFchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "DKFchr/VARPIJGR_DKFchr_121-12.svg"
set label "50" at  9.429e-002, 1.187e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  9.429e-002+ 2.000*( 1.857e-002* 1.866e-002*cos(t)+-9.998e-001* 1.353e-002*sin(t)),  1.187e-001 +2.000*( 9.998e-001* 1.866e-002*cos(t)+ 1.857e-002* 1.353e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  7.883e-002, 1.377e-001 center
replot  7.883e-002+ 2.000*( 1.156e-002* 1.542e-002*cos(t)+-9.999e-001* 9.001e-003*sin(t)),  1.377e-001 +2.000*( 9.999e-001* 1.542e-002*cos(t)+ 1.156e-002* 9.001e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  6.532e-002, 1.582e-001 center
replot  6.532e-002+ 2.000*( 8.916e-003* 1.283e-002*cos(t)+-1.000e+000* 5.979e-003*sin(t)),  1.582e-001 +2.000*( 1.000e+000* 1.283e-002*cos(t)+ 8.916e-003* 5.979e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  5.360e-002, 1.796e-001 center
replot  5.360e-002+ 2.000*( 6.422e-003* 1.312e-002*cos(t)+-1.000e+000* 4.636e-003*sin(t)),  1.796e-001 +2.000*( 1.000e+000* 1.312e-002*cos(t)+ 6.422e-003* 4.636e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  4.344e-002, 2.007e-001 center
replot  4.344e-002+ 2.000*( 3.556e-003* 1.721e-002*cos(t)+-1.000e+000* 4.568e-003*sin(t)),  2.007e-001 +2.000*( 1.000e+000* 1.721e-002*cos(t)+ 3.556e-003* 4.568e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  3.463e-002, 2.192e-001 center
replot  3.463e-002+ 2.000*( 1.150e-003* 2.342e-002*cos(t)+-1.000e+000* 4.855e-003*sin(t)),  2.192e-001 +2.000*( 1.000e+000* 2.342e-002*cos(t)+ 1.150e-003* 4.855e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.697e-002, 2.304e-001 center
replot  2.697e-002+ 2.000*( 1.242e-003* 3.084e-002*cos(t)+ 1.000e+000* 4.955e-003*sin(t)),  2.304e-001 +2.000*(-1.000e+000* 3.084e-002*cos(t)+ 1.242e-003* 4.955e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  2.032e-002, 2.275e-001 center
replot  2.032e-002+ 2.000*( 3.062e-003* 4.243e-002*cos(t)+ 1.000e+000* 4.721e-003*sin(t)),  2.275e-001 +2.000*(-1.000e+000* 4.243e-002*cos(t)+ 3.062e-003* 4.721e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.463e-002, 2.035e-001 center
replot  1.463e-002+ 2.000*( 2.938e-003* 6.380e-002*cos(t)+ 1.000e+000* 4.187e-003*sin(t)),  2.035e-001 +2.000*(-1.000e+000* 6.380e-002*cos(t)+ 2.938e-003* 4.187e-003*sin(t)) not
set out;
set out "DKFchr/VARPIJGR_DKFchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "DKFchr/VARPIJGR_DKFchr_123-12.svg"
set label "50" at  2.664e-003, 1.187e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  2.664e-003+ 2.000*( 5.233e-004* 1.866e-002*cos(t)+-1.000e+000* 1.046e-003*sin(t)),  1.187e-001 +2.000*( 1.000e+000* 1.866e-002*cos(t)+ 5.233e-004* 1.046e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  4.630e-003, 1.377e-001 center
replot  4.630e-003+ 2.000*( 5.277e-004* 1.542e-002*cos(t)+-1.000e+000* 1.508e-003*sin(t)),  1.377e-001 +2.000*( 1.000e+000* 1.542e-002*cos(t)+ 5.277e-004* 1.508e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  7.977e-003, 1.582e-001 center
replot  7.977e-003+ 2.000*( 2.809e-005* 1.283e-002*cos(t)+-1.000e+000* 2.082e-003*sin(t)),  1.582e-001 +2.000*( 1.000e+000* 1.283e-002*cos(t)+ 2.809e-005* 2.082e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.361e-002, 1.796e-001 center
replot  1.361e-002+ 2.000*( 3.111e-004* 1.312e-002*cos(t)+ 1.000e+000* 2.729e-003*sin(t)),  1.796e-001 +2.000*(-1.000e+000* 1.312e-002*cos(t)+ 3.111e-004* 2.729e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  2.293e-002, 2.007e-001 center
replot  2.293e-002+ 2.000*( 1.638e-003* 1.721e-002*cos(t)+-1.000e+000* 3.426e-003*sin(t)),  2.007e-001 +2.000*( 1.000e+000* 1.721e-002*cos(t)+ 1.638e-003* 3.426e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  3.801e-002, 2.192e-001 center
replot  3.801e-002+ 2.000*( 6.017e-003* 2.342e-002*cos(t)+-1.000e+000* 4.493e-003*sin(t)),  2.192e-001 +2.000*( 1.000e+000* 2.342e-002*cos(t)+ 6.017e-003* 4.493e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  6.155e-002, 2.304e-001 center
replot  6.155e-002+ 2.000*( 1.480e-002* 3.084e-002*cos(t)+-9.999e-001* 7.248e-003*sin(t)),  2.304e-001 +2.000*( 9.999e-001* 3.084e-002*cos(t)+ 1.480e-002* 7.248e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  9.641e-002, 2.275e-001 center
replot  9.641e-002+ 2.000*( 2.827e-002* 4.244e-002*cos(t)+-9.996e-001* 1.336e-002*sin(t)),  2.275e-001 +2.000*( 9.996e-001* 4.244e-002*cos(t)+ 2.827e-002* 1.336e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.443e-001, 2.035e-001 center
replot  1.443e-001+ 2.000*( 3.545e-002* 6.383e-002*cos(t)+-9.994e-001* 2.311e-002*sin(t)),  2.035e-001 +2.000*( 9.994e-001* 6.383e-002*cos(t)+ 3.545e-002* 2.311e-002*sin(t)) not
set out;
set out "DKFchr/VARPIJGR_DKFchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "DKFchr/VARPIJGR_DKFchr_121-13.svg"
set label "50" at  9.429e-002, 4.094e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  9.429e-002+ 2.000*( 1.000e+000* 1.353e-002*cos(t)+-3.422e-004* 4.946e-004*sin(t)),  4.094e-004 +2.000*( 3.422e-004* 1.353e-002*cos(t)+ 1.000e+000* 4.946e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  7.883e-002, 9.397e-004 center
replot  7.883e-002+ 2.000*( 1.000e+000* 9.002e-003*cos(t)+-7.685e-004* 9.383e-004*sin(t)),  9.397e-004 +2.000*( 7.685e-004* 9.002e-003*cos(t)+ 1.000e+000* 9.383e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  6.532e-002, 2.137e-003 center
replot  6.532e-002+ 2.000*( 1.000e+000* 5.980e-003*cos(t)+-1.936e-003* 1.703e-003*sin(t)),  2.137e-003 +2.000*( 1.936e-003* 5.980e-003*cos(t)+ 1.000e+000* 1.703e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  5.360e-002, 4.803e-003 center
replot  5.360e-002+ 2.000*( 9.999e-001* 4.637e-003*cos(t)+-1.074e-002* 2.939e-003*sin(t)),  4.803e-003 +2.000*( 1.074e-002* 4.637e-003*cos(t)+ 9.999e-001* 2.939e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  4.344e-002, 1.063e-002 center
replot  4.344e-002+ 2.000*( 1.495e-001* 4.927e-003*cos(t)+-9.888e-001* 4.560e-003*sin(t)),  1.063e-002 +2.000*( 9.888e-001* 4.927e-003*cos(t)+ 1.495e-001* 4.560e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  3.463e-002, 2.296e-002 center
replot  3.463e-002+ 2.000*( 3.136e-002* 8.956e-003*cos(t)+-9.995e-001* 4.850e-003*sin(t)),  2.296e-002 +2.000*( 9.995e-001* 8.956e-003*cos(t)+ 3.136e-002* 4.850e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.697e-002, 4.778e-002 center
replot  2.697e-002+ 2.000*( 1.364e-002* 1.991e-002*cos(t)+-9.999e-001* 4.948e-003*sin(t)),  4.778e-002 +2.000*( 9.999e-001* 1.991e-002*cos(t)+ 1.364e-002* 4.948e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  2.032e-002, 9.337e-002 center
replot  2.032e-002+ 2.000*( 5.668e-003* 4.557e-002*cos(t)+-1.000e+000* 4.716e-003*sin(t)),  9.337e-002 +2.000*( 1.000e+000* 4.557e-002*cos(t)+ 5.668e-003* 4.716e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.463e-002, 1.653e-001 center
replot  1.463e-002+ 2.000*( 2.718e-003* 8.657e-002*cos(t)+-1.000e+000* 4.185e-003*sin(t)),  1.653e-001 +2.000*( 1.000e+000* 8.657e-002*cos(t)+ 2.718e-003* 4.185e-003*sin(t)) not
set out;
set out "DKFchr/VARPIJGR_DKFchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "DKFchr/VARPIJGR_DKFchr_123-13.svg"
set label "50" at  2.664e-003, 4.094e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  2.664e-003+ 2.000*( 9.999e-001* 1.047e-003*cos(t)+ 1.508e-002* 4.944e-004*sin(t)),  4.094e-004 +2.000*(-1.508e-002* 1.047e-003*cos(t)+ 9.999e-001* 4.944e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  4.630e-003, 9.397e-004 center
replot  4.630e-003+ 2.000*( 9.998e-001* 1.509e-003*cos(t)+ 2.193e-002* 9.380e-004*sin(t)),  9.397e-004 +2.000*(-2.193e-002* 1.509e-003*cos(t)+ 9.998e-001* 9.380e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  7.977e-003, 2.137e-003 center
replot  7.977e-003+ 2.000*( 9.990e-001* 2.083e-003*cos(t)+ 4.457e-002* 1.702e-003*sin(t)),  2.137e-003 +2.000*(-4.457e-002* 2.083e-003*cos(t)+ 9.990e-001* 1.702e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.361e-002, 4.803e-003 center
replot  1.361e-002+ 2.000*( 1.031e-001* 2.941e-003*cos(t)+ 9.947e-001* 2.726e-003*sin(t)),  4.803e-003 +2.000*(-9.947e-001* 2.941e-003*cos(t)+ 1.031e-001* 2.726e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  2.293e-002, 1.063e-002 center
replot  2.293e-002+ 2.000*( 2.814e-002* 4.920e-003*cos(t)+ 9.996e-001* 3.424e-003*sin(t)),  1.063e-002 +2.000*(-9.996e-001* 4.920e-003*cos(t)+ 2.814e-002* 3.424e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  3.801e-002, 2.296e-002 center
replot  3.801e-002+ 2.000*( 3.244e-002* 8.957e-003*cos(t)+ 9.995e-001* 4.488e-003*sin(t)),  2.296e-002 +2.000*(-9.995e-001* 8.957e-003*cos(t)+ 3.244e-002* 4.488e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  6.155e-002, 4.778e-002 center
replot  6.155e-002+ 2.000*( 3.365e-002* 1.992e-002*cos(t)+ 9.994e-001* 7.235e-003*sin(t)),  4.778e-002 +2.000*(-9.994e-001* 1.992e-002*cos(t)+ 3.365e-002* 7.235e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  9.641e-002, 9.337e-002 center
replot  9.641e-002+ 2.000*( 2.761e-002* 4.559e-002*cos(t)+ 9.996e-001* 1.335e-002*sin(t)),  9.337e-002 +2.000*(-9.996e-001* 4.559e-002*cos(t)+ 2.761e-002* 1.335e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.443e-001, 1.653e-001 center
replot  1.443e-001+ 2.000*( 2.330e-002* 8.660e-002*cos(t)+ 9.997e-001* 2.313e-002*sin(t)),  1.653e-001 +2.000*(-9.997e-001* 8.660e-002*cos(t)+ 2.330e-002* 2.313e-002*sin(t)) not
set out;
set out "DKFchr/VARPIJGR_DKFchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "DKFchr/VARPIJGR_DKFchr_123-21.svg"
set label "50" at  2.664e-003, 9.429e-002 center
# Age 50, p23 - p21
plot [-pi:pi]  2.664e-003+ 2.000*( 4.697e-003* 1.353e-002*cos(t)+ 1.000e+000* 1.045e-003*sin(t)),  9.429e-002 +2.000*(-1.000e+000* 1.353e-002*cos(t)+ 4.697e-003* 1.045e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  4.630e-003, 7.883e-002 center
replot  4.630e-003+ 2.000*( 8.618e-003* 9.003e-003*cos(t)+ 1.000e+000* 1.506e-003*sin(t)),  7.883e-002 +2.000*(-1.000e+000* 9.003e-003*cos(t)+ 8.618e-003* 1.506e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  7.977e-003, 6.532e-002 center
replot  7.977e-003+ 2.000*( 2.052e-002* 5.981e-003*cos(t)+ 9.998e-001* 2.079e-003*sin(t)),  6.532e-002 +2.000*(-9.998e-001* 5.981e-003*cos(t)+ 2.052e-002* 2.079e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.361e-002, 5.360e-002 center
replot  1.361e-002+ 2.000*( 5.841e-002* 4.642e-003*cos(t)+ 9.983e-001* 2.720e-003*sin(t)),  5.360e-002 +2.000*(-9.983e-001* 4.642e-003*cos(t)+ 5.841e-002* 2.720e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  2.293e-002, 4.344e-002 center
replot  2.293e-002+ 2.000*( 1.313e-001* 4.586e-003*cos(t)+ 9.913e-001* 3.402e-003*sin(t)),  4.344e-002 +2.000*(-9.913e-001* 4.586e-003*cos(t)+ 1.313e-001* 3.402e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  3.801e-002, 3.463e-002 center
replot  3.801e-002+ 2.000*( 4.194e-001* 4.949e-003*cos(t)+ 9.078e-001* 4.393e-003*sin(t)),  3.463e-002 +2.000*(-9.078e-001* 4.949e-003*cos(t)+ 4.194e-001* 4.393e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  6.155e-002, 2.697e-002 center
replot  6.155e-002+ 2.000*( 9.909e-001* 7.298e-003*cos(t)+ 1.344e-001* 4.901e-003*sin(t)),  2.697e-002 +2.000*(-1.344e-001* 7.298e-003*cos(t)+ 9.909e-001* 4.901e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  9.641e-002, 2.032e-002 center
replot  9.641e-002+ 2.000*( 9.982e-001* 1.343e-002*cos(t)+ 5.964e-002* 4.663e-003*sin(t)),  2.032e-002 +2.000*(-5.964e-002* 1.343e-002*cos(t)+ 9.982e-001* 4.663e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.443e-001, 1.463e-002 center
replot  1.443e-001+ 2.000*( 9.991e-001* 2.323e-002*cos(t)+ 4.153e-002* 4.082e-003*sin(t)),  1.463e-002 +2.000*(-4.153e-002* 2.323e-002*cos(t)+ 9.991e-001* 4.082e-003*sin(t)) not
set out;
set out "DKFchr/VARPIJGR_DKFchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "DKFchr/VARMUPTJGR--STABLBASED_DKFchr1.svg";
 plot "DKFchr/PRMORPREV-1-STABLBASED_DKFchr.txt"  u 1:($3) not w l lt 1 
 replot "DKFchr/PRMORPREV-1-STABLBASED_DKFchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "DKFchr/PRMORPREV-1-STABLBASED_DKFchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "DKFchr/VARMUPTJGR--STABLBASED_DKFchr1.svg";replot;set out;
