
# IMaCh-0.99r45
# GRFadl.gp
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


set ter svg size 640, 480;set out "GRFadl/D_GRFadl_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "GRFadl/ILK_GRFadl-dest.png";
set log y;plot  "GRFadl/ILK_GRFadl.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "GRFadl/ILK_GRFadl-ori.png";
set log y;plot  "GRFadl/ILK_GRFadl.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "GRFadl/ILK_GRFadl-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "GRFadl/ILK_GRFadl.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "GRFadl/ILK_GRFadl-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "GRFadl/ILK_GRFadl.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "GRFadl/V_GRFadl_1-1-1.svg" 

#set out "V_GRFadl_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "GRFadl/VPL_GRFadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"GRFadl/VPL_GRFadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"GRFadl/VPL_GRFadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"GRFadl/P_GRFadl.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "GRFadl/V_GRFadl_2-1-1.svg" 

#set out "V_GRFadl_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "GRFadl/VPL_GRFadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"GRFadl/VPL_GRFadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"GRFadl/VPL_GRFadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"GRFadl/P_GRFadl.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "GRFadl/E_GRFadl_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "GRFadl/T_GRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"GRFadl/T_GRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"GRFadl/T_GRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"GRFadl/T_GRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"GRFadl/T_GRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"GRFadl/T_GRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"GRFadl/T_GRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"GRFadl/T_GRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"GRFadl/T_GRFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "GRFadl/E_GRFadl_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "GRFadl/EXP_GRFadl_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "GRFadl/E_GRFadl.txt" every :::0::0 u 1:2 t "e11" w l ,"GRFadl/E_GRFadl.txt" every :::0::0 u 1:3 t "e12" w l ,"GRFadl/E_GRFadl.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "GRFadl/EXP_GRFadl_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "GRFadl/E_GRFadl.txt" every :::0::0 u 1:5 t "e21" w l ,"GRFadl/E_GRFadl.txt" every :::0::0 u 1:6 t "e22" w l ,"GRFadl/E_GRFadl.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "GRFadl/LIJ_GRFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRFadl/PIJ_GRFadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "GRFadl/LIJ_GRFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRFadl/PIJ_GRFadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "GRFadl/LIJT_GRFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRFadl/PIJ_GRFadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "GRFadl/LIJT_GRFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRFadl/PIJ_GRFadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "GRFadl/P_GRFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRFadl/PIJ_GRFadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "GRFadl/P_GRFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRFadl/PIJ_GRFadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-14.412046; p2=0.136792; 
#   current state 3
p3=-19.961846; p4=0.200534; 
# initial state 2
#   current state 1
p5=-2.167241; p6=0.000675; 
#   current state 3
p7=-8.943571; p8=0.082680; 
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

set out "GRFadl/PE_GRFadl_1-1-1.svg" 
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

set out "GRFadl/PE_GRFadl_1-2-1.svg" 
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

