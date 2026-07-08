
# IMaCh-0.99r45
# EEFgali.gp
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


set ter svg size 640, 480;set out "EEFgali/D_EEFgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "EEFgali/ILK_EEFgali-dest.png";
set log y;plot  "EEFgali/ILK_EEFgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "EEFgali/ILK_EEFgali-ori.png";
set log y;plot  "EEFgali/ILK_EEFgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "EEFgali/ILK_EEFgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "EEFgali/ILK_EEFgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "EEFgali/ILK_EEFgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "EEFgali/ILK_EEFgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "EEFgali/V_EEFgali_1-1-1.svg" 

#set out "V_EEFgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "EEFgali/VPL_EEFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"EEFgali/VPL_EEFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"EEFgali/VPL_EEFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"EEFgali/P_EEFgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "EEFgali/V_EEFgali_2-1-1.svg" 

#set out "V_EEFgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "EEFgali/VPL_EEFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"EEFgali/VPL_EEFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"EEFgali/VPL_EEFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"EEFgali/P_EEFgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "EEFgali/E_EEFgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "EEFgali/T_EEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"EEFgali/T_EEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"EEFgali/T_EEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"EEFgali/T_EEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"EEFgali/T_EEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"EEFgali/T_EEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"EEFgali/T_EEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"EEFgali/T_EEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"EEFgali/T_EEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "EEFgali/E_EEFgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "EEFgali/EXP_EEFgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "EEFgali/E_EEFgali.txt" every :::0::0 u 1:2 t "e11" w l ,"EEFgali/E_EEFgali.txt" every :::0::0 u 1:3 t "e12" w l ,"EEFgali/E_EEFgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "EEFgali/EXP_EEFgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "EEFgali/E_EEFgali.txt" every :::0::0 u 1:5 t "e21" w l ,"EEFgali/E_EEFgali.txt" every :::0::0 u 1:6 t "e22" w l ,"EEFgali/E_EEFgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "EEFgali/LIJ_EEFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFgali/PIJ_EEFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "EEFgali/LIJ_EEFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFgali/PIJ_EEFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "EEFgali/LIJT_EEFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFgali/PIJ_EEFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "EEFgali/LIJT_EEFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFgali/PIJ_EEFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "EEFgali/P_EEFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFgali/PIJ_EEFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "EEFgali/P_EEFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "EEFgali/PIJ_EEFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-5.838183; p2=0.044323; 
#   current state 3
p3=-12.573028; p4=0.104051; 
# initial state 2
#   current state 1
p5=-0.844568; p6=-0.015459; 
#   current state 3
p7=-9.509493; p8=0.084336; 
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

set out "EEFgali/PE_EEFgali_1-1-1.svg" 
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

set out "EEFgali/PE_EEFgali_1-2-1.svg" 
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

