
# IMaCh-0.99r45
# DEFgali.gp
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


set ter svg size 640, 480;set out "DEFgali/D_DEFgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "DEFgali/ILK_DEFgali-dest.png";
set log y;plot  "DEFgali/ILK_DEFgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "DEFgali/ILK_DEFgali-ori.png";
set log y;plot  "DEFgali/ILK_DEFgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "DEFgali/ILK_DEFgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "DEFgali/ILK_DEFgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "DEFgali/ILK_DEFgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "DEFgali/ILK_DEFgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "DEFgali/V_DEFgali_1-1-1.svg" 

#set out "V_DEFgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "DEFgali/VPL_DEFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"DEFgali/VPL_DEFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"DEFgali/VPL_DEFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"DEFgali/P_DEFgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "DEFgali/V_DEFgali_2-1-1.svg" 

#set out "V_DEFgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "DEFgali/VPL_DEFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"DEFgali/VPL_DEFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"DEFgali/VPL_DEFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"DEFgali/P_DEFgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "DEFgali/E_DEFgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "DEFgali/T_DEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"DEFgali/T_DEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"DEFgali/T_DEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"DEFgali/T_DEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"DEFgali/T_DEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"DEFgali/T_DEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"DEFgali/T_DEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"DEFgali/T_DEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"DEFgali/T_DEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "DEFgali/E_DEFgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "DEFgali/EXP_DEFgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "DEFgali/E_DEFgali.txt" every :::0::0 u 1:2 t "e11" w l ,"DEFgali/E_DEFgali.txt" every :::0::0 u 1:3 t "e12" w l ,"DEFgali/E_DEFgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "DEFgali/EXP_DEFgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "DEFgali/E_DEFgali.txt" every :::0::0 u 1:5 t "e21" w l ,"DEFgali/E_DEFgali.txt" every :::0::0 u 1:6 t "e22" w l ,"DEFgali/E_DEFgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "DEFgali/LIJ_DEFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEFgali/PIJ_DEFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "DEFgali/LIJ_DEFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEFgali/PIJ_DEFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "DEFgali/LIJT_DEFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEFgali/PIJ_DEFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "DEFgali/LIJT_DEFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEFgali/PIJ_DEFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "DEFgali/P_DEFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEFgali/PIJ_DEFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "DEFgali/P_DEFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEFgali/PIJ_DEFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-3.721992; p2=0.007993; 
#   current state 3
p3=-8.617912; p4=0.041846; 
# initial state 2
#   current state 1
p5=1.100444; p6=-0.045128; 
#   current state 3
p7=-10.219891; p8=0.089222; 
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

set out "DEFgali/PE_DEFgali_1-1-1.svg" 
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

set out "DEFgali/PE_DEFgali_1-2-1.svg" 
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

