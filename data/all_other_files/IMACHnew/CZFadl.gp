
# IMaCh-0.99r45
# CZFadl.gp
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


set ter svg size 640, 480;set out "CZFadl/D_CZFadl_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "CZFadl/ILK_CZFadl-dest.png";
set log y;plot  "CZFadl/ILK_CZFadl.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "CZFadl/ILK_CZFadl-ori.png";
set log y;plot  "CZFadl/ILK_CZFadl.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "CZFadl/ILK_CZFadl-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "CZFadl/ILK_CZFadl.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "CZFadl/ILK_CZFadl-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "CZFadl/ILK_CZFadl.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "CZFadl/V_CZFadl_1-1-1.svg" 

#set out "V_CZFadl_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "CZFadl/VPL_CZFadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"CZFadl/VPL_CZFadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"CZFadl/VPL_CZFadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"CZFadl/P_CZFadl.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "CZFadl/V_CZFadl_2-1-1.svg" 

#set out "V_CZFadl_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "CZFadl/VPL_CZFadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"CZFadl/VPL_CZFadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"CZFadl/VPL_CZFadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"CZFadl/P_CZFadl.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "CZFadl/E_CZFadl_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "CZFadl/T_CZFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"CZFadl/T_CZFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"CZFadl/T_CZFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"CZFadl/T_CZFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"CZFadl/T_CZFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"CZFadl/T_CZFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"CZFadl/T_CZFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"CZFadl/T_CZFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"CZFadl/T_CZFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "CZFadl/E_CZFadl_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "CZFadl/EXP_CZFadl_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "CZFadl/E_CZFadl.txt" every :::0::0 u 1:2 t "e11" w l ,"CZFadl/E_CZFadl.txt" every :::0::0 u 1:3 t "e12" w l ,"CZFadl/E_CZFadl.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "CZFadl/EXP_CZFadl_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "CZFadl/E_CZFadl.txt" every :::0::0 u 1:5 t "e21" w l ,"CZFadl/E_CZFadl.txt" every :::0::0 u 1:6 t "e22" w l ,"CZFadl/E_CZFadl.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "CZFadl/LIJ_CZFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFadl/PIJ_CZFadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "CZFadl/LIJ_CZFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFadl/PIJ_CZFadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "CZFadl/LIJT_CZFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFadl/PIJ_CZFadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "CZFadl/LIJT_CZFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFadl/PIJ_CZFadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "CZFadl/P_CZFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFadl/PIJ_CZFadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "CZFadl/P_CZFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFadl/PIJ_CZFadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-6.591691; p2=0.043872; 
#   current state 3
p3=-16.368187; p4=0.153220; 
# initial state 2
#   current state 1
p5=1.140897; p6=-0.040542; 
#   current state 3
p7=-7.393010; p8=0.061503; 
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

set out "CZFadl/PE_CZFadl_1-1-1.svg" 
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

set out "CZFadl/PE_CZFadl_1-2-1.svg" 
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

