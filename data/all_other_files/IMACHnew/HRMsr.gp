
# IMaCh-0.99r45
# HRMsr.gp
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


set ter svg size 640, 480;set out "HRMsr/D_HRMsr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "HRMsr/ILK_HRMsr-dest.png";
set log y;plot  "HRMsr/ILK_HRMsr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "HRMsr/ILK_HRMsr-ori.png";
set log y;plot  "HRMsr/ILK_HRMsr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "HRMsr/ILK_HRMsr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "HRMsr/ILK_HRMsr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "HRMsr/ILK_HRMsr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "HRMsr/ILK_HRMsr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "HRMsr/V_HRMsr_1-1-1.svg" 

#set out "V_HRMsr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "HRMsr/VPL_HRMsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"HRMsr/VPL_HRMsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"HRMsr/VPL_HRMsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"HRMsr/P_HRMsr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "HRMsr/V_HRMsr_2-1-1.svg" 

#set out "V_HRMsr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "HRMsr/VPL_HRMsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"HRMsr/VPL_HRMsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"HRMsr/VPL_HRMsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"HRMsr/P_HRMsr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "HRMsr/E_HRMsr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "HRMsr/T_HRMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"HRMsr/T_HRMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"HRMsr/T_HRMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"HRMsr/T_HRMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"HRMsr/T_HRMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"HRMsr/T_HRMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"HRMsr/T_HRMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"HRMsr/T_HRMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"HRMsr/T_HRMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "HRMsr/E_HRMsr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "HRMsr/EXP_HRMsr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "HRMsr/E_HRMsr.txt" every :::0::0 u 1:2 t "e11" w l ,"HRMsr/E_HRMsr.txt" every :::0::0 u 1:3 t "e12" w l ,"HRMsr/E_HRMsr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "HRMsr/EXP_HRMsr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "HRMsr/E_HRMsr.txt" every :::0::0 u 1:5 t "e21" w l ,"HRMsr/E_HRMsr.txt" every :::0::0 u 1:6 t "e22" w l ,"HRMsr/E_HRMsr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "HRMsr/LIJ_HRMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMsr/PIJ_HRMsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "HRMsr/LIJ_HRMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMsr/PIJ_HRMsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "HRMsr/LIJT_HRMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMsr/PIJ_HRMsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "HRMsr/LIJT_HRMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMsr/PIJ_HRMsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "HRMsr/P_HRMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMsr/PIJ_HRMsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "HRMsr/P_HRMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMsr/PIJ_HRMsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-5.517838; p2=0.052621; 
#   current state 3
p3=-12.436731; p4=0.117173; 
# initial state 2
#   current state 1
p5=-3.337777; p6=0.022773; 
#   current state 3
p7=-9.502748; p8=0.090996; 
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

set out "HRMsr/PE_HRMsr_1-1-1.svg" 
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

set out "HRMsr/PE_HRMsr_1-2-1.svg" 
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

