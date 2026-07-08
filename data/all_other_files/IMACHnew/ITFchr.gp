
# IMaCh-0.99r45
# ITFchr.gp
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


set ter svg size 640, 480;set out "ITFchr/D_ITFchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "ITFchr/ILK_ITFchr-dest.png";
set log y;plot  "ITFchr/ILK_ITFchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "ITFchr/ILK_ITFchr-ori.png";
set log y;plot  "ITFchr/ILK_ITFchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "ITFchr/ILK_ITFchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ITFchr/ILK_ITFchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "ITFchr/ILK_ITFchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ITFchr/ILK_ITFchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "ITFchr/V_ITFchr_1-1-1.svg" 

#set out "V_ITFchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ITFchr/VPL_ITFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"ITFchr/VPL_ITFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"ITFchr/VPL_ITFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"ITFchr/P_ITFchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "ITFchr/V_ITFchr_2-1-1.svg" 

#set out "V_ITFchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ITFchr/VPL_ITFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"ITFchr/VPL_ITFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"ITFchr/VPL_ITFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"ITFchr/P_ITFchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "ITFchr/E_ITFchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "ITFchr/T_ITFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"ITFchr/T_ITFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"ITFchr/T_ITFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"ITFchr/T_ITFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"ITFchr/T_ITFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"ITFchr/T_ITFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"ITFchr/T_ITFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"ITFchr/T_ITFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"ITFchr/T_ITFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "ITFchr/E_ITFchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "ITFchr/EXP_ITFchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ITFchr/E_ITFchr.txt" every :::0::0 u 1:2 t "e11" w l ,"ITFchr/E_ITFchr.txt" every :::0::0 u 1:3 t "e12" w l ,"ITFchr/E_ITFchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "ITFchr/EXP_ITFchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ITFchr/E_ITFchr.txt" every :::0::0 u 1:5 t "e21" w l ,"ITFchr/E_ITFchr.txt" every :::0::0 u 1:6 t "e22" w l ,"ITFchr/E_ITFchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "ITFchr/LIJ_ITFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITFchr/PIJ_ITFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "ITFchr/LIJ_ITFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITFchr/PIJ_ITFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "ITFchr/LIJT_ITFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITFchr/PIJ_ITFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "ITFchr/LIJT_ITFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITFchr/PIJ_ITFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "ITFchr/P_ITFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITFchr/PIJ_ITFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "ITFchr/P_ITFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITFchr/PIJ_ITFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-4.662212; p2=0.072955; 
#   current state 3
p3=-16.787456; p4=0.193764; 
# initial state 2
#   current state 1
p5=3.585479; p6=-0.082029; 
#   current state 3
p7=-12.326545; p8=0.127785; 
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

set out "ITFchr/PE_ITFchr_1-1-1.svg" 
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

set out "ITFchr/PE_ITFchr_1-2-1.svg" 
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

set out "ITFchr/PE_ITFchr_1-3-1.svg" 
set key outside 
set title "()" font "Helvetica,12"

set ter svg size 640, 480 
set ylabel "Quasi-incidence per year"

set log y
plot  [50:90]  (1.)/(1+exp(p1+p2*x)+exp(p3+p4*x)) w l lw 2 lt (3*1+1)%3+1 dt 1 t "i11" , 0.500000*exp(p1+p2*x)/(1+exp(p1+p2*x)+exp(p3+p4*x)) w l lw 2 lt (3*1+2)%3+1 dt 1 t "i12" , 0.500000*exp(p3+p4*x)/(1+exp(p1+p2*x)+exp(p3+p4*x)) w l lw 2 lt (3*1+3)%3+1 dt 1 t "i13" , 0.500000*exp(p5+p6*x)/(1+exp(p5+p6*x)+exp(p7+p8*x)) w l lw 2 lt (3*2+1)%3+1 dt 2 t "i21" , (1.)/(1+exp(p5+p6*x)+exp(p7+p8*x)) w l lw 2 lt (3*2+2)%3+1 dt 2 t "i22" , 0.500000*exp(p7+p8*x)/(1+exp(p5+p6*x)+exp(p7+p8*x)) w l lw 2 lt (3*2+3)%3+1 dt 2 t "i23" 
 set out; unset title;set key default;

