
# IMaCh-0.99r45
# ESFsr.gp
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


set ter svg size 640, 480;set out "ESFsr/D_ESFsr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "ESFsr/ILK_ESFsr-dest.png";
set log y;plot  "ESFsr/ILK_ESFsr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "ESFsr/ILK_ESFsr-ori.png";
set log y;plot  "ESFsr/ILK_ESFsr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "ESFsr/ILK_ESFsr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ESFsr/ILK_ESFsr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "ESFsr/ILK_ESFsr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ESFsr/ILK_ESFsr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "ESFsr/V_ESFsr_1-1-1.svg" 

#set out "V_ESFsr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ESFsr/VPL_ESFsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"ESFsr/VPL_ESFsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"ESFsr/VPL_ESFsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"ESFsr/P_ESFsr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "ESFsr/V_ESFsr_2-1-1.svg" 

#set out "V_ESFsr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ESFsr/VPL_ESFsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"ESFsr/VPL_ESFsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"ESFsr/VPL_ESFsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"ESFsr/P_ESFsr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "ESFsr/E_ESFsr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "ESFsr/T_ESFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"ESFsr/T_ESFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"ESFsr/T_ESFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"ESFsr/T_ESFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"ESFsr/T_ESFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"ESFsr/T_ESFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"ESFsr/T_ESFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"ESFsr/T_ESFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"ESFsr/T_ESFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "ESFsr/E_ESFsr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "ESFsr/EXP_ESFsr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ESFsr/E_ESFsr.txt" every :::0::0 u 1:2 t "e11" w l ,"ESFsr/E_ESFsr.txt" every :::0::0 u 1:3 t "e12" w l ,"ESFsr/E_ESFsr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "ESFsr/EXP_ESFsr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ESFsr/E_ESFsr.txt" every :::0::0 u 1:5 t "e21" w l ,"ESFsr/E_ESFsr.txt" every :::0::0 u 1:6 t "e22" w l ,"ESFsr/E_ESFsr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "ESFsr/LIJ_ESFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFsr/PIJ_ESFsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "ESFsr/LIJ_ESFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFsr/PIJ_ESFsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "ESFsr/LIJT_ESFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFsr/PIJ_ESFsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "ESFsr/LIJT_ESFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFsr/PIJ_ESFsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "ESFsr/P_ESFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFsr/PIJ_ESFsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "ESFsr/P_ESFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFsr/PIJ_ESFsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-6.178250; p2=0.055545; 
#   current state 3
p3=-9.632373; p4=0.055345; 
# initial state 2
#   current state 1
p5=-0.707667; p6=-0.025130; 
#   current state 3
p7=-13.392443; p8=0.126367; 
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

set out "ESFsr/PE_ESFsr_1-1-1.svg" 
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

set out "ESFsr/PE_ESFsr_1-2-1.svg" 
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

