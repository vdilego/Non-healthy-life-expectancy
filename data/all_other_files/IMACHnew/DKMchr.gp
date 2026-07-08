
# IMaCh-0.99r45
# DKMchr.gp
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


set ter svg size 640, 480;set out "DKMchr/D_DKMchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "DKMchr/ILK_DKMchr-dest.png";
set log y;plot  "DKMchr/ILK_DKMchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "DKMchr/ILK_DKMchr-ori.png";
set log y;plot  "DKMchr/ILK_DKMchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "DKMchr/ILK_DKMchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "DKMchr/ILK_DKMchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "DKMchr/ILK_DKMchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "DKMchr/ILK_DKMchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "DKMchr/V_DKMchr_1-1-1.svg" 

#set out "V_DKMchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "DKMchr/VPL_DKMchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"DKMchr/VPL_DKMchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"DKMchr/VPL_DKMchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"DKMchr/P_DKMchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "DKMchr/V_DKMchr_2-1-1.svg" 

#set out "V_DKMchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "DKMchr/VPL_DKMchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"DKMchr/VPL_DKMchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"DKMchr/VPL_DKMchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"DKMchr/P_DKMchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "DKMchr/E_DKMchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "DKMchr/T_DKMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"DKMchr/T_DKMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"DKMchr/T_DKMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"DKMchr/T_DKMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"DKMchr/T_DKMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"DKMchr/T_DKMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"DKMchr/T_DKMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"DKMchr/T_DKMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"DKMchr/T_DKMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "DKMchr/E_DKMchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "DKMchr/EXP_DKMchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "DKMchr/E_DKMchr.txt" every :::0::0 u 1:2 t "e11" w l ,"DKMchr/E_DKMchr.txt" every :::0::0 u 1:3 t "e12" w l ,"DKMchr/E_DKMchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "DKMchr/EXP_DKMchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "DKMchr/E_DKMchr.txt" every :::0::0 u 1:5 t "e21" w l ,"DKMchr/E_DKMchr.txt" every :::0::0 u 1:6 t "e22" w l ,"DKMchr/E_DKMchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "DKMchr/LIJ_DKMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKMchr/PIJ_DKMchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "DKMchr/LIJ_DKMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKMchr/PIJ_DKMchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "DKMchr/LIJT_DKMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKMchr/PIJ_DKMchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "DKMchr/LIJT_DKMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKMchr/PIJ_DKMchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "DKMchr/P_DKMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKMchr/PIJ_DKMchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "DKMchr/P_DKMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKMchr/PIJ_DKMchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-2.491870; p2=0.028930; 
#   current state 3
p3=-16.134040; p4=0.174791; 
# initial state 2
#   current state 1
p5=0.507487; p6=-0.043692; 
#   current state 3
p7=-12.349431; p8=0.137468; 
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

set out "DKMchr/PE_DKMchr_1-1-1.svg" 
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

set out "DKMchr/PE_DKMchr_1-2-1.svg" 
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

