
# IMaCh-0.99r45
# BEMgali.gp
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


set ter svg size 640, 480;set out "BEMgali/D_BEMgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "BEMgali/ILK_BEMgali-dest.png";
set log y;plot  "BEMgali/ILK_BEMgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "BEMgali/ILK_BEMgali-ori.png";
set log y;plot  "BEMgali/ILK_BEMgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "BEMgali/ILK_BEMgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "BEMgali/ILK_BEMgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "BEMgali/ILK_BEMgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "BEMgali/ILK_BEMgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "BEMgali/V_BEMgali_1-1-1.svg" 

#set out "V_BEMgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "BEMgali/VPL_BEMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"BEMgali/VPL_BEMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"BEMgali/VPL_BEMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"BEMgali/P_BEMgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "BEMgali/V_BEMgali_2-1-1.svg" 

#set out "V_BEMgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "BEMgali/VPL_BEMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"BEMgali/VPL_BEMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"BEMgali/VPL_BEMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"BEMgali/P_BEMgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "BEMgali/E_BEMgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "BEMgali/T_BEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"BEMgali/T_BEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"BEMgali/T_BEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"BEMgali/T_BEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"BEMgali/T_BEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"BEMgali/T_BEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"BEMgali/T_BEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"BEMgali/T_BEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"BEMgali/T_BEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "BEMgali/E_BEMgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "BEMgali/EXP_BEMgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "BEMgali/E_BEMgali.txt" every :::0::0 u 1:2 t "e11" w l ,"BEMgali/E_BEMgali.txt" every :::0::0 u 1:3 t "e12" w l ,"BEMgali/E_BEMgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "BEMgali/EXP_BEMgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "BEMgali/E_BEMgali.txt" every :::0::0 u 1:5 t "e21" w l ,"BEMgali/E_BEMgali.txt" every :::0::0 u 1:6 t "e22" w l ,"BEMgali/E_BEMgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "BEMgali/LIJ_BEMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEMgali/PIJ_BEMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "BEMgali/LIJ_BEMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEMgali/PIJ_BEMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "BEMgali/LIJT_BEMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEMgali/PIJ_BEMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "BEMgali/LIJT_BEMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEMgali/PIJ_BEMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "BEMgali/P_BEMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEMgali/PIJ_BEMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "BEMgali/P_BEMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEMgali/PIJ_BEMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-5.280905; p2=0.027239; 
#   current state 3
p3=-15.283380; p4=0.140754; 
# initial state 2
#   current state 1
p5=-1.026096; p6=-0.010699; 
#   current state 3
p7=-6.813192; p8=0.057121; 
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

set out "BEMgali/PE_BEMgali_1-1-1.svg" 
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

set out "BEMgali/PE_BEMgali_1-2-1.svg" 
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

