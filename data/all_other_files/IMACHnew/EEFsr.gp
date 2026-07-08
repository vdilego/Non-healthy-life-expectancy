
# IMaCh-0.99r45
# EEFsr.gp
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


set ter svg size 640, 480;set out "EEFsr/D_EEFsr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "EEFsr/ILK_EEFsr-dest.png";
set log y;plot  "EEFsr/ILK_EEFsr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "EEFsr/ILK_EEFsr-ori.png";
set log y;plot  "EEFsr/ILK_EEFsr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "EEFsr/ILK_EEFsr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "EEFsr/ILK_EEFsr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "EEFsr/ILK_EEFsr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "EEFsr/ILK_EEFsr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "EEFsr/V_EEFsr_1-1-1.svg" 

#set out "V_EEFsr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "EEFsr/VPL_EEFsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"EEFsr/VPL_EEFsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"EEFsr/VPL_EEFsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"EEFsr/P_EEFsr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "EEFsr/V_EEFsr_2-1-1.svg" 

#set out "V_EEFsr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "EEFsr/VPL_EEFsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"EEFsr/VPL_EEFsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"EEFsr/VPL_EEFsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"EEFsr/P_EEFsr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "EEFsr/E_EEFsr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "EEFsr/T_EEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"EEFsr/T_EEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"EEFsr/T_EEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"EEFsr/T_EEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"EEFsr/T_EEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"EEFsr/T_EEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"EEFsr/T_EEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"EEFsr/T_EEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"EEFsr/T_EEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "EEFsr/E_EEFsr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "EEFsr/EXP_EEFsr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "EEFsr/E_EEFsr.txt" every :::0::0 u 1:2 t "e11" w l ,"EEFsr/E_EEFsr.txt" every :::0::0 u 1:3 t "e12" w l ,"EEFsr/E_EEFsr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "EEFsr/EXP_EEFsr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "EEFsr/E_EEFsr.txt" every :::0::0 u 1:5 t "e21" w l ,"EEFsr/E_EEFsr.txt" every :::0::0 u 1:6 t "e22" w l ,"EEFsr/E_EEFsr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "EEFsr/LIJ_EEFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFsr/PIJ_EEFsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "EEFsr/LIJ_EEFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFsr/PIJ_EEFsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "EEFsr/LIJT_EEFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFsr/PIJ_EEFsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "EEFsr/LIJT_EEFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFsr/PIJ_EEFsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "EEFsr/P_EEFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFsr/PIJ_EEFsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "EEFsr/P_EEFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFsr/PIJ_EEFsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-3.763832; p2=0.029161; 
#   current state 3
p3=-13.276038; p4=0.118547; 
# initial state 2
#   current state 1
p5=-0.267012; p6=-0.042099; 
#   current state 3
p7=-11.707500; p8=0.103900; 
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

set out "EEFsr/PE_EEFsr_1-1-1.svg" 
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

set out "EEFsr/PE_EEFsr_1-2-1.svg" 
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

