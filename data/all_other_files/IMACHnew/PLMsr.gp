
# IMaCh-0.99r45
# PLMsr.gp
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


set ter svg size 640, 480;set out "PLMsr/D_PLMsr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "PLMsr/ILK_PLMsr-dest.png";
set log y;plot  "PLMsr/ILK_PLMsr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "PLMsr/ILK_PLMsr-ori.png";
set log y;plot  "PLMsr/ILK_PLMsr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "PLMsr/ILK_PLMsr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "PLMsr/ILK_PLMsr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "PLMsr/ILK_PLMsr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "PLMsr/ILK_PLMsr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "PLMsr/V_PLMsr_1-1-1.svg" 

#set out "V_PLMsr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "PLMsr/VPL_PLMsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"PLMsr/VPL_PLMsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"PLMsr/VPL_PLMsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"PLMsr/P_PLMsr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "PLMsr/V_PLMsr_2-1-1.svg" 

#set out "V_PLMsr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "PLMsr/VPL_PLMsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"PLMsr/VPL_PLMsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"PLMsr/VPL_PLMsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"PLMsr/P_PLMsr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "PLMsr/E_PLMsr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "PLMsr/T_PLMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"PLMsr/T_PLMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"PLMsr/T_PLMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"PLMsr/T_PLMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"PLMsr/T_PLMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"PLMsr/T_PLMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"PLMsr/T_PLMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"PLMsr/T_PLMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"PLMsr/T_PLMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "PLMsr/E_PLMsr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "PLMsr/EXP_PLMsr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "PLMsr/E_PLMsr.txt" every :::0::0 u 1:2 t "e11" w l ,"PLMsr/E_PLMsr.txt" every :::0::0 u 1:3 t "e12" w l ,"PLMsr/E_PLMsr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "PLMsr/EXP_PLMsr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "PLMsr/E_PLMsr.txt" every :::0::0 u 1:5 t "e21" w l ,"PLMsr/E_PLMsr.txt" every :::0::0 u 1:6 t "e22" w l ,"PLMsr/E_PLMsr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "PLMsr/LIJ_PLMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMsr/PIJ_PLMsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "PLMsr/LIJ_PLMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMsr/PIJ_PLMsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "PLMsr/LIJT_PLMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMsr/PIJ_PLMsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "PLMsr/LIJT_PLMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMsr/PIJ_PLMsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "PLMsr/P_PLMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMsr/PIJ_PLMsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "PLMsr/P_PLMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMsr/PIJ_PLMsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-2.341658; p2=0.006191; 
#   current state 3
p3=-5.798869; p4=0.011468; 
# initial state 2
#   current state 1
p5=1.273279; p6=-0.053827; 
#   current state 3
p7=-7.726596; p8=0.062965; 
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

set out "PLMsr/PE_PLMsr_1-1-1.svg" 
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

set out "PLMsr/PE_PLMsr_1-2-1.svg" 
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

