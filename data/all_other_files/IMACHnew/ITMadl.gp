
# IMaCh-0.99r45
# ITMadl.gp
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


set ter svg size 640, 480;set out "ITMadl/D_ITMadl_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "ITMadl/ILK_ITMadl-dest.png";
set log y;plot  "ITMadl/ILK_ITMadl.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "ITMadl/ILK_ITMadl-ori.png";
set log y;plot  "ITMadl/ILK_ITMadl.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "ITMadl/ILK_ITMadl-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ITMadl/ILK_ITMadl.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "ITMadl/ILK_ITMadl-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ITMadl/ILK_ITMadl.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "ITMadl/V_ITMadl_1-1-1.svg" 

#set out "V_ITMadl_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ITMadl/VPL_ITMadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"ITMadl/VPL_ITMadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"ITMadl/VPL_ITMadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"ITMadl/P_ITMadl.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "ITMadl/V_ITMadl_2-1-1.svg" 

#set out "V_ITMadl_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ITMadl/VPL_ITMadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"ITMadl/VPL_ITMadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"ITMadl/VPL_ITMadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"ITMadl/P_ITMadl.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "ITMadl/E_ITMadl_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "ITMadl/T_ITMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"ITMadl/T_ITMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"ITMadl/T_ITMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"ITMadl/T_ITMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"ITMadl/T_ITMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"ITMadl/T_ITMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"ITMadl/T_ITMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"ITMadl/T_ITMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"ITMadl/T_ITMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "ITMadl/E_ITMadl_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "ITMadl/EXP_ITMadl_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ITMadl/E_ITMadl.txt" every :::0::0 u 1:2 t "e11" w l ,"ITMadl/E_ITMadl.txt" every :::0::0 u 1:3 t "e12" w l ,"ITMadl/E_ITMadl.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "ITMadl/EXP_ITMadl_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ITMadl/E_ITMadl.txt" every :::0::0 u 1:5 t "e21" w l ,"ITMadl/E_ITMadl.txt" every :::0::0 u 1:6 t "e22" w l ,"ITMadl/E_ITMadl.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "ITMadl/LIJ_ITMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMadl/PIJ_ITMadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "ITMadl/LIJ_ITMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMadl/PIJ_ITMadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "ITMadl/LIJT_ITMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMadl/PIJ_ITMadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "ITMadl/LIJT_ITMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMadl/PIJ_ITMadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "ITMadl/P_ITMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMadl/PIJ_ITMadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "ITMadl/P_ITMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMadl/PIJ_ITMadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-8.641874; p2=0.062556; 
#   current state 3
p3=-13.943865; p4=0.128191; 
# initial state 2
#   current state 1
p5=-0.788005; p6=-0.014383; 
#   current state 3
p7=-8.040239; p8=0.065601; 
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

set out "ITMadl/PE_ITMadl_1-1-1.svg" 
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

set out "ITMadl/PE_ITMadl_1-2-1.svg" 
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