set out "ESFsr/PE_ESFsr_1-3-1.svg" 
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
set out "ESFsr/VARPIJGR_ESFsr_113-12.svg"
set label "50" at  2.018e-003, 6.446e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  2.018e-003+ 2.000*( 6.838e-003* 8.091e-003*cos(t)+ 1.000e+000* 1.333e-003*sin(t)),  6.446e-002 +2.000*(-1.000e+000* 8.091e-003*cos(t)+ 6.838e-003* 1.333e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  2.633e-003, 8.420e-002 center
replot  2.633e-003+ 2.000*( 4.958e-003* 8.381e-003*cos(t)+ 1.000e+000* 1.359e-003*sin(t)),  8.420e-002 +2.000*(-1.000e+000* 8.381e-003*cos(t)+ 4.958e-003* 1.359e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  3.425e-003, 1.096e-001 center
replot  3.425e-003+ 2.000*( 3.617e-003* 8.492e-003*cos(t)+ 1.000e+000* 1.373e-003*sin(t)),  1.096e-001 +2.000*(-1.000e+000* 8.492e-003*cos(t)+ 3.617e-003* 1.373e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  4.436e-003, 1.422e-001 center
replot  4.436e-003+ 2.000*( 6.910e-003* 8.941e-003*cos(t)+ 1.000e+000* 1.538e-003*sin(t)),  1.422e-001 +2.000*(-1.000e+000* 8.941e-003*cos(t)+ 6.910e-003* 1.538e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  5.716e-003, 1.834e-001 center
replot  5.716e-003+ 2.000*( 1.921e-002* 1.105e-002*cos(t)+ 9.998e-001* 2.167e-003*sin(t)),  1.834e-001 +2.000*(-9.998e-001* 1.105e-002*cos(t)+ 1.921e-002* 2.167e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  7.317e-003, 2.350e-001 center
replot  7.317e-003+ 2.000*( 3.217e-002* 1.631e-002*cos(t)+ 9.995e-001* 3.508e-003*sin(t)),  2.350e-001 +2.000*(-9.995e-001* 1.631e-002*cos(t)+ 3.217e-002* 3.508e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  9.290e-003, 2.986e-001 center
replot  9.290e-003+ 2.000*( 4.034e-002* 2.534e-002*cos(t)+ 9.992e-001* 5.711e-003*sin(t)),  2.986e-001 +2.000*(-9.992e-001* 2.534e-002*cos(t)+ 4.034e-002* 5.711e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  1.168e-002, 3.757e-001 center
replot  1.168e-002+ 2.000*( 4.689e-002* 3.825e-002*cos(t)+ 9.989e-001* 8.941e-003*sin(t)),  3.757e-001 +2.000*(-9.989e-001* 3.825e-002*cos(t)+ 4.689e-002* 8.941e-003*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.450e-002, 4.670e-001 center
replot  1.450e-002+ 2.000*( 5.456e-002* 5.491e-002*cos(t)+ 9.985e-001* 1.339e-002*sin(t)),  4.670e-001 +2.000*(-9.985e-001* 5.491e-002*cos(t)+ 5.456e-002* 1.339e-002*sin(t)) not
set out;
set out "ESFsr/VARPIJGR_ESFsr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ESFsr/VARPIJGR_ESFsr_121-12.svg"
set label "50" at  2.458e-001, 6.446e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  2.458e-001+ 2.000*( 9.971e-001* 3.211e-002*cos(t)+-7.629e-002* 7.734e-003*sin(t)),  6.446e-002 +2.000*( 7.629e-002* 3.211e-002*cos(t)+ 9.971e-001* 7.734e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  2.199e-001, 8.420e-002 center
replot  2.199e-001+ 2.000*( 9.937e-001* 2.360e-002*cos(t)+-1.122e-001* 8.001e-003*sin(t)),  8.420e-002 +2.000*( 1.122e-001* 2.360e-002*cos(t)+ 9.937e-001* 8.001e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  1.962e-001, 1.096e-001 center
replot  1.962e-001+ 2.000*( 9.840e-001* 1.708e-002*cos(t)+-1.784e-001* 8.056e-003*sin(t)),  1.096e-001 +2.000*( 1.784e-001* 1.708e-002*cos(t)+ 9.840e-001* 8.056e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  1.746e-001, 1.422e-001 center
replot  1.746e-001+ 2.000*( 9.378e-001* 1.298e-002*cos(t)+-3.471e-001* 8.235e-003*sin(t)),  1.422e-001 +2.000*( 3.471e-001* 1.298e-002*cos(t)+ 9.378e-001* 8.235e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  1.549e-001, 1.834e-001 center
replot  1.549e-001+ 2.000*( 6.701e-001* 1.254e-002*cos(t)+-7.423e-001* 8.887e-003*sin(t)),  1.834e-001 +2.000*( 7.423e-001* 1.254e-002*cos(t)+ 6.701e-001* 8.887e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.367e-001, 2.350e-001 center
replot  1.367e-001+ 2.000*( 3.512e-001* 1.702e-002*cos(t)+-9.363e-001* 9.795e-003*sin(t)),  2.350e-001 +2.000*( 9.363e-001* 1.702e-002*cos(t)+ 3.512e-001* 9.795e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.196e-001, 2.986e-001 center
replot  1.196e-001+ 2.000*( 2.088e-001* 2.578e-002*cos(t)+-9.780e-001* 1.105e-002*sin(t)),  2.986e-001 +2.000*( 9.780e-001* 2.578e-002*cos(t)+ 2.088e-001* 1.105e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.031e-001, 3.757e-001 center
replot  1.031e-001+ 2.000*( 1.357e-001* 3.853e-002*cos(t)+-9.907e-001* 1.215e-002*sin(t)),  3.757e-001 +2.000*( 9.907e-001* 3.853e-002*cos(t)+ 1.357e-001* 1.215e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  8.671e-002, 4.670e-001 center
replot  8.671e-002+ 2.000*( 9.173e-002* 5.505e-002*cos(t)+-9.958e-001* 1.267e-002*sin(t)),  4.670e-001 +2.000*( 9.958e-001* 5.505e-002*cos(t)+ 9.173e-002* 1.267e-002*sin(t)) not
set out;
set out "ESFsr/VARPIJGR_ESFsr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ESFsr/VARPIJGR_ESFsr_123-12.svg"
set label "50" at  1.484e-003, 6.446e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  1.484e-003+ 2.000*( 3.966e-004* 8.091e-003*cos(t)+ 1.000e+000* 7.102e-004*sin(t)),  6.446e-002 +2.000*(-1.000e+000* 8.091e-003*cos(t)+ 3.966e-004* 7.102e-004*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.831e-003, 8.420e-002 center
replot  2.831e-003+ 2.000*( 3.933e-005* 8.380e-003*cos(t)+ 1.000e+000* 1.157e-003*sin(t)),  8.420e-002 +2.000*(-1.000e+000* 8.380e-003*cos(t)+ 3.933e-005* 1.157e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  5.388e-003, 1.096e-001 center
replot  5.388e-003+ 2.000*( 1.267e-003* 8.492e-003*cos(t)+-1.000e+000* 1.828e-003*sin(t)),  1.096e-001 +2.000*( 1.000e+000* 8.492e-003*cos(t)+ 1.267e-003* 1.828e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.023e-002, 1.422e-001 center
replot  1.023e-002+ 2.000*( 4.779e-003* 8.941e-003*cos(t)+-1.000e+000* 2.773e-003*sin(t)),  1.422e-001 +2.000*( 1.000e+000* 8.941e-003*cos(t)+ 4.779e-003* 2.773e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  1.936e-002, 1.834e-001 center
replot  1.936e-002+ 2.000*( 9.444e-003* 1.105e-002*cos(t)+-1.000e+000* 3.975e-003*sin(t)),  1.834e-001 +2.000*( 1.000e+000* 1.105e-002*cos(t)+ 9.444e-003* 3.975e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  3.643e-002, 2.350e-001 center
replot  3.643e-002+ 2.000*( 1.097e-002* 1.630e-002*cos(t)+-9.999e-001* 5.303e-003*sin(t)),  2.350e-001 +2.000*( 9.999e-001* 1.630e-002*cos(t)+ 1.097e-002* 5.303e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  6.799e-002, 2.986e-001 center
replot  6.799e-002+ 2.000*( 1.087e-002* 2.532e-002*cos(t)+-9.999e-001* 6.943e-003*sin(t)),  2.986e-001 +2.000*( 9.999e-001* 2.532e-002*cos(t)+ 1.087e-002* 6.943e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.250e-001, 3.757e-001 center
replot  1.250e-001+ 2.000*( 1.187e-002* 3.821e-002*cos(t)+-9.999e-001* 1.206e-002*sin(t)),  3.757e-001 +2.000*( 9.999e-001* 3.821e-002*cos(t)+ 1.187e-002* 1.206e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.242e-001, 4.670e-001 center
replot  2.242e-001+ 2.000*( 1.674e-002* 5.483e-002*cos(t)+-9.999e-001* 2.829e-002*sin(t)),  4.670e-001 +2.000*( 9.999e-001* 5.483e-002*cos(t)+ 1.674e-002* 2.829e-002*sin(t)) not
set out;
set out "ESFsr/VARPIJGR_ESFsr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ESFsr/VARPIJGR_ESFsr_121-13.svg"
set label "50" at  2.458e-001, 2.018e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  2.458e-001+ 2.000*( 1.000e+000* 3.202e-002*cos(t)+-1.026e-004* 1.335e-003*sin(t)),  2.018e-003 +2.000*( 1.026e-004* 3.202e-002*cos(t)+ 1.000e+000* 1.335e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  2.199e-001, 2.633e-003 center
replot  2.199e-001+ 2.000*( 1.000e+000* 2.347e-002*cos(t)+-2.215e-004* 1.359e-003*sin(t)),  2.633e-003 +2.000*( 2.215e-004* 2.347e-002*cos(t)+ 1.000e+000* 1.359e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  1.962e-001, 3.425e-003 center
replot  1.962e-001+ 2.000*( 1.000e+000* 1.687e-002*cos(t)+-7.024e-004* 1.374e-003*sin(t)),  3.425e-003 +2.000*( 7.024e-004* 1.687e-002*cos(t)+ 1.000e+000* 1.374e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  1.746e-001, 4.436e-003 center
replot  1.746e-001+ 2.000*( 1.000e+000* 1.250e-002*cos(t)+-2.322e-003* 1.539e-003*sin(t)),  4.436e-003 +2.000*( 2.322e-003* 1.250e-002*cos(t)+ 1.000e+000* 1.539e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  1.549e-001, 5.716e-003 center
replot  1.549e-001+ 2.000*( 1.000e+000* 1.068e-002*cos(t)+-5.631e-003* 2.176e-003*sin(t)),  5.716e-003 +2.000*( 5.631e-003* 1.068e-002*cos(t)+ 1.000e+000* 2.176e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.367e-001, 7.317e-003 center
replot  1.367e-001+ 2.000*( 1.000e+000* 1.095e-002*cos(t)+-9.165e-003* 3.544e-003*sin(t)),  7.317e-003 +2.000*( 9.165e-003* 1.095e-002*cos(t)+ 1.000e+000* 3.544e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.196e-001, 9.290e-003 center
replot  1.196e-001+ 2.000*( 9.999e-001* 1.208e-002*cos(t)+-1.301e-002* 5.795e-003*sin(t)),  9.290e-003 +2.000*( 1.301e-002* 1.208e-002*cos(t)+ 9.999e-001* 5.795e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.031e-001, 1.168e-002 center
replot  1.031e-001+ 2.000*( 9.997e-001* 1.312e-002*cos(t)+-2.315e-002* 9.107e-003*sin(t)),  1.168e-002 +2.000*( 2.315e-002* 1.312e-002*cos(t)+ 9.997e-001* 9.107e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  8.671e-002, 1.450e-002 center
replot  8.671e-002+ 2.000*( 5.268e-001* 1.376e-002*cos(t)+-8.500e-001* 1.353e-002*sin(t)),  1.450e-002 +2.000*( 8.500e-001* 1.376e-002*cos(t)+ 5.268e-001* 1.353e-002*sin(t)) not
set out;
set out "ESFsr/VARPIJGR_ESFsr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ESFsr/VARPIJGR_ESFsr_123-13.svg"
set label "50" at  1.484e-003, 2.018e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  1.484e-003+ 2.000*( 4.553e-002* 1.336e-003*cos(t)+ 9.990e-001* 7.083e-004*sin(t)),  2.018e-003 +2.000*(-9.990e-001* 1.336e-003*cos(t)+ 4.553e-002* 7.083e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.831e-003, 2.633e-003 center
replot  2.831e-003+ 2.000*( 2.262e-001* 1.370e-003*cos(t)+ 9.741e-001* 1.144e-003*sin(t)),  2.633e-003 +2.000*(-9.741e-001* 1.370e-003*cos(t)+ 2.262e-001* 1.144e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  5.388e-003, 3.425e-003 center
replot  5.388e-003+ 2.000*( 9.840e-001* 1.842e-003*cos(t)+ 1.781e-001* 1.356e-003*sin(t)),  3.425e-003 +2.000*(-1.781e-001* 1.842e-003*cos(t)+ 9.840e-001* 1.356e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.023e-002, 4.436e-003 center
replot  1.023e-002+ 2.000*( 9.938e-001* 2.786e-003*cos(t)+ 1.116e-001* 1.517e-003*sin(t)),  4.436e-003 +2.000*(-1.116e-001* 2.786e-003*cos(t)+ 9.938e-001* 1.517e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  1.936e-002, 5.716e-003 center
replot  1.936e-002+ 2.000*( 9.925e-001* 3.998e-003*cos(t)+ 1.226e-001* 2.137e-003*sin(t)),  5.716e-003 +2.000*(-1.226e-001* 3.998e-003*cos(t)+ 9.925e-001* 2.137e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  3.643e-002, 7.317e-003 center
replot  3.643e-002+ 2.000*( 9.801e-001* 5.368e-003*cos(t)+ 1.985e-001* 3.450e-003*sin(t)),  7.317e-003 +2.000*(-1.985e-001* 5.368e-003*cos(t)+ 9.801e-001* 3.450e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  6.799e-002, 9.290e-003 center
replot  6.799e-002+ 2.000*( 9.154e-001* 7.196e-003*cos(t)+ 4.025e-001* 5.485e-003*sin(t)),  9.290e-003 +2.000*(-4.025e-001* 7.196e-003*cos(t)+ 9.154e-001* 5.485e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.250e-001, 1.168e-002 center
replot  1.250e-001+ 2.000*( 9.613e-001* 1.229e-002*cos(t)+ 2.755e-001* 8.797e-003*sin(t)),  1.168e-002 +2.000*(-2.755e-001* 1.229e-002*cos(t)+ 9.613e-001* 8.797e-003*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.242e-001, 1.450e-002 center
replot  2.242e-001+ 2.000*( 9.972e-001* 2.836e-002*cos(t)+ 7.498e-002* 1.357e-002*sin(t)),  1.450e-002 +2.000*(-7.498e-002* 2.836e-002*cos(t)+ 9.972e-001* 1.357e-002*sin(t)) not
set out;
set out "ESFsr/VARPIJGR_ESFsr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "ESFsr/VARPIJGR_ESFsr_123-21.svg"
set label "50" at  1.484e-003, 2.458e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.484e-003+ 2.000*( 4.361e-004* 3.202e-002*cos(t)+ 1.000e+000* 7.100e-004*sin(t)),  2.458e-001 +2.000*(-1.000e+000* 3.202e-002*cos(t)+ 4.361e-004* 7.100e-004*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.831e-003, 2.199e-001 center
replot  2.831e-003+ 2.000*( 9.089e-004* 2.347e-002*cos(t)+ 1.000e+000* 1.156e-003*sin(t)),  2.199e-001 +2.000*(-1.000e+000* 2.347e-002*cos(t)+ 9.089e-004* 1.156e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  5.388e-003, 1.962e-001 center
replot  5.388e-003+ 2.000*( 2.297e-003* 1.687e-002*cos(t)+ 1.000e+000* 1.828e-003*sin(t)),  1.962e-001 +2.000*(-1.000e+000* 1.687e-002*cos(t)+ 2.297e-003* 1.828e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.023e-002, 1.746e-001 center
replot  1.023e-002+ 2.000*( 6.625e-003* 1.250e-002*cos(t)+ 1.000e+000* 2.773e-003*sin(t)),  1.746e-001 +2.000*(-1.000e+000* 1.250e-002*cos(t)+ 6.625e-003* 2.773e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  1.936e-002, 1.549e-001 center
replot  1.936e-002+ 2.000*( 1.600e-002* 1.069e-002*cos(t)+ 9.999e-001* 3.973e-003*sin(t)),  1.549e-001 +2.000*(-9.999e-001* 1.069e-002*cos(t)+ 1.600e-002* 3.973e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  3.643e-002, 1.367e-001 center
replot  3.643e-002+ 2.000*( 2.437e-002* 1.095e-002*cos(t)+ 9.997e-001* 5.301e-003*sin(t)),  1.367e-001 +2.000*(-9.997e-001* 1.095e-002*cos(t)+ 2.437e-002* 5.301e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  6.799e-002, 1.196e-001 center
replot  6.799e-002+ 2.000*( 2.655e-002* 1.208e-002*cos(t)+ 9.996e-001* 6.943e-003*sin(t)),  1.196e-001 +2.000*(-9.996e-001* 1.208e-002*cos(t)+ 2.655e-002* 6.943e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.250e-001, 1.031e-001 center
replot  1.250e-001+ 2.000*( 1.778e-001* 1.316e-002*cos(t)+ 9.841e-001* 1.203e-002*sin(t)),  1.031e-001 +2.000*(-9.841e-001* 1.316e-002*cos(t)+ 1.778e-001* 1.203e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.242e-001, 8.671e-002 center
replot  2.242e-001+ 2.000*( 9.989e-001* 2.833e-002*cos(t)+ 4.709e-002* 1.354e-002*sin(t)),  8.671e-002 +2.000*(-4.709e-002* 2.833e-002*cos(t)+ 9.989e-001* 1.354e-002*sin(t)) not
set out;
set out "ESFsr/VARPIJGR_ESFsr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "ESFsr/VARMUPTJGR--STABLBASED_ESFsr1.svg";
 plot "ESFsr/PRMORPREV-1-STABLBASED_ESFsr.txt"  u 1:($3) not w l lt 1 
 replot "ESFsr/PRMORPREV-1-STABLBASED_ESFsr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "ESFsr/PRMORPREV-1-STABLBASED_ESFsr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "ESFsr/VARMUPTJGR--STABLBASED_ESFsr1.svg";replot;set out;