set out "DEFgali/PE_DEFgali_1-3-1.svg" 
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
set out "DEFgali/VARPIJGR_DEFgali_113-12.svg"
set label "50" at  2.825e-003, 6.953e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  2.825e-003+ 2.000*( 9.161e-003* 1.197e-002*cos(t)+ 1.000e+000* 1.796e-003*sin(t)),  6.953e-002 +2.000*(-1.000e+000* 1.197e-002*cos(t)+ 9.161e-003* 1.796e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  3.476e-003, 7.223e-002 center
replot  3.476e-003+ 2.000*( 9.835e-003* 9.854e-003*cos(t)+ 1.000e+000* 1.762e-003*sin(t)),  7.223e-002 +2.000*(-1.000e+000* 9.854e-003*cos(t)+ 9.835e-003* 1.762e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  4.277e-003, 7.504e-002 center
replot  4.277e-003+ 2.000*( 1.119e-002* 7.918e-003*cos(t)+ 9.999e-001* 1.682e-003*sin(t)),  7.504e-002 +2.000*(-9.999e-001* 7.918e-003*cos(t)+ 1.119e-002* 1.682e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  5.262e-003, 7.794e-002 center
replot  5.262e-003+ 2.000*( 1.793e-002* 6.600e-003*cos(t)+ 9.998e-001* 1.646e-003*sin(t)),  7.794e-002 +2.000*(-9.998e-001* 6.600e-003*cos(t)+ 1.793e-002* 1.646e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  6.472e-003, 8.094e-002 center
replot  6.472e-003+ 2.000*( 3.695e-002* 6.624e-003*cos(t)+ 9.993e-001* 1.895e-003*sin(t)),  8.094e-002 +2.000*(-9.993e-001* 6.624e-003*cos(t)+ 3.695e-002* 1.895e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  7.959e-003, 8.404e-002 center
replot  7.959e-003+ 2.000*( 5.862e-002* 8.276e-003*cos(t)+ 9.983e-001* 2.734e-003*sin(t)),  8.404e-002 +2.000*(-9.983e-001* 8.276e-003*cos(t)+ 5.862e-002* 2.734e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  9.786e-003, 8.723e-002 center
replot  9.786e-003+ 2.000*( 7.718e-002* 1.109e-002*cos(t)+ 9.970e-001* 4.314e-003*sin(t)),  8.723e-002 +2.000*(-9.970e-001* 1.109e-002*cos(t)+ 7.718e-002* 4.314e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  1.203e-002, 9.053e-002 center
replot  1.203e-002+ 2.000*( 9.893e-002* 1.463e-002*cos(t)+ 9.951e-001* 6.737e-003*sin(t)),  9.053e-002 +2.000*(-9.951e-001* 1.463e-002*cos(t)+ 9.893e-002* 6.737e-003*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.478e-002, 9.391e-002 center
replot  1.478e-002+ 2.000*( 1.315e-001* 1.869e-002*cos(t)+ 9.913e-001* 1.018e-002*sin(t)),  9.391e-002 +2.000*(-9.913e-001* 1.869e-002*cos(t)+ 1.315e-001* 1.018e-002*sin(t)) not
set out;
set out "DEFgali/VARPIJGR_DEFgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "DEFgali/VARPIJGR_DEFgali_121-12.svg"
set label "50" at  4.777e-001, 6.953e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  4.777e-001+ 2.000*( 9.986e-001* 7.396e-002*cos(t)+-5.235e-002* 1.134e-002*sin(t)),  6.953e-002 +2.000*( 5.235e-002* 7.396e-002*cos(t)+ 9.986e-001* 1.134e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.999e-001, 7.223e-002 center
replot  3.999e-001+ 2.000*( 9.980e-001* 5.271e-002*cos(t)+-6.295e-002* 9.296e-003*sin(t)),  7.223e-002 +2.000*( 6.295e-002* 5.271e-002*cos(t)+ 9.980e-001* 9.296e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.318e-001, 7.504e-002 center
replot  3.318e-001+ 2.000*( 9.972e-001* 3.640e-002*cos(t)+-7.544e-002* 7.447e-003*sin(t)),  7.504e-002 +2.000*( 7.544e-002* 3.640e-002*cos(t)+ 9.972e-001* 7.447e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.730e-001, 7.794e-002 center
replot  2.730e-001+ 2.000*( 9.963e-001* 2.566e-002*cos(t)+-8.583e-002* 6.243e-003*sin(t)),  7.794e-002 +2.000*( 8.583e-002* 2.566e-002*cos(t)+ 9.963e-001* 6.243e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.227e-001, 8.094e-002 center
replot  2.227e-001+ 2.000*( 9.958e-001* 2.058e-002*cos(t)+-9.104e-002* 6.376e-003*sin(t)),  8.094e-002 +2.000*( 9.104e-002* 2.058e-002*cos(t)+ 9.958e-001* 6.376e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.801e-001, 8.404e-002 center
replot  1.801e-001+ 2.000*( 9.943e-001* 1.954e-002*cos(t)+-1.065e-001* 8.043e-003*sin(t)),  8.404e-002 +2.000*( 1.065e-001* 1.954e-002*cos(t)+ 9.943e-001* 8.043e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.442e-001, 8.723e-002 center
replot  1.442e-001+ 2.000*( 9.880e-001* 1.993e-002*cos(t)+-1.544e-001* 1.076e-002*sin(t)),  8.723e-002 +2.000*( 1.544e-001* 1.993e-002*cos(t)+ 9.880e-001* 1.076e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.141e-001, 9.053e-002 center
replot  1.141e-001+ 2.000*( 9.605e-001* 2.023e-002*cos(t)+-2.783e-001* 1.399e-002*sin(t)),  9.053e-002 +2.000*( 2.783e-001* 2.023e-002*cos(t)+ 9.605e-001* 1.399e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  8.896e-002, 9.391e-002 center
replot  8.896e-002+ 2.000*( 7.562e-001* 2.068e-002*cos(t)+-6.544e-001* 1.683e-002*sin(t)),  9.391e-002 +2.000*( 6.544e-001* 2.068e-002*cos(t)+ 7.562e-001* 1.683e-002*sin(t)) not
set out;
set out "DEFgali/VARPIJGR_DEFgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "DEFgali/VARPIJGR_DEFgali_123-12.svg"
set label "50" at  4.788e-003, 6.953e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  4.788e-003+ 2.000*( 4.672e-003* 1.197e-002*cos(t)+-1.000e+000* 3.153e-003*sin(t)),  6.953e-002 +2.000*( 1.000e+000* 1.197e-002*cos(t)+ 4.672e-003* 3.153e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  7.848e-003, 7.223e-002 center
replot  7.848e-003+ 2.000*( 1.432e-002* 9.854e-003*cos(t)+-9.999e-001* 4.392e-003*sin(t)),  7.223e-002 +2.000*( 9.999e-001* 9.854e-003*cos(t)+ 1.432e-002* 4.392e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  1.275e-002, 7.504e-002 center
replot  1.275e-002+ 2.000*( 6.271e-002* 7.924e-003*cos(t)+-9.980e-001* 5.890e-003*sin(t)),  7.504e-002 +2.000*( 9.980e-001* 7.924e-003*cos(t)+ 6.271e-002* 5.890e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  2.053e-002, 7.794e-002 center
replot  2.053e-002+ 2.000*( 9.836e-001* 7.600e-003*cos(t)+-1.805e-001* 6.562e-003*sin(t)),  7.794e-002 +2.000*( 1.805e-001* 7.600e-003*cos(t)+ 9.836e-001* 6.562e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  3.278e-002, 8.094e-002 center
replot  3.278e-002+ 2.000*( 9.956e-001* 9.214e-003*cos(t)+-9.371e-002* 6.592e-003*sin(t)),  8.094e-002 +2.000*( 9.371e-002* 9.214e-003*cos(t)+ 9.956e-001* 6.592e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  5.190e-002, 8.404e-002 center
replot  5.190e-002+ 2.000*( 9.914e-001* 1.070e-002*cos(t)+-1.312e-001* 8.215e-003*sin(t)),  8.404e-002 +2.000*( 1.312e-001* 1.070e-002*cos(t)+ 9.914e-001* 8.215e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  8.138e-002, 8.723e-002 center
replot  8.138e-002+ 2.000*( 9.793e-001* 1.322e-002*cos(t)+-2.024e-001* 1.096e-002*sin(t)),  8.723e-002 +2.000*( 2.024e-001* 1.322e-002*cos(t)+ 9.793e-001* 1.096e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.261e-001, 9.053e-002 center
replot  1.261e-001+ 2.000*( 9.964e-001* 2.143e-002*cos(t)+-8.529e-002* 1.451e-002*sin(t)),  9.053e-002 +2.000*( 8.529e-002* 2.143e-002*cos(t)+ 9.964e-001* 1.451e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.924e-001, 9.391e-002 center
replot  1.924e-001+ 2.000*( 9.995e-001* 4.186e-002*cos(t)+-3.069e-002* 1.854e-002*sin(t)),  9.391e-002 +2.000*( 3.069e-002* 4.186e-002*cos(t)+ 9.995e-001* 1.854e-002*sin(t)) not
set out;
set out "DEFgali/VARPIJGR_DEFgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "DEFgali/VARPIJGR_DEFgali_121-13.svg"
set label "50" at  4.777e-001, 2.825e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  4.777e-001+ 2.000*( 1.000e+000* 7.387e-002*cos(t)+-2.239e-004* 1.799e-003*sin(t)),  2.825e-003 +2.000*( 2.239e-004* 7.387e-002*cos(t)+ 1.000e+000* 1.799e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.999e-001, 3.476e-003 center
replot  3.999e-001+ 2.000*( 1.000e+000* 5.261e-002*cos(t)+-2.202e-004* 1.764e-003*sin(t)),  3.476e-003 +2.000*( 2.202e-004* 5.261e-002*cos(t)+ 1.000e+000* 1.764e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.318e-001, 4.277e-003 center
replot  3.318e-001+ 2.000*( 1.000e+000* 3.630e-002*cos(t)+-2.404e-004* 1.684e-003*sin(t)),  4.277e-003 +2.000*( 2.404e-004* 3.630e-002*cos(t)+ 1.000e+000* 1.684e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.730e-001, 5.262e-003 center
replot  2.730e-001+ 2.000*( 1.000e+000* 2.557e-002*cos(t)+-6.598e-004* 1.649e-003*sin(t)),  5.262e-003 +2.000*( 6.598e-004* 2.557e-002*cos(t)+ 1.000e+000* 1.649e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.227e-001, 6.472e-003 center
replot  2.227e-001+ 2.000*( 1.000e+000* 2.050e-002*cos(t)+-2.445e-003* 1.909e-003*sin(t)),  6.472e-003 +2.000*( 2.445e-003* 2.050e-002*cos(t)+ 1.000e+000* 1.909e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.801e-001, 7.959e-003 center
replot  1.801e-001+ 2.000*( 1.000e+000* 1.944e-002*cos(t)+-5.811e-003* 2.770e-003*sin(t)),  7.959e-003 +2.000*( 5.811e-003* 1.944e-002*cos(t)+ 1.000e+000* 2.770e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.442e-001, 9.786e-003 center
replot  1.442e-001+ 2.000*( 9.999e-001* 1.976e-002*cos(t)+-1.060e-002* 4.380e-003*sin(t)),  9.786e-003 +2.000*( 1.060e-002* 1.976e-002*cos(t)+ 9.999e-001* 4.380e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.141e-001, 1.203e-002 center
replot  1.141e-001+ 2.000*( 9.998e-001* 1.982e-002*cos(t)+-1.895e-002* 6.849e-003*sin(t)),  1.203e-002 +2.000*( 1.895e-002* 1.982e-002*cos(t)+ 9.998e-001* 6.849e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  8.896e-002, 1.478e-002 center
replot  8.896e-002+ 2.000*( 9.992e-001* 1.913e-002*cos(t)+-4.001e-002* 1.037e-002*sin(t)),  1.478e-002 +2.000*( 4.001e-002* 1.913e-002*cos(t)+ 9.992e-001* 1.037e-002*sin(t)) not
set out;
set out "DEFgali/VARPIJGR_DEFgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "DEFgali/VARPIJGR_DEFgali_123-13.svg"
set label "50" at  4.788e-003, 2.825e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  4.788e-003+ 2.000*( 9.916e-001* 3.172e-003*cos(t)+ 1.292e-001* 1.767e-003*sin(t)),  2.825e-003 +2.000*(-1.292e-001* 3.172e-003*cos(t)+ 9.916e-001* 1.767e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  7.848e-003, 3.476e-003 center
replot  7.848e-003+ 2.000*( 9.967e-001* 4.406e-003*cos(t)+ 8.148e-002* 1.733e-003*sin(t)),  3.476e-003 +2.000*(-8.148e-002* 4.406e-003*cos(t)+ 9.967e-001* 1.733e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  1.275e-002, 4.277e-003 center
replot  1.275e-002+ 2.000*( 9.982e-001* 5.909e-003*cos(t)+ 6.020e-002* 1.649e-003*sin(t)),  4.277e-003 +2.000*(-6.020e-002* 5.909e-003*cos(t)+ 9.982e-001* 1.649e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  2.053e-002, 5.262e-003 center
replot  2.053e-002+ 2.000*( 9.987e-001* 7.578e-003*cos(t)+ 5.050e-002* 1.607e-003*sin(t)),  5.262e-003 +2.000*(-5.050e-002* 7.578e-003*cos(t)+ 9.987e-001* 1.607e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  3.278e-002, 6.472e-003 center
replot  3.278e-002+ 2.000*( 9.987e-001* 9.206e-003*cos(t)+ 5.009e-002* 1.856e-003*sin(t)),  6.472e-003 +2.000*(-5.009e-002* 9.206e-003*cos(t)+ 9.987e-001* 1.856e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  5.190e-002, 7.959e-003 center
replot  5.190e-002+ 2.000*( 9.981e-001* 1.068e-002*cos(t)+ 6.237e-002* 2.696e-003*sin(t)),  7.959e-003 +2.000*(-6.237e-002* 1.068e-002*cos(t)+ 9.981e-001* 2.696e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  8.138e-002, 9.786e-003 center
replot  8.138e-002+ 2.000*( 9.965e-001* 1.317e-002*cos(t)+ 8.371e-002* 4.259e-003*sin(t)),  9.786e-003 +2.000*(-8.371e-002* 1.317e-002*cos(t)+ 9.965e-001* 4.259e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.261e-001, 1.203e-002 center
replot  1.261e-001+ 2.000*( 9.974e-001* 2.144e-002*cos(t)+ 7.147e-002* 6.702e-003*sin(t)),  1.203e-002 +2.000*(-7.147e-002* 2.144e-002*cos(t)+ 9.974e-001* 6.702e-003*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.924e-001, 1.478e-002 center
replot  1.924e-001+ 2.000*( 9.990e-001* 4.189e-002*cos(t)+ 4.367e-002* 1.023e-002*sin(t)),  1.478e-002 +2.000*(-4.367e-002* 4.189e-002*cos(t)+ 9.990e-001* 1.023e-002*sin(t)) not
set out;
set out "DEFgali/VARPIJGR_DEFgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "DEFgali/VARPIJGR_DEFgali_123-21.svg"
set label "50" at  4.788e-003, 4.777e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  4.788e-003+ 2.000*( 1.995e-003* 7.387e-002*cos(t)+ 1.000e+000* 3.150e-003*sin(t)),  4.777e-001 +2.000*(-1.000e+000* 7.387e-002*cos(t)+ 1.995e-003* 3.150e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  7.848e-003, 3.999e-001 center
replot  7.848e-003+ 2.000*( 3.124e-003* 5.261e-002*cos(t)+ 1.000e+000* 4.391e-003*sin(t)),  3.999e-001 +2.000*(-1.000e+000* 5.261e-002*cos(t)+ 3.124e-003* 4.391e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  1.275e-002, 3.318e-001 center
replot  1.275e-002+ 2.000*( 5.758e-003* 3.630e-002*cos(t)+ 1.000e+000* 5.896e-003*sin(t)),  3.318e-001 +2.000*(-1.000e+000* 3.630e-002*cos(t)+ 5.758e-003* 5.896e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  2.053e-002, 2.730e-001 center
replot  2.053e-002+ 2.000*( 1.315e-002* 2.557e-002*cos(t)+ 9.999e-001* 7.562e-003*sin(t)),  2.730e-001 +2.000*(-9.999e-001* 2.557e-002*cos(t)+ 1.315e-002* 7.562e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  3.278e-002, 2.227e-001 center
replot  3.278e-002+ 2.000*( 2.921e-002* 2.051e-002*cos(t)+ 9.996e-001* 9.179e-003*sin(t)),  2.227e-001 +2.000*(-9.996e-001* 2.051e-002*cos(t)+ 2.921e-002* 9.179e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  5.190e-002, 1.801e-001 center
replot  5.190e-002+ 2.000*( 4.752e-002* 1.946e-002*cos(t)+ 9.989e-001* 1.063e-002*sin(t)),  1.801e-001 +2.000*(-9.989e-001* 1.946e-002*cos(t)+ 4.752e-002* 1.063e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  8.138e-002, 1.442e-001 center
replot  8.138e-002+ 2.000*( 7.739e-002* 1.979e-002*cos(t)+ 9.970e-001* 1.308e-002*sin(t)),  1.442e-001 +2.000*(-9.970e-001* 1.979e-002*cos(t)+ 7.739e-002* 1.308e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.261e-001, 1.141e-001 center
replot  1.261e-001+ 2.000*( 9.263e-001* 2.168e-002*cos(t)+ 3.769e-001* 1.950e-002*sin(t)),  1.141e-001 +2.000*(-3.769e-001* 2.168e-002*cos(t)+ 9.263e-001* 1.950e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.924e-001, 8.896e-002 center
replot  1.924e-001+ 2.000*( 9.982e-001* 4.191e-002*cos(t)+ 6.013e-002* 1.899e-002*sin(t)),  8.896e-002 +2.000*(-6.013e-002* 4.191e-002*cos(t)+ 9.982e-001* 1.899e-002*sin(t)) not
set out;
set out "DEFgali/VARPIJGR_DEFgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "DEFgali/VARMUPTJGR--STABLBASED_DEFgali1.svg";
 plot "DEFgali/PRMORPREV-1-STABLBASED_DEFgali.txt"  u 1:($3) not w l lt 1 
 replot "DEFgali/PRMORPREV-1-STABLBASED_DEFgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "DEFgali/PRMORPREV-1-STABLBASED_DEFgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "DEFgali/VARMUPTJGR--STABLBASED_DEFgali1.svg";replot;set out;