set out "CZFadl/PE_CZFadl_1-3-1.svg" 
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
set out "CZFadl/VARPIJGR_CZFadl_113-12.svg"
set label "50" at  3.267e-004, 2.430e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  3.267e-004+ 2.000*( 1.458e-002* 5.385e-003*cos(t)+ 9.999e-001* 3.130e-004*sin(t)),  2.430e-002 +2.000*(-9.999e-001* 5.385e-003*cos(t)+ 1.458e-002* 3.130e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  7.007e-004, 3.016e-002 center
replot  7.007e-004+ 2.000*( 2.792e-002* 5.368e-003*cos(t)+ 9.996e-001* 5.624e-004*sin(t)),  3.016e-002 +2.000*(-9.996e-001* 5.368e-003*cos(t)+ 2.792e-002* 5.624e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.501e-003, 3.741e-002 center
replot  1.501e-003+ 2.000*( 5.498e-002* 5.172e-003*cos(t)+ 9.985e-001* 9.743e-004*sin(t)),  3.741e-002 +2.000*(-9.985e-001* 5.172e-003*cos(t)+ 5.498e-002* 9.743e-004*sin(t)) not
# Age 65, p13 - p12
set label "65" at  3.212e-003, 4.633e-002 center
replot  3.212e-003+ 2.000*( 1.082e-001* 4.947e-003*cos(t)+ 9.941e-001* 1.604e-003*sin(t)),  4.633e-002 +2.000*(-9.941e-001* 4.947e-003*cos(t)+ 1.082e-001* 1.604e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  6.859e-003, 5.726e-002 center
replot  6.859e-003+ 2.000*( 1.758e-001* 5.251e-003*cos(t)+ 9.844e-001* 2.477e-003*sin(t)),  5.726e-002 +2.000*(-9.844e-001* 5.251e-003*cos(t)+ 1.758e-001* 2.477e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.460e-002, 7.053e-002 center
replot  1.460e-002+ 2.000*( 1.756e-001* 7.032e-003*cos(t)+ 9.845e-001* 3.632e-003*sin(t)),  7.053e-002 +2.000*(-9.845e-001* 7.032e-003*cos(t)+ 1.756e-001* 3.632e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.087e-002, 8.636e-002 center
replot  3.087e-002+ 2.000*( 1.958e-001* 1.095e-002*cos(t)+ 9.806e-001* 6.049e-003*sin(t)),  8.636e-002 +2.000*(-9.806e-001* 1.095e-002*cos(t)+ 1.958e-001* 6.049e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  6.459e-002, 1.046e-001 center
replot  6.459e-002+ 2.000*( 6.832e-001* 1.870e-002*cos(t)+ 7.302e-001* 1.447e-002*sin(t)),  1.046e-001 +2.000*(-7.302e-001* 1.870e-002*cos(t)+ 6.832e-001* 1.447e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.323e-001, 1.240e-001 center
replot  1.323e-001+ 2.000*( 9.771e-001* 4.876e-002*cos(t)+ 2.126e-001* 2.358e-002*sin(t)),  1.240e-001 +2.000*(-2.126e-001* 4.876e-002*cos(t)+ 9.771e-001* 2.358e-002*sin(t)) not
set out;
set out "CZFadl/VARPIJGR_CZFadl_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "CZFadl/VARPIJGR_CZFadl_121-12.svg"
set label "50" at  5.783e-001, 2.430e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  5.783e-001+ 2.000*( 9.998e-001* 1.113e-001*cos(t)+-1.761e-002* 5.016e-003*sin(t)),  2.430e-002 +2.000*( 1.761e-002* 1.113e-001*cos(t)+ 9.998e-001* 5.016e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  4.969e-001, 3.016e-002 center
replot  4.969e-001+ 2.000*( 9.997e-001* 8.240e-002*cos(t)+-2.423e-002* 4.982e-003*sin(t)),  3.016e-002 +2.000*( 2.423e-002* 8.240e-002*cos(t)+ 9.997e-001* 4.982e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  4.230e-001, 3.741e-002 center
replot  4.230e-001+ 2.000*( 9.994e-001* 5.832e-002*cos(t)+-3.362e-002* 4.781e-003*sin(t)),  3.741e-002 +2.000*( 3.362e-002* 5.832e-002*cos(t)+ 9.994e-001* 4.781e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.568e-001, 4.633e-002 center
replot  3.568e-001+ 2.000*( 9.989e-001* 4.029e-002*cos(t)+-4.590e-002* 4.565e-003*sin(t)),  4.633e-002 +2.000*( 4.590e-002* 4.029e-002*cos(t)+ 9.989e-001* 4.565e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.982e-001, 5.726e-002 center
replot  2.982e-001+ 2.000*( 9.983e-001* 2.965e-002*cos(t)+-5.895e-002* 4.893e-003*sin(t)),  5.726e-002 +2.000*( 5.895e-002* 2.965e-002*cos(t)+ 9.983e-001* 4.893e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.469e-001, 7.053e-002 center
replot  2.469e-001+ 2.000*( 9.972e-001* 2.639e-002*cos(t)+-7.507e-002* 6.682e-003*sin(t)),  7.053e-002 +2.000*( 7.507e-002* 2.639e-002*cos(t)+ 9.972e-001* 6.682e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.025e-001, 8.636e-002 center
replot  2.025e-001+ 2.000*( 9.938e-001* 2.738e-002*cos(t)+-1.108e-001* 1.043e-002*sin(t)),  8.636e-002 +2.000*( 1.108e-001* 2.738e-002*cos(t)+ 9.938e-001* 1.043e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.643e-001, 1.046e-001 center
replot  1.643e-001+ 2.000*( 9.811e-001* 2.920e-002*cos(t)+-1.933e-001* 1.619e-002*sin(t)),  1.046e-001 +2.000*( 1.933e-001* 2.920e-002*cos(t)+ 9.811e-001* 1.619e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.316e-001, 1.240e-001 center
replot  1.316e-001+ 2.000*( 8.911e-001* 3.083e-002*cos(t)+-4.538e-001* 2.361e-002*sin(t)),  1.240e-001 +2.000*( 4.538e-001* 3.083e-002*cos(t)+ 8.911e-001* 2.361e-002*sin(t)) not
set out;
set out "CZFadl/VARPIJGR_CZFadl_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "CZFadl/VARPIJGR_CZFadl_123-12.svg"
set label "50" at  1.870e-002, 2.430e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  1.870e-002+ 2.000*( 9.953e-001* 1.191e-002*cos(t)+-9.678e-002* 5.284e-003*sin(t)),  2.430e-002 +2.000*( 9.678e-002* 1.191e-002*cos(t)+ 9.953e-001* 5.284e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.676e-002, 3.016e-002 center
replot  2.676e-002+ 2.000*( 9.967e-001* 1.442e-002*cos(t)+-8.172e-002* 5.253e-003*sin(t)),  3.016e-002 +2.000*( 8.172e-002* 1.442e-002*cos(t)+ 9.967e-001* 5.253e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.794e-002, 3.741e-002 center
replot  3.794e-002+ 2.000*( 9.974e-001* 1.680e-002*cos(t)+-7.164e-002* 5.036e-003*sin(t)),  3.741e-002 +2.000*( 7.164e-002* 1.680e-002*cos(t)+ 9.974e-001* 5.036e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  5.331e-002, 4.633e-002 center
replot  5.331e-002+ 2.000*( 9.978e-001* 1.868e-002*cos(t)+-6.563e-002* 4.776e-003*sin(t)),  4.633e-002 +2.000*( 6.563e-002* 1.868e-002*cos(t)+ 9.978e-001* 4.776e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  7.422e-002, 5.726e-002 center
replot  7.422e-002+ 2.000*( 9.979e-001* 1.958e-002*cos(t)+-6.529e-002* 5.039e-003*sin(t)),  5.726e-002 +2.000*( 6.529e-002* 1.958e-002*cos(t)+ 9.979e-001* 5.039e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.024e-001, 7.053e-002 center
replot  1.024e-001+ 2.000*( 9.969e-001* 1.944e-002*cos(t)+-7.822e-002* 6.804e-003*sin(t)),  7.053e-002 +2.000*( 7.822e-002* 1.944e-002*cos(t)+ 9.969e-001* 6.804e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.398e-001, 8.636e-002 center
replot  1.398e-001+ 2.000*( 9.926e-001* 2.038e-002*cos(t)+-1.213e-001* 1.059e-002*sin(t)),  8.636e-002 +2.000*( 1.213e-001* 2.038e-002*cos(t)+ 9.926e-001* 1.059e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.889e-001, 1.046e-001 center
replot  1.889e-001+ 2.000*( 9.896e-001* 2.889e-002*cos(t)+-1.438e-001* 1.651e-002*sin(t)),  1.046e-001 +2.000*( 1.438e-001* 2.889e-002*cos(t)+ 9.896e-001* 1.651e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.522e-001, 1.240e-001 center
replot  2.522e-001+ 2.000*( 9.922e-001* 5.025e-002*cos(t)+-1.248e-001* 2.467e-002*sin(t)),  1.240e-001 +2.000*( 1.248e-001* 5.025e-002*cos(t)+ 9.922e-001* 2.467e-002*sin(t)) not
set out;
set out "CZFadl/VARPIJGR_CZFadl_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "CZFadl/VARPIJGR_CZFadl_121-13.svg"
set label "50" at  5.783e-001, 3.267e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  5.783e-001+ 2.000*( 1.000e+000* 1.112e-001*cos(t)+-1.645e-005* 3.226e-004*sin(t)),  3.267e-004 +2.000*( 1.645e-005* 1.112e-001*cos(t)+ 1.000e+000* 3.226e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  4.969e-001, 7.007e-004 center
replot  4.969e-001+ 2.000*( 1.000e+000* 8.238e-002*cos(t)+-9.098e-006* 5.818e-004*sin(t)),  7.007e-004 +2.000*( 9.098e-006* 8.238e-002*cos(t)+ 1.000e+000* 5.818e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  4.230e-001, 1.501e-003 center
replot  4.230e-001+ 2.000*( 1.000e+000* 5.828e-002*cos(t)+ 6.981e-005* 1.013e-003*sin(t)),  1.501e-003 +2.000*(-6.981e-005* 5.828e-002*cos(t)+ 1.000e+000* 1.013e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.568e-001, 3.212e-003 center
replot  3.568e-001+ 2.000*( 1.000e+000* 4.025e-002*cos(t)+ 3.770e-004* 1.682e-003*sin(t)),  3.212e-003 +2.000*(-3.770e-004* 4.025e-002*cos(t)+ 1.000e+000* 1.682e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.982e-001, 6.859e-003 center
replot  2.982e-001+ 2.000*( 1.000e+000* 2.960e-002*cos(t)+ 5.151e-004* 2.607e-003*sin(t)),  6.859e-003 +2.000*(-5.151e-004* 2.960e-002*cos(t)+ 1.000e+000* 2.607e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.469e-001, 1.460e-002 center
replot  2.469e-001+ 2.000*( 1.000e+000* 2.632e-002*cos(t)+-3.971e-003* 3.782e-003*sin(t)),  1.460e-002 +2.000*( 3.971e-003* 2.632e-002*cos(t)+ 1.000e+000* 3.782e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.025e-001, 3.087e-002 center
replot  2.025e-001+ 2.000*( 9.997e-001* 2.725e-002*cos(t)+-2.437e-002* 6.275e-003*sin(t)),  3.087e-002 +2.000*( 2.437e-002* 2.725e-002*cos(t)+ 9.997e-001* 6.275e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.643e-001, 6.459e-002 center
replot  1.643e-001+ 2.000*( 9.928e-001* 2.896e-002*cos(t)+-1.197e-001* 1.633e-002*sin(t)),  6.459e-002 +2.000*( 1.197e-001* 2.896e-002*cos(t)+ 9.928e-001* 1.633e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.316e-001, 1.323e-001 center
replot  1.316e-001+ 2.000*( 1.498e-001* 4.826e-002*cos(t)+-9.887e-001* 2.891e-002*sin(t)),  1.323e-001 +2.000*( 9.887e-001* 4.826e-002*cos(t)+ 1.498e-001* 2.891e-002*sin(t)) not
set out;
set out "CZFadl/VARPIJGR_CZFadl_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "CZFadl/VARPIJGR_CZFadl_123-13.svg"
set label "50" at  1.870e-002, 3.267e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  1.870e-002+ 2.000*( 9.999e-001* 1.186e-002*cos(t)+ 1.579e-002* 2.627e-004*sin(t)),  3.267e-004 +2.000*(-1.579e-002* 1.186e-002*cos(t)+ 9.999e-001* 2.627e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.676e-002, 7.007e-004 center
replot  2.676e-002+ 2.000*( 9.997e-001* 1.438e-002*cos(t)+ 2.364e-002* 4.724e-004*sin(t)),  7.007e-004 +2.000*(-2.364e-002* 1.438e-002*cos(t)+ 9.997e-001* 4.724e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.794e-002, 1.501e-003 center
replot  3.794e-002+ 2.000*( 9.994e-001* 1.678e-002*cos(t)+ 3.552e-002* 8.204e-004*sin(t)),  1.501e-003 +2.000*(-3.552e-002* 1.678e-002*cos(t)+ 9.994e-001* 8.204e-004*sin(t)) not
# Age 65, p23 - p13
set label "65" at  5.331e-002, 3.212e-003 center
replot  5.331e-002+ 2.000*( 9.986e-001* 1.867e-002*cos(t)+ 5.319e-002* 1.359e-003*sin(t)),  3.212e-003 +2.000*(-5.319e-002* 1.867e-002*cos(t)+ 9.986e-001* 1.359e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  7.422e-002, 6.859e-003 center
replot  7.422e-002+ 2.000*( 9.970e-001* 1.960e-002*cos(t)+ 7.787e-002* 2.121e-003*sin(t)),  6.859e-003 +2.000*(-7.787e-002* 1.960e-002*cos(t)+ 9.970e-001* 2.121e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.024e-001, 1.460e-002 center
replot  1.024e-001+ 2.000*( 9.944e-001* 1.949e-002*cos(t)+ 1.053e-001* 3.196e-003*sin(t)),  1.460e-002 +2.000*(-1.053e-001* 1.949e-002*cos(t)+ 9.944e-001* 3.196e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.398e-001, 3.087e-002 center
replot  1.398e-001+ 2.000*( 9.920e-001* 2.042e-002*cos(t)+ 1.263e-001* 5.803e-003*sin(t)),  3.087e-002 +2.000*(-1.263e-001* 2.042e-002*cos(t)+ 9.920e-001* 5.803e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.889e-001, 6.459e-002 center
replot  1.889e-001+ 2.000*( 9.679e-001* 2.937e-002*cos(t)+ 2.515e-001* 1.533e-002*sin(t)),  6.459e-002 +2.000*(-2.515e-001* 2.937e-002*cos(t)+ 9.679e-001* 1.533e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.522e-001, 1.323e-001 center
replot  2.522e-001+ 2.000*( 7.441e-001* 5.767e-002*cos(t)+ 6.680e-001* 3.827e-002*sin(t)),  1.323e-001 +2.000*(-6.680e-001* 5.767e-002*cos(t)+ 7.441e-001* 3.827e-002*sin(t)) not
set out;
set out "CZFadl/VARPIJGR_CZFadl_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "CZFadl/VARPIJGR_CZFadl_123-21.svg"
set label "50" at  1.870e-002, 5.783e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.870e-002+ 2.000*( 7.188e-003* 1.112e-001*cos(t)+ 1.000e+000* 1.184e-002*sin(t)),  5.783e-001 +2.000*(-1.000e+000* 1.112e-001*cos(t)+ 7.188e-003* 1.184e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.676e-002, 4.969e-001 center
replot  2.676e-002+ 2.000*( 8.887e-003* 8.238e-002*cos(t)+ 1.000e+000* 1.436e-002*sin(t)),  4.969e-001 +2.000*(-1.000e+000* 8.238e-002*cos(t)+ 8.887e-003* 1.436e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.794e-002, 4.230e-001 center
replot  3.794e-002+ 2.000*( 1.175e-002* 5.829e-002*cos(t)+ 9.999e-001* 1.675e-002*sin(t)),  4.230e-001 +2.000*(-9.999e-001* 5.829e-002*cos(t)+ 1.175e-002* 1.675e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  5.331e-002, 3.568e-001 center
replot  5.331e-002+ 2.000*( 2.010e-002* 4.026e-002*cos(t)+ 9.998e-001* 1.863e-002*sin(t)),  3.568e-001 +2.000*(-9.998e-001* 4.026e-002*cos(t)+ 2.010e-002* 1.863e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  7.422e-002, 2.982e-001 center
replot  7.422e-002+ 2.000*( 5.237e-002* 2.962e-002*cos(t)+ 9.986e-001* 1.950e-002*sin(t)),  2.982e-001 +2.000*(-9.986e-001* 2.962e-002*cos(t)+ 5.237e-002* 1.950e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.024e-001, 2.469e-001 center
replot  1.024e-001+ 2.000*( 1.180e-001* 2.640e-002*cos(t)+ 9.930e-001* 1.927e-002*sin(t)),  2.469e-001 +2.000*(-9.930e-001* 2.640e-002*cos(t)+ 1.180e-001* 1.927e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.398e-001, 2.025e-001 center
replot  1.398e-001+ 2.000*( 1.933e-001* 2.748e-002*cos(t)+ 9.811e-001* 1.994e-002*sin(t)),  2.025e-001 +2.000*(-9.811e-001* 2.748e-002*cos(t)+ 1.933e-001* 1.994e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.889e-001, 1.643e-001 center
replot  1.889e-001+ 2.000*( 6.972e-001* 3.100e-002*cos(t)+ 7.169e-001* 2.632e-002*sin(t)),  1.643e-001 +2.000*(-7.169e-001* 3.100e-002*cos(t)+ 6.972e-001* 2.632e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.522e-001, 1.316e-001 center
replot  2.522e-001+ 2.000*( 9.867e-001* 5.040e-002*cos(t)+ 1.623e-001* 2.871e-002*sin(t)),  1.316e-001 +2.000*(-1.623e-001* 5.040e-002*cos(t)+ 9.867e-001* 2.871e-002*sin(t)) not
set out;
set out "CZFadl/VARPIJGR_CZFadl_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "CZFadl/VARMUPTJGR--STABLBASED_CZFadl1.svg";
 plot "CZFadl/PRMORPREV-1-STABLBASED_CZFadl.txt"  u 1:($3) not w l lt 1 
 replot "CZFadl/PRMORPREV-1-STABLBASED_CZFadl.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "CZFadl/PRMORPREV-1-STABLBASED_CZFadl.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "CZFadl/VARMUPTJGR--STABLBASED_CZFadl1.svg";replot;set out;
