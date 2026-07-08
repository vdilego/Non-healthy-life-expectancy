
# IMaCh-0.99r45
# PLMchr.gp
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


set ter svg size 640, 480;set out "PLMchr/D_PLMchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "PLMchr/ILK_PLMchr-dest.png";
set log y;plot  "PLMchr/ILK_PLMchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "PLMchr/ILK_PLMchr-ori.png";
set log y;plot  "PLMchr/ILK_PLMchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "PLMchr/ILK_PLMchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "PLMchr/ILK_PLMchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "PLMchr/ILK_PLMchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "PLMchr/ILK_PLMchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "PLMchr/V_PLMchr_1-1-1.svg" 

#set out "V_PLMchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "PLMchr/VPL_PLMchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"PLMchr/VPL_PLMchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"PLMchr/VPL_PLMchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"PLMchr/P_PLMchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "PLMchr/V_PLMchr_2-1-1.svg" 

#set out "V_PLMchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "PLMchr/VPL_PLMchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"PLMchr/VPL_PLMchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"PLMchr/VPL_PLMchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"PLMchr/P_PLMchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "PLMchr/E_PLMchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "PLMchr/T_PLMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"PLMchr/T_PLMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"PLMchr/T_PLMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"PLMchr/T_PLMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"PLMchr/T_PLMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"PLMchr/T_PLMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"PLMchr/T_PLMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"PLMchr/T_PLMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"PLMchr/T_PLMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "PLMchr/E_PLMchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "PLMchr/EXP_PLMchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "PLMchr/E_PLMchr.txt" every :::0::0 u 1:2 t "e11" w l ,"PLMchr/E_PLMchr.txt" every :::0::0 u 1:3 t "e12" w l ,"PLMchr/E_PLMchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "PLMchr/EXP_PLMchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "PLMchr/E_PLMchr.txt" every :::0::0 u 1:5 t "e21" w l ,"PLMchr/E_PLMchr.txt" every :::0::0 u 1:6 t "e22" w l ,"PLMchr/E_PLMchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "PLMchr/LIJ_PLMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMchr/PIJ_PLMchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "PLMchr/LIJ_PLMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMchr/PIJ_PLMchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "PLMchr/LIJT_PLMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMchr/PIJ_PLMchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "PLMchr/LIJT_PLMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMchr/PIJ_PLMchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "PLMchr/P_PLMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMchr/PIJ_PLMchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "PLMchr/P_PLMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMchr/PIJ_PLMchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-0.395552; p2=0.004612; 
#   current state 3
p3=-4.727924; p4=0.038680; 
# initial state 2
#   current state 1
p5=1.919842; p6=-0.065784; 
#   current state 3
p7=-7.481506; p8=0.075316; 
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

set out "PLMchr/PE_PLMchr_1-1-1.svg" 
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

set out "PLMchr/PE_PLMchr_1-2-1.svg" 
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

