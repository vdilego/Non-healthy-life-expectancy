
# IMaCh-0.99r45
# PLFchr.gp
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


set ter svg size 640, 480;set out "PLFchr/D_PLFchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "PLFchr/ILK_PLFchr-dest.png";
set log y;plot  "PLFchr/ILK_PLFchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "PLFchr/ILK_PLFchr-ori.png";
set log y;plot  "PLFchr/ILK_PLFchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "PLFchr/ILK_PLFchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "PLFchr/ILK_PLFchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "PLFchr/ILK_PLFchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "PLFchr/ILK_PLFchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "PLFchr/V_PLFchr_1-1-1.svg" 

#set out "V_PLFchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "PLFchr/VPL_PLFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"PLFchr/VPL_PLFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"PLFchr/VPL_PLFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"PLFchr/P_PLFchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "PLFchr/V_PLFchr_2-1-1.svg" 

#set out "V_PLFchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "PLFchr/VPL_PLFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"PLFchr/VPL_PLFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"PLFchr/VPL_PLFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"PLFchr/P_PLFchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "PLFchr/E_PLFchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "PLFchr/T_PLFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"PLFchr/T_PLFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"PLFchr/T_PLFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"PLFchr/T_PLFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"PLFchr/T_PLFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"PLFchr/T_PLFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"PLFchr/T_PLFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"PLFchr/T_PLFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"PLFchr/T_PLFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "PLFchr/E_PLFchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "PLFchr/EXP_PLFchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "PLFchr/E_PLFchr.txt" every :::0::0 u 1:2 t "e11" w l ,"PLFchr/E_PLFchr.txt" every :::0::0 u 1:3 t "e12" w l ,"PLFchr/E_PLFchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "PLFchr/EXP_PLFchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "PLFchr/E_PLFchr.txt" every :::0::0 u 1:5 t "e21" w l ,"PLFchr/E_PLFchr.txt" every :::0::0 u 1:6 t "e22" w l ,"PLFchr/E_PLFchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "PLFchr/LIJ_PLFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFchr/PIJ_PLFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "PLFchr/LIJ_PLFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFchr/PIJ_PLFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "PLFchr/LIJT_PLFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFchr/PIJ_PLFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "PLFchr/LIJT_PLFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFchr/PIJ_PLFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "PLFchr/P_PLFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFchr/PIJ_PLFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "PLFchr/P_PLFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFchr/PIJ_PLFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-3.670773; p2=0.054644; 
#   current state 3
p3=-29.763154; p4=0.371445; 
# initial state 2
#   current state 1
p5=-0.294761; p6=-0.032622; 
#   current state 3
p7=-10.115498; p8=0.106341; 
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

set out "PLFchr/PE_PLFchr_1-1-1.svg" 
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

set out "PLFchr/PE_PLFchr_1-2-1.svg" 
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

