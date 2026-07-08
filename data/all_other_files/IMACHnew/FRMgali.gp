
# IMaCh-0.99r45
# FRMgali.gp
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


set ter svg size 640, 480;set out "FRMgali/D_FRMgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "FRMgali/ILK_FRMgali-dest.png";
set log y;plot  "FRMgali/ILK_FRMgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "FRMgali/ILK_FRMgali-ori.png";
set log y;plot  "FRMgali/ILK_FRMgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "FRMgali/ILK_FRMgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "FRMgali/ILK_FRMgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "FRMgali/ILK_FRMgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "FRMgali/ILK_FRMgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "FRMgali/V_FRMgali_1-1-1.svg" 

#set out "V_FRMgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "FRMgali/VPL_FRMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"FRMgali/VPL_FRMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"FRMgali/VPL_FRMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"FRMgali/P_FRMgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "FRMgali/V_FRMgali_2-1-1.svg" 

#set out "V_FRMgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "FRMgali/VPL_FRMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"FRMgali/VPL_FRMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"FRMgali/VPL_FRMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"FRMgali/P_FRMgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "FRMgali/E_FRMgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "FRMgali/T_FRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"FRMgali/T_FRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"FRMgali/T_FRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"FRMgali/T_FRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"FRMgali/T_FRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"FRMgali/T_FRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"FRMgali/T_FRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"FRMgali/T_FRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"FRMgali/T_FRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "FRMgali/E_FRMgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "FRMgali/EXP_FRMgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "FRMgali/E_FRMgali.txt" every :::0::0 u 1:2 t "e11" w l ,"FRMgali/E_FRMgali.txt" every :::0::0 u 1:3 t "e12" w l ,"FRMgali/E_FRMgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "FRMgali/EXP_FRMgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "FRMgali/E_FRMgali.txt" every :::0::0 u 1:5 t "e21" w l ,"FRMgali/E_FRMgali.txt" every :::0::0 u 1:6 t "e22" w l ,"FRMgali/E_FRMgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "FRMgali/LIJ_FRMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRMgali/PIJ_FRMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "FRMgali/LIJ_FRMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRMgali/PIJ_FRMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "FRMgali/LIJT_FRMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRMgali/PIJ_FRMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "FRMgali/LIJT_FRMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRMgali/PIJ_FRMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "FRMgali/P_FRMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRMgali/PIJ_FRMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "FRMgali/P_FRMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRMgali/PIJ_FRMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-9.164935; p2=0.079926; 
#   current state 3
p3=-10.513400; p4=0.073203; 
# initial state 2
#   current state 1
p5=0.363548; p6=-0.033702; 
#   current state 3
p7=-10.201899; p8=0.102063; 
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

set out "FRMgali/PE_FRMgali_1-1-1.svg" 
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

set out "FRMgali/PE_FRMgali_1-2-1.svg" 
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

