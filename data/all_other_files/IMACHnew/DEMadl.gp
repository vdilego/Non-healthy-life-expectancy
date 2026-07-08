
# IMaCh-0.99r45
# DEMadl.gp
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


set ter svg size 640, 480;set out "DEMadl/D_DEMadl_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "DEMadl/ILK_DEMadl-dest.png";
set log y;plot  "DEMadl/ILK_DEMadl.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "DEMadl/ILK_DEMadl-ori.png";
set log y;plot  "DEMadl/ILK_DEMadl.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "DEMadl/ILK_DEMadl-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "DEMadl/ILK_DEMadl.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "DEMadl/ILK_DEMadl-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "DEMadl/ILK_DEMadl.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "DEMadl/V_DEMadl_1-1-1.svg" 

#set out "V_DEMadl_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "DEMadl/VPL_DEMadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"DEMadl/VPL_DEMadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"DEMadl/VPL_DEMadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"DEMadl/P_DEMadl.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "DEMadl/V_DEMadl_2-1-1.svg" 

#set out "V_DEMadl_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "DEMadl/VPL_DEMadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"DEMadl/VPL_DEMadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"DEMadl/VPL_DEMadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"DEMadl/P_DEMadl.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "DEMadl/E_DEMadl_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "DEMadl/T_DEMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"DEMadl/T_DEMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"DEMadl/T_DEMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"DEMadl/T_DEMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"DEMadl/T_DEMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"DEMadl/T_DEMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"DEMadl/T_DEMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"DEMadl/T_DEMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"DEMadl/T_DEMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "DEMadl/E_DEMadl_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "DEMadl/EXP_DEMadl_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "DEMadl/E_DEMadl.txt" every :::0::0 u 1:2 t "e11" w l ,"DEMadl/E_DEMadl.txt" every :::0::0 u 1:3 t "e12" w l ,"DEMadl/E_DEMadl.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "DEMadl/EXP_DEMadl_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "DEMadl/E_DEMadl.txt" every :::0::0 u 1:5 t "e21" w l ,"DEMadl/E_DEMadl.txt" every :::0::0 u 1:6 t "e22" w l ,"DEMadl/E_DEMadl.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "DEMadl/LIJ_DEMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEMadl/PIJ_DEMadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "DEMadl/LIJ_DEMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEMadl/PIJ_DEMadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "DEMadl/LIJT_DEMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEMadl/PIJ_DEMadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "DEMadl/LIJT_DEMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEMadl/PIJ_DEMadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "DEMadl/P_DEMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEMadl/PIJ_DEMadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "DEMadl/P_DEMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEMadl/PIJ_DEMadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-8.011261; p2=0.062974; 
#   current state 3
p3=-4.450613; p4=-0.010452; 
# initial state 2
#   current state 1
p5=1.831910; p6=-0.057940; 
#   current state 3
p7=-10.881216; p8=0.111019; 
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

set out "DEMadl/PE_DEMadl_1-1-1.svg" 
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

set out "DEMadl/PE_DEMadl_1-2-1.svg" 
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