set out "GRFadl/PE_GRFadl_1-3-1.svg" 
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
set out "GRFadl/VARPIJGR_GRFadl_113-12.svg"
set label "50" at  9.683e-005, 1.028e-003 center
# Age 50, p13 - p12
plot [-pi:pi]  9.683e-005+ 2.000*( 1.396e-002* 5.418e-004*cos(t)+ 9.999e-001* 7.943e-005*sin(t)),  1.028e-003 +2.000*(-9.999e-001* 5.418e-004*cos(t)+ 1.396e-002* 7.943e-005*sin(t)) not
# Age 55, p13 - p12
set label "55" at  2.638e-004, 2.037e-003 center
replot  2.638e-004+ 2.000*( 2.020e-002* 9.002e-004*cos(t)+ 9.998e-001* 1.842e-004*sin(t)),  2.037e-003 +2.000*(-9.998e-001* 9.002e-004*cos(t)+ 2.020e-002* 1.842e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  7.180e-004, 4.031e-003 center
replot  7.180e-004+ 2.000*( 3.037e-002* 1.447e-003*cos(t)+ 9.995e-001* 4.145e-004*sin(t)),  4.031e-003 +2.000*(-9.995e-001* 1.447e-003*cos(t)+ 3.037e-002* 4.145e-004*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.952e-003, 7.967e-003 center
replot  1.952e-003+ 2.000*( 4.929e-002* 2.228e-003*cos(t)+ 9.988e-001* 8.939e-004*sin(t)),  7.967e-003 +2.000*(-9.988e-001* 2.228e-003*cos(t)+ 4.929e-002* 8.939e-004*sin(t)) not
# Age 70, p13 - p12
set label "70" at  5.290e-003, 1.570e-002 center
replot  5.290e-003+ 2.000*( 9.266e-002* 3.270e-003*cos(t)+ 9.957e-001* 1.810e-003*sin(t)),  1.570e-002 +2.000*(-9.957e-001* 3.270e-003*cos(t)+ 9.266e-002* 1.810e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.424e-002, 3.074e-002 center
replot  1.424e-002+ 2.000*( 1.992e-001* 4.809e-003*cos(t)+ 9.800e-001* 3.349e-003*sin(t)),  3.074e-002 +2.000*(-9.800e-001* 4.809e-003*cos(t)+ 1.992e-001* 3.349e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.779e-002, 5.929e-002 center
replot  3.779e-002+ 2.000*( 2.794e-001* 8.611e-003*cos(t)+ 9.602e-001* 5.981e-003*sin(t)),  5.929e-002 +2.000*(-9.602e-001* 8.611e-003*cos(t)+ 2.794e-001* 5.981e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  9.701e-002, 1.107e-001 center
replot  9.701e-002+ 2.000*( 4.373e-001* 2.034e-002*cos(t)+ 8.993e-001* 1.463e-002*sin(t)),  1.107e-001 +2.000*(-8.993e-001* 2.034e-002*cos(t)+ 4.373e-001* 1.463e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  2.323e-001, 1.927e-001 center
replot  2.323e-001+ 2.000*( 8.378e-001* 5.662e-002*cos(t)+ 5.460e-001* 3.806e-002*sin(t)),  1.927e-001 +2.000*(-5.460e-001* 5.662e-002*cos(t)+ 8.378e-001* 3.806e-002*sin(t)) not
set out;
set out "GRFadl/VARPIJGR_GRFadl_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "GRFadl/VARPIJGR_GRFadl_121-12.svg"
set label "50" at  2.102e-001, 1.028e-003 center
# Age 50, p21 - p12
plot [-pi:pi]  2.102e-001+ 2.000*( 1.000e+000* 9.503e-002*cos(t)+-8.962e-004* 5.350e-004*sin(t)),  1.028e-003 +2.000*( 8.962e-004* 9.503e-002*cos(t)+ 1.000e+000* 5.350e-004*sin(t)) not
# Age 55, p21 - p12
set label "55" at  2.101e-001, 2.037e-003 center
replot  2.101e-001+ 2.000*( 1.000e+000* 7.935e-002*cos(t)+-1.722e-003* 8.896e-004*sin(t)),  2.037e-003 +2.000*( 1.722e-003* 7.935e-002*cos(t)+ 1.000e+000* 8.896e-004*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.096e-001, 4.031e-003 center
replot  2.096e-001+ 2.000*( 1.000e+000* 6.419e-002*cos(t)+-3.274e-003* 1.431e-003*sin(t)),  4.031e-003 +2.000*( 3.274e-003* 6.419e-002*cos(t)+ 1.000e+000* 1.431e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.084e-001, 7.967e-003 center
replot  2.084e-001+ 2.000*( 1.000e+000* 5.010e-002*cos(t)+-6.175e-003* 2.204e-003*sin(t)),  7.967e-003 +2.000*( 6.175e-003* 5.010e-002*cos(t)+ 1.000e+000* 2.204e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.065e-001, 1.570e-002 center
replot  2.065e-001+ 2.000*( 9.999e-001* 3.834e-002*cos(t)+-1.195e-002* 3.228e-003*sin(t)),  1.570e-002 +2.000*( 1.195e-002* 3.834e-002*cos(t)+ 9.999e-001* 3.228e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.033e-001, 3.074e-002 center
replot  2.033e-001+ 2.000*( 9.996e-001* 3.145e-002*cos(t)+-2.650e-002* 4.688e-003*sin(t)),  3.074e-002 +2.000*( 2.650e-002* 3.145e-002*cos(t)+ 9.996e-001* 4.688e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.984e-001, 5.929e-002 center
replot  1.984e-001+ 2.000*( 9.979e-001* 3.217e-002*cos(t)+-6.451e-002* 8.193e-003*sin(t)),  5.929e-002 +2.000*( 6.451e-002* 3.217e-002*cos(t)+ 9.979e-001* 8.193e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.912e-001, 1.107e-001 center
replot  1.912e-001+ 2.000*( 9.885e-001* 3.936e-002*cos(t)+-1.509e-001* 1.866e-002*sin(t)),  1.107e-001 +2.000*( 1.509e-001* 3.936e-002*cos(t)+ 9.885e-001* 1.866e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.810e-001, 1.927e-001 center
replot  1.810e-001+ 2.000*( 8.338e-001* 5.120e-002*cos(t)+-5.521e-001* 4.108e-002*sin(t)),  1.927e-001 +2.000*( 5.521e-001* 5.120e-002*cos(t)+ 8.338e-001* 4.108e-002*sin(t)) not
set out;
set out "GRFadl/VARPIJGR_GRFadl_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "GRFadl/VARPIJGR_GRFadl_123-12.svg"
set label "50" at  1.447e-002, 1.028e-003 center
# Age 50, p23 - p12
plot [-pi:pi]  1.447e-002+ 2.000*( 1.000e+000* 1.216e-002*cos(t)+-4.451e-003* 5.391e-004*sin(t)),  1.028e-003 +2.000*( 4.451e-003* 1.216e-002*cos(t)+ 1.000e+000* 5.391e-004*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.179e-002, 2.037e-003 center
replot  2.179e-002+ 2.000*( 1.000e+000* 1.559e-002*cos(t)+-5.723e-003* 8.956e-004*sin(t)),  2.037e-003 +2.000*( 5.723e-003* 1.559e-002*cos(t)+ 1.000e+000* 8.956e-004*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.275e-002, 4.031e-003 center
replot  3.275e-002+ 2.000*( 1.000e+000* 1.938e-002*cos(t)+-7.377e-003* 1.439e-003*sin(t)),  4.031e-003 +2.000*( 7.377e-003* 1.938e-002*cos(t)+ 1.000e+000* 1.439e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  4.909e-002, 7.967e-003 center
replot  4.909e-002+ 2.000*( 1.000e+000* 2.309e-002*cos(t)+-9.656e-003* 2.214e-003*sin(t)),  7.967e-003 +2.000*( 9.656e-003* 2.309e-002*cos(t)+ 1.000e+000* 2.214e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  7.328e-002, 1.570e-002 center
replot  7.328e-002+ 2.000*( 9.999e-001* 2.593e-002*cos(t)+-1.344e-002* 3.242e-003*sin(t)),  1.570e-002 +2.000*( 1.344e-002* 2.593e-002*cos(t)+ 9.999e-001* 3.242e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.087e-001, 3.074e-002 center
replot  1.087e-001+ 2.000*( 9.997e-001* 2.703e-002*cos(t)+-2.309e-002* 4.720e-003*sin(t)),  3.074e-002 +2.000*( 2.309e-002* 2.703e-002*cos(t)+ 9.997e-001* 4.720e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.599e-001, 5.929e-002 center
replot  1.599e-001+ 2.000*( 9.982e-001* 2.764e-002*cos(t)+-6.036e-002* 8.284e-003*sin(t)),  5.929e-002 +2.000*( 6.036e-002* 2.764e-002*cos(t)+ 9.982e-001* 8.284e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  2.321e-001, 1.107e-001 center
replot  2.321e-001+ 2.000*( 9.886e-001* 3.768e-002*cos(t)+-1.508e-001* 1.874e-002*sin(t)),  1.107e-001 +2.000*( 1.508e-001* 3.768e-002*cos(t)+ 9.886e-001* 1.874e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  3.312e-001, 1.927e-001 center
replot  3.312e-001+ 2.000*( 9.757e-001* 7.042e-002*cos(t)+-2.189e-001* 4.268e-002*sin(t)),  1.927e-001 +2.000*( 2.189e-001* 7.042e-002*cos(t)+ 9.757e-001* 4.268e-002*sin(t)) not
set out;
set out "GRFadl/VARPIJGR_GRFadl_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "GRFadl/VARPIJGR_GRFadl_121-13.svg"
set label "50" at  2.102e-001, 9.683e-005 center
# Age 50, p21 - p13
plot [-pi:pi]  2.102e-001+ 2.000*( 1.000e+000* 9.503e-002*cos(t)+-2.803e-005* 7.973e-005*sin(t)),  9.683e-005 +2.000*( 2.803e-005* 9.503e-002*cos(t)+ 1.000e+000* 7.973e-005*sin(t)) not
# Age 55, p21 - p13
set label "55" at  2.101e-001, 2.638e-004 center
replot  2.101e-001+ 2.000*( 1.000e+000* 7.935e-002*cos(t)+-6.909e-005* 1.849e-004*sin(t)),  2.638e-004 +2.000*( 6.909e-005* 7.935e-002*cos(t)+ 1.000e+000* 1.849e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.096e-001, 7.180e-004 center
replot  2.096e-001+ 2.000*( 1.000e+000* 6.419e-002*cos(t)+-1.592e-004* 4.165e-004*sin(t)),  7.180e-004 +2.000*( 1.592e-004* 6.419e-002*cos(t)+ 1.000e+000* 4.165e-004*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.084e-001, 1.952e-003 center
replot  2.084e-001+ 2.000*( 1.000e+000* 5.010e-002*cos(t)+-3.140e-004* 8.994e-004*sin(t)),  1.952e-003 +2.000*( 3.140e-004* 5.010e-002*cos(t)+ 1.000e+000* 8.994e-004*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.065e-001, 5.290e-003 center
replot  2.065e-001+ 2.000*( 1.000e+000* 3.833e-002*cos(t)+-4.262e-004* 1.827e-003*sin(t)),  5.290e-003 +2.000*( 4.262e-004* 3.833e-002*cos(t)+ 1.000e+000* 1.827e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.033e-001, 1.424e-002 center
replot  2.033e-001+ 2.000*( 1.000e+000* 3.144e-002*cos(t)+-8.851e-004* 3.418e-003*sin(t)),  1.424e-002 +2.000*( 8.851e-004* 3.144e-002*cos(t)+ 1.000e+000* 3.418e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.984e-001, 3.779e-002 center
replot  1.984e-001+ 2.000*( 1.000e+000* 3.211e-002*cos(t)+-9.186e-003* 6.220e-003*sin(t)),  3.779e-002 +2.000*( 9.186e-003* 3.211e-002*cos(t)+ 1.000e+000* 6.220e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.912e-001, 9.701e-002 center
replot  1.912e-001+ 2.000*( 9.987e-001* 3.905e-002*cos(t)+-5.037e-002* 1.578e-002*sin(t)),  9.701e-002 +2.000*( 5.037e-002* 3.905e-002*cos(t)+ 9.987e-001* 1.578e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.810e-001, 2.323e-001 center
replot  1.810e-001+ 2.000*( 4.968e-001* 5.338e-002*cos(t)+-8.679e-001* 4.657e-002*sin(t)),  2.323e-001 +2.000*( 8.679e-001* 5.338e-002*cos(t)+ 4.968e-001* 4.657e-002*sin(t)) not
set out;
set out "GRFadl/VARPIJGR_GRFadl_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "GRFadl/VARPIJGR_GRFadl_123-13.svg"
set label "50" at  1.447e-002, 9.683e-005 center
# Age 50, p23 - p13
plot [-pi:pi]  1.447e-002+ 2.000*( 1.000e+000* 1.216e-002*cos(t)+ 1.294e-003* 7.821e-005*sin(t)),  9.683e-005 +2.000*(-1.294e-003* 1.216e-002*cos(t)+ 1.000e+000* 7.821e-005*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.179e-002, 2.638e-004 center
replot  2.179e-002+ 2.000*( 1.000e+000* 1.559e-002*cos(t)+ 2.312e-003* 1.815e-004*sin(t)),  2.638e-004 +2.000*(-2.312e-003* 1.559e-002*cos(t)+ 1.000e+000* 1.815e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.275e-002, 7.180e-004 center
replot  3.275e-002+ 2.000*( 1.000e+000* 1.938e-002*cos(t)+ 4.125e-003* 4.089e-004*sin(t)),  7.180e-004 +2.000*(-4.125e-003* 1.938e-002*cos(t)+ 1.000e+000* 4.089e-004*sin(t)) not
# Age 65, p23 - p13
set label "65" at  4.909e-002, 1.952e-003 center
replot  4.909e-002+ 2.000*( 1.000e+000* 2.309e-002*cos(t)+ 7.349e-003* 8.834e-004*sin(t)),  1.952e-003 +2.000*(-7.349e-003* 2.309e-002*cos(t)+ 1.000e+000* 8.834e-004*sin(t)) not
# Age 70, p23 - p13
set label "70" at  7.328e-002, 5.290e-003 center
replot  7.328e-002+ 2.000*( 9.999e-001* 2.593e-002*cos(t)+ 1.315e-002* 1.796e-003*sin(t)),  5.290e-003 +2.000*(-1.315e-002* 2.593e-002*cos(t)+ 9.999e-001* 1.796e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.087e-001, 1.424e-002 center
replot  1.087e-001+ 2.000*( 9.997e-001* 2.703e-002*cos(t)+ 2.451e-002* 3.355e-003*sin(t)),  1.424e-002 +2.000*(-2.451e-002* 2.703e-002*cos(t)+ 9.997e-001* 3.355e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.599e-001, 3.779e-002 center
replot  1.599e-001+ 2.000*( 9.984e-001* 2.764e-002*cos(t)+ 5.622e-002* 6.039e-003*sin(t)),  3.779e-002 +2.000*(-5.622e-002* 2.764e-002*cos(t)+ 9.984e-001* 6.039e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  2.321e-001, 9.701e-002 center
replot  2.321e-001+ 2.000*( 9.876e-001* 3.775e-002*cos(t)+ 1.569e-001* 1.492e-002*sin(t)),  9.701e-002 +2.000*(-1.569e-001* 3.775e-002*cos(t)+ 9.876e-001* 1.492e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  3.312e-001, 2.323e-001 center
replot  3.312e-001+ 2.000*( 9.196e-001* 7.269e-002*cos(t)+ 3.929e-001* 4.698e-002*sin(t)),  2.323e-001 +2.000*(-3.929e-001* 7.269e-002*cos(t)+ 9.196e-001* 4.698e-002*sin(t)) not
set out;
set out "GRFadl/VARPIJGR_GRFadl_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "GRFadl/VARPIJGR_GRFadl_123-21.svg"
set label "50" at  1.447e-002, 2.102e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.447e-002+ 2.000*( 3.486e-003* 9.503e-002*cos(t)+ 1.000e+000* 1.216e-002*sin(t)),  2.102e-001 +2.000*(-1.000e+000* 9.503e-002*cos(t)+ 3.486e-003* 1.216e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.179e-002, 2.101e-001 center
replot  2.179e-002+ 2.000*( 6.269e-003* 7.936e-002*cos(t)+ 1.000e+000* 1.559e-002*sin(t)),  2.101e-001 +2.000*(-1.000e+000* 7.936e-002*cos(t)+ 6.269e-003* 1.559e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.275e-002, 2.096e-001 center
replot  3.275e-002+ 2.000*( 1.234e-002* 6.419e-002*cos(t)+ 9.999e-001* 1.937e-002*sin(t)),  2.096e-001 +2.000*(-9.999e-001* 6.419e-002*cos(t)+ 1.234e-002* 1.937e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  4.909e-002, 2.084e-001 center
replot  4.909e-002+ 2.000*( 2.777e-002* 5.011e-002*cos(t)+ 9.996e-001* 2.306e-002*sin(t)),  2.084e-001 +2.000*(-9.996e-001* 5.011e-002*cos(t)+ 2.777e-002* 2.306e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  7.328e-002, 2.065e-001 center
replot  7.328e-002+ 2.000*( 7.740e-002* 3.840e-002*cos(t)+ 9.970e-001* 2.583e-002*sin(t)),  2.065e-001 +2.000*(-9.970e-001* 3.840e-002*cos(t)+ 7.740e-002* 2.583e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.087e-001, 2.033e-001 center
replot  1.087e-001+ 2.000*( 2.419e-001* 3.171e-002*cos(t)+ 9.703e-001* 2.671e-002*sin(t)),  2.033e-001 +2.000*(-9.703e-001* 3.171e-002*cos(t)+ 2.419e-001* 2.671e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.599e-001, 1.984e-001 center
replot  1.599e-001+ 2.000*( 2.995e-001* 3.257e-002*cos(t)+ 9.541e-001* 2.706e-002*sin(t)),  1.984e-001 +2.000*(-9.541e-001* 3.257e-002*cos(t)+ 2.995e-001* 2.706e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  2.321e-001, 1.912e-001 center
replot  2.321e-001+ 2.000*( 6.060e-001* 4.118e-002*cos(t)+ 7.955e-001* 3.495e-002*sin(t)),  1.912e-001 +2.000*(-7.955e-001* 4.118e-002*cos(t)+ 6.060e-001* 3.495e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  3.312e-001, 1.810e-001 center
replot  3.312e-001+ 2.000*( 9.643e-001* 7.079e-002*cos(t)+ 2.648e-001* 4.621e-002*sin(t)),  1.810e-001 +2.000*(-2.648e-001* 7.079e-002*cos(t)+ 9.643e-001* 4.621e-002*sin(t)) not
set out;
set out "GRFadl/VARPIJGR_GRFadl_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "GRFadl/VARMUPTJGR--STABLBASED_GRFadl1.svg";
 plot "GRFadl/PRMORPREV-1-STABLBASED_GRFadl.txt"  u 1:($3) not w l lt 1 
 replot "GRFadl/PRMORPREV-1-STABLBASED_GRFadl.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "GRFadl/PRMORPREV-1-STABLBASED_GRFadl.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "GRFadl/VARMUPTJGR--STABLBASED_GRFadl1.svg";replot;set out;
