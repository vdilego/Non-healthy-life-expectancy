
# IMaCh-0.99r45
# BEFchr.gp
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


set ter svg size 640, 480;set out "BEFchr/D_BEFchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "BEFchr/ILK_BEFchr-dest.png";
set log y;plot  "BEFchr/ILK_BEFchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "BEFchr/ILK_BEFchr-ori.png";
set log y;plot  "BEFchr/ILK_BEFchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "BEFchr/ILK_BEFchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "BEFchr/ILK_BEFchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "BEFchr/ILK_BEFchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "BEFchr/ILK_BEFchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "BEFchr/V_BEFchr_1-1-1.svg" 

#set out "V_BEFchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "BEFchr/VPL_BEFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"BEFchr/VPL_BEFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"BEFchr/VPL_BEFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"BEFchr/P_BEFchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "BEFchr/V_BEFchr_2-1-1.svg" 

#set out "V_BEFchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "BEFchr/VPL_BEFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"BEFchr/VPL_BEFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"BEFchr/VPL_BEFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"BEFchr/P_BEFchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "BEFchr/E_BEFchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "BEFchr/T_BEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"BEFchr/T_BEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"BEFchr/T_BEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"BEFchr/T_BEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"BEFchr/T_BEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"BEFchr/T_BEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"BEFchr/T_BEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"BEFchr/T_BEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"BEFchr/T_BEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "BEFchr/E_BEFchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "BEFchr/EXP_BEFchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "BEFchr/E_BEFchr.txt" every :::0::0 u 1:2 t "e11" w l ,"BEFchr/E_BEFchr.txt" every :::0::0 u 1:3 t "e12" w l ,"BEFchr/E_BEFchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "BEFchr/EXP_BEFchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "BEFchr/E_BEFchr.txt" every :::0::0 u 1:5 t "e21" w l ,"BEFchr/E_BEFchr.txt" every :::0::0 u 1:6 t "e22" w l ,"BEFchr/E_BEFchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "BEFchr/LIJ_BEFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEFchr/PIJ_BEFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "BEFchr/LIJ_BEFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEFchr/PIJ_BEFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "BEFchr/LIJT_BEFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEFchr/PIJ_BEFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "BEFchr/LIJT_BEFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEFchr/PIJ_BEFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "BEFchr/P_BEFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEFchr/PIJ_BEFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "BEFchr/P_BEFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "BEFchr/PIJ_BEFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-3.125333; p2=0.049068; 
#   current state 3
p3=-7.523292; p4=0.067325; 
# initial state 2
#   current state 1
p5=1.498353; p6=-0.059819; 
#   current state 3
p7=-13.822962; p8=0.146606; 
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

set out "BEFchr/PE_BEFchr_1-1-1.svg" 
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

set out "BEFchr/PE_BEFchr_1-2-1.svg" 
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