set out "FRMgali/PE_FRMgali_1-3-1.svg" 
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
set out "FRMgali/VARPIJGR_FRMgali_113-12.svg"
set label "50" at  2.098e-003, 1.131e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  2.098e-003+ 2.000*( 9.975e-002* 3.429e-003*cos(t)+ 9.950e-001* 1.523e-003*sin(t)),  1.131e-002 +2.000*(-9.950e-001* 3.429e-003*cos(t)+ 9.975e-002* 1.523e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  3.015e-003, 1.681e-002 center
replot  3.015e-003+ 2.000*( 7.806e-002* 4.122e-003*cos(t)+ 9.969e-001* 1.724e-003*sin(t)),  1.681e-002 +2.000*(-9.969e-001* 4.122e-003*cos(t)+ 7.806e-002* 1.724e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  4.327e-003, 2.495e-002 center
replot  4.327e-003+ 2.000*( 5.454e-002* 4.776e-003*cos(t)+ 9.985e-001* 1.866e-003*sin(t)),  2.495e-002 +2.000*(-9.985e-001* 4.776e-003*cos(t)+ 5.454e-002* 1.866e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  6.196e-003, 3.694e-002 center
replot  6.196e-003+ 2.000*( 3.836e-002* 5.409e-003*cos(t)+ 9.993e-001* 2.010e-003*sin(t)),  3.694e-002 +2.000*(-9.993e-001* 5.409e-003*cos(t)+ 3.836e-002* 2.010e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  8.842e-003, 5.452e-002 center
replot  8.842e-003+ 2.000*( 6.778e-002* 6.520e-003*cos(t)+ 9.977e-001* 2.590e-003*sin(t)),  5.452e-002 +2.000*(-9.977e-001* 6.520e-003*cos(t)+ 6.778e-002* 2.590e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.256e-002, 8.008e-002 center
replot  1.256e-002+ 2.000*( 1.618e-001* 9.845e-003*cos(t)+ 9.868e-001* 4.368e-003*sin(t)),  8.008e-002 +2.000*(-9.868e-001* 9.845e-003*cos(t)+ 1.618e-001* 4.368e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  1.771e-002, 1.168e-001 center
replot  1.771e-002+ 2.000*( 2.214e-001* 1.786e-002*cos(t)+ 9.752e-001* 8.003e-003*sin(t)),  1.168e-001 +2.000*(-9.752e-001* 1.786e-002*cos(t)+ 2.214e-001* 8.003e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  2.473e-002, 1.687e-001 center
replot  2.473e-002+ 2.000*( 2.385e-001* 3.285e-002*cos(t)+ 9.711e-001* 1.436e-002*sin(t)),  1.687e-001 +2.000*(-9.711e-001* 3.285e-002*cos(t)+ 2.385e-001* 1.436e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  3.406e-002, 2.403e-001 center
replot  3.406e-002+ 2.000*( 2.474e-001* 5.737e-002*cos(t)+ 9.689e-001* 2.442e-002*sin(t)),  2.403e-001 +2.000*(-9.689e-001* 5.737e-002*cos(t)+ 2.474e-001* 2.442e-002*sin(t)) not
set out;
set out "FRMgali/VARPIJGR_FRMgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "FRMgali/VARPIJGR_FRMgali_121-12.svg"
set label "50" at  4.191e-001, 1.131e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  4.191e-001+ 2.000*( 1.000e+000* 9.253e-002*cos(t)+-7.822e-003* 3.338e-003*sin(t)),  1.131e-002 +2.000*( 7.822e-003* 9.253e-002*cos(t)+ 1.000e+000* 3.338e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.648e-001, 1.681e-002 center
replot  3.648e-001+ 2.000*( 9.999e-001* 6.562e-002*cos(t)+-1.330e-002* 4.018e-003*sin(t)),  1.681e-002 +2.000*( 1.330e-002* 6.562e-002*cos(t)+ 9.999e-001* 4.018e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.154e-001, 2.495e-002 center
replot  3.154e-001+ 2.000*( 9.997e-001* 4.567e-002*cos(t)+-2.252e-002* 4.659e-003*sin(t)),  2.495e-002 +2.000*( 2.252e-002* 4.567e-002*cos(t)+ 9.997e-001* 4.659e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.706e-001, 3.694e-002 center
replot  2.706e-001+ 2.000*( 9.994e-001* 3.427e-002*cos(t)+-3.575e-002* 5.268e-003*sin(t)),  3.694e-002 +2.000*( 3.575e-002* 3.427e-002*cos(t)+ 9.994e-001* 5.268e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.298e-001, 5.452e-002 center
replot  2.298e-001+ 2.000*( 9.986e-001* 3.155e-002*cos(t)+-5.242e-002* 6.302e-003*sin(t)),  5.452e-002 +2.000*( 5.242e-002* 3.155e-002*cos(t)+ 9.986e-001* 6.302e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.925e-001, 8.008e-002 center
replot  1.925e-001+ 2.000*( 9.965e-001* 3.362e-002*cos(t)+-8.315e-002* 9.363e-003*sin(t)),  8.008e-002 +2.000*( 8.315e-002* 3.362e-002*cos(t)+ 9.965e-001* 9.363e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.581e-001, 1.168e-001 center
replot  1.581e-001+ 2.000*( 9.872e-001* 3.619e-002*cos(t)+-1.596e-001* 1.674e-002*sin(t)),  1.168e-001 +2.000*( 1.596e-001* 3.619e-002*cos(t)+ 9.872e-001* 1.674e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.262e-001, 1.687e-001 center
replot  1.262e-001+ 2.000*( 8.539e-001* 3.857e-002*cos(t)+-5.204e-001* 2.932e-002*sin(t)),  1.687e-001 +2.000*( 5.204e-001* 3.857e-002*cos(t)+ 8.539e-001* 2.932e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  9.681e-002, 2.403e-001 center
replot  9.681e-002+ 2.000*( 1.995e-001* 5.666e-002*cos(t)+-9.799e-001* 3.313e-002*sin(t)),  2.403e-001 +2.000*( 9.799e-001* 5.666e-002*cos(t)+ 1.995e-001* 3.313e-002*sin(t)) not
set out;
set out "FRMgali/VARPIJGR_FRMgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "FRMgali/VARPIJGR_FRMgali_123-12.svg"
set label "50" at  9.592e-003, 1.131e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  9.592e-003+ 2.000*( 9.977e-001* 5.886e-003*cos(t)+-6.846e-002* 3.400e-003*sin(t)),  1.131e-002 +2.000*( 6.846e-002* 5.886e-003*cos(t)+ 9.977e-001* 3.400e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.646e-002, 1.681e-002 center
replot  1.646e-002+ 2.000*( 9.988e-001* 8.511e-003*cos(t)+-4.836e-002* 4.096e-003*sin(t)),  1.681e-002 +2.000*( 4.836e-002* 8.511e-003*cos(t)+ 9.988e-001* 4.096e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  2.806e-002, 2.495e-002 center
replot  2.806e-002+ 2.000*( 9.994e-001* 1.186e-002*cos(t)+-3.485e-002* 4.755e-003*sin(t)),  2.495e-002 +2.000*( 3.485e-002* 1.186e-002*cos(t)+ 9.994e-001* 4.755e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  4.746e-002, 3.694e-002 center
replot  4.746e-002+ 2.000*( 9.997e-001* 1.574e-002*cos(t)+-2.553e-002* 5.392e-003*sin(t)),  3.694e-002 +2.000*( 2.553e-002* 1.574e-002*cos(t)+ 9.997e-001* 5.392e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  7.947e-002, 5.452e-002 center
replot  7.947e-002+ 2.000*( 9.997e-001* 1.975e-002*cos(t)+-2.246e-002* 6.494e-003*sin(t)),  5.452e-002 +2.000*( 2.246e-002* 1.975e-002*cos(t)+ 9.997e-001* 6.494e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.313e-001, 8.008e-002 center
replot  1.313e-001+ 2.000*( 9.992e-001* 2.398e-002*cos(t)+-3.919e-002* 9.703e-003*sin(t)),  8.008e-002 +2.000*( 3.919e-002* 2.398e-002*cos(t)+ 9.992e-001* 9.703e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  2.125e-001, 1.168e-001 center
replot  2.125e-001+ 2.000*( 9.948e-001* 3.253e-002*cos(t)+-1.016e-001* 1.728e-002*sin(t)),  1.168e-001 +2.000*( 1.016e-001* 3.253e-002*cos(t)+ 9.948e-001* 1.728e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  3.345e-001, 1.687e-001 center
replot  3.345e-001+ 2.000*( 9.895e-001* 5.598e-002*cos(t)+-1.446e-001* 3.138e-002*sin(t)),  1.687e-001 +2.000*( 1.446e-001* 5.598e-002*cos(t)+ 9.895e-001* 3.138e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  5.058e-001, 2.403e-001 center
replot  5.058e-001+ 2.000*( 9.899e-001* 1.009e-001*cos(t)+-1.418e-001* 5.460e-002*sin(t)),  2.403e-001 +2.000*( 1.418e-001* 1.009e-001*cos(t)+ 9.899e-001* 5.460e-002*sin(t)) not
set out;
set out "FRMgali/VARPIJGR_FRMgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "FRMgali/VARPIJGR_FRMgali_121-13.svg"
set label "50" at  4.191e-001, 2.098e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  4.191e-001+ 2.000*( 1.000e+000* 9.253e-002*cos(t)+ 3.121e-004* 1.553e-003*sin(t)),  2.098e-003 +2.000*(-3.121e-004* 9.253e-002*cos(t)+ 1.000e+000* 1.553e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.648e-001, 3.015e-003 center
replot  3.648e-001+ 2.000*( 1.000e+000* 6.562e-002*cos(t)+ 3.959e-004* 1.748e-003*sin(t)),  3.015e-003 +2.000*(-3.959e-004* 6.562e-002*cos(t)+ 1.000e+000* 1.748e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.154e-001, 4.327e-003 center
replot  3.154e-001+ 2.000*( 1.000e+000* 4.566e-002*cos(t)+ 2.863e-004* 1.881e-003*sin(t)),  4.327e-003 +2.000*(-2.863e-004* 4.566e-002*cos(t)+ 1.000e+000* 1.881e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.706e-001, 6.196e-003 center
replot  2.706e-001+ 2.000*( 1.000e+000* 3.425e-002*cos(t)+-3.561e-004* 2.019e-003*sin(t)),  6.196e-003 +2.000*( 3.561e-004* 3.425e-002*cos(t)+ 1.000e+000* 2.019e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.298e-001, 8.842e-003 center
replot  2.298e-001+ 2.000*( 1.000e+000* 3.151e-002*cos(t)+-1.104e-003* 2.621e-003*sin(t)),  8.842e-003 +2.000*( 1.104e-003* 3.151e-002*cos(t)+ 1.000e+000* 2.621e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.925e-001, 1.256e-002 center
replot  1.925e-001+ 2.000*( 1.000e+000* 3.352e-002*cos(t)+-1.435e-003* 4.595e-003*sin(t)),  1.256e-002 +2.000*( 1.435e-003* 3.352e-002*cos(t)+ 1.000e+000* 4.595e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.581e-001, 1.771e-002 center
replot  1.581e-001+ 2.000*( 1.000e+000* 3.583e-002*cos(t)+-2.923e-003* 8.749e-003*sin(t)),  1.771e-002 +2.000*( 2.923e-003* 3.583e-002*cos(t)+ 1.000e+000* 8.749e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.262e-001, 2.473e-002 center
replot  1.262e-001+ 2.000*( 9.999e-001* 3.630e-002*cos(t)+-1.113e-002* 1.599e-002*sin(t)),  2.473e-002 +2.000*( 1.113e-002* 3.630e-002*cos(t)+ 9.999e-001* 1.599e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  9.681e-002, 3.406e-002 center
replot  9.681e-002+ 2.000*( 9.965e-001* 3.441e-002*cos(t)+-8.359e-002* 2.753e-002*sin(t)),  3.406e-002 +2.000*( 8.359e-002* 3.441e-002*cos(t)+ 9.965e-001* 2.753e-002*sin(t)) not
set out;
set out "FRMgali/VARPIJGR_FRMgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "FRMgali/VARPIJGR_FRMgali_123-13.svg"
set label "50" at  9.592e-003, 2.098e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  9.592e-003+ 2.000*( 9.986e-001* 5.884e-003*cos(t)+ 5.361e-002* 1.523e-003*sin(t)),  2.098e-003 +2.000*(-5.361e-002* 5.884e-003*cos(t)+ 9.986e-001* 1.523e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.646e-002, 3.015e-003 center
replot  1.646e-002+ 2.000*( 9.992e-001* 8.509e-003*cos(t)+ 3.981e-002* 1.717e-003*sin(t)),  3.015e-003 +2.000*(-3.981e-002* 8.509e-003*cos(t)+ 9.992e-001* 1.717e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  2.806e-002, 4.327e-003 center
replot  2.806e-002+ 2.000*( 9.996e-001* 1.186e-002*cos(t)+ 2.951e-002* 1.849e-003*sin(t)),  4.327e-003 +2.000*(-2.951e-002* 1.186e-002*cos(t)+ 9.996e-001* 1.849e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  4.746e-002, 6.196e-003 center
replot  4.746e-002+ 2.000*( 9.997e-001* 1.574e-002*cos(t)+ 2.283e-002* 1.987e-003*sin(t)),  6.196e-003 +2.000*(-2.283e-002* 1.574e-002*cos(t)+ 9.997e-001* 1.987e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  7.947e-002, 8.842e-003 center
replot  7.947e-002+ 2.000*( 9.997e-001* 1.975e-002*cos(t)+ 2.284e-002* 2.583e-003*sin(t)),  8.842e-003 +2.000*(-2.284e-002* 1.975e-002*cos(t)+ 9.997e-001* 2.583e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.313e-001, 1.256e-002 center
replot  1.313e-001+ 2.000*( 9.992e-001* 2.398e-002*cos(t)+ 4.049e-002* 4.495e-003*sin(t)),  1.256e-002 +2.000*(-4.049e-002* 2.398e-002*cos(t)+ 9.992e-001* 4.495e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  2.125e-001, 1.771e-002 center
replot  2.125e-001+ 2.000*( 9.966e-001* 3.251e-002*cos(t)+ 8.285e-002* 8.353e-003*sin(t)),  1.771e-002 +2.000*(-8.285e-002* 3.251e-002*cos(t)+ 9.966e-001* 8.353e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  3.345e-001, 2.473e-002 center
replot  3.345e-001+ 2.000*( 9.949e-001* 5.584e-002*cos(t)+ 1.006e-001* 1.505e-002*sin(t)),  2.473e-002 +2.000*(-1.006e-001* 5.584e-002*cos(t)+ 9.949e-001* 1.505e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  5.058e-001, 3.406e-002 center
replot  5.058e-001+ 2.000*( 9.957e-001* 1.006e-001*cos(t)+ 9.304e-002* 2.606e-002*sin(t)),  3.406e-002 +2.000*(-9.304e-002* 1.006e-001*cos(t)+ 9.957e-001* 2.606e-002*sin(t)) not
set out;
set out "FRMgali/VARPIJGR_FRMgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "FRMgali/VARPIJGR_FRMgali_123-21.svg"
set label "50" at  9.592e-003, 4.191e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  9.592e-003+ 2.000*( 2.027e-003* 9.253e-002*cos(t)+ 1.000e+000* 5.873e-003*sin(t)),  4.191e-001 +2.000*(-1.000e+000* 9.253e-002*cos(t)+ 2.027e-003* 5.873e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.646e-002, 3.648e-001 center
replot  1.646e-002+ 2.000*( 3.525e-003* 6.562e-002*cos(t)+ 1.000e+000* 8.500e-003*sin(t)),  3.648e-001 +2.000*(-1.000e+000* 6.562e-002*cos(t)+ 3.525e-003* 8.500e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  2.806e-002, 3.154e-001 center
replot  2.806e-002+ 2.000*( 9.525e-003* 4.566e-002*cos(t)+ 1.000e+000* 1.184e-002*sin(t)),  3.154e-001 +2.000*(-1.000e+000* 4.566e-002*cos(t)+ 9.525e-003* 1.184e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  4.746e-002, 2.706e-001 center
replot  4.746e-002+ 2.000*( 3.273e-002* 3.426e-002*cos(t)+ 9.995e-001* 1.571e-002*sin(t)),  2.706e-001 +2.000*(-9.995e-001* 3.426e-002*cos(t)+ 3.273e-002* 1.571e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  7.947e-002, 2.298e-001 center
replot  7.947e-002+ 2.000*( 7.873e-002* 3.157e-002*cos(t)+ 9.969e-001* 1.965e-002*sin(t)),  2.298e-001 +2.000*(-9.969e-001* 3.157e-002*cos(t)+ 7.873e-002* 1.965e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.313e-001, 1.925e-001 center
replot  1.313e-001+ 2.000*( 1.139e-001* 3.363e-002*cos(t)+ 9.935e-001* 2.381e-002*sin(t)),  1.925e-001 +2.000*(-9.935e-001* 3.363e-002*cos(t)+ 1.139e-001* 2.381e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  2.125e-001, 1.581e-001 center
replot  2.125e-001+ 2.000*( 3.007e-001* 3.619e-002*cos(t)+ 9.537e-001* 3.201e-002*sin(t)),  1.581e-001 +2.000*(-9.537e-001* 3.619e-002*cos(t)+ 3.007e-001* 3.201e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  3.345e-001, 1.262e-001 center
replot  3.345e-001+ 2.000*( 9.958e-001* 5.571e-002*cos(t)+ 9.157e-002* 3.609e-002*sin(t)),  1.262e-001 +2.000*(-9.157e-002* 5.571e-002*cos(t)+ 9.958e-001* 3.609e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  5.058e-001, 9.681e-002 center
replot  5.058e-001+ 2.000*( 9.986e-001* 1.003e-001*cos(t)+ 5.300e-002* 3.401e-002*sin(t)),  9.681e-002 +2.000*(-5.300e-002* 1.003e-001*cos(t)+ 9.986e-001* 3.401e-002*sin(t)) not
set out;
set out "FRMgali/VARPIJGR_FRMgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "FRMgali/VARMUPTJGR--STABLBASED_FRMgali1.svg";
 plot "FRMgali/PRMORPREV-1-STABLBASED_FRMgali.txt"  u 1:($3) not w l lt 1 
 replot "FRMgali/PRMORPREV-1-STABLBASED_FRMgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "FRMgali/PRMORPREV-1-STABLBASED_FRMgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "FRMgali/VARMUPTJGR--STABLBASED_FRMgali1.svg";replot;set out;
