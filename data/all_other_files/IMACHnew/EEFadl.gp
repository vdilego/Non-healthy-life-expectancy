
# IMaCh-0.99r45
# EEFadl.gp
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


set ter svg size 640, 480;set out "EEFadl/D_EEFadl_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "EEFadl/ILK_EEFadl-dest.png";
set log y;plot  "EEFadl/ILK_EEFadl.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "EEFadl/ILK_EEFadl-ori.png";
set log y;plot  "EEFadl/ILK_EEFadl.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "EEFadl/ILK_EEFadl-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "EEFadl/ILK_EEFadl.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "EEFadl/ILK_EEFadl-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "EEFadl/ILK_EEFadl.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "EEFadl/V_EEFadl_1-1-1.svg" 

#set out "V_EEFadl_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "EEFadl/VPL_EEFadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"EEFadl/VPL_EEFadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"EEFadl/VPL_EEFadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"EEFadl/P_EEFadl.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "EEFadl/V_EEFadl_2-1-1.svg" 

#set out "V_EEFadl_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "EEFadl/VPL_EEFadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"EEFadl/VPL_EEFadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"EEFadl/VPL_EEFadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"EEFadl/P_EEFadl.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "EEFadl/E_EEFadl_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "EEFadl/T_EEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"EEFadl/T_EEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"EEFadl/T_EEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"EEFadl/T_EEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"EEFadl/T_EEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"EEFadl/T_EEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"EEFadl/T_EEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"EEFadl/T_EEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"EEFadl/T_EEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "EEFadl/E_EEFadl_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "EEFadl/EXP_EEFadl_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "EEFadl/E_EEFadl.txt" every :::0::0 u 1:2 t "e11" w l ,"EEFadl/E_EEFadl.txt" every :::0::0 u 1:3 t "e12" w l ,"EEFadl/E_EEFadl.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "EEFadl/EXP_EEFadl_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "EEFadl/E_EEFadl.txt" every :::0::0 u 1:5 t "e21" w l ,"EEFadl/E_EEFadl.txt" every :::0::0 u 1:6 t "e22" w l ,"EEFadl/E_EEFadl.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "EEFadl/LIJ_EEFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFadl/PIJ_EEFadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "EEFadl/LIJ_EEFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFadl/PIJ_EEFadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "EEFadl/LIJT_EEFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFadl/PIJ_EEFadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "EEFadl/LIJT_EEFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFadl/PIJ_EEFadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "EEFadl/P_EEFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFadl/PIJ_EEFadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "EEFadl/P_EEFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFadl/PIJ_EEFadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-7.215782; p2=0.054042; 
#   current state 3
p3=-11.101574; p4=0.091049; 
# initial state 2
#   current state 1
p5=-0.605487; p6=-0.017116; 
#   current state 3
p7=-11.916197; p8=0.113972; 
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

set out "EEFadl/PE_EEFadl_1-1-1.svg" 
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

set out "EEFadl/PE_EEFadl_1-2-1.svg" 
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

