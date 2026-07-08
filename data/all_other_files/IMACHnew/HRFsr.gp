
# IMaCh-0.99r45
# HRFsr.gp
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


set ter svg size 640, 480;set out "HRFsr/D_HRFsr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "HRFsr/ILK_HRFsr-dest.png";
set log y;plot  "HRFsr/ILK_HRFsr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "HRFsr/ILK_HRFsr-ori.png";
set log y;plot  "HRFsr/ILK_HRFsr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "HRFsr/ILK_HRFsr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "HRFsr/ILK_HRFsr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "HRFsr/ILK_HRFsr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "HRFsr/ILK_HRFsr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "HRFsr/V_HRFsr_1-1-1.svg" 

#set out "V_HRFsr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "HRFsr/VPL_HRFsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"HRFsr/VPL_HRFsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"HRFsr/VPL_HRFsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"HRFsr/P_HRFsr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "HRFsr/V_HRFsr_2-1-1.svg" 

#set out "V_HRFsr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "HRFsr/VPL_HRFsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"HRFsr/VPL_HRFsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"HRFsr/VPL_HRFsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"HRFsr/P_HRFsr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "HRFsr/E_HRFsr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "HRFsr/T_HRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"HRFsr/T_HRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"HRFsr/T_HRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"HRFsr/T_HRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"HRFsr/T_HRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"HRFsr/T_HRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"HRFsr/T_HRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"HRFsr/T_HRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"HRFsr/T_HRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "HRFsr/E_HRFsr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "HRFsr/EXP_HRFsr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "HRFsr/E_HRFsr.txt" every :::0::0 u 1:2 t "e11" w l ,"HRFsr/E_HRFsr.txt" every :::0::0 u 1:3 t "e12" w l ,"HRFsr/E_HRFsr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "HRFsr/EXP_HRFsr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "HRFsr/E_HRFsr.txt" every :::0::0 u 1:5 t "e21" w l ,"HRFsr/E_HRFsr.txt" every :::0::0 u 1:6 t "e22" w l ,"HRFsr/E_HRFsr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "HRFsr/LIJ_HRFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFsr/PIJ_HRFsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "HRFsr/LIJ_HRFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFsr/PIJ_HRFsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "HRFsr/LIJT_HRFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFsr/PIJ_HRFsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "HRFsr/LIJT_HRFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFsr/PIJ_HRFsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "HRFsr/P_HRFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFsr/PIJ_HRFsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "HRFsr/P_HRFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFsr/PIJ_HRFsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-4.482800; p2=0.038090; 
#   current state 3
p3=-19.642258; p4=0.210288; 
# initial state 2
#   current state 1
p5=-0.975392; p6=-0.014571; 
#   current state 3
p7=-11.468519; p8=0.109091; 
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

set out "HRFsr/PE_HRFsr_1-1-1.svg" 
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

set out "HRFsr/PE_HRFsr_1-2-1.svg" 
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

