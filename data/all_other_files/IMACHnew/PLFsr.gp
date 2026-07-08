
# IMaCh-0.99r45
# PLFsr.gp
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


set ter svg size 640, 480;set out "PLFsr/D_PLFsr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "PLFsr/ILK_PLFsr-dest.png";
set log y;plot  "PLFsr/ILK_PLFsr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "PLFsr/ILK_PLFsr-ori.png";
set log y;plot  "PLFsr/ILK_PLFsr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "PLFsr/ILK_PLFsr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "PLFsr/ILK_PLFsr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "PLFsr/ILK_PLFsr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "PLFsr/ILK_PLFsr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "PLFsr/V_PLFsr_1-1-1.svg" 

#set out "V_PLFsr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "PLFsr/VPL_PLFsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"PLFsr/VPL_PLFsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"PLFsr/VPL_PLFsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"PLFsr/P_PLFsr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "PLFsr/V_PLFsr_2-1-1.svg" 

#set out "V_PLFsr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "PLFsr/VPL_PLFsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"PLFsr/VPL_PLFsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"PLFsr/VPL_PLFsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"PLFsr/P_PLFsr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "PLFsr/E_PLFsr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "PLFsr/T_PLFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"PLFsr/T_PLFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"PLFsr/T_PLFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"PLFsr/T_PLFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"PLFsr/T_PLFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"PLFsr/T_PLFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"PLFsr/T_PLFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"PLFsr/T_PLFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"PLFsr/T_PLFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "PLFsr/E_PLFsr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "PLFsr/EXP_PLFsr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "PLFsr/E_PLFsr.txt" every :::0::0 u 1:2 t "e11" w l ,"PLFsr/E_PLFsr.txt" every :::0::0 u 1:3 t "e12" w l ,"PLFsr/E_PLFsr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "PLFsr/EXP_PLFsr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "PLFsr/E_PLFsr.txt" every :::0::0 u 1:5 t "e21" w l ,"PLFsr/E_PLFsr.txt" every :::0::0 u 1:6 t "e22" w l ,"PLFsr/E_PLFsr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "PLFsr/LIJ_PLFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFsr/PIJ_PLFsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "PLFsr/LIJ_PLFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFsr/PIJ_PLFsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "PLFsr/LIJT_PLFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFsr/PIJ_PLFsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "PLFsr/LIJT_PLFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFsr/PIJ_PLFsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "PLFsr/P_PLFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFsr/PIJ_PLFsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "PLFsr/P_PLFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFsr/PIJ_PLFsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-4.567926; p2=0.036302; 
#   current state 3
p3=-13.064696; p4=0.114143; 
# initial state 2
#   current state 1
p5=-0.457880; p6=-0.027975; 
#   current state 3
p7=-10.878369; p8=0.099639; 
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

set out "PLFsr/PE_PLFsr_1-1-1.svg" 
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

set out "PLFsr/PE_PLFsr_1-2-1.svg" 
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

