
# IMaCh-0.99r45
# ESMgali.gp
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


set ter svg size 640, 480;set out "ESMgali/D_ESMgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "ESMgali/ILK_ESMgali-dest.png";
set log y;plot  "ESMgali/ILK_ESMgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "ESMgali/ILK_ESMgali-ori.png";
set log y;plot  "ESMgali/ILK_ESMgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "ESMgali/ILK_ESMgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ESMgali/ILK_ESMgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "ESMgali/ILK_ESMgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ESMgali/ILK_ESMgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "ESMgali/V_ESMgali_1-1-1.svg" 

#set out "V_ESMgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ESMgali/VPL_ESMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"ESMgali/VPL_ESMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"ESMgali/VPL_ESMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"ESMgali/P_ESMgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "ESMgali/V_ESMgali_2-1-1.svg" 

#set out "V_ESMgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ESMgali/VPL_ESMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"ESMgali/VPL_ESMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"ESMgali/VPL_ESMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"ESMgali/P_ESMgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "ESMgali/E_ESMgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "ESMgali/T_ESMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"ESMgali/T_ESMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"ESMgali/T_ESMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"ESMgali/T_ESMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"ESMgali/T_ESMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"ESMgali/T_ESMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"ESMgali/T_ESMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"ESMgali/T_ESMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"ESMgali/T_ESMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "ESMgali/E_ESMgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "ESMgali/EXP_ESMgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ESMgali/E_ESMgali.txt" every :::0::0 u 1:2 t "e11" w l ,"ESMgali/E_ESMgali.txt" every :::0::0 u 1:3 t "e12" w l ,"ESMgali/E_ESMgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "ESMgali/EXP_ESMgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ESMgali/E_ESMgali.txt" every :::0::0 u 1:5 t "e21" w l ,"ESMgali/E_ESMgali.txt" every :::0::0 u 1:6 t "e22" w l ,"ESMgali/E_ESMgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "ESMgali/LIJ_ESMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMgali/PIJ_ESMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "ESMgali/LIJ_ESMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMgali/PIJ_ESMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "ESMgali/LIJT_ESMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMgali/PIJ_ESMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "ESMgali/LIJT_ESMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMgali/PIJ_ESMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "ESMgali/P_ESMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMgali/PIJ_ESMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "ESMgali/P_ESMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMgali/PIJ_ESMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-4.741859; p2=0.019191; 
#   current state 3
p3=-9.480834; p4=0.068287; 
# initial state 2
#   current state 1
p5=1.176209; p6=-0.028644; 
#   current state 3
p7=-5.650874; p8=0.055706; 
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

set out "ESMgali/PE_ESMgali_1-1-1.svg" 
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

set out "ESMgali/PE_ESMgali_1-2-1.svg" 
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