set out "PLFchr/PE_PLFchr_1-3-1.svg" 
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
set out "PLFchr/VARPIJGR_PLFchr_113-12.svg"
set label "50" at  4.959e-006, 1.406e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  4.959e-006+ 2.000*( 5.357e-005* 3.493e-002*cos(t)+-1.000e+000* 2.496e-005*sin(t)),  1.406e-001 +2.000*( 1.000e+000* 3.493e-002*cos(t)+ 5.357e-005* 2.496e-005*sin(t)) not
# Age 55, p13 - p12
set label "55" at  2.919e-005, 1.698e-001 center
replot  2.919e-005+ 2.000*( 1.532e-004* 2.629e-002*cos(t)+-1.000e+000* 1.241e-004*sin(t)),  1.698e-001 +2.000*( 1.000e+000* 2.629e-002*cos(t)+ 1.532e-004* 1.241e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.689e-004, 2.015e-001 center
replot  1.689e-004+ 2.000*( 1.220e-003* 2.152e-002*cos(t)+ 1.000e+000* 5.847e-004*sin(t)),  2.015e-001 +2.000*(-1.000e+000* 2.152e-002*cos(t)+ 1.220e-003* 5.847e-004*sin(t)) not
# Age 65, p13 - p12
set label "65" at  9.589e-004, 2.347e-001 center
replot  9.589e-004+ 2.000*( 1.036e-002* 2.802e-002*cos(t)+ 9.999e-001* 2.560e-003*sin(t)),  2.347e-001 +2.000*(-9.999e-001* 2.802e-002*cos(t)+ 1.036e-002* 2.560e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  5.305e-003, 2.664e-001 center
replot  5.305e-003+ 2.000*( 4.873e-002* 4.154e-002*cos(t)+ 9.988e-001* 9.996e-003*sin(t)),  2.664e-001 +2.000*(-9.988e-001* 4.154e-002*cos(t)+ 4.873e-002* 9.996e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.775e-002, 2.858e-001 center
replot  2.775e-002+ 2.000*( 2.902e-001* 5.780e-002*cos(t)+ 9.570e-001* 2.942e-002*sin(t)),  2.858e-001 +2.000*(-9.570e-001* 5.780e-002*cos(t)+ 2.902e-001* 2.942e-002*sin(t)) not
# Age 80, p13 - p12
set label "80" at  1.201e-001, 2.539e-001 center
replot  1.201e-001+ 2.000*( 7.388e-001* 9.106e-002*cos(t)+ 6.739e-001* 3.983e-002*sin(t)),  2.539e-001 +2.000*(-6.739e-001* 9.106e-002*cos(t)+ 7.388e-001* 3.983e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  3.130e-001, 1.357e-001 center
replot  3.130e-001+ 2.000*( 8.067e-001* 1.412e-001*cos(t)+ 5.910e-001* 2.208e-002*sin(t)),  1.357e-001 +2.000*(-5.910e-001* 1.412e-001*cos(t)+ 8.067e-001* 2.208e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  4.486e-001, 3.990e-002 center
replot  4.486e-001+ 2.000*( 7.907e-001* 9.299e-002*cos(t)+ 6.122e-001* 6.147e-003*sin(t)),  3.990e-002 +2.000*(-6.122e-001* 9.299e-002*cos(t)+ 7.907e-001* 6.147e-003*sin(t)) not
set out;
set out "PLFchr/VARPIJGR_PLFchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "PLFchr/VARPIJGR_PLFchr_121-12.svg"
set label "50" at  6.315e-002, 1.406e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  6.315e-002+ 2.000*( 1.081e-002* 3.493e-002*cos(t)+-9.999e-001* 1.525e-002*sin(t)),  1.406e-001 +2.000*( 9.999e-001* 3.493e-002*cos(t)+ 1.081e-002* 1.525e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  5.441e-002, 1.698e-001 center
replot  5.441e-002+ 2.000*( 9.204e-003* 2.629e-002*cos(t)+-1.000e+000* 1.024e-002*sin(t)),  1.698e-001 +2.000*( 1.000e+000* 2.629e-002*cos(t)+ 9.204e-003* 1.024e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  4.658e-002, 2.015e-001 center
replot  4.658e-002+ 2.000*( 7.878e-003* 2.152e-002*cos(t)+-1.000e+000* 6.846e-003*sin(t)),  2.015e-001 +2.000*( 1.000e+000* 2.152e-002*cos(t)+ 7.878e-003* 6.846e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.954e-002, 2.347e-001 center
replot  3.954e-002+ 2.000*( 5.167e-003* 2.802e-002*cos(t)+-1.000e+000* 5.334e-003*sin(t)),  2.347e-001 +2.000*( 1.000e+000* 2.802e-002*cos(t)+ 5.167e-003* 5.334e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  3.314e-002, 2.664e-001 center
replot  3.314e-002+ 2.000*( 3.526e-003* 4.150e-002*cos(t)+-1.000e+000* 5.371e-003*sin(t)),  2.664e-001 +2.000*( 1.000e+000* 4.150e-002*cos(t)+ 3.526e-003* 5.371e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.727e-002, 2.858e-001 center
replot  2.727e-002+ 2.000*( 1.609e-003* 5.597e-002*cos(t)+-1.000e+000* 5.894e-003*sin(t)),  2.858e-001 +2.000*( 1.000e+000* 5.597e-002*cos(t)+ 1.609e-003* 5.894e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.182e-002, 2.539e-001 center
replot  2.182e-002+ 2.000*( 3.201e-003* 6.806e-002*cos(t)+ 1.000e+000* 6.186e-003*sin(t)),  2.539e-001 +2.000*(-1.000e+000* 6.806e-002*cos(t)+ 3.201e-003* 6.186e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.677e-002, 1.357e-001 center
replot  1.677e-002+ 2.000*( 5.493e-003* 8.535e-002*cos(t)+ 1.000e+000* 6.007e-003*sin(t)),  1.357e-001 +2.000*(-1.000e+000* 8.535e-002*cos(t)+ 5.493e-003* 6.007e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.220e-002, 3.990e-002 center
replot  1.220e-002+ 2.000*( 6.518e-003* 5.714e-002*cos(t)+ 1.000e+000* 5.388e-003*sin(t)),  3.990e-002 +2.000*(-1.000e+000* 5.714e-002*cos(t)+ 6.518e-003* 5.388e-003*sin(t)) not
set out;
set out "PLFchr/VARPIJGR_PLFchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "PLFchr/VARPIJGR_PLFchr_123-12.svg"
set label "50" at  3.571e-003, 1.406e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  3.571e-003+ 2.000*( 1.086e-004* 3.493e-002*cos(t)+-1.000e+000* 1.595e-003*sin(t)),  1.406e-001 +2.000*( 1.000e+000* 3.493e-002*cos(t)+ 1.086e-004* 1.595e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  6.164e-003, 1.698e-001 center
replot  6.164e-003+ 2.000*( 1.911e-004* 2.629e-002*cos(t)+-1.000e+000* 2.282e-003*sin(t)),  1.698e-001 +2.000*( 1.000e+000* 2.629e-002*cos(t)+ 1.911e-004* 2.282e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  1.057e-002, 2.015e-001 center
replot  1.057e-002+ 2.000*( 4.709e-004* 2.152e-002*cos(t)+-1.000e+000* 3.134e-003*sin(t)),  2.015e-001 +2.000*( 1.000e+000* 2.152e-002*cos(t)+ 4.709e-004* 3.134e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.798e-002, 2.347e-001 center
replot  1.798e-002+ 2.000*( 1.060e-003* 2.802e-002*cos(t)+-1.000e+000* 4.090e-003*sin(t)),  2.347e-001 +2.000*( 1.000e+000* 2.802e-002*cos(t)+ 1.060e-003* 4.090e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  3.019e-002, 2.664e-001 center
replot  3.019e-002+ 2.000*( 2.000e-003* 4.150e-002*cos(t)+-1.000e+000* 5.114e-003*sin(t)),  2.664e-001 +2.000*( 1.000e+000* 4.150e-002*cos(t)+ 2.000e-003* 5.114e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  4.977e-002, 2.858e-001 center
replot  4.977e-002+ 2.000*( 3.972e-003* 5.597e-002*cos(t)+-1.000e+000* 6.651e-003*sin(t)),  2.858e-001 +2.000*( 1.000e+000* 5.597e-002*cos(t)+ 3.972e-003* 6.651e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  7.978e-002, 2.539e-001 center
replot  7.978e-002+ 2.000*( 8.769e-003* 6.806e-002*cos(t)+-1.000e+000* 1.044e-002*sin(t)),  2.539e-001 +2.000*( 1.000e+000* 6.806e-002*cos(t)+ 8.769e-003* 1.044e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.228e-001, 1.357e-001 center
replot  1.228e-001+ 2.000*( 1.270e-002* 8.535e-002*cos(t)+-9.999e-001* 1.835e-002*sin(t)),  1.357e-001 +2.000*( 9.999e-001* 8.535e-002*cos(t)+ 1.270e-002* 1.835e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.791e-001, 3.990e-002 center
replot  1.791e-001+ 2.000*( 3.246e-002* 5.716e-002*cos(t)+-9.995e-001* 2.974e-002*sin(t)),  3.990e-002 +2.000*( 9.995e-001* 5.716e-002*cos(t)+ 3.246e-002* 2.974e-002*sin(t)) not
set out;
set out "PLFchr/VARPIJGR_PLFchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "PLFchr/VARPIJGR_PLFchr_121-13.svg"
set label "50" at  6.315e-002, 4.959e-006 center
# Age 50, p21 - p13
plot [-pi:pi]  6.315e-002+ 2.000*( 1.000e+000* 1.525e-002*cos(t)+-2.149e-005* 2.502e-005*sin(t)),  4.959e-006 +2.000*( 2.149e-005* 1.525e-002*cos(t)+ 1.000e+000* 2.502e-005*sin(t)) not
# Age 55, p21 - p13
set label "55" at  5.441e-002, 2.919e-005 center
replot  5.441e-002+ 2.000*( 1.000e+000* 1.024e-002*cos(t)+-1.173e-004* 1.241e-004*sin(t)),  2.919e-005 +2.000*( 1.173e-004* 1.024e-002*cos(t)+ 1.000e+000* 1.241e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  4.658e-002, 1.689e-004 center
replot  4.658e-002+ 2.000*( 1.000e+000* 6.848e-003*cos(t)+-4.722e-004* 5.853e-004*sin(t)),  1.689e-004 +2.000*( 4.722e-004* 6.848e-003*cos(t)+ 1.000e+000* 5.853e-004*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.954e-002, 9.589e-004 center
replot  3.954e-002+ 2.000*( 1.000e+000* 5.335e-003*cos(t)+-2.069e-003* 2.576e-003*sin(t)),  9.589e-004 +2.000*( 2.069e-003* 5.335e-003*cos(t)+ 1.000e+000* 2.576e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  3.314e-002, 5.305e-003 center
replot  3.314e-002+ 2.000*( 6.900e-003* 1.019e-002*cos(t)+-1.000e+000* 5.372e-003*sin(t)),  5.305e-003 +2.000*( 1.000e+000* 1.019e-002*cos(t)+ 6.900e-003* 5.372e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.727e-002, 2.775e-002 center
replot  2.727e-002+ 2.000*( 5.645e-003* 3.278e-002*cos(t)+-1.000e+000* 5.892e-003*sin(t)),  2.775e-002 +2.000*( 1.000e+000* 3.278e-002*cos(t)+ 5.645e-003* 5.892e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.182e-002, 1.201e-001 center
replot  2.182e-002+ 2.000*( 6.583e-003* 7.243e-002*cos(t)+-1.000e+000* 6.172e-003*sin(t)),  1.201e-001 +2.000*( 1.000e+000* 7.243e-002*cos(t)+ 6.583e-003* 6.172e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.677e-002, 3.130e-001 center
replot  1.677e-002+ 2.000*( 4.610e-003* 1.147e-001*cos(t)+-1.000e+000* 6.002e-003*sin(t)),  3.130e-001 +2.000*( 1.000e+000* 1.147e-001*cos(t)+ 4.610e-003* 6.002e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.220e-002, 4.486e-001 center
replot  1.220e-002+ 2.000*( 5.265e-003* 7.362e-002*cos(t)+-1.000e+000* 5.387e-003*sin(t)),  4.486e-001 +2.000*( 1.000e+000* 7.362e-002*cos(t)+ 5.265e-003* 5.387e-003*sin(t)) not
set out;
set out "PLFchr/VARPIJGR_PLFchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "PLFchr/VARPIJGR_PLFchr_123-13.svg"
set label "50" at  3.571e-003, 4.959e-006 center
# Age 50, p23 - p13
plot [-pi:pi]  3.571e-003+ 2.000*( 1.000e+000* 1.595e-003*cos(t)+ 6.728e-004* 2.500e-005*sin(t)),  4.959e-006 +2.000*(-6.728e-004* 1.595e-003*cos(t)+ 1.000e+000* 2.500e-005*sin(t)) not
# Age 55, p23 - p13
set label "55" at  6.164e-003, 2.919e-005 center
replot  6.164e-003+ 2.000*( 1.000e+000* 2.282e-003*cos(t)+ 2.363e-003* 1.240e-004*sin(t)),  2.919e-005 +2.000*(-2.363e-003* 2.282e-003*cos(t)+ 1.000e+000* 1.240e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  1.057e-002, 1.689e-004 center
replot  1.057e-002+ 2.000*( 1.000e+000* 3.134e-003*cos(t)+ 8.532e-003* 5.847e-004*sin(t)),  1.689e-004 +2.000*(-8.532e-003* 3.134e-003*cos(t)+ 1.000e+000* 5.847e-004*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.798e-002, 9.589e-004 center
replot  1.798e-002+ 2.000*( 9.989e-001* 4.093e-003*cos(t)+ 4.717e-002* 2.572e-003*sin(t)),  9.589e-004 +2.000*(-4.717e-002* 4.093e-003*cos(t)+ 9.989e-001* 2.572e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  3.019e-002, 5.305e-003 center
replot  3.019e-002+ 2.000*( 3.159e-002* 1.019e-002*cos(t)+ 9.995e-001* 5.107e-003*sin(t)),  5.305e-003 +2.000*(-9.995e-001* 1.019e-002*cos(t)+ 3.159e-002* 5.107e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  4.977e-002, 2.775e-002 center
replot  4.977e-002+ 2.000*( 1.059e-002* 3.278e-002*cos(t)+ 9.999e-001* 6.646e-003*sin(t)),  2.775e-002 +2.000*(-9.999e-001* 3.278e-002*cos(t)+ 1.059e-002* 6.646e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  7.978e-002, 1.201e-001 center
replot  7.978e-002+ 2.000*( 8.481e-003* 7.243e-002*cos(t)+ 1.000e+000* 1.044e-002*sin(t)),  1.201e-001 +2.000*(-1.000e+000* 7.243e-002*cos(t)+ 8.481e-003* 1.044e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.228e-001, 3.130e-001 center
replot  1.228e-001+ 2.000*( 8.430e-003* 1.147e-001*cos(t)+ 1.000e+000* 1.836e-002*sin(t)),  3.130e-001 +2.000*(-1.000e+000* 1.147e-001*cos(t)+ 8.430e-003* 1.836e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.791e-001, 4.486e-001 center
replot  1.791e-001+ 2.000*( 2.076e-002* 7.363e-002*cos(t)+ 9.998e-001* 2.975e-002*sin(t)),  4.486e-001 +2.000*(-9.998e-001* 7.363e-002*cos(t)+ 2.076e-002* 2.975e-002*sin(t)) not
set out;
set out "PLFchr/VARPIJGR_PLFchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "PLFchr/VARPIJGR_PLFchr_123-21.svg"
set label "50" at  3.571e-003, 6.315e-002 center
# Age 50, p23 - p21
plot [-pi:pi]  3.571e-003+ 2.000*( 6.009e-003* 1.525e-002*cos(t)+ 1.000e+000* 1.593e-003*sin(t)),  6.315e-002 +2.000*(-1.000e+000* 1.525e-002*cos(t)+ 6.009e-003* 1.593e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  6.164e-003, 5.441e-002 center
replot  6.164e-003+ 2.000*( 1.096e-002* 1.024e-002*cos(t)+ 9.999e-001* 2.280e-003*sin(t)),  5.441e-002 +2.000*(-9.999e-001* 1.024e-002*cos(t)+ 1.096e-002* 2.280e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  1.057e-002, 4.658e-002 center
replot  1.057e-002+ 2.000*( 2.704e-002* 6.850e-003*cos(t)+ 9.996e-001* 3.129e-003*sin(t)),  4.658e-002 +2.000*(-9.996e-001* 6.850e-003*cos(t)+ 2.704e-002* 3.129e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.798e-002, 3.954e-002 center
replot  1.798e-002+ 2.000*( 1.093e-001* 5.349e-003*cos(t)+ 9.940e-001* 4.073e-003*sin(t)),  3.954e-002 +2.000*(-9.940e-001* 5.349e-003*cos(t)+ 1.093e-001* 4.073e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  3.019e-002, 3.314e-002 center
replot  3.019e-002+ 2.000*( 4.873e-001* 5.486e-003*cos(t)+ 8.732e-001* 4.993e-003*sin(t)),  3.314e-002 +2.000*(-8.732e-001* 5.486e-003*cos(t)+ 4.873e-001* 4.993e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  4.977e-002, 2.727e-002 center
replot  4.977e-002+ 2.000*( 9.373e-001* 6.769e-003*cos(t)+ 3.484e-001* 5.763e-003*sin(t)),  2.727e-002 +2.000*(-3.484e-001* 6.769e-003*cos(t)+ 9.373e-001* 5.763e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  7.978e-002, 2.182e-002 center
replot  7.978e-002+ 2.000*( 9.929e-001* 1.051e-002*cos(t)+ 1.186e-001* 6.106e-003*sin(t)),  2.182e-002 +2.000*(-1.186e-001* 1.051e-002*cos(t)+ 9.929e-001* 6.106e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.228e-001, 1.677e-002 center
replot  1.228e-001+ 2.000*( 9.980e-001* 1.842e-002*cos(t)+ 6.310e-002* 5.923e-003*sin(t)),  1.677e-002 +2.000*(-6.310e-002* 1.842e-002*cos(t)+ 9.980e-001* 5.923e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.791e-001, 1.220e-002 center
replot  1.791e-001+ 2.000*( 9.990e-001* 2.981e-002*cos(t)+ 4.402e-002* 5.244e-003*sin(t)),  1.220e-002 +2.000*(-4.402e-002* 2.981e-002*cos(t)+ 9.990e-001* 5.244e-003*sin(t)) not
set out;
set out "PLFchr/VARPIJGR_PLFchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "PLFchr/VARMUPTJGR--STABLBASED_PLFchr1.svg";
 plot "PLFchr/PRMORPREV-1-STABLBASED_PLFchr.txt"  u 1:($3) not w l lt 1 
 replot "PLFchr/PRMORPREV-1-STABLBASED_PLFchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "PLFchr/PRMORPREV-1-STABLBASED_PLFchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "PLFchr/VARMUPTJGR--STABLBASED_PLFchr1.svg";replot;set out;