set out "PLFsr/PE_PLFsr_1-3-1.svg" 
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
set out "PLFsr/VARPIJGR_PLFsr_113-12.svg"
set label "50" at  1.198e-003, 1.198e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  1.198e-003+ 2.000*( 4.278e-002* 2.799e-002*cos(t)+ 9.991e-001* 2.426e-003*sin(t)),  1.198e-001 +2.000*(-9.991e-001* 2.799e-002*cos(t)+ 4.278e-002* 2.426e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  2.095e-003, 1.419e-001 center
replot  2.095e-003+ 2.000*( 6.421e-002* 2.450e-002*cos(t)+ 9.979e-001* 3.470e-003*sin(t)),  1.419e-001 +2.000*(-9.979e-001* 2.450e-002*cos(t)+ 6.421e-002* 3.470e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  3.652e-003, 1.676e-001 center
replot  3.652e-003+ 2.000*( 8.281e-002* 2.070e-002*cos(t)+ 9.966e-001* 4.784e-003*sin(t)),  1.676e-001 +2.000*(-9.966e-001* 2.070e-002*cos(t)+ 8.281e-002* 4.784e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  6.347e-003, 1.974e-001 center
replot  6.347e-003+ 2.000*( 4.972e-002* 1.997e-002*cos(t)+ 9.988e-001* 6.197e-003*sin(t)),  1.974e-001 +2.000*(-9.988e-001* 1.997e-002*cos(t)+ 4.972e-002* 6.197e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.099e-002, 2.316e-001 center
replot  1.099e-002+ 2.000*( 1.833e-002* 2.756e-002*cos(t)+ 9.998e-001* 7.366e-003*sin(t)),  2.316e-001 +2.000*(-9.998e-001* 2.756e-002*cos(t)+ 1.833e-002* 7.366e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.893e-002, 2.703e-001 center
replot  1.893e-002+ 2.000*( 7.721e-002* 4.397e-002*cos(t)+ 9.970e-001* 1.074e-002*sin(t)),  2.703e-001 +2.000*(-9.970e-001* 4.397e-002*cos(t)+ 7.721e-002* 1.074e-002*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.239e-002, 3.134e-001 center
replot  3.239e-002+ 2.000*( 2.070e-001* 6.890e-002*cos(t)+ 9.783e-001* 2.288e-002*sin(t)),  3.134e-001 +2.000*(-9.783e-001* 6.890e-002*cos(t)+ 2.070e-001* 2.288e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  5.492e-002, 3.600e-001 center
replot  5.492e-002+ 2.000*( 4.407e-001* 1.081e-001*cos(t)+ 8.976e-001* 4.877e-002*sin(t)),  3.600e-001 +2.000*(-8.976e-001* 1.081e-001*cos(t)+ 4.407e-001* 4.877e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  9.194e-002, 4.084e-001 center
replot  9.194e-002+ 2.000*( 7.126e-001* 1.841e-001*cos(t)+ 7.016e-001* 8.382e-002*sin(t)),  4.084e-001 +2.000*(-7.016e-001* 1.841e-001*cos(t)+ 7.126e-001* 8.382e-002*sin(t)) not
set out;
set out "PLFsr/VARPIJGR_PLFsr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "PLFsr/VARPIJGR_PLFsr_121-12.svg"
set label "50" at  2.695e-001, 1.198e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  2.695e-001+ 2.000*( 9.775e-001* 5.653e-002*cos(t)+-2.111e-001* 2.587e-002*sin(t)),  1.198e-001 +2.000*( 2.111e-001* 5.653e-002*cos(t)+ 9.775e-001* 2.587e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  2.382e-001, 1.419e-001 center
replot  2.382e-001+ 2.000*( 9.565e-001* 4.055e-002*cos(t)+-2.917e-001* 2.237e-002*sin(t)),  1.419e-001 +2.000*( 2.917e-001* 4.055e-002*cos(t)+ 9.565e-001* 2.237e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.098e-001, 1.676e-001 center
replot  2.098e-001+ 2.000*( 9.058e-001* 2.872e-002*cos(t)+-4.236e-001* 1.839e-002*sin(t)),  1.676e-001 +2.000*( 4.236e-001* 2.872e-002*cos(t)+ 9.058e-001* 1.839e-002*sin(t)) not
# Age 65, p21 - p12
set label "65" at  1.842e-001, 1.974e-001 center
replot  1.842e-001+ 2.000*( 6.987e-001* 2.309e-002*cos(t)+-7.154e-001* 1.601e-002*sin(t)),  1.974e-001 +2.000*( 7.154e-001* 2.309e-002*cos(t)+ 6.987e-001* 1.601e-002*sin(t)) not
# Age 70, p21 - p12
set label "70" at  1.609e-001, 2.316e-001 center
replot  1.609e-001+ 2.000*( 3.373e-001* 2.872e-002*cos(t)+-9.414e-001* 1.579e-002*sin(t)),  2.316e-001 +2.000*( 9.414e-001* 2.872e-002*cos(t)+ 3.373e-001* 1.579e-002*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.397e-001, 2.703e-001 center
replot  1.397e-001+ 2.000*( 1.939e-001* 4.456e-002*cos(t)+-9.810e-001* 1.758e-002*sin(t)),  2.703e-001 +2.000*( 9.810e-001* 4.456e-002*cos(t)+ 1.939e-001* 1.758e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.203e-001, 3.134e-001 center
replot  1.203e-001+ 2.000*( 1.261e-001* 6.807e-002*cos(t)+-9.920e-001* 2.009e-002*sin(t)),  3.134e-001 +2.000*( 9.920e-001* 6.807e-002*cos(t)+ 1.261e-001* 2.009e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.022e-001, 3.600e-001 center
replot  1.022e-001+ 2.000*( 8.116e-002* 9.968e-002*cos(t)+-9.967e-001* 2.216e-002*sin(t)),  3.600e-001 +2.000*( 9.967e-001* 9.968e-002*cos(t)+ 8.116e-002* 2.216e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  8.510e-002, 4.084e-001 center
replot  8.510e-002+ 2.000*( 4.666e-002* 1.425e-001*cos(t)+-9.989e-001* 2.334e-002*sin(t)),  4.084e-001 +2.000*( 9.989e-001* 1.425e-001*cos(t)+ 4.666e-002* 2.334e-002*sin(t)) not
set out;
set out "PLFsr/VARPIJGR_PLFsr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "PLFsr/VARPIJGR_PLFsr_123-12.svg"
set label "50" at  4.744e-003, 1.198e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  4.744e-003+ 2.000*( 4.560e-002* 2.799e-002*cos(t)+-9.990e-001* 3.444e-003*sin(t)),  1.198e-001 +2.000*( 9.990e-001* 2.799e-002*cos(t)+ 4.560e-002* 3.444e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  7.936e-003, 1.419e-001 center
replot  7.936e-003+ 2.000*( 6.992e-002* 2.451e-002*cos(t)+-9.976e-001* 4.842e-003*sin(t)),  1.419e-001 +2.000*( 9.976e-001* 2.451e-002*cos(t)+ 6.992e-002* 4.842e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  1.323e-002, 1.676e-001 center
replot  1.323e-002+ 2.000*( 9.541e-002* 2.071e-002*cos(t)+-9.954e-001* 6.618e-003*sin(t)),  1.676e-001 +2.000*( 9.954e-001* 2.071e-002*cos(t)+ 9.541e-002* 6.618e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  2.198e-002, 1.974e-001 center
replot  2.198e-002+ 2.000*( 5.376e-002* 1.997e-002*cos(t)+-9.986e-001* 8.664e-003*sin(t)),  1.974e-001 +2.000*( 9.986e-001* 1.997e-002*cos(t)+ 5.376e-002* 8.664e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  3.636e-002, 2.316e-001 center
replot  3.636e-002+ 2.000*( 2.422e-002* 2.756e-002*cos(t)+ 9.997e-001* 1.018e-002*sin(t)),  2.316e-001 +2.000*(-9.997e-001* 2.756e-002*cos(t)+ 2.422e-002* 1.018e-002*sin(t)) not
# Age 75, p23 - p12
set label "75" at  5.976e-002, 2.703e-001 center
replot  5.976e-002+ 2.000*( 1.206e-002* 4.385e-002*cos(t)+ 9.999e-001* 1.101e-002*sin(t)),  2.703e-001 +2.000*(-9.999e-001* 4.385e-002*cos(t)+ 1.206e-002* 1.101e-002*sin(t)) not
# Age 80, p23 - p12
set label "80" at  9.736e-002, 3.134e-001 center
replot  9.736e-002+ 2.000*( 3.983e-002* 6.763e-002*cos(t)+-9.992e-001* 1.429e-002*sin(t)),  3.134e-001 +2.000*( 9.992e-001* 6.763e-002*cos(t)+ 3.983e-002* 1.429e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.565e-001, 3.600e-001 center
replot  1.565e-001+ 2.000*( 1.242e-001* 1.001e-001*cos(t)+-9.923e-001* 2.893e-002*sin(t)),  3.600e-001 +2.000*( 9.923e-001* 1.001e-001*cos(t)+ 1.242e-001* 2.893e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.468e-001, 4.084e-001 center
replot  2.468e-001+ 2.000*( 2.590e-001* 1.464e-001*cos(t)+-9.659e-001* 6.033e-002*sin(t)),  4.084e-001 +2.000*( 9.659e-001* 1.464e-001*cos(t)+ 2.590e-001* 6.033e-002*sin(t)) not
set out;
set out "PLFsr/VARPIJGR_PLFsr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "PLFsr/VARPIJGR_PLFsr_121-13.svg"
set label "50" at  2.695e-001, 1.198e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  2.695e-001+ 2.000*( 1.000e+000* 5.552e-002*cos(t)+ 1.758e-003* 2.702e-003*sin(t)),  1.198e-003 +2.000*(-1.758e-003* 5.552e-002*cos(t)+ 1.000e+000* 2.702e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  2.382e-001, 2.095e-003 center
replot  2.382e-001+ 2.000*( 1.000e+000* 3.933e-002*cos(t)+ 2.877e-003* 3.801e-003*sin(t)),  2.095e-003 +2.000*(-2.877e-003* 3.933e-002*cos(t)+ 1.000e+000* 3.801e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.098e-001, 3.652e-003 center
replot  2.098e-001+ 2.000*( 1.000e+000* 2.716e-002*cos(t)+ 2.690e-003* 5.066e-003*sin(t)),  3.652e-003 +2.000*(-2.690e-003* 2.716e-002*cos(t)+ 1.000e+000* 5.066e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  1.842e-001, 6.347e-003 center
replot  1.842e-001+ 2.000*( 1.000e+000* 1.978e-002*cos(t)+-6.295e-003* 6.268e-003*sin(t)),  6.347e-003 +2.000*( 6.295e-003* 1.978e-002*cos(t)+ 1.000e+000* 6.268e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  1.609e-001, 1.099e-002 center
replot  1.609e-001+ 2.000*( 9.996e-001* 1.775e-002*cos(t)+-2.788e-002* 7.368e-003*sin(t)),  1.099e-002 +2.000*( 2.788e-002* 1.775e-002*cos(t)+ 9.996e-001* 7.368e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.397e-001, 1.893e-002 center
replot  1.397e-001+ 2.000*( 9.989e-001* 1.930e-002*cos(t)+-4.790e-002* 1.121e-002*sin(t)),  1.893e-002 +2.000*( 4.790e-002* 1.930e-002*cos(t)+ 9.989e-001* 1.121e-002*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.203e-001, 3.239e-002 center
replot  1.203e-001+ 2.000*( 7.948e-002* 2.657e-002*cos(t)+-9.968e-001* 2.167e-002*sin(t)),  3.239e-002 +2.000*( 9.968e-001* 2.657e-002*cos(t)+ 7.948e-002* 2.167e-002*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.022e-001, 5.492e-002 center
replot  1.022e-001+ 2.000*( 1.586e-002* 6.470e-002*cos(t)+-9.999e-001* 2.350e-002*sin(t)),  5.492e-002 +2.000*( 9.999e-001* 6.470e-002*cos(t)+ 1.586e-002* 2.350e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  8.510e-002, 9.194e-002 center
replot  8.510e-002+ 2.000*( 1.246e-002* 1.438e-001*cos(t)+-9.999e-001* 2.417e-002*sin(t)),  9.194e-002 +2.000*( 9.999e-001* 1.438e-001*cos(t)+ 1.246e-002* 2.417e-002*sin(t)) not
set out;
set out "PLFsr/VARPIJGR_PLFsr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "PLFsr/VARPIJGR_PLFsr_123-13.svg"
set label "50" at  4.744e-003, 1.198e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  4.744e-003+ 2.000*( 8.398e-001* 4.229e-003*cos(t)+ 5.430e-001* 1.699e-003*sin(t)),  1.198e-003 +2.000*(-5.430e-001* 4.229e-003*cos(t)+ 8.398e-001* 1.699e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  7.936e-003, 2.095e-003 center
replot  7.936e-003+ 2.000*( 8.382e-001* 5.911e-003*cos(t)+ 5.454e-001* 2.407e-003*sin(t)),  2.095e-003 +2.000*(-5.454e-001* 5.911e-003*cos(t)+ 8.382e-001* 2.407e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  1.323e-002, 3.652e-003 center
replot  1.323e-002+ 2.000*( 8.427e-001* 7.887e-003*cos(t)+ 5.383e-001* 3.279e-003*sin(t)),  3.652e-003 +2.000*(-5.383e-001* 7.887e-003*cos(t)+ 8.427e-001* 3.279e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  2.198e-002, 6.347e-003 center
replot  2.198e-002+ 2.000*( 8.568e-001* 9.840e-003*cos(t)+ 5.156e-001* 4.298e-003*sin(t)),  6.347e-003 +2.000*(-5.156e-001* 9.840e-003*cos(t)+ 8.568e-001* 4.298e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  3.636e-002, 1.099e-002 center
replot  3.636e-002+ 2.000*( 8.771e-001* 1.118e-002*cos(t)+ 4.803e-001* 5.772e-003*sin(t)),  1.099e-002 +2.000*(-4.803e-001* 1.118e-002*cos(t)+ 8.771e-001* 5.772e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  5.976e-002, 1.893e-002 center
replot  5.976e-002+ 2.000*( 6.818e-001* 1.251e-002*cos(t)+ 7.315e-001* 9.543e-003*sin(t)),  1.893e-002 +2.000*(-7.315e-001* 1.251e-002*cos(t)+ 6.818e-001* 9.543e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  9.736e-002, 3.239e-002 center
replot  9.736e-002+ 2.000*( 2.445e-001* 2.717e-002*cos(t)+ 9.697e-001* 1.333e-002*sin(t)),  3.239e-002 +2.000*(-9.697e-001* 2.717e-002*cos(t)+ 2.445e-001* 1.333e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.565e-001, 5.492e-002 center
replot  1.565e-001+ 2.000*( 2.989e-001* 6.734e-002*cos(t)+ 9.543e-001* 2.509e-002*sin(t)),  5.492e-002 +2.000*(-9.543e-001* 6.734e-002*cos(t)+ 2.989e-001* 2.509e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.468e-001, 9.194e-002 center
replot  2.468e-001+ 2.000*( 3.280e-001* 1.511e-001*cos(t)+ 9.447e-001* 5.161e-002*sin(t)),  9.194e-002 +2.000*(-9.447e-001* 1.511e-001*cos(t)+ 3.280e-001* 5.161e-002*sin(t)) not
set out;
set out "PLFsr/VARPIJGR_PLFsr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "PLFsr/VARPIJGR_PLFsr_123-21.svg"
set label "50" at  4.744e-003, 2.695e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  4.744e-003+ 2.000*( 1.049e-003* 5.552e-002*cos(t)+-1.000e+000* 3.669e-003*sin(t)),  2.695e-001 +2.000*( 1.000e+000* 5.552e-002*cos(t)+ 1.049e-003* 3.669e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  7.936e-003, 2.382e-001 center
replot  7.936e-003+ 2.000*( 1.676e-003* 3.933e-002*cos(t)+-1.000e+000* 5.125e-003*sin(t)),  2.382e-001 +2.000*( 1.000e+000* 3.933e-002*cos(t)+ 1.676e-003* 5.125e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  1.323e-002, 2.098e-001 center
replot  1.323e-002+ 2.000*( 1.023e-004* 2.716e-002*cos(t)+ 1.000e+000* 6.877e-003*sin(t)),  2.098e-001 +2.000*(-1.000e+000* 2.716e-002*cos(t)+ 1.023e-004* 6.877e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  2.198e-002, 1.842e-001 center
replot  2.198e-002+ 2.000*( 1.513e-002* 1.978e-002*cos(t)+ 9.999e-001* 8.713e-003*sin(t)),  1.842e-001 +2.000*(-9.999e-001* 1.978e-002*cos(t)+ 1.513e-002* 8.713e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  3.636e-002, 1.609e-001 center
replot  3.636e-002+ 2.000*( 4.893e-002* 1.776e-002*cos(t)+ 9.988e-001* 1.017e-002*sin(t)),  1.609e-001 +2.000*(-9.988e-001* 1.776e-002*cos(t)+ 4.893e-002* 1.017e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  5.976e-002, 1.397e-001 center
replot  5.976e-002+ 2.000*( 5.591e-002* 1.931e-002*cos(t)+ 9.984e-001* 1.099e-002*sin(t)),  1.397e-001 +2.000*(-9.984e-001* 1.931e-002*cos(t)+ 5.591e-002* 1.099e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  9.736e-002, 1.203e-001 center
replot  9.736e-002+ 2.000*( 6.105e-002* 2.173e-002*cos(t)+ 9.981e-001* 1.450e-002*sin(t)),  1.203e-001 +2.000*(-9.981e-001* 2.173e-002*cos(t)+ 6.105e-002* 1.450e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.565e-001, 1.022e-001 center
replot  1.565e-001+ 2.000*( 9.961e-001* 3.133e-002*cos(t)+ 8.794e-002* 2.345e-002*sin(t)),  1.022e-001 +2.000*(-8.794e-002* 3.133e-002*cos(t)+ 9.961e-001* 2.345e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.468e-001, 8.510e-002 center
replot  2.468e-001+ 2.000*( 9.992e-001* 6.958e-002*cos(t)+ 3.997e-002* 2.410e-002*sin(t)),  8.510e-002 +2.000*(-3.997e-002* 6.958e-002*cos(t)+ 9.992e-001* 2.410e-002*sin(t)) not
set out;
set out "PLFsr/VARPIJGR_PLFsr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "PLFsr/VARMUPTJGR--STABLBASED_PLFsr1.svg";
 plot "PLFsr/PRMORPREV-1-STABLBASED_PLFsr.txt"  u 1:($3) not w l lt 1 
 replot "PLFsr/PRMORPREV-1-STABLBASED_PLFsr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "PLFsr/PRMORPREV-1-STABLBASED_PLFsr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "PLFsr/VARMUPTJGR--STABLBASED_PLFsr1.svg";replot;set out;
