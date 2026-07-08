
# IMaCh-0.99r45
# GRMadl.gp
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


set ter svg size 640, 480;set out "GRMadl/D_GRMadl_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "GRMadl/ILK_GRMadl-dest.png";
set log y;plot  "GRMadl/ILK_GRMadl.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "GRMadl/ILK_GRMadl-ori.png";
set log y;plot  "GRMadl/ILK_GRMadl.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "GRMadl/ILK_GRMadl-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "GRMadl/ILK_GRMadl.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "GRMadl/ILK_GRMadl-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "GRMadl/ILK_GRMadl.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "GRMadl/V_GRMadl_1-1-1.svg" 

#set out "V_GRMadl_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "GRMadl/VPL_GRMadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"GRMadl/VPL_GRMadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"GRMadl/VPL_GRMadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"GRMadl/P_GRMadl.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "GRMadl/V_GRMadl_2-1-1.svg" 

#set out "V_GRMadl_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "GRMadl/VPL_GRMadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"GRMadl/VPL_GRMadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"GRMadl/VPL_GRMadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"GRMadl/P_GRMadl.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "GRMadl/E_GRMadl_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "GRMadl/T_GRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"GRMadl/T_GRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"GRMadl/T_GRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"GRMadl/T_GRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"GRMadl/T_GRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"GRMadl/T_GRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"GRMadl/T_GRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"GRMadl/T_GRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"GRMadl/T_GRMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "GRMadl/E_GRMadl_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "GRMadl/EXP_GRMadl_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "GRMadl/E_GRMadl.txt" every :::0::0 u 1:2 t "e11" w l ,"GRMadl/E_GRMadl.txt" every :::0::0 u 1:3 t "e12" w l ,"GRMadl/E_GRMadl.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "GRMadl/EXP_GRMadl_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "GRMadl/E_GRMadl.txt" every :::0::0 u 1:5 t "e21" w l ,"GRMadl/E_GRMadl.txt" every :::0::0 u 1:6 t "e22" w l ,"GRMadl/E_GRMadl.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "GRMadl/LIJ_GRMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMadl/PIJ_GRMadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "GRMadl/LIJ_GRMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMadl/PIJ_GRMadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "GRMadl/LIJT_GRMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMadl/PIJ_GRMadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "GRMadl/LIJT_GRMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMadl/PIJ_GRMadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "GRMadl/P_GRMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMadl/PIJ_GRMadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "GRMadl/P_GRMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMadl/PIJ_GRMadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-9.374852; p2=0.065793; 
#   current state 3
p3=-13.863106; p4=0.131304; 
# initial state 2
#   current state 1
p5=-0.269752; p6=-0.030395; 
#   current state 3
p7=-3.621010; p8=0.020966; 
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

set out "GRMadl/PE_GRMadl_1-1-1.svg" 
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

set out "GRMadl/PE_GRMadl_1-2-1.svg" 
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

