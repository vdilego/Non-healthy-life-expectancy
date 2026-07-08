
# IMaCh-0.99r45
# CZMsr.gp
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


set ter svg size 640, 480;set out "CZMsr/D_CZMsr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "CZMsr/ILK_CZMsr-dest.png";
set log y;plot  "CZMsr/ILK_CZMsr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "CZMsr/ILK_CZMsr-ori.png";
set log y;plot  "CZMsr/ILK_CZMsr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "CZMsr/ILK_CZMsr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "CZMsr/ILK_CZMsr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "CZMsr/ILK_CZMsr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "CZMsr/ILK_CZMsr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "CZMsr/V_CZMsr_1-1-1.svg" 

#set out "V_CZMsr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "CZMsr/VPL_CZMsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"CZMsr/VPL_CZMsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"CZMsr/VPL_CZMsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"CZMsr/P_CZMsr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "CZMsr/V_CZMsr_2-1-1.svg" 

#set out "V_CZMsr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "CZMsr/VPL_CZMsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"CZMsr/VPL_CZMsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"CZMsr/VPL_CZMsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"CZMsr/P_CZMsr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "CZMsr/E_CZMsr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "CZMsr/T_CZMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"CZMsr/T_CZMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"CZMsr/T_CZMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"CZMsr/T_CZMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"CZMsr/T_CZMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"CZMsr/T_CZMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"CZMsr/T_CZMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"CZMsr/T_CZMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"CZMsr/T_CZMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "CZMsr/E_CZMsr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "CZMsr/EXP_CZMsr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "CZMsr/E_CZMsr.txt" every :::0::0 u 1:2 t "e11" w l ,"CZMsr/E_CZMsr.txt" every :::0::0 u 1:3 t "e12" w l ,"CZMsr/E_CZMsr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "CZMsr/EXP_CZMsr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "CZMsr/E_CZMsr.txt" every :::0::0 u 1:5 t "e21" w l ,"CZMsr/E_CZMsr.txt" every :::0::0 u 1:6 t "e22" w l ,"CZMsr/E_CZMsr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "CZMsr/LIJ_CZMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMsr/PIJ_CZMsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "CZMsr/LIJ_CZMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMsr/PIJ_CZMsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "CZMsr/LIJT_CZMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMsr/PIJ_CZMsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "CZMsr/LIJT_CZMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMsr/PIJ_CZMsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "CZMsr/P_CZMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMsr/PIJ_CZMsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "CZMsr/P_CZMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMsr/PIJ_CZMsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-4.742440; p2=0.025518; 
#   current state 3
p3=-15.056161; p4=0.143285; 
# initial state 2
#   current state 1
p5=1.235134; p6=-0.041999; 
#   current state 3
p7=-6.377710; p8=0.045663; 
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

set out "CZMsr/PE_CZMsr_1-1-1.svg" 
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

set out "CZMsr/PE_CZMsr_1-2-1.svg" 
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

