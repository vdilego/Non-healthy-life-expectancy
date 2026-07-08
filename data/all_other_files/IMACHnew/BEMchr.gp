
# IMaCh-0.99r45
# BEMchr.gp
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


set ter svg size 640, 480;set out "BEMchr/D_BEMchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "BEMchr/ILK_BEMchr-dest.png";
set log y;plot  "BEMchr/ILK_BEMchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "BEMchr/ILK_BEMchr-ori.png";
set log y;plot  "BEMchr/ILK_BEMchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "BEMchr/ILK_BEMchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "BEMchr/ILK_BEMchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "BEMchr/ILK_BEMchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "BEMchr/ILK_BEMchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "BEMchr/V_BEMchr_1-1-1.svg" 

#set out "V_BEMchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "BEMchr/VPL_BEMchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"BEMchr/VPL_BEMchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"BEMchr/VPL_BEMchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"BEMchr/P_BEMchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "BEMchr/V_BEMchr_2-1-1.svg" 

#set out "V_BEMchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "BEMchr/VPL_BEMchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"BEMchr/VPL_BEMchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"BEMchr/VPL_BEMchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"BEMchr/P_BEMchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "BEMchr/E_BEMchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "BEMchr/T_BEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"BEMchr/T_BEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"BEMchr/T_BEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"BEMchr/T_BEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"BEMchr/T_BEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"BEMchr/T_BEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"BEMchr/T_BEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"BEMchr/T_BEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"BEMchr/T_BEMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "BEMchr/E_BEMchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "BEMchr/EXP_BEMchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "BEMchr/E_BEMchr.txt" every :::0::0 u 1:2 t "e11" w l ,"BEMchr/E_BEMchr.txt" every :::0::0 u 1:3 t "e12" w l ,"BEMchr/E_BEMchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "BEMchr/EXP_BEMchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "BEMchr/E_BEMchr.txt" every :::0::0 u 1:5 t "e21" w l ,"BEMchr/E_BEMchr.txt" every :::0::0 u 1:6 t "e22" w l ,"BEMchr/E_BEMchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "BEMchr/LIJ_BEMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEMchr/PIJ_BEMchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "BEMchr/LIJ_BEMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEMchr/PIJ_BEMchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "BEMchr/LIJT_BEMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEMchr/PIJ_BEMchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "BEMchr/LIJT_BEMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEMchr/PIJ_BEMchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "BEMchr/P_BEMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEMchr/PIJ_BEMchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "BEMchr/P_BEMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEMchr/PIJ_BEMchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-2.723763; p2=0.039912; 
#   current state 3
p3=-14.347437; p4=0.153297; 
# initial state 2
#   current state 1
p5=-2.296095; p6=-0.001705; 
#   current state 3
p7=-9.587902; p8=0.098006; 
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

set out "BEMchr/PE_BEMchr_1-1-1.svg" 
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

set out "BEMchr/PE_BEMchr_1-2-1.svg" 
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

