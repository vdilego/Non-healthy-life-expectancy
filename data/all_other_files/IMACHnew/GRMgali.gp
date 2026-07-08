
# IMaCh-0.99r45
# GRMgali.gp
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


set ter svg size 640, 480;set out "GRMgali/D_GRMgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "GRMgali/ILK_GRMgali-dest.png";
set log y;plot  "GRMgali/ILK_GRMgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "GRMgali/ILK_GRMgali-ori.png";
set log y;plot  "GRMgali/ILK_GRMgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "GRMgali/ILK_GRMgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "GRMgali/ILK_GRMgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "GRMgali/ILK_GRMgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "GRMgali/ILK_GRMgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "GRMgali/V_GRMgali_1-1-1.svg" 

#set out "V_GRMgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "GRMgali/VPL_GRMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"GRMgali/VPL_GRMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"GRMgali/VPL_GRMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"GRMgali/P_GRMgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "GRMgali/V_GRMgali_2-1-1.svg" 

#set out "V_GRMgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "GRMgali/VPL_GRMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"GRMgali/VPL_GRMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"GRMgali/VPL_GRMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"GRMgali/P_GRMgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "GRMgali/E_GRMgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "GRMgali/T_GRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"GRMgali/T_GRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"GRMgali/T_GRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"GRMgali/T_GRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"GRMgali/T_GRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"GRMgali/T_GRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"GRMgali/T_GRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"GRMgali/T_GRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"GRMgali/T_GRMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "GRMgali/E_GRMgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "GRMgali/EXP_GRMgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "GRMgali/E_GRMgali.txt" every :::0::0 u 1:2 t "e11" w l ,"GRMgali/E_GRMgali.txt" every :::0::0 u 1:3 t "e12" w l ,"GRMgali/E_GRMgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "GRMgali/EXP_GRMgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "GRMgali/E_GRMgali.txt" every :::0::0 u 1:5 t "e21" w l ,"GRMgali/E_GRMgali.txt" every :::0::0 u 1:6 t "e22" w l ,"GRMgali/E_GRMgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "GRMgali/LIJ_GRMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMgali/PIJ_GRMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "GRMgali/LIJ_GRMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMgali/PIJ_GRMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "GRMgali/LIJT_GRMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMgali/PIJ_GRMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "GRMgali/LIJT_GRMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMgali/PIJ_GRMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "GRMgali/P_GRMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMgali/PIJ_GRMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "GRMgali/P_GRMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMgali/PIJ_GRMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-10.653986; p2=0.081654; 
#   current state 3
p3=-13.676819; p4=0.128921; 
# initial state 2
#   current state 1
p5=0.482059; p6=-0.034336; 
#   current state 3
p7=-5.449046; p8=0.044041; 
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

set out "GRMgali/PE_GRMgali_1-1-1.svg" 
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

set out "GRMgali/PE_GRMgali_1-2-1.svg" 
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

