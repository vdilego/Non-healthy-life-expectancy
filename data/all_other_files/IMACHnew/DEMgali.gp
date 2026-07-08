
# IMaCh-0.99r45
# DEMgali.gp
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


set ter svg size 640, 480;set out "DEMgali/D_DEMgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "DEMgali/ILK_DEMgali-dest.png";
set log y;plot  "DEMgali/ILK_DEMgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "DEMgali/ILK_DEMgali-ori.png";
set log y;plot  "DEMgali/ILK_DEMgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "DEMgali/ILK_DEMgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "DEMgali/ILK_DEMgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "DEMgali/ILK_DEMgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "DEMgali/ILK_DEMgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "DEMgali/V_DEMgali_1-1-1.svg" 

#set out "V_DEMgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "DEMgali/VPL_DEMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"DEMgali/VPL_DEMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"DEMgali/VPL_DEMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"DEMgali/P_DEMgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "DEMgali/V_DEMgali_2-1-1.svg" 

#set out "V_DEMgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "DEMgali/VPL_DEMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"DEMgali/VPL_DEMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"DEMgali/VPL_DEMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"DEMgali/P_DEMgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "DEMgali/E_DEMgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "DEMgali/T_DEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"DEMgali/T_DEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"DEMgali/T_DEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"DEMgali/T_DEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"DEMgali/T_DEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"DEMgali/T_DEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"DEMgali/T_DEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"DEMgali/T_DEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"DEMgali/T_DEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "DEMgali/E_DEMgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "DEMgali/EXP_DEMgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "DEMgali/E_DEMgali.txt" every :::0::0 u 1:2 t "e11" w l ,"DEMgali/E_DEMgali.txt" every :::0::0 u 1:3 t "e12" w l ,"DEMgali/E_DEMgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "DEMgali/EXP_DEMgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "DEMgali/E_DEMgali.txt" every :::0::0 u 1:5 t "e21" w l ,"DEMgali/E_DEMgali.txt" every :::0::0 u 1:6 t "e22" w l ,"DEMgali/E_DEMgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "DEMgali/LIJ_DEMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEMgali/PIJ_DEMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "DEMgali/LIJ_DEMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEMgali/PIJ_DEMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "DEMgali/LIJT_DEMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEMgali/PIJ_DEMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "DEMgali/LIJT_DEMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEMgali/PIJ_DEMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "DEMgali/P_DEMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEMgali/PIJ_DEMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "DEMgali/P_DEMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEMgali/PIJ_DEMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-5.711117; p2=0.036575; 
#   current state 3
p3=-4.868426; p4=-0.010177; 
# initial state 2
#   current state 1
p5=-1.787224; p6=-0.004713; 
#   current state 3
p7=-8.944687; p8=0.085255; 
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

set out "DEMgali/PE_DEMgali_1-1-1.svg" 
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

set out "DEMgali/PE_DEMgali_1-2-1.svg" 
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