set out "BEMchr/PE_BEMchr_1-3-1.svg" 
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
set out "BEMchr/VARPIJGR_BEMchr_113-12.svg"
set label "50" at  4.220e-004, 1.627e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  4.220e-004+ 2.000*( 3.498e-004* 1.882e-002*cos(t)+-1.000e+000* 5.820e-004*sin(t)),  1.627e-001 +2.000*( 1.000e+000* 1.882e-002*cos(t)+ 3.498e-004* 5.820e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  8.466e-004, 1.851e-001 center
replot  8.466e-004+ 2.000*( 1.189e-003* 1.514e-002*cos(t)+ 1.000e+000* 9.732e-004*sin(t)),  1.851e-001 +2.000*(-1.000e+000* 1.514e-002*cos(t)+ 1.189e-003* 9.732e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.681e-003, 2.085e-001 center
replot  1.681e-003+ 2.000*( 7.918e-003* 1.248e-002*cos(t)+ 1.000e+000* 1.560e-003*sin(t)),  2.085e-001 +2.000*(-1.000e+000* 1.248e-002*cos(t)+ 7.918e-003* 1.560e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  3.301e-003, 2.323e-001 center
replot  3.301e-003+ 2.000*( 2.015e-002* 1.267e-002*cos(t)+ 9.998e-001* 2.390e-003*sin(t)),  2.323e-001 +2.000*(-9.998e-001* 1.267e-002*cos(t)+ 2.015e-002* 2.390e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  6.400e-003, 2.554e-001 center
replot  6.400e-003+ 2.000*( 2.913e-002* 1.591e-002*cos(t)+ 9.996e-001* 3.577e-003*sin(t)),  2.554e-001 +2.000*(-9.996e-001* 1.591e-002*cos(t)+ 2.913e-002* 3.577e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.222e-002, 2.766e-001 center
replot  1.222e-002+ 2.000*( 4.831e-002* 2.054e-002*cos(t)+ 9.988e-001* 5.717e-003*sin(t)),  2.766e-001 +2.000*(-9.988e-001* 2.054e-002*cos(t)+ 4.831e-002* 5.717e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  2.285e-002, 2.935e-001 center
replot  2.285e-002+ 2.000*( 1.476e-001* 2.571e-002*cos(t)+ 9.890e-001* 1.078e-002*sin(t)),  2.935e-001 +2.000*(-9.890e-001* 2.571e-002*cos(t)+ 1.476e-001* 1.078e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  4.160e-002, 3.031e-001 center
replot  4.160e-002+ 2.000*( 5.250e-001* 3.600e-002*cos(t)+ 8.511e-001* 1.897e-002*sin(t)),  3.031e-001 +2.000*(-8.511e-001* 3.600e-002*cos(t)+ 5.250e-001* 1.897e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  7.281e-002, 3.009e-001 center
replot  7.281e-002+ 2.000*( 7.510e-001* 6.660e-002*cos(t)+ 6.603e-001* 2.227e-002*sin(t)),  3.009e-001 +2.000*(-6.603e-001* 6.660e-002*cos(t)+ 7.510e-001* 2.227e-002*sin(t)) not
set out;
set out "BEMchr/VARPIJGR_BEMchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "BEMchr/VARPIJGR_BEMchr_121-12.svg"
set label "50" at  4.195e-002, 1.627e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  4.195e-002+ 2.000*( 5.032e-003* 1.882e-002*cos(t)+-1.000e+000* 6.974e-003*sin(t)),  1.627e-001 +2.000*( 1.000e+000* 1.882e-002*cos(t)+ 5.032e-003* 6.974e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  4.140e-002, 1.851e-001 center
replot  4.140e-002+ 2.000*( 4.499e-003* 1.514e-002*cos(t)+-1.000e+000* 5.391e-003*sin(t)),  1.851e-001 +2.000*( 1.000e+000* 1.514e-002*cos(t)+ 4.499e-003* 5.391e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  4.073e-002, 2.085e-001 center
replot  4.073e-002+ 2.000*( 4.392e-003* 1.248e-002*cos(t)+-1.000e+000* 4.135e-003*sin(t)),  2.085e-001 +2.000*( 1.000e+000* 1.248e-002*cos(t)+ 4.392e-003* 4.135e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.986e-002, 2.323e-001 center
replot  3.986e-002+ 2.000*( 4.705e-003* 1.267e-002*cos(t)+-1.000e+000* 3.503e-003*sin(t)),  2.323e-001 +2.000*( 1.000e+000* 1.267e-002*cos(t)+ 4.705e-003* 3.503e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  3.868e-002, 2.554e-001 center
replot  3.868e-002+ 2.000*( 4.617e-003* 1.591e-002*cos(t)+-1.000e+000* 3.715e-003*sin(t)),  2.554e-001 +2.000*( 1.000e+000* 1.591e-002*cos(t)+ 4.617e-003* 3.715e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  3.705e-002, 2.766e-001 center
replot  3.705e-002+ 2.000*( 3.952e-003* 2.052e-002*cos(t)+-1.000e+000* 4.515e-003*sin(t)),  2.766e-001 +2.000*( 1.000e+000* 2.052e-002*cos(t)+ 3.952e-003* 4.515e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  3.479e-002, 2.935e-001 center
replot  3.479e-002+ 2.000*( 2.485e-003* 2.548e-002*cos(t)+-1.000e+000* 5.472e-003*sin(t)),  2.935e-001 +2.000*( 1.000e+000* 2.548e-002*cos(t)+ 2.485e-003* 5.472e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  3.174e-002, 3.031e-001 center
replot  3.174e-002+ 2.000*( 1.812e-004* 3.222e-002*cos(t)+ 1.000e+000* 6.296e-003*sin(t)),  3.031e-001 +2.000*(-1.000e+000* 3.222e-002*cos(t)+ 1.812e-004* 6.296e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  2.784e-002, 3.009e-001 center
replot  2.784e-002+ 2.000*( 2.419e-003* 4.705e-002*cos(t)+ 1.000e+000* 6.812e-003*sin(t)),  3.009e-001 +2.000*(-1.000e+000* 4.705e-002*cos(t)+ 2.419e-003* 6.812e-003*sin(t)) not
set out;
set out "BEMchr/VARPIJGR_BEMchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "BEMchr/VARPIJGR_BEMchr_123-12.svg"
set label "50" at  4.180e-003, 1.627e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  4.180e-003+ 2.000*( 1.235e-004* 1.882e-002*cos(t)+-1.000e+000* 1.250e-003*sin(t)),  1.627e-001 +2.000*( 1.000e+000* 1.882e-002*cos(t)+ 1.235e-004* 1.250e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  6.791e-003, 1.851e-001 center
replot  6.791e-003+ 2.000*( 3.244e-004* 1.514e-002*cos(t)+-1.000e+000* 1.673e-003*sin(t)),  1.851e-001 +2.000*( 1.000e+000* 1.514e-002*cos(t)+ 3.244e-004* 1.673e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  1.100e-002, 2.085e-001 center
replot  1.100e-002+ 2.000*( 8.654e-004* 1.248e-002*cos(t)+-1.000e+000* 2.156e-003*sin(t)),  2.085e-001 +2.000*( 1.000e+000* 1.248e-002*cos(t)+ 8.654e-004* 2.156e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.772e-002, 2.323e-001 center
replot  1.772e-002+ 2.000*( 1.568e-003* 1.267e-002*cos(t)+-1.000e+000* 2.666e-003*sin(t)),  2.323e-001 +2.000*( 1.000e+000* 1.267e-002*cos(t)+ 1.568e-003* 2.666e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  2.831e-002, 2.554e-001 center
replot  2.831e-002+ 2.000*( 1.863e-003* 1.591e-002*cos(t)+-1.000e+000* 3.255e-003*sin(t)),  2.554e-001 +2.000*( 1.000e+000* 1.591e-002*cos(t)+ 1.863e-003* 3.255e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  4.464e-002, 2.766e-001 center
replot  4.464e-002+ 2.000*( 2.298e-003* 2.052e-002*cos(t)+-1.000e+000* 4.403e-003*sin(t)),  2.766e-001 +2.000*( 1.000e+000* 2.052e-002*cos(t)+ 2.298e-003* 4.403e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  6.902e-002, 2.935e-001 center
replot  6.902e-002+ 2.000*( 3.990e-003* 2.548e-002*cos(t)+-1.000e+000* 7.276e-003*sin(t)),  2.935e-001 +2.000*( 1.000e+000* 2.548e-002*cos(t)+ 3.990e-003* 7.276e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.037e-001, 3.031e-001 center
replot  1.037e-001+ 2.000*( 8.893e-003* 3.222e-002*cos(t)+-1.000e+000* 1.287e-002*sin(t)),  3.031e-001 +2.000*( 1.000e+000* 3.222e-002*cos(t)+ 8.893e-003* 1.287e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.497e-001, 3.009e-001 center
replot  1.497e-001+ 2.000*( 1.433e-002* 4.706e-002*cos(t)+-9.999e-001* 2.109e-002*sin(t)),  3.009e-001 +2.000*( 9.999e-001* 4.706e-002*cos(t)+ 1.433e-002* 2.109e-002*sin(t)) not
set out;
set out "BEMchr/VARPIJGR_BEMchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "BEMchr/VARPIJGR_BEMchr_121-13.svg"
set label "50" at  4.195e-002, 4.220e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  4.195e-002+ 2.000*( 1.000e+000* 6.975e-003*cos(t)+-1.009e-003* 5.820e-004*sin(t)),  4.220e-004 +2.000*( 1.009e-003* 6.975e-003*cos(t)+ 1.000e+000* 5.820e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  4.140e-002, 8.466e-004 center
replot  4.140e-002+ 2.000*( 1.000e+000* 5.391e-003*cos(t)+-1.975e-003* 9.733e-004*sin(t)),  8.466e-004 +2.000*( 1.975e-003* 5.391e-003*cos(t)+ 1.000e+000* 9.733e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  4.073e-002, 1.681e-003 center
replot  4.073e-002+ 2.000*( 1.000e+000* 4.136e-003*cos(t)+-4.118e-003* 1.563e-003*sin(t)),  1.681e-003 +2.000*( 4.118e-003* 4.136e-003*cos(t)+ 1.000e+000* 1.563e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.986e-002, 3.301e-003 center
replot  3.986e-002+ 2.000*( 9.999e-001* 3.504e-003*cos(t)+-1.276e-002* 2.403e-003*sin(t)),  3.301e-003 +2.000*( 1.276e-002* 3.504e-003*cos(t)+ 9.999e-001* 2.403e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  3.868e-002, 6.400e-003 center
replot  3.868e-002+ 2.000*( 9.729e-001* 3.722e-003*cos(t)+-2.314e-001* 3.599e-003*sin(t)),  6.400e-003 +2.000*( 2.314e-001* 3.722e-003*cos(t)+ 9.729e-001* 3.599e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  3.705e-002, 1.222e-002 center
replot  3.705e-002+ 2.000*( 4.974e-002* 5.798e-003*cos(t)+-9.988e-001* 4.512e-003*sin(t)),  1.222e-002 +2.000*( 9.988e-001* 5.798e-003*cos(t)+ 4.974e-002* 4.512e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  3.479e-002, 2.285e-002 center
replot  3.479e-002+ 2.000*( 2.068e-002* 1.132e-002*cos(t)+-9.998e-001* 5.469e-003*sin(t)),  2.285e-002 +2.000*( 9.998e-001* 1.132e-002*cos(t)+ 2.068e-002* 5.469e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  3.174e-002, 4.160e-002 center
replot  3.174e-002+ 2.000*( 9.493e-003* 2.486e-002*cos(t)+-1.000e+000* 6.292e-003*sin(t)),  4.160e-002 +2.000*( 1.000e+000* 2.486e-002*cos(t)+ 9.493e-003* 6.292e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  2.784e-002, 7.281e-002 center
replot  2.784e-002+ 2.000*( 4.738e-003* 5.213e-002*cos(t)+-1.000e+000* 6.808e-003*sin(t)),  7.281e-002 +2.000*( 1.000e+000* 5.213e-002*cos(t)+ 4.738e-003* 6.808e-003*sin(t)) not
set out;
set out "BEMchr/VARPIJGR_BEMchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "BEMchr/VARPIJGR_BEMchr_123-13.svg"
set label "50" at  4.180e-003, 4.220e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  4.180e-003+ 2.000*( 9.998e-001* 1.250e-003*cos(t)+ 1.993e-002* 5.816e-004*sin(t)),  4.220e-004 +2.000*(-1.993e-002* 1.250e-003*cos(t)+ 9.998e-001* 5.816e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  6.791e-003, 8.466e-004 center
replot  6.791e-003+ 2.000*( 9.996e-001* 1.673e-003*cos(t)+ 2.996e-002* 9.725e-004*sin(t)),  8.466e-004 +2.000*(-2.996e-002* 1.673e-003*cos(t)+ 9.996e-001* 9.725e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  1.100e-002, 1.681e-003 center
replot  1.100e-002+ 2.000*( 9.986e-001* 2.157e-003*cos(t)+ 5.319e-002* 1.561e-003*sin(t)),  1.681e-003 +2.000*(-5.319e-002* 2.157e-003*cos(t)+ 9.986e-001* 1.561e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.772e-002, 3.301e-003 center
replot  1.772e-002+ 2.000*( 9.861e-001* 2.674e-003*cos(t)+ 1.663e-001* 2.395e-003*sin(t)),  3.301e-003 +2.000*(-1.663e-001* 2.674e-003*cos(t)+ 9.861e-001* 2.395e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  2.831e-002, 6.400e-003 center
replot  2.831e-002+ 2.000*( 1.746e-001* 3.616e-003*cos(t)+ 9.846e-001* 3.243e-003*sin(t)),  6.400e-003 +2.000*(-9.846e-001* 3.616e-003*cos(t)+ 1.746e-001* 3.243e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  4.464e-002, 1.222e-002 center
replot  4.464e-002+ 2.000*( 6.610e-002* 5.801e-003*cos(t)+ 9.978e-001* 4.396e-003*sin(t)),  1.222e-002 +2.000*(-9.978e-001* 5.801e-003*cos(t)+ 6.610e-002* 4.396e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  6.902e-002, 2.285e-002 center
replot  6.902e-002+ 2.000*( 3.728e-002* 1.133e-002*cos(t)+ 9.993e-001* 7.270e-003*sin(t)),  2.285e-002 +2.000*(-9.993e-001* 1.133e-002*cos(t)+ 3.728e-002* 7.270e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.037e-001, 4.160e-002 center
replot  1.037e-001+ 2.000*( 2.255e-002* 2.486e-002*cos(t)+ 9.997e-001* 1.287e-002*sin(t)),  4.160e-002 +2.000*(-9.997e-001* 2.486e-002*cos(t)+ 2.255e-002* 1.287e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.497e-001, 7.281e-002 center
replot  1.497e-001+ 2.000*( 1.496e-002* 5.214e-002*cos(t)+ 9.999e-001* 2.109e-002*sin(t)),  7.281e-002 +2.000*(-9.999e-001* 5.214e-002*cos(t)+ 1.496e-002* 2.109e-002*sin(t)) not
set out;
set out "BEMchr/VARPIJGR_BEMchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "BEMchr/VARPIJGR_BEMchr_123-21.svg"
set label "50" at  4.180e-003, 4.195e-002 center
# Age 50, p23 - p21
plot [-pi:pi]  4.180e-003+ 2.000*( 3.183e-003* 6.975e-003*cos(t)+ 1.000e+000* 1.249e-003*sin(t)),  4.195e-002 +2.000*(-1.000e+000* 6.975e-003*cos(t)+ 3.183e-003* 1.249e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  6.791e-003, 4.140e-002 center
replot  6.791e-003+ 2.000*( 9.270e-003* 5.392e-003*cos(t)+ 1.000e+000* 1.672e-003*sin(t)),  4.140e-002 +2.000*(-1.000e+000* 5.392e-003*cos(t)+ 9.270e-003* 1.672e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  1.100e-002, 4.073e-002 center
replot  1.100e-002+ 2.000*( 3.092e-002* 4.137e-003*cos(t)+ 9.995e-001* 2.153e-003*sin(t)),  4.073e-002 +2.000*(-9.995e-001* 4.137e-003*cos(t)+ 3.092e-002* 2.153e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.772e-002, 3.986e-002 center
replot  1.772e-002+ 2.000*( 1.104e-001* 3.513e-003*cos(t)+ 9.939e-001* 2.654e-003*sin(t)),  3.986e-002 +2.000*(-9.939e-001* 3.513e-003*cos(t)+ 1.104e-001* 2.654e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  2.831e-002, 3.868e-002 center
replot  2.831e-002+ 2.000*( 2.466e-001* 3.745e-003*cos(t)+ 9.691e-001* 3.221e-003*sin(t)),  3.868e-002 +2.000*(-9.691e-001* 3.745e-003*cos(t)+ 2.466e-001* 3.221e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  4.464e-002, 3.705e-002 center
replot  4.464e-002+ 2.000*( 5.942e-001* 4.646e-003*cos(t)+ 8.043e-001* 4.266e-003*sin(t)),  3.705e-002 +2.000*(-8.043e-001* 4.646e-003*cos(t)+ 5.942e-001* 4.266e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  6.902e-002, 3.479e-002 center
replot  6.902e-002+ 2.000*( 9.834e-001* 7.332e-003*cos(t)+ 1.812e-001* 5.398e-003*sin(t)),  3.479e-002 +2.000*(-1.812e-001* 7.332e-003*cos(t)+ 9.834e-001* 5.398e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.037e-001, 3.174e-002 center
replot  1.037e-001+ 2.000*( 9.945e-001* 1.293e-002*cos(t)+ 1.051e-001* 6.182e-003*sin(t)),  3.174e-002 +2.000*(-1.051e-001* 1.293e-002*cos(t)+ 9.945e-001* 6.182e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.497e-001, 2.784e-002 center
replot  1.497e-001+ 2.000*( 9.961e-001* 2.118e-002*cos(t)+ 8.827e-002* 6.577e-003*sin(t)),  2.784e-002 +2.000*(-8.827e-002* 2.118e-002*cos(t)+ 9.961e-001* 6.577e-003*sin(t)) not
set out;
set out "BEMchr/VARPIJGR_BEMchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "BEMchr/VARMUPTJGR--STABLBASED_BEMchr1.svg";
 plot "BEMchr/PRMORPREV-1-STABLBASED_BEMchr.txt"  u 1:($3) not w l lt 1 
 replot "BEMchr/PRMORPREV-1-STABLBASED_BEMchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "BEMchr/PRMORPREV-1-STABLBASED_BEMchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "BEMchr/VARMUPTJGR--STABLBASED_BEMchr1.svg";replot;set out;