set out "PLMsr/PE_PLMsr_1-3-1.svg" 
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
set out "PLMsr/VARPIJGR_PLMsr_113-12.svg"
set label "50" at  9.465e-003, 2.307e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  9.465e-003+ 2.000*( 1.109e-002* 4.797e-002*cos(t)+ 9.999e-001* 8.213e-003*sin(t)),  2.307e-001 +2.000*(-9.999e-001* 4.797e-002*cos(t)+ 1.109e-002* 8.213e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  9.984e-003, 2.370e-001 center
replot  9.984e-003+ 2.000*( 1.551e-002* 3.787e-002*cos(t)+ 9.999e-001* 6.808e-003*sin(t)),  2.370e-001 +2.000*(-9.999e-001* 3.787e-002*cos(t)+ 1.551e-002* 6.808e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.053e-002, 2.435e-001 center
replot  1.053e-002+ 2.000*( 2.702e-002* 2.987e-002*cos(t)+ 9.996e-001* 6.053e-003*sin(t)),  2.435e-001 +2.000*(-9.996e-001* 2.987e-002*cos(t)+ 2.702e-002* 6.053e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.111e-002, 2.501e-001 center
replot  1.111e-002+ 2.000*( 4.569e-002* 2.698e-002*cos(t)+ 9.990e-001* 6.547e-003*sin(t)),  2.501e-001 +2.000*(-9.990e-001* 2.698e-002*cos(t)+ 4.569e-002* 6.547e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.171e-002, 2.568e-001 center
replot  1.171e-002+ 2.000*( 5.204e-002* 3.161e-002*cos(t)+ 9.986e-001* 8.438e-003*sin(t)),  2.568e-001 +2.000*(-9.986e-001* 3.161e-002*cos(t)+ 5.204e-002* 8.438e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.235e-002, 2.638e-001 center
replot  1.235e-002+ 2.000*( 4.685e-002* 4.204e-002*cos(t)+ 9.989e-001* 1.137e-002*sin(t)),  2.638e-001 +2.000*(-9.989e-001* 4.204e-002*cos(t)+ 4.685e-002* 1.137e-002*sin(t)) not
# Age 80, p13 - p12
set label "80" at  1.302e-002, 2.708e-001 center
replot  1.302e-002+ 2.000*( 4.175e-002* 5.568e-002*cos(t)+ 9.991e-001* 1.501e-002*sin(t)),  2.708e-001 +2.000*(-9.991e-001* 5.568e-002*cos(t)+ 4.175e-002* 1.501e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  1.372e-002, 2.781e-001 center
replot  1.372e-002+ 2.000*( 3.876e-002* 7.120e-002*cos(t)+ 9.992e-001* 1.923e-002*sin(t)),  2.781e-001 +2.000*(-9.992e-001* 7.120e-002*cos(t)+ 3.876e-002* 1.923e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.446e-002, 2.854e-001 center
replot  1.446e-002+ 2.000*( 3.734e-002* 8.803e-002*cos(t)+ 9.993e-001* 2.398e-002*sin(t)),  2.854e-001 +2.000*(-9.993e-001* 8.803e-002*cos(t)+ 3.734e-002* 2.398e-002*sin(t)) not
set out;
set out "PLMsr/VARPIJGR_PLMsr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "PLMsr/VARPIJGR_PLMsr_121-12.svg"
set label "50" at  3.867e-001, 2.307e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  3.867e-001+ 2.000*( 9.461e-001* 8.894e-002*cos(t)+-3.239e-001* 4.054e-002*sin(t)),  2.307e-001 +2.000*( 3.239e-001* 8.894e-002*cos(t)+ 9.461e-001* 4.054e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.086e-001, 2.370e-001 center
replot  3.086e-001+ 2.000*( 8.949e-001* 5.843e-002*cos(t)+-4.464e-001* 3.068e-002*sin(t)),  2.370e-001 +2.000*( 4.464e-001* 5.843e-002*cos(t)+ 8.949e-001* 3.068e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.436e-001, 2.435e-001 center
replot  2.436e-001+ 2.000*( 7.765e-001* 3.838e-002*cos(t)+-6.301e-001* 2.255e-002*sin(t)),  2.435e-001 +2.000*( 6.301e-001* 3.838e-002*cos(t)+ 7.765e-001* 2.255e-002*sin(t)) not
# Age 65, p21 - p12
set label "65" at  1.904e-001, 2.501e-001 center
replot  1.904e-001+ 2.000*( 5.542e-001* 2.993e-002*cos(t)+-8.324e-001* 1.854e-002*sin(t)),  2.501e-001 +2.000*( 8.324e-001* 2.993e-002*cos(t)+ 5.542e-001* 1.854e-002*sin(t)) not
# Age 70, p21 - p12
set label "70" at  1.475e-001, 2.568e-001 center
replot  1.475e-001+ 2.000*( 3.342e-001* 3.282e-002*cos(t)+-9.425e-001* 1.884e-002*sin(t)),  2.568e-001 +2.000*( 9.425e-001* 3.282e-002*cos(t)+ 3.342e-001* 1.884e-002*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.133e-001, 2.638e-001 center
replot  1.133e-001+ 2.000*( 2.182e-001* 4.280e-002*cos(t)+-9.759e-001* 2.027e-002*sin(t)),  2.638e-001 +2.000*( 9.759e-001* 4.280e-002*cos(t)+ 2.182e-001* 2.027e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  8.633e-002, 2.708e-001 center
replot  8.633e-002+ 2.000*( 1.543e-001* 5.622e-002*cos(t)+-9.880e-001* 2.079e-002*sin(t)),  2.708e-001 +2.000*( 9.880e-001* 5.622e-002*cos(t)+ 1.543e-001* 2.079e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  6.516e-002, 2.781e-001 center
replot  6.516e-002+ 2.000*( 1.121e-001* 7.157e-002*cos(t)+-9.937e-001* 2.008e-002*sin(t)),  2.781e-001 +2.000*( 9.937e-001* 7.157e-002*cos(t)+ 1.121e-001* 2.008e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  4.867e-002, 2.854e-001 center
replot  4.867e-002+ 2.000*( 8.194e-002* 8.826e-002*cos(t)+-9.966e-001* 1.841e-002*sin(t)),  2.854e-001 +2.000*( 9.966e-001* 8.826e-002*cos(t)+ 8.194e-002* 1.841e-002*sin(t)) not
set out;
set out "PLMsr/VARPIJGR_PLMsr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "PLMsr/VARPIJGR_PLMsr_123-12.svg"
set label "50" at  1.640e-002, 2.307e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  1.640e-002+ 2.000*( 4.365e-004* 4.797e-002*cos(t)+-1.000e+000* 7.075e-003*sin(t)),  2.307e-001 +2.000*( 1.000e+000* 4.797e-002*cos(t)+ 4.365e-004* 7.075e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.347e-002, 2.370e-001 center
replot  2.347e-002+ 2.000*( 7.397e-003* 3.787e-002*cos(t)+-1.000e+000* 8.315e-003*sin(t)),  2.370e-001 +2.000*( 1.000e+000* 3.787e-002*cos(t)+ 7.397e-003* 8.315e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.322e-002, 2.435e-001 center
replot  3.322e-002+ 2.000*( 2.272e-002* 2.986e-002*cos(t)+-9.997e-001* 9.355e-003*sin(t)),  2.435e-001 +2.000*( 9.997e-001* 2.986e-002*cos(t)+ 2.272e-002* 9.355e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  4.657e-002, 2.501e-001 center
replot  4.657e-002+ 2.000*( 3.922e-002* 2.697e-002*cos(t)+-9.992e-001* 1.013e-002*sin(t)),  2.501e-001 +2.000*( 9.992e-001* 2.697e-002*cos(t)+ 3.922e-002* 1.013e-002*sin(t)) not
# Age 70, p23 - p12
set label "70" at  6.470e-002, 2.568e-001 center
replot  6.470e-002+ 2.000*( 3.248e-002* 3.158e-002*cos(t)+-9.995e-001* 1.107e-002*sin(t)),  2.568e-001 +2.000*( 9.995e-001* 3.158e-002*cos(t)+ 3.248e-002* 1.107e-002*sin(t)) not
# Age 75, p23 - p12
set label "75" at  8.912e-002, 2.638e-001 center
replot  8.912e-002+ 2.000*( 1.969e-002* 4.201e-002*cos(t)+-9.998e-001* 1.391e-002*sin(t)),  2.638e-001 +2.000*( 9.998e-001* 4.201e-002*cos(t)+ 1.969e-002* 1.391e-002*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.217e-001, 2.708e-001 center
replot  1.217e-001+ 2.000*( 1.333e-002* 5.564e-002*cos(t)+-9.999e-001* 2.163e-002*sin(t)),  2.708e-001 +2.000*( 9.999e-001* 5.564e-002*cos(t)+ 1.333e-002* 2.163e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.647e-001, 2.781e-001 center
replot  1.647e-001+ 2.000*( 1.256e-002* 7.115e-002*cos(t)+-9.999e-001* 3.664e-002*sin(t)),  2.781e-001 +2.000*( 9.999e-001* 7.115e-002*cos(t)+ 1.256e-002* 3.664e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.206e-001, 2.854e-001 center
replot  2.206e-001+ 2.000*( 1.877e-002* 8.799e-002*cos(t)+-9.998e-001* 6.068e-002*sin(t)),  2.854e-001 +2.000*( 9.998e-001* 8.799e-002*cos(t)+ 1.877e-002* 6.068e-002*sin(t)) not
set out;
set out "PLMsr/VARPIJGR_PLMsr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "PLMsr/VARPIJGR_PLMsr_121-13.svg"
set label "50" at  3.867e-001, 9.465e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  3.867e-001+ 2.000*( 1.000e+000* 8.517e-002*cos(t)+-1.122e-003* 8.229e-003*sin(t)),  9.465e-003 +2.000*( 1.122e-003* 8.517e-002*cos(t)+ 1.000e+000* 8.229e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.086e-001, 9.984e-003 center
replot  3.086e-001+ 2.000*( 1.000e+000* 5.405e-002*cos(t)+-5.113e-004* 6.832e-003*sin(t)),  9.984e-003 +2.000*( 5.113e-004* 5.405e-002*cos(t)+ 1.000e+000* 6.832e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.436e-001, 1.053e-002 center
replot  2.436e-001+ 2.000*( 1.000e+000* 3.301e-002*cos(t)+-4.741e-004* 6.104e-003*sin(t)),  1.053e-002 +2.000*( 4.741e-004* 3.301e-002*cos(t)+ 1.000e+000* 6.104e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  1.904e-001, 1.111e-002 center
replot  1.904e-001+ 2.000*( 1.000e+000* 2.266e-002*cos(t)+-6.833e-003* 6.654e-003*sin(t)),  1.111e-002 +2.000*( 6.833e-003* 2.266e-002*cos(t)+ 1.000e+000* 6.654e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  1.475e-001, 1.171e-002 center
replot  1.475e-001+ 2.000*( 9.998e-001* 2.087e-002*cos(t)+-2.169e-002* 8.576e-003*sin(t)),  1.171e-002 +2.000*( 2.169e-002* 2.087e-002*cos(t)+ 9.998e-001* 8.576e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.133e-001, 1.235e-002 center
replot  1.133e-001+ 2.000*( 9.993e-001* 2.189e-002*cos(t)+-3.777e-002* 1.150e-002*sin(t)),  1.235e-002 +2.000*( 3.777e-002* 2.189e-002*cos(t)+ 9.993e-001* 1.150e-002*sin(t)) not
# Age 80, p21 - p13
set label "80" at  8.633e-002, 1.302e-002 center
replot  8.633e-002+ 2.000*( 9.978e-001* 2.233e-002*cos(t)+-6.687e-002* 1.513e-002*sin(t)),  1.302e-002 +2.000*( 6.687e-002* 2.233e-002*cos(t)+ 9.978e-001* 1.513e-002*sin(t)) not
# Age 85, p21 - p13
set label "85" at  6.516e-002, 1.372e-002 center
replot  6.516e-002+ 2.000*( 9.721e-001* 2.163e-002*cos(t)+-2.347e-001* 1.927e-002*sin(t)),  1.372e-002 +2.000*( 2.347e-001* 2.163e-002*cos(t)+ 9.721e-001* 1.927e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  4.867e-002, 1.446e-002 center
replot  4.867e-002+ 2.000*( 1.234e-001* 2.425e-002*cos(t)+-9.924e-001* 1.965e-002*sin(t)),  1.446e-002 +2.000*( 9.924e-001* 2.425e-002*cos(t)+ 1.234e-001* 1.965e-002*sin(t)) not
set out;
set out "PLMsr/VARPIJGR_PLMsr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "PLMsr/VARPIJGR_PLMsr_123-13.svg"
set label "50" at  1.640e-002, 9.465e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  1.640e-002+ 2.000*( 4.399e-001* 8.562e-003*cos(t)+ 8.980e-001* 6.669e-003*sin(t)),  9.465e-003 +2.000*(-8.980e-001* 8.562e-003*cos(t)+ 4.399e-001* 6.669e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.347e-002, 9.984e-003 center
replot  2.347e-002+ 2.000*( 8.992e-001* 8.729e-003*cos(t)+ 4.376e-001* 6.300e-003*sin(t)),  9.984e-003 +2.000*(-4.376e-001* 8.729e-003*cos(t)+ 8.992e-001* 6.300e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.322e-002, 1.053e-002 center
replot  3.322e-002+ 2.000*( 9.524e-001* 9.680e-003*cos(t)+ 3.047e-001* 5.611e-003*sin(t)),  1.053e-002 +2.000*(-3.047e-001* 9.680e-003*cos(t)+ 9.524e-001* 5.611e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  4.657e-002, 1.111e-002 center
replot  4.657e-002+ 2.000*( 9.467e-001* 1.055e-002*cos(t)+ 3.220e-001* 6.045e-003*sin(t)),  1.111e-002 +2.000*(-3.220e-001* 1.055e-002*cos(t)+ 9.467e-001* 6.045e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  6.470e-002, 1.171e-002 center
replot  6.470e-002+ 2.000*( 9.081e-001* 1.171e-002*cos(t)+ 4.188e-001* 7.762e-003*sin(t)),  1.171e-002 +2.000*(-4.188e-001* 1.171e-002*cos(t)+ 9.081e-001* 7.762e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  8.912e-002, 1.235e-002 center
replot  8.912e-002+ 2.000*( 9.012e-001* 1.458e-002*cos(t)+ 4.334e-001* 1.069e-002*sin(t)),  1.235e-002 +2.000*(-4.334e-001* 1.458e-002*cos(t)+ 9.012e-001* 1.069e-002*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.217e-001, 1.302e-002 center
replot  1.217e-001+ 2.000*( 9.786e-001* 2.190e-002*cos(t)+ 2.056e-001* 1.481e-002*sin(t)),  1.302e-002 +2.000*(-2.056e-001* 2.190e-002*cos(t)+ 9.786e-001* 1.481e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.647e-001, 1.372e-002 center
replot  1.647e-001+ 2.000*( 9.971e-001* 3.672e-002*cos(t)+ 7.617e-002* 1.926e-002*sin(t)),  1.372e-002 +2.000*(-7.617e-002* 3.672e-002*cos(t)+ 9.971e-001* 1.926e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.206e-001, 1.446e-002 center
replot  2.206e-001+ 2.000*( 9.994e-001* 6.072e-002*cos(t)+ 3.507e-002* 2.411e-002*sin(t)),  1.446e-002 +2.000*(-3.507e-002* 6.072e-002*cos(t)+ 9.994e-001* 2.411e-002*sin(t)) not
set out;
set out "PLMsr/VARPIJGR_PLMsr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "PLMsr/VARPIJGR_PLMsr_123-21.svg"
set label "50" at  1.640e-002, 3.867e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.640e-002+ 2.000*( 5.620e-003* 8.517e-002*cos(t)+ 1.000e+000* 7.059e-003*sin(t)),  3.867e-001 +2.000*(-1.000e+000* 8.517e-002*cos(t)+ 5.620e-003* 7.059e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.347e-002, 3.086e-001 center
replot  2.347e-002+ 2.000*( 6.384e-003* 5.405e-002*cos(t)+ 1.000e+000* 8.312e-003*sin(t)),  3.086e-001 +2.000*(-1.000e+000* 5.405e-002*cos(t)+ 6.384e-003* 8.312e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.322e-002, 2.436e-001 center
replot  3.322e-002+ 2.000*( 8.251e-003* 3.301e-002*cos(t)+ 1.000e+000* 9.374e-003*sin(t)),  2.436e-001 +2.000*(-1.000e+000* 3.301e-002*cos(t)+ 8.251e-003* 9.374e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  4.657e-002, 1.904e-001 center
replot  4.657e-002+ 2.000*( 1.808e-002* 2.266e-002*cos(t)+ 9.998e-001* 1.017e-002*sin(t)),  1.904e-001 +2.000*(-9.998e-001* 2.266e-002*cos(t)+ 1.808e-002* 1.017e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  6.470e-002, 1.475e-001 center
replot  6.470e-002+ 2.000*( 3.553e-002* 2.088e-002*cos(t)+ 9.994e-001* 1.110e-002*sin(t)),  1.475e-001 +2.000*(-9.994e-001* 2.088e-002*cos(t)+ 3.553e-002* 1.110e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  8.912e-002, 1.133e-001 center
replot  8.912e-002+ 2.000*( 5.628e-002* 2.190e-002*cos(t)+ 9.984e-001* 1.390e-002*sin(t)),  1.133e-001 +2.000*(-9.984e-001* 2.190e-002*cos(t)+ 5.628e-002* 1.390e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.217e-001, 8.633e-002 center
replot  1.217e-001+ 2.000*( 4.812e-001* 2.258e-002*cos(t)+ 8.766e-001* 2.135e-002*sin(t)),  8.633e-002 +2.000*(-8.766e-001* 2.258e-002*cos(t)+ 4.812e-001* 2.135e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.647e-001, 6.516e-002 center
replot  1.647e-001+ 2.000*( 9.992e-001* 3.667e-002*cos(t)+ 4.113e-002* 2.147e-002*sin(t)),  6.516e-002 +2.000*(-4.113e-002* 3.667e-002*cos(t)+ 9.992e-001* 2.147e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.206e-001, 4.867e-002 center
replot  2.206e-001+ 2.000*( 9.998e-001* 6.070e-002*cos(t)+ 2.051e-002* 1.969e-002*sin(t)),  4.867e-002 +2.000*(-2.051e-002* 6.070e-002*cos(t)+ 9.998e-001* 1.969e-002*sin(t)) not
set out;
set out "PLMsr/VARPIJGR_PLMsr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "PLMsr/VARMUPTJGR--STABLBASED_PLMsr1.svg";
 plot "PLMsr/PRMORPREV-1-STABLBASED_PLMsr.txt"  u 1:($3) not w l lt 1 
 replot "PLMsr/PRMORPREV-1-STABLBASED_PLMsr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "PLMsr/PRMORPREV-1-STABLBASED_PLMsr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "PLMsr/VARMUPTJGR--STABLBASED_PLMsr1.svg";replot;set out;