set out "DKMchr/PE_DKMchr_1-3-1.svg" 
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
set out "DKMchr/VARPIJGR_DKMchr_113-12.svg"
set label "50" at  2.273e-004, 1.300e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  2.273e-004+ 2.000*( 3.542e-005* 1.893e-002*cos(t)+-1.000e+000* 3.958e-004*sin(t)),  1.300e-001 +2.000*( 1.000e+000* 1.893e-002*cos(t)+ 3.542e-005* 3.958e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  5.231e-004, 1.443e-001 center
replot  5.231e-004+ 2.000*( 8.881e-004* 1.505e-002*cos(t)+ 1.000e+000* 7.561e-004*sin(t)),  1.443e-001 +2.000*(-1.000e+000* 1.505e-002*cos(t)+ 8.881e-004* 7.561e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.198e-003, 1.594e-001 center
replot  1.198e-003+ 2.000*( 5.743e-003* 1.232e-002*cos(t)+ 1.000e+000* 1.387e-003*sin(t)),  1.594e-001 +2.000*(-1.000e+000* 1.232e-002*cos(t)+ 5.743e-003* 1.387e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  2.727e-003, 1.749e-001 center
replot  2.727e-003+ 2.000*( 1.676e-002* 1.290e-002*cos(t)+ 9.999e-001* 2.425e-003*sin(t)),  1.749e-001 +2.000*(-9.999e-001* 1.290e-002*cos(t)+ 1.676e-002* 2.425e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  6.152e-003, 1.903e-001 center
replot  6.152e-003+ 2.000*( 2.775e-002* 1.722e-002*cos(t)+ 9.996e-001* 4.092e-003*sin(t)),  1.903e-001 +2.000*(-9.996e-001* 1.722e-002*cos(t)+ 2.775e-002* 4.092e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.370e-002, 2.043e-001 center
replot  1.370e-002+ 2.000*( 5.278e-002* 2.356e-002*cos(t)+ 9.986e-001* 7.331e-003*sin(t)),  2.043e-001 +2.000*(-9.986e-001* 2.356e-002*cos(t)+ 5.278e-002* 7.331e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  2.979e-002, 2.143e-001 center
replot  2.979e-002+ 2.000*( 2.006e-001* 3.121e-002*cos(t)+ 9.797e-001* 1.593e-002*sin(t)),  2.143e-001 +2.000*(-9.797e-001* 3.121e-002*cos(t)+ 2.006e-001* 1.593e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  6.208e-002, 2.154e-001 center
replot  6.208e-002+ 2.000*( 7.318e-001* 5.164e-002*cos(t)+ 6.815e-001* 2.821e-002*sin(t)),  2.154e-001 +2.000*(-6.815e-001* 5.164e-002*cos(t)+ 7.318e-001* 2.821e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.199e-001, 2.006e-001 center
replot  1.199e-001+ 2.000*( 8.538e-001* 1.080e-001*cos(t)+ 5.207e-001* 3.086e-002*sin(t)),  2.006e-001 +2.000*(-5.207e-001* 1.080e-001*cos(t)+ 8.538e-001* 3.086e-002*sin(t)) not
set out;
set out "DKMchr/VARPIJGR_DKMchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "DKMchr/VARPIJGR_DKMchr_121-12.svg"
set label "50" at  7.846e-002, 1.300e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  7.846e-002+ 2.000*( 1.859e-002* 1.893e-002*cos(t)+-9.998e-001* 1.428e-002*sin(t)),  1.300e-001 +2.000*( 9.998e-001* 1.893e-002*cos(t)+ 1.859e-002* 1.428e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  6.484e-002, 1.443e-001 center
replot  6.484e-002+ 2.000*( 1.027e-002* 1.505e-002*cos(t)+-9.999e-001* 9.135e-003*sin(t)),  1.443e-001 +2.000*( 9.999e-001* 1.505e-002*cos(t)+ 1.027e-002* 9.135e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  5.309e-002, 1.594e-001 center
replot  5.309e-002+ 2.000*( 7.504e-003* 1.232e-002*cos(t)+-1.000e+000* 5.877e-003*sin(t)),  1.594e-001 +2.000*( 1.000e+000* 1.232e-002*cos(t)+ 7.504e-003* 5.877e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  4.295e-002, 1.749e-001 center
replot  4.295e-002+ 2.000*( 6.158e-003* 1.290e-002*cos(t)+-1.000e+000* 4.648e-003*sin(t)),  1.749e-001 +2.000*( 1.000e+000* 1.290e-002*cos(t)+ 6.158e-003* 4.648e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  3.411e-002, 1.903e-001 center
replot  3.411e-002+ 2.000*( 4.399e-003* 1.722e-002*cos(t)+-1.000e+000* 4.736e-003*sin(t)),  1.903e-001 +2.000*( 1.000e+000* 1.722e-002*cos(t)+ 4.399e-003* 4.736e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.628e-002, 2.043e-001 center
replot  2.628e-002+ 2.000*( 2.570e-003* 2.353e-002*cos(t)+-1.000e+000* 4.969e-003*sin(t)),  2.043e-001 +2.000*( 1.000e+000* 2.353e-002*cos(t)+ 2.570e-003* 4.969e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.925e-002, 2.143e-001 center
replot  1.925e-002+ 2.000*( 6.563e-004* 3.075e-002*cos(t)+-1.000e+000* 4.791e-003*sin(t)),  2.143e-001 +2.000*( 1.000e+000* 3.075e-002*cos(t)+ 6.563e-004* 4.791e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.302e-002, 2.154e-001 center
replot  1.302e-002+ 2.000*( 1.216e-003* 4.080e-002*cos(t)+ 1.000e+000* 4.114e-003*sin(t)),  2.154e-001 +2.000*(-1.000e+000* 4.080e-002*cos(t)+ 1.216e-003* 4.114e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  7.919e-003, 2.006e-001 center
replot  7.919e-003+ 2.000*( 1.660e-003* 6.212e-002*cos(t)+ 1.000e+000* 3.112e-003*sin(t)),  2.006e-001 +2.000*(-1.000e+000* 6.212e-002*cos(t)+ 1.660e-003* 3.112e-003*sin(t)) not
set out;
set out "DKMchr/VARPIJGR_DKMchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "DKMchr/VARPIJGR_DKMchr_123-12.svg"
set label "50" at  1.757e-003, 1.300e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  1.757e-003+ 2.000*( 1.677e-004* 1.893e-002*cos(t)+-1.000e+000* 7.444e-004*sin(t)),  1.300e-001 +2.000*( 1.000e+000* 1.893e-002*cos(t)+ 1.677e-004* 7.444e-004*sin(t)) not
# Age 55, p23 - p12
set label "55" at  3.592e-003, 1.443e-001 center
replot  3.592e-003+ 2.000*( 4.689e-004* 1.505e-002*cos(t)+-1.000e+000* 1.259e-003*sin(t)),  1.443e-001 +2.000*( 1.000e+000* 1.505e-002*cos(t)+ 4.689e-004* 1.259e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  7.276e-003, 1.594e-001 center
replot  7.276e-003+ 2.000*( 1.342e-003* 1.232e-002*cos(t)+-1.000e+000* 2.034e-003*sin(t)),  1.594e-001 +2.000*( 1.000e+000* 1.232e-002*cos(t)+ 1.342e-003* 2.034e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.456e-002, 1.749e-001 center
replot  1.456e-002+ 2.000*( 2.666e-003* 1.290e-002*cos(t)+-1.000e+000* 3.090e-003*sin(t)),  1.749e-001 +2.000*( 1.000e+000* 1.290e-002*cos(t)+ 2.666e-003* 3.090e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  2.861e-002, 1.903e-001 center
replot  2.861e-002+ 2.000*( 3.438e-003* 1.722e-002*cos(t)+-1.000e+000* 4.402e-003*sin(t)),  1.903e-001 +2.000*( 1.000e+000* 1.722e-002*cos(t)+ 3.438e-003* 4.402e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  5.454e-002, 2.043e-001 center
replot  5.454e-002+ 2.000*( 4.324e-003* 2.353e-002*cos(t)+-1.000e+000* 6.331e-003*sin(t)),  2.043e-001 +2.000*( 1.000e+000* 2.353e-002*cos(t)+ 4.324e-003* 6.331e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  9.882e-002, 2.143e-001 center
replot  9.882e-002+ 2.000*( 7.299e-003* 3.075e-002*cos(t)+-1.000e+000* 1.087e-002*sin(t)),  2.143e-001 +2.000*( 1.000e+000* 3.075e-002*cos(t)+ 7.299e-003* 1.087e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.654e-001, 2.154e-001 center
replot  1.654e-001+ 2.000*( 1.732e-002* 4.081e-002*cos(t)+-9.998e-001* 1.982e-002*sin(t)),  2.154e-001 +2.000*( 9.998e-001* 4.081e-002*cos(t)+ 1.732e-002* 1.982e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.488e-001, 2.006e-001 center
replot  2.488e-001+ 2.000*( 2.499e-002* 6.214e-002*cos(t)+-9.997e-001* 2.979e-002*sin(t)),  2.006e-001 +2.000*( 9.997e-001* 6.214e-002*cos(t)+ 2.499e-002* 2.979e-002*sin(t)) not
set out;
set out "DKMchr/VARPIJGR_DKMchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "DKMchr/VARPIJGR_DKMchr_121-13.svg"
set label "50" at  7.846e-002, 2.273e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  7.846e-002+ 2.000*( 1.000e+000* 1.428e-002*cos(t)+-6.612e-004* 3.957e-004*sin(t)),  2.273e-004 +2.000*( 6.612e-004* 1.428e-002*cos(t)+ 1.000e+000* 3.957e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  6.484e-002, 5.231e-004 center
replot  6.484e-002+ 2.000*( 1.000e+000* 9.136e-003*cos(t)+-1.774e-003* 7.561e-004*sin(t)),  5.231e-004 +2.000*( 1.774e-003* 9.136e-003*cos(t)+ 1.000e+000* 7.561e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  5.309e-002, 1.198e-003 center
replot  5.309e-002+ 2.000*( 1.000e+000* 5.878e-003*cos(t)+-4.196e-003* 1.389e-003*sin(t)),  1.198e-003 +2.000*( 4.196e-003* 5.878e-003*cos(t)+ 1.000e+000* 1.389e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  4.295e-002, 2.727e-003 center
replot  4.295e-002+ 2.000*( 1.000e+000* 4.649e-003*cos(t)+-8.231e-003* 2.435e-003*sin(t)),  2.727e-003 +2.000*( 8.231e-003* 4.649e-003*cos(t)+ 1.000e+000* 2.435e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  3.411e-002, 6.152e-003 center
replot  3.411e-002+ 2.000*( 9.989e-001* 4.738e-003*cos(t)+-4.708e-002* 4.117e-003*sin(t)),  6.152e-003 +2.000*( 4.708e-002* 4.738e-003*cos(t)+ 9.989e-001* 4.117e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.628e-002, 1.370e-002 center
replot  2.628e-002+ 2.000*( 3.045e-002* 7.428e-003*cos(t)+-9.995e-001* 4.967e-003*sin(t)),  1.370e-002 +2.000*( 9.995e-001* 7.428e-003*cos(t)+ 3.045e-002* 4.967e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.925e-002, 2.979e-002 center
replot  1.925e-002+ 2.000*( 1.165e-002* 1.682e-002*cos(t)+-9.999e-001* 4.787e-003*sin(t)),  2.979e-002 +2.000*( 9.999e-001* 1.682e-002*cos(t)+ 1.165e-002* 4.787e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.302e-002, 6.208e-002 center
replot  1.302e-002+ 2.000*( 4.347e-003* 4.240e-002*cos(t)+-1.000e+000* 4.111e-003*sin(t)),  6.208e-002 +2.000*( 1.000e+000* 4.240e-002*cos(t)+ 4.347e-003* 4.111e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  7.919e-003, 1.199e-001 center
replot  7.919e-003+ 2.000*( 1.653e-003* 9.364e-002*cos(t)+-1.000e+000* 3.110e-003*sin(t)),  1.199e-001 +2.000*( 1.000e+000* 9.364e-002*cos(t)+ 1.653e-003* 3.110e-003*sin(t)) not
set out;
set out "DKMchr/VARPIJGR_DKMchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "DKMchr/VARPIJGR_DKMchr_123-13.svg"
set label "50" at  1.757e-003, 2.273e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  1.757e-003+ 2.000*( 9.986e-001* 7.452e-004*cos(t)+ 5.373e-002* 3.944e-004*sin(t)),  2.273e-004 +2.000*(-5.373e-002* 7.452e-004*cos(t)+ 9.986e-001* 3.944e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  3.592e-003, 5.231e-004 center
replot  3.592e-003+ 2.000*( 9.977e-001* 1.261e-003*cos(t)+ 6.801e-002* 7.531e-004*sin(t)),  5.231e-004 +2.000*(-6.801e-002* 1.261e-003*cos(t)+ 9.977e-001* 7.531e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  7.276e-003, 1.198e-003 center
replot  7.276e-003+ 2.000*( 9.958e-001* 2.038e-003*cos(t)+ 9.207e-002* 1.382e-003*sin(t)),  1.198e-003 +2.000*(-9.207e-002* 2.038e-003*cos(t)+ 9.958e-001* 1.382e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.456e-002, 2.727e-003 center
replot  1.456e-002+ 2.000*( 9.896e-001* 3.103e-003*cos(t)+ 1.437e-001* 2.419e-003*sin(t)),  2.727e-003 +2.000*(-1.437e-001* 3.103e-003*cos(t)+ 9.896e-001* 2.419e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  2.861e-002, 6.152e-003 center
replot  2.861e-002+ 2.000*( 9.260e-001* 4.457e-003*cos(t)+ 3.776e-001* 4.060e-003*sin(t)),  6.152e-003 +2.000*(-3.776e-001* 4.457e-003*cos(t)+ 9.260e-001* 4.060e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  5.454e-002, 1.370e-002 center
replot  5.454e-002+ 2.000*( 1.477e-001* 7.449e-003*cos(t)+ 9.890e-001* 6.304e-003*sin(t)),  1.370e-002 +2.000*(-9.890e-001* 7.449e-003*cos(t)+ 1.477e-001* 6.304e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  9.882e-002, 2.979e-002 center
replot  9.882e-002+ 2.000*( 3.997e-002* 1.682e-002*cos(t)+ 9.992e-001* 1.086e-002*sin(t)),  2.979e-002 +2.000*(-9.992e-001* 1.682e-002*cos(t)+ 3.997e-002* 1.086e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.654e-001, 6.208e-002 center
replot  1.654e-001+ 2.000*( 2.331e-002* 4.241e-002*cos(t)+ 9.997e-001* 1.981e-002*sin(t)),  6.208e-002 +2.000*(-9.997e-001* 4.241e-002*cos(t)+ 2.331e-002* 1.981e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.488e-001, 1.199e-001 center
replot  2.488e-001+ 2.000*( 1.586e-002* 9.365e-002*cos(t)+ 9.999e-001* 2.978e-002*sin(t)),  1.199e-001 +2.000*(-9.999e-001* 9.365e-002*cos(t)+ 1.586e-002* 2.978e-002*sin(t)) not
set out;
set out "DKMchr/VARPIJGR_DKMchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "DKMchr/VARPIJGR_DKMchr_123-21.svg"
set label "50" at  1.757e-003, 7.846e-002 center
# Age 50, p23 - p21
plot [-pi:pi]  1.757e-003+ 2.000*( 3.252e-003* 1.428e-002*cos(t)+ 1.000e+000* 7.430e-004*sin(t)),  7.846e-002 +2.000*(-1.000e+000* 1.428e-002*cos(t)+ 3.252e-003* 7.430e-004*sin(t)) not
# Age 55, p23 - p21
set label "55" at  3.592e-003, 6.484e-002 center
replot  3.592e-003+ 2.000*( 6.797e-003* 9.136e-003*cos(t)+ 1.000e+000* 1.258e-003*sin(t)),  6.484e-002 +2.000*(-1.000e+000* 9.136e-003*cos(t)+ 6.797e-003* 1.258e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  7.276e-003, 5.309e-002 center
replot  7.276e-003+ 2.000*( 1.851e-002* 5.879e-003*cos(t)+ 9.998e-001* 2.031e-003*sin(t)),  5.309e-002 +2.000*(-9.998e-001* 5.879e-003*cos(t)+ 1.851e-002* 2.031e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.456e-002, 4.295e-002 center
replot  1.456e-002+ 2.000*( 6.936e-002* 4.655e-003*cos(t)+ 9.976e-001* 3.081e-003*sin(t)),  4.295e-002 +2.000*(-9.976e-001* 4.655e-003*cos(t)+ 6.936e-002* 3.081e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  2.861e-002, 3.411e-002 center
replot  2.861e-002+ 2.000*( 3.784e-001* 4.801e-003*cos(t)+ 9.256e-001* 4.333e-003*sin(t)),  3.411e-002 +2.000*(-9.256e-001* 4.801e-003*cos(t)+ 3.784e-001* 4.333e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  5.454e-002, 2.628e-002 center
replot  5.454e-002+ 2.000*( 9.856e-001* 6.368e-003*cos(t)+ 1.689e-001* 4.923e-003*sin(t)),  2.628e-002 +2.000*(-1.689e-001* 6.368e-003*cos(t)+ 9.856e-001* 4.923e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  9.882e-002, 1.925e-002 center
replot  9.882e-002+ 2.000*( 9.980e-001* 1.089e-002*cos(t)+ 6.336e-002* 4.750e-003*sin(t)),  1.925e-002 +2.000*(-6.336e-002* 1.089e-002*cos(t)+ 9.980e-001* 4.750e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.654e-001, 1.302e-002 center
replot  1.654e-001+ 2.000*( 9.992e-001* 1.985e-002*cos(t)+ 4.021e-002* 4.040e-003*sin(t)),  1.302e-002 +2.000*(-4.021e-002* 1.985e-002*cos(t)+ 9.992e-001* 4.040e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.488e-001, 7.919e-003 center
replot  2.488e-001+ 2.000*( 9.995e-001* 2.983e-002*cos(t)+ 3.082e-002* 2.976e-003*sin(t)),  7.919e-003 +2.000*(-3.082e-002* 2.983e-002*cos(t)+ 9.995e-001* 2.976e-003*sin(t)) not
set out;
set out "DKMchr/VARPIJGR_DKMchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "DKMchr/VARMUPTJGR--STABLBASED_DKMchr1.svg";
 plot "DKMchr/PRMORPREV-1-STABLBASED_DKMchr.txt"  u 1:($3) not w l lt 1 
 replot "DKMchr/PRMORPREV-1-STABLBASED_DKMchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "DKMchr/PRMORPREV-1-STABLBASED_DKMchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "DKMchr/VARMUPTJGR--STABLBASED_DKMchr1.svg";replot;set out;