set out "EEFadl/PE_EEFadl_1-3-1.svg" 
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
set out "EEFadl/VARPIJGR_EEFadl_113-12.svg"
set label "50" at  2.828e-003, 2.165e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  2.828e-003+ 2.000*( 2.327e-002* 4.018e-003*cos(t)+ 9.997e-001* 1.043e-003*sin(t)),  2.165e-002 +2.000*(-9.997e-001* 4.018e-003*cos(t)+ 2.327e-002* 1.043e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  4.439e-003, 2.825e-002 center
replot  4.439e-003+ 2.000*( 2.643e-002* 4.260e-003*cos(t)+ 9.997e-001* 1.353e-003*sin(t)),  2.825e-002 +2.000*(-9.997e-001* 4.260e-003*cos(t)+ 2.643e-002* 1.353e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  6.960e-003, 3.680e-002 center
replot  6.960e-003+ 2.000*( 2.878e-002* 4.367e-003*cos(t)+ 9.996e-001* 1.694e-003*sin(t)),  3.680e-002 +2.000*(-9.996e-001* 4.367e-003*cos(t)+ 2.878e-002* 1.694e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.089e-002, 4.785e-002 center
replot  1.089e-002+ 2.000*( 3.021e-002* 4.395e-003*cos(t)+ 9.995e-001* 2.040e-003*sin(t)),  4.785e-002 +2.000*(-9.995e-001* 4.395e-003*cos(t)+ 3.021e-002* 2.040e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.699e-002, 6.204e-002 center
replot  1.699e-002+ 2.000*( 4.195e-002* 4.710e-003*cos(t)+ 9.991e-001* 2.433e-003*sin(t)),  6.204e-002 +2.000*(-9.991e-001* 4.710e-003*cos(t)+ 4.195e-002* 2.433e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.640e-002, 8.012e-002 center
replot  2.640e-002+ 2.000*( 9.217e-002* 6.201e-003*cos(t)+ 9.957e-001* 3.265e-003*sin(t)),  8.012e-002 +2.000*(-9.957e-001* 6.201e-003*cos(t)+ 9.217e-002* 3.265e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  4.080e-002, 1.029e-001 center
replot  4.080e-002+ 2.000*( 1.795e-001* 9.807e-003*cos(t)+ 9.837e-001* 5.598e-003*sin(t)),  1.029e-001 +2.000*(-9.837e-001* 9.807e-003*cos(t)+ 1.795e-001* 5.598e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  6.259e-002, 1.312e-001 center
replot  6.259e-002+ 2.000*( 3.262e-001* 1.622e-002*cos(t)+ 9.453e-001* 1.074e-002*sin(t)),  1.312e-001 +2.000*(-9.453e-001* 1.622e-002*cos(t)+ 3.262e-001* 1.074e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  9.502e-002, 1.656e-001 center
replot  9.502e-002+ 2.000*( 5.778e-001* 2.688e-002*cos(t)+ 8.162e-001* 1.951e-002*sin(t)),  1.656e-001 +2.000*(-8.162e-001* 2.688e-002*cos(t)+ 5.778e-001* 1.951e-002*sin(t)) not
set out;
set out "EEFadl/VARPIJGR_EEFadl_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "EEFadl/VARPIJGR_EEFadl_121-12.svg"
set label "50" at  3.759e-001, 2.165e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  3.759e-001+ 2.000*( 9.999e-001* 6.705e-002*cos(t)+-1.417e-002* 3.904e-003*sin(t)),  2.165e-002 +2.000*( 1.417e-002* 6.705e-002*cos(t)+ 9.999e-001* 3.904e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.501e-001, 2.825e-002 center
replot  3.501e-001+ 2.000*( 9.998e-001* 5.238e-002*cos(t)+-1.940e-002* 4.136e-003*sin(t)),  2.825e-002 +2.000*( 1.940e-002* 5.238e-002*cos(t)+ 9.998e-001* 4.136e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.253e-001, 3.680e-002 center
replot  3.253e-001+ 2.000*( 9.996e-001* 3.977e-002*cos(t)+-2.659e-002* 4.237e-003*sin(t)),  3.680e-002 +2.000*( 2.659e-002* 3.977e-002*cos(t)+ 9.996e-001* 4.237e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.014e-001, 4.785e-002 center
replot  3.014e-001+ 2.000*( 9.993e-001* 2.975e-002*cos(t)+-3.662e-002* 4.259e-003*sin(t)),  4.785e-002 +2.000*( 3.662e-002* 2.975e-002*cos(t)+ 9.993e-001* 4.259e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.782e-001, 6.204e-002 center
replot  2.782e-001+ 2.000*( 9.987e-001* 2.328e-002*cos(t)+-5.151e-002* 4.557e-003*sin(t)),  6.204e-002 +2.000*( 5.151e-002* 2.328e-002*cos(t)+ 9.987e-001* 4.557e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.550e-001, 8.012e-002 center
replot  2.550e-001+ 2.000*( 9.972e-001* 2.129e-002*cos(t)+-7.542e-002* 5.987e-003*sin(t)),  8.012e-002 +2.000*( 7.542e-002* 2.129e-002*cos(t)+ 9.972e-001* 5.987e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.314e-001, 1.029e-001 center
replot  2.314e-001+ 2.000*( 9.934e-001* 2.301e-002*cos(t)+-1.146e-001* 9.396e-003*sin(t)),  1.029e-001 +2.000*( 1.146e-001* 2.301e-002*cos(t)+ 9.934e-001* 9.396e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  2.063e-001, 1.312e-001 center
replot  2.063e-001+ 2.000*( 9.821e-001* 2.629e-002*cos(t)+-1.882e-001* 1.520e-002*sin(t)),  1.312e-001 +2.000*( 1.882e-001* 2.629e-002*cos(t)+ 9.821e-001* 1.520e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.789e-001, 1.656e-001 center
replot  1.789e-001+ 2.000*( 9.122e-001* 2.989e-002*cos(t)+-4.098e-001* 2.347e-002*sin(t)),  1.656e-001 +2.000*( 4.098e-001* 2.989e-002*cos(t)+ 9.122e-001* 2.347e-002*sin(t)) not
set out;
set out "EEFadl/VARPIJGR_EEFadl_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "EEFadl/VARPIJGR_EEFadl_123-12.svg"
set label "50" at  3.232e-003, 2.165e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  3.232e-003+ 2.000*( 9.175e-002* 4.027e-003*cos(t)+-9.958e-001* 2.631e-003*sin(t)),  2.165e-002 +2.000*( 9.958e-001* 4.027e-003*cos(t)+ 9.175e-002* 2.631e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  5.797e-003, 2.825e-002 center
replot  5.797e-003+ 2.000*( 4.699e-001* 4.340e-003*cos(t)+-8.827e-001* 3.956e-003*sin(t)),  2.825e-002 +2.000*( 8.827e-001* 4.340e-003*cos(t)+ 4.699e-001* 3.956e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  1.037e-002, 3.680e-002 center
replot  1.037e-002+ 2.000*( 9.940e-001* 6.007e-003*cos(t)+-1.092e-001* 4.341e-003*sin(t)),  3.680e-002 +2.000*( 1.092e-001* 6.007e-003*cos(t)+ 9.940e-001* 4.341e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.852e-002, 4.785e-002 center
replot  1.852e-002+ 2.000*( 9.990e-001* 8.495e-003*cos(t)+-4.369e-002* 4.382e-003*sin(t)),  4.785e-002 +2.000*( 4.369e-002* 8.495e-003*cos(t)+ 9.990e-001* 4.382e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  3.291e-002, 6.204e-002 center
replot  3.291e-002+ 2.000*( 9.997e-001* 1.128e-002*cos(t)+-2.403e-002* 4.700e-003*sin(t)),  6.204e-002 +2.000*( 2.403e-002* 1.128e-002*cos(t)+ 9.997e-001* 4.700e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  5.811e-002, 8.012e-002 center
replot  5.811e-002+ 2.000*( 9.997e-001* 1.363e-002*cos(t)+-2.507e-002* 6.174e-003*sin(t)),  8.012e-002 +2.000*( 2.507e-002* 1.363e-002*cos(t)+ 9.997e-001* 6.174e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.015e-001, 1.029e-001 center
replot  1.015e-001+ 2.000*( 9.954e-001* 1.529e-002*cos(t)+-9.589e-002* 9.633e-003*sin(t)),  1.029e-001 +2.000*( 9.589e-002* 1.529e-002*cos(t)+ 9.954e-001* 9.633e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.744e-001, 1.312e-001 center
replot  1.744e-001+ 2.000*( 9.806e-001* 2.358e-002*cos(t)+-1.961e-001* 1.533e-002*sin(t)),  1.312e-001 +2.000*( 1.961e-001* 2.358e-002*cos(t)+ 9.806e-001* 1.533e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.913e-001, 1.656e-001 center
replot  2.913e-001+ 2.000*( 9.949e-001* 5.450e-002*cos(t)+-1.007e-001* 2.417e-002*sin(t)),  1.656e-001 +2.000*( 1.007e-001* 5.450e-002*cos(t)+ 9.949e-001* 2.417e-002*sin(t)) not
set out;
set out "EEFadl/VARPIJGR_EEFadl_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "EEFadl/VARPIJGR_EEFadl_121-13.svg"
set label "50" at  3.759e-001, 2.828e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  3.759e-001+ 2.000*( 1.000e+000* 6.705e-002*cos(t)+-1.012e-003* 1.045e-003*sin(t)),  2.828e-003 +2.000*( 1.012e-003* 6.705e-002*cos(t)+ 1.000e+000* 1.045e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.501e-001, 4.439e-003 center
replot  3.501e-001+ 2.000*( 1.000e+000* 5.237e-002*cos(t)+-1.642e-003* 1.355e-003*sin(t)),  4.439e-003 +2.000*( 1.642e-003* 5.237e-002*cos(t)+ 1.000e+000* 1.355e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.253e-001, 6.960e-003 center
replot  3.253e-001+ 2.000*( 1.000e+000* 3.976e-002*cos(t)+-2.683e-003* 1.694e-003*sin(t)),  6.960e-003 +2.000*( 2.683e-003* 3.976e-002*cos(t)+ 1.000e+000* 1.694e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.014e-001, 1.089e-002 center
replot  3.014e-001+ 2.000*( 1.000e+000* 2.973e-002*cos(t)+-4.487e-003* 2.039e-003*sin(t)),  1.089e-002 +2.000*( 4.487e-003* 2.973e-002*cos(t)+ 1.000e+000* 2.039e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.782e-001, 1.699e-002 center
replot  2.782e-001+ 2.000*( 1.000e+000* 2.325e-002*cos(t)+-7.915e-003* 2.432e-003*sin(t)),  1.699e-002 +2.000*( 7.915e-003* 2.325e-002*cos(t)+ 1.000e+000* 2.432e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.550e-001, 2.640e-002 center
replot  2.550e-001+ 2.000*( 9.999e-001* 2.124e-002*cos(t)+-1.476e-002* 3.287e-003*sin(t)),  2.640e-002 +2.000*( 1.476e-002* 2.124e-002*cos(t)+ 9.999e-001* 3.287e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.314e-001, 4.080e-002 center
replot  2.314e-001+ 2.000*( 9.996e-001* 2.289e-002*cos(t)+-2.880e-002* 5.746e-003*sin(t)),  4.080e-002 +2.000*( 2.880e-002* 2.289e-002*cos(t)+ 9.996e-001* 5.746e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  2.063e-001, 6.259e-002 center
replot  2.063e-001+ 2.000*( 9.979e-001* 2.602e-002*cos(t)+-6.549e-002* 1.134e-002*sin(t)),  6.259e-002 +2.000*( 6.549e-002* 2.602e-002*cos(t)+ 9.979e-001* 1.134e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.789e-001, 9.502e-002 center
replot  1.789e-001+ 2.000*( 9.687e-001* 2.932e-002*cos(t)+-2.483e-001* 2.170e-002*sin(t)),  9.502e-002 +2.000*( 2.483e-001* 2.932e-002*cos(t)+ 9.687e-001* 2.170e-002*sin(t)) not
set out;
set out "EEFadl/VARPIJGR_EEFadl_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "EEFadl/VARPIJGR_EEFadl_123-13.svg"
set label "50" at  3.232e-003, 2.828e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  3.232e-003+ 2.000*( 9.911e-001* 2.666e-003*cos(t)+ 1.334e-001* 9.937e-004*sin(t)),  2.828e-003 +2.000*(-1.334e-001* 2.666e-003*cos(t)+ 9.911e-001* 9.937e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  5.797e-003, 4.439e-003 center
replot  5.797e-003+ 2.000*( 9.941e-001* 4.065e-003*cos(t)+ 1.084e-001* 1.291e-003*sin(t)),  4.439e-003 +2.000*(-1.084e-001* 4.065e-003*cos(t)+ 9.941e-001* 1.291e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  1.037e-002, 6.960e-003 center
replot  1.037e-002+ 2.000*( 9.961e-001* 6.012e-003*cos(t)+ 8.831e-002* 1.619e-003*sin(t)),  6.960e-003 +2.000*(-8.831e-002* 6.012e-003*cos(t)+ 9.961e-001* 1.619e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.852e-002, 1.089e-002 center
replot  1.852e-002+ 2.000*( 9.974e-001* 8.510e-003*cos(t)+ 7.203e-002* 1.954e-003*sin(t)),  1.089e-002 +2.000*(-7.203e-002* 8.510e-003*cos(t)+ 9.974e-001* 1.954e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  3.291e-002, 1.699e-002 center
replot  3.291e-002+ 2.000*( 9.982e-001* 1.129e-002*cos(t)+ 5.984e-002* 2.348e-003*sin(t)),  1.699e-002 +2.000*(-5.984e-002* 1.129e-002*cos(t)+ 9.982e-001* 2.348e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  5.811e-002, 2.640e-002 center
replot  5.811e-002+ 2.000*( 9.983e-001* 1.365e-002*cos(t)+ 5.752e-002* 3.212e-003*sin(t)),  2.640e-002 +2.000*(-5.752e-002* 1.365e-002*cos(t)+ 9.983e-001* 3.212e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.015e-001, 4.080e-002 center
replot  1.015e-001+ 2.000*( 9.948e-001* 1.532e-002*cos(t)+ 1.014e-001* 5.598e-003*sin(t)),  4.080e-002 +2.000*(-1.014e-001* 1.532e-002*cos(t)+ 9.948e-001* 5.598e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.744e-001, 6.259e-002 center
replot  1.744e-001+ 2.000*( 9.812e-001* 2.368e-002*cos(t)+ 1.931e-001* 1.070e-002*sin(t)),  6.259e-002 +2.000*(-1.931e-001* 2.368e-002*cos(t)+ 9.812e-001* 1.070e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.913e-001, 9.502e-002 center
replot  2.913e-001+ 2.000*( 9.883e-001* 5.483e-002*cos(t)+ 1.527e-001* 2.085e-002*sin(t)),  9.502e-002 +2.000*(-1.527e-001* 5.483e-002*cos(t)+ 9.883e-001* 2.085e-002*sin(t)) not
set out;
set out "EEFadl/VARPIJGR_EEFadl_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "EEFadl/VARPIJGR_EEFadl_123-21.svg"
set label "50" at  3.232e-003, 3.759e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  3.232e-003+ 2.000*( 3.987e-003* 6.705e-002*cos(t)+ 1.000e+000* 2.632e-003*sin(t)),  3.759e-001 +2.000*(-1.000e+000* 6.705e-002*cos(t)+ 3.987e-003* 2.632e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  5.797e-003, 3.501e-001 center
replot  5.797e-003+ 2.000*( 8.134e-003* 5.237e-002*cos(t)+ 1.000e+000* 4.021e-003*sin(t)),  3.501e-001 +2.000*(-1.000e+000* 5.237e-002*cos(t)+ 8.134e-003* 4.021e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  1.037e-002, 3.253e-001 center
replot  1.037e-002+ 2.000*( 1.755e-002* 3.976e-002*cos(t)+ 9.998e-001* 5.950e-003*sin(t)),  3.253e-001 +2.000*(-9.998e-001* 3.976e-002*cos(t)+ 1.755e-002* 5.950e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.852e-002, 3.014e-001 center
replot  1.852e-002+ 2.000*( 4.032e-002* 2.975e-002*cos(t)+ 9.992e-001* 8.411e-003*sin(t)),  3.014e-001 +2.000*(-9.992e-001* 2.975e-002*cos(t)+ 4.032e-002* 8.411e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  3.291e-002, 2.782e-001 center
replot  3.291e-002+ 2.000*( 9.272e-002* 2.333e-002*cos(t)+ 9.957e-001* 1.111e-002*sin(t)),  2.782e-001 +2.000*(-9.957e-001* 2.333e-002*cos(t)+ 9.272e-002* 1.111e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  5.811e-002, 2.550e-001 center
replot  5.811e-002+ 2.000*( 1.590e-001* 2.140e-002*cos(t)+ 9.873e-001* 1.336e-002*sin(t)),  2.550e-001 +2.000*(-9.873e-001* 2.140e-002*cos(t)+ 1.590e-001* 1.336e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.015e-001, 2.314e-001 center
replot  1.015e-001+ 2.000*( 1.657e-001* 2.307e-002*cos(t)+ 9.862e-001* 1.497e-002*sin(t)),  2.314e-001 +2.000*(-9.862e-001* 2.307e-002*cos(t)+ 1.657e-001* 1.497e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.744e-001, 2.063e-001 center
replot  1.744e-001+ 2.000*( 4.739e-001* 2.698e-002*cos(t)+ 8.806e-001* 2.215e-002*sin(t)),  2.063e-001 +2.000*(-8.806e-001* 2.698e-002*cos(t)+ 4.739e-001* 2.215e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.913e-001, 1.789e-001 center
replot  2.913e-001+ 2.000*( 9.846e-001* 5.491e-002*cos(t)+ 1.750e-001* 2.769e-002*sin(t)),  1.789e-001 +2.000*(-1.750e-001* 5.491e-002*cos(t)+ 9.846e-001* 2.769e-002*sin(t)) not
set out;
set out "EEFadl/VARPIJGR_EEFadl_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "EEFadl/VARMUPTJGR--STABLBASED_EEFadl1.svg";
 plot "EEFadl/PRMORPREV-1-STABLBASED_EEFadl.txt"  u 1:($3) not w l lt 1 
 replot "EEFadl/PRMORPREV-1-STABLBASED_EEFadl.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "EEFadl/PRMORPREV-1-STABLBASED_EEFadl.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "EEFadl/VARMUPTJGR--STABLBASED_EEFadl1.svg";replot;set out;
