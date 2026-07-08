
# IMaCh-0.99r45
# HRMgali.gp
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


set ter svg size 640, 480;set out "HRMgali/D_HRMgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "HRMgali/ILK_HRMgali-dest.png";
set log y;plot  "HRMgali/ILK_HRMgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "HRMgali/ILK_HRMgali-ori.png";
set log y;plot  "HRMgali/ILK_HRMgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "HRMgali/ILK_HRMgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "HRMgali/ILK_HRMgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "HRMgali/ILK_HRMgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "HRMgali/ILK_HRMgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "HRMgali/V_HRMgali_1-1-1.svg" 

#set out "V_HRMgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "HRMgali/VPL_HRMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"HRMgali/VPL_HRMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"HRMgali/VPL_HRMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"HRMgali/P_HRMgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "HRMgali/V_HRMgali_2-1-1.svg" 

#set out "V_HRMgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "HRMgali/VPL_HRMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"HRMgali/VPL_HRMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"HRMgali/VPL_HRMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"HRMgali/P_HRMgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "HRMgali/E_HRMgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "HRMgali/T_HRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"HRMgali/T_HRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"HRMgali/T_HRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"HRMgali/T_HRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"HRMgali/T_HRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"HRMgali/T_HRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"HRMgali/T_HRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"HRMgali/T_HRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"HRMgali/T_HRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "HRMgali/E_HRMgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "HRMgali/EXP_HRMgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "HRMgali/E_HRMgali.txt" every :::0::0 u 1:2 t "e11" w l ,"HRMgali/E_HRMgali.txt" every :::0::0 u 1:3 t "e12" w l ,"HRMgali/E_HRMgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "HRMgali/EXP_HRMgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "HRMgali/E_HRMgali.txt" every :::0::0 u 1:5 t "e21" w l ,"HRMgali/E_HRMgali.txt" every :::0::0 u 1:6 t "e22" w l ,"HRMgali/E_HRMgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "HRMgali/LIJ_HRMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMgali/PIJ_HRMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "HRMgali/LIJ_HRMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMgali/PIJ_HRMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "HRMgali/LIJT_HRMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMgali/PIJ_HRMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "HRMgali/LIJT_HRMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMgali/PIJ_HRMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "HRMgali/P_HRMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMgali/PIJ_HRMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "HRMgali/P_HRMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRMgali/PIJ_HRMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-5.850702; p2=0.042073; 
#   current state 3
p3=-12.522392; p4=0.117003; 
# initial state 2
#   current state 1
p5=-0.921666; p6=-0.008787; 
#   current state 3
p7=-7.558593; p8=0.072655; 
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

set out "HRMgali/PE_HRMgali_1-1-1.svg" 
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

set out "HRMgali/PE_HRMgali_1-2-1.svg" 
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