set out "HRFsr/PE_HRFsr_1-3-1.svg" 
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
set out "HRFsr/VARPIJGR_HRFsr_113-12.svg"
set label "50" at  2.019e-004, 1.411e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  2.019e-004+ 2.000*( 1.381e-005* 2.641e-002*cos(t)+ 1.000e+000* 2.958e-004*sin(t)),  1.411e-001 +2.000*(-1.000e+000* 2.641e-002*cos(t)+ 1.381e-005* 2.958e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  5.691e-004, 1.682e-001 center
replot  5.691e-004+ 2.000*( 7.551e-004* 2.403e-002*cos(t)+ 1.000e+000* 7.059e-004*sin(t)),  1.682e-001 +2.000*(-1.000e+000* 2.403e-002*cos(t)+ 7.551e-004* 7.059e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.600e-003, 1.998e-001 center
replot  1.600e-003+ 2.000*( 4.958e-003* 2.129e-002*cos(t)+ 1.000e+000* 1.625e-003*sin(t)),  1.998e-001 +2.000*(-1.000e+000* 2.129e-002*cos(t)+ 4.958e-003* 1.625e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  4.477e-003, 2.364e-001 center
replot  4.477e-003+ 2.000*( 2.088e-002* 2.038e-002*cos(t)+ 9.998e-001* 3.553e-003*sin(t)),  2.364e-001 +2.000*(-9.998e-001* 2.038e-002*cos(t)+ 2.088e-002* 3.553e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.245e-002, 2.780e-001 center
replot  1.245e-002+ 2.000*( 4.603e-002* 2.512e-002*cos(t)+ 9.989e-001* 7.244e-003*sin(t)),  2.780e-001 +2.000*(-9.989e-001* 2.512e-002*cos(t)+ 4.603e-002* 7.244e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  3.424e-002, 3.231e-001 center
replot  3.424e-002+ 2.000*( 6.084e-002* 3.668e-002*cos(t)+ 9.981e-001* 1.353e-002*sin(t)),  3.231e-001 +2.000*(-9.981e-001* 3.668e-002*cos(t)+ 6.084e-002* 1.353e-002*sin(t)) not
# Age 80, p13 - p12
set label "80" at  9.194e-002, 3.668e-001 center
replot  9.194e-002+ 2.000*( 7.927e-002* 5.291e-002*cos(t)+ 9.969e-001* 2.534e-002*sin(t)),  3.668e-001 +2.000*(-9.969e-001* 5.291e-002*cos(t)+ 7.927e-002* 2.534e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  2.341e-001, 3.948e-001 center
replot  2.341e-001+ 2.000*( 6.664e-001* 7.626e-002*cos(t)+ 7.456e-001* 6.180e-002*sin(t)),  3.948e-001 +2.000*(-7.456e-001* 7.626e-002*cos(t)+ 6.664e-001* 6.180e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  5.319e-001, 3.792e-001 center
replot  5.319e-001+ 2.000*( 9.593e-001* 1.982e-001*cos(t)+ 2.823e-001* 7.437e-002*sin(t)),  3.792e-001 +2.000*(-2.823e-001* 1.982e-001*cos(t)+ 9.593e-001* 7.437e-002*sin(t)) not
set out;
set out "HRFsr/VARPIJGR_HRFsr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "HRFsr/VARPIJGR_HRFsr_121-12.svg"
set label "50" at  3.073e-001, 1.411e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  3.073e-001+ 2.000*( 9.746e-001* 5.302e-002*cos(t)+-2.241e-001* 2.420e-002*sin(t)),  1.411e-001 +2.000*( 2.241e-001* 5.302e-002*cos(t)+ 9.746e-001* 2.420e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  2.884e-001, 1.682e-001 center
replot  2.884e-001+ 2.000*( 9.550e-001* 4.006e-002*cos(t)+-2.966e-001* 2.187e-002*sin(t)),  1.682e-001 +2.000*( 2.966e-001* 4.006e-002*cos(t)+ 9.550e-001* 2.187e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.701e-001, 1.998e-001 center
replot  2.701e-001+ 2.000*( 9.115e-001* 2.992e-002*cos(t)+-4.114e-001* 1.905e-002*sin(t)),  1.998e-001 +2.000*( 4.114e-001* 2.992e-002*cos(t)+ 9.115e-001* 1.905e-002*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.524e-001, 2.364e-001 center
replot  2.524e-001+ 2.000*( 7.831e-001* 2.465e-002*cos(t)+-6.219e-001* 1.714e-002*sin(t)),  2.364e-001 +2.000*( 6.219e-001* 2.465e-002*cos(t)+ 7.831e-001* 1.714e-002*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.349e-001, 2.780e-001 center
replot  2.349e-001+ 2.000*( 5.459e-001* 2.761e-002*cos(t)+-8.378e-001* 1.781e-002*sin(t)),  2.780e-001 +2.000*( 8.378e-001* 2.761e-002*cos(t)+ 5.459e-001* 1.781e-002*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.172e-001, 3.231e-001 center
replot  2.172e-001+ 2.000*( 3.835e-001* 3.866e-002*cos(t)+-9.235e-001* 2.129e-002*sin(t)),  3.231e-001 +2.000*( 9.235e-001* 3.866e-002*cos(t)+ 3.835e-001* 2.129e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.989e-001, 3.668e-001 center
replot  1.989e-001+ 2.000*( 2.881e-001* 5.455e-002*cos(t)+-9.576e-001* 2.611e-002*sin(t)),  3.668e-001 +2.000*( 9.576e-001* 5.455e-002*cos(t)+ 2.881e-001* 2.611e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.791e-001, 3.948e-001 center
replot  1.791e-001+ 2.000*( 2.179e-001* 7.160e-002*cos(t)+-9.760e-001* 3.109e-002*sin(t)),  3.948e-001 +2.000*( 9.760e-001* 7.160e-002*cos(t)+ 2.179e-001* 3.109e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.571e-001, 3.792e-001 center
replot  1.571e-001+ 2.000*( 1.195e-001* 9.123e-002*cos(t)+-9.928e-001* 3.611e-002*sin(t)),  3.792e-001 +2.000*( 9.928e-001* 9.123e-002*cos(t)+ 1.195e-001* 3.611e-002*sin(t)) not
set out;
set out "HRFsr/VARPIJGR_HRFsr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "HRFsr/VARPIJGR_HRFsr_123-12.svg"
set label "50" at  4.128e-003, 1.411e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  4.128e-003+ 2.000*( 7.678e-004* 2.641e-002*cos(t)+-1.000e+000* 2.434e-003*sin(t)),  1.411e-001 +2.000*( 1.000e+000* 2.641e-002*cos(t)+ 7.678e-004* 2.434e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  7.188e-003, 1.682e-001 center
replot  7.188e-003+ 2.000*( 3.240e-003* 2.403e-002*cos(t)+-1.000e+000* 3.564e-003*sin(t)),  1.682e-001 +2.000*( 1.000e+000* 2.403e-002*cos(t)+ 3.240e-003* 3.564e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  1.250e-002, 1.998e-001 center
replot  1.250e-002+ 2.000*( 1.051e-002* 2.129e-002*cos(t)+-9.999e-001* 5.044e-003*sin(t)),  1.998e-001 +2.000*( 9.999e-001* 2.129e-002*cos(t)+ 1.051e-002* 5.044e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  2.167e-002, 2.364e-001 center
replot  2.167e-002+ 2.000*( 2.566e-002* 2.038e-002*cos(t)+-9.997e-001* 6.820e-003*sin(t)),  2.364e-001 +2.000*( 9.997e-001* 2.038e-002*cos(t)+ 2.566e-002* 6.820e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  3.743e-002, 2.780e-001 center
replot  3.743e-002+ 2.000*( 3.212e-002* 2.510e-002*cos(t)+-9.995e-001* 8.741e-003*sin(t)),  2.780e-001 +2.000*( 9.995e-001* 2.510e-002*cos(t)+ 3.212e-002* 8.741e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  6.423e-002, 3.231e-001 center
replot  6.423e-002+ 2.000*( 2.402e-002* 3.663e-002*cos(t)+-9.997e-001* 1.095e-002*sin(t)),  3.231e-001 +2.000*( 9.997e-001* 3.663e-002*cos(t)+ 2.402e-002* 1.095e-002*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.091e-001, 3.668e-001 center
replot  1.091e-001+ 2.000*( 1.768e-002* 5.279e-002*cos(t)+-9.998e-001* 1.598e-002*sin(t)),  3.668e-001 +2.000*( 9.998e-001* 5.279e-002*cos(t)+ 1.768e-002* 1.598e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.823e-001, 3.948e-001 center
replot  1.823e-001+ 2.000*( 3.585e-002* 7.024e-002*cos(t)+-9.994e-001* 3.123e-002*sin(t)),  3.948e-001 +2.000*( 9.994e-001* 7.024e-002*cos(t)+ 3.585e-002* 3.123e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.968e-001, 3.792e-001 center
replot  2.968e-001+ 2.000*( 2.193e-001* 9.184e-002*cos(t)+-9.756e-001* 6.331e-002*sin(t)),  3.792e-001 +2.000*( 9.756e-001* 9.184e-002*cos(t)+ 2.193e-001* 6.331e-002*sin(t)) not
set out;
set out "HRFsr/VARPIJGR_HRFsr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "HRFsr/VARPIJGR_HRFsr_121-13.svg"
set label "50" at  3.073e-001, 2.019e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  3.073e-001+ 2.000*( 1.000e+000* 5.195e-002*cos(t)+-3.512e-004* 2.953e-004*sin(t)),  2.019e-004 +2.000*( 3.512e-004* 5.195e-002*cos(t)+ 1.000e+000* 2.953e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  2.884e-001, 5.691e-004 center
replot  2.884e-001+ 2.000*( 1.000e+000* 3.880e-002*cos(t)+-9.652e-004* 7.051e-004*sin(t)),  5.691e-004 +2.000*( 9.652e-004* 3.880e-002*cos(t)+ 1.000e+000* 7.051e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.701e-001, 1.600e-003 center
replot  2.701e-001+ 2.000*( 1.000e+000* 2.837e-002*cos(t)+-2.402e-003* 1.627e-003*sin(t)),  1.600e-003 +2.000*( 2.402e-003* 2.837e-002*cos(t)+ 1.000e+000* 1.627e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.524e-001, 4.477e-003 center
replot  2.524e-001+ 2.000*( 1.000e+000* 2.205e-002*cos(t)+-4.920e-003* 3.576e-003*sin(t)),  4.477e-003 +2.000*( 4.920e-003* 2.205e-002*cos(t)+ 1.000e+000* 3.576e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.349e-001, 1.245e-002 center
replot  2.349e-001+ 2.000*( 9.999e-001* 2.121e-002*cos(t)+-1.154e-002* 7.325e-003*sin(t)),  1.245e-002 +2.000*( 1.154e-002* 2.121e-002*cos(t)+ 9.999e-001* 7.325e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.172e-001, 3.424e-002 center
replot  2.172e-001+ 2.000*( 9.987e-001* 2.465e-002*cos(t)+-5.053e-002* 1.364e-002*sin(t)),  3.424e-002 +2.000*( 5.053e-002* 2.465e-002*cos(t)+ 9.987e-001* 1.364e-002*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.989e-001, 9.194e-002 center
replot  1.989e-001+ 2.000*( 9.242e-001* 3.028e-002*cos(t)+-3.820e-001* 2.472e-002*sin(t)),  9.194e-002 +2.000*( 3.820e-001* 3.028e-002*cos(t)+ 9.242e-001* 2.472e-002*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.791e-001, 2.341e-001 center
replot  1.791e-001+ 2.000*( 1.235e-001* 6.900e-002*cos(t)+-9.923e-001* 3.329e-002*sin(t)),  2.341e-001 +2.000*( 9.923e-001* 6.900e-002*cos(t)+ 1.235e-001* 3.329e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.571e-001, 5.319e-001 center
replot  1.571e-001+ 2.000*( 3.936e-002* 1.914e-001*cos(t)+-9.992e-001* 3.673e-002*sin(t)),  5.319e-001 +2.000*( 9.992e-001* 1.914e-001*cos(t)+ 3.936e-002* 3.673e-002*sin(t)) not
set out;
set out "HRFsr/VARPIJGR_HRFsr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "HRFsr/VARPIJGR_HRFsr_123-13.svg"
set label "50" at  4.128e-003, 2.019e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  4.128e-003+ 2.000*( 9.989e-001* 2.437e-003*cos(t)+ 4.751e-002* 2.725e-004*sin(t)),  2.019e-004 +2.000*(-4.751e-002* 2.437e-003*cos(t)+ 9.989e-001* 2.725e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  7.188e-003, 5.691e-004 center
replot  7.188e-003+ 2.000*( 9.969e-001* 3.576e-003*cos(t)+ 7.922e-002* 6.488e-004*sin(t)),  5.691e-004 +2.000*(-7.922e-002* 3.576e-003*cos(t)+ 9.969e-001* 6.488e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  1.250e-002, 1.600e-003 center
replot  1.250e-002+ 2.000*( 9.907e-001* 5.093e-003*cos(t)+ 1.363e-001* 1.487e-003*sin(t)),  1.600e-003 +2.000*(-1.363e-001* 5.093e-003*cos(t)+ 9.907e-001* 1.487e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  2.167e-002, 4.477e-003 center
replot  2.167e-002+ 2.000*( 9.674e-001* 7.018e-003*cos(t)+ 2.534e-001* 3.209e-003*sin(t)),  4.477e-003 +2.000*(-2.534e-001* 7.018e-003*cos(t)+ 9.674e-001* 3.209e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  3.743e-002, 1.245e-002 center
replot  3.743e-002+ 2.000*( 8.438e-001* 9.633e-003*cos(t)+ 5.367e-001* 6.156e-003*sin(t)),  1.245e-002 +2.000*(-5.367e-001* 9.633e-003*cos(t)+ 8.438e-001* 6.156e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  6.423e-002, 3.424e-002 center
replot  6.423e-002+ 2.000*( 4.897e-001* 1.477e-002*cos(t)+ 8.719e-001* 9.477e-003*sin(t)),  3.424e-002 +2.000*(-8.719e-001* 1.477e-002*cos(t)+ 4.897e-001* 9.477e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.091e-001, 9.194e-002 center
replot  1.091e-001+ 2.000*( 2.803e-001* 2.632e-002*cos(t)+ 9.599e-001* 1.480e-002*sin(t)),  9.194e-002 +2.000*(-9.599e-001* 2.632e-002*cos(t)+ 2.803e-001* 1.480e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.823e-001, 2.341e-001 center
replot  1.823e-001+ 2.000*( 1.624e-001* 6.935e-002*cos(t)+ 9.867e-001* 2.961e-002*sin(t)),  2.341e-001 +2.000*(-9.867e-001* 6.935e-002*cos(t)+ 1.624e-001* 2.961e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.968e-001, 5.319e-001 center
replot  2.968e-001+ 2.000*( 1.166e-001* 1.925e-001*cos(t)+ 9.932e-001* 6.139e-002*sin(t)),  5.319e-001 +2.000*(-9.932e-001* 1.925e-001*cos(t)+ 1.166e-001* 6.139e-002*sin(t)) not
set out;
set out "HRFsr/VARPIJGR_HRFsr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "HRFsr/VARPIJGR_HRFsr_123-21.svg"
set label "50" at  4.128e-003, 3.073e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  4.128e-003+ 2.000*( 2.878e-003* 5.195e-002*cos(t)+ 1.000e+000* 2.429e-003*sin(t)),  3.073e-001 +2.000*(-1.000e+000* 5.195e-002*cos(t)+ 2.878e-003* 2.429e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  7.188e-003, 2.884e-001 center
replot  7.188e-003+ 2.000*( 4.862e-003* 3.880e-002*cos(t)+ 1.000e+000* 3.560e-003*sin(t)),  2.884e-001 +2.000*(-1.000e+000* 3.880e-002*cos(t)+ 4.862e-003* 3.560e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  1.250e-002, 2.701e-001 center
replot  1.250e-002+ 2.000*( 8.276e-003* 2.837e-002*cos(t)+ 1.000e+000* 5.044e-003*sin(t)),  2.701e-001 +2.000*(-1.000e+000* 2.837e-002*cos(t)+ 8.276e-003* 5.044e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  2.167e-002, 2.524e-001 center
replot  2.167e-002+ 2.000*( 1.490e-002* 2.205e-002*cos(t)+ 9.999e-001* 6.831e-003*sin(t)),  2.524e-001 +2.000*(-9.999e-001* 2.205e-002*cos(t)+ 1.490e-002* 6.831e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  3.743e-002, 2.349e-001 center
replot  3.743e-002+ 2.000*( 2.896e-002* 2.122e-002*cos(t)+ 9.996e-001* 8.756e-003*sin(t)),  2.349e-001 +2.000*(-9.996e-001* 2.122e-002*cos(t)+ 2.896e-002* 8.756e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  6.423e-002, 2.172e-001 center
replot  6.423e-002+ 2.000*( 5.635e-002* 2.466e-002*cos(t)+ 9.984e-001* 1.091e-002*sin(t)),  2.172e-001 +2.000*(-9.984e-001* 2.466e-002*cos(t)+ 5.635e-002* 1.091e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.091e-001, 1.989e-001 center
replot  1.091e-001+ 2.000*( 1.266e-001* 2.970e-002*cos(t)+ 9.920e-001* 1.569e-002*sin(t)),  1.989e-001 +2.000*(-9.920e-001* 2.970e-002*cos(t)+ 1.266e-001* 1.569e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.823e-001, 1.791e-001 center
replot  1.823e-001+ 2.000*( 5.656e-001* 3.642e-002*cos(t)+ 8.247e-001* 2.860e-002*sin(t)),  1.791e-001 +2.000*(-8.247e-001* 3.642e-002*cos(t)+ 5.656e-001* 2.860e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.968e-001, 1.571e-001 center
replot  2.968e-001+ 2.000*( 9.745e-001* 6.617e-002*cos(t)+ 2.245e-001* 3.530e-002*sin(t)),  1.571e-001 +2.000*(-2.245e-001* 6.617e-002*cos(t)+ 9.745e-001* 3.530e-002*sin(t)) not
set out;
set out "HRFsr/VARPIJGR_HRFsr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "HRFsr/VARMUPTJGR--STABLBASED_HRFsr1.svg";
 plot "HRFsr/PRMORPREV-1-STABLBASED_HRFsr.txt"  u 1:($3) not w l lt 1 
 replot "HRFsr/PRMORPREV-1-STABLBASED_HRFsr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "HRFsr/PRMORPREV-1-STABLBASED_HRFsr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "HRFsr/VARMUPTJGR--STABLBASED_HRFsr1.svg";replot;set out;