set out "HRMsr/PE_HRMsr_1-3-1.svg" 
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
set out "HRMsr/VARPIJGR_HRMsr_113-12.svg"
set label "50" at  2.631e-003, 1.055e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  2.631e-003+ 2.000*( 7.632e-003* 2.062e-002*cos(t)+ 1.000e+000* 2.165e-003*sin(t)),  1.055e-001 +2.000*(-1.000e+000* 2.062e-002*cos(t)+ 7.632e-003* 2.165e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  4.648e-003, 1.349e-001 center
replot  4.648e-003+ 2.000*( 1.203e-002* 1.992e-002*cos(t)+ 9.999e-001* 3.062e-003*sin(t)),  1.349e-001 +2.000*(-9.999e-001* 1.992e-002*cos(t)+ 1.203e-002* 3.062e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  8.168e-003, 1.717e-001 center
replot  8.168e-003+ 2.000*( 1.887e-002* 1.895e-002*cos(t)+ 9.998e-001* 4.143e-003*sin(t)),  1.717e-001 +2.000*(-9.998e-001* 1.895e-002*cos(t)+ 1.887e-002* 4.143e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.426e-002, 2.171e-001 center
replot  1.426e-002+ 2.000*( 2.644e-002* 2.042e-002*cos(t)+ 9.997e-001* 5.470e-003*sin(t)),  2.171e-001 +2.000*(-9.997e-001* 2.042e-002*cos(t)+ 2.644e-002* 5.470e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  2.467e-002, 2.720e-001 center
replot  2.467e-002+ 2.000*( 3.653e-002* 2.858e-002*cos(t)+ 9.993e-001* 7.907e-003*sin(t)),  2.720e-001 +2.000*(-9.993e-001* 2.858e-002*cos(t)+ 3.653e-002* 7.907e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  4.218e-002, 3.368e-001 center
replot  4.218e-002+ 2.000*( 6.515e-002* 4.488e-002*cos(t)+ 9.979e-001* 1.468e-002*sin(t)),  3.368e-001 +2.000*(-9.979e-001* 4.488e-002*cos(t)+ 6.515e-002* 1.468e-002*sin(t)) not
# Age 80, p13 - p12
set label "80" at  7.099e-002, 4.105e-001 center
replot  7.099e-002+ 2.000*( 1.424e-001* 6.896e-002*cos(t)+ 9.898e-001* 3.111e-002*sin(t)),  4.105e-001 +2.000*(-9.898e-001* 6.896e-002*cos(t)+ 1.424e-001* 3.111e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  1.170e-001, 4.899e-001 center
replot  1.170e-001+ 2.000*( 3.542e-001* 1.031e-001*cos(t)+ 9.352e-001* 6.167e-002*sin(t)),  4.899e-001 +2.000*(-9.352e-001* 1.031e-001*cos(t)+ 3.542e-001* 6.167e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.876e-001, 5.689e-001 center
replot  1.876e-001+ 2.000*( 6.863e-001* 1.640e-001*cos(t)+ 7.274e-001* 9.862e-002*sin(t)),  5.689e-001 +2.000*(-7.274e-001* 1.640e-001*cos(t)+ 6.863e-001* 9.862e-002*sin(t)) not
set out;
set out "HRMsr/VARPIJGR_HRMsr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "HRMsr/VARPIJGR_HRMsr_121-12.svg"
set label "50" at  1.984e-001, 1.055e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  1.984e-001+ 2.000*( 9.819e-001* 4.086e-002*cos(t)+-1.894e-001* 1.946e-002*sin(t)),  1.055e-001 +2.000*( 1.894e-001* 4.086e-002*cos(t)+ 9.819e-001* 1.946e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  2.189e-001, 1.349e-001 center
replot  2.189e-001+ 2.000*( 9.747e-001* 3.483e-002*cos(t)+-2.236e-001* 1.881e-002*sin(t)),  1.349e-001 +2.000*( 2.236e-001* 3.483e-002*cos(t)+ 9.747e-001* 1.881e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.408e-001, 1.717e-001 center
replot  2.408e-001+ 2.000*( 9.575e-001* 2.928e-002*cos(t)+-2.884e-001* 1.772e-002*sin(t)),  1.717e-001 +2.000*( 2.884e-001* 2.928e-002*cos(t)+ 9.575e-001* 1.772e-002*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.637e-001, 2.171e-001 center
replot  2.637e-001+ 2.000*( 8.867e-001* 2.761e-002*cos(t)+-4.623e-001* 1.797e-002*sin(t)),  2.171e-001 +2.000*( 4.623e-001* 2.761e-002*cos(t)+ 8.867e-001* 1.797e-002*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.870e-001, 2.720e-001 center
replot  2.870e-001+ 2.000*( 7.418e-001* 3.482e-002*cos(t)+-6.706e-001* 2.217e-002*sin(t)),  2.720e-001 +2.000*( 6.706e-001* 3.482e-002*cos(t)+ 7.418e-001* 2.217e-002*sin(t)) not
# Age 75, p21 - p12
set label "75" at  3.099e-001, 3.368e-001 center
replot  3.099e-001+ 2.000*( 6.213e-001* 5.130e-002*cos(t)+-7.836e-001* 3.183e-002*sin(t)),  3.368e-001 +2.000*( 7.836e-001* 5.130e-002*cos(t)+ 6.213e-001* 3.183e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  3.308e-001, 4.105e-001 center
replot  3.308e-001+ 2.000*( 5.188e-001* 7.494e-002*cos(t)+-8.549e-001* 4.619e-002*sin(t)),  4.105e-001 +2.000*( 8.549e-001* 7.494e-002*cos(t)+ 5.188e-001* 4.619e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  3.474e-001, 4.899e-001 center
replot  3.474e-001+ 2.000*( 4.138e-001* 1.046e-001*cos(t)+-9.104e-001* 6.423e-002*sin(t)),  4.899e-001 +2.000*( 9.104e-001* 1.046e-001*cos(t)+ 4.138e-001* 6.423e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  3.570e-001, 5.689e-001 center
replot  3.570e-001+ 2.000*( 2.872e-001* 1.409e-001*cos(t)+-9.579e-001* 8.550e-002*sin(t)),  5.689e-001 +2.000*( 9.579e-001* 1.409e-001*cos(t)+ 2.872e-001* 8.550e-002*sin(t)) not
set out;
set out "HRMsr/VARPIJGR_HRMsr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "HRMsr/VARPIJGR_HRMsr_123-12.svg"
set label "50" at  1.263e-002, 1.055e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  1.263e-002+ 2.000*( 2.089e-002* 2.062e-002*cos(t)+-9.998e-001* 5.729e-003*sin(t)),  1.055e-001 +2.000*( 9.998e-001* 2.062e-002*cos(t)+ 2.089e-002* 5.729e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.961e-002, 1.349e-001 center
replot  1.961e-002+ 2.000*( 2.481e-002* 1.992e-002*cos(t)+-9.997e-001* 7.263e-003*sin(t)),  1.349e-001 +2.000*( 9.997e-001* 1.992e-002*cos(t)+ 2.481e-002* 7.263e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.033e-002, 1.717e-001 center
replot  3.033e-002+ 2.000*( 2.815e-002* 1.895e-002*cos(t)+-9.996e-001* 8.855e-003*sin(t)),  1.717e-001 +2.000*( 9.996e-001* 1.895e-002*cos(t)+ 2.815e-002* 8.855e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  4.672e-002, 2.171e-001 center
replot  4.672e-002+ 2.000*( 2.954e-002* 2.042e-002*cos(t)+-9.996e-001* 1.041e-002*sin(t)),  2.171e-001 +2.000*( 9.996e-001* 2.042e-002*cos(t)+ 2.954e-002* 1.041e-002*sin(t)) not
# Age 70, p23 - p12
set label "70" at  7.154e-002, 2.720e-001 center
replot  7.154e-002+ 2.000*( 3.715e-002* 2.858e-002*cos(t)+-9.993e-001* 1.245e-002*sin(t)),  2.720e-001 +2.000*( 9.993e-001* 2.858e-002*cos(t)+ 3.715e-002* 1.245e-002*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.086e-001, 3.368e-001 center
replot  1.086e-001+ 2.000*( 5.572e-002* 4.485e-002*cos(t)+-9.984e-001* 1.758e-002*sin(t)),  3.368e-001 +2.000*( 9.984e-001* 4.485e-002*cos(t)+ 5.572e-002* 1.758e-002*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.631e-001, 4.105e-001 center
replot  1.631e-001+ 2.000*( 9.106e-002* 6.862e-002*cos(t)+-9.958e-001* 3.069e-002*sin(t)),  4.105e-001 +2.000*( 9.958e-001* 6.862e-002*cos(t)+ 9.106e-002* 3.069e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  2.409e-001, 4.899e-001 center
replot  2.409e-001+ 2.000*( 1.661e-001* 9.981e-002*cos(t)+-9.861e-001* 5.581e-002*sin(t)),  4.899e-001 +2.000*( 9.861e-001* 9.981e-002*cos(t)+ 1.661e-001* 5.581e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  3.482e-001, 5.689e-001 center
replot  3.482e-001+ 2.000*( 3.218e-001* 1.413e-001*cos(t)+-9.468e-001* 9.389e-002*sin(t)),  5.689e-001 +2.000*( 9.468e-001* 1.413e-001*cos(t)+ 3.218e-001* 9.389e-002*sin(t)) not
set out;
set out "HRMsr/VARPIJGR_HRMsr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "HRMsr/VARPIJGR_HRMsr_121-13.svg"
set label "50" at  1.984e-001, 2.631e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  1.984e-001+ 2.000*( 1.000e+000* 4.029e-002*cos(t)+-3.139e-003* 2.167e-003*sin(t)),  2.631e-003 +2.000*( 3.139e-003* 4.029e-002*cos(t)+ 1.000e+000* 2.167e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  2.189e-001, 4.648e-003 center
replot  2.189e-001+ 2.000*( 1.000e+000* 3.421e-002*cos(t)+-3.678e-003* 3.068e-003*sin(t)),  4.648e-003 +2.000*( 3.678e-003* 3.421e-002*cos(t)+ 1.000e+000* 3.068e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.408e-001, 8.168e-003 center
replot  2.408e-001+ 2.000*( 1.000e+000* 2.850e-002*cos(t)+-3.013e-003* 4.157e-003*sin(t)),  8.168e-003 +2.000*( 3.013e-003* 2.850e-002*cos(t)+ 1.000e+000* 4.157e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.637e-001, 1.426e-002 center
replot  2.637e-001+ 2.000*( 1.000e+000* 2.585e-002*cos(t)+-3.909e-003* 5.494e-003*sin(t)),  1.426e-002 +2.000*( 3.909e-003* 2.585e-002*cos(t)+ 1.000e+000* 5.494e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.870e-001, 2.467e-002 center
replot  2.870e-001+ 2.000*( 9.998e-001* 2.981e-002*cos(t)+-2.113e-002* 7.948e-003*sin(t)),  2.467e-002 +2.000*( 2.113e-002* 2.981e-002*cos(t)+ 9.998e-001* 7.948e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  3.099e-001, 4.218e-002 center
replot  3.099e-001+ 2.000*( 9.981e-001* 4.054e-002*cos(t)+-6.185e-002* 1.475e-002*sin(t)),  4.218e-002 +2.000*( 6.185e-002* 4.054e-002*cos(t)+ 9.981e-001* 1.475e-002*sin(t)) not
# Age 80, p21 - p13
set label "80" at  3.308e-001, 7.099e-002 center
replot  3.308e-001+ 2.000*( 9.877e-001* 5.588e-002*cos(t)+-1.561e-001* 3.150e-002*sin(t)),  7.099e-002 +2.000*( 1.561e-001* 5.588e-002*cos(t)+ 9.877e-001* 3.150e-002*sin(t)) not
# Age 85, p21 - p13
set label "85" at  3.474e-001, 1.170e-001 center
replot  3.474e-001+ 2.000*( 8.043e-001* 7.781e-002*cos(t)+-5.943e-001* 6.243e-002*sin(t)),  1.170e-001 +2.000*( 5.943e-001* 7.781e-002*cos(t)+ 8.043e-001* 6.243e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  3.570e-001, 1.876e-001 center
replot  3.570e-001+ 2.000*( 2.688e-001* 1.364e-001*cos(t)+-9.632e-001* 8.686e-002*sin(t)),  1.876e-001 +2.000*( 9.632e-001* 1.364e-001*cos(t)+ 2.688e-001* 8.686e-002*sin(t)) not
set out;
set out "HRMsr/VARPIJGR_HRMsr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "HRMsr/VARPIJGR_HRMsr_123-13.svg"
set label "50" at  1.263e-002, 2.631e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  1.263e-002+ 2.000*( 9.919e-001* 5.785e-003*cos(t)+ 1.272e-001* 2.059e-003*sin(t)),  2.631e-003 +2.000*(-1.272e-001* 5.785e-003*cos(t)+ 9.919e-001* 2.059e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.961e-002, 4.648e-003 center
replot  1.961e-002+ 2.000*( 9.908e-001* 7.334e-003*cos(t)+ 1.355e-001* 2.933e-003*sin(t)),  4.648e-003 +2.000*(-1.355e-001* 7.334e-003*cos(t)+ 9.908e-001* 2.933e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.033e-002, 8.168e-003 center
replot  3.033e-002+ 2.000*( 9.902e-001* 8.938e-003*cos(t)+ 1.399e-001* 4.005e-003*sin(t)),  8.168e-003 +2.000*(-1.399e-001* 8.938e-003*cos(t)+ 9.902e-001* 4.005e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  4.672e-002, 1.426e-002 center
replot  4.672e-002+ 2.000*( 9.886e-001* 1.051e-002*cos(t)+ 1.504e-001* 5.323e-003*sin(t)),  1.426e-002 +2.000*(-1.504e-001* 1.051e-002*cos(t)+ 9.886e-001* 5.323e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  7.154e-002, 2.467e-002 center
replot  7.154e-002+ 2.000*( 9.684e-001* 1.274e-002*cos(t)+ 2.492e-001* 7.549e-003*sin(t)),  2.467e-002 +2.000*(-2.492e-001* 1.274e-002*cos(t)+ 9.684e-001* 7.549e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.086e-001, 4.218e-002 center
replot  1.086e-001+ 2.000*( 8.345e-001* 1.963e-002*cos(t)+ 5.510e-001* 1.234e-002*sin(t)),  4.218e-002 +2.000*(-5.510e-001* 1.963e-002*cos(t)+ 8.345e-001* 1.234e-002*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.631e-001, 7.099e-002 center
replot  1.631e-001+ 2.000*( 6.819e-001* 3.895e-002*cos(t)+ 7.314e-001* 2.236e-002*sin(t)),  7.099e-002 +2.000*(-7.314e-001* 3.895e-002*cos(t)+ 6.819e-001* 2.236e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  2.409e-001, 1.170e-001 center
replot  2.409e-001+ 2.000*( 5.861e-001* 7.840e-002*cos(t)+ 8.102e-001* 4.261e-002*sin(t)),  1.170e-001 +2.000*(-8.102e-001* 7.840e-002*cos(t)+ 5.861e-001* 4.261e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  3.482e-001, 1.876e-001 center
replot  3.482e-001+ 2.000*( 5.035e-001* 1.478e-001*cos(t)+ 8.640e-001* 7.706e-002*sin(t)),  1.876e-001 +2.000*(-8.640e-001* 1.478e-001*cos(t)+ 5.035e-001* 7.706e-002*sin(t)) not
set out;
set out "HRMsr/VARPIJGR_HRMsr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "HRMsr/VARPIJGR_HRMsr_123-21.svg"
set label "50" at  1.263e-002, 1.984e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.263e-002+ 2.000*( 2.458e-004* 4.029e-002*cos(t)+ 1.000e+000* 5.744e-003*sin(t)),  1.984e-001 +2.000*(-1.000e+000* 4.029e-002*cos(t)+ 2.458e-004* 5.744e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.961e-002, 2.189e-001 center
replot  1.961e-002+ 2.000*( 3.081e-003* 3.421e-002*cos(t)+ 1.000e+000* 7.277e-003*sin(t)),  2.189e-001 +2.000*(-1.000e+000* 3.421e-002*cos(t)+ 3.081e-003* 7.277e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.033e-002, 2.408e-001 center
replot  3.033e-002+ 2.000*( 1.027e-002* 2.850e-002*cos(t)+ 9.999e-001* 8.863e-003*sin(t)),  2.408e-001 +2.000*(-9.999e-001* 2.850e-002*cos(t)+ 1.027e-002* 8.863e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  4.672e-002, 2.637e-001 center
replot  4.672e-002+ 2.000*( 2.345e-002* 2.586e-002*cos(t)+ 9.997e-001* 1.041e-002*sin(t)),  2.637e-001 +2.000*(-9.997e-001* 2.586e-002*cos(t)+ 2.345e-002* 1.041e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  7.154e-002, 2.870e-001 center
replot  7.154e-002+ 2.000*( 3.553e-002* 2.982e-002*cos(t)+ 9.994e-001* 1.245e-002*sin(t)),  2.870e-001 +2.000*(-9.994e-001* 2.982e-002*cos(t)+ 3.553e-002* 1.245e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.086e-001, 3.099e-001 center
replot  1.086e-001+ 2.000*( 5.756e-002* 4.052e-002*cos(t)+ 9.983e-001* 1.761e-002*sin(t)),  3.099e-001 +2.000*(-9.983e-001* 4.052e-002*cos(t)+ 5.756e-002* 1.761e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.631e-001, 3.308e-001 center
replot  1.631e-001+ 2.000*( 1.291e-001* 5.574e-002*cos(t)+ 9.916e-001* 3.061e-002*sin(t)),  3.308e-001 +2.000*(-9.916e-001* 5.574e-002*cos(t)+ 1.291e-001* 3.061e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  2.409e-001, 3.474e-001 center
replot  2.409e-001+ 2.000*( 3.764e-001* 7.541e-002*cos(t)+ 9.265e-001* 5.395e-002*sin(t)),  3.474e-001 +2.000*(-9.265e-001* 7.541e-002*cos(t)+ 3.764e-001* 5.395e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  3.482e-001, 3.570e-001 center
replot  3.482e-001+ 2.000*( 7.955e-001* 1.105e-001*cos(t)+ 6.059e-001* 7.809e-002*sin(t)),  3.570e-001 +2.000*(-6.059e-001* 1.105e-001*cos(t)+ 7.955e-001* 7.809e-002*sin(t)) not
set out;
set out "HRMsr/VARPIJGR_HRMsr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "HRMsr/VARMUPTJGR--STABLBASED_HRMsr1.svg";
 plot "HRMsr/PRMORPREV-1-STABLBASED_HRMsr.txt"  u 1:($3) not w l lt 1 
 replot "HRMsr/PRMORPREV-1-STABLBASED_HRMsr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "HRMsr/PRMORPREV-1-STABLBASED_HRMsr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "HRMsr/VARMUPTJGR--STABLBASED_HRMsr1.svg";replot;set out;