set out "BEFchr/PE_BEFchr_1-3-1.svg" 
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
set out "BEFchr/VARPIJGR_BEFchr_113-12.svg"
set label "50" at  5.128e-003, 1.673e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  5.128e-003+ 2.000*( 4.966e-003* 1.862e-002*cos(t)+ 1.000e+000* 3.228e-003*sin(t)),  1.673e-001 +2.000*(-1.000e+000* 1.862e-002*cos(t)+ 4.966e-003* 3.228e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  6.544e-003, 1.949e-001 center
replot  6.544e-003+ 2.000*( 1.791e-002* 1.498e-002*cos(t)+ 9.998e-001* 3.258e-003*sin(t)),  1.949e-001 +2.000*(-9.998e-001* 1.498e-002*cos(t)+ 1.791e-002* 3.258e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  8.229e-003, 2.237e-001 center
replot  8.229e-003+ 2.000*( 3.439e-002* 1.252e-002*cos(t)+ 9.994e-001* 3.250e-003*sin(t)),  2.237e-001 +2.000*(-9.994e-001* 1.252e-002*cos(t)+ 3.439e-002* 3.250e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.019e-002, 2.528e-001 center
replot  1.019e-002+ 2.000*( 3.955e-002* 1.312e-002*cos(t)+ 9.992e-001* 3.535e-003*sin(t)),  2.528e-001 +2.000*(-9.992e-001* 1.312e-002*cos(t)+ 3.955e-002* 3.535e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.242e-002, 2.812e-001 center
replot  1.242e-002+ 2.000*( 4.738e-002* 1.651e-002*cos(t)+ 9.989e-001* 4.600e-003*sin(t)),  2.812e-001 +2.000*(-9.989e-001* 1.651e-002*cos(t)+ 4.738e-002* 4.600e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.491e-002, 3.081e-001 center
replot  1.491e-002+ 2.000*( 7.891e-002* 2.090e-002*cos(t)+ 9.969e-001* 6.674e-003*sin(t)),  3.081e-001 +2.000*(-9.969e-001* 2.090e-002*cos(t)+ 7.891e-002* 6.674e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  1.764e-002, 3.328e-001 center
replot  1.764e-002+ 2.000*( 1.449e-001* 2.527e-002*cos(t)+ 9.894e-001* 9.595e-003*sin(t)),  3.328e-001 +2.000*(-9.894e-001* 2.527e-002*cos(t)+ 1.449e-001* 9.595e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  2.060e-002, 3.547e-001 center
replot  2.060e-002+ 2.000*( 2.573e-001* 2.962e-002*cos(t)+ 9.663e-001* 1.290e-002*sin(t)),  3.547e-001 +2.000*(-9.663e-001* 2.962e-002*cos(t)+ 2.573e-001* 1.290e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  2.376e-002, 3.735e-001 center
replot  2.376e-002+ 2.000*( 4.062e-001* 3.476e-002*cos(t)+ 9.138e-001* 1.578e-002*sin(t)),  3.735e-001 +2.000*(-9.138e-001* 3.476e-002*cos(t)+ 4.062e-001* 1.578e-002*sin(t)) not
set out;
set out "BEFchr/VARPIJGR_BEFchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "BEFchr/VARPIJGR_BEFchr_121-12.svg"
set label "50" at  9.165e-002, 1.673e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  9.165e-002+ 2.000*( 1.402e-002* 1.862e-002*cos(t)+-9.999e-001* 1.101e-002*sin(t)),  1.673e-001 +2.000*( 9.999e-001* 1.862e-002*cos(t)+ 1.402e-002* 1.101e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  7.124e-002, 1.949e-001 center
replot  7.124e-002+ 2.000*( 9.146e-003* 1.498e-002*cos(t)+-1.000e+000* 6.852e-003*sin(t)),  1.949e-001 +2.000*( 1.000e+000* 1.498e-002*cos(t)+ 9.146e-003* 6.852e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  5.468e-002, 2.237e-001 center
replot  5.468e-002+ 2.000*( 6.580e-003* 1.251e-002*cos(t)+-1.000e+000* 4.320e-003*sin(t)),  2.237e-001 +2.000*( 1.000e+000* 1.251e-002*cos(t)+ 6.580e-003* 4.320e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  4.145e-002, 2.528e-001 center
replot  4.145e-002+ 2.000*( 4.606e-003* 1.311e-002*cos(t)+-1.000e+000* 3.295e-003*sin(t)),  2.528e-001 +2.000*( 1.000e+000* 1.311e-002*cos(t)+ 4.606e-003* 3.295e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  3.099e-002, 2.812e-001 center
replot  3.099e-002+ 2.000*( 3.121e-003* 1.649e-002*cos(t)+-1.000e+000* 3.119e-003*sin(t)),  2.812e-001 +2.000*( 1.000e+000* 1.649e-002*cos(t)+ 3.121e-003* 3.119e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.270e-002, 3.081e-001 center
replot  2.270e-002+ 2.000*( 2.111e-003* 2.084e-002*cos(t)+-1.000e+000* 3.053e-003*sin(t)),  3.081e-001 +2.000*( 1.000e+000* 2.084e-002*cos(t)+ 2.111e-003* 3.053e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.610e-002, 3.328e-001 center
replot  1.610e-002+ 2.000*( 1.355e-003* 2.504e-002*cos(t)+-1.000e+000* 2.809e-003*sin(t)),  3.328e-001 +2.000*( 1.000e+000* 2.504e-002*cos(t)+ 1.355e-003* 2.809e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.079e-002, 3.547e-001 center
replot  1.079e-002+ 2.000*( 7.421e-004* 2.882e-002*cos(t)+-1.000e+000* 2.353e-003*sin(t)),  3.547e-001 +2.000*( 1.000e+000* 2.882e-002*cos(t)+ 7.421e-004* 2.353e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  6.609e-003, 3.735e-001 center
replot  6.609e-003+ 2.000*( 2.694e-004* 3.241e-002*cos(t)+-1.000e+000* 1.762e-003*sin(t)),  3.735e-001 +2.000*( 1.000e+000* 3.241e-002*cos(t)+ 2.694e-004* 1.762e-003*sin(t)) not
set out;
set out "BEFchr/VARPIJGR_BEFchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "BEFchr/VARPIJGR_BEFchr_123-12.svg"
set label "50" at  6.175e-004, 1.673e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  6.175e-004+ 2.000*( 8.995e-005* 1.862e-002*cos(t)+-1.000e+000* 2.643e-004*sin(t)),  1.673e-001 +2.000*( 1.000e+000* 1.862e-002*cos(t)+ 8.995e-005* 2.643e-004*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.347e-003, 1.949e-001 center
replot  1.347e-003+ 2.000*( 2.427e-004* 1.498e-002*cos(t)+-1.000e+000* 4.876e-004*sin(t)),  1.949e-001 +2.000*( 1.000e+000* 1.498e-002*cos(t)+ 2.427e-004* 4.876e-004*sin(t)) not
# Age 60, p23 - p12
set label "60" at  2.903e-003, 2.237e-001 center
replot  2.903e-003+ 2.000*( 5.515e-004* 1.251e-002*cos(t)+-1.000e+000* 8.614e-004*sin(t)),  2.237e-001 +2.000*( 1.000e+000* 1.251e-002*cos(t)+ 5.515e-004* 8.614e-004*sin(t)) not
# Age 65, p23 - p12
set label "65" at  6.178e-003, 2.528e-001 center
replot  6.178e-003+ 2.000*( 7.461e-004* 1.311e-002*cos(t)+-1.000e+000* 1.440e-003*sin(t)),  2.528e-001 +2.000*( 1.000e+000* 1.311e-002*cos(t)+ 7.461e-004* 1.440e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  1.296e-002, 2.812e-001 center
replot  1.296e-002+ 2.000*( 7.307e-004* 1.649e-002*cos(t)+-1.000e+000* 2.240e-003*sin(t)),  2.812e-001 +2.000*( 1.000e+000* 1.649e-002*cos(t)+ 7.307e-004* 2.240e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  2.666e-002, 3.081e-001 center
replot  2.666e-002+ 2.000*( 9.244e-004* 2.084e-002*cos(t)+-1.000e+000* 3.231e-003*sin(t)),  3.081e-001 +2.000*( 1.000e+000* 2.084e-002*cos(t)+ 9.244e-004* 3.231e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  5.305e-002, 3.328e-001 center
replot  5.305e-002+ 2.000*( 1.768e-003* 2.504e-002*cos(t)+-1.000e+000* 4.844e-003*sin(t)),  3.328e-001 +2.000*( 1.000e+000* 2.504e-002*cos(t)+ 1.768e-003* 4.844e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  9.980e-002, 3.547e-001 center
replot  9.980e-002+ 2.000*( 4.095e-003* 2.882e-002*cos(t)+-1.000e+000* 9.319e-003*sin(t)),  3.547e-001 +2.000*( 1.000e+000* 2.882e-002*cos(t)+ 4.095e-003* 9.319e-003*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.716e-001, 3.735e-001 center
replot  1.716e-001+ 2.000*( 1.010e-002* 3.241e-002*cos(t)+-9.999e-001* 1.815e-002*sin(t)),  3.735e-001 +2.000*( 9.999e-001* 3.241e-002*cos(t)+ 1.010e-002* 1.815e-002*sin(t)) not
set out;
set out "BEFchr/VARPIJGR_BEFchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "BEFchr/VARPIJGR_BEFchr_121-13.svg"
set label "50" at  9.165e-002, 5.128e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  9.165e-002+ 2.000*( 1.000e+000* 1.102e-002*cos(t)+-2.054e-003* 3.230e-003*sin(t)),  5.128e-003 +2.000*( 2.054e-003* 1.102e-002*cos(t)+ 1.000e+000* 3.230e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  7.124e-002, 6.544e-003 center
replot  7.124e-002+ 2.000*( 1.000e+000* 6.853e-003*cos(t)+-3.450e-003* 3.268e-003*sin(t)),  6.544e-003 +2.000*( 3.450e-003* 6.853e-003*cos(t)+ 1.000e+000* 3.268e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  5.468e-002, 8.229e-003 center
replot  5.468e-002+ 2.000*( 9.999e-001* 4.320e-003*cos(t)+-1.216e-002* 3.276e-003*sin(t)),  8.229e-003 +2.000*( 1.216e-002* 4.320e-003*cos(t)+ 9.999e-001* 3.276e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  4.145e-002, 1.019e-002 center
replot  4.145e-002+ 2.000*( 7.349e-002* 3.571e-003*cos(t)+-9.973e-001* 3.294e-003*sin(t)),  1.019e-002 +2.000*( 9.973e-001* 3.571e-003*cos(t)+ 7.349e-002* 3.294e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  3.099e-002, 1.242e-002 center
replot  3.099e-002+ 2.000*( 1.970e-002* 4.662e-003*cos(t)+-9.998e-001* 3.118e-003*sin(t)),  1.242e-002 +2.000*( 9.998e-001* 4.662e-003*cos(t)+ 1.970e-002* 3.118e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.270e-002, 1.491e-002 center
replot  2.270e-002+ 2.000*( 9.559e-003* 6.854e-003*cos(t)+-1.000e+000* 3.053e-003*sin(t)),  1.491e-002 +2.000*( 1.000e+000* 6.854e-003*cos(t)+ 9.559e-003* 3.053e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.610e-002, 1.764e-002 center
replot  1.610e-002+ 2.000*( 5.017e-003* 1.018e-002*cos(t)+-1.000e+000* 2.808e-003*sin(t)),  1.764e-002 +2.000*( 1.000e+000* 1.018e-002*cos(t)+ 5.017e-003* 2.808e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.079e-002, 2.060e-002 center
replot  1.079e-002+ 2.000*( 2.734e-003* 1.461e-002*cos(t)+-1.000e+000* 2.353e-003*sin(t)),  2.060e-002 +2.000*( 1.000e+000* 1.461e-002*cos(t)+ 2.734e-003* 2.353e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  6.609e-003, 2.376e-002 center
replot  6.609e-003+ 2.000*( 1.486e-003* 2.018e-002*cos(t)+-1.000e+000* 1.762e-003*sin(t)),  2.376e-002 +2.000*( 1.000e+000* 2.018e-002*cos(t)+ 1.486e-003* 1.762e-003*sin(t)) not
set out;
set out "BEFchr/VARPIJGR_BEFchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "BEFchr/VARPIJGR_BEFchr_123-13.svg"
set label "50" at  6.175e-004, 5.128e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  6.175e-004+ 2.000*( 2.531e-003* 3.230e-003*cos(t)+ 1.000e+000* 2.642e-004*sin(t)),  5.128e-003 +2.000*(-1.000e+000* 3.230e-003*cos(t)+ 2.531e-003* 2.642e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.347e-003, 6.544e-003 center
replot  1.347e-003+ 2.000*( 5.113e-003* 3.268e-003*cos(t)+ 1.000e+000* 4.874e-004*sin(t)),  6.544e-003 +2.000*(-1.000e+000* 3.268e-003*cos(t)+ 5.113e-003* 4.874e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  2.903e-003, 8.229e-003 center
replot  2.903e-003+ 2.000*( 1.020e-002* 3.276e-003*cos(t)+ 9.999e-001* 8.608e-004*sin(t)),  8.229e-003 +2.000*(-9.999e-001* 3.276e-003*cos(t)+ 1.020e-002* 8.608e-004*sin(t)) not
# Age 65, p23 - p13
set label "65" at  6.178e-003, 1.019e-002 center
replot  6.178e-003+ 2.000*( 1.705e-002* 3.570e-003*cos(t)+ 9.999e-001* 1.439e-003*sin(t)),  1.019e-002 +2.000*(-9.999e-001* 3.570e-003*cos(t)+ 1.705e-002* 1.439e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  1.296e-002, 1.242e-002 center
replot  1.296e-002+ 2.000*( 1.854e-002* 4.662e-003*cos(t)+ 9.998e-001* 2.239e-003*sin(t)),  1.242e-002 +2.000*(-9.998e-001* 4.662e-003*cos(t)+ 1.854e-002* 2.239e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  2.666e-002, 1.491e-002 center
replot  2.666e-002+ 2.000*( 1.471e-002* 6.855e-003*cos(t)+ 9.999e-001* 3.230e-003*sin(t)),  1.491e-002 +2.000*(-9.999e-001* 6.855e-003*cos(t)+ 1.471e-002* 3.230e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  5.305e-002, 1.764e-002 center
replot  5.305e-002+ 2.000*( 1.342e-002* 1.018e-002*cos(t)+ 9.999e-001* 4.842e-003*sin(t)),  1.764e-002 +2.000*(-9.999e-001* 1.018e-002*cos(t)+ 1.342e-002* 4.842e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  9.980e-002, 2.060e-002 center
replot  9.980e-002+ 2.000*( 2.003e-002* 1.461e-002*cos(t)+ 9.998e-001* 9.317e-003*sin(t)),  2.060e-002 +2.000*(-9.998e-001* 1.461e-002*cos(t)+ 2.003e-002* 9.317e-003*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.716e-001, 2.376e-002 center
replot  1.716e-001+ 2.000*( 7.509e-002* 2.019e-002*cos(t)+ 9.972e-001* 1.814e-002*sin(t)),  2.376e-002 +2.000*(-9.972e-001* 2.019e-002*cos(t)+ 7.509e-002* 1.814e-002*sin(t)) not
set out;
set out "BEFchr/VARPIJGR_BEFchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "BEFchr/VARPIJGR_BEFchr_123-21.svg"
set label "50" at  6.175e-004, 9.165e-002 center
# Age 50, p23 - p21
plot [-pi:pi]  6.175e-004+ 2.000*( 1.322e-003* 1.102e-002*cos(t)+ 1.000e+000* 2.639e-004*sin(t)),  9.165e-002 +2.000*(-1.000e+000* 1.102e-002*cos(t)+ 1.322e-003* 2.639e-004*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.347e-003, 7.124e-002 center
replot  1.347e-003+ 2.000*( 2.812e-003* 6.853e-003*cos(t)+ 1.000e+000* 4.873e-004*sin(t)),  7.124e-002 +2.000*(-1.000e+000* 6.853e-003*cos(t)+ 2.812e-003* 4.873e-004*sin(t)) not
# Age 60, p23 - p21
set label "60" at  2.903e-003, 5.468e-002 center
replot  2.903e-003+ 2.000*( 7.202e-003* 4.320e-003*cos(t)+ 1.000e+000* 8.608e-004*sin(t)),  5.468e-002 +2.000*(-1.000e+000* 4.320e-003*cos(t)+ 7.202e-003* 8.608e-004*sin(t)) not
# Age 65, p23 - p21
set label "65" at  6.178e-003, 4.145e-002 center
replot  6.178e-003+ 2.000*( 2.247e-002* 3.296e-003*cos(t)+ 9.997e-001* 1.438e-003*sin(t)),  4.145e-002 +2.000*(-9.997e-001* 3.296e-003*cos(t)+ 2.247e-002* 1.438e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  1.296e-002, 3.099e-002 center
replot  1.296e-002+ 2.000*( 7.628e-002* 3.123e-003*cos(t)+ 9.971e-001* 2.234e-003*sin(t)),  3.099e-002 +2.000*(-9.971e-001* 3.123e-003*cos(t)+ 7.628e-002* 2.234e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  2.666e-002, 2.270e-002 center
replot  2.666e-002+ 2.000*( 9.180e-001* 3.270e-003*cos(t)+ 3.966e-001* 3.012e-003*sin(t)),  2.270e-002 +2.000*(-3.966e-001* 3.270e-003*cos(t)+ 9.180e-001* 3.012e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  5.305e-002, 1.610e-002 center
replot  5.305e-002+ 2.000*( 9.982e-001* 4.850e-003*cos(t)+ 6.020e-002* 2.799e-003*sin(t)),  1.610e-002 +2.000*(-6.020e-002* 4.850e-003*cos(t)+ 9.982e-001* 2.799e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  9.980e-002, 1.079e-002 center
replot  9.980e-002+ 2.000*( 9.996e-001* 9.323e-003*cos(t)+ 2.832e-002* 2.339e-003*sin(t)),  1.079e-002 +2.000*(-2.832e-002* 9.323e-003*cos(t)+ 9.996e-001* 2.339e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.716e-001, 6.609e-003 center
replot  1.716e-001+ 2.000*( 9.998e-001* 1.815e-002*cos(t)+ 1.947e-002* 1.727e-003*sin(t)),  6.609e-003 +2.000*(-1.947e-002* 1.815e-002*cos(t)+ 9.998e-001* 1.727e-003*sin(t)) not
set out;
set out "BEFchr/VARPIJGR_BEFchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "BEFchr/VARMUPTJGR--STABLBASED_BEFchr1.svg";
 plot "BEFchr/PRMORPREV-1-STABLBASED_BEFchr.txt"  u 1:($3) not w l lt 1 
 replot "BEFchr/PRMORPREV-1-STABLBASED_BEFchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "BEFchr/PRMORPREV-1-STABLBASED_BEFchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "BEFchr/VARMUPTJGR--STABLBASED_BEFchr1.svg";replot;set out;