set out "EEFgali/PE_EEFgali_1-3-1.svg" 
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
set out "EEFgali/VARPIJGR_EEFgali_113-12.svg"
set label "50" at  1.226e-003, 5.203e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  1.226e-003+ 2.000*( 1.798e-002* 7.361e-003*cos(t)+ 9.998e-001* 8.501e-004*sin(t)),  5.203e-002 +2.000*(-9.998e-001* 7.361e-003*cos(t)+ 1.798e-002* 8.501e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  2.048e-003, 6.450e-002 center
replot  2.048e-003+ 2.000*( 2.288e-002* 7.279e-003*cos(t)+ 9.997e-001* 1.166e-003*sin(t)),  6.450e-002 +2.000*(-9.997e-001* 7.279e-003*cos(t)+ 2.288e-002* 1.166e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  3.416e-003, 7.980e-002 center
replot  3.416e-003+ 2.000*( 2.737e-002* 6.960e-003*cos(t)+ 9.996e-001* 1.535e-003*sin(t)),  7.980e-002 +2.000*(-9.996e-001* 6.960e-003*cos(t)+ 2.737e-002* 1.535e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  5.684e-003, 9.851e-002 center
replot  5.684e-003+ 2.000*( 2.920e-002* 6.653e-003*cos(t)+ 9.996e-001* 1.921e-003*sin(t)),  9.851e-002 +2.000*(-9.996e-001* 6.653e-003*cos(t)+ 2.920e-002* 1.921e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  9.430e-003, 1.212e-001 center
replot  9.430e-003+ 2.000*( 3.526e-002* 7.199e-003*cos(t)+ 9.994e-001* 2.337e-003*sin(t)),  1.212e-001 +2.000*(-9.994e-001* 7.199e-003*cos(t)+ 3.526e-002* 2.337e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.558e-002, 1.486e-001 center
replot  1.558e-002+ 2.000*( 7.140e-002* 9.862e-003*cos(t)+ 9.974e-001* 3.242e-003*sin(t)),  1.486e-001 +2.000*(-9.974e-001* 9.862e-003*cos(t)+ 7.140e-002* 3.242e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  2.561e-002, 1.812e-001 center
replot  2.561e-002+ 2.000*( 1.460e-001* 1.531e-002*cos(t)+ 9.893e-001* 6.143e-003*sin(t)),  1.812e-001 +2.000*(-9.893e-001* 1.531e-002*cos(t)+ 1.460e-001* 6.143e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  4.178e-002, 2.193e-001 center
replot  4.178e-002+ 2.000*( 2.933e-001* 2.405e-002*cos(t)+ 9.560e-001* 1.302e-002*sin(t)),  2.193e-001 +2.000*(-9.560e-001* 2.405e-002*cos(t)+ 2.933e-001* 1.302e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  6.749e-002, 2.628e-001 center
replot  6.749e-002+ 2.000*( 5.869e-001* 3.862e-002*cos(t)+ 8.097e-001* 2.489e-002*sin(t)),  2.628e-001 +2.000*(-8.097e-001* 3.862e-002*cos(t)+ 5.869e-001* 2.489e-002*sin(t)) not
set out;
set out "EEFgali/VARPIJGR_EEFgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "EEFgali/VARPIJGR_EEFgali_121-12.svg"
set label "50" at  3.297e-001, 5.203e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  3.297e-001+ 2.000*( 9.990e-001* 4.183e-002*cos(t)+-4.535e-002* 7.118e-003*sin(t)),  5.203e-002 +2.000*( 4.535e-002* 4.183e-002*cos(t)+ 9.990e-001* 7.118e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.083e-001, 6.450e-002 center
replot  3.083e-001+ 2.000*( 9.983e-001* 3.229e-002*cos(t)+-5.886e-002* 7.037e-003*sin(t)),  6.450e-002 +2.000*( 5.886e-002* 3.229e-002*cos(t)+ 9.983e-001* 7.037e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.877e-001, 7.980e-002 center
replot  2.877e-001+ 2.000*( 9.970e-001* 2.434e-002*cos(t)+-7.715e-002* 6.719e-003*sin(t)),  7.980e-002 +2.000*( 7.715e-002* 2.434e-002*cos(t)+ 9.970e-001* 6.719e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.678e-001, 9.851e-002 center
replot  2.678e-001+ 2.000*( 9.945e-001* 1.852e-002*cos(t)+-1.049e-001* 6.396e-003*sin(t)),  9.851e-002 +2.000*( 1.049e-001* 1.852e-002*cos(t)+ 9.945e-001* 6.396e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.483e-001, 1.212e-001 center
replot  2.483e-001+ 2.000*( 9.877e-001* 1.568e-002*cos(t)+-1.565e-001* 6.848e-003*sin(t)),  1.212e-001 +2.000*( 1.565e-001* 1.568e-002*cos(t)+ 9.877e-001* 6.848e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.292e-001, 1.486e-001 center
replot  2.292e-001+ 2.000*( 9.655e-001* 1.614e-002*cos(t)+-2.604e-001* 9.215e-003*sin(t)),  1.486e-001 +2.000*( 2.604e-001* 1.614e-002*cos(t)+ 9.655e-001* 9.215e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.101e-001, 1.812e-001 center
replot  2.101e-001+ 2.000*( 8.739e-001* 1.911e-002*cos(t)+-4.862e-001* 1.372e-002*sin(t)),  1.812e-001 +2.000*( 4.862e-001* 1.911e-002*cos(t)+ 8.739e-001* 1.372e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.906e-001, 2.193e-001 center
replot  1.906e-001+ 2.000*( 5.407e-001* 2.495e-002*cos(t)+-8.412e-001* 1.874e-002*sin(t)),  2.193e-001 +2.000*( 8.412e-001* 2.495e-002*cos(t)+ 5.407e-001* 1.874e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.705e-001, 2.628e-001 center
replot  1.705e-001+ 2.000*( 2.496e-001* 3.518e-002*cos(t)+-9.683e-001* 2.222e-002*sin(t)),  2.628e-001 +2.000*( 9.683e-001* 3.518e-002*cos(t)+ 2.496e-001* 2.222e-002*sin(t)) not
set out;
set out "EEFgali/VARPIJGR_EEFgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "EEFgali/VARPIJGR_EEFgali_123-12.svg"
set label "50" at  8.356e-003, 5.203e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  8.356e-003+ 2.000*( 6.070e-002* 7.370e-003*cos(t)+-9.982e-001* 3.577e-003*sin(t)),  5.203e-002 +2.000*( 9.982e-001* 7.370e-003*cos(t)+ 6.070e-002* 3.577e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.287e-002, 6.450e-002 center
replot  1.287e-002+ 2.000*( 9.540e-002* 7.297e-003*cos(t)+-9.954e-001* 4.638e-003*sin(t)),  6.450e-002 +2.000*( 9.954e-001* 7.297e-003*cos(t)+ 9.540e-002* 4.638e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  1.978e-002, 7.980e-002 center
replot  1.978e-002+ 2.000*( 2.119e-001* 7.007e-003*cos(t)+-9.773e-001* 5.801e-003*sin(t)),  7.980e-002 +2.000*( 9.773e-001* 7.007e-003*cos(t)+ 2.119e-001* 5.801e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  3.032e-002, 9.851e-002 center
replot  3.032e-002+ 2.000*( 9.125e-001* 7.125e-003*cos(t)+-4.090e-001* 6.551e-003*sin(t)),  9.851e-002 +2.000*( 4.090e-001* 7.125e-003*cos(t)+ 9.125e-001* 6.551e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  4.632e-002, 1.212e-001 center
replot  4.632e-002+ 2.000*( 9.761e-001* 8.020e-003*cos(t)+-2.175e-001* 7.152e-003*sin(t)),  1.212e-001 +2.000*( 2.175e-001* 8.020e-003*cos(t)+ 9.761e-001* 7.152e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  7.041e-002, 1.486e-001 center
replot  7.041e-002+ 2.000*( 2.619e-001* 9.923e-003*cos(t)+-9.651e-001* 8.630e-003*sin(t)),  1.486e-001 +2.000*( 9.651e-001* 9.923e-003*cos(t)+ 2.619e-001* 8.630e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.063e-001, 1.812e-001 center
replot  1.063e-001+ 2.000*( 1.991e-001* 1.533e-002*cos(t)+-9.800e-001* 1.060e-002*sin(t)),  1.812e-001 +2.000*( 9.800e-001* 1.533e-002*cos(t)+ 1.991e-001* 1.060e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.588e-001, 2.193e-001 center
replot  1.588e-001+ 2.000*( 3.632e-001* 2.403e-002*cos(t)+-9.317e-001* 1.776e-002*sin(t)),  2.193e-001 +2.000*( 9.317e-001* 2.403e-002*cos(t)+ 3.632e-001* 1.776e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.341e-001, 2.628e-001 center
replot  2.341e-001+ 2.000*( 7.801e-001* 3.934e-002*cos(t)+-6.257e-001* 3.102e-002*sin(t)),  2.628e-001 +2.000*( 6.257e-001* 3.934e-002*cos(t)+ 7.801e-001* 3.102e-002*sin(t)) not
set out;
set out "EEFgali/VARPIJGR_EEFgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "EEFgali/VARPIJGR_EEFgali_121-13.svg"
set label "50" at  3.297e-001, 1.226e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  3.297e-001+ 2.000*( 1.000e+000* 4.179e-002*cos(t)+-1.331e-003* 8.584e-004*sin(t)),  1.226e-003 +2.000*( 1.331e-003* 4.179e-002*cos(t)+ 1.000e+000* 8.584e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.083e-001, 2.048e-003 center
replot  3.083e-001+ 2.000*( 1.000e+000* 3.223e-002*cos(t)+-2.268e-003* 1.175e-003*sin(t)),  2.048e-003 +2.000*( 2.268e-003* 3.223e-002*cos(t)+ 1.000e+000* 1.175e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.877e-001, 3.416e-003 center
replot  2.877e-001+ 2.000*( 1.000e+000* 2.427e-002*cos(t)+-3.729e-003* 1.543e-003*sin(t)),  3.416e-003 +2.000*( 3.729e-003* 2.427e-002*cos(t)+ 1.000e+000* 1.543e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.678e-001, 5.684e-003 center
replot  2.678e-001+ 2.000*( 1.000e+000* 1.843e-002*cos(t)+-5.677e-003* 1.927e-003*sin(t)),  5.684e-003 +2.000*( 5.677e-003* 1.843e-002*cos(t)+ 1.000e+000* 1.927e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.483e-001, 9.430e-003 center
replot  2.483e-001+ 2.000*( 1.000e+000* 1.552e-002*cos(t)+-8.300e-003* 2.346e-003*sin(t)),  9.430e-003 +2.000*( 8.300e-003* 1.552e-002*cos(t)+ 1.000e+000* 2.346e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.292e-001, 1.558e-002 center
replot  2.292e-001+ 2.000*( 9.999e-001* 1.577e-002*cos(t)+-1.582e-002* 3.301e-003*sin(t)),  1.558e-002 +2.000*( 1.582e-002* 1.577e-002*cos(t)+ 9.999e-001* 3.301e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.101e-001, 2.561e-002 center
replot  2.101e-001+ 2.000*( 9.992e-001* 1.800e-002*cos(t)+-4.036e-002* 6.440e-003*sin(t)),  2.561e-002 +2.000*( 4.036e-002* 1.800e-002*cos(t)+ 9.992e-001* 6.440e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.906e-001, 4.178e-002 center
replot  1.906e-001+ 2.000*( 9.883e-001* 2.088e-002*cos(t)+-1.523e-001* 1.411e-002*sin(t)),  4.178e-002 +2.000*( 1.523e-001* 2.088e-002*cos(t)+ 9.883e-001* 1.411e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.705e-001, 6.749e-002 center
replot  1.705e-001+ 2.000*( 2.465e-001* 3.076e-002*cos(t)+-9.691e-001* 2.267e-002*sin(t)),  6.749e-002 +2.000*( 9.691e-001* 3.076e-002*cos(t)+ 2.465e-001* 2.267e-002*sin(t)) not
set out;
set out "EEFgali/VARPIJGR_EEFgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "EEFgali/VARPIJGR_EEFgali_123-13.svg"
set label "50" at  8.356e-003, 1.226e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  8.356e-003+ 2.000*( 9.951e-001* 3.615e-003*cos(t)+ 9.904e-002* 7.860e-004*sin(t)),  1.226e-003 +2.000*(-9.904e-002* 3.615e-003*cos(t)+ 9.951e-001* 7.860e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.287e-002, 2.048e-003 center
replot  1.287e-002+ 2.000*( 9.947e-001* 4.693e-003*cos(t)+ 1.033e-001* 1.079e-003*sin(t)),  2.048e-003 +2.000*(-1.033e-001* 4.693e-003*cos(t)+ 9.947e-001* 1.079e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  1.978e-002, 3.416e-003 center
replot  1.978e-002+ 2.000*( 9.944e-001* 5.891e-003*cos(t)+ 1.058e-001* 1.423e-003*sin(t)),  3.416e-003 +2.000*(-1.058e-001* 5.891e-003*cos(t)+ 9.944e-001* 1.423e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  3.032e-002, 5.684e-003 center
replot  3.032e-002+ 2.000*( 9.944e-001* 7.069e-003*cos(t)+ 1.055e-001* 1.790e-003*sin(t)),  5.684e-003 +2.000*(-1.055e-001* 7.069e-003*cos(t)+ 9.944e-001* 1.790e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  4.632e-002, 9.430e-003 center
replot  4.632e-002+ 2.000*( 9.946e-001* 8.022e-003*cos(t)+ 1.042e-001* 2.208e-003*sin(t)),  9.430e-003 +2.000*(-1.042e-001* 8.022e-003*cos(t)+ 9.946e-001* 2.208e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  7.041e-002, 1.558e-002 center
replot  7.041e-002+ 2.000*( 9.921e-001* 8.785e-003*cos(t)+ 1.258e-001* 3.145e-003*sin(t)),  1.558e-002 +2.000*(-1.258e-001* 8.785e-003*cos(t)+ 9.921e-001* 3.145e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.063e-001, 2.561e-002 center
replot  1.063e-001+ 2.000*( 9.599e-001* 1.115e-002*cos(t)+ 2.804e-001* 5.908e-003*sin(t)),  2.561e-002 +2.000*(-2.804e-001* 1.115e-002*cos(t)+ 9.599e-001* 5.908e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.588e-001, 4.178e-002 center
replot  1.588e-001+ 2.000*( 8.776e-001* 2.030e-002*cos(t)+ 4.795e-001* 1.195e-002*sin(t)),  4.178e-002 +2.000*(-4.795e-001* 2.030e-002*cos(t)+ 8.776e-001* 1.195e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.341e-001, 6.749e-002 center
replot  2.341e-001+ 2.000*( 8.293e-001* 4.061e-002*cos(t)+ 5.588e-001* 2.426e-002*sin(t)),  6.749e-002 +2.000*(-5.588e-001* 4.061e-002*cos(t)+ 8.293e-001* 2.426e-002*sin(t)) not
set out;
set out "EEFgali/VARPIJGR_EEFgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "EEFgali/VARPIJGR_EEFgali_123-21.svg"
set label "50" at  8.356e-003, 3.297e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  8.356e-003+ 2.000*( 5.492e-003* 4.179e-002*cos(t)+ 1.000e+000* 3.591e-003*sin(t)),  3.297e-001 +2.000*(-1.000e+000* 4.179e-002*cos(t)+ 5.492e-003* 3.591e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.287e-002, 3.083e-001 center
replot  1.287e-002+ 2.000*( 9.591e-003* 3.224e-002*cos(t)+ 1.000e+000* 4.659e-003*sin(t)),  3.083e-001 +2.000*(-1.000e+000* 3.224e-002*cos(t)+ 9.591e-003* 4.659e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  1.978e-002, 2.877e-001 center
replot  1.978e-002+ 2.000*( 1.791e-002* 2.427e-002*cos(t)+ 9.998e-001* 5.845e-003*sin(t)),  2.877e-001 +2.000*(-9.998e-001* 2.427e-002*cos(t)+ 1.791e-002* 5.845e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  3.032e-002, 2.678e-001 center
replot  3.032e-002+ 2.000*( 3.470e-002* 1.844e-002*cos(t)+ 9.994e-001* 7.007e-003*sin(t)),  2.678e-001 +2.000*(-9.994e-001* 1.844e-002*cos(t)+ 3.470e-002* 7.007e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  4.632e-002, 2.483e-001 center
replot  4.632e-002+ 2.000*( 5.793e-002* 1.554e-002*cos(t)+ 9.983e-001* 7.944e-003*sin(t)),  2.483e-001 +2.000*(-9.983e-001* 1.554e-002*cos(t)+ 5.793e-002* 7.944e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  7.041e-002, 2.292e-001 center
replot  7.041e-002+ 2.000*( 6.677e-002* 1.579e-002*cos(t)+ 9.978e-001* 8.680e-003*sin(t)),  2.292e-001 +2.000*(-9.978e-001* 1.579e-002*cos(t)+ 6.677e-002* 8.680e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.063e-001, 2.101e-001 center
replot  1.063e-001+ 2.000*( 9.058e-002* 1.803e-002*cos(t)+ 9.959e-001* 1.075e-002*sin(t)),  2.101e-001 +2.000*(-9.959e-001* 1.803e-002*cos(t)+ 9.058e-002* 1.075e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.588e-001, 1.906e-001 center
replot  1.588e-001+ 2.000*( 4.336e-001* 2.132e-002*cos(t)+ 9.011e-001* 1.805e-002*sin(t)),  1.906e-001 +2.000*(-9.011e-001* 2.132e-002*cos(t)+ 4.336e-001* 1.805e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.341e-001, 1.705e-001 center
replot  2.341e-001+ 2.000*( 9.820e-001* 3.672e-002*cos(t)+ 1.890e-001* 2.259e-002*sin(t)),  1.705e-001 +2.000*(-1.890e-001* 3.672e-002*cos(t)+ 9.820e-001* 2.259e-002*sin(t)) not
set out;
set out "EEFgali/VARPIJGR_EEFgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "EEFgali/VARMUPTJGR--STABLBASED_EEFgali1.svg";
 plot "EEFgali/PRMORPREV-1-STABLBASED_EEFgali.txt"  u 1:($3) not w l lt 1 
 replot "EEFgali/PRMORPREV-1-STABLBASED_EEFgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "EEFgali/PRMORPREV-1-STABLBASED_EEFgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "EEFgali/VARMUPTJGR--STABLBASED_EEFgali1.svg";replot;set out;