set out "ESMgali/PE_ESMgali_1-3-1.svg" 
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
set out "ESMgali/VARPIJGR_ESMgali_113-12.svg"
set label "50" at  4.525e-003, 4.443e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  4.525e-003+ 2.000*( 9.544e-003* 1.338e-002*cos(t)+ 1.000e+000* 1.707e-003*sin(t)),  4.443e-002 +2.000*(-1.000e+000* 1.338e-002*cos(t)+ 9.544e-003* 1.707e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  6.347e-003, 4.875e-002 center
replot  6.347e-003+ 2.000*( 1.168e-002* 1.201e-002*cos(t)+ 9.999e-001* 1.983e-003*sin(t)),  4.875e-002 +2.000*(-9.999e-001* 1.201e-002*cos(t)+ 1.168e-002* 1.983e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  8.896e-003, 5.346e-002 center
replot  8.896e-003+ 2.000*( 1.735e-002* 1.051e-002*cos(t)+ 9.998e-001* 2.256e-003*sin(t)),  5.346e-002 +2.000*(-9.998e-001* 1.051e-002*cos(t)+ 1.735e-002* 2.256e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.246e-002, 5.858e-002 center
replot  1.246e-002+ 2.000*( 3.800e-002* 9.184e-003*cos(t)+ 9.993e-001* 2.560e-003*sin(t)),  5.858e-002 +2.000*(-9.993e-001* 9.184e-003*cos(t)+ 3.800e-002* 2.560e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.744e-002, 6.412e-002 center
replot  1.744e-002+ 2.000*( 1.006e-001* 8.715e-003*cos(t)+ 9.949e-001* 3.044e-003*sin(t)),  6.412e-002 +2.000*(-9.949e-001* 8.715e-003*cos(t)+ 1.006e-001* 3.044e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.437e-002, 7.011e-002 center
replot  2.437e-002+ 2.000*( 2.015e-001* 1.004e-002*cos(t)+ 9.795e-001* 4.091e-003*sin(t)),  7.011e-002 +2.000*(-9.795e-001* 1.004e-002*cos(t)+ 2.015e-001* 4.091e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.400e-002, 7.652e-002 center
replot  3.400e-002+ 2.000*( 2.977e-001* 1.350e-002*cos(t)+ 9.546e-001* 6.407e-003*sin(t)),  7.652e-002 +2.000*(-9.546e-001* 1.350e-002*cos(t)+ 2.977e-001* 6.407e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  4.732e-002, 8.333e-002 center
replot  4.732e-002+ 2.000*( 4.119e-001* 1.897e-002*cos(t)+ 9.112e-001* 1.068e-002*sin(t)),  8.333e-002 +2.000*(-9.112e-001* 1.897e-002*cos(t)+ 4.119e-001* 1.068e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  6.567e-002, 9.047e-002 center
replot  6.567e-002+ 2.000*( 5.866e-001* 2.686e-002*cos(t)+ 8.098e-001* 1.722e-002*sin(t)),  9.047e-002 +2.000*(-8.098e-001* 2.686e-002*cos(t)+ 5.866e-001* 1.722e-002*sin(t)) not
set out;
set out "ESMgali/VARPIJGR_ESMgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ESMgali/VARPIJGR_ESMgali_121-12.svg"
set label "50" at  8.456e-001, 4.443e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  8.456e-001+ 2.000*( 9.995e-001* 3.329e-001*cos(t)+-3.091e-002* 8.551e-003*sin(t)),  4.443e-002 +2.000*( 3.091e-002* 3.329e-001*cos(t)+ 9.995e-001* 8.551e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  7.684e-001, 4.875e-002 center
replot  7.684e-001+ 2.000*( 9.994e-001* 2.664e-001*cos(t)+-3.529e-002* 7.471e-003*sin(t)),  4.875e-002 +2.000*( 3.529e-002* 2.664e-001*cos(t)+ 9.994e-001* 7.471e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  6.918e-001, 5.346e-002 center
replot  6.918e-001+ 2.000*( 9.992e-001* 2.037e-001*cos(t)+-4.082e-002* 6.430e-003*sin(t)),  5.346e-002 +2.000*( 4.082e-002* 2.037e-001*cos(t)+ 9.992e-001* 6.430e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  6.162e-001, 5.858e-002 center
replot  6.162e-001+ 2.000*( 9.989e-001* 1.489e-001*cos(t)+-4.753e-002* 5.848e-003*sin(t)),  5.858e-002 +2.000*( 4.753e-002* 1.489e-001*cos(t)+ 9.989e-001* 5.848e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  5.423e-001, 6.412e-002 center
replot  5.423e-001+ 2.000*( 9.985e-001* 1.078e-001*cos(t)+-5.443e-002* 6.400e-003*sin(t)),  6.412e-002 +2.000*( 5.443e-002* 1.078e-001*cos(t)+ 9.985e-001* 6.400e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  4.706e-001, 7.011e-002 center
replot  4.706e-001+ 2.000*( 9.982e-001* 8.712e-002*cos(t)+-5.952e-002* 8.411e-003*sin(t)),  7.011e-002 +2.000*( 5.952e-002* 8.712e-002*cos(t)+ 9.982e-001* 8.411e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  4.021e-001, 7.652e-002 center
replot  4.021e-001+ 2.000*( 9.978e-001* 8.701e-002*cos(t)+-6.702e-002* 1.168e-002*sin(t)),  7.652e-002 +2.000*( 6.702e-002* 8.701e-002*cos(t)+ 9.978e-001* 1.168e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  3.373e-001, 8.333e-002 center
replot  3.373e-001+ 2.000*( 9.966e-001* 9.610e-002*cos(t)+-8.282e-002* 1.601e-002*sin(t)),  8.333e-002 +2.000*( 8.282e-002* 9.610e-002*cos(t)+ 9.966e-001* 1.601e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  2.774e-001, 9.047e-002 center
replot  2.774e-001+ 2.000*( 9.942e-001* 1.042e-001*cos(t)+-1.073e-001* 2.134e-002*sin(t)),  9.047e-002 +2.000*( 1.073e-001* 1.042e-001*cos(t)+ 9.942e-001* 2.134e-002*sin(t)) not
set out;
set out "ESMgali/VARPIJGR_ESMgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ESMgali/VARPIJGR_ESMgali_123-12.svg"
set label "50" at  6.220e-002, 4.443e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  6.220e-002+ 2.000*( 9.975e-001* 3.390e-002*cos(t)+ 7.106e-002* 1.319e-002*sin(t)),  4.443e-002 +2.000*(-7.106e-002* 3.390e-002*cos(t)+ 9.975e-001* 1.319e-002*sin(t)) not
# Age 55, p23 - p12
set label "55" at  8.618e-002, 4.875e-002 center
replot  8.618e-002+ 2.000*( 9.992e-001* 3.890e-002*cos(t)+ 3.945e-002* 1.192e-002*sin(t)),  4.875e-002 +2.000*(-3.945e-002* 3.890e-002*cos(t)+ 9.992e-001* 1.192e-002*sin(t)) not
# Age 60, p23 - p12
set label "60" at  1.183e-001, 5.346e-002 center
replot  1.183e-001+ 2.000*( 9.998e-001* 4.313e-002*cos(t)+ 1.756e-002* 1.048e-002*sin(t)),  5.346e-002 +2.000*(-1.756e-002* 4.313e-002*cos(t)+ 9.998e-001* 1.048e-002*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.606e-001, 5.858e-002 center
replot  1.606e-001+ 2.000*( 1.000e+000* 4.611e-002*cos(t)+-9.298e-004* 9.178e-003*sin(t)),  5.858e-002 +2.000*( 9.298e-004* 4.611e-002*cos(t)+ 1.000e+000* 9.178e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  2.155e-001, 6.412e-002 center
replot  2.155e-001+ 2.000*( 9.998e-001* 4.814e-002*cos(t)+-2.130e-002* 8.617e-003*sin(t)),  6.412e-002 +2.000*( 2.130e-002* 4.814e-002*cos(t)+ 9.998e-001* 8.617e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  2.852e-001, 7.011e-002 center
replot  2.852e-001+ 2.000*( 9.990e-001* 5.208e-002*cos(t)+-4.513e-002* 9.594e-003*sin(t)),  7.011e-002 +2.000*( 4.513e-002* 5.208e-002*cos(t)+ 9.990e-001* 9.594e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  3.715e-001, 7.652e-002 center
replot  3.715e-001+ 2.000*( 9.982e-001* 6.429e-002*cos(t)+-5.993e-002* 1.247e-002*sin(t)),  7.652e-002 +2.000*( 5.993e-002* 6.429e-002*cos(t)+ 9.982e-001* 1.247e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  4.752e-001, 8.333e-002 center
replot  4.752e-001+ 2.000*( 9.983e-001* 9.034e-002*cos(t)+-5.752e-002* 1.709e-002*sin(t)),  8.333e-002 +2.000*( 5.752e-002* 9.034e-002*cos(t)+ 9.983e-001* 1.709e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  5.958e-001, 9.047e-002 center
replot  5.958e-001+ 2.000*( 9.987e-001* 1.301e-001*cos(t)+-5.042e-002* 2.310e-002*sin(t)),  9.047e-002 +2.000*( 5.042e-002* 1.301e-001*cos(t)+ 9.987e-001* 2.310e-002*sin(t)) not
set out;
set out "ESMgali/VARPIJGR_ESMgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ESMgali/VARPIJGR_ESMgali_121-13.svg"
set label "50" at  8.456e-001, 4.525e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  8.456e-001+ 2.000*( 1.000e+000* 3.327e-001*cos(t)+-2.321e-004* 1.710e-003*sin(t)),  4.525e-003 +2.000*( 2.321e-004* 3.327e-001*cos(t)+ 1.000e+000* 1.710e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  7.684e-001, 6.347e-003 center
replot  7.684e-001+ 2.000*( 1.000e+000* 2.662e-001*cos(t)+-3.687e-004* 1.986e-003*sin(t)),  6.347e-003 +2.000*( 3.687e-004* 2.662e-001*cos(t)+ 1.000e+000* 1.986e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  6.918e-001, 8.896e-003 center
replot  6.918e-001+ 2.000*( 1.000e+000* 2.035e-001*cos(t)+-5.844e-004* 2.260e-003*sin(t)),  8.896e-003 +2.000*( 5.844e-004* 2.035e-001*cos(t)+ 1.000e+000* 2.260e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  6.162e-001, 1.246e-002 center
replot  6.162e-001+ 2.000*( 1.000e+000* 1.488e-001*cos(t)+-8.693e-004* 2.579e-003*sin(t)),  1.246e-002 +2.000*( 8.693e-004* 1.488e-001*cos(t)+ 1.000e+000* 2.579e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  5.423e-001, 1.744e-002 center
replot  5.423e-001+ 2.000*( 1.000e+000* 1.076e-001*cos(t)+-9.820e-004* 3.152e-003*sin(t)),  1.744e-002 +2.000*( 9.820e-004* 1.076e-001*cos(t)+ 1.000e+000* 3.152e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  4.706e-001, 2.437e-002 center
replot  4.706e-001+ 2.000*( 1.000e+000* 8.697e-002*cos(t)+-3.974e-004* 4.488e-003*sin(t)),  2.437e-002 +2.000*( 3.974e-004* 8.697e-002*cos(t)+ 1.000e+000* 4.488e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  4.021e-001, 3.400e-002 center
replot  4.021e-001+ 2.000*( 1.000e+000* 8.682e-002*cos(t)+-1.235e-004* 7.320e-003*sin(t)),  3.400e-002 +2.000*( 1.235e-004* 8.682e-002*cos(t)+ 1.000e+000* 7.320e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  3.373e-001, 4.732e-002 center
replot  3.373e-001+ 2.000*( 1.000e+000* 9.578e-002*cos(t)+-2.089e-003* 1.248e-002*sin(t)),  4.732e-002 +2.000*( 2.089e-003* 9.578e-002*cos(t)+ 1.000e+000* 1.248e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  2.774e-001, 6.567e-002 center
replot  2.774e-001+ 2.000*( 1.000e+000* 1.036e-001*cos(t)+-7.637e-003* 2.103e-002*sin(t)),  6.567e-002 +2.000*( 7.637e-003* 1.036e-001*cos(t)+ 1.000e+000* 2.103e-002*sin(t)) not
set out;
set out "ESMgali/VARPIJGR_ESMgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ESMgali/VARPIJGR_ESMgali_123-13.svg"
set label "50" at  6.220e-002, 4.525e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  6.220e-002+ 2.000*( 9.998e-001* 3.384e-002*cos(t)+ 1.834e-002* 1.596e-003*sin(t)),  4.525e-003 +2.000*(-1.834e-002* 3.384e-002*cos(t)+ 9.998e-001* 1.596e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  8.618e-002, 6.347e-003 center
replot  8.618e-002+ 2.000*( 9.998e-001* 3.888e-002*cos(t)+ 1.941e-002* 1.840e-003*sin(t)),  6.347e-003 +2.000*(-1.941e-002* 3.888e-002*cos(t)+ 9.998e-001* 1.840e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  1.183e-001, 8.896e-003 center
replot  1.183e-001+ 2.000*( 9.998e-001* 4.314e-002*cos(t)+ 2.119e-002* 2.071e-003*sin(t)),  8.896e-003 +2.000*(-2.119e-002* 4.314e-002*cos(t)+ 9.998e-001* 2.071e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.606e-001, 1.246e-002 center
replot  1.606e-001+ 2.000*( 9.997e-001* 4.612e-002*cos(t)+ 2.447e-002* 2.323e-003*sin(t)),  1.246e-002 +2.000*(-2.447e-002* 4.612e-002*cos(t)+ 9.997e-001* 2.323e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  2.155e-001, 1.744e-002 center
replot  2.155e-001+ 2.000*( 9.995e-001* 4.816e-002*cos(t)+ 3.086e-002* 2.783e-003*sin(t)),  1.744e-002 +2.000*(-3.086e-002* 4.816e-002*cos(t)+ 9.995e-001* 2.783e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  2.852e-001, 2.437e-002 center
replot  2.852e-001+ 2.000*( 9.991e-001* 5.208e-002*cos(t)+ 4.178e-002* 3.929e-003*sin(t)),  2.437e-002 +2.000*(-4.178e-002* 5.208e-002*cos(t)+ 9.991e-001* 3.929e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  3.715e-001, 3.400e-002 center
replot  3.715e-001+ 2.000*( 9.986e-001* 6.427e-002*cos(t)+ 5.293e-002* 6.490e-003*sin(t)),  3.400e-002 +2.000*(-5.293e-002* 6.427e-002*cos(t)+ 9.986e-001* 6.490e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  4.752e-001, 4.732e-002 center
replot  4.752e-001+ 2.000*( 9.983e-001* 9.035e-002*cos(t)+ 5.889e-002* 1.131e-002*sin(t)),  4.732e-002 +2.000*(-5.889e-002* 9.035e-002*cos(t)+ 9.983e-001* 1.131e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  5.958e-001, 6.567e-002 center
replot  5.958e-001+ 2.000*( 9.980e-001* 1.302e-001*cos(t)+ 6.373e-002* 1.938e-002*sin(t)),  6.567e-002 +2.000*(-6.373e-002* 1.302e-001*cos(t)+ 9.980e-001* 1.938e-002*sin(t)) not
set out;
set out "ESMgali/VARPIJGR_ESMgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "ESMgali/VARPIJGR_ESMgali_123-21.svg"
set label "50" at  6.220e-002, 8.456e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  6.220e-002+ 2.000*( 2.608e-002* 3.328e-001*cos(t)+ 9.997e-001* 3.271e-002*sin(t)),  8.456e-001 +2.000*(-9.997e-001* 3.328e-001*cos(t)+ 2.608e-002* 3.271e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  8.618e-002, 7.684e-001 center
replot  8.618e-002+ 2.000*( 3.317e-002* 2.663e-001*cos(t)+ 9.994e-001* 3.787e-002*sin(t)),  7.684e-001 +2.000*(-9.994e-001* 2.663e-001*cos(t)+ 3.317e-002* 3.787e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  1.183e-001, 6.918e-001 center
replot  1.183e-001+ 2.000*( 4.330e-002* 2.037e-001*cos(t)+ 9.991e-001* 4.226e-002*sin(t)),  6.918e-001 +2.000*(-9.991e-001* 2.037e-001*cos(t)+ 4.330e-002* 4.226e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.606e-001, 6.162e-001 center
replot  1.606e-001+ 2.000*( 5.923e-002* 1.490e-001*cos(t)+ 9.982e-001* 4.533e-002*sin(t)),  6.162e-001 +2.000*(-9.982e-001* 1.490e-001*cos(t)+ 5.923e-002* 4.533e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  2.155e-001, 5.423e-001 center
replot  2.155e-001+ 2.000*( 8.447e-002* 1.080e-001*cos(t)+ 9.964e-001* 4.743e-002*sin(t)),  5.423e-001 +2.000*(-9.964e-001* 1.080e-001*cos(t)+ 8.447e-002* 4.743e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  2.852e-001, 4.706e-001 center
replot  2.852e-001+ 2.000*( 1.124e-001* 8.733e-002*cos(t)+ 9.937e-001* 5.142e-002*sin(t)),  4.706e-001 +2.000*(-9.937e-001* 8.733e-002*cos(t)+ 1.124e-001* 5.142e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  3.715e-001, 4.021e-001 center
replot  3.715e-001+ 2.000*( 1.467e-001* 8.726e-002*cos(t)+ 9.892e-001* 6.358e-002*sin(t)),  4.021e-001 +2.000*(-9.892e-001* 8.726e-002*cos(t)+ 1.467e-001* 6.358e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  4.752e-001, 3.373e-001 center
replot  4.752e-001+ 2.000*( 4.626e-001* 9.779e-002*cos(t)+ 8.866e-001* 8.802e-002*sin(t)),  3.373e-001 +2.000*(-8.866e-001* 9.779e-002*cos(t)+ 4.626e-001* 8.802e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  5.958e-001, 2.774e-001 center
replot  5.958e-001+ 2.000*( 9.790e-001* 1.310e-001*cos(t)+ 2.039e-001* 1.023e-001*sin(t)),  2.774e-001 +2.000*(-2.039e-001* 1.310e-001*cos(t)+ 9.790e-001* 1.023e-001*sin(t)) not
set out;
set out "ESMgali/VARPIJGR_ESMgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "ESMgali/VARMUPTJGR--STABLBASED_ESMgali1.svg";
 plot "ESMgali/PRMORPREV-1-STABLBASED_ESMgali.txt"  u 1:($3) not w l lt 1 
 replot "ESMgali/PRMORPREV-1-STABLBASED_ESMgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "ESMgali/PRMORPREV-1-STABLBASED_ESMgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "ESMgali/VARMUPTJGR--STABLBASED_ESMgali1.svg";replot;set out;