set out "GRMgali/PE_GRMgali_1-3-1.svg" 
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
set out "GRMgali/VARPIJGR_GRMgali_113-12.svg"
set label "50" at  1.445e-003, 2.794e-003 center
# Age 50, p13 - p12
plot [-pi:pi]  1.445e-003+ 2.000*( 5.323e-002* 1.691e-003*cos(t)+ 9.986e-001* 6.814e-004*sin(t)),  2.794e-003 +2.000*(-9.986e-001* 1.691e-003*cos(t)+ 5.323e-002* 6.814e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  2.749e-003, 4.197e-003 center
replot  2.749e-003+ 2.000*( 7.780e-002* 2.108e-003*cos(t)+ 9.970e-001* 1.091e-003*sin(t)),  4.197e-003 +2.000*(-9.970e-001* 2.108e-003*cos(t)+ 7.780e-002* 1.091e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  5.226e-003, 6.299e-003 center
replot  5.226e-003+ 2.000*( 1.306e-001* 2.542e-003*cos(t)+ 9.914e-001* 1.690e-003*sin(t)),  6.299e-003 +2.000*(-9.914e-001* 2.542e-003*cos(t)+ 1.306e-001* 1.690e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  9.917e-003, 9.437e-003 center
replot  9.917e-003+ 2.000*( 3.187e-001* 2.965e-003*cos(t)+ 9.479e-001* 2.485e-003*sin(t)),  9.437e-003 +2.000*(-9.479e-001* 2.965e-003*cos(t)+ 3.187e-001* 2.485e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.877e-002, 1.410e-002 center
replot  1.877e-002+ 2.000*( 8.996e-001* 3.657e-003*cos(t)+ 4.368e-001* 3.197e-003*sin(t)),  1.410e-002 +2.000*(-4.368e-001* 3.657e-003*cos(t)+ 8.996e-001* 3.197e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  3.533e-002, 2.096e-002 center
replot  3.533e-002+ 2.000*( 9.652e-001* 4.946e-003*cos(t)+ 2.617e-001* 3.969e-003*sin(t)),  2.096e-002 +2.000*(-2.617e-001* 4.946e-003*cos(t)+ 9.652e-001* 3.969e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  6.590e-002, 3.086e-002 center
replot  6.590e-002+ 2.000*( 9.435e-001* 7.913e-003*cos(t)+ 3.314e-001* 6.255e-003*sin(t)),  3.086e-002 +2.000*(-3.314e-001* 7.913e-003*cos(t)+ 9.435e-001* 6.255e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  1.210e-001, 4.474e-002 center
replot  1.210e-001+ 2.000*( 9.651e-001* 1.716e-002*cos(t)+ 2.620e-001* 1.168e-002*sin(t)),  4.474e-002 +2.000*(-2.620e-001* 1.716e-002*cos(t)+ 9.651e-001* 1.168e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  2.163e-001, 6.313e-002 center
replot  2.163e-001+ 2.000*( 9.806e-001* 3.984e-002*cos(t)+ 1.961e-001* 2.142e-002*sin(t)),  6.313e-002 +2.000*(-1.961e-001* 3.984e-002*cos(t)+ 9.806e-001* 2.142e-002*sin(t)) not
set out;
set out "GRMgali/VARPIJGR_GRMgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "GRMgali/VARPIJGR_GRMgali_121-12.svg"
set label "50" at  4.375e-001, 2.794e-003 center
# Age 50, p21 - p12
plot [-pi:pi]  4.375e-001+ 2.000*( 1.000e+000* 1.525e-001*cos(t)+-1.345e-003* 1.676e-003*sin(t)),  2.794e-003 +2.000*( 1.345e-003* 1.525e-001*cos(t)+ 1.000e+000* 1.676e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.789e-001, 4.197e-003 center
replot  3.789e-001+ 2.000*( 1.000e+000* 1.116e-001*cos(t)+-2.306e-003* 2.088e-003*sin(t)),  4.197e-003 +2.000*( 2.306e-003* 1.116e-001*cos(t)+ 1.000e+000* 2.088e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.258e-001, 6.299e-003 center
replot  3.258e-001+ 2.000*( 1.000e+000* 7.909e-002*cos(t)+-3.992e-003* 2.510e-003*sin(t)),  6.299e-003 +2.000*( 3.992e-003* 7.909e-002*cos(t)+ 1.000e+000* 2.510e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.783e-001, 9.437e-003 center
replot  2.783e-001+ 2.000*( 1.000e+000* 5.618e-002*cos(t)+-6.752e-003* 2.895e-003*sin(t)),  9.437e-003 +2.000*( 6.752e-003* 5.618e-002*cos(t)+ 1.000e+000* 2.895e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.361e-001, 1.410e-002 center
replot  2.361e-001+ 2.000*( 9.999e-001* 4.407e-002*cos(t)+-1.039e-002* 3.258e-003*sin(t)),  1.410e-002 +2.000*( 1.039e-002* 4.407e-002*cos(t)+ 9.999e-001* 3.258e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.988e-001, 2.096e-002 center
replot  1.988e-001+ 2.000*( 9.999e-001* 4.141e-002*cos(t)+-1.472e-002* 3.997e-003*sin(t)),  2.096e-002 +2.000*( 1.472e-002* 4.141e-002*cos(t)+ 9.999e-001* 3.997e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.662e-001, 3.086e-002 center
replot  1.662e-001+ 2.000*( 9.998e-001* 4.342e-002*cos(t)+-2.200e-002* 6.388e-003*sin(t)),  3.086e-002 +2.000*( 2.200e-002* 4.342e-002*cos(t)+ 9.998e-001* 6.388e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.378e-001, 4.474e-002 center
replot  1.378e-001+ 2.000*( 9.994e-001* 4.593e-002*cos(t)+-3.594e-002* 1.203e-002*sin(t)),  4.474e-002 +2.000*( 3.594e-002* 4.593e-002*cos(t)+ 9.994e-001* 1.203e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.133e-001, 6.313e-002 center
replot  1.133e-001+ 2.000*( 9.978e-001* 4.721e-002*cos(t)+-6.612e-002* 2.224e-002*sin(t)),  6.313e-002 +2.000*( 6.612e-002* 4.721e-002*cos(t)+ 9.978e-001* 2.224e-002*sin(t)) not
set out;
set out "GRMgali/VARPIJGR_GRMgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "GRMgali/VARPIJGR_GRMgali_123-12.svg"
set label "50" at  5.849e-002, 2.794e-003 center
# Age 50, p23 - p12
plot [-pi:pi]  5.849e-002+ 2.000*( 1.000e+000* 3.627e-002*cos(t)+-5.285e-003* 1.678e-003*sin(t)),  2.794e-003 +2.000*( 5.285e-003* 3.627e-002*cos(t)+ 1.000e+000* 1.678e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  7.494e-002, 4.197e-003 center
replot  7.494e-002+ 2.000*( 1.000e+000* 3.899e-002*cos(t)+-6.049e-003* 2.090e-003*sin(t)),  4.197e-003 +2.000*( 6.049e-003* 3.899e-002*cos(t)+ 1.000e+000* 2.090e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  9.538e-002, 6.299e-003 center
replot  9.538e-002+ 2.000*( 1.000e+000* 4.052e-002*cos(t)+-6.818e-003* 2.515e-003*sin(t)),  6.299e-003 +2.000*( 6.818e-003* 4.052e-002*cos(t)+ 1.000e+000* 2.515e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.206e-001, 9.437e-003 center
replot  1.206e-001+ 2.000*( 1.000e+000* 4.050e-002*cos(t)+-7.596e-003* 2.904e-003*sin(t)),  9.437e-003 +2.000*( 7.596e-003* 4.050e-002*cos(t)+ 1.000e+000* 2.904e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  1.513e-001, 1.410e-002 center
replot  1.513e-001+ 2.000*( 1.000e+000* 3.911e-002*cos(t)+-8.871e-003* 3.271e-003*sin(t)),  1.410e-002 +2.000*( 8.871e-003* 3.911e-002*cos(t)+ 1.000e+000* 3.271e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.886e-001, 2.096e-002 center
replot  1.886e-001+ 2.000*( 9.999e-001* 3.819e-002*cos(t)+-1.337e-002* 4.011e-003*sin(t)),  2.096e-002 +2.000*( 1.337e-002* 3.819e-002*cos(t)+ 9.999e-001* 4.011e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  2.333e-001, 3.086e-002 center
replot  2.333e-001+ 2.000*( 9.997e-001* 4.277e-002*cos(t)+-2.635e-002* 6.361e-003*sin(t)),  3.086e-002 +2.000*( 2.635e-002* 4.277e-002*cos(t)+ 9.997e-001* 6.361e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  2.863e-001, 4.474e-002 center
replot  2.863e-001+ 2.000*( 9.991e-001* 5.883e-002*cos(t)+-4.329e-002* 1.187e-002*sin(t)),  4.474e-002 +2.000*( 4.329e-002* 5.883e-002*cos(t)+ 9.991e-001* 1.187e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  3.483e-001, 6.313e-002 center
replot  3.483e-001+ 2.000*( 9.984e-001* 8.789e-002*cos(t)+-5.710e-002* 2.187e-002*sin(t)),  6.313e-002 +2.000*( 5.710e-002* 8.789e-002*cos(t)+ 9.984e-001* 2.187e-002*sin(t)) not
set out;
set out "GRMgali/VARPIJGR_GRMgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "GRMgali/VARPIJGR_GRMgali_121-13.svg"
set label "50" at  4.375e-001, 1.445e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  4.375e-001+ 2.000*( 1.000e+000* 1.525e-001*cos(t)+-1.606e-004* 6.860e-004*sin(t)),  1.445e-003 +2.000*( 1.606e-004* 1.525e-001*cos(t)+ 1.000e+000* 6.860e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.789e-001, 2.749e-003 center
replot  3.789e-001+ 2.000*( 1.000e+000* 1.116e-001*cos(t)+-3.234e-004* 1.100e-003*sin(t)),  2.749e-003 +2.000*( 3.234e-004* 1.116e-001*cos(t)+ 1.000e+000* 1.100e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.258e-001, 5.226e-003 center
replot  3.258e-001+ 2.000*( 1.000e+000* 7.909e-002*cos(t)+-6.141e-004* 1.707e-003*sin(t)),  5.226e-003 +2.000*( 6.141e-004* 7.909e-002*cos(t)+ 1.000e+000* 1.707e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.783e-001, 9.917e-003 center
replot  2.783e-001+ 2.000*( 1.000e+000* 5.618e-002*cos(t)+-1.018e-003* 2.537e-003*sin(t)),  9.917e-003 +2.000*( 1.018e-003* 5.618e-002*cos(t)+ 1.000e+000* 2.537e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.361e-001, 1.877e-002 center
replot  2.361e-001+ 2.000*( 1.000e+000* 4.406e-002*cos(t)+-1.572e-003* 3.573e-003*sin(t)),  1.877e-002 +2.000*( 1.572e-003* 4.406e-002*cos(t)+ 1.000e+000* 3.573e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.988e-001, 3.533e-002 center
replot  1.988e-001+ 2.000*( 1.000e+000* 4.141e-002*cos(t)+-3.843e-003* 4.883e-003*sin(t)),  3.533e-002 +2.000*( 3.843e-003* 4.141e-002*cos(t)+ 1.000e+000* 4.883e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.662e-001, 6.590e-002 center
replot  1.662e-001+ 2.000*( 9.999e-001* 4.341e-002*cos(t)+-1.187e-002* 7.732e-003*sin(t)),  6.590e-002 +2.000*( 1.187e-002* 4.341e-002*cos(t)+ 9.999e-001* 7.732e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.378e-001, 1.210e-001 center
replot  1.378e-001+ 2.000*( 9.994e-001* 4.593e-002*cos(t)+-3.553e-002* 1.677e-002*sin(t)),  1.210e-001 +2.000*( 3.553e-002* 4.593e-002*cos(t)+ 9.994e-001* 1.677e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.133e-001, 2.163e-001 center
replot  1.133e-001+ 2.000*( 9.753e-001* 4.752e-002*cos(t)+-2.209e-001* 3.882e-002*sin(t)),  2.163e-001 +2.000*( 2.209e-001* 4.752e-002*cos(t)+ 9.753e-001* 3.882e-002*sin(t)) not
set out;
set out "GRMgali/VARPIJGR_GRMgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "GRMgali/VARPIJGR_GRMgali_123-13.svg"
set label "50" at  5.849e-002, 1.445e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  5.849e-002+ 2.000*( 1.000e+000* 3.627e-002*cos(t)+ 2.678e-003* 6.795e-004*sin(t)),  1.445e-003 +2.000*(-2.678e-003* 3.627e-002*cos(t)+ 1.000e+000* 6.795e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  7.494e-002, 2.749e-003 center
replot  7.494e-002+ 2.000*( 1.000e+000* 3.899e-002*cos(t)+ 3.898e-003* 1.090e-003*sin(t)),  2.749e-003 +2.000*(-3.898e-003* 3.899e-002*cos(t)+ 1.000e+000* 1.090e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  9.538e-002, 5.226e-003 center
replot  9.538e-002+ 2.000*( 1.000e+000* 4.052e-002*cos(t)+ 5.647e-003* 1.693e-003*sin(t)),  5.226e-003 +2.000*(-5.647e-003* 4.052e-002*cos(t)+ 1.000e+000* 1.693e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.206e-001, 9.917e-003 center
replot  1.206e-001+ 2.000*( 1.000e+000* 4.050e-002*cos(t)+ 8.091e-003* 2.517e-003*sin(t)),  9.917e-003 +2.000*(-8.091e-003* 4.050e-002*cos(t)+ 1.000e+000* 2.517e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  1.513e-001, 1.877e-002 center
replot  1.513e-001+ 2.000*( 9.999e-001* 3.911e-002*cos(t)+ 1.144e-002* 3.546e-003*sin(t)),  1.877e-002 +2.000*(-1.144e-002* 3.911e-002*cos(t)+ 9.999e-001* 3.546e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.886e-001, 3.533e-002 center
replot  1.886e-001+ 2.000*( 9.999e-001* 3.819e-002*cos(t)+ 1.681e-002* 4.844e-003*sin(t)),  3.533e-002 +2.000*(-1.681e-002* 3.819e-002*cos(t)+ 9.999e-001* 4.844e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  2.333e-001, 6.590e-002 center
replot  2.333e-001+ 2.000*( 9.996e-001* 4.278e-002*cos(t)+ 2.969e-002* 7.647e-003*sin(t)),  6.590e-002 +2.000*(-2.969e-002* 4.278e-002*cos(t)+ 9.996e-001* 7.647e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  2.863e-001, 1.210e-001 center
replot  2.863e-001+ 2.000*( 9.984e-001* 5.887e-002*cos(t)+ 5.711e-002* 1.653e-002*sin(t)),  1.210e-001 +2.000*(-5.711e-002* 5.887e-002*cos(t)+ 9.984e-001* 1.653e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  3.483e-001, 2.163e-001 center
replot  3.483e-001+ 2.000*( 9.945e-001* 8.815e-002*cos(t)+ 1.044e-001* 3.841e-002*sin(t)),  2.163e-001 +2.000*(-1.044e-001* 8.815e-002*cos(t)+ 9.945e-001* 3.841e-002*sin(t)) not
set out;
set out "GRMgali/VARPIJGR_GRMgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "GRMgali/VARPIJGR_GRMgali_123-21.svg"
set label "50" at  5.849e-002, 4.375e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  5.849e-002+ 2.000*( 3.222e-002* 1.526e-001*cos(t)+ 9.995e-001* 3.595e-002*sin(t)),  4.375e-001 +2.000*(-9.995e-001* 1.526e-001*cos(t)+ 3.222e-002* 3.595e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  7.494e-002, 3.789e-001 center
replot  7.494e-002+ 2.000*( 4.446e-002* 1.117e-001*cos(t)+ 9.990e-001* 3.871e-002*sin(t)),  3.789e-001 +2.000*(-9.990e-001* 1.117e-001*cos(t)+ 4.446e-002* 3.871e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  9.538e-002, 3.258e-001 center
replot  9.538e-002+ 2.000*( 7.078e-002* 7.923e-002*cos(t)+ 9.975e-001* 4.023e-002*sin(t)),  3.258e-001 +2.000*(-9.975e-001* 7.923e-002*cos(t)+ 7.078e-002* 4.023e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.206e-001, 2.783e-001 center
replot  1.206e-001+ 2.000*( 1.488e-001* 5.649e-002*cos(t)+ 9.889e-001* 4.006e-002*sin(t)),  2.783e-001 +2.000*(-9.889e-001* 5.649e-002*cos(t)+ 1.488e-001* 4.006e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  1.513e-001, 2.361e-001 center
replot  1.513e-001+ 2.000*( 3.734e-001* 4.496e-002*cos(t)+ 9.277e-001* 3.808e-002*sin(t)),  2.361e-001 +2.000*(-9.277e-001* 4.496e-002*cos(t)+ 3.734e-001* 3.808e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.886e-001, 1.988e-001 center
replot  1.886e-001+ 2.000*( 4.993e-001* 4.292e-002*cos(t)+ 8.664e-001* 3.647e-002*sin(t)),  1.988e-001 +2.000*(-8.664e-001* 4.292e-002*cos(t)+ 4.993e-001* 3.647e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  2.333e-001, 1.662e-001 center
replot  2.333e-001+ 2.000*( 6.749e-001* 4.658e-002*cos(t)+ 7.379e-001* 3.928e-002*sin(t)),  1.662e-001 +2.000*(-7.379e-001* 4.658e-002*cos(t)+ 6.749e-001* 3.928e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  2.863e-001, 1.378e-001 center
replot  2.863e-001+ 2.000*( 9.511e-001* 6.011e-002*cos(t)+ 3.088e-001* 4.414e-002*sin(t)),  1.378e-001 +2.000*(-3.088e-001* 6.011e-002*cos(t)+ 9.511e-001* 4.414e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  3.483e-001, 1.133e-001 center
replot  3.483e-001+ 2.000*( 9.904e-001* 8.838e-002*cos(t)+ 1.385e-001* 4.595e-002*sin(t)),  1.133e-001 +2.000*(-1.385e-001* 8.838e-002*cos(t)+ 9.904e-001* 4.595e-002*sin(t)) not
set out;
set out "GRMgali/VARPIJGR_GRMgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "GRMgali/VARMUPTJGR--STABLBASED_GRMgali1.svg";
 plot "GRMgali/PRMORPREV-1-STABLBASED_GRMgali.txt"  u 1:($3) not w l lt 1 
 replot "GRMgali/PRMORPREV-1-STABLBASED_GRMgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "GRMgali/PRMORPREV-1-STABLBASED_GRMgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "GRMgali/VARMUPTJGR--STABLBASED_GRMgali1.svg";replot;set out;