# Routine varprob
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p13 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ITFchr/VARPIJGR_ITFchr_113-12.svg"
set label "50" at  3.028e-004, 1.330e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  3.028e-004+ 2.000*( 1.491e-003* 1.589e-002*cos(t)+ 1.000e+000* 5.294e-004*sin(t)),  1.330e-001 +2.000*(-1.000e+000* 1.589e-002*cos(t)+ 1.491e-003* 5.294e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  7.136e-004, 1.713e-001 center
replot  7.136e-004+ 2.000*( 5.890e-003* 1.345e-002*cos(t)+ 1.000e+000* 1.021e-003*sin(t)),  1.713e-001 +2.000*(-1.000e+000* 1.345e-002*cos(t)+ 5.890e-003* 1.021e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.631e-003, 2.139e-001 center
replot  1.631e-003+ 2.000*( 1.998e-002* 1.143e-002*cos(t)+ 9.998e-001* 1.826e-003*sin(t)),  2.139e-001 +2.000*(-9.998e-001* 1.143e-002*cos(t)+ 1.998e-002* 1.826e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  3.599e-003, 2.581e-001 center
replot  3.599e-003+ 2.000*( 3.897e-002* 1.236e-002*cos(t)+ 9.992e-001* 2.976e-003*sin(t)),  2.581e-001 +2.000*(-9.992e-001* 1.236e-002*cos(t)+ 3.897e-002* 2.976e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  7.654e-003, 3.000e-001 center
replot  7.654e-003+ 2.000*( 5.363e-002* 1.574e-002*cos(t)+ 9.986e-001* 4.406e-003*sin(t)),  3.000e-001 +2.000*(-9.986e-001* 1.574e-002*cos(t)+ 5.363e-002* 4.406e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.564e-002, 3.352e-001 center
replot  1.564e-002+ 2.000*( 1.091e-001* 1.920e-002*cos(t)+ 9.940e-001* 6.674e-003*sin(t)),  3.352e-001 +2.000*(-9.940e-001* 1.920e-002*cos(t)+ 1.091e-001* 6.674e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.062e-002, 3.586e-001 center
replot  3.062e-002+ 2.000*( 4.381e-001* 2.519e-002*cos(t)+ 8.989e-001* 1.183e-002*sin(t)),  3.586e-001 +2.000*(-8.989e-001* 2.519e-002*cos(t)+ 4.381e-001* 1.183e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  5.698e-002, 3.647e-001 center
replot  5.698e-002+ 2.000*( 7.140e-001* 5.197e-002*cos(t)+ 7.002e-001* 1.344e-002*sin(t)),  3.647e-001 +2.000*(-7.002e-001* 5.197e-002*cos(t)+ 7.140e-001* 1.344e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  9.960e-002, 3.485e-001 center
replot  9.960e-002+ 2.000*( 7.419e-001* 1.114e-001*cos(t)+ 6.705e-001* 1.137e-002*sin(t)),  3.485e-001 +2.000*(-6.705e-001* 1.114e-001*cos(t)+ 7.419e-001* 1.137e-002*sin(t)) not
set out;
set out "ITFchr/VARPIJGR_ITFchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ITFchr/VARPIJGR_ITFchr_121-12.svg"
set label "50" at  1.866e-001, 1.330e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  1.866e-001+ 2.000*( 9.922e-001* 1.738e-002*cos(t)+-1.246e-001* 1.587e-002*sin(t)),  1.330e-001 +2.000*( 1.246e-001* 1.738e-002*cos(t)+ 9.922e-001* 1.587e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  1.414e-001, 1.713e-001 center
replot  1.414e-001+ 2.000*( 7.376e-002* 1.346e-002*cos(t)+-9.973e-001* 1.153e-002*sin(t)),  1.713e-001 +2.000*( 9.973e-001* 1.346e-002*cos(t)+ 7.376e-002* 1.153e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  1.033e-001, 2.139e-001 center
replot  1.033e-001+ 2.000*( 2.345e-002* 1.143e-002*cos(t)+-9.997e-001* 7.211e-003*sin(t)),  2.139e-001 +2.000*( 9.997e-001* 1.143e-002*cos(t)+ 2.345e-002* 7.211e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  7.313e-002, 2.581e-001 center
replot  7.313e-002+ 2.000*( 9.542e-003* 1.235e-002*cos(t)+-1.000e+000* 5.005e-003*sin(t)),  2.581e-001 +2.000*( 1.000e+000* 1.235e-002*cos(t)+ 9.542e-003* 5.005e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  5.033e-002, 3.000e-001 center
replot  5.033e-002+ 2.000*( 5.220e-003* 1.572e-002*cos(t)+-1.000e+000* 4.289e-003*sin(t)),  3.000e-001 +2.000*( 1.000e+000* 1.572e-002*cos(t)+ 5.220e-003* 4.289e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  3.364e-002, 3.352e-001 center
replot  3.364e-002+ 2.000*( 3.465e-003* 1.910e-002*cos(t)+-1.000e+000* 3.892e-003*sin(t)),  3.352e-001 +2.000*( 1.000e+000* 1.910e-002*cos(t)+ 3.465e-003* 3.892e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.172e-002, 3.586e-001 center
replot  2.172e-002+ 2.000*( 1.659e-003* 2.323e-002*cos(t)+-1.000e+000* 3.327e-003*sin(t)),  3.586e-001 +2.000*( 1.000e+000* 2.323e-002*cos(t)+ 1.659e-003* 3.327e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.336e-002, 3.647e-001 center
replot  1.336e-002+ 2.000*( 3.865e-004* 3.763e-002*cos(t)+ 1.000e+000* 2.600e-003*sin(t)),  3.647e-001 +2.000*(-1.000e+000* 3.763e-002*cos(t)+ 3.865e-004* 2.600e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  7.682e-003, 3.485e-001 center
replot  7.682e-003+ 2.000*( 7.906e-004* 7.519e-002*cos(t)+ 1.000e+000* 1.848e-003*sin(t)),  3.485e-001 +2.000*(-1.000e+000* 7.519e-002*cos(t)+ 7.906e-004* 1.848e-003*sin(t)) not
set out;
set out "ITFchr/VARPIJGR_ITFchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ITFchr/VARPIJGR_ITFchr_123-12.svg"
set label "50" at  8.250e-004, 1.330e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  8.250e-004+ 2.000*( 7.761e-004* 1.589e-002*cos(t)+-1.000e+000* 3.931e-004*sin(t)),  1.330e-001 +2.000*( 1.000e+000* 1.589e-002*cos(t)+ 7.761e-004* 3.931e-004*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.784e-003, 1.713e-001 center
replot  1.784e-003+ 2.000*( 2.043e-003* 1.345e-002*cos(t)+-1.000e+000* 7.157e-004*sin(t)),  1.713e-001 +2.000*( 1.000e+000* 1.345e-002*cos(t)+ 2.043e-003* 7.157e-004*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.722e-003, 2.139e-001 center
replot  3.722e-003+ 2.000*( 5.100e-003* 1.142e-002*cos(t)+-1.000e+000* 1.219e-003*sin(t)),  2.139e-001 +2.000*( 1.000e+000* 1.142e-002*cos(t)+ 5.100e-003* 1.219e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  7.524e-003, 2.581e-001 center
replot  7.524e-003+ 2.000*( 7.953e-003* 1.235e-002*cos(t)+-1.000e+000* 1.924e-003*sin(t)),  2.581e-001 +2.000*( 1.000e+000* 1.235e-002*cos(t)+ 7.953e-003* 1.924e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  1.478e-002, 3.000e-001 center
replot  1.478e-002+ 2.000*( 8.446e-003* 1.572e-002*cos(t)+-1.000e+000* 2.774e-003*sin(t)),  3.000e-001 +2.000*( 1.000e+000* 1.572e-002*cos(t)+ 8.446e-003* 2.774e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  2.821e-002, 3.352e-001 center
replot  2.821e-002+ 2.000*( 6.953e-003* 1.910e-002*cos(t)+-1.000e+000* 3.637e-003*sin(t)),  3.352e-001 +2.000*( 1.000e+000* 1.910e-002*cos(t)+ 6.953e-003* 3.637e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  5.200e-002, 3.586e-001 center
replot  5.200e-002+ 2.000*( 3.431e-003* 2.323e-002*cos(t)+-1.000e+000* 4.927e-003*sin(t)),  3.586e-001 +2.000*( 1.000e+000* 2.323e-002*cos(t)+ 3.431e-003* 4.927e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  9.136e-002, 3.647e-001 center
replot  9.136e-002+ 2.000*( 1.477e-002* 3.764e-002*cos(t)+-9.999e-001* 9.114e-003*sin(t)),  3.647e-001 +2.000*( 9.999e-001* 3.764e-002*cos(t)+ 1.477e-002* 9.114e-003*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.499e-001, 3.485e-001 center
replot  1.499e-001+ 2.000*( 3.061e-002* 7.522e-002*cos(t)+-9.995e-001* 1.805e-002*sin(t)),  3.485e-001 +2.000*( 9.995e-001* 7.522e-002*cos(t)+ 3.061e-002* 1.805e-002*sin(t)) not
set out;
set out "ITFchr/VARPIJGR_ITFchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ITFchr/VARPIJGR_ITFchr_121-13.svg"
set label "50" at  1.866e-001, 3.028e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  1.866e-001+ 2.000*( 1.000e+000* 1.736e-002*cos(t)+-8.150e-004* 5.297e-004*sin(t)),  3.028e-004 +2.000*( 8.150e-004* 1.736e-002*cos(t)+ 1.000e+000* 5.297e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  1.414e-001, 7.136e-004 center
replot  1.414e-001+ 2.000*( 1.000e+000* 1.154e-002*cos(t)+-2.734e-003* 1.024e-003*sin(t)),  7.136e-004 +2.000*( 2.734e-003* 1.154e-002*cos(t)+ 1.000e+000* 1.024e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  1.033e-001, 1.631e-003 center
replot  1.033e-001+ 2.000*( 1.000e+000* 7.214e-003*cos(t)+-9.783e-003* 1.839e-003*sin(t)),  1.631e-003 +2.000*( 9.783e-003* 7.214e-003*cos(t)+ 1.000e+000* 1.839e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  7.313e-002, 3.599e-003 center
replot  7.313e-002+ 2.000*( 9.994e-001* 5.008e-003*cos(t)+-3.573e-002* 3.009e-003*sin(t)),  3.599e-003 +2.000*( 3.573e-002* 5.008e-003*cos(t)+ 9.994e-001* 3.009e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  5.033e-002, 7.654e-003 center
replot  5.033e-002+ 2.000*( 3.157e-001* 4.503e-003*cos(t)+-9.489e-001* 4.265e-003*sin(t)),  7.654e-003 +2.000*( 9.489e-001* 4.503e-003*cos(t)+ 3.157e-001* 4.265e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  3.364e-002, 1.564e-002 center
replot  3.364e-002+ 2.000*( 1.835e-002* 6.958e-003*cos(t)+-9.998e-001* 3.891e-003*sin(t)),  1.564e-002 +2.000*( 9.998e-001* 6.958e-003*cos(t)+ 1.835e-002* 3.891e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.172e-002, 3.062e-002 center
replot  2.172e-002+ 2.000*( 3.145e-003* 1.532e-002*cos(t)+-1.000e+000* 3.327e-003*sin(t)),  3.062e-002 +2.000*( 1.000e+000* 1.532e-002*cos(t)+ 3.145e-003* 3.327e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.336e-002, 5.698e-002 center
replot  1.336e-002+ 2.000*( 1.261e-003* 3.828e-002*cos(t)+-1.000e+000* 2.600e-003*sin(t)),  5.698e-002 +2.000*( 1.000e+000* 3.828e-002*cos(t)+ 1.261e-003* 2.600e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  7.682e-003, 9.960e-002 center
replot  7.682e-003+ 2.000*( 8.296e-004* 8.302e-002*cos(t)+-1.000e+000* 1.848e-003*sin(t)),  9.960e-002 +2.000*( 1.000e+000* 8.302e-002*cos(t)+ 8.296e-004* 1.848e-003*sin(t)) not
set out;
set out "ITFchr/VARPIJGR_ITFchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ITFchr/VARPIJGR_ITFchr_123-13.svg"
set label "50" at  8.250e-004, 3.028e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  8.250e-004+ 2.000*( 3.487e-001* 5.487e-004*cos(t)+ 9.372e-001* 3.666e-004*sin(t)),  3.028e-004 +2.000*(-9.372e-001* 5.487e-004*cos(t)+ 3.487e-001* 3.666e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.784e-003, 7.136e-004 center
replot  1.784e-003+ 2.000*( 3.076e-001* 1.055e-003*cos(t)+ 9.515e-001* 6.710e-004*sin(t)),  7.136e-004 +2.000*(-9.515e-001* 1.055e-003*cos(t)+ 3.076e-001* 6.710e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.722e-003, 1.631e-003 center
replot  3.722e-003+ 2.000*( 2.767e-001* 1.886e-003*cos(t)+ 9.610e-001* 1.148e-003*sin(t)),  1.631e-003 +2.000*(-9.610e-001* 1.886e-003*cos(t)+ 2.767e-001* 1.148e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  7.524e-003, 3.599e-003 center
replot  7.524e-003+ 2.000*( 2.545e-001* 3.078e-003*cos(t)+ 9.671e-001* 1.820e-003*sin(t)),  3.599e-003 +2.000*(-9.671e-001* 3.078e-003*cos(t)+ 2.545e-001* 1.820e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  1.478e-002, 7.654e-003 center
replot  1.478e-002+ 2.000*( 2.186e-001* 4.552e-003*cos(t)+ 9.758e-001* 2.657e-003*sin(t)),  7.654e-003 +2.000*(-9.758e-001* 4.552e-003*cos(t)+ 2.186e-001* 2.657e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  2.821e-002, 1.564e-002 center
replot  2.821e-002+ 2.000*( 9.348e-002* 6.979e-003*cos(t)+ 9.956e-001* 3.597e-003*sin(t)),  1.564e-002 +2.000*(-9.956e-001* 6.979e-003*cos(t)+ 9.348e-002* 3.597e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  5.200e-002, 3.062e-002 center
replot  5.200e-002+ 2.000*( 7.323e-003* 1.532e-002*cos(t)+ 1.000e+000* 4.926e-003*sin(t)),  3.062e-002 +2.000*(-1.000e+000* 1.532e-002*cos(t)+ 7.323e-003* 4.926e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  9.136e-002, 5.698e-002 center
replot  9.136e-002+ 2.000*( 1.543e-002* 3.829e-002*cos(t)+ 9.999e-001* 9.112e-003*sin(t)),  5.698e-002 +2.000*(-9.999e-001* 3.829e-002*cos(t)+ 1.543e-002* 9.112e-003*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.499e-001, 9.960e-002 center
replot  1.499e-001+ 2.000*( 2.776e-002* 8.305e-002*cos(t)+ 9.996e-001* 1.804e-002*sin(t)),  9.960e-002 +2.000*(-9.996e-001* 8.305e-002*cos(t)+ 2.776e-002* 1.804e-002*sin(t)) not
set out;
set out "ITFchr/VARPIJGR_ITFchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "ITFchr/VARPIJGR_ITFchr_123-21.svg"
set label "50" at  8.250e-004, 1.866e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  8.250e-004+ 2.000*( 2.561e-003* 1.736e-002*cos(t)+ 1.000e+000* 3.908e-004*sin(t)),  1.866e-001 +2.000*(-1.000e+000* 1.736e-002*cos(t)+ 2.561e-003* 3.908e-004*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.784e-003, 1.414e-001 center
replot  1.784e-003+ 2.000*( 5.131e-003* 1.154e-002*cos(t)+ 1.000e+000* 7.137e-004*sin(t)),  1.414e-001 +2.000*(-1.000e+000* 1.154e-002*cos(t)+ 5.131e-003* 7.137e-004*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.722e-003, 1.033e-001 center
replot  3.722e-003+ 2.000*( 1.188e-002* 7.215e-003*cos(t)+ 9.999e-001* 1.217e-003*sin(t)),  1.033e-001 +2.000*(-9.999e-001* 7.215e-003*cos(t)+ 1.188e-002* 1.217e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  7.524e-003, 7.313e-002 center
replot  7.524e-003+ 2.000*( 3.204e-002* 5.008e-003*cos(t)+ 9.995e-001* 1.921e-003*sin(t)),  7.313e-002 +2.000*(-9.995e-001* 5.008e-003*cos(t)+ 3.204e-002* 1.921e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  1.478e-002, 5.033e-002 center
replot  1.478e-002+ 2.000*( 8.539e-002* 4.299e-003*cos(t)+ 9.963e-001* 2.763e-003*sin(t)),  5.033e-002 +2.000*(-9.963e-001* 4.299e-003*cos(t)+ 8.539e-002* 2.763e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  2.821e-002, 3.364e-002 center
replot  2.821e-002+ 2.000*( 4.199e-001* 3.959e-003*cos(t)+ 9.076e-001* 3.568e-003*sin(t)),  3.364e-002 +2.000*(-9.076e-001* 3.959e-003*cos(t)+ 4.199e-001* 3.568e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  5.200e-002, 2.172e-002 center
replot  5.200e-002+ 2.000*( 9.951e-001* 4.941e-003*cos(t)+ 9.875e-002* 3.307e-003*sin(t)),  2.172e-002 +2.000*(-9.875e-002* 4.941e-003*cos(t)+ 9.951e-001* 3.307e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  9.136e-002, 1.336e-002 center
replot  9.136e-002+ 2.000*( 9.994e-001* 9.135e-003*cos(t)+ 3.473e-002* 2.582e-003*sin(t)),  1.336e-002 +2.000*(-3.473e-002* 9.135e-003*cos(t)+ 9.994e-001* 2.582e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.499e-001, 7.682e-003 center
replot  1.499e-001+ 2.000*( 9.998e-001* 1.819e-002*cos(t)+ 2.111e-002* 1.809e-003*sin(t)),  7.682e-003 +2.000*(-2.111e-002* 1.819e-002*cos(t)+ 9.998e-001* 1.809e-003*sin(t)) not
set out;
set out "ITFchr/VARPIJGR_ITFchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "ITFchr/VARMUPTJGR--STABLBASED_ITFchr1.svg";
 plot "ITFchr/PRMORPREV-1-STABLBASED_ITFchr.txt"  u 1:($3) not w l lt 1 
 replot "ITFchr/PRMORPREV-1-STABLBASED_ITFchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "ITFchr/PRMORPREV-1-STABLBASED_ITFchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "ITFchr/VARMUPTJGR--STABLBASED_ITFchr1.svg";replot;set out;