set out "PLMchr/PE_PLMchr_1-3-1.svg" 
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
set out "PLMchr/VARPIJGR_PLMchr_113-12.svg"
set label "50" at  1.602e-002, 2.221e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  1.602e-002+ 2.000*( 3.838e-002* 3.358e-002*cos(t)+ 9.993e-001* 9.801e-003*sin(t)),  2.221e-001 +2.000*(-9.993e-001* 3.358e-002*cos(t)+ 3.838e-002* 9.801e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.911e-002, 2.234e-001 center
replot  1.911e-002+ 2.000*( 6.707e-002* 2.445e-002*cos(t)+ 9.977e-001* 8.780e-003*sin(t)),  2.234e-001 +2.000*(-9.977e-001* 2.445e-002*cos(t)+ 6.707e-002* 8.780e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  2.277e-002, 2.245e-001 center
replot  2.277e-002+ 2.000*( 9.208e-002* 2.069e-002*cos(t)+ 9.958e-001* 8.368e-003*sin(t)),  2.245e-001 +2.000*(-9.958e-001* 2.069e-002*cos(t)+ 9.208e-002* 8.368e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  2.708e-002, 2.251e-001 center
replot  2.708e-002+ 2.000*( 9.316e-002* 2.478e-002*cos(t)+ 9.957e-001* 1.018e-002*sin(t)),  2.251e-001 +2.000*(-9.957e-001* 2.478e-002*cos(t)+ 9.316e-002* 1.018e-002*sin(t)) not
# Age 70, p13 - p12
set label "70" at  3.215e-002, 2.254e-001 center
replot  3.215e-002+ 2.000*( 1.146e-001* 3.400e-002*cos(t)+ 9.934e-001* 1.508e-002*sin(t)),  2.254e-001 +2.000*(-9.934e-001* 3.400e-002*cos(t)+ 1.146e-001* 1.508e-002*sin(t)) not
# Age 75, p13 - p12
set label "75" at  3.809e-002, 2.252e-001 center
replot  3.809e-002+ 2.000*( 1.680e-001* 4.549e-002*cos(t)+ 9.858e-001* 2.280e-002*sin(t)),  2.252e-001 +2.000*(-9.858e-001* 4.549e-002*cos(t)+ 1.680e-001* 2.280e-002*sin(t)) not
# Age 80, p13 - p12
set label "80" at  4.501e-002, 2.245e-001 center
replot  4.501e-002+ 2.000*( 2.574e-001* 5.845e-002*cos(t)+ 9.663e-001* 3.285e-002*sin(t)),  2.245e-001 +2.000*(-9.663e-001* 5.845e-002*cos(t)+ 2.574e-001* 3.285e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  5.304e-002, 2.231e-001 center
replot  5.304e-002+ 2.000*( 3.850e-001* 7.333e-002*cos(t)+ 9.229e-001* 4.455e-002*sin(t)),  2.231e-001 +2.000*(-9.229e-001* 7.333e-002*cos(t)+ 3.850e-001* 4.455e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  6.230e-002, 2.210e-001 center
replot  6.230e-002+ 2.000*( 5.308e-001* 9.141e-002*cos(t)+ 8.475e-001* 5.668e-002*sin(t)),  2.210e-001 +2.000*(-8.475e-001* 9.141e-002*cos(t)+ 5.308e-001* 5.668e-002*sin(t)) not
set out;
set out "PLMchr/VARPIJGR_PLMchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "PLMchr/VARPIJGR_PLMchr_121-12.svg"
set label "50" at  9.943e-002, 2.221e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  9.943e-002+ 2.000*( 3.717e-002* 3.357e-002*cos(t)+-9.993e-001* 2.503e-002*sin(t)),  2.221e-001 +2.000*( 9.993e-001* 3.357e-002*cos(t)+ 3.717e-002* 2.503e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  7.509e-002, 2.234e-001 center
replot  7.509e-002+ 2.000*( 2.266e-002* 2.440e-002*cos(t)+-9.997e-001* 1.449e-002*sin(t)),  2.234e-001 +2.000*( 9.997e-001* 2.440e-002*cos(t)+ 2.266e-002* 1.449e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  5.565e-002, 2.245e-001 center
replot  5.565e-002+ 2.000*( 1.302e-002* 2.062e-002*cos(t)+-9.999e-001* 8.404e-003*sin(t)),  2.245e-001 +2.000*( 9.999e-001* 2.062e-002*cos(t)+ 1.302e-002* 8.404e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  4.050e-002, 2.251e-001 center
replot  4.050e-002+ 2.000*( 6.318e-003* 2.469e-002*cos(t)+-1.000e+000* 6.505e-003*sin(t)),  2.251e-001 +2.000*( 1.000e+000* 2.469e-002*cos(t)+ 6.318e-003* 6.505e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.896e-002, 2.254e-001 center
replot  2.896e-002+ 2.000*( 3.387e-003* 3.382e-002*cos(t)+-1.000e+000* 6.485e-003*sin(t)),  2.254e-001 +2.000*( 1.000e+000* 3.382e-002*cos(t)+ 3.387e-003* 6.485e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.030e-002, 2.252e-001 center
replot  2.030e-002+ 2.000*( 1.987e-003* 4.501e-002*cos(t)+-1.000e+000* 6.366e-003*sin(t)),  2.252e-001 +2.000*( 1.000e+000* 4.501e-002*cos(t)+ 1.987e-003* 6.366e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.393e-002, 2.245e-001 center
replot  1.393e-002+ 2.000*( 1.162e-003* 5.711e-002*cos(t)+-1.000e+000* 5.770e-003*sin(t)),  2.245e-001 +2.000*( 1.000e+000* 5.711e-002*cos(t)+ 1.162e-003* 5.770e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  9.314e-003, 2.231e-001 center
replot  9.314e-003+ 2.000*( 6.406e-004* 6.981e-002*cos(t)+-1.000e+000* 4.852e-003*sin(t)),  2.231e-001 +2.000*( 1.000e+000* 6.981e-002*cos(t)+ 6.406e-004* 4.852e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  6.047e-003, 2.210e-001 center
replot  6.047e-003+ 2.000*( 3.166e-004* 8.311e-002*cos(t)+-1.000e+000* 3.823e-003*sin(t)),  2.210e-001 +2.000*( 1.000e+000* 8.311e-002*cos(t)+ 3.166e-004* 3.823e-003*sin(t)) not
set out;
set out "PLMchr/VARPIJGR_PLMchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "PLMchr/VARPIJGR_PLMchr_123-12.svg"
set label "50" at  9.517e-003, 2.221e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  9.517e-003+ 2.000*( 3.182e-004* 3.356e-002*cos(t)+ 1.000e+000* 3.768e-003*sin(t)),  2.221e-001 +2.000*(-1.000e+000* 3.356e-002*cos(t)+ 3.182e-004* 3.768e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.455e-002, 2.234e-001 center
replot  1.455e-002+ 2.000*( 2.956e-004* 2.440e-002*cos(t)+ 1.000e+000* 4.617e-003*sin(t)),  2.234e-001 +2.000*(-1.000e+000* 2.440e-002*cos(t)+ 2.956e-004* 4.617e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  2.184e-002, 2.245e-001 center
replot  2.184e-002+ 2.000*( 1.688e-005* 2.061e-002*cos(t)+ 1.000e+000* 5.361e-003*sin(t)),  2.245e-001 +2.000*(-1.000e+000* 2.061e-002*cos(t)+ 1.688e-005* 5.361e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  3.219e-002, 2.251e-001 center
replot  3.219e-002+ 2.000*( 3.198e-004* 2.469e-002*cos(t)+-1.000e+000* 5.971e-003*sin(t)),  2.251e-001 +2.000*( 1.000e+000* 2.469e-002*cos(t)+ 3.198e-004* 5.971e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  4.659e-002, 2.254e-001 center
replot  4.659e-002+ 2.000*( 5.126e-004* 3.382e-002*cos(t)+-1.000e+000* 6.905e-003*sin(t)),  2.254e-001 +2.000*( 1.000e+000* 3.382e-002*cos(t)+ 5.126e-004* 6.905e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  6.615e-002, 2.252e-001 center
replot  6.615e-002+ 2.000*( 7.545e-004* 4.501e-002*cos(t)+-1.000e+000* 9.613e-003*sin(t)),  2.252e-001 +2.000*( 1.000e+000* 4.501e-002*cos(t)+ 7.545e-004* 9.613e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  9.189e-002, 2.245e-001 center
replot  9.189e-002+ 2.000*( 1.130e-003* 5.711e-002*cos(t)+-1.000e+000* 1.562e-002*sin(t)),  2.245e-001 +2.000*( 1.000e+000* 5.711e-002*cos(t)+ 1.130e-003* 1.562e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.244e-001, 2.231e-001 center
replot  1.244e-001+ 2.000*( 1.677e-003* 6.981e-002*cos(t)+-1.000e+000* 2.521e-002*sin(t)),  2.231e-001 +2.000*( 1.000e+000* 6.981e-002*cos(t)+ 1.677e-003* 2.521e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.636e-001, 2.210e-001 center
replot  1.636e-001+ 2.000*( 2.396e-003* 8.311e-002*cos(t)+-1.000e+000* 3.752e-002*sin(t)),  2.210e-001 +2.000*( 1.000e+000* 8.311e-002*cos(t)+ 2.396e-003* 3.752e-002*sin(t)) not
set out;
set out "PLMchr/VARPIJGR_PLMchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "PLMchr/VARPIJGR_PLMchr_121-13.svg"
set label "50" at  9.943e-002, 1.602e-002 center
# Age 50, p21 - p13
plot [-pi:pi]  9.943e-002+ 2.000*( 1.000e+000* 2.504e-002*cos(t)+-1.684e-003* 9.878e-003*sin(t)),  1.602e-002 +2.000*( 1.684e-003* 2.504e-002*cos(t)+ 1.000e+000* 9.878e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  7.509e-002, 1.911e-002 center
replot  7.509e-002+ 2.000*( 1.000e+000* 1.450e-002*cos(t)+ 7.441e-004* 8.912e-003*sin(t)),  1.911e-002 +2.000*(-7.441e-004* 1.450e-002*cos(t)+ 1.000e+000* 8.912e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  5.565e-002, 2.277e-002 center
replot  5.565e-002+ 2.000*( 6.560e-002* 8.548e-003*cos(t)+-9.978e-001* 8.407e-003*sin(t)),  2.277e-002 +2.000*( 9.978e-001* 8.548e-003*cos(t)+ 6.560e-002* 8.407e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  4.050e-002, 2.708e-002 center
replot  4.050e-002+ 2.000*( 2.045e-002* 1.039e-002*cos(t)+-9.998e-001* 6.505e-003*sin(t)),  2.708e-002 +2.000*( 9.998e-001* 1.039e-002*cos(t)+ 2.045e-002* 6.505e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.896e-002, 3.215e-002 center
replot  2.896e-002+ 2.000*( 1.543e-002* 1.548e-002*cos(t)+-9.999e-001* 6.482e-003*sin(t)),  3.215e-002 +2.000*( 9.999e-001* 1.548e-002*cos(t)+ 1.543e-002* 6.482e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.030e-002, 3.809e-002 center
replot  2.030e-002+ 2.000*( 9.284e-003* 2.374e-002*cos(t)+-1.000e+000* 6.363e-003*sin(t)),  3.809e-002 +2.000*( 1.000e+000* 2.374e-002*cos(t)+ 9.284e-003* 6.363e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.393e-002, 4.501e-002 center
replot  1.393e-002+ 2.000*( 5.332e-003* 3.513e-002*cos(t)+-1.000e+000* 5.767e-003*sin(t)),  4.501e-002 +2.000*( 1.000e+000* 3.513e-002*cos(t)+ 5.332e-003* 5.767e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  9.314e-003, 5.304e-002 center
replot  9.314e-003+ 2.000*( 3.017e-003* 4.987e-002*cos(t)+-1.000e+000* 4.850e-003*sin(t)),  5.304e-002 +2.000*( 1.000e+000* 4.987e-002*cos(t)+ 3.017e-003* 4.850e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  6.047e-003, 6.230e-002 center
replot  6.047e-003+ 2.000*( 1.679e-003* 6.828e-002*cos(t)+-1.000e+000* 3.822e-003*sin(t)),  6.230e-002 +2.000*( 1.000e+000* 6.828e-002*cos(t)+ 1.679e-003* 3.822e-003*sin(t)) not
set out;
set out "PLMchr/VARPIJGR_PLMchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "PLMchr/VARPIJGR_PLMchr_123-13.svg"
set label "50" at  9.517e-003, 1.602e-002 center
# Age 50, p23 - p13
plot [-pi:pi]  9.517e-003+ 2.000*( 7.547e-004* 9.878e-003*cos(t)+ 1.000e+000* 3.768e-003*sin(t)),  1.602e-002 +2.000*(-1.000e+000* 9.878e-003*cos(t)+ 7.547e-004* 3.768e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.455e-002, 1.911e-002 center
replot  1.455e-002+ 2.000*( 1.118e-003* 8.912e-003*cos(t)+ 1.000e+000* 4.617e-003*sin(t)),  1.911e-002 +2.000*(-1.000e+000* 8.912e-003*cos(t)+ 1.118e-003* 4.617e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  2.184e-002, 2.277e-002 center
replot  2.184e-002+ 2.000*( 4.178e-003* 8.548e-003*cos(t)+ 1.000e+000* 5.361e-003*sin(t)),  2.277e-002 +2.000*(-1.000e+000* 8.548e-003*cos(t)+ 4.178e-003* 5.361e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  3.219e-002, 2.708e-002 center
replot  3.219e-002+ 2.000*( 8.471e-003* 1.039e-002*cos(t)+ 1.000e+000* 5.971e-003*sin(t)),  2.708e-002 +2.000*(-1.000e+000* 1.039e-002*cos(t)+ 8.471e-003* 5.971e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  4.659e-002, 3.215e-002 center
replot  4.659e-002+ 2.000*( 8.905e-003* 1.548e-002*cos(t)+ 1.000e+000* 6.904e-003*sin(t)),  3.215e-002 +2.000*(-1.000e+000* 1.548e-002*cos(t)+ 8.905e-003* 6.904e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  6.615e-002, 3.809e-002 center
replot  6.615e-002+ 2.000*( 8.693e-003* 2.374e-002*cos(t)+ 1.000e+000* 9.611e-003*sin(t)),  3.809e-002 +2.000*(-1.000e+000* 2.374e-002*cos(t)+ 8.693e-003* 9.611e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  9.189e-002, 4.501e-002 center
replot  9.189e-002+ 2.000*( 8.788e-003* 3.513e-002*cos(t)+ 1.000e+000* 1.562e-002*sin(t)),  4.501e-002 +2.000*(-1.000e+000* 3.513e-002*cos(t)+ 8.788e-003* 1.562e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.244e-001, 5.304e-002 center
replot  1.244e-001+ 2.000*( 8.998e-003* 4.987e-002*cos(t)+ 1.000e+000* 2.521e-002*sin(t)),  5.304e-002 +2.000*(-1.000e+000* 4.987e-002*cos(t)+ 8.998e-003* 2.521e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.636e-001, 6.230e-002 center
replot  1.636e-001+ 2.000*( 8.883e-003* 6.828e-002*cos(t)+ 1.000e+000* 3.751e-002*sin(t)),  6.230e-002 +2.000*(-1.000e+000* 6.828e-002*cos(t)+ 8.883e-003* 3.751e-002*sin(t)) not
set out;
set out "PLMchr/VARPIJGR_PLMchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "PLMchr/VARPIJGR_PLMchr_123-21.svg"
set label "50" at  9.517e-003, 9.943e-002 center
# Age 50, p23 - p21
plot [-pi:pi]  9.517e-003+ 2.000*( 1.953e-002* 2.504e-002*cos(t)+ 9.998e-001* 3.736e-003*sin(t)),  9.943e-002 +2.000*(-9.998e-001* 2.504e-002*cos(t)+ 1.953e-002* 3.736e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.455e-002, 7.509e-002 center
replot  1.455e-002+ 2.000*( 3.149e-002* 1.451e-002*cos(t)+ 9.995e-001* 4.597e-003*sin(t)),  7.509e-002 +2.000*(-9.995e-001* 1.451e-002*cos(t)+ 3.149e-002* 4.597e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  2.184e-002, 5.565e-002 center
replot  2.184e-002+ 2.000*( 8.129e-002* 8.424e-003*cos(t)+ 9.967e-001* 5.335e-003*sin(t)),  5.565e-002 +2.000*(-9.967e-001* 8.424e-003*cos(t)+ 8.129e-002* 5.335e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  3.219e-002, 4.050e-002 center
replot  3.219e-002+ 2.000*( 3.779e-001* 6.609e-003*cos(t)+ 9.259e-001* 5.858e-003*sin(t)),  4.050e-002 +2.000*(-9.259e-001* 6.609e-003*cos(t)+ 3.779e-001* 5.858e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  4.659e-002, 2.896e-002 center
replot  4.659e-002+ 2.000*( 8.833e-001* 7.062e-003*cos(t)+ 4.688e-001* 6.314e-003*sin(t)),  2.896e-002 +2.000*(-4.688e-001* 7.062e-003*cos(t)+ 8.833e-001* 6.314e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  6.615e-002, 2.030e-002 center
replot  6.615e-002+ 2.000*( 9.942e-001* 9.645e-003*cos(t)+ 1.072e-001* 6.318e-003*sin(t)),  2.030e-002 +2.000*(-1.072e-001* 9.645e-003*cos(t)+ 9.942e-001* 6.318e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  9.189e-002, 1.393e-002 center
replot  9.189e-002+ 2.000*( 9.992e-001* 1.563e-002*cos(t)+ 4.076e-002* 5.740e-003*sin(t)),  1.393e-002 +2.000*(-4.076e-002* 1.563e-002*cos(t)+ 9.992e-001* 5.740e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.244e-001, 9.314e-003 center
replot  1.244e-001+ 2.000*( 9.997e-001* 2.522e-002*cos(t)+ 2.289e-002* 4.819e-003*sin(t)),  9.314e-003 +2.000*(-2.289e-002* 2.522e-002*cos(t)+ 9.997e-001* 4.819e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.636e-001, 6.047e-003 center
replot  1.636e-001+ 2.000*( 9.999e-001* 3.752e-002*cos(t)+ 1.543e-002* 3.780e-003*sin(t)),  6.047e-003 +2.000*(-1.543e-002* 3.752e-002*cos(t)+ 9.999e-001* 3.780e-003*sin(t)) not
set out;
set out "PLMchr/VARPIJGR_PLMchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "PLMchr/VARMUPTJGR--STABLBASED_PLMchr1.svg";
 plot "PLMchr/PRMORPREV-1-STABLBASED_PLMchr.txt"  u 1:($3) not w l lt 1 
 replot "PLMchr/PRMORPREV-1-STABLBASED_PLMchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "PLMchr/PRMORPREV-1-STABLBASED_PLMchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "PLMchr/VARMUPTJGR--STABLBASED_PLMchr1.svg";replot;set out;