set out "ITMadl/PE_ITMadl_1-3-1.svg" 
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
set out "ITMadl/VARPIJGR_ITMadl_113-12.svg"
set label "50" at  1.064e-003, 8.023e-003 center
# Age 50, p13 - p12
plot [-pi:pi]  1.064e-003+ 2.000*( 1.278e-002* 2.567e-003*cos(t)+ 9.999e-001* 5.050e-004*sin(t)),  8.023e-003 +2.000*(-9.999e-001* 2.567e-003*cos(t)+ 1.278e-002* 5.050e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  2.016e-003, 1.095e-002 center
replot  2.016e-003+ 2.000*( 1.989e-002* 2.854e-003*cos(t)+ 9.998e-001* 7.990e-004*sin(t)),  1.095e-002 +2.000*(-9.998e-001* 2.854e-003*cos(t)+ 1.989e-002* 7.990e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  3.816e-003, 1.492e-002 center
replot  3.816e-003+ 2.000*( 3.336e-002* 3.070e-003*cos(t)+ 9.994e-001* 1.222e-003*sin(t)),  1.492e-002 +2.000*(-9.994e-001* 3.070e-003*cos(t)+ 3.336e-002* 1.222e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  7.211e-003, 2.031e-002 center
replot  7.211e-003+ 2.000*( 6.301e-002* 3.239e-003*cos(t)+ 9.980e-001* 1.788e-003*sin(t)),  2.031e-002 +2.000*(-9.980e-001* 3.239e-003*cos(t)+ 6.301e-002* 1.788e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.359e-002, 2.758e-002 center
replot  1.359e-002+ 2.000*( 1.250e-001* 3.621e-003*cos(t)+ 9.922e-001* 2.508e-003*sin(t)),  2.758e-002 +2.000*(-9.922e-001* 3.621e-003*cos(t)+ 1.250e-001* 2.508e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.552e-002, 3.729e-002 center
replot  2.552e-002+ 2.000*( 1.804e-001* 4.951e-003*cos(t)+ 9.836e-001* 3.627e-003*sin(t)),  3.729e-002 +2.000*(-9.836e-001* 4.951e-003*cos(t)+ 1.804e-001* 3.627e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  4.757e-002, 5.007e-002 center
replot  4.757e-002+ 2.000*( 3.134e-001* 8.203e-003*cos(t)+ 9.496e-001* 6.579e-003*sin(t)),  5.007e-002 +2.000*(-9.496e-001* 8.203e-003*cos(t)+ 3.134e-001* 6.579e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  8.763e-002, 6.643e-002 center
replot  8.763e-002+ 2.000*( 9.098e-001* 1.608e-002*cos(t)+ 4.151e-001* 1.312e-002*sin(t)),  6.643e-002 +2.000*(-4.151e-001* 1.608e-002*cos(t)+ 9.098e-001* 1.312e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.582e-001, 8.637e-002 center
replot  1.582e-001+ 2.000*( 9.834e-001* 3.668e-002*cos(t)+ 1.813e-001* 2.164e-002*sin(t)),  8.637e-002 +2.000*(-1.813e-001* 3.668e-002*cos(t)+ 9.834e-001* 2.164e-002*sin(t)) not
set out;
set out "ITMadl/VARPIJGR_ITMadl_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ITMadl/VARPIJGR_ITMadl_121-12.svg"
set label "50" at  3.602e-001, 8.023e-003 center
# Age 50, p21 - p12
plot [-pi:pi]  3.602e-001+ 2.000*( 1.000e+000* 1.009e-001*cos(t)+-5.837e-003* 2.498e-003*sin(t)),  8.023e-003 +2.000*( 5.837e-003* 1.009e-001*cos(t)+ 1.000e+000* 2.498e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.385e-001, 1.095e-002 center
replot  3.385e-001+ 2.000*( 1.000e+000* 7.955e-002*cos(t)+-8.329e-003* 2.775e-003*sin(t)),  1.095e-002 +2.000*( 8.329e-003* 7.955e-002*cos(t)+ 1.000e+000* 2.775e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.176e-001, 1.492e-002 center
replot  3.176e-001+ 2.000*( 9.999e-001* 6.117e-002*cos(t)+-1.183e-002* 2.982e-003*sin(t)),  1.492e-002 +2.000*( 1.183e-002* 6.117e-002*cos(t)+ 9.999e-001* 2.982e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.972e-001, 2.031e-002 center
replot  2.972e-001+ 2.000*( 9.999e-001* 4.665e-002*cos(t)+-1.658e-002* 3.141e-003*sin(t)),  2.031e-002 +2.000*( 1.658e-002* 4.665e-002*cos(t)+ 9.999e-001* 3.141e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.774e-001, 2.758e-002 center
replot  2.774e-001+ 2.000*( 9.997e-001* 3.753e-002*cos(t)+-2.268e-002* 3.506e-003*sin(t)),  2.758e-002 +2.000*( 2.268e-002* 3.753e-002*cos(t)+ 9.997e-001* 3.506e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.580e-001, 3.729e-002 center
replot  2.580e-001+ 2.000*( 9.995e-001* 3.520e-002*cos(t)+-3.084e-002* 4.794e-003*sin(t)),  3.729e-002 +2.000*( 3.084e-002* 3.520e-002*cos(t)+ 9.995e-001* 4.794e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.388e-001, 5.007e-002 center
replot  2.388e-001+ 2.000*( 9.991e-001* 3.859e-002*cos(t)+-4.337e-002* 7.890e-003*sin(t)),  5.007e-002 +2.000*( 4.337e-002* 3.859e-002*cos(t)+ 9.991e-001* 7.890e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  2.197e-001, 6.643e-002 center
replot  2.197e-001+ 2.000*( 9.980e-001* 4.477e-002*cos(t)+-6.249e-002* 1.342e-002*sin(t)),  6.643e-002 +2.000*( 6.249e-002* 4.477e-002*cos(t)+ 9.980e-001* 1.342e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  2.006e-001, 8.637e-002 center
replot  2.006e-001+ 2.000*( 9.959e-001* 5.149e-002*cos(t)+-9.099e-002* 2.189e-002*sin(t)),  8.637e-002 +2.000*( 9.099e-002* 5.149e-002*cos(t)+ 9.959e-001* 2.189e-002*sin(t)) not
set out;
set out "ITMadl/VARPIJGR_ITMadl_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ITMadl/VARPIJGR_ITMadl_123-12.svg"
set label "50" at  1.392e-002, 8.023e-003 center
# Age 50, p23 - p12
plot [-pi:pi]  1.392e-002+ 2.000*( 9.999e-001* 1.274e-002*cos(t)+-1.702e-002* 2.558e-003*sin(t)),  8.023e-003 +2.000*( 1.702e-002* 1.274e-002*cos(t)+ 9.999e-001* 2.558e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.952e-002, 1.095e-002 center
replot  1.952e-002+ 2.000*( 9.999e-001* 1.518e-002*cos(t)+-1.677e-002* 2.842e-003*sin(t)),  1.095e-002 +2.000*( 1.677e-002* 1.518e-002*cos(t)+ 9.999e-001* 2.842e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  2.732e-002, 1.492e-002 center
replot  2.732e-002+ 2.000*( 9.999e-001* 1.757e-002*cos(t)+-1.688e-002* 3.054e-003*sin(t)),  1.492e-002 +2.000*( 1.688e-002* 1.757e-002*cos(t)+ 9.999e-001* 3.054e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  3.814e-002, 2.031e-002 center
replot  3.814e-002+ 2.000*( 9.998e-001* 1.959e-002*cos(t)+-1.792e-002* 3.216e-003*sin(t)),  2.031e-002 +2.000*( 1.792e-002* 1.959e-002*cos(t)+ 9.998e-001* 3.216e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  5.310e-002, 2.758e-002 center
replot  5.310e-002+ 2.000*( 9.998e-001* 2.091e-002*cos(t)+-2.145e-002* 3.579e-003*sin(t)),  2.758e-002 +2.000*( 2.145e-002* 2.091e-002*cos(t)+ 9.998e-001* 3.579e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  7.366e-002, 3.729e-002 center
replot  7.366e-002+ 2.000*( 9.995e-001* 2.165e-002*cos(t)+-3.185e-002* 4.867e-003*sin(t)),  3.729e-002 +2.000*( 3.185e-002* 2.165e-002*cos(t)+ 9.995e-001* 4.867e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.017e-001, 5.007e-002 center
replot  1.017e-001+ 2.000*( 9.985e-001* 2.422e-002*cos(t)+-5.391e-002* 7.963e-003*sin(t)),  5.007e-002 +2.000*( 5.391e-002* 2.422e-002*cos(t)+ 9.985e-001* 7.963e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.396e-001, 6.643e-002 center
replot  1.396e-001+ 2.000*( 9.978e-001* 3.506e-002*cos(t)+-6.620e-002* 1.351e-002*sin(t)),  6.643e-002 +2.000*( 6.620e-002* 3.506e-002*cos(t)+ 9.978e-001* 1.351e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.901e-001, 8.637e-002 center
replot  1.901e-001+ 2.000*( 9.983e-001* 6.031e-002*cos(t)+-5.893e-002* 2.205e-002*sin(t)),  8.637e-002 +2.000*( 5.893e-002* 6.031e-002*cos(t)+ 9.983e-001* 2.205e-002*sin(t)) not
set out;
set out "ITMadl/VARPIJGR_ITMadl_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ITMadl/VARPIJGR_ITMadl_121-13.svg"
set label "50" at  3.602e-001, 1.064e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  3.602e-001+ 2.000*( 1.000e+000* 1.009e-001*cos(t)+-2.015e-004* 5.056e-004*sin(t)),  1.064e-003 +2.000*( 2.015e-004* 1.009e-001*cos(t)+ 1.000e+000* 5.056e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.385e-001, 2.016e-003 center
replot  3.385e-001+ 2.000*( 1.000e+000* 7.954e-002*cos(t)+-3.413e-004* 8.004e-004*sin(t)),  2.016e-003 +2.000*( 3.413e-004* 7.954e-002*cos(t)+ 1.000e+000* 8.004e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.176e-001, 3.816e-003 center
replot  3.176e-001+ 2.000*( 1.000e+000* 6.116e-002*cos(t)+-5.461e-004* 1.225e-003*sin(t)),  3.816e-003 +2.000*( 5.461e-004* 6.116e-002*cos(t)+ 1.000e+000* 1.225e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.972e-001, 7.211e-003 center
replot  2.972e-001+ 2.000*( 1.000e+000* 4.664e-002*cos(t)+-9.311e-004* 1.796e-003*sin(t)),  7.211e-003 +2.000*( 9.311e-004* 4.664e-002*cos(t)+ 1.000e+000* 1.796e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.774e-001, 1.359e-002 center
replot  2.774e-001+ 2.000*( 1.000e+000* 3.752e-002*cos(t)+-2.626e-003* 2.527e-003*sin(t)),  1.359e-002 +2.000*( 2.626e-003* 3.752e-002*cos(t)+ 1.000e+000* 2.527e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.580e-001, 2.552e-002 center
replot  2.580e-001+ 2.000*( 1.000e+000* 3.518e-002*cos(t)+-9.874e-003* 3.661e-003*sin(t)),  2.552e-002 +2.000*( 9.874e-003* 3.518e-002*cos(t)+ 1.000e+000* 3.661e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.388e-001, 4.757e-002 center
replot  2.388e-001+ 2.000*( 9.996e-001* 3.857e-002*cos(t)+-2.838e-002* 6.669e-003*sin(t)),  4.757e-002 +2.000*( 2.838e-002* 3.857e-002*cos(t)+ 9.996e-001* 6.669e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  2.197e-001, 8.763e-002 center
replot  2.197e-001+ 2.000*( 9.976e-001* 4.478e-002*cos(t)+-6.962e-002* 1.533e-002*sin(t)),  8.763e-002 +2.000*( 6.962e-002* 4.478e-002*cos(t)+ 9.976e-001* 1.533e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  2.006e-001, 1.582e-001 center
replot  2.006e-001+ 2.000*( 9.737e-001* 5.205e-002*cos(t)+-2.279e-001* 3.522e-002*sin(t)),  1.582e-001 +2.000*( 2.279e-001* 5.205e-002*cos(t)+ 9.737e-001* 3.522e-002*sin(t)) not
set out;
set out "ITMadl/VARPIJGR_ITMadl_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ITMadl/VARPIJGR_ITMadl_123-13.svg"
set label "50" at  1.392e-002, 1.064e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  1.392e-002+ 2.000*( 1.000e+000* 1.274e-002*cos(t)+ 8.603e-003* 4.940e-004*sin(t)),  1.064e-003 +2.000*(-8.603e-003* 1.274e-002*cos(t)+ 1.000e+000* 4.940e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.952e-002, 2.016e-003 center
replot  1.952e-002+ 2.000*( 9.999e-001* 1.518e-002*cos(t)+ 1.146e-002* 7.818e-004*sin(t)),  2.016e-003 +2.000*(-1.146e-002* 1.518e-002*cos(t)+ 9.999e-001* 7.818e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  2.732e-002, 3.816e-003 center
replot  2.732e-002+ 2.000*( 9.999e-001* 1.757e-002*cos(t)+ 1.528e-002* 1.196e-003*sin(t)),  3.816e-003 +2.000*(-1.528e-002* 1.757e-002*cos(t)+ 9.999e-001* 1.196e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  3.814e-002, 7.211e-003 center
replot  3.814e-002+ 2.000*( 9.998e-001* 1.960e-002*cos(t)+ 2.056e-002* 1.751e-003*sin(t)),  7.211e-003 +2.000*(-2.056e-002* 1.960e-002*cos(t)+ 9.998e-001* 1.751e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  5.310e-002, 1.359e-002 center
replot  5.310e-002+ 2.000*( 9.996e-001* 2.091e-002*cos(t)+ 2.868e-002* 2.458e-003*sin(t)),  1.359e-002 +2.000*(-2.868e-002* 2.091e-002*cos(t)+ 9.996e-001* 2.458e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  7.366e-002, 2.552e-002 center
replot  7.366e-002+ 2.000*( 9.990e-001* 2.167e-002*cos(t)+ 4.505e-002* 3.549e-003*sin(t)),  2.552e-002 +2.000*(-4.505e-002* 2.167e-002*cos(t)+ 9.990e-001* 3.549e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.017e-001, 4.757e-002 center
replot  1.017e-001+ 2.000*( 9.963e-001* 2.427e-002*cos(t)+ 8.625e-002* 6.447e-003*sin(t)),  4.757e-002 +2.000*(-8.625e-002* 2.427e-002*cos(t)+ 9.963e-001* 6.447e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.396e-001, 8.763e-002 center
replot  1.396e-001+ 2.000*( 9.876e-001* 3.535e-002*cos(t)+ 1.571e-001* 1.477e-002*sin(t)),  8.763e-002 +2.000*(-1.571e-001* 3.535e-002*cos(t)+ 9.876e-001* 1.477e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.901e-001, 1.582e-001 center
replot  1.901e-001+ 2.000*( 9.709e-001* 6.144e-002*cos(t)+ 2.394e-001* 3.417e-002*sin(t)),  1.582e-001 +2.000*(-2.394e-001* 6.144e-002*cos(t)+ 9.709e-001* 3.417e-002*sin(t)) not
set out;
set out "ITMadl/VARPIJGR_ITMadl_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "ITMadl/VARPIJGR_ITMadl_123-21.svg"
set label "50" at  1.392e-002, 3.602e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.392e-002+ 2.000*( 8.169e-003* 1.009e-001*cos(t)+ 1.000e+000* 1.271e-002*sin(t)),  3.602e-001 +2.000*(-1.000e+000* 1.009e-001*cos(t)+ 8.169e-003* 1.271e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.952e-002, 3.385e-001 center
replot  1.952e-002+ 2.000*( 1.267e-002* 7.955e-002*cos(t)+ 9.999e-001* 1.515e-002*sin(t)),  3.385e-001 +2.000*(-9.999e-001* 7.955e-002*cos(t)+ 1.267e-002* 1.515e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  2.732e-002, 3.176e-001 center
replot  2.732e-002+ 2.000*( 2.166e-002* 6.118e-002*cos(t)+ 9.998e-001* 1.752e-002*sin(t)),  3.176e-001 +2.000*(-9.998e-001* 6.118e-002*cos(t)+ 2.166e-002* 1.752e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  3.814e-002, 2.972e-001 center
replot  3.814e-002+ 2.000*( 4.245e-002* 4.667e-002*cos(t)+ 9.991e-001* 1.951e-002*sin(t)),  2.972e-001 +2.000*(-9.991e-001* 4.667e-002*cos(t)+ 4.245e-002* 1.951e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  5.310e-002, 2.774e-001 center
replot  5.310e-002+ 2.000*( 9.003e-002* 3.762e-002*cos(t)+ 9.959e-001* 2.071e-002*sin(t)),  2.774e-001 +2.000*(-9.959e-001* 3.762e-002*cos(t)+ 9.003e-002* 2.071e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  7.366e-002, 2.580e-001 center
replot  7.366e-002+ 2.000*( 1.545e-001* 3.545e-002*cos(t)+ 9.880e-001* 2.119e-002*sin(t)),  2.580e-001 +2.000*(-9.880e-001* 3.545e-002*cos(t)+ 1.545e-001* 2.119e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.017e-001, 2.388e-001 center
replot  1.017e-001+ 2.000*( 2.159e-001* 3.915e-002*cos(t)+ 9.764e-001* 2.321e-002*sin(t)),  2.388e-001 +2.000*(-9.764e-001* 3.915e-002*cos(t)+ 2.159e-001* 2.321e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.396e-001, 2.197e-001 center
replot  1.396e-001+ 2.000*( 3.985e-001* 4.666e-002*cos(t)+ 9.171e-001* 3.232e-002*sin(t)),  2.197e-001 +2.000*(-9.171e-001* 4.666e-002*cos(t)+ 3.985e-001* 3.232e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.901e-001, 2.006e-001 center
replot  1.901e-001+ 2.000*( 8.639e-001* 6.432e-002*cos(t)+ 5.037e-001* 4.606e-002*sin(t)),  2.006e-001 +2.000*(-5.037e-001* 6.432e-002*cos(t)+ 8.639e-001* 4.606e-002*sin(t)) not
set out;
set out "ITMadl/VARPIJGR_ITMadl_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "ITMadl/VARMUPTJGR--STABLBASED_ITMadl1.svg";
 plot "ITMadl/PRMORPREV-1-STABLBASED_ITMadl.txt"  u 1:($3) not w l lt 1 
 replot "ITMadl/PRMORPREV-1-STABLBASED_ITMadl.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "ITMadl/PRMORPREV-1-STABLBASED_ITMadl.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "ITMadl/VARMUPTJGR--STABLBASED_ITMadl1.svg";replot;set out;