set out "CZMsr/PE_CZMsr_1-3-1.svg" 
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
set out "CZMsr/VARPIJGR_CZMsr_113-12.svg"
set label "50" at  7.246e-004, 6.054e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  7.246e-004+ 2.000*( 2.895e-003* 1.323e-002*cos(t)+ 1.000e+000* 6.528e-004*sin(t)),  6.054e-002 +2.000*(-1.000e+000* 1.323e-002*cos(t)+ 2.895e-003* 6.528e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.477e-003, 6.847e-002 center
replot  1.477e-003+ 2.000*( 7.133e-003* 1.161e-002*cos(t)+ 1.000e+000* 1.105e-003*sin(t)),  6.847e-002 +2.000*(-1.000e+000* 1.161e-002*cos(t)+ 7.133e-003* 1.105e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  3.007e-003, 7.737e-002 center
replot  3.007e-003+ 2.000*( 1.878e-002* 9.919e-003*cos(t)+ 9.998e-001* 1.806e-003*sin(t)),  7.737e-002 +2.000*(-9.998e-001* 9.919e-003*cos(t)+ 1.878e-002* 1.806e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  6.113e-003, 8.730e-002 center
replot  6.113e-003+ 2.000*( 4.611e-002* 9.013e-003*cos(t)+ 9.989e-001* 2.819e-003*sin(t)),  8.730e-002 +2.000*(-9.989e-001* 9.013e-003*cos(t)+ 4.611e-002* 2.819e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.240e-002, 9.828e-002 center
replot  1.240e-002+ 2.000*( 7.331e-002* 1.043e-002*cos(t)+ 9.973e-001* 4.255e-003*sin(t)),  9.828e-002 +2.000*(-9.973e-001* 1.043e-002*cos(t)+ 7.331e-002* 4.255e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.506e-002, 1.102e-001 center
replot  2.506e-002+ 2.000*( 8.470e-002* 1.480e-002*cos(t)+ 9.964e-001* 6.836e-003*sin(t)),  1.102e-001 +2.000*(-9.964e-001* 1.480e-002*cos(t)+ 8.470e-002* 6.836e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  5.026e-002, 1.227e-001 center
replot  5.026e-002+ 2.000*( 1.567e-001* 2.161e-002*cos(t)+ 9.876e-001* 1.414e-002*sin(t)),  1.227e-001 +2.000*(-9.876e-001* 2.161e-002*cos(t)+ 1.567e-001* 1.414e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  9.943e-002, 1.347e-001 center
replot  9.943e-002+ 2.000*( 9.403e-001* 3.686e-002*cos(t)+ 3.403e-001* 2.887e-002*sin(t)),  1.347e-001 +2.000*(-3.403e-001* 3.686e-002*cos(t)+ 9.403e-001* 2.887e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.918e-001, 1.442e-001 center
replot  1.918e-001+ 2.000*( 9.915e-001* 8.843e-002*cos(t)+ 1.304e-001* 3.820e-002*sin(t)),  1.442e-001 +2.000*(-1.304e-001* 8.843e-002*cos(t)+ 9.915e-001* 3.820e-002*sin(t)) not
set out;
set out "CZMsr/VARPIJGR_CZMsr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "CZMsr/VARPIJGR_CZMsr_121-12.svg"
set label "50" at  5.858e-001, 6.054e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  5.858e-001+ 2.000*( 9.974e-001* 6.553e-002*cos(t)+-7.262e-002* 1.238e-002*sin(t)),  6.054e-002 +2.000*( 7.262e-002* 6.553e-002*cos(t)+ 9.974e-001* 1.238e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  5.012e-001, 6.847e-002 center
replot  5.012e-001+ 2.000*( 9.955e-001* 4.577e-002*cos(t)+-9.518e-002* 1.081e-002*sin(t)),  6.847e-002 +2.000*( 9.518e-002* 4.577e-002*cos(t)+ 9.955e-001* 1.081e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  4.247e-001, 7.737e-002 center
replot  4.247e-001+ 2.000*( 9.918e-001* 3.065e-002*cos(t)+-1.276e-001* 9.188e-003*sin(t)),  7.737e-002 +2.000*( 1.276e-001* 3.065e-002*cos(t)+ 9.918e-001* 9.188e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.568e-001, 8.730e-002 center
replot  3.568e-001+ 2.000*( 9.867e-001* 2.210e-002*cos(t)+-1.627e-001* 8.366e-003*sin(t)),  8.730e-002 +2.000*( 1.627e-001* 2.210e-002*cos(t)+ 9.867e-001* 8.366e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.972e-001, 9.828e-002 center
replot  2.972e-001+ 2.000*( 9.812e-001* 2.085e-002*cos(t)+-1.930e-001* 9.780e-003*sin(t)),  9.828e-002 +2.000*( 1.930e-001* 2.085e-002*cos(t)+ 9.812e-001* 9.780e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.457e-001, 1.102e-001 center
replot  2.457e-001+ 2.000*( 9.630e-001* 2.358e-002*cos(t)+-2.694e-001* 1.383e-002*sin(t)),  1.102e-001 +2.000*( 2.694e-001* 2.358e-002*cos(t)+ 9.630e-001* 1.383e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.016e-001, 1.227e-001 center
replot  2.016e-001+ 2.000*( 8.814e-001* 2.717e-002*cos(t)+-4.724e-001* 1.952e-002*sin(t)),  1.227e-001 +2.000*( 4.724e-001* 2.717e-002*cos(t)+ 8.814e-001* 1.952e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.642e-001, 1.347e-001 center
replot  1.642e-001+ 2.000*( 5.727e-001* 3.226e-002*cos(t)+-8.198e-001* 2.436e-002*sin(t)),  1.347e-001 +2.000*( 8.198e-001* 3.226e-002*cos(t)+ 5.727e-001* 2.436e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.328e-001, 1.442e-001 center
replot  1.328e-001+ 2.000*( 2.749e-001* 4.049e-002*cos(t)+-9.615e-001* 2.615e-002*sin(t)),  1.442e-001 +2.000*( 9.615e-001* 4.049e-002*cos(t)+ 2.749e-001* 2.615e-002*sin(t)) not
set out;
set out "CZMsr/VARPIJGR_CZMsr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "CZMsr/VARPIJGR_CZMsr_123-12.svg"
set label "50" at  2.318e-002, 6.054e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  2.318e-002+ 2.000*( 1.374e-002* 1.323e-002*cos(t)+-9.999e-001* 7.728e-003*sin(t)),  6.054e-002 +2.000*( 9.999e-001* 1.323e-002*cos(t)+ 1.374e-002* 7.728e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  3.074e-002, 6.847e-002 center
replot  3.074e-002+ 2.000*( 4.457e-002* 1.162e-002*cos(t)+-9.990e-001* 8.315e-003*sin(t)),  6.847e-002 +2.000*( 9.990e-001* 1.162e-002*cos(t)+ 4.457e-002* 8.315e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  4.038e-002, 7.737e-002 center
replot  4.038e-002+ 2.000*( 1.683e-001* 9.954e-003*cos(t)+-9.857e-001* 8.562e-003*sin(t)),  7.737e-002 +2.000*( 9.857e-001* 9.954e-003*cos(t)+ 1.683e-001* 8.562e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  5.258e-002, 8.730e-002 center
replot  5.258e-002+ 2.000*( 5.108e-001* 9.194e-003*cos(t)+-8.597e-001* 8.444e-003*sin(t)),  8.730e-002 +2.000*( 8.597e-001* 9.194e-003*cos(t)+ 5.108e-001* 8.444e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  6.790e-002, 9.828e-002 center
replot  6.790e-002+ 2.000*( 2.815e-001* 1.052e-002*cos(t)+-9.596e-001* 8.919e-003*sin(t)),  9.828e-002 +2.000*( 9.596e-001* 1.052e-002*cos(t)+ 2.815e-001* 8.919e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  8.701e-002, 1.102e-001 center
replot  8.701e-002+ 2.000*( 1.599e-001* 1.484e-002*cos(t)+-9.871e-001* 1.131e-002*sin(t)),  1.102e-001 +2.000*( 9.871e-001* 1.484e-002*cos(t)+ 1.599e-001* 1.131e-002*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.107e-001, 1.227e-001 center
replot  1.107e-001+ 2.000*( 1.842e-001* 2.160e-002*cos(t)+-9.829e-001* 1.723e-002*sin(t)),  1.227e-001 +2.000*( 9.829e-001* 2.160e-002*cos(t)+ 1.842e-001* 1.723e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.397e-001, 1.347e-001 center
replot  1.397e-001+ 2.000*( 4.288e-001* 3.049e-002*cos(t)+-9.034e-001* 2.713e-002*sin(t)),  1.347e-001 +2.000*( 9.034e-001* 3.049e-002*cos(t)+ 4.288e-001* 2.713e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.752e-001, 1.442e-001 center
replot  1.752e-001+ 2.000*( 8.918e-001* 4.427e-002*cos(t)+-4.524e-001* 3.829e-002*sin(t)),  1.442e-001 +2.000*( 4.524e-001* 4.427e-002*cos(t)+ 8.918e-001* 3.829e-002*sin(t)) not
set out;
set out "CZMsr/VARPIJGR_CZMsr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "CZMsr/VARPIJGR_CZMsr_121-13.svg"
set label "50" at  5.858e-001, 7.246e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  5.858e-001+ 2.000*( 1.000e+000* 6.537e-002*cos(t)+-1.037e-003* 6.504e-004*sin(t)),  7.246e-004 +2.000*( 1.037e-003* 6.537e-002*cos(t)+ 1.000e+000* 6.504e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  5.012e-001, 1.477e-003 center
replot  5.012e-001+ 2.000*( 1.000e+000* 4.557e-002*cos(t)+-2.286e-003* 1.104e-003*sin(t)),  1.477e-003 +2.000*( 2.286e-003* 4.557e-002*cos(t)+ 1.000e+000* 1.104e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  4.247e-001, 3.007e-003 center
replot  4.247e-001+ 2.000*( 1.000e+000* 3.042e-002*cos(t)+-4.805e-003* 1.809e-003*sin(t)),  3.007e-003 +2.000*( 4.805e-003* 3.042e-002*cos(t)+ 1.000e+000* 1.809e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.568e-001, 6.113e-003 center
replot  3.568e-001+ 2.000*( 1.000e+000* 2.185e-002*cos(t)+-8.925e-003* 2.840e-003*sin(t)),  6.113e-003 +2.000*( 8.925e-003* 2.185e-002*cos(t)+ 1.000e+000* 2.840e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.972e-001, 1.240e-002 center
replot  2.972e-001+ 2.000*( 9.998e-001* 2.055e-002*cos(t)+-1.860e-002* 4.296e-003*sin(t)),  1.240e-002 +2.000*( 1.860e-002* 2.055e-002*cos(t)+ 9.998e-001* 4.296e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.457e-001, 2.506e-002 center
replot  2.457e-001+ 2.000*( 9.987e-001* 2.304e-002*cos(t)+-5.177e-002* 6.832e-003*sin(t)),  2.506e-002 +2.000*( 5.177e-002* 2.304e-002*cos(t)+ 9.987e-001* 6.832e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.016e-001, 5.026e-002 center
replot  2.016e-001+ 2.000*( 9.845e-001* 2.595e-002*cos(t)+-1.754e-001* 1.384e-002*sin(t)),  5.026e-002 +2.000*( 1.754e-001* 2.595e-002*cos(t)+ 9.845e-001* 1.384e-002*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.642e-001, 9.943e-002 center
replot  1.642e-001+ 2.000*( 3.454e-001* 3.722e-002*cos(t)+-9.384e-001* 2.555e-002*sin(t)),  9.943e-002 +2.000*( 9.384e-001* 3.722e-002*cos(t)+ 3.454e-001* 2.555e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.328e-001, 1.918e-001 center
replot  1.328e-001+ 2.000*( 8.244e-002* 8.809e-002*cos(t)+-9.966e-001* 2.661e-002*sin(t)),  1.918e-001 +2.000*( 9.966e-001* 8.809e-002*cos(t)+ 8.244e-002* 2.661e-002*sin(t)) not
set out;
set out "CZMsr/VARPIJGR_CZMsr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "CZMsr/VARPIJGR_CZMsr_123-13.svg"
set label "50" at  2.318e-002, 7.246e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  2.318e-002+ 2.000*( 9.996e-001* 7.733e-003*cos(t)+ 2.894e-002* 6.147e-004*sin(t)),  7.246e-004 +2.000*(-2.894e-002* 7.733e-003*cos(t)+ 9.996e-001* 6.147e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  3.074e-002, 1.477e-003 center
replot  3.074e-002+ 2.000*( 9.989e-001* 8.332e-003*cos(t)+ 4.595e-002* 1.041e-003*sin(t)),  1.477e-003 +2.000*(-4.595e-002* 8.332e-003*cos(t)+ 9.989e-001* 1.041e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  4.038e-002, 3.007e-003 center
replot  4.038e-002+ 2.000*( 9.972e-001* 8.628e-003*cos(t)+ 7.458e-002* 1.702e-003*sin(t)),  3.007e-003 +2.000*(-7.458e-002* 8.628e-003*cos(t)+ 9.972e-001* 1.702e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  5.258e-002, 6.113e-003 center
replot  5.258e-002+ 2.000*( 9.923e-001* 8.706e-003*cos(t)+ 1.235e-001* 2.656e-003*sin(t)),  6.113e-003 +2.000*(-1.235e-001* 8.706e-003*cos(t)+ 9.923e-001* 2.656e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  6.790e-002, 1.240e-002 center
replot  6.790e-002+ 2.000*( 9.800e-001* 9.205e-003*cos(t)+ 1.989e-001* 3.983e-003*sin(t)),  1.240e-002 +2.000*(-1.989e-001* 9.205e-003*cos(t)+ 9.800e-001* 3.983e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  8.701e-002, 2.506e-002 center
replot  8.701e-002+ 2.000*( 9.564e-001* 1.178e-002*cos(t)+ 2.920e-001* 6.286e-003*sin(t)),  2.506e-002 +2.000*(-2.920e-001* 1.178e-002*cos(t)+ 9.564e-001* 6.286e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.107e-001, 5.026e-002 center
replot  1.107e-001+ 2.000*( 8.587e-001* 1.886e-002*cos(t)+ 5.125e-001* 1.238e-002*sin(t)),  5.026e-002 +2.000*(-5.125e-001* 1.886e-002*cos(t)+ 8.587e-001* 1.238e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.397e-001, 9.943e-002 center
replot  1.397e-001+ 2.000*( 4.459e-001* 3.836e-002*cos(t)+ 8.951e-001* 2.445e-002*sin(t)),  9.943e-002 +2.000*(-8.951e-001* 3.836e-002*cos(t)+ 4.459e-001* 2.445e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.752e-001, 1.918e-001 center
replot  1.752e-001+ 2.000*( 2.054e-001* 8.934e-002*cos(t)+ 9.787e-001* 3.987e-002*sin(t)),  1.918e-001 +2.000*(-9.787e-001* 8.934e-002*cos(t)+ 2.054e-001* 3.987e-002*sin(t)) not
set out;
set out "CZMsr/VARPIJGR_CZMsr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "CZMsr/VARPIJGR_CZMsr_123-21.svg"
set label "50" at  2.318e-002, 5.858e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  2.318e-002+ 2.000*( 1.679e-002* 6.538e-002*cos(t)+ 9.999e-001* 7.652e-003*sin(t)),  5.858e-001 +2.000*(-9.999e-001* 6.538e-002*cos(t)+ 1.679e-002* 7.652e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  3.074e-002, 5.012e-001 center
replot  3.074e-002+ 2.000*( 2.051e-002* 4.558e-002*cos(t)+ 9.998e-001* 8.272e-003*sin(t)),  5.012e-001 +2.000*(-9.998e-001* 4.558e-002*cos(t)+ 2.051e-002* 8.272e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  4.038e-002, 4.247e-001 center
replot  4.038e-002+ 2.000*( 2.499e-002* 3.043e-002*cos(t)+ 9.997e-001* 8.574e-003*sin(t)),  4.247e-001 +2.000*(-9.997e-001* 3.043e-002*cos(t)+ 2.499e-002* 8.574e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  5.258e-002, 3.568e-001 center
replot  5.258e-002+ 2.000*( 3.633e-002* 2.186e-002*cos(t)+ 9.993e-001* 8.615e-003*sin(t)),  3.568e-001 +2.000*(-9.993e-001* 2.186e-002*cos(t)+ 3.633e-002* 8.615e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  6.790e-002, 2.972e-001 center
replot  6.790e-002+ 2.000*( 6.919e-002* 2.058e-002*cos(t)+ 9.976e-001* 8.965e-003*sin(t)),  2.972e-001 +2.000*(-9.976e-001* 2.058e-002*cos(t)+ 6.919e-002* 8.965e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  8.701e-002, 2.457e-001 center
replot  8.701e-002+ 2.000*( 1.239e-001* 2.315e-002*cos(t)+ 9.923e-001* 1.113e-002*sin(t)),  2.457e-001 +2.000*(-9.923e-001* 2.315e-002*cos(t)+ 1.239e-001* 1.113e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.107e-001, 2.016e-001 center
replot  1.107e-001+ 2.000*( 2.504e-001* 2.615e-002*cos(t)+ 9.681e-001* 1.665e-002*sin(t)),  2.016e-001 +2.000*(-9.681e-001* 2.615e-002*cos(t)+ 2.504e-001* 1.665e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.397e-001, 1.642e-001 center
replot  1.397e-001+ 2.000*( 7.384e-001* 3.048e-002*cos(t)+ 6.743e-001* 2.414e-002*sin(t)),  1.642e-001 +2.000*(-6.743e-001* 3.048e-002*cos(t)+ 7.384e-001* 2.414e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.752e-001, 1.328e-001 center
replot  1.752e-001+ 2.000*( 9.726e-001* 4.389e-002*cos(t)+ 2.327e-001* 2.625e-002*sin(t)),  1.328e-001 +2.000*(-2.327e-001* 4.389e-002*cos(t)+ 9.726e-001* 2.625e-002*sin(t)) not
set out;
set out "CZMsr/VARPIJGR_CZMsr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "CZMsr/VARMUPTJGR--STABLBASED_CZMsr1.svg";
 plot "CZMsr/PRMORPREV-1-STABLBASED_CZMsr.txt"  u 1:($3) not w l lt 1 
 replot "CZMsr/PRMORPREV-1-STABLBASED_CZMsr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "CZMsr/PRMORPREV-1-STABLBASED_CZMsr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "CZMsr/VARMUPTJGR--STABLBASED_CZMsr1.svg";replot;set out;