set out "DEMgali/PE_DEMgali_1-3-1.svg" 
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
set out "DEMgali/VARPIJGR_DEMgali_113-12.svg"
set label "50" at  9.013e-003, 4.019e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  9.013e-003+ 2.000*( 1.925e-001* 7.564e-003*cos(t)+ 9.813e-001* 5.174e-003*sin(t)),  4.019e-002 +2.000*(-9.813e-001* 7.564e-003*cos(t)+ 1.925e-001* 5.174e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  8.534e-003, 4.807e-002 center
replot  8.534e-003+ 2.000*( 8.393e-002* 7.060e-003*cos(t)+ 9.965e-001* 3.519e-003*sin(t)),  4.807e-002 +2.000*(-9.965e-001* 7.060e-003*cos(t)+ 8.393e-002* 3.519e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  8.073e-003, 5.745e-002 center
replot  8.073e-003+ 2.000*( 4.554e-002* 6.435e-003*cos(t)+ 9.990e-001* 2.380e-003*sin(t)),  5.745e-002 +2.000*(-9.990e-001* 6.435e-003*cos(t)+ 4.554e-002* 2.380e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  7.630e-003, 6.860e-002 center
replot  7.630e-003+ 2.000*( 5.592e-002* 6.078e-003*cos(t)+ 9.984e-001* 2.225e-003*sin(t)),  6.860e-002 +2.000*(-9.984e-001* 6.078e-003*cos(t)+ 5.592e-002* 2.225e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  7.203e-003, 8.182e-002 center
replot  7.203e-003+ 2.000*( 1.064e-001* 7.002e-003*cos(t)+ 9.943e-001* 2.891e-003*sin(t)),  8.182e-002 +2.000*(-9.943e-001* 7.002e-003*cos(t)+ 1.064e-001* 2.891e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  6.792e-003, 9.745e-002 center
replot  6.792e-003+ 2.000*( 1.149e-001* 1.010e-002*cos(t)+ 9.934e-001* 3.799e-003*sin(t)),  9.745e-002 +2.000*(-9.934e-001* 1.010e-002*cos(t)+ 1.149e-001* 3.799e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  6.393e-003, 1.159e-001 center
replot  6.393e-003+ 2.000*( 9.167e-002* 1.548e-002*cos(t)+ 9.958e-001* 4.726e-003*sin(t)),  1.159e-001 +2.000*(-9.958e-001* 1.548e-002*cos(t)+ 9.167e-002* 4.726e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  6.007e-003, 1.376e-001 center
replot  6.007e-003+ 2.000*( 6.929e-002* 2.316e-002*cos(t)+ 9.976e-001* 5.580e-003*sin(t)),  1.376e-001 +2.000*(-9.976e-001* 2.316e-002*cos(t)+ 6.929e-002* 5.580e-003*sin(t)) not
# Age 90, p13 - p12
set label "90" at  5.632e-003, 1.629e-001 center
replot  5.632e-003+ 2.000*( 5.274e-002* 3.333e-002*cos(t)+ 9.986e-001* 6.325e-003*sin(t)),  1.629e-001 +2.000*(-9.986e-001* 3.333e-002*cos(t)+ 5.274e-002* 6.325e-003*sin(t)) not
set out;
set out "DEMgali/VARPIJGR_DEMgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "DEMgali/VARPIJGR_DEMgali_121-12.svg"
set label "50" at  2.317e-001, 4.019e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  2.317e-001+ 2.000*( 9.994e-001* 4.840e-002*cos(t)+-3.540e-002* 7.295e-003*sin(t)),  4.019e-002 +2.000*( 3.540e-002* 4.840e-002*cos(t)+ 9.994e-001* 7.295e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  2.260e-001, 4.807e-002 center
replot  2.260e-001+ 2.000*( 9.991e-001* 3.805e-002*cos(t)+-4.248e-002* 6.860e-003*sin(t)),  4.807e-002 +2.000*( 4.248e-002* 3.805e-002*cos(t)+ 9.991e-001* 6.860e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.199e-001, 5.745e-002 center
replot  2.199e-001+ 2.000*( 9.987e-001* 2.939e-002*cos(t)+-5.108e-002* 6.260e-003*sin(t)),  5.745e-002 +2.000*( 5.108e-002* 2.939e-002*cos(t)+ 9.987e-001* 6.260e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.131e-001, 6.860e-002 center
replot  2.131e-001+ 2.000*( 9.980e-001* 2.363e-002*cos(t)+-6.363e-002* 5.893e-003*sin(t)),  6.860e-002 +2.000*( 6.363e-002* 2.363e-002*cos(t)+ 9.980e-001* 5.893e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.055e-001, 8.182e-002 center
replot  2.055e-001+ 2.000*( 9.963e-001* 2.223e-002*cos(t)+-8.599e-002* 6.727e-003*sin(t)),  8.182e-002 +2.000*( 8.599e-002* 2.223e-002*cos(t)+ 9.963e-001* 6.727e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.967e-001, 9.745e-002 center
replot  1.967e-001+ 2.000*( 9.927e-001* 2.504e-002*cos(t)+-1.206e-001* 9.651e-003*sin(t)),  9.745e-002 +2.000*( 1.206e-001* 2.504e-002*cos(t)+ 9.927e-001* 9.651e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.861e-001, 1.159e-001 center
replot  1.861e-001+ 2.000*( 9.853e-001* 3.008e-002*cos(t)+-1.707e-001* 1.476e-002*sin(t)),  1.159e-001 +2.000*( 1.707e-001* 3.008e-002*cos(t)+ 9.853e-001* 1.476e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.732e-001, 1.376e-001 center
replot  1.732e-001+ 2.000*( 9.661e-001* 3.563e-002*cos(t)+-2.582e-001* 2.194e-002*sin(t)),  1.376e-001 +2.000*( 2.582e-001* 3.563e-002*cos(t)+ 9.661e-001* 2.194e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.576e-001, 1.629e-001 center
replot  1.576e-001+ 2.000*( 8.880e-001* 4.118e-002*cos(t)+-4.598e-001* 3.083e-002*sin(t)),  1.629e-001 +2.000*( 4.598e-001* 4.118e-002*cos(t)+ 8.880e-001* 3.083e-002*sin(t)) not
set out;
set out "DEMgali/VARPIJGR_DEMgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "DEMgali/VARPIJGR_DEMgali_123-12.svg"
set label "50" at  1.623e-002, 4.019e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  1.623e-002+ 2.000*( 7.061e-001* 7.794e-003*cos(t)+-7.081e-001* 7.169e-003*sin(t)),  4.019e-002 +2.000*( 7.081e-001* 7.794e-003*cos(t)+ 7.061e-001* 7.169e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.481e-002, 4.807e-002 center
replot  2.481e-002+ 2.000*( 9.911e-001* 9.607e-003*cos(t)+-1.328e-001* 6.987e-003*sin(t)),  4.807e-002 +2.000*( 1.328e-001* 9.607e-003*cos(t)+ 9.911e-001* 6.987e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.785e-002, 5.745e-002 center
replot  3.785e-002+ 2.000*( 9.978e-001* 1.182e-002*cos(t)+-6.612e-002* 6.396e-003*sin(t)),  5.745e-002 +2.000*( 6.612e-002* 1.182e-002*cos(t)+ 9.978e-001* 6.396e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  5.754e-002, 6.860e-002 center
replot  5.754e-002+ 2.000*( 9.990e-001* 1.393e-002*cos(t)+-4.443e-002* 6.045e-003*sin(t)),  6.860e-002 +2.000*( 4.443e-002* 1.393e-002*cos(t)+ 9.990e-001* 6.045e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  8.700e-002, 8.182e-002 center
replot  8.700e-002+ 2.000*( 9.992e-001* 1.572e-002*cos(t)+-3.986e-002* 6.946e-003*sin(t)),  8.182e-002 +2.000*( 3.986e-002* 1.572e-002*cos(t)+ 9.992e-001* 6.946e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.305e-001, 9.745e-002 center
replot  1.305e-001+ 2.000*( 9.984e-001* 1.803e-002*cos(t)+-5.666e-002* 1.001e-002*sin(t)),  9.745e-002 +2.000*( 5.666e-002* 1.803e-002*cos(t)+ 9.984e-001* 1.001e-002*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.937e-001, 1.159e-001 center
replot  1.937e-001+ 2.000*( 9.968e-001* 2.505e-002*cos(t)+-7.946e-002* 1.534e-002*sin(t)),  1.159e-001 +2.000*( 7.946e-002* 2.505e-002*cos(t)+ 9.968e-001* 1.534e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  2.827e-001, 1.376e-001 center
replot  2.827e-001+ 2.000*( 9.980e-001* 4.321e-002*cos(t)+-6.341e-002* 2.299e-002*sin(t)),  1.376e-001 +2.000*( 6.341e-002* 4.321e-002*cos(t)+ 9.980e-001* 2.299e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  4.034e-001, 1.629e-001 center
replot  4.034e-001+ 2.000*( 9.989e-001* 7.579e-002*cos(t)+-4.594e-002* 3.314e-002*sin(t)),  1.629e-001 +2.000*( 4.594e-002* 7.579e-002*cos(t)+ 9.989e-001* 3.314e-002*sin(t)) not
set out;
set out "DEMgali/VARPIJGR_DEMgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "DEMgali/VARPIJGR_DEMgali_121-13.svg"
set label "50" at  2.317e-001, 9.013e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  2.317e-001+ 2.000*( 1.000e+000* 4.837e-002*cos(t)+-3.465e-003* 5.279e-003*sin(t)),  9.013e-003 +2.000*( 3.465e-003* 4.837e-002*cos(t)+ 1.000e+000* 5.279e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  2.260e-001, 8.534e-003 center
replot  2.260e-001+ 2.000*( 1.000e+000* 3.801e-002*cos(t)+-3.485e-003* 3.554e-003*sin(t)),  8.534e-003 +2.000*( 3.485e-003* 3.801e-002*cos(t)+ 1.000e+000* 3.554e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.199e-001, 8.073e-003 center
replot  2.199e-001+ 2.000*( 1.000e+000* 2.936e-002*cos(t)+-3.500e-003* 2.394e-003*sin(t)),  8.073e-003 +2.000*( 3.500e-003* 2.936e-002*cos(t)+ 1.000e+000* 2.394e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.131e-001, 7.630e-003 center
replot  2.131e-001+ 2.000*( 1.000e+000* 2.359e-002*cos(t)+-3.438e-003* 2.246e-003*sin(t)),  7.630e-003 +2.000*( 3.438e-003* 2.359e-002*cos(t)+ 1.000e+000* 2.246e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.055e-001, 7.203e-003 center
replot  2.055e-001+ 2.000*( 1.000e+000* 2.215e-002*cos(t)+-3.422e-003* 2.969e-003*sin(t)),  7.203e-003 +2.000*( 3.422e-003* 2.215e-002*cos(t)+ 1.000e+000* 2.969e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.967e-001, 6.792e-003 center
replot  1.967e-001+ 2.000*( 1.000e+000* 2.489e-002*cos(t)+-3.895e-003* 3.947e-003*sin(t)),  6.792e-003 +2.000*( 3.895e-003* 2.489e-002*cos(t)+ 1.000e+000* 3.947e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.861e-001, 6.393e-003 center
replot  1.861e-001+ 2.000*( 1.000e+000* 2.975e-002*cos(t)+-4.942e-003* 4.914e-003*sin(t)),  6.393e-003 +2.000*( 4.942e-003* 2.975e-002*cos(t)+ 1.000e+000* 4.914e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.732e-001, 6.007e-003 center
replot  1.732e-001+ 2.000*( 1.000e+000* 3.489e-002*cos(t)+-6.527e-003* 5.789e-003*sin(t)),  6.007e-003 +2.000*( 6.527e-003* 3.489e-002*cos(t)+ 1.000e+000* 5.789e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.576e-001, 5.632e-003 center
replot  1.576e-001+ 2.000*( 1.000e+000* 3.922e-002*cos(t)+-8.740e-003* 6.547e-003*sin(t)),  5.632e-003 +2.000*( 8.740e-003* 3.922e-002*cos(t)+ 1.000e+000* 6.547e-003*sin(t)) not
set out;
set out "DEMgali/VARPIJGR_DEMgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "DEMgali/VARPIJGR_DEMgali_123-13.svg"
set label "50" at  1.623e-002, 9.013e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  1.623e-002+ 2.000*( 9.637e-001* 7.642e-003*cos(t)+ 2.669e-001* 5.055e-003*sin(t)),  9.013e-003 +2.000*(-2.669e-001* 7.642e-003*cos(t)+ 9.637e-001* 5.055e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.481e-002, 8.534e-003 center
replot  2.481e-002+ 2.000*( 9.947e-001* 9.611e-003*cos(t)+ 1.029e-001* 3.434e-003*sin(t)),  8.534e-003 +2.000*(-1.029e-001* 9.611e-003*cos(t)+ 9.947e-001* 3.434e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.785e-002, 8.073e-003 center
replot  3.785e-002+ 2.000*( 9.983e-001* 1.182e-002*cos(t)+ 5.827e-002* 2.299e-003*sin(t)),  8.073e-003 +2.000*(-5.827e-002* 1.182e-002*cos(t)+ 9.983e-001* 2.299e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  5.754e-002, 7.630e-003 center
replot  5.754e-002+ 2.000*( 9.992e-001* 1.393e-002*cos(t)+ 4.100e-002* 2.175e-003*sin(t)),  7.630e-003 +2.000*(-4.100e-002* 1.393e-002*cos(t)+ 9.992e-001* 2.175e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  8.700e-002, 7.203e-003 center
replot  8.700e-002+ 2.000*( 9.992e-001* 1.573e-002*cos(t)+ 3.962e-002* 2.906e-003*sin(t)),  7.203e-003 +2.000*(-3.962e-002* 1.573e-002*cos(t)+ 9.992e-001* 2.906e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.305e-001, 6.792e-003 center
replot  1.305e-001+ 2.000*( 9.987e-001* 1.803e-002*cos(t)+ 5.037e-002* 3.847e-003*sin(t)),  6.792e-003 +2.000*(-5.037e-002* 1.803e-002*cos(t)+ 9.987e-001* 3.847e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.937e-001, 6.393e-003 center
replot  1.937e-001+ 2.000*( 9.987e-001* 2.503e-002*cos(t)+ 5.078e-002* 4.755e-003*sin(t)),  6.393e-003 +2.000*(-5.078e-002* 2.503e-002*cos(t)+ 9.987e-001* 4.755e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  2.827e-001, 6.007e-003 center
replot  2.827e-001+ 2.000*( 9.995e-001* 4.317e-002*cos(t)+ 3.301e-002* 5.618e-003*sin(t)),  6.007e-003 +2.000*(-3.301e-002* 4.317e-002*cos(t)+ 9.995e-001* 5.618e-003*sin(t)) not
# Age 90, p23 - p13
set label "90" at  4.034e-001, 5.632e-003 center
replot  4.034e-001+ 2.000*( 9.998e-001* 7.574e-002*cos(t)+ 1.945e-002* 6.390e-003*sin(t)),  5.632e-003 +2.000*(-1.945e-002* 7.574e-002*cos(t)+ 9.998e-001* 6.390e-003*sin(t)) not
set out;
set out "DEMgali/VARPIJGR_DEMgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "DEMgali/VARPIJGR_DEMgali_123-21.svg"
set label "50" at  1.623e-002, 2.317e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.623e-002+ 2.000*( 7.220e-003* 4.837e-002*cos(t)+ 1.000e+000* 7.479e-003*sin(t)),  2.317e-001 +2.000*(-1.000e+000* 4.837e-002*cos(t)+ 7.220e-003* 7.479e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.481e-002, 2.260e-001 center
replot  2.481e-002+ 2.000*( 1.536e-002* 3.802e-002*cos(t)+ 9.999e-001* 9.550e-003*sin(t)),  2.260e-001 +2.000*(-9.999e-001* 3.802e-002*cos(t)+ 1.536e-002* 9.550e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.785e-002, 2.199e-001 center
replot  3.785e-002+ 2.000*( 3.545e-002* 2.937e-002*cos(t)+ 9.994e-001* 1.176e-002*sin(t)),  2.199e-001 +2.000*(-9.994e-001* 2.937e-002*cos(t)+ 3.545e-002* 1.176e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  5.754e-002, 2.131e-001 center
replot  5.754e-002+ 2.000*( 8.189e-002* 2.364e-002*cos(t)+ 9.966e-001* 1.383e-002*sin(t)),  2.131e-001 +2.000*(-9.966e-001* 2.364e-002*cos(t)+ 8.189e-002* 1.383e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  8.700e-002, 2.055e-001 center
replot  8.700e-002+ 2.000*( 1.283e-001* 2.225e-002*cos(t)+ 9.917e-001* 1.558e-002*sin(t)),  2.055e-001 +2.000*(-9.917e-001* 2.225e-002*cos(t)+ 1.283e-001* 1.558e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.305e-001, 1.967e-001 center
replot  1.305e-001+ 2.000*( 1.109e-001* 2.496e-002*cos(t)+ 9.938e-001* 1.790e-002*sin(t)),  1.967e-001 +2.000*(-9.938e-001* 2.496e-002*cos(t)+ 1.109e-001* 1.790e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.937e-001, 1.861e-001 center
replot  1.937e-001+ 2.000*( 1.900e-001* 2.992e-002*cos(t)+ 9.818e-001* 2.480e-002*sin(t)),  1.861e-001 +2.000*(-9.818e-001* 2.992e-002*cos(t)+ 1.900e-001* 2.480e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  2.827e-001, 1.732e-001 center
replot  2.827e-001+ 2.000*( 9.744e-001* 4.356e-002*cos(t)+ 2.249e-001* 3.436e-002*sin(t)),  1.732e-001 +2.000*(-2.249e-001* 4.356e-002*cos(t)+ 9.744e-001* 3.436e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  4.034e-001, 1.576e-001 center
replot  4.034e-001+ 2.000*( 9.929e-001* 7.612e-002*cos(t)+ 1.185e-001* 3.844e-002*sin(t)),  1.576e-001 +2.000*(-1.185e-001* 7.612e-002*cos(t)+ 9.929e-001* 3.844e-002*sin(t)) not
set out;
set out "DEMgali/VARPIJGR_DEMgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "DEMgali/VARMUPTJGR--STABLBASED_DEMgali1.svg";
 plot "DEMgali/PRMORPREV-1-STABLBASED_DEMgali.txt"  u 1:($3) not w l lt 1 
 replot "DEMgali/PRMORPREV-1-STABLBASED_DEMgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "DEMgali/PRMORPREV-1-STABLBASED_DEMgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "DEMgali/VARMUPTJGR--STABLBASED_DEMgali1.svg";replot;set out;