set out "EEFsr/PE_EEFsr_1-3-1.svg" 
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
set out "EEFsr/VARPIJGR_EEFsr_113-12.svg"
set label "50" at  1.170e-003, 1.812e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  1.170e-003+ 2.000*( 4.784e-003* 2.066e-002*cos(t)+ 1.000e+000* 1.226e-003*sin(t)),  1.812e-001 +2.000*(-1.000e+000* 2.066e-002*cos(t)+ 4.784e-003* 1.226e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  2.085e-003, 2.066e-001 center
replot  2.085e-003+ 2.000*( 8.006e-003* 1.783e-002*cos(t)+ 1.000e+000* 1.801e-003*sin(t)),  2.066e-001 +2.000*(-1.000e+000* 1.783e-002*cos(t)+ 8.006e-003* 1.801e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  3.708e-003, 2.350e-001 center
replot  3.708e-003+ 2.000*( 1.292e-002* 1.539e-002*cos(t)+ 9.999e-001* 2.554e-003*sin(t)),  2.350e-001 +2.000*(-9.999e-001* 1.539e-002*cos(t)+ 1.292e-002* 2.554e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  6.577e-003, 2.666e-001 center
replot  6.577e-003+ 2.000*( 1.800e-002* 1.540e-002*cos(t)+ 9.998e-001* 3.490e-003*sin(t)),  2.666e-001 +2.000*(-9.998e-001* 1.540e-002*cos(t)+ 1.800e-002* 3.490e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.162e-002, 3.013e-001 center
replot  1.162e-002+ 2.000*( 2.456e-002* 1.996e-002*cos(t)+ 9.997e-001* 4.765e-003*sin(t)),  3.013e-001 +2.000*(-9.997e-001* 1.996e-002*cos(t)+ 2.456e-002* 4.765e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.045e-002, 3.390e-001 center
replot  2.045e-002+ 2.000*( 4.259e-002* 2.881e-002*cos(t)+ 9.991e-001* 7.445e-003*sin(t)),  3.390e-001 +2.000*(-9.991e-001* 2.881e-002*cos(t)+ 4.259e-002* 7.445e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.574e-002, 3.790e-001 center
replot  3.574e-002+ 2.000*( 9.077e-002* 4.101e-002*cos(t)+ 9.959e-001* 1.475e-002*sin(t)),  3.790e-001 +2.000*(-9.959e-001* 4.101e-002*cos(t)+ 9.077e-002* 1.475e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  6.191e-002, 4.199e-001 center
replot  6.191e-002+ 2.000*( 2.445e-001* 5.696e-002*cos(t)+ 9.696e-001* 3.163e-002*sin(t)),  4.199e-001 +2.000*(-9.696e-001* 5.696e-002*cos(t)+ 2.445e-001* 3.163e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.059e-001, 4.592e-001 center
replot  1.059e-001+ 2.000*( 6.895e-001* 8.646e-002*cos(t)+ 7.243e-001* 5.735e-002*sin(t)),  4.592e-001 +2.000*(-7.243e-001* 8.646e-002*cos(t)+ 6.895e-001* 5.735e-002*sin(t)) not
set out;
set out "EEFsr/VARPIJGR_EEFsr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "EEFsr/VARPIJGR_EEFsr_121-12.svg"
set label "50" at  1.704e-001, 1.812e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  1.704e-001+ 2.000*( 8.296e-001* 2.456e-002*cos(t)+-5.583e-001* 1.863e-002*sin(t)),  1.812e-001 +2.000*( 5.583e-001* 2.456e-002*cos(t)+ 8.296e-001* 1.863e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  1.402e-001, 2.066e-001 center
replot  1.402e-001+ 2.000*( 4.605e-001* 1.877e-002*cos(t)+-8.877e-001* 1.379e-002*sin(t)),  2.066e-001 +2.000*( 8.877e-001* 1.877e-002*cos(t)+ 4.605e-001* 1.379e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  1.150e-001, 2.350e-001 center
replot  1.150e-001+ 2.000*( 2.319e-001* 1.567e-002*cos(t)+-9.728e-001* 9.156e-003*sin(t)),  2.350e-001 +2.000*( 9.728e-001* 1.567e-002*cos(t)+ 2.319e-001* 9.156e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  9.391e-002, 2.666e-001 center
replot  9.391e-002+ 2.000*( 1.316e-001* 1.550e-002*cos(t)+-9.913e-001* 6.391e-003*sin(t)),  2.666e-001 +2.000*( 9.913e-001* 1.550e-002*cos(t)+ 1.316e-001* 6.391e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  7.641e-002, 3.013e-001 center
replot  7.641e-002+ 2.000*( 8.405e-002* 2.002e-002*cos(t)+-9.965e-001* 5.539e-003*sin(t)),  3.013e-001 +2.000*( 9.965e-001* 2.002e-002*cos(t)+ 8.405e-002* 5.539e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  6.188e-002, 3.390e-001 center
replot  6.188e-002+ 2.000*( 5.858e-002* 2.884e-002*cos(t)+-9.983e-001* 5.694e-003*sin(t)),  3.390e-001 +2.000*( 9.983e-001* 2.884e-002*cos(t)+ 5.858e-002* 5.694e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  4.979e-002, 3.790e-001 center
replot  4.979e-002+ 2.000*( 4.162e-002* 4.090e-002*cos(t)+-9.991e-001* 5.980e-003*sin(t)),  3.790e-001 +2.000*( 9.991e-001* 4.090e-002*cos(t)+ 4.162e-002* 5.980e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  3.967e-002, 4.199e-001 center
replot  3.967e-002+ 2.000*( 2.892e-002* 5.580e-002*cos(t)+-9.996e-001* 6.059e-003*sin(t)),  4.199e-001 +2.000*( 9.996e-001* 5.580e-002*cos(t)+ 2.892e-002* 6.059e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  3.115e-002, 4.592e-001 center
replot  3.115e-002+ 2.000*( 1.866e-002* 7.408e-002*cos(t)+-9.998e-001* 5.873e-003*sin(t)),  4.592e-001 +2.000*( 9.998e-001* 7.408e-002*cos(t)+ 1.866e-002* 5.873e-003*sin(t)) not
set out;
set out "EEFsr/VARPIJGR_EEFsr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "EEFsr/VARPIJGR_EEFsr_123-12.svg"
set label "50" at  2.712e-003, 1.812e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  2.712e-003+ 2.000*( 1.805e-003* 2.066e-002*cos(t)+-1.000e+000* 9.794e-004*sin(t)),  1.812e-001 +2.000*( 1.000e+000* 2.066e-002*cos(t)+ 1.805e-003* 9.794e-004*sin(t)) not
# Age 55, p23 - p12
set label "55" at  4.631e-003, 2.066e-001 center
replot  4.631e-003+ 2.000*( 3.203e-003* 1.783e-002*cos(t)+-1.000e+000* 1.411e-003*sin(t)),  2.066e-001 +2.000*( 1.000e+000* 1.783e-002*cos(t)+ 3.203e-003* 1.411e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  7.878e-003, 2.350e-001 center
replot  7.878e-003+ 2.000*( 5.240e-003* 1.539e-002*cos(t)+-1.000e+000* 1.964e-003*sin(t)),  2.350e-001 +2.000*( 1.000e+000* 1.539e-002*cos(t)+ 5.240e-003* 1.964e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.335e-002, 2.666e-001 center
replot  1.335e-002+ 2.000*( 6.059e-003* 1.539e-002*cos(t)+-1.000e+000* 2.612e-003*sin(t)),  2.666e-001 +2.000*( 1.000e+000* 1.539e-002*cos(t)+ 6.059e-003* 2.612e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  2.255e-002, 3.013e-001 center
replot  2.255e-002+ 2.000*( 4.683e-003* 1.995e-002*cos(t)+-1.000e+000* 3.283e-003*sin(t)),  3.013e-001 +2.000*( 1.000e+000* 1.995e-002*cos(t)+ 4.683e-003* 3.283e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  3.789e-002, 3.390e-001 center
replot  3.789e-002+ 2.000*( 4.713e-003* 2.879e-002*cos(t)+-1.000e+000* 3.950e-003*sin(t)),  3.390e-001 +2.000*( 1.000e+000* 2.879e-002*cos(t)+ 4.713e-003* 3.950e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  6.326e-002, 3.790e-001 center
replot  6.326e-002+ 2.000*( 7.775e-003* 4.087e-002*cos(t)+-1.000e+000* 5.350e-003*sin(t)),  3.790e-001 +2.000*( 1.000e+000* 4.087e-002*cos(t)+ 7.775e-003* 5.350e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.046e-001, 4.199e-001 center
replot  1.046e-001+ 2.000*( 1.632e-002* 5.578e-002*cos(t)+-9.999e-001* 1.023e-002*sin(t)),  4.199e-001 +2.000*( 9.999e-001* 5.578e-002*cos(t)+ 1.632e-002* 1.023e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.704e-001, 4.592e-001 center
replot  1.704e-001+ 2.000*( 3.794e-002* 7.411e-002*cos(t)+-9.993e-001* 2.219e-002*sin(t)),  4.592e-001 +2.000*( 9.993e-001* 7.411e-002*cos(t)+ 3.794e-002* 2.219e-002*sin(t)) not
set out;
set out "EEFsr/VARPIJGR_EEFsr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "EEFsr/VARPIJGR_EEFsr_121-13.svg"
set label "50" at  1.704e-001, 1.170e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  1.704e-001+ 2.000*( 1.000e+000* 2.288e-002*cos(t)+-3.985e-003* 1.226e-003*sin(t)),  1.170e-003 +2.000*( 3.985e-003* 2.288e-002*cos(t)+ 1.000e+000* 1.226e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  1.402e-001, 2.085e-003 center
replot  1.402e-001+ 2.000*( 1.000e+000* 1.499e-002*cos(t)+-8.403e-003* 1.803e-003*sin(t)),  2.085e-003 +2.000*( 8.403e-003* 1.499e-002*cos(t)+ 1.000e+000* 1.803e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  1.150e-001, 3.708e-003 center
replot  1.150e-001+ 2.000*( 9.998e-001* 9.620e-003*cos(t)+-1.750e-002* 2.556e-003*sin(t)),  3.708e-003 +2.000*( 1.750e-002* 9.620e-003*cos(t)+ 9.998e-001* 2.556e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  9.391e-002, 6.577e-003 center
replot  9.391e-002+ 2.000*( 9.993e-001* 6.660e-003*cos(t)+-3.796e-002* 3.494e-003*sin(t)),  6.577e-003 +2.000*( 3.796e-002* 6.660e-003*cos(t)+ 9.993e-001* 3.494e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  7.641e-002, 1.162e-002 center
replot  7.641e-002+ 2.000*( 9.899e-001* 5.789e-003*cos(t)+-1.421e-001* 4.766e-003*sin(t)),  1.162e-002 +2.000*( 1.421e-001* 5.789e-003*cos(t)+ 9.899e-001* 4.766e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  6.188e-002, 2.045e-002 center
replot  6.188e-002+ 2.000*( 1.542e-001* 7.575e-003*cos(t)+-9.880e-001* 5.884e-003*sin(t)),  2.045e-002 +2.000*( 9.880e-001* 7.575e-003*cos(t)+ 1.542e-001* 5.884e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  4.979e-002, 3.574e-002 center
replot  4.979e-002+ 2.000*( 4.742e-002* 1.517e-002*cos(t)+-9.989e-001* 6.178e-003*sin(t)),  3.574e-002 +2.000*( 9.989e-001* 1.517e-002*cos(t)+ 4.742e-002* 6.178e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  3.967e-002, 6.191e-002 center
replot  3.967e-002+ 2.000*( 2.014e-002* 3.369e-002*cos(t)+-9.998e-001* 6.232e-003*sin(t)),  6.191e-002 +2.000*( 9.998e-001* 3.369e-002*cos(t)+ 2.014e-002* 6.232e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  3.115e-002, 1.059e-001 center
replot  3.115e-002+ 2.000*( 9.305e-003* 7.266e-002*cos(t)+-1.000e+000* 5.995e-003*sin(t)),  1.059e-001 +2.000*( 1.000e+000* 7.266e-002*cos(t)+ 9.305e-003* 5.995e-003*sin(t)) not
set out;
set out "EEFsr/VARPIJGR_EEFsr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "EEFsr/VARPIJGR_EEFsr_123-13.svg"
set label "50" at  2.712e-003, 1.170e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  2.712e-003+ 2.000*( 4.723e-001* 1.317e-003*cos(t)+ 8.814e-001* 8.595e-004*sin(t)),  1.170e-003 +2.000*(-8.814e-001* 1.317e-003*cos(t)+ 4.723e-001* 8.595e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  4.631e-003, 2.085e-003 center
replot  4.631e-003+ 2.000*( 4.549e-001* 1.927e-003*cos(t)+ 8.906e-001* 1.243e-003*sin(t)),  2.085e-003 +2.000*(-8.906e-001* 1.927e-003*cos(t)+ 4.549e-001* 1.243e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  7.878e-003, 3.708e-003 center
replot  7.878e-003+ 2.000*( 4.382e-001* 2.721e-003*cos(t)+ 8.989e-001* 1.738e-003*sin(t)),  3.708e-003 +2.000*(-8.989e-001* 2.721e-003*cos(t)+ 4.382e-001* 1.738e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.335e-002, 6.577e-003 center
replot  1.335e-002+ 2.000*( 4.096e-001* 3.691e-003*cos(t)+ 9.123e-001* 2.338e-003*sin(t)),  6.577e-003 +2.000*(-9.123e-001* 3.691e-003*cos(t)+ 4.096e-001* 2.338e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  2.255e-002, 1.162e-002 center
replot  2.255e-002+ 2.000*( 3.232e-001* 4.954e-003*cos(t)+ 9.463e-001* 3.030e-003*sin(t)),  1.162e-002 +2.000*(-9.463e-001* 4.954e-003*cos(t)+ 3.232e-001* 3.030e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  3.789e-002, 2.045e-002 center
replot  3.789e-002+ 2.000*( 1.561e-001* 7.608e-003*cos(t)+ 9.877e-001* 3.817e-003*sin(t)),  2.045e-002 +2.000*(-9.877e-001* 7.608e-003*cos(t)+ 1.561e-001* 3.817e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  6.326e-002, 3.574e-002 center
replot  6.326e-002+ 2.000*( 7.413e-002* 1.520e-002*cos(t)+ 9.972e-001* 5.254e-003*sin(t)),  3.574e-002 +2.000*(-9.972e-001* 1.520e-002*cos(t)+ 7.413e-002* 5.254e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.046e-001, 6.191e-002 center
replot  1.046e-001+ 2.000*( 7.205e-002* 3.376e-002*cos(t)+ 9.974e-001* 1.000e-002*sin(t)),  6.191e-002 +2.000*(-9.974e-001* 3.376e-002*cos(t)+ 7.205e-002* 1.000e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.704e-001, 1.059e-001 center
replot  1.704e-001+ 2.000*( 8.289e-002* 7.289e-002*cos(t)+ 9.966e-001* 2.159e-002*sin(t)),  1.059e-001 +2.000*(-9.966e-001* 7.289e-002*cos(t)+ 8.289e-002* 2.159e-002*sin(t)) not
set out;
set out "EEFsr/VARPIJGR_EEFsr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "EEFsr/VARPIJGR_EEFsr_123-21.svg"
set label "50" at  2.712e-003, 1.704e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  2.712e-003+ 2.000*( 2.602e-003* 2.288e-002*cos(t)+ 1.000e+000* 9.783e-004*sin(t)),  1.704e-001 +2.000*(-1.000e+000* 2.288e-002*cos(t)+ 2.602e-003* 9.783e-004*sin(t)) not
# Age 55, p23 - p21
set label "55" at  4.631e-003, 1.402e-001 center
replot  4.631e-003+ 2.000*( 5.141e-003* 1.499e-002*cos(t)+ 1.000e+000* 1.410e-003*sin(t)),  1.402e-001 +2.000*(-1.000e+000* 1.499e-002*cos(t)+ 5.141e-003* 1.410e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  7.878e-003, 1.150e-001 center
replot  7.878e-003+ 2.000*( 1.054e-002* 9.619e-003*cos(t)+ 9.999e-001* 1.963e-003*sin(t)),  1.150e-001 +2.000*(-9.999e-001* 9.619e-003*cos(t)+ 1.054e-002* 1.963e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.335e-002, 9.391e-002 center
replot  1.335e-002+ 2.000*( 2.064e-002* 6.657e-003*cos(t)+ 9.998e-001* 2.611e-003*sin(t)),  9.391e-002 +2.000*(-9.998e-001* 6.657e-003*cos(t)+ 2.064e-002* 2.611e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  2.255e-002, 7.641e-002 center
replot  2.255e-002+ 2.000*( 3.187e-002* 5.772e-003*cos(t)+ 9.995e-001* 3.280e-003*sin(t)),  7.641e-002 +2.000*(-9.995e-001* 5.772e-003*cos(t)+ 3.187e-002* 3.280e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  3.789e-002, 6.188e-002 center
replot  3.789e-002+ 2.000*( 4.490e-002* 5.933e-003*cos(t)+ 9.990e-001* 3.947e-003*sin(t)),  6.188e-002 +2.000*(-9.990e-001* 5.933e-003*cos(t)+ 4.490e-002* 3.947e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  6.326e-002, 4.979e-002 center
replot  6.326e-002+ 2.000*( 1.580e-001* 6.234e-003*cos(t)+ 9.874e-001* 5.335e-003*sin(t)),  4.979e-002 +2.000*(-9.874e-001* 6.234e-003*cos(t)+ 1.580e-001* 5.335e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.046e-001, 3.967e-002 center
replot  1.046e-001+ 2.000*( 9.980e-001* 1.028e-002*cos(t)+ 6.339e-002* 6.247e-003*sin(t)),  3.967e-002 +2.000*(-6.339e-002* 1.028e-002*cos(t)+ 9.980e-001* 6.247e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.704e-001, 3.115e-002 center
replot  1.704e-001+ 2.000*( 9.996e-001* 2.236e-002*cos(t)+ 2.690e-002* 6.005e-003*sin(t)),  3.115e-002 +2.000*(-2.690e-002* 2.236e-002*cos(t)+ 9.996e-001* 6.005e-003*sin(t)) not
set out;
set out "EEFsr/VARPIJGR_EEFsr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "EEFsr/VARMUPTJGR--STABLBASED_EEFsr1.svg";
 plot "EEFsr/PRMORPREV-1-STABLBASED_EEFsr.txt"  u 1:($3) not w l lt 1 
 replot "EEFsr/PRMORPREV-1-STABLBASED_EEFsr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "EEFsr/PRMORPREV-1-STABLBASED_EEFsr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "EEFsr/VARMUPTJGR--STABLBASED_EEFsr1.svg";replot;set out;