set out "GRMadl/PE_GRMadl_1-3-1.svg" 
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
set out "GRMadl/VARPIJGR_GRMadl_113-12.svg"
set label "50" at  1.350e-003, 4.539e-003 center
# Age 50, p13 - p12
plot [-pi:pi]  1.350e-003+ 2.000*( 5.067e-002* 2.405e-003*cos(t)+ 9.987e-001* 6.656e-004*sin(t)),  4.539e-003 +2.000*(-9.987e-001* 2.405e-003*cos(t)+ 5.067e-002* 6.656e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  2.599e-003, 6.298e-003 center
replot  2.599e-003+ 2.000*( 7.978e-002* 2.757e-003*cos(t)+ 9.968e-001* 1.078e-003*sin(t)),  6.298e-003 +2.000*(-9.968e-001* 2.757e-003*cos(t)+ 7.978e-002* 1.078e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  4.998e-003, 8.730e-003 center
replot  4.998e-003+ 2.000*( 1.408e-001* 3.059e-003*cos(t)+ 9.900e-001* 1.686e-003*sin(t)),  8.730e-003 +2.000*(-9.900e-001* 3.059e-003*cos(t)+ 1.408e-001* 1.686e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  9.599e-003, 1.208e-002 center
replot  9.599e-003+ 2.000*( 3.275e-001* 3.313e-003*cos(t)+ 9.448e-001* 2.491e-003*sin(t)),  1.208e-002 +2.000*(-9.448e-001* 3.313e-003*cos(t)+ 3.275e-001* 2.491e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.838e-002, 1.667e-002 center
replot  1.838e-002+ 2.000*( 8.348e-001* 3.869e-003*cos(t)+ 5.505e-001* 3.208e-003*sin(t)),  1.667e-002 +2.000*(-5.505e-001* 3.869e-003*cos(t)+ 8.348e-001* 3.208e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  3.503e-002, 2.290e-002 center
replot  3.503e-002+ 2.000*( 9.510e-001* 5.126e-003*cos(t)+ 3.093e-001* 3.993e-003*sin(t)),  2.290e-002 +2.000*(-3.093e-001* 5.126e-003*cos(t)+ 9.510e-001* 3.993e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  6.617e-002, 3.117e-002 center
replot  6.617e-002+ 2.000*( 9.592e-001* 7.987e-003*cos(t)+ 2.828e-001* 6.223e-003*sin(t)),  3.117e-002 +2.000*(-2.828e-001* 7.987e-003*cos(t)+ 9.592e-001* 6.223e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  1.230e-001, 4.178e-002 center
replot  1.230e-001+ 2.000*( 9.841e-001* 1.736e-002*cos(t)+ 1.775e-001* 1.084e-002*sin(t)),  4.178e-002 +2.000*(-1.775e-001* 1.736e-002*cos(t)+ 9.841e-001* 1.084e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  2.227e-001, 5.450e-002 center
replot  2.227e-001+ 2.000*( 9.920e-001* 4.118e-002*cos(t)+ 1.266e-001* 1.819e-002*sin(t)),  5.450e-002 +2.000*(-1.266e-001* 4.118e-002*cos(t)+ 9.920e-001* 1.819e-002*sin(t)) not
set out;
set out "GRMadl/VARPIJGR_GRMadl_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "GRMadl/VARPIJGR_GRMadl_121-12.svg"
set label "50" at  2.687e-001, 4.539e-003 center
# Age 50, p21 - p12
plot [-pi:pi]  2.687e-001+ 2.000*( 1.000e+000* 1.543e-001*cos(t)+-2.039e-003* 2.381e-003*sin(t)),  4.539e-003 +2.000*( 2.039e-003* 1.543e-001*cos(t)+ 1.000e+000* 2.381e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  2.336e-001, 6.298e-003 center
replot  2.336e-001+ 2.000*( 1.000e+000* 1.140e-001*cos(t)+-3.237e-003* 2.724e-003*sin(t)),  6.298e-003 +2.000*( 3.237e-003* 1.140e-001*cos(t)+ 1.000e+000* 2.724e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.025e-001, 8.730e-003 center
replot  2.025e-001+ 2.000*( 1.000e+000* 8.190e-002*cos(t)+-5.172e-003* 3.008e-003*sin(t)),  8.730e-003 +2.000*( 5.172e-003* 8.190e-002*cos(t)+ 1.000e+000* 3.008e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  1.749e-001, 1.208e-002 center
replot  1.749e-001+ 2.000*( 1.000e+000* 5.778e-002*cos(t)+-8.200e-003* 3.200e-003*sin(t)),  1.208e-002 +2.000*( 8.200e-003* 5.778e-002*cos(t)+ 1.000e+000* 3.200e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  1.507e-001, 1.667e-002 center
replot  1.507e-001+ 2.000*( 9.999e-001* 4.202e-002*cos(t)+-1.236e-002* 3.383e-003*sin(t)),  1.667e-002 +2.000*( 1.236e-002* 4.202e-002*cos(t)+ 9.999e-001* 3.383e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.295e-001, 2.290e-002 center
replot  1.295e-001+ 2.000*( 9.999e-001* 3.475e-002*cos(t)+-1.686e-002* 4.073e-003*sin(t)),  2.290e-002 +2.000*( 1.686e-002* 3.475e-002*cos(t)+ 9.999e-001* 4.073e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.109e-001, 3.117e-002 center
replot  1.109e-001+ 2.000*( 9.997e-001* 3.401e-002*cos(t)+-2.252e-002* 6.337e-003*sin(t)),  3.117e-002 +2.000*( 2.252e-002* 3.401e-002*cos(t)+ 9.997e-001* 6.337e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  9.477e-002, 4.178e-002 center
replot  9.477e-002+ 2.000*( 9.995e-001* 3.614e-002*cos(t)+-3.314e-002* 1.105e-002*sin(t)),  4.178e-002 +2.000*( 3.314e-002* 3.614e-002*cos(t)+ 9.995e-001* 1.105e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  8.078e-002, 5.450e-002 center
replot  8.078e-002+ 2.000*( 9.985e-001* 3.854e-002*cos(t)+-5.502e-002* 1.869e-002*sin(t)),  5.450e-002 +2.000*( 5.502e-002* 3.854e-002*cos(t)+ 9.985e-001* 1.869e-002*sin(t)) not
set out;
set out "GRMadl/VARPIJGR_GRMadl_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "GRMadl/VARPIJGR_GRMadl_123-12.svg"
set label "50" at  1.228e-001, 4.539e-003 center
# Age 50, p23 - p12
plot [-pi:pi]  1.228e-001+ 2.000*( 1.000e+000* 7.811e-002*cos(t)+-5.115e-003* 2.368e-003*sin(t)),  4.539e-003 +2.000*( 5.115e-003* 7.811e-002*cos(t)+ 1.000e+000* 2.368e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.380e-001, 6.298e-003 center
replot  1.380e-001+ 2.000*( 1.000e+000* 7.396e-002*cos(t)+-6.319e-003* 2.709e-003*sin(t)),  6.298e-003 +2.000*( 6.319e-003* 7.396e-002*cos(t)+ 1.000e+000* 2.709e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  1.546e-001, 8.730e-003 center
replot  1.546e-001+ 2.000*( 1.000e+000* 6.797e-002*cos(t)+-7.749e-003* 2.992e-003*sin(t)),  8.730e-003 +2.000*( 7.749e-003* 6.797e-002*cos(t)+ 1.000e+000* 2.992e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.727e-001, 1.208e-002 center
replot  1.727e-001+ 2.000*( 1.000e+000* 6.028e-002*cos(t)+-9.427e-003* 3.184e-003*sin(t)),  1.208e-002 +2.000*( 9.427e-003* 6.028e-002*cos(t)+ 1.000e+000* 3.184e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  1.924e-001, 1.667e-002 center
replot  1.924e-001+ 2.000*( 9.999e-001* 5.154e-002*cos(t)+-1.152e-002* 3.370e-003*sin(t)),  1.667e-002 +2.000*( 1.152e-002* 5.154e-002*cos(t)+ 9.999e-001* 3.370e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  2.136e-001, 2.290e-002 center
replot  2.136e-001+ 2.000*( 9.999e-001* 4.383e-002*cos(t)+-1.515e-002* 4.061e-003*sin(t)),  2.290e-002 +2.000*( 1.515e-002* 4.383e-002*cos(t)+ 9.999e-001* 4.061e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  2.366e-001, 3.117e-002 center
replot  2.366e-001+ 2.000*( 9.997e-001* 4.194e-002*cos(t)+-2.386e-002* 6.305e-003*sin(t)),  3.117e-002 +2.000*( 2.386e-002* 4.194e-002*cos(t)+ 9.997e-001* 6.305e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  2.614e-001, 4.178e-002 center
replot  2.614e-001+ 2.000*( 9.993e-001* 5.123e-002*cos(t)+-3.718e-002* 1.095e-002*sin(t)),  4.178e-002 +2.000*( 3.718e-002* 5.123e-002*cos(t)+ 9.993e-001* 1.095e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.880e-001, 5.450e-002 center
replot  2.880e-001+ 2.000*( 9.988e-001* 7.150e-002*cos(t)+-4.945e-002* 1.847e-002*sin(t)),  5.450e-002 +2.000*( 4.945e-002* 7.150e-002*cos(t)+ 9.988e-001* 1.847e-002*sin(t)) not
set out;
set out "GRMadl/VARPIJGR_GRMadl_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "GRMadl/VARPIJGR_GRMadl_121-13.svg"
set label "50" at  2.687e-001, 1.350e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  2.687e-001+ 2.000*( 1.000e+000* 1.543e-001*cos(t)+-1.719e-004* 6.753e-004*sin(t)),  1.350e-003 +2.000*( 1.719e-004* 1.543e-001*cos(t)+ 1.000e+000* 6.753e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  2.336e-001, 2.599e-003 center
replot  2.336e-001+ 2.000*( 1.000e+000* 1.140e-001*cos(t)+-3.349e-004* 1.096e-003*sin(t)),  2.599e-003 +2.000*( 3.349e-004* 1.140e-001*cos(t)+ 1.000e+000* 1.096e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.025e-001, 4.998e-003 center
replot  2.025e-001+ 2.000*( 1.000e+000* 8.190e-002*cos(t)+-5.977e-004* 1.723e-003*sin(t)),  4.998e-003 +2.000*( 5.977e-004* 8.190e-002*cos(t)+ 1.000e+000* 1.723e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  1.749e-001, 9.599e-003 center
replot  1.749e-001+ 2.000*( 1.000e+000* 5.778e-002*cos(t)+-8.860e-004* 2.591e-003*sin(t)),  9.599e-003 +2.000*( 8.860e-004* 5.778e-002*cos(t)+ 1.000e+000* 2.591e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  1.507e-001, 1.838e-002 center
replot  1.507e-001+ 2.000*( 1.000e+000* 4.202e-002*cos(t)+-1.086e-003* 3.681e-003*sin(t)),  1.838e-002 +2.000*( 1.086e-003* 4.202e-002*cos(t)+ 1.000e+000* 3.681e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.295e-001, 3.503e-002 center
replot  1.295e-001+ 2.000*( 1.000e+000* 3.475e-002*cos(t)+-3.261e-003* 5.027e-003*sin(t)),  3.503e-002 +2.000*( 3.261e-003* 3.475e-002*cos(t)+ 1.000e+000* 5.027e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.109e-001, 6.617e-002 center
replot  1.109e-001+ 2.000*( 9.999e-001* 3.401e-002*cos(t)+-1.552e-002* 7.844e-003*sin(t)),  6.617e-002 +2.000*( 1.552e-002* 3.401e-002*cos(t)+ 9.999e-001* 7.844e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  9.477e-002, 1.230e-001 center
replot  9.477e-002+ 2.000*( 9.983e-001* 3.617e-002*cos(t)+-5.810e-002* 1.710e-002*sin(t)),  1.230e-001 +2.000*( 5.810e-002* 3.617e-002*cos(t)+ 9.983e-001* 1.710e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  8.078e-002, 2.227e-001 center
replot  8.078e-002+ 2.000*( 4.916e-001* 4.199e-002*cos(t)+-8.708e-001* 3.732e-002*sin(t)),  2.227e-001 +2.000*( 8.708e-001* 4.199e-002*cos(t)+ 4.916e-001* 3.732e-002*sin(t)) not
set out;
set out "GRMadl/VARPIJGR_GRMadl_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "GRMadl/VARPIJGR_GRMadl_123-13.svg"
set label "50" at  1.228e-001, 1.350e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  1.228e-001+ 2.000*( 1.000e+000* 7.811e-002*cos(t)+ 1.852e-003* 6.602e-004*sin(t)),  1.350e-003 +2.000*(-1.852e-003* 7.811e-002*cos(t)+ 1.000e+000* 6.602e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.380e-001, 2.599e-003 center
replot  1.380e-001+ 2.000*( 1.000e+000* 7.396e-002*cos(t)+ 3.163e-003* 1.072e-003*sin(t)),  2.599e-003 +2.000*(-3.163e-003* 7.396e-002*cos(t)+ 1.000e+000* 1.072e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  1.546e-001, 4.998e-003 center
replot  1.546e-001+ 2.000*( 1.000e+000* 6.797e-002*cos(t)+ 5.371e-003* 1.685e-003*sin(t)),  4.998e-003 +2.000*(-5.371e-003* 6.797e-002*cos(t)+ 1.000e+000* 1.685e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.727e-001, 9.599e-003 center
replot  1.727e-001+ 2.000*( 1.000e+000* 6.028e-002*cos(t)+ 8.974e-003* 2.534e-003*sin(t)),  9.599e-003 +2.000*(-8.974e-003* 6.028e-002*cos(t)+ 1.000e+000* 2.534e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  1.924e-001, 1.838e-002 center
replot  1.924e-001+ 2.000*( 9.999e-001* 5.155e-002*cos(t)+ 1.439e-002* 3.606e-003*sin(t)),  1.838e-002 +2.000*(-1.439e-002* 5.155e-002*cos(t)+ 9.999e-001* 3.606e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  2.136e-001, 3.503e-002 center
replot  2.136e-001+ 2.000*( 9.998e-001* 4.383e-002*cos(t)+ 2.114e-002* 4.944e-003*sin(t)),  3.503e-002 +2.000*(-2.114e-002* 4.383e-002*cos(t)+ 9.998e-001* 4.944e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  2.366e-001, 6.617e-002 center
replot  2.366e-001+ 2.000*( 9.995e-001* 4.194e-002*cos(t)+ 3.027e-002* 7.761e-003*sin(t)),  6.617e-002 +2.000*(-3.027e-002* 4.194e-002*cos(t)+ 9.995e-001* 7.761e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  2.614e-001, 1.230e-001 center
replot  2.614e-001+ 2.000*( 9.982e-001* 5.128e-002*cos(t)+ 5.927e-002* 1.695e-002*sin(t)),  1.230e-001 +2.000*(-5.927e-002* 5.128e-002*cos(t)+ 9.982e-001* 1.695e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.880e-001, 2.227e-001 center
replot  2.880e-001+ 2.000*( 9.895e-001* 7.194e-002*cos(t)+ 1.444e-001* 3.999e-002*sin(t)),  2.227e-001 +2.000*(-1.444e-001* 7.194e-002*cos(t)+ 9.895e-001* 3.999e-002*sin(t)) not
set out;
set out "GRMadl/VARPIJGR_GRMadl_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "GRMadl/VARPIJGR_GRMadl_123-21.svg"
set label "50" at  1.228e-001, 2.687e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.228e-001+ 2.000*( 8.962e-002* 1.547e-001*cos(t)+ 9.960e-001* 7.718e-002*sin(t)),  2.687e-001 +2.000*(-9.960e-001* 1.547e-001*cos(t)+ 8.962e-002* 7.718e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.380e-001, 2.336e-001 center
replot  1.380e-001+ 2.000*( 1.265e-001* 1.146e-001*cos(t)+ 9.920e-001* 7.311e-002*sin(t)),  2.336e-001 +2.000*(-9.920e-001* 1.146e-001*cos(t)+ 1.265e-001* 7.311e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  1.546e-001, 2.025e-001 center
replot  1.546e-001+ 2.000*( 2.437e-001* 8.275e-002*cos(t)+ 9.699e-001* 6.692e-002*sin(t)),  2.025e-001 +2.000*(-9.699e-001* 8.275e-002*cos(t)+ 2.437e-001* 6.692e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.727e-001, 1.749e-001 center
replot  1.727e-001+ 2.000*( 8.452e-001* 6.188e-002*cos(t)+ 5.344e-001* 5.606e-002*sin(t)),  1.749e-001 +2.000*(-5.344e-001* 6.188e-002*cos(t)+ 8.452e-001* 5.606e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  1.924e-001, 1.507e-001 center
replot  1.924e-001+ 2.000*( 9.800e-001* 5.191e-002*cos(t)+ 1.991e-001* 4.156e-002*sin(t)),  1.507e-001 +2.000*(-1.991e-001* 5.191e-002*cos(t)+ 9.800e-001* 4.156e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  2.136e-001, 1.295e-001 center
replot  2.136e-001+ 2.000*( 9.766e-001* 4.424e-002*cos(t)+ 2.150e-001* 3.422e-002*sin(t)),  1.295e-001 +2.000*(-2.150e-001* 4.424e-002*cos(t)+ 9.766e-001* 3.422e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  2.366e-001, 1.109e-001 center
replot  2.366e-001+ 2.000*( 9.518e-001* 4.275e-002*cos(t)+ 3.067e-001* 3.297e-002*sin(t)),  1.109e-001 +2.000*(-3.067e-001* 4.275e-002*cos(t)+ 9.518e-001* 3.297e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  2.614e-001, 9.477e-002 center
replot  2.614e-001+ 2.000*( 9.736e-001* 5.194e-002*cos(t)+ 2.285e-001* 3.504e-002*sin(t)),  9.477e-002 +2.000*(-2.285e-001* 5.194e-002*cos(t)+ 9.736e-001* 3.504e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.880e-001, 8.078e-002 center
replot  2.880e-001+ 2.000*( 9.914e-001* 7.187e-002*cos(t)+ 1.312e-001* 3.765e-002*sin(t)),  8.078e-002 +2.000*(-1.312e-001* 7.187e-002*cos(t)+ 9.914e-001* 3.765e-002*sin(t)) not
set out;
set out "GRMadl/VARPIJGR_GRMadl_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "GRMadl/VARMUPTJGR--STABLBASED_GRMadl1.svg";
 plot "GRMadl/PRMORPREV-1-STABLBASED_GRMadl.txt"  u 1:($3) not w l lt 1 
 replot "GRMadl/PRMORPREV-1-STABLBASED_GRMadl.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "GRMadl/PRMORPREV-1-STABLBASED_GRMadl.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "GRMadl/VARMUPTJGR--STABLBASED_GRMadl1.svg";replot;set out;
