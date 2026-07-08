
# IMaCh-0.99r45
# BEFadl.gp
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


set ter svg size 640, 480;set out "BEFadl/D_BEFadl_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "BEFadl/ILK_BEFadl-dest.png";
set log y;plot  "BEFadl/ILK_BEFadl.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "BEFadl/ILK_BEFadl-ori.png";
set log y;plot  "BEFadl/ILK_BEFadl.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "BEFadl/ILK_BEFadl-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "BEFadl/ILK_BEFadl.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "BEFadl/ILK_BEFadl-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "BEFadl/ILK_BEFadl.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "BEFadl/V_BEFadl_1-1-1.svg" 

#set out "V_BEFadl_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "BEFadl/VPL_BEFadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"BEFadl/VPL_BEFadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"BEFadl/VPL_BEFadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"BEFadl/P_BEFadl.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "BEFadl/V_BEFadl_2-1-1.svg" 

#set out "V_BEFadl_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "BEFadl/VPL_BEFadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"BEFadl/VPL_BEFadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"BEFadl/VPL_BEFadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"BEFadl/P_BEFadl.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "BEFadl/E_BEFadl_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "BEFadl/T_BEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"BEFadl/T_BEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"BEFadl/T_BEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"BEFadl/T_BEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"BEFadl/T_BEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"BEFadl/T_BEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"BEFadl/T_BEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"BEFadl/T_BEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"BEFadl/T_BEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "BEFadl/E_BEFadl_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "BEFadl/EXP_BEFadl_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "BEFadl/E_BEFadl.txt" every :::0::0 u 1:2 t "e11" w l ,"BEFadl/E_BEFadl.txt" every :::0::0 u 1:3 t "e12" w l ,"BEFadl/E_BEFadl.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "BEFadl/EXP_BEFadl_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "BEFadl/E_BEFadl.txt" every :::0::0 u 1:5 t "e21" w l ,"BEFadl/E_BEFadl.txt" every :::0::0 u 1:6 t "e22" w l ,"BEFadl/E_BEFadl.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "BEFadl/LIJ_BEFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEFadl/PIJ_BEFadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "BEFadl/LIJ_BEFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEFadl/PIJ_BEFadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "BEFadl/LIJT_BEFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEFadl/PIJ_BEFadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "BEFadl/LIJT_BEFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEFadl/PIJ_BEFadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "BEFadl/P_BEFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEFadl/PIJ_BEFadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "BEFadl/P_BEFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEFadl/PIJ_BEFadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-8.549684; p2=0.071790; 
#   current state 3
p3=-12.683137; p4=0.100028; 
# initial state 2
#   current state 1
p5=-1.637727; p6=-0.007076; 
#   current state 3
p7=-9.674394; p8=0.087819; 
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

set out "BEFadl/PE_BEFadl_1-1-1.svg" 
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

set out "BEFadl/PE_BEFadl_1-2-1.svg" 
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