set out "DEMadl/PE_DEMadl_1-3-1.svg" 
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
set out "DEMadl/VARPIJGR_DEMadl_113-12.svg"
set label "50" at  1.364e-002, 1.524e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  1.364e-002+ 2.000*( 9.939e-001* 5.720e-003*cos(t)+ 1.107e-001* 3.775e-003*sin(t)),  1.524e-002 +2.000*(-1.107e-001* 5.720e-003*cos(t)+ 9.939e-001* 3.775e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.292e-002, 2.083e-002 center
replot  1.292e-002+ 2.000*( 2.815e-001* 4.234e-003*cos(t)+ 9.596e-001* 3.724e-003*sin(t)),  2.083e-002 +2.000*(-9.596e-001* 4.234e-003*cos(t)+ 2.815e-001* 3.724e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.221e-002, 2.843e-002 center
replot  1.221e-002+ 2.000*( 5.220e-002* 4.482e-003*cos(t)+ 9.986e-001* 2.551e-003*sin(t)),  2.843e-002 +2.000*(-9.986e-001* 4.482e-003*cos(t)+ 5.220e-002* 2.551e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.154e-002, 3.876e-002 center
replot  1.154e-002+ 2.000*( 1.019e-001* 4.749e-003*cos(t)+ 9.948e-001* 2.578e-003*sin(t)),  3.876e-002 +2.000*(-9.948e-001* 4.749e-003*cos(t)+ 1.019e-001* 2.578e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.087e-002, 5.275e-002 center
replot  1.087e-002+ 2.000*( 2.594e-001* 5.594e-003*cos(t)+ 9.658e-001* 3.367e-003*sin(t)),  5.275e-002 +2.000*(-9.658e-001* 5.594e-003*cos(t)+ 2.594e-001* 3.367e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.022e-002, 7.159e-002 center
replot  1.022e-002+ 2.000*( 2.774e-001* 8.132e-003*cos(t)+ 9.607e-001* 4.304e-003*sin(t)),  7.159e-002 +2.000*(-9.607e-001* 8.132e-003*cos(t)+ 2.774e-001* 4.304e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  9.578e-003, 9.683e-002 center
replot  9.578e-003+ 2.000*( 1.818e-001* 1.346e-002*cos(t)+ 9.833e-001* 5.350e-003*sin(t)),  9.683e-002 +2.000*(-9.833e-001* 1.346e-002*cos(t)+ 1.818e-001* 5.350e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  8.933e-003, 1.304e-001 center
replot  8.933e-003+ 2.000*( 1.108e-001* 2.269e-002*cos(t)+ 9.938e-001* 6.308e-003*sin(t)),  1.304e-001 +2.000*(-9.938e-001* 2.269e-002*cos(t)+ 1.108e-001* 6.308e-003*sin(t)) not
# Age 90, p13 - p12
set label "90" at  8.280e-003, 1.744e-001 center
replot  8.280e-003+ 2.000*( 7.015e-002* 3.697e-002*cos(t)+ 9.975e-001* 7.090e-003*sin(t)),  1.744e-001 +2.000*(-9.975e-001* 3.697e-002*cos(t)+ 7.015e-002* 7.090e-003*sin(t)) not
set out;
set out "DEMadl/VARPIJGR_DEMadl_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "DEMadl/VARPIJGR_DEMadl_121-12.svg"
set label "50" at  5.108e-001, 1.524e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  5.108e-001+ 2.000*( 1.000e+000* 1.241e-001*cos(t)+-7.012e-003* 3.704e-003*sin(t)),  1.524e-002 +2.000*( 7.012e-003* 1.241e-001*cos(t)+ 1.000e+000* 3.704e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  4.074e-001, 2.083e-002 center
replot  4.074e-001+ 2.000*( 9.999e-001* 8.301e-002*cos(t)+-1.193e-002* 4.078e-003*sin(t)),  2.083e-002 +2.000*( 1.193e-002* 8.301e-002*cos(t)+ 9.999e-001* 4.078e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.198e-001, 2.843e-002 center
replot  3.198e-001+ 2.000*( 9.998e-001* 5.287e-002*cos(t)+-2.059e-002* 4.344e-003*sin(t)),  2.843e-002 +2.000*( 2.059e-002* 5.287e-002*cos(t)+ 9.998e-001* 4.344e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.470e-001, 3.876e-002 center
replot  2.470e-001+ 2.000*( 9.995e-001* 3.506e-002*cos(t)+-3.223e-002* 4.597e-003*sin(t)),  3.876e-002 +2.000*( 3.223e-002* 3.506e-002*cos(t)+ 9.995e-001* 4.597e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  1.877e-001, 5.275e-002 center
replot  1.877e-001+ 2.000*( 9.992e-001* 2.838e-002*cos(t)+-4.117e-002* 5.351e-003*sin(t)),  5.275e-002 +2.000*( 4.117e-002* 2.838e-002*cos(t)+ 9.992e-001* 5.351e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.398e-001, 7.159e-002 center
replot  1.398e-001+ 2.000*( 9.983e-001* 2.715e-002*cos(t)+-5.795e-002* 7.759e-003*sin(t)),  7.159e-002 +2.000*( 5.795e-002* 2.715e-002*cos(t)+ 9.983e-001* 7.759e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.014e-001, 9.683e-002 center
replot  1.014e-001+ 2.000*( 9.931e-001* 2.615e-002*cos(t)+-1.176e-001* 1.300e-002*sin(t)),  9.683e-002 +2.000*( 1.176e-001* 2.615e-002*cos(t)+ 9.931e-001* 1.300e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  7.082e-002, 1.304e-001 center
replot  7.082e-002+ 2.000*( 7.759e-001* 2.489e-002*cos(t)+-6.309e-001* 2.087e-002*sin(t)),  1.304e-001 +2.000*( 6.309e-001* 2.489e-002*cos(t)+ 7.759e-001* 2.087e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  4.700e-002, 1.744e-001 center
replot  4.700e-002+ 2.000*( 1.181e-001* 3.707e-002*cos(t)+-9.930e-001* 1.899e-002*sin(t)),  1.744e-001 +2.000*( 9.930e-001* 3.707e-002*cos(t)+ 1.181e-001* 1.899e-002*sin(t)) not
set out;
set out "DEMadl/VARPIJGR_DEMadl_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "DEMadl/VARPIJGR_DEMadl_123-12.svg"
set label "50" at  7.177e-003, 1.524e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  7.177e-003+ 2.000*( 9.977e-001* 5.135e-003*cos(t)+-6.803e-002* 3.797e-003*sin(t)),  1.524e-002 +2.000*( 6.803e-002* 5.135e-003*cos(t)+ 9.977e-001* 3.797e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.332e-002, 2.083e-002 center
replot  1.332e-002+ 2.000*( 9.991e-001* 8.031e-003*cos(t)+-4.143e-002* 4.186e-003*sin(t)),  2.083e-002 +2.000*( 4.143e-002* 8.031e-003*cos(t)+ 9.991e-001* 4.186e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  2.434e-002, 2.843e-002 center
replot  2.434e-002+ 2.000*( 9.994e-001* 1.199e-002*cos(t)+-3.423e-002* 4.462e-003*sin(t)),  2.843e-002 +2.000*( 3.423e-002* 1.199e-002*cos(t)+ 9.994e-001* 4.462e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  4.376e-002, 3.876e-002 center
replot  4.376e-002+ 2.000*( 9.995e-001* 1.688e-002*cos(t)+-3.299e-002* 4.701e-003*sin(t)),  3.876e-002 +2.000*( 3.299e-002* 1.688e-002*cos(t)+ 9.995e-001* 4.701e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  7.739e-002, 5.275e-002 center
replot  7.739e-002+ 2.000*( 9.993e-001* 2.205e-002*cos(t)+-3.772e-002* 5.413e-003*sin(t)),  5.275e-002 +2.000*( 3.772e-002* 2.205e-002*cos(t)+ 9.993e-001* 5.413e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.341e-001, 7.159e-002 center
replot  1.341e-001+ 2.000*( 9.986e-001* 2.666e-002*cos(t)+-5.334e-002* 7.786e-003*sin(t)),  7.159e-002 +2.000*( 5.334e-002* 2.666e-002*cos(t)+ 9.986e-001* 7.786e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  2.264e-001, 9.683e-002 center
replot  2.264e-001+ 2.000*( 9.971e-001* 3.366e-002*cos(t)+-7.624e-002* 1.306e-002*sin(t)),  9.683e-002 +2.000*( 7.624e-002* 3.366e-002*cos(t)+ 9.971e-001* 1.306e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  3.682e-001, 1.304e-001 center
replot  3.682e-001+ 2.000*( 9.983e-001* 5.688e-002*cos(t)+-5.911e-002* 2.234e-002*sin(t)),  1.304e-001 +2.000*( 5.911e-002* 5.688e-002*cos(t)+ 9.983e-001* 2.234e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  5.688e-001, 1.744e-001 center
replot  5.688e-001+ 2.000*( 9.994e-001* 1.067e-001*cos(t)+-3.498e-002* 3.671e-002*sin(t)),  1.744e-001 +2.000*( 3.498e-002* 1.067e-001*cos(t)+ 9.994e-001* 3.671e-002*sin(t)) not
set out;
set out "DEMadl/VARPIJGR_DEMadl_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "DEMadl/VARPIJGR_DEMadl_121-13.svg"
set label "50" at  5.108e-001, 1.364e-002 center
# Age 50, p21 - p13
plot [-pi:pi]  5.108e-001+ 2.000*( 1.000e+000* 1.241e-001*cos(t)+-7.495e-004* 5.699e-003*sin(t)),  1.364e-002 +2.000*( 7.495e-004* 1.241e-001*cos(t)+ 1.000e+000* 5.699e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  4.074e-001, 1.292e-002 center
replot  4.074e-001+ 2.000*( 1.000e+000* 8.300e-002*cos(t)+-9.455e-004* 3.766e-003*sin(t)),  1.292e-002 +2.000*( 9.455e-004* 8.300e-002*cos(t)+ 1.000e+000* 3.766e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.198e-001, 1.221e-002 center
replot  3.198e-001+ 2.000*( 1.000e+000* 5.286e-002*cos(t)+-1.295e-003* 2.558e-003*sin(t)),  1.221e-002 +2.000*( 1.295e-003* 5.286e-002*cos(t)+ 1.000e+000* 2.558e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.470e-001, 1.154e-002 center
replot  2.470e-001+ 2.000*( 1.000e+000* 3.504e-002*cos(t)+-1.905e-003* 2.609e-003*sin(t)),  1.154e-002 +2.000*( 1.905e-003* 3.504e-002*cos(t)+ 1.000e+000* 2.609e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  1.877e-001, 1.087e-002 center
replot  1.877e-001+ 2.000*( 1.000e+000* 2.836e-002*cos(t)+-2.695e-003* 3.560e-003*sin(t)),  1.087e-002 +2.000*( 2.695e-003* 2.836e-002*cos(t)+ 1.000e+000* 3.560e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.398e-001, 1.022e-002 center
replot  1.398e-001+ 2.000*( 1.000e+000* 2.711e-002*cos(t)+-3.624e-003* 4.710e-003*sin(t)),  1.022e-002 +2.000*( 3.624e-003* 2.711e-002*cos(t)+ 1.000e+000* 4.710e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.014e-001, 9.578e-003 center
replot  1.014e-001+ 2.000*( 1.000e+000* 2.602e-002*cos(t)+-5.091e-003* 5.800e-003*sin(t)),  9.578e-003 +2.000*( 5.091e-003* 2.602e-002*cos(t)+ 1.000e+000* 5.800e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  7.082e-002, 8.933e-003 center
replot  7.082e-002+ 2.000*( 1.000e+000* 2.337e-002*cos(t)+-7.647e-003* 6.752e-003*sin(t)),  8.933e-003 +2.000*( 7.647e-003* 2.337e-002*cos(t)+ 1.000e+000* 6.752e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  4.700e-002, 8.280e-003 center
replot  4.700e-002+ 2.000*( 9.999e-001* 1.936e-002*cos(t)+-1.230e-002* 7.530e-003*sin(t)),  8.280e-003 +2.000*( 1.230e-002* 1.936e-002*cos(t)+ 9.999e-001* 7.530e-003*sin(t)) not
set out;
set out "DEMadl/VARPIJGR_DEMadl_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "DEMadl/VARPIJGR_DEMadl_123-13.svg"
set label "50" at  7.177e-003, 1.364e-002 center
# Age 50, p23 - p13
plot [-pi:pi]  7.177e-003+ 2.000*( 1.440e-001* 5.712e-003*cos(t)+ 9.896e-001* 5.116e-003*sin(t)),  1.364e-002 +2.000*(-9.896e-001* 5.712e-003*cos(t)+ 1.440e-001* 5.116e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.332e-002, 1.292e-002 center
replot  1.332e-002+ 2.000*( 9.988e-001* 8.034e-003*cos(t)+ 4.907e-002* 3.751e-003*sin(t)),  1.292e-002 +2.000*(-4.907e-002* 8.034e-003*cos(t)+ 9.988e-001* 3.751e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  2.434e-002, 1.221e-002 center
replot  2.434e-002+ 2.000*( 9.992e-001* 1.199e-002*cos(t)+ 4.113e-002* 2.513e-003*sin(t)),  1.221e-002 +2.000*(-4.113e-002* 1.199e-002*cos(t)+ 9.992e-001* 2.513e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  4.376e-002, 1.154e-002 center
replot  4.376e-002+ 2.000*( 9.991e-001* 1.689e-002*cos(t)+ 4.204e-002* 2.514e-003*sin(t)),  1.154e-002 +2.000*(-4.204e-002* 1.689e-002*cos(t)+ 9.991e-001* 2.514e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  7.739e-002, 1.087e-002 center
replot  7.739e-002+ 2.000*( 9.989e-001* 2.206e-002*cos(t)+ 4.749e-002* 3.407e-003*sin(t)),  1.087e-002 +2.000*(-4.749e-002* 2.206e-002*cos(t)+ 9.989e-001* 3.407e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.341e-001, 1.022e-002 center
replot  1.341e-001+ 2.000*( 9.983e-001* 2.667e-002*cos(t)+ 5.863e-002* 4.451e-003*sin(t)),  1.022e-002 +2.000*(-5.863e-002* 2.667e-002*cos(t)+ 9.983e-001* 4.451e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  2.264e-001, 9.578e-003 center
replot  2.264e-001+ 2.000*( 9.981e-001* 3.364e-002*cos(t)+ 6.136e-002* 5.433e-003*sin(t)),  9.578e-003 +2.000*(-6.136e-002* 3.364e-002*cos(t)+ 9.981e-001* 5.433e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  3.682e-001, 8.933e-003 center
replot  3.682e-001+ 2.000*( 9.995e-001* 5.682e-002*cos(t)+ 3.220e-002* 6.505e-003*sin(t)),  8.933e-003 +2.000*(-3.220e-002* 5.682e-002*cos(t)+ 9.995e-001* 6.505e-003*sin(t)) not
# Age 90, p23 - p13
set label "90" at  5.688e-001, 8.280e-003 center
replot  5.688e-001+ 2.000*( 9.999e-001* 1.066e-001*cos(t)+ 1.223e-002* 7.420e-003*sin(t)),  8.280e-003 +2.000*(-1.223e-002* 1.066e-001*cos(t)+ 9.999e-001* 7.420e-003*sin(t)) not
set out;
set out "DEMadl/VARPIJGR_DEMadl_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "DEMadl/VARPIJGR_DEMadl_123-21.svg"
set label "50" at  7.177e-003, 5.108e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  7.177e-003+ 2.000*( 5.043e-003* 1.241e-001*cos(t)+ 1.000e+000* 5.091e-003*sin(t)),  5.108e-001 +2.000*(-1.000e+000* 1.241e-001*cos(t)+ 5.043e-003* 5.091e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.332e-002, 4.074e-001 center
replot  1.332e-002+ 2.000*( 9.761e-003* 8.301e-002*cos(t)+ 1.000e+000* 7.986e-003*sin(t)),  4.074e-001 +2.000*(-1.000e+000* 8.301e-002*cos(t)+ 9.761e-003* 7.986e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  2.434e-002, 3.198e-001 center
replot  2.434e-002+ 2.000*( 2.156e-002* 5.287e-002*cos(t)+ 9.998e-001* 1.193e-002*sin(t)),  3.198e-001 +2.000*(-9.998e-001* 5.287e-002*cos(t)+ 2.156e-002* 1.193e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  4.376e-002, 2.470e-001 center
replot  4.376e-002+ 2.000*( 5.711e-002* 3.508e-002*cos(t)+ 9.984e-001* 1.678e-002*sin(t)),  2.470e-001 +2.000*(-9.984e-001* 3.508e-002*cos(t)+ 5.711e-002* 1.678e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  7.739e-002, 1.877e-001 center
replot  7.739e-002+ 2.000*( 1.697e-001* 2.853e-002*cos(t)+ 9.855e-001* 2.181e-002*sin(t)),  1.877e-001 +2.000*(-9.855e-001* 2.853e-002*cos(t)+ 1.697e-001* 2.181e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.341e-001, 1.398e-001 center
replot  1.341e-001+ 2.000*( 6.268e-001* 2.796e-002*cos(t)+ 7.792e-001* 2.573e-002*sin(t)),  1.398e-001 +2.000*(-7.792e-001* 2.796e-002*cos(t)+ 6.268e-001* 2.573e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  2.264e-001, 1.014e-001 center
replot  2.264e-001+ 2.000*( 9.903e-001* 3.371e-002*cos(t)+ 1.392e-001* 2.584e-002*sin(t)),  1.014e-001 +2.000*(-1.392e-001* 3.371e-002*cos(t)+ 9.903e-001* 2.584e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  3.682e-001, 7.082e-002 center
replot  3.682e-001+ 2.000*( 9.989e-001* 5.685e-002*cos(t)+ 4.711e-002* 2.325e-002*sin(t)),  7.082e-002 +2.000*(-4.711e-002* 5.685e-002*cos(t)+ 9.989e-001* 2.325e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  5.688e-001, 4.700e-002 center
replot  5.688e-001+ 2.000*( 9.995e-001* 1.067e-001*cos(t)+ 3.079e-002* 1.908e-002*sin(t)),  4.700e-002 +2.000*(-3.079e-002* 1.067e-001*cos(t)+ 9.995e-001* 1.908e-002*sin(t)) not
set out;
set out "DEMadl/VARPIJGR_DEMadl_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "DEMadl/VARMUPTJGR--STABLBASED_DEMadl1.svg";
 plot "DEMadl/PRMORPREV-1-STABLBASED_DEMadl.txt"  u 1:($3) not w l lt 1 
 replot "DEMadl/PRMORPREV-1-STABLBASED_DEMadl.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "DEMadl/PRMORPREV-1-STABLBASED_DEMadl.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "DEMadl/VARMUPTJGR--STABLBASED_DEMadl1.svg";replot;set out;