set out "BEMgali/PE_BEMgali_1-3-1.svg" 
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
set out "BEMgali/VARPIJGR_BEMgali_113-12.svg"
set label "50" at  5.144e-004, 3.894e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  5.144e-004+ 2.000*( 9.021e-003* 7.005e-003*cos(t)+ 1.000e+000* 4.024e-004*sin(t)),  3.894e-002 +2.000*(-1.000e+000* 7.005e-003*cos(t)+ 9.021e-003* 4.024e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.037e-003, 4.448e-002 center
replot  1.037e-003+ 2.000*( 1.921e-002* 6.365e-003*cos(t)+ 9.998e-001* 6.868e-004*sin(t)),  4.448e-002 +2.000*(-9.998e-001* 6.365e-003*cos(t)+ 1.921e-002* 6.868e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  2.088e-003, 5.078e-002 center
replot  2.088e-003+ 2.000*( 4.239e-002* 5.681e-003*cos(t)+ 9.991e-001* 1.136e-003*sin(t)),  5.078e-002 +2.000*(-9.991e-001* 5.681e-003*cos(t)+ 4.239e-002* 1.136e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  4.200e-003, 5.791e-002 center
replot  4.200e-003+ 2.000*( 8.902e-002* 5.321e-003*cos(t)+ 9.960e-001* 1.803e-003*sin(t)),  5.791e-002 +2.000*(-9.960e-001* 5.321e-003*cos(t)+ 8.902e-002* 1.803e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  8.435e-003, 6.594e-002 center
replot  8.435e-003+ 2.000*( 1.389e-001* 5.968e-003*cos(t)+ 9.903e-001* 2.737e-003*sin(t)),  6.594e-002 +2.000*(-9.903e-001* 5.968e-003*cos(t)+ 1.389e-001* 2.737e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.690e-002, 7.488e-002 center
replot  1.690e-002+ 2.000*( 1.526e-001* 8.085e-003*cos(t)+ 9.883e-001* 4.025e-003*sin(t)),  7.488e-002 +2.000*(-9.883e-001* 8.085e-003*cos(t)+ 1.526e-001* 4.025e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.368e-002, 8.462e-002 center
replot  3.368e-002+ 2.000*( 1.844e-001* 1.164e-002*cos(t)+ 9.828e-001* 6.397e-003*sin(t)),  8.462e-002 +2.000*(-9.828e-001* 1.164e-002*cos(t)+ 1.844e-001* 6.397e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  6.652e-002, 9.475e-002 center
replot  6.652e-002+ 2.000*( 5.041e-001* 1.706e-002*cos(t)+ 8.637e-001* 1.320e-002*sin(t)),  9.475e-002 +2.000*(-8.637e-001* 1.706e-002*cos(t)+ 5.041e-001* 1.320e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.292e-001, 1.043e-001 center
replot  1.292e-001+ 2.000*( 9.768e-001* 3.661e-002*cos(t)+ 2.141e-001* 2.084e-002*sin(t)),  1.043e-001 +2.000*(-2.141e-001* 3.661e-002*cos(t)+ 9.768e-001* 2.084e-002*sin(t)) not
set out;
set out "BEMgali/VARPIJGR_BEMgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "BEMgali/VARPIJGR_BEMgali_121-12.svg"
set label "50" at  3.416e-001, 3.894e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  3.416e-001+ 2.000*( 9.994e-001* 5.806e-002*cos(t)+-3.448e-002* 6.716e-003*sin(t)),  3.894e-002 +2.000*( 3.448e-002* 5.806e-002*cos(t)+ 9.994e-001* 6.716e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.250e-001, 4.448e-002 center
replot  3.250e-001+ 2.000*( 9.991e-001* 4.394e-002*cos(t)+-4.135e-002* 6.104e-003*sin(t)),  4.448e-002 +2.000*( 4.135e-002* 4.394e-002*cos(t)+ 9.991e-001* 6.104e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.086e-001, 5.078e-002 center
replot  3.086e-001+ 2.000*( 9.988e-001* 3.297e-002*cos(t)+-4.926e-002* 5.445e-003*sin(t)),  5.078e-002 +2.000*( 4.926e-002* 3.297e-002*cos(t)+ 9.988e-001* 5.445e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.922e-001, 5.791e-002 center
replot  2.922e-001+ 2.000*( 9.984e-001* 2.702e-002*cos(t)+-5.684e-002* 5.084e-003*sin(t)),  5.791e-002 +2.000*( 5.684e-002* 2.702e-002*cos(t)+ 9.984e-001* 5.084e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.757e-001, 6.594e-002 center
replot  2.757e-001+ 2.000*( 9.979e-001* 2.747e-002*cos(t)+-6.403e-002* 5.666e-003*sin(t)),  6.594e-002 +2.000*( 6.403e-002* 2.747e-002*cos(t)+ 9.979e-001* 5.666e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.590e-001, 7.488e-002 center
replot  2.590e-001+ 2.000*( 9.972e-001* 3.256e-002*cos(t)+-7.446e-002* 7.660e-003*sin(t)),  7.488e-002 +2.000*( 7.446e-002* 3.256e-002*cos(t)+ 9.972e-001* 7.660e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.420e-001, 8.462e-002 center
replot  2.420e-001+ 2.000*( 9.960e-001* 3.938e-002*cos(t)+-8.901e-002* 1.100e-002*sin(t)),  8.462e-002 +2.000*( 8.901e-002* 3.938e-002*cos(t)+ 9.960e-001* 1.100e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  2.246e-001, 9.475e-002 center
replot  2.246e-001+ 2.000*( 9.943e-001* 4.624e-002*cos(t)+-1.070e-001* 1.548e-002*sin(t)),  9.475e-002 +2.000*( 1.070e-001* 4.624e-002*cos(t)+ 9.943e-001* 1.548e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  2.066e-001, 1.043e-001 center
replot  2.066e-001+ 2.000*( 9.919e-001* 5.233e-002*cos(t)+-1.273e-001* 2.095e-002*sin(t)),  1.043e-001 +2.000*( 1.273e-001* 5.233e-002*cos(t)+ 9.919e-001* 2.095e-002*sin(t)) not
set out;
set out "BEMgali/VARPIJGR_BEMgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "BEMgali/VARPIJGR_BEMgali_123-12.svg"
set label "50" at  3.111e-002, 3.894e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  3.111e-002+ 2.000*( 9.963e-001* 1.192e-002*cos(t)+-8.620e-002* 6.954e-003*sin(t)),  3.894e-002 +2.000*( 8.620e-002* 1.192e-002*cos(t)+ 9.963e-001* 6.954e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  4.155e-002, 4.448e-002 center
replot  4.155e-002+ 2.000*( 9.979e-001* 1.317e-002*cos(t)+-6.521e-002* 6.319e-003*sin(t)),  4.448e-002 +2.000*( 6.521e-002* 1.317e-002*cos(t)+ 9.979e-001* 6.319e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  5.537e-002, 5.078e-002 center
replot  5.537e-002+ 2.000*( 9.984e-001* 1.415e-002*cos(t)+-5.579e-002* 5.630e-003*sin(t)),  5.078e-002 +2.000*( 5.579e-002* 1.415e-002*cos(t)+ 9.984e-001* 5.630e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  7.359e-002, 5.791e-002 center
replot  7.359e-002+ 2.000*( 9.984e-001* 1.492e-002*cos(t)+-5.647e-002* 5.244e-003*sin(t)),  5.791e-002 +2.000*( 5.647e-002* 1.492e-002*cos(t)+ 9.984e-001* 5.244e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  9.748e-002, 6.594e-002 center
replot  9.748e-002+ 2.000*( 9.976e-001* 1.616e-002*cos(t)+-6.911e-002* 5.830e-003*sin(t)),  6.594e-002 +2.000*( 6.911e-002* 1.616e-002*cos(t)+ 9.976e-001* 5.830e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.286e-001, 7.488e-002 center
replot  1.286e-001+ 2.000*( 9.964e-001* 1.985e-002*cos(t)+-8.447e-002* 7.865e-003*sin(t)),  7.488e-002 +2.000*( 8.447e-002* 1.985e-002*cos(t)+ 9.964e-001* 7.865e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.686e-001, 8.462e-002 center
replot  1.686e-001+ 2.000*( 9.967e-001* 2.882e-002*cos(t)+-8.140e-002* 1.130e-002*sin(t)),  8.462e-002 +2.000*( 8.140e-002* 2.882e-002*cos(t)+ 9.967e-001* 1.130e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  2.196e-001, 9.475e-002 center
replot  2.196e-001+ 2.000*( 9.977e-001* 4.509e-002*cos(t)+-6.798e-002* 1.591e-002*sin(t)),  9.475e-002 +2.000*( 6.798e-002* 4.509e-002*cos(t)+ 9.977e-001* 1.591e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.836e-001, 1.043e-001 center
replot  2.836e-001+ 2.000*( 9.983e-001* 6.982e-002*cos(t)+-5.794e-002* 2.147e-002*sin(t)),  1.043e-001 +2.000*( 5.794e-002* 6.982e-002*cos(t)+ 9.983e-001* 2.147e-002*sin(t)) not
set out;
set out "BEMgali/VARPIJGR_BEMgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "BEMgali/VARPIJGR_BEMgali_121-13.svg"
set label "50" at  3.416e-001, 5.144e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  3.416e-001+ 2.000*( 1.000e+000* 5.802e-002*cos(t)+-6.900e-005* 4.073e-004*sin(t)),  5.144e-004 +2.000*( 6.900e-005* 5.802e-002*cos(t)+ 1.000e+000* 4.073e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.250e-001, 1.037e-003 center
replot  3.250e-001+ 2.000*( 1.000e+000* 4.390e-002*cos(t)+-1.473e-004* 6.974e-004*sin(t)),  1.037e-003 +2.000*( 1.473e-004* 4.390e-002*cos(t)+ 1.000e+000* 6.974e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.086e-001, 2.088e-003 center
replot  3.086e-001+ 2.000*( 1.000e+000* 3.293e-002*cos(t)+-3.577e-004* 1.160e-003*sin(t)),  2.088e-003 +2.000*( 3.577e-004* 3.293e-002*cos(t)+ 1.000e+000* 1.160e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.922e-001, 4.200e-003 center
replot  2.922e-001+ 2.000*( 1.000e+000* 2.698e-002*cos(t)+-1.026e-003* 1.857e-003*sin(t)),  4.200e-003 +2.000*( 1.026e-003* 2.698e-002*cos(t)+ 1.000e+000* 1.857e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.757e-001, 8.435e-003 center
replot  2.757e-001+ 2.000*( 1.000e+000* 2.742e-002*cos(t)+-2.774e-003* 2.834e-003*sin(t)),  8.435e-003 +2.000*( 2.774e-003* 2.742e-002*cos(t)+ 1.000e+000* 2.834e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.590e-001, 1.690e-002 center
replot  2.590e-001+ 2.000*( 1.000e+000* 3.247e-002*cos(t)+-6.423e-003* 4.160e-003*sin(t)),  1.690e-002 +2.000*( 6.423e-003* 3.247e-002*cos(t)+ 1.000e+000* 4.160e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.420e-001, 3.368e-002 center
replot  2.420e-001+ 2.000*( 9.999e-001* 3.924e-002*cos(t)+-1.447e-002* 6.620e-003*sin(t)),  3.368e-002 +2.000*( 1.447e-002* 3.924e-002*cos(t)+ 9.999e-001* 6.620e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  2.246e-001, 6.652e-002 center
replot  2.246e-001+ 2.000*( 9.994e-001* 4.603e-002*cos(t)+-3.526e-002* 1.419e-002*sin(t)),  6.652e-002 +2.000*( 3.526e-002* 4.603e-002*cos(t)+ 9.994e-001* 1.419e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  2.066e-001, 1.292e-001 center
replot  2.066e-001+ 2.000*( 9.906e-001* 5.223e-002*cos(t)+-1.370e-001* 3.566e-002*sin(t)),  1.292e-001 +2.000*( 1.370e-001* 5.223e-002*cos(t)+ 9.906e-001* 3.566e-002*sin(t)) not
set out;
set out "BEMgali/VARPIJGR_BEMgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "BEMgali/VARPIJGR_BEMgali_123-13.svg"
set label "50" at  3.111e-002, 5.144e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  3.111e-002+ 2.000*( 9.999e-001* 1.189e-002*cos(t)+ 1.232e-002* 3.801e-004*sin(t)),  5.144e-004 +2.000*(-1.232e-002* 1.189e-002*cos(t)+ 9.999e-001* 3.801e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  4.155e-002, 1.037e-003 center
replot  4.155e-002+ 2.000*( 9.998e-001* 1.315e-002*cos(t)+ 1.970e-002* 6.477e-004*sin(t)),  1.037e-003 +2.000*(-1.970e-002* 1.315e-002*cos(t)+ 9.998e-001* 6.477e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  5.537e-002, 2.088e-003 center
replot  5.537e-002+ 2.000*( 9.995e-001* 1.414e-002*cos(t)+ 3.172e-002* 1.071e-003*sin(t)),  2.088e-003 +2.000*(-3.172e-002* 1.414e-002*cos(t)+ 9.995e-001* 1.071e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  7.359e-002, 4.200e-003 center
replot  7.359e-002+ 2.000*( 9.987e-001* 1.492e-002*cos(t)+ 5.024e-002* 1.702e-003*sin(t)),  4.200e-003 +2.000*(-5.024e-002* 1.492e-002*cos(t)+ 9.987e-001* 1.702e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  9.748e-002, 8.435e-003 center
replot  9.748e-002+ 2.000*( 9.974e-001* 1.617e-002*cos(t)+ 7.208e-002* 2.591e-003*sin(t)),  8.435e-003 +2.000*(-7.208e-002* 1.617e-002*cos(t)+ 9.974e-001* 2.591e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.286e-001, 1.690e-002 center
replot  1.286e-001+ 2.000*( 9.967e-001* 1.986e-002*cos(t)+ 8.173e-002* 3.848e-003*sin(t)),  1.690e-002 +2.000*(-8.173e-002* 1.986e-002*cos(t)+ 9.967e-001* 3.848e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.686e-001, 3.368e-002 center
replot  1.686e-001+ 2.000*( 9.967e-001* 2.883e-002*cos(t)+ 8.151e-002* 6.235e-003*sin(t)),  3.368e-002 +2.000*(-8.151e-002* 2.883e-002*cos(t)+ 9.967e-001* 6.235e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  2.196e-001, 6.652e-002 center
replot  2.196e-001+ 2.000*( 9.946e-001* 4.522e-002*cos(t)+ 1.038e-001* 1.356e-002*sin(t)),  6.652e-002 +2.000*(-1.038e-001* 4.522e-002*cos(t)+ 9.946e-001* 1.356e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.836e-001, 1.292e-001 center
replot  2.836e-001+ 2.000*( 9.830e-001* 7.063e-002*cos(t)+ 1.836e-001* 3.421e-002*sin(t)),  1.292e-001 +2.000*(-1.836e-001* 7.063e-002*cos(t)+ 9.830e-001* 3.421e-002*sin(t)) not
set out;
set out "BEMgali/VARPIJGR_BEMgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "BEMgali/VARPIJGR_BEMgali_123-21.svg"
set label "50" at  3.111e-002, 3.416e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  3.111e-002+ 2.000*( 9.653e-003* 5.802e-002*cos(t)+ 1.000e+000* 1.188e-002*sin(t)),  3.416e-001 +2.000*(-1.000e+000* 5.802e-002*cos(t)+ 9.653e-003* 1.188e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  4.155e-002, 3.250e-001 center
replot  4.155e-002+ 2.000*( 1.512e-002* 4.390e-002*cos(t)+ 9.999e-001* 1.313e-002*sin(t)),  3.250e-001 +2.000*(-9.999e-001* 4.390e-002*cos(t)+ 1.512e-002* 1.313e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  5.537e-002, 3.086e-001 center
replot  5.537e-002+ 2.000*( 2.738e-002* 3.294e-002*cos(t)+ 9.996e-001* 1.411e-002*sin(t)),  3.086e-001 +2.000*(-9.996e-001* 3.294e-002*cos(t)+ 2.738e-002* 1.411e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  7.359e-002, 2.922e-001 center
replot  7.359e-002+ 2.000*( 5.309e-002* 2.701e-002*cos(t)+ 9.986e-001* 1.485e-002*sin(t)),  2.922e-001 +2.000*(-9.986e-001* 2.701e-002*cos(t)+ 5.309e-002* 1.485e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  9.748e-002, 2.757e-001 center
replot  9.748e-002+ 2.000*( 8.163e-002* 2.748e-002*cos(t)+ 9.967e-001* 1.603e-002*sin(t)),  2.757e-001 +2.000*(-9.967e-001* 2.748e-002*cos(t)+ 8.163e-002* 1.603e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.286e-001, 2.590e-001 center
replot  1.286e-001+ 2.000*( 1.153e-001* 3.261e-002*cos(t)+ 9.933e-001* 1.956e-002*sin(t)),  2.590e-001 +2.000*(-9.933e-001* 3.261e-002*cos(t)+ 1.153e-001* 1.956e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.686e-001, 2.420e-001 center
replot  1.686e-001+ 2.000*( 2.167e-001* 3.971e-002*cos(t)+ 9.762e-001* 2.809e-002*sin(t)),  2.420e-001 +2.000*(-9.762e-001* 3.971e-002*cos(t)+ 2.167e-001* 2.809e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  2.196e-001, 2.246e-001 center
replot  2.196e-001+ 2.000*( 6.609e-001* 4.932e-002*cos(t)+ 7.505e-001* 4.134e-002*sin(t)),  2.246e-001 +2.000*(-7.505e-001* 4.932e-002*cos(t)+ 6.609e-001* 4.134e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.836e-001, 2.066e-001 center
replot  2.836e-001+ 2.000*( 9.550e-001* 7.135e-002*cos(t)+ 2.966e-001* 4.970e-002*sin(t)),  2.066e-001 +2.000*(-2.966e-001* 7.135e-002*cos(t)+ 9.550e-001* 4.970e-002*sin(t)) not
set out;
set out "BEMgali/VARPIJGR_BEMgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "BEMgali/VARMUPTJGR--STABLBASED_BEMgali1.svg";
 plot "BEMgali/PRMORPREV-1-STABLBASED_BEMgali.txt"  u 1:($3) not w l lt 1 
 replot "BEMgali/PRMORPREV-1-STABLBASED_BEMgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "BEMgali/PRMORPREV-1-STABLBASED_BEMgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "BEMgali/VARMUPTJGR--STABLBASED_BEMgali1.svg";replot;set out;