set out "BEFadl/PE_BEFadl_1-3-1.svg" 
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
set out "BEFadl/VARPIJGR_BEFadl_113-12.svg"
set label "50" at  9.155e-004, 1.392e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  9.155e-004+ 2.000*( 3.255e-002* 2.788e-003*cos(t)+ 9.995e-001* 6.133e-004*sin(t)),  1.392e-002 +2.000*(-9.995e-001* 2.788e-003*cos(t)+ 3.255e-002* 6.133e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.505e-003, 1.986e-002 center
replot  1.505e-003+ 2.000*( 3.574e-002* 3.241e-003*cos(t)+ 9.994e-001* 8.271e-004*sin(t)),  1.986e-002 +2.000*(-9.994e-001* 3.241e-003*cos(t)+ 3.574e-002* 8.271e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  2.469e-003, 2.831e-002 center
replot  2.469e-003+ 2.000*( 3.830e-002* 3.643e-003*cos(t)+ 9.993e-001* 1.075e-003*sin(t)),  2.831e-002 +2.000*(-9.993e-001* 3.643e-003*cos(t)+ 3.830e-002* 1.075e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  4.044e-003, 4.025e-002 center
replot  4.044e-003+ 2.000*( 4.084e-002* 4.014e-003*cos(t)+ 9.992e-001* 1.346e-003*sin(t)),  4.025e-002 +2.000*(-9.992e-001* 4.014e-003*cos(t)+ 4.084e-002* 1.346e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  6.602e-003, 5.707e-002 center
replot  6.602e-003+ 2.000*( 5.197e-002* 4.669e-003*cos(t)+ 9.986e-001* 1.697e-003*sin(t)),  5.707e-002 +2.000*(-9.986e-001* 4.669e-003*cos(t)+ 5.197e-002* 1.697e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.073e-002, 8.054e-002 center
replot  1.073e-002+ 2.000*( 8.832e-002* 6.606e-003*cos(t)+ 9.961e-001* 2.512e-003*sin(t)),  8.054e-002 +2.000*(-9.961e-001* 6.606e-003*cos(t)+ 8.832e-002* 2.512e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  1.733e-002, 1.130e-001 center
replot  1.733e-002+ 2.000*( 1.417e-001* 1.123e-002*cos(t)+ 9.899e-001* 4.759e-003*sin(t)),  1.130e-001 +2.000*(-9.899e-001* 1.123e-002*cos(t)+ 1.417e-001* 4.759e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  2.775e-002, 1.570e-001 center
replot  2.775e-002+ 2.000*( 2.092e-001* 1.983e-002*cos(t)+ 9.779e-001* 9.790e-003*sin(t)),  1.570e-001 +2.000*(-9.779e-001* 1.983e-002*cos(t)+ 2.092e-001* 9.790e-003*sin(t)) not
# Age 90, p13 - p12
set label "90" at  4.387e-002, 2.156e-001 center
replot  4.387e-002+ 2.000*( 3.107e-001* 3.404e-002*cos(t)+ 9.505e-001* 1.930e-002*sin(t)),  2.156e-001 +2.000*(-9.505e-001* 3.404e-002*cos(t)+ 3.107e-001* 1.930e-002*sin(t)) not
set out;
set out "BEFadl/VARPIJGR_BEFadl_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "BEFadl/VARPIJGR_BEFadl_121-12.svg"
set label "50" at  2.391e-001, 1.392e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  2.391e-001+ 2.000*( 9.999e-001* 4.403e-002*cos(t)+-1.303e-002* 2.727e-003*sin(t)),  1.392e-002 +2.000*( 1.303e-002* 4.403e-002*cos(t)+ 9.999e-001* 2.727e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  2.312e-001, 1.986e-002 center
replot  2.312e-001+ 2.000*( 9.998e-001* 3.546e-002*cos(t)+-1.841e-002* 3.173e-003*sin(t)),  1.986e-002 +2.000*( 1.841e-002* 3.546e-002*cos(t)+ 9.998e-001* 3.173e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.232e-001, 2.831e-002 center
replot  2.232e-001+ 2.000*( 9.997e-001* 2.798e-002*cos(t)+-2.592e-002* 3.569e-003*sin(t)),  2.831e-002 +2.000*( 2.592e-002* 2.798e-002*cos(t)+ 9.997e-001* 3.569e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.150e-001, 4.025e-002 center
replot  2.150e-001+ 2.000*( 9.993e-001* 2.210e-002*cos(t)+-3.746e-002* 3.927e-003*sin(t)),  4.025e-002 +2.000*( 3.746e-002* 2.210e-002*cos(t)+ 9.993e-001* 3.927e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.064e-001, 5.707e-002 center
replot  2.064e-001+ 2.000*( 9.982e-001* 1.864e-002*cos(t)+-5.996e-002* 4.536e-003*sin(t)),  5.707e-002 +2.000*( 5.996e-002* 1.864e-002*cos(t)+ 9.982e-001* 4.536e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.972e-001, 8.054e-002 center
replot  1.972e-001+ 2.000*( 9.942e-001* 1.826e-002*cos(t)+-1.078e-001* 6.320e-003*sin(t)),  8.054e-002 +2.000*( 1.078e-001* 1.826e-002*cos(t)+ 9.942e-001* 6.320e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.869e-001, 1.130e-001 center
replot  1.869e-001+ 2.000*( 9.789e-001* 2.054e-002*cos(t)+-2.046e-001* 1.053e-002*sin(t)),  1.130e-001 +2.000*( 2.046e-001* 2.054e-002*cos(t)+ 9.789e-001* 1.053e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.752e-001, 1.570e-001 center
replot  1.752e-001+ 2.000*( 8.852e-001* 2.476e-002*cos(t)+-4.652e-001* 1.777e-002*sin(t)),  1.570e-001 +2.000*( 4.652e-001* 2.476e-002*cos(t)+ 8.852e-001* 1.777e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.616e-001, 2.156e-001 center
replot  1.616e-001+ 2.000*( 4.201e-001* 3.440e-002*cos(t)+-9.075e-001* 2.473e-002*sin(t)),  2.156e-001 +2.000*( 9.075e-001* 3.440e-002*cos(t)+ 4.201e-001* 2.473e-002*sin(t)) not
set out;
set out "BEFadl/VARPIJGR_BEFadl_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "BEFadl/VARPIJGR_BEFadl_123-12.svg"
set label "50" at  8.891e-003, 1.392e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  8.891e-003+ 2.000*( 9.966e-001* 4.595e-003*cos(t)+-8.235e-002* 2.770e-003*sin(t)),  1.392e-002 +2.000*( 8.235e-002* 4.595e-003*cos(t)+ 9.966e-001* 2.770e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.382e-002, 1.986e-002 center
replot  1.382e-002+ 2.000*( 9.980e-001* 6.087e-003*cos(t)+-6.341e-002* 3.222e-003*sin(t)),  1.986e-002 +2.000*( 6.341e-002* 6.087e-003*cos(t)+ 9.980e-001* 3.222e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  2.144e-002, 2.831e-002 center
replot  2.144e-002+ 2.000*( 9.987e-001* 7.836e-003*cos(t)+-5.018e-002* 3.624e-003*sin(t)),  2.831e-002 +2.000*( 5.018e-002* 7.836e-003*cos(t)+ 9.987e-001* 3.624e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  3.319e-002, 4.025e-002 center
replot  3.319e-002+ 2.000*( 9.991e-001* 9.700e-003*cos(t)+-4.150e-002* 3.994e-003*sin(t)),  4.025e-002 +2.000*( 4.150e-002* 9.700e-003*cos(t)+ 9.991e-001* 3.994e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  5.121e-002, 5.707e-002 center
replot  5.121e-002+ 2.000*( 9.992e-001* 1.140e-002*cos(t)+-3.970e-002* 4.646e-003*sin(t)),  5.707e-002 +2.000*( 3.970e-002* 1.140e-002*cos(t)+ 9.992e-001* 4.646e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  7.861e-002, 8.054e-002 center
replot  7.861e-002+ 2.000*( 9.982e-001* 1.266e-002*cos(t)+-6.060e-002* 6.551e-003*sin(t)),  8.054e-002 +2.000*( 6.060e-002* 1.266e-002*cos(t)+ 9.982e-001* 6.551e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.198e-001, 1.130e-001 center
replot  1.198e-001+ 2.000*( 9.754e-001* 1.434e-002*cos(t)+-2.205e-001* 1.094e-002*sin(t)),  1.130e-001 +2.000*( 2.205e-001* 1.434e-002*cos(t)+ 9.754e-001* 1.094e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.804e-001, 1.570e-001 center
replot  1.804e-001+ 2.000*( 8.163e-001* 2.162e-002*cos(t)+-5.776e-001* 1.834e-002*sin(t)),  1.570e-001 +2.000*( 5.776e-001* 2.162e-002*cos(t)+ 8.163e-001* 1.834e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.674e-001, 2.156e-001 center
replot  2.674e-001+ 2.000*( 9.207e-001* 3.956e-002*cos(t)+-3.904e-001* 3.156e-002*sin(t)),  2.156e-001 +2.000*( 3.904e-001* 3.956e-002*cos(t)+ 9.207e-001* 3.156e-002*sin(t)) not
set out;
set out "BEFadl/VARPIJGR_BEFadl_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "BEFadl/VARPIJGR_BEFadl_121-13.svg"
set label "50" at  2.391e-001, 9.155e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  2.391e-001+ 2.000*( 1.000e+000* 4.403e-002*cos(t)+-2.770e-004* 6.196e-004*sin(t)),  9.155e-004 +2.000*( 2.770e-004* 4.403e-002*cos(t)+ 1.000e+000* 6.196e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  2.312e-001, 1.505e-003 center
replot  2.312e-001+ 2.000*( 1.000e+000* 3.545e-002*cos(t)+-3.793e-004* 8.345e-004*sin(t)),  1.505e-003 +2.000*( 3.793e-004* 3.545e-002*cos(t)+ 1.000e+000* 8.345e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.232e-001, 2.469e-003 center
replot  2.232e-001+ 2.000*( 1.000e+000* 2.797e-002*cos(t)+-4.894e-004* 1.083e-003*sin(t)),  2.469e-003 +2.000*( 4.894e-004* 2.797e-002*cos(t)+ 1.000e+000* 1.083e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.150e-001, 4.044e-003 center
replot  2.150e-001+ 2.000*( 1.000e+000* 2.209e-002*cos(t)+-7.507e-004* 1.354e-003*sin(t)),  4.044e-003 +2.000*( 7.507e-004* 2.209e-002*cos(t)+ 1.000e+000* 1.354e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.064e-001, 6.602e-003 center
replot  2.064e-001+ 2.000*( 1.000e+000* 1.861e-002*cos(t)+-2.204e-003* 1.711e-003*sin(t)),  6.602e-003 +2.000*( 2.204e-003* 1.861e-002*cos(t)+ 1.000e+000* 1.711e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.972e-001, 1.073e-002 center
replot  1.972e-001+ 2.000*( 1.000e+000* 1.816e-002*cos(t)+-7.507e-003* 2.566e-003*sin(t)),  1.073e-002 +2.000*( 7.507e-003* 1.816e-002*cos(t)+ 1.000e+000* 2.566e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.869e-001, 1.733e-002 center
replot  1.869e-001+ 2.000*( 9.998e-001* 2.022e-002*cos(t)+-1.967e-002* 4.957e-003*sin(t)),  1.733e-002 +2.000*( 1.967e-002* 2.022e-002*cos(t)+ 9.998e-001* 4.957e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.752e-001, 2.775e-002 center
replot  1.752e-001+ 2.000*( 9.988e-001* 2.345e-002*cos(t)+-4.880e-002* 1.038e-002*sin(t)),  2.775e-002 +2.000*( 4.880e-002* 2.345e-002*cos(t)+ 9.988e-001* 1.038e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.616e-001, 4.387e-002 center
replot  1.616e-001+ 2.000*( 9.792e-001* 2.692e-002*cos(t)+-2.030e-001* 2.089e-002*sin(t)),  4.387e-002 +2.000*( 2.030e-001* 2.692e-002*cos(t)+ 9.792e-001* 2.089e-002*sin(t)) not
set out;
set out "BEFadl/VARPIJGR_BEFadl_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "BEFadl/VARPIJGR_BEFadl_123-13.svg"
set label "50" at  8.891e-003, 9.155e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  8.891e-003+ 2.000*( 9.993e-001* 4.588e-003*cos(t)+ 3.615e-002* 5.975e-004*sin(t)),  9.155e-004 +2.000*(-3.615e-002* 4.588e-003*cos(t)+ 9.993e-001* 5.975e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.382e-002, 1.505e-003 center
replot  1.382e-002+ 2.000*( 9.993e-001* 6.083e-003*cos(t)+ 3.679e-002* 8.046e-004*sin(t)),  1.505e-003 +2.000*(-3.679e-002* 6.083e-003*cos(t)+ 9.993e-001* 8.046e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  2.144e-002, 2.469e-003 center
replot  2.144e-002+ 2.000*( 9.993e-001* 7.834e-003*cos(t)+ 3.720e-002* 1.044e-003*sin(t)),  2.469e-003 +2.000*(-3.720e-002* 7.834e-003*cos(t)+ 9.993e-001* 1.044e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  3.319e-002, 4.044e-003 center
replot  3.319e-002+ 2.000*( 9.993e-001* 9.700e-003*cos(t)+ 3.768e-002* 1.305e-003*sin(t)),  4.044e-003 +2.000*(-3.768e-002* 9.700e-003*cos(t)+ 9.993e-001* 1.305e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  5.121e-002, 6.602e-003 center
replot  5.121e-002+ 2.000*( 9.992e-001* 1.140e-002*cos(t)+ 4.000e-002* 1.651e-003*sin(t)),  6.602e-003 +2.000*(-4.000e-002* 1.140e-002*cos(t)+ 9.992e-001* 1.651e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  7.861e-002, 1.073e-002 center
replot  7.861e-002+ 2.000*( 9.986e-001* 1.266e-002*cos(t)+ 5.288e-002* 2.484e-003*sin(t)),  1.073e-002 +2.000*(-5.288e-002* 1.266e-002*cos(t)+ 9.986e-001* 2.484e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.198e-001, 1.733e-002 center
replot  1.198e-001+ 2.000*( 9.939e-001* 1.427e-002*cos(t)+ 1.100e-001* 4.747e-003*sin(t)),  1.733e-002 +2.000*(-1.100e-001* 1.427e-002*cos(t)+ 9.939e-001* 4.747e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.804e-001, 2.775e-002 center
replot  1.804e-001+ 2.000*( 9.773e-001* 2.096e-002*cos(t)+ 2.118e-001* 9.661e-003*sin(t)),  2.775e-002 +2.000*(-2.118e-001* 2.096e-002*cos(t)+ 9.773e-001* 9.661e-003*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.674e-001, 4.387e-002 center
replot  2.674e-001+ 2.000*( 9.707e-001* 3.931e-002*cos(t)+ 2.401e-001* 1.953e-002*sin(t)),  4.387e-002 +2.000*(-2.401e-001* 3.931e-002*cos(t)+ 9.707e-001* 1.953e-002*sin(t)) not
set out;
set out "BEFadl/VARPIJGR_BEFadl_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "BEFadl/VARPIJGR_BEFadl_123-21.svg"
set label "50" at  8.891e-003, 2.391e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  8.891e-003+ 2.000*( 1.660e-003* 4.403e-002*cos(t)+ 1.000e+000* 4.584e-003*sin(t)),  2.391e-001 +2.000*(-1.000e+000* 4.403e-002*cos(t)+ 1.660e-003* 4.584e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.382e-002, 2.312e-001 center
replot  1.382e-002+ 2.000*( 3.758e-003* 3.545e-002*cos(t)+ 1.000e+000* 6.077e-003*sin(t)),  2.312e-001 +2.000*(-1.000e+000* 3.545e-002*cos(t)+ 3.758e-003* 6.077e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  2.144e-002, 2.232e-001 center
replot  2.144e-002+ 2.000*( 9.496e-003* 2.797e-002*cos(t)+ 1.000e+000* 7.824e-003*sin(t)),  2.232e-001 +2.000*(-1.000e+000* 2.797e-002*cos(t)+ 9.496e-003* 7.824e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  3.319e-002, 2.150e-001 center
replot  3.319e-002+ 2.000*( 2.547e-002* 2.209e-002*cos(t)+ 9.997e-001* 9.680e-003*sin(t)),  2.150e-001 +2.000*(-9.997e-001* 2.209e-002*cos(t)+ 2.547e-002* 9.680e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  5.121e-002, 2.064e-001 center
replot  5.121e-002+ 2.000*( 6.307e-002* 1.863e-002*cos(t)+ 9.980e-001* 1.135e-002*sin(t)),  2.064e-001 +2.000*(-9.980e-001* 1.863e-002*cos(t)+ 6.307e-002* 1.135e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  7.861e-002, 1.972e-001 center
replot  7.861e-002+ 2.000*( 9.911e-002* 1.821e-002*cos(t)+ 9.951e-001* 1.258e-002*sin(t)),  1.972e-001 +2.000*(-9.951e-001* 1.821e-002*cos(t)+ 9.911e-002* 1.258e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.198e-001, 1.869e-001 center
replot  1.198e-001+ 2.000*( 1.033e-001* 2.027e-002*cos(t)+ 9.947e-001* 1.411e-002*sin(t)),  1.869e-001 +2.000*(-9.947e-001* 2.027e-002*cos(t)+ 1.033e-001* 1.411e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.804e-001, 1.752e-001 center
replot  1.804e-001+ 2.000*( 2.967e-001* 2.371e-002*cos(t)+ 9.550e-001* 2.026e-002*sin(t)),  1.752e-001 +2.000*(-9.550e-001* 2.371e-002*cos(t)+ 2.967e-001* 2.026e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.674e-001, 1.616e-001 center
replot  2.674e-001+ 2.000*( 9.851e-001* 3.876e-002*cos(t)+ 1.718e-001* 2.624e-002*sin(t)),  1.616e-001 +2.000*(-1.718e-001* 3.876e-002*cos(t)+ 9.851e-001* 2.624e-002*sin(t)) not
set out;
set out "BEFadl/VARPIJGR_BEFadl_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "BEFadl/VARMUPTJGR--STABLBASED_BEFadl1.svg";
 plot "BEFadl/PRMORPREV-1-STABLBASED_BEFadl.txt"  u 1:($3) not w l lt 1 
 replot "BEFadl/PRMORPREV-1-STABLBASED_BEFadl.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "BEFadl/PRMORPREV-1-STABLBASED_BEFadl.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "BEFadl/VARMUPTJGR--STABLBASED_BEFadl1.svg";replot;set out;