set out "HRMgali/PE_HRMgali_1-3-1.svg" 
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
set out "HRMgali/VARPIJGR_HRMgali_113-12.svg"
set label "50" at  2.470e-003, 4.603e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  2.470e-003+ 2.000*( 1.218e-002* 1.193e-002*cos(t)+ 9.999e-001* 1.473e-003*sin(t)),  4.603e-002 +2.000*(-9.999e-001* 1.193e-002*cos(t)+ 1.218e-002* 1.473e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  4.405e-003, 5.645e-002 center
replot  4.405e-003+ 2.000*( 1.797e-002* 1.142e-002*cos(t)+ 9.998e-001* 2.172e-003*sin(t)),  5.645e-002 +2.000*(-9.998e-001* 1.142e-002*cos(t)+ 1.797e-002* 2.172e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  7.842e-003, 6.908e-002 center
replot  7.842e-003+ 2.000*( 2.751e-002* 1.065e-002*cos(t)+ 9.996e-001* 3.097e-003*sin(t)),  6.908e-002 +2.000*(-9.996e-001* 1.065e-002*cos(t)+ 2.751e-002* 3.097e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.392e-002, 8.431e-002 center
replot  1.392e-002+ 2.000*( 4.668e-002* 1.050e-002*cos(t)+ 9.989e-001* 4.268e-003*sin(t)),  8.431e-002 +2.000*(-9.989e-001* 1.050e-002*cos(t)+ 4.668e-002* 4.268e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  2.461e-002, 1.025e-001 center
replot  2.461e-002+ 2.000*( 8.415e-002* 1.291e-002*cos(t)+ 9.965e-001* 5.877e-003*sin(t)),  1.025e-001 +2.000*(-9.965e-001* 1.291e-002*cos(t)+ 8.415e-002* 5.877e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  4.323e-002, 1.238e-001 center
replot  4.323e-002+ 2.000*( 1.437e-001* 1.945e-002*cos(t)+ 9.896e-001* 9.099e-003*sin(t)),  1.238e-001 +2.000*(-9.896e-001* 1.945e-002*cos(t)+ 1.437e-001* 9.099e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  7.522e-002, 1.481e-001 center
replot  7.522e-002+ 2.000*( 2.687e-001* 3.062e-002*cos(t)+ 9.632e-001* 1.724e-002*sin(t)),  1.481e-001 +2.000*(-9.632e-001* 3.062e-002*cos(t)+ 2.687e-001* 1.724e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  1.289e-001, 1.745e-001 center
replot  1.289e-001+ 2.000*( 5.863e-001* 4.915e-002*cos(t)+ 8.101e-001* 3.358e-002*sin(t)),  1.745e-001 +2.000*(-8.101e-001* 4.915e-002*cos(t)+ 5.863e-001* 3.358e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  2.160e-001, 2.009e-001 center
replot  2.160e-001+ 2.000*( 8.755e-001* 8.795e-002*cos(t)+ 4.832e-001* 5.300e-002*sin(t)),  2.009e-001 +2.000*(-4.832e-001* 8.795e-002*cos(t)+ 8.755e-001* 5.300e-002*sin(t)) not
set out;
set out "HRMgali/VARPIJGR_HRMgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "HRMgali/VARPIJGR_HRMgali_121-12.svg"
set label "50" at  4.018e-001, 4.603e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  4.018e-001+ 2.000*( 9.994e-001* 9.265e-002*cos(t)+-3.581e-002* 1.147e-002*sin(t)),  4.603e-002 +2.000*( 3.581e-002* 9.265e-002*cos(t)+ 9.994e-001* 1.147e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.853e-001, 5.645e-002 center
replot  3.853e-001+ 2.000*( 9.990e-001* 6.941e-002*cos(t)+-4.508e-002* 1.099e-002*sin(t)),  5.645e-002 +2.000*( 4.508e-002* 6.941e-002*cos(t)+ 9.990e-001* 1.099e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.682e-001, 6.908e-002 center
replot  3.682e-001+ 2.000*( 9.984e-001* 5.105e-002*cos(t)+-5.700e-002* 1.026e-002*sin(t)),  6.908e-002 +2.000*( 5.700e-002* 5.105e-002*cos(t)+ 9.984e-001* 1.026e-002*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.502e-001, 8.431e-002 center
replot  3.502e-001+ 2.000*( 9.973e-001* 4.132e-002*cos(t)+-7.299e-002* 1.007e-002*sin(t)),  8.431e-002 +2.000*( 7.299e-002* 4.132e-002*cos(t)+ 9.973e-001* 1.007e-002*sin(t)) not
# Age 70, p21 - p12
set label "70" at  3.310e-001, 1.025e-001 center
replot  3.310e-001+ 2.000*( 9.956e-001* 4.321e-002*cos(t)+-9.414e-002* 1.227e-002*sin(t)),  1.025e-001 +2.000*( 9.414e-002* 4.321e-002*cos(t)+ 9.956e-001* 1.227e-002*sin(t)) not
# Age 75, p21 - p12
set label "75" at  3.102e-001, 1.238e-001 center
replot  3.102e-001+ 2.000*( 9.926e-001* 5.300e-002*cos(t)+-1.213e-001* 1.833e-002*sin(t)),  1.238e-001 +2.000*( 1.213e-001* 5.300e-002*cos(t)+ 9.926e-001* 1.833e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.873e-001, 1.481e-001 center
replot  2.873e-001+ 2.000*( 9.874e-001* 6.509e-002*cos(t)+-1.583e-001* 2.837e-002*sin(t)),  1.481e-001 +2.000*( 1.583e-001* 6.509e-002*cos(t)+ 9.874e-001* 2.837e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  2.620e-001, 1.745e-001 center
replot  2.620e-001+ 2.000*( 9.769e-001* 7.653e-002*cos(t)+-2.138e-001* 4.227e-002*sin(t)),  1.745e-001 +2.000*( 2.138e-001* 7.653e-002*cos(t)+ 9.769e-001* 4.227e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  2.341e-001, 2.009e-001 center
replot  2.341e-001+ 2.000*( 9.489e-001* 8.613e-002*cos(t)+-3.156e-001* 5.981e-002*sin(t)),  2.009e-001 +2.000*( 3.156e-001* 8.613e-002*cos(t)+ 9.489e-001* 5.981e-002*sin(t)) not
set out;
set out "HRMgali/VARPIJGR_HRMgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "HRMgali/VARPIJGR_HRMgali_123-12.svg"
set label "50" at  3.091e-002, 4.603e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  3.091e-002+ 2.000*( 9.877e-001* 1.547e-002*cos(t)+-1.562e-001* 1.183e-002*sin(t)),  4.603e-002 +2.000*( 1.562e-001* 1.547e-002*cos(t)+ 9.877e-001* 1.183e-002*sin(t)) not
# Age 55, p23 - p12
set label "55" at  4.454e-002, 5.645e-002 center
replot  4.454e-002+ 2.000*( 9.974e-001* 1.801e-002*cos(t)+-7.232e-002* 1.137e-002*sin(t)),  5.645e-002 +2.000*( 7.232e-002* 1.801e-002*cos(t)+ 9.974e-001* 1.137e-002*sin(t)) not
# Age 60, p23 - p12
set label "60" at  6.395e-002, 6.908e-002 center
replot  6.395e-002+ 2.000*( 9.993e-001* 2.020e-002*cos(t)+-3.716e-002* 1.063e-002*sin(t)),  6.908e-002 +2.000*( 3.716e-002* 2.020e-002*cos(t)+ 9.993e-001* 1.063e-002*sin(t)) not
# Age 65, p23 - p12
set label "65" at  9.141e-002, 8.431e-002 center
replot  9.141e-002+ 2.000*( 9.996e-001* 2.196e-002*cos(t)+-2.981e-002* 1.047e-002*sin(t)),  8.431e-002 +2.000*( 2.981e-002* 2.196e-002*cos(t)+ 9.996e-001* 1.047e-002*sin(t)) not
# Age 70, p23 - p12
set label "70" at  1.298e-001, 1.025e-001 center
replot  1.298e-001+ 2.000*( 9.974e-001* 2.478e-002*cos(t)+-7.233e-002* 1.279e-002*sin(t)),  1.025e-001 +2.000*( 7.233e-002* 2.478e-002*cos(t)+ 9.974e-001* 1.279e-002*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.828e-001, 1.238e-001 center
replot  1.828e-001+ 2.000*( 9.877e-001* 3.383e-002*cos(t)+-1.567e-001* 1.879e-002*sin(t)),  1.238e-001 +2.000*( 1.567e-001* 3.383e-002*cos(t)+ 9.877e-001* 1.879e-002*sin(t)) not
# Age 80, p23 - p12
set label "80" at  2.544e-001, 1.481e-001 center
replot  2.544e-001+ 2.000*( 9.848e-001* 5.556e-002*cos(t)+-1.738e-001* 2.868e-002*sin(t)),  1.481e-001 +2.000*( 1.738e-001* 5.556e-002*cos(t)+ 9.848e-001* 2.868e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  3.485e-001, 1.745e-001 center
replot  3.485e-001+ 2.000*( 9.882e-001* 9.315e-002*cos(t)+-1.533e-001* 4.256e-002*sin(t)),  1.745e-001 +2.000*( 1.533e-001* 9.315e-002*cos(t)+ 9.882e-001* 4.256e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  4.681e-001, 2.009e-001 center
replot  4.681e-001+ 2.000*( 9.905e-001* 1.471e-001*cos(t)+-1.375e-001* 6.016e-002*sin(t)),  2.009e-001 +2.000*( 1.375e-001* 1.471e-001*cos(t)+ 9.905e-001* 6.016e-002*sin(t)) not
set out;
set out "HRMgali/VARPIJGR_HRMgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "HRMgali/VARPIJGR_HRMgali_121-13.svg"
set label "50" at  4.018e-001, 2.470e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  4.018e-001+ 2.000*( 1.000e+000* 9.259e-002*cos(t)+-2.896e-004* 1.479e-003*sin(t)),  2.470e-003 +2.000*( 2.896e-004* 9.259e-002*cos(t)+ 1.000e+000* 1.479e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.853e-001, 4.405e-003 center
replot  3.853e-001+ 2.000*( 1.000e+000* 6.934e-002*cos(t)+-5.601e-004* 2.181e-003*sin(t)),  4.405e-003 +2.000*( 5.601e-004* 6.934e-002*cos(t)+ 1.000e+000* 2.181e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.682e-001, 7.842e-003 center
replot  3.682e-001+ 2.000*( 1.000e+000* 5.097e-002*cos(t)+-1.114e-003* 3.109e-003*sin(t)),  7.842e-003 +2.000*( 1.114e-003* 5.097e-002*cos(t)+ 1.000e+000* 3.109e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.502e-001, 1.392e-002 center
replot  3.502e-001+ 2.000*( 1.000e+000* 4.122e-002*cos(t)+-2.249e-003* 4.290e-003*sin(t)),  1.392e-002 +2.000*( 2.249e-003* 4.122e-002*cos(t)+ 1.000e+000* 4.290e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  3.310e-001, 2.461e-002 center
replot  3.310e-001+ 2.000*( 1.000e+000* 4.304e-002*cos(t)+-4.601e-003* 5.953e-003*sin(t)),  2.461e-002 +2.000*( 4.601e-003* 4.304e-002*cos(t)+ 1.000e+000* 5.953e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  3.102e-001, 4.323e-002 center
replot  3.102e-001+ 2.000*( 9.999e-001* 5.265e-002*cos(t)+-1.002e-002* 9.414e-003*sin(t)),  4.323e-002 +2.000*( 1.002e-002* 5.265e-002*cos(t)+ 9.999e-001* 9.414e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.873e-001, 7.522e-002 center
replot  2.873e-001+ 2.000*( 9.997e-001* 6.445e-002*cos(t)+-2.374e-002* 1.847e-002*sin(t)),  7.522e-002 +2.000*( 2.374e-002* 6.445e-002*cos(t)+ 9.997e-001* 1.847e-002*sin(t)) not
# Age 85, p21 - p13
set label "85" at  2.620e-001, 1.289e-001 center
replot  2.620e-001+ 2.000*( 9.977e-001* 7.543e-002*cos(t)+-6.796e-002* 3.939e-002*sin(t)),  1.289e-001 +2.000*( 6.796e-002* 7.543e-002*cos(t)+ 9.977e-001* 3.939e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  2.341e-001, 2.160e-001 center
replot  2.341e-001+ 2.000*( 8.000e-001* 8.725e-002*cos(t)+-6.000e-001* 7.751e-002*sin(t)),  2.160e-001 +2.000*( 6.000e-001* 8.725e-002*cos(t)+ 8.000e-001* 7.751e-002*sin(t)) not
set out;
set out "HRMgali/VARPIJGR_HRMgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "HRMgali/VARPIJGR_HRMgali_123-13.svg"
set label "50" at  3.091e-002, 2.470e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  3.091e-002+ 2.000*( 9.998e-001* 1.540e-002*cos(t)+ 2.067e-002* 1.445e-003*sin(t)),  2.470e-003 +2.000*(-2.067e-002* 1.540e-002*cos(t)+ 9.998e-001* 1.445e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  4.454e-002, 4.405e-003 center
replot  4.454e-002+ 2.000*( 9.997e-001* 1.798e-002*cos(t)+ 2.475e-002* 2.136e-003*sin(t)),  4.405e-003 +2.000*(-2.475e-002* 1.798e-002*cos(t)+ 9.997e-001* 2.136e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  6.395e-002, 7.842e-003 center
replot  6.395e-002+ 2.000*( 9.996e-001* 2.019e-002*cos(t)+ 2.950e-002* 3.053e-003*sin(t)),  7.842e-003 +2.000*(-2.950e-002* 2.019e-002*cos(t)+ 9.996e-001* 3.053e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  9.141e-002, 1.392e-002 center
replot  9.141e-002+ 2.000*( 9.993e-001* 2.197e-002*cos(t)+ 3.624e-002* 4.220e-003*sin(t)),  1.392e-002 +2.000*(-3.624e-002* 2.197e-002*cos(t)+ 9.993e-001* 4.220e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  1.298e-001, 2.461e-002 center
replot  1.298e-001+ 2.000*( 9.986e-001* 2.476e-002*cos(t)+ 5.214e-002* 5.822e-003*sin(t)),  2.461e-002 +2.000*(-5.214e-002* 2.476e-002*cos(t)+ 9.986e-001* 5.822e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.828e-001, 4.323e-002 center
replot  1.828e-001+ 2.000*( 9.961e-001* 3.367e-002*cos(t)+ 8.817e-002* 8.984e-003*sin(t)),  4.323e-002 +2.000*(-8.817e-002* 3.367e-002*cos(t)+ 9.961e-001* 8.984e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  2.544e-001, 7.522e-002 center
replot  2.544e-001+ 2.000*( 9.910e-001* 5.539e-002*cos(t)+ 1.337e-001* 1.714e-002*sin(t)),  7.522e-002 +2.000*(-1.337e-001* 5.539e-002*cos(t)+ 9.910e-001* 1.714e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  3.485e-001, 1.289e-001 center
replot  3.485e-001+ 2.000*( 9.824e-001* 9.369e-002*cos(t)+ 1.869e-001* 3.619e-002*sin(t)),  1.289e-001 +2.000*(-1.869e-001* 9.369e-002*cos(t)+ 9.824e-001* 3.619e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  4.681e-001, 2.160e-001 center
replot  4.681e-001+ 2.000*( 9.643e-001* 1.499e-001*cos(t)+ 2.649e-001* 7.339e-002*sin(t)),  2.160e-001 +2.000*(-2.649e-001* 1.499e-001*cos(t)+ 9.643e-001* 7.339e-002*sin(t)) not
set out;
set out "HRMgali/VARPIJGR_HRMgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "HRMgali/VARPIJGR_HRMgali_123-21.svg"
set label "50" at  3.091e-002, 4.018e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  3.091e-002+ 2.000*( 7.651e-003* 9.259e-002*cos(t)+ 1.000e+000* 1.538e-002*sin(t)),  4.018e-001 +2.000*(-1.000e+000* 9.259e-002*cos(t)+ 7.651e-003* 1.538e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  4.454e-002, 3.853e-001 center
replot  4.454e-002+ 2.000*( 1.498e-002* 6.935e-002*cos(t)+ 9.999e-001* 1.795e-002*sin(t)),  3.853e-001 +2.000*(-9.999e-001* 6.935e-002*cos(t)+ 1.498e-002* 1.795e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  6.395e-002, 3.682e-001 center
replot  6.395e-002+ 2.000*( 3.321e-002* 5.099e-002*cos(t)+ 9.994e-001* 2.013e-002*sin(t)),  3.682e-001 +2.000*(-9.994e-001* 5.099e-002*cos(t)+ 3.321e-002* 2.013e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  9.141e-002, 3.502e-001 center
replot  9.141e-002+ 2.000*( 6.760e-002* 4.129e-002*cos(t)+ 9.977e-001* 2.182e-002*sin(t)),  3.502e-001 +2.000*(-9.977e-001* 4.129e-002*cos(t)+ 6.760e-002* 2.182e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  1.298e-001, 3.310e-001 center
replot  1.298e-001+ 2.000*( 8.855e-002* 4.315e-002*cos(t)+ 9.961e-001* 2.453e-002*sin(t)),  3.310e-001 +2.000*(-9.961e-001* 4.315e-002*cos(t)+ 8.855e-002* 2.453e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.828e-001, 3.102e-001 center
replot  1.828e-001+ 2.000*( 1.251e-001* 5.290e-002*cos(t)+ 9.921e-001* 3.315e-002*sin(t)),  3.102e-001 +2.000*(-9.921e-001* 5.290e-002*cos(t)+ 1.251e-001* 3.315e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  2.544e-001, 2.873e-001 center
replot  2.544e-001+ 2.000*( 3.670e-001* 6.603e-002*cos(t)+ 9.302e-001* 5.300e-002*sin(t)),  2.873e-001 +2.000*(-9.302e-001* 6.603e-002*cos(t)+ 3.670e-001* 5.300e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  3.485e-001, 2.620e-001 center
replot  3.485e-001+ 2.000*( 9.271e-001* 9.525e-002*cos(t)+ 3.748e-001* 7.152e-002*sin(t)),  2.620e-001 +2.000*(-3.748e-001* 9.525e-002*cos(t)+ 9.271e-001* 7.152e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  4.681e-001, 2.341e-001 center
replot  4.681e-001+ 2.000*( 9.776e-001* 1.482e-001*cos(t)+ 2.107e-001* 7.963e-002*sin(t)),  2.341e-001 +2.000*(-2.107e-001* 1.482e-001*cos(t)+ 9.776e-001* 7.963e-002*sin(t)) not
set out;
set out "HRMgali/VARPIJGR_HRMgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "HRMgali/VARMUPTJGR--STABLBASED_HRMgali1.svg";
 plot "HRMgali/PRMORPREV-1-STABLBASED_HRMgali.txt"  u 1:($3) not w l lt 1 
 replot "HRMgali/PRMORPREV-1-STABLBASED_HRMgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "HRMgali/PRMORPREV-1-STABLBASED_HRMgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "HRMgali/VARMUPTJGR--STABLBASED_HRMgali1.svg";replot;set out;
