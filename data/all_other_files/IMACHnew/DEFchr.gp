
# IMaCh-0.99r45
# DEFchr.gp
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


set ter svg size 640, 480;set out "DEFchr/D_DEFchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "DEFchr/ILK_DEFchr-dest.png";
set log y;plot  "DEFchr/ILK_DEFchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "DEFchr/ILK_DEFchr-ori.png";
set log y;plot  "DEFchr/ILK_DEFchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "DEFchr/ILK_DEFchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "DEFchr/ILK_DEFchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "DEFchr/ILK_DEFchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "DEFchr/ILK_DEFchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "DEFchr/V_DEFchr_1-1-1.svg" 

#set out "V_DEFchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "DEFchr/VPL_DEFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"DEFchr/VPL_DEFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"DEFchr/VPL_DEFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"DEFchr/P_DEFchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "DEFchr/V_DEFchr_2-1-1.svg" 

#set out "V_DEFchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "DEFchr/VPL_DEFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"DEFchr/VPL_DEFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"DEFchr/VPL_DEFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"DEFchr/P_DEFchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "DEFchr/E_DEFchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "DEFchr/T_DEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"DEFchr/T_DEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"DEFchr/T_DEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"DEFchr/T_DEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"DEFchr/T_DEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"DEFchr/T_DEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"DEFchr/T_DEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"DEFchr/T_DEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"DEFchr/T_DEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "DEFchr/E_DEFchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "DEFchr/EXP_DEFchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "DEFchr/E_DEFchr.txt" every :::0::0 u 1:2 t "e11" w l ,"DEFchr/E_DEFchr.txt" every :::0::0 u 1:3 t "e12" w l ,"DEFchr/E_DEFchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "DEFchr/EXP_DEFchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "DEFchr/E_DEFchr.txt" every :::0::0 u 1:5 t "e21" w l ,"DEFchr/E_DEFchr.txt" every :::0::0 u 1:6 t "e22" w l ,"DEFchr/E_DEFchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "DEFchr/LIJ_DEFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEFchr/PIJ_DEFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "DEFchr/LIJ_DEFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEFchr/PIJ_DEFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "DEFchr/LIJT_DEFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEFchr/PIJ_DEFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "DEFchr/LIJT_DEFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEFchr/PIJ_DEFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "DEFchr/P_DEFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEFchr/PIJ_DEFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "DEFchr/P_DEFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DEFchr/PIJ_DEFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-1.588670; p2=0.024944; 
#   current state 3
p3=-2.662305; p4=-0.030135; 
# initial state 2
#   current state 1
p5=0.803633; p6=-0.049115; 
#   current state 3
p7=-10.610154; p8=0.103010; 
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

set out "DEFchr/PE_DEFchr_1-1-1.svg" 
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

set out "DEFchr/PE_DEFchr_1-2-1.svg" 
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

set out "DEFchr/PE_DEFchr_1-3-1.svg" 
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
set out "DEFchr/VARPIJGR_DEFchr_113-12.svg"
set label "50" at  4.480e-003, 2.059e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  4.480e-003+ 2.000*( 2.442e-002* 2.447e-002*cos(t)+ 9.997e-001* 5.824e-003*sin(t)),  2.059e-001 +2.000*(-9.997e-001* 2.447e-002*cos(t)+ 2.442e-002* 5.824e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  3.658e-003, 2.214e-001 center
replot  3.658e-003+ 2.000*( 1.394e-002* 1.874e-002*cos(t)+ 9.999e-001* 3.328e-003*sin(t)),  2.214e-001 +2.000*(-9.999e-001* 1.874e-002*cos(t)+ 1.394e-002* 3.328e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  2.974e-003, 2.371e-001 center
replot  2.974e-003+ 2.000*( 1.050e-002* 1.478e-002*cos(t)+ 9.999e-001* 2.222e-003*sin(t)),  2.371e-001 +2.000*(-9.999e-001* 1.478e-002*cos(t)+ 1.050e-002* 2.222e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  2.409e-003, 2.529e-001 center
replot  2.409e-003+ 2.000*( 1.333e-002* 1.465e-002*cos(t)+ 9.999e-001* 2.272e-003*sin(t)),  2.529e-001 +2.000*(-9.999e-001* 1.465e-002*cos(t)+ 1.333e-002* 2.272e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.943e-003, 2.686e-001 center
replot  1.943e-003+ 2.000*( 1.324e-002* 1.848e-002*cos(t)+ 9.999e-001* 2.626e-003*sin(t)),  2.686e-001 +2.000*(-9.999e-001* 1.848e-002*cos(t)+ 1.324e-002* 2.626e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.560e-003, 2.841e-001 center
replot  1.560e-003+ 2.000*( 1.058e-002* 2.426e-002*cos(t)+ 9.999e-001* 2.868e-003*sin(t)),  2.841e-001 +2.000*(-9.999e-001* 2.426e-002*cos(t)+ 1.058e-002* 2.868e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  1.248e-003, 2.994e-001 center
replot  1.248e-003+ 2.000*( 8.070e-003* 3.058e-002*cos(t)+ 1.000e+000* 2.939e-003*sin(t)),  2.994e-001 +2.000*(-1.000e+000* 3.058e-002*cos(t)+ 8.070e-003* 2.939e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  9.950e-004, 3.143e-001 center
replot  9.950e-004+ 2.000*( 6.174e-003* 3.676e-002*cos(t)+ 1.000e+000* 2.871e-003*sin(t)),  3.143e-001 +2.000*(-1.000e+000* 3.676e-002*cos(t)+ 6.174e-003* 2.871e-003*sin(t)) not
# Age 90, p13 - p12
set label "90" at  7.901e-004, 3.287e-001 center
replot  7.901e-004+ 2.000*( 4.791e-003* 4.247e-002*cos(t)+ 1.000e+000* 2.705e-003*sin(t)),  3.287e-001 +2.000*(-1.000e+000* 4.247e-002*cos(t)+ 4.791e-003* 2.705e-003*sin(t)) not
set out;
set out "DEFchr/VARPIJGR_DEFchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "DEFchr/VARPIJGR_DEFchr_121-12.svg"
set label "50" at  8.012e-002, 2.059e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  8.012e-002+ 2.000*( 9.275e-003* 2.447e-002*cos(t)+-1.000e+000* 1.239e-002*sin(t)),  2.059e-001 +2.000*( 1.000e+000* 2.447e-002*cos(t)+ 9.275e-003* 1.239e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  6.478e-002, 2.214e-001 center
replot  6.478e-002+ 2.000*( 7.326e-003* 1.874e-002*cos(t)+-1.000e+000* 7.974e-003*sin(t)),  2.214e-001 +2.000*( 1.000e+000* 1.874e-002*cos(t)+ 7.326e-003* 7.974e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  5.193e-002, 2.371e-001 center
replot  5.193e-002+ 2.000*( 6.130e-003* 1.478e-002*cos(t)+-1.000e+000* 5.128e-003*sin(t)),  2.371e-001 +2.000*( 1.000e+000* 1.478e-002*cos(t)+ 6.130e-003* 5.128e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  4.126e-002, 2.529e-001 center
replot  4.126e-002+ 2.000*( 4.997e-003* 1.465e-002*cos(t)+-1.000e+000* 3.850e-003*sin(t)),  2.529e-001 +2.000*( 1.000e+000* 1.465e-002*cos(t)+ 4.997e-003* 3.850e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  3.247e-002, 2.686e-001 center
replot  3.247e-002+ 2.000*( 3.783e-003* 1.848e-002*cos(t)+-1.000e+000* 3.666e-003*sin(t)),  2.686e-001 +2.000*( 1.000e+000* 1.848e-002*cos(t)+ 3.783e-003* 3.666e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.524e-002, 2.841e-001 center
replot  2.524e-002+ 2.000*( 2.852e-003* 2.426e-002*cos(t)+-1.000e+000* 3.778e-003*sin(t)),  2.841e-001 +2.000*( 1.000e+000* 2.426e-002*cos(t)+ 2.852e-003* 3.778e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.930e-002, 2.994e-001 center
replot  1.930e-002+ 2.000*( 2.166e-003* 3.058e-002*cos(t)+-1.000e+000* 3.764e-003*sin(t)),  2.994e-001 +2.000*( 1.000e+000* 3.058e-002*cos(t)+ 2.166e-003* 3.764e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.442e-002, 3.143e-001 center
replot  1.442e-002+ 2.000*( 1.635e-003* 3.676e-002*cos(t)+-1.000e+000* 3.533e-003*sin(t)),  3.143e-001 +2.000*( 1.000e+000* 3.676e-002*cos(t)+ 1.635e-003* 3.533e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.042e-002, 3.287e-001 center
replot  1.042e-002+ 2.000*( 1.206e-003* 4.247e-002*cos(t)+-1.000e+000* 3.115e-003*sin(t)),  3.287e-001 +2.000*( 1.000e+000* 4.247e-002*cos(t)+ 1.206e-003* 3.115e-003*sin(t)) not
set out;
set out "DEFchr/VARPIJGR_DEFchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "DEFchr/VARPIJGR_DEFchr_123-12.svg"
set label "50" at  1.779e-003, 2.059e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  1.779e-003+ 2.000*( 8.229e-005* 2.447e-002*cos(t)+-1.000e+000* 7.948e-004*sin(t)),  2.059e-001 +2.000*( 1.000e+000* 2.447e-002*cos(t)+ 8.229e-005* 7.948e-004*sin(t)) not
# Age 55, p23 - p12
set label "55" at  3.078e-003, 2.214e-001 center
replot  3.078e-003+ 2.000*( 1.327e-004* 1.874e-002*cos(t)+-1.000e+000* 1.147e-003*sin(t)),  2.214e-001 +2.000*( 1.000e+000* 1.874e-002*cos(t)+ 1.327e-004* 1.147e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  5.278e-003, 2.371e-001 center
replot  5.278e-003+ 2.000*( 1.607e-004* 1.478e-002*cos(t)+-1.000e+000* 1.587e-003*sin(t)),  2.371e-001 +2.000*( 1.000e+000* 1.478e-002*cos(t)+ 1.607e-004* 1.587e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  8.973e-003, 2.529e-001 center
replot  8.973e-003+ 2.000*( 8.439e-005* 1.465e-002*cos(t)+-1.000e+000* 2.089e-003*sin(t)),  2.529e-001 +2.000*( 1.000e+000* 1.465e-002*cos(t)+ 8.439e-005* 2.089e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  1.511e-002, 2.686e-001 center
replot  1.511e-002+ 2.000*( 4.313e-005* 1.848e-002*cos(t)+-1.000e+000* 2.624e-003*sin(t)),  2.686e-001 +2.000*( 1.000e+000* 1.848e-002*cos(t)+ 4.313e-005* 2.624e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  2.513e-002, 2.841e-001 center
replot  2.513e-002+ 2.000*( 1.294e-004* 2.426e-002*cos(t)+-1.000e+000* 3.370e-003*sin(t)),  2.841e-001 +2.000*( 1.000e+000* 2.426e-002*cos(t)+ 1.294e-004* 3.370e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  4.112e-002, 2.994e-001 center
replot  4.112e-002+ 2.000*( 3.297e-004* 3.058e-002*cos(t)+-1.000e+000* 5.312e-003*sin(t)),  2.994e-001 +2.000*( 1.000e+000* 3.058e-002*cos(t)+ 3.297e-004* 5.312e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  6.573e-002, 3.143e-001 center
replot  6.573e-002+ 2.000*( 6.758e-004* 3.676e-002*cos(t)+-1.000e+000* 1.016e-002*sin(t)),  3.143e-001 +2.000*( 1.000e+000* 3.676e-002*cos(t)+ 6.758e-004* 1.016e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.017e-001, 3.287e-001 center
replot  1.017e-001+ 2.000*( 1.299e-003* 4.247e-002*cos(t)+-1.000e+000* 1.909e-002*sin(t)),  3.287e-001 +2.000*( 1.000e+000* 4.247e-002*cos(t)+ 1.299e-003* 1.909e-002*sin(t)) not
set out;
set out "DEFchr/VARPIJGR_DEFchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "DEFchr/VARPIJGR_DEFchr_121-13.svg"
set label "50" at  8.012e-002, 4.480e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  8.012e-002+ 2.000*( 1.000e+000* 1.239e-002*cos(t)+-7.590e-003* 5.853e-003*sin(t)),  4.480e-003 +2.000*( 7.590e-003* 1.239e-002*cos(t)+ 1.000e+000* 5.853e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  6.478e-002, 3.658e-003 center
replot  6.478e-002+ 2.000*( 1.000e+000* 7.975e-003*cos(t)+-7.058e-003* 3.338e-003*sin(t)),  3.658e-003 +2.000*( 7.058e-003* 7.975e-003*cos(t)+ 1.000e+000* 3.338e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  5.193e-002, 2.974e-003 center
replot  5.193e-002+ 2.000*( 1.000e+000* 5.129e-003*cos(t)+-6.573e-003* 2.227e-003*sin(t)),  2.974e-003 +2.000*( 6.573e-003* 5.129e-003*cos(t)+ 1.000e+000* 2.227e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  4.126e-002, 2.409e-003 center
replot  4.126e-002+ 2.000*( 1.000e+000* 3.851e-003*cos(t)+-6.179e-003* 2.280e-003*sin(t)),  2.409e-003 +2.000*( 6.179e-003* 3.851e-003*cos(t)+ 1.000e+000* 2.280e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  3.247e-002, 1.943e-003 center
replot  3.247e-002+ 2.000*( 1.000e+000* 3.667e-003*cos(t)+-6.516e-003* 2.637e-003*sin(t)),  1.943e-003 +2.000*( 6.516e-003* 3.667e-003*cos(t)+ 1.000e+000* 2.637e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.524e-002, 1.560e-003 center
replot  2.524e-002+ 2.000*( 1.000e+000* 3.778e-003*cos(t)+-7.796e-003* 2.879e-003*sin(t)),  1.560e-003 +2.000*( 7.796e-003* 3.778e-003*cos(t)+ 1.000e+000* 2.879e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.930e-002, 1.248e-003 center
replot  1.930e-002+ 2.000*( 9.999e-001* 3.764e-003*cos(t)+-1.001e-002* 2.949e-003*sin(t)),  1.248e-003 +2.000*( 1.001e-002* 3.764e-003*cos(t)+ 9.999e-001* 2.949e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.442e-002, 9.950e-004 center
replot  1.442e-002+ 2.000*( 9.999e-001* 3.533e-003*cos(t)+-1.440e-002* 2.880e-003*sin(t)),  9.950e-004 +2.000*( 1.440e-002* 3.533e-003*cos(t)+ 9.999e-001* 2.880e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.042e-002, 7.901e-004 center
replot  1.042e-002+ 2.000*( 9.997e-001* 3.116e-003*cos(t)+-2.625e-002* 2.713e-003*sin(t)),  7.901e-004 +2.000*( 2.625e-002* 3.116e-003*cos(t)+ 9.997e-001* 2.713e-003*sin(t)) not
set out;
set out "DEFchr/VARPIJGR_DEFchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "DEFchr/VARPIJGR_DEFchr_123-13.svg"
set label "50" at  1.779e-003, 4.480e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  1.779e-003+ 2.000*( 4.240e-003* 5.853e-003*cos(t)+ 1.000e+000* 7.944e-004*sin(t)),  4.480e-003 +2.000*(-1.000e+000* 5.853e-003*cos(t)+ 4.240e-003* 7.944e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  3.078e-003, 3.658e-003 center
replot  3.078e-003+ 2.000*( 1.294e-002* 3.339e-003*cos(t)+ 9.999e-001* 1.146e-003*sin(t)),  3.658e-003 +2.000*(-9.999e-001* 3.339e-003*cos(t)+ 1.294e-002* 1.146e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  5.278e-003, 2.974e-003 center
replot  5.278e-003+ 2.000*( 4.157e-002* 2.228e-003*cos(t)+ 9.991e-001* 1.586e-003*sin(t)),  2.974e-003 +2.000*(-9.991e-001* 2.228e-003*cos(t)+ 4.157e-002* 1.586e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  8.973e-003, 2.409e-003 center
replot  8.973e-003+ 2.000*( 8.695e-002* 2.281e-003*cos(t)+ 9.962e-001* 2.088e-003*sin(t)),  2.409e-003 +2.000*(-9.962e-001* 2.281e-003*cos(t)+ 8.695e-002* 2.088e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  1.511e-002, 1.943e-003 center
replot  1.511e-002+ 2.000*( 4.934e-001* 2.644e-003*cos(t)+ 8.698e-001* 2.617e-003*sin(t)),  1.943e-003 +2.000*(-8.698e-001* 2.644e-003*cos(t)+ 4.934e-001* 2.617e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  2.513e-002, 1.560e-003 center
replot  2.513e-002+ 2.000*( 9.996e-001* 3.371e-003*cos(t)+ 2.866e-002* 2.879e-003*sin(t)),  1.560e-003 +2.000*(-2.866e-002* 3.371e-003*cos(t)+ 9.996e-001* 2.879e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  4.112e-002, 1.248e-003 center
replot  4.112e-002+ 2.000*( 9.999e-001* 5.312e-003*cos(t)+ 1.049e-002* 2.949e-003*sin(t)),  1.248e-003 +2.000*(-1.049e-002* 5.312e-003*cos(t)+ 9.999e-001* 2.949e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  6.573e-002, 9.950e-004 center
replot  6.573e-002+ 2.000*( 1.000e+000* 1.016e-002*cos(t)+ 4.785e-003* 2.880e-003*sin(t)),  9.950e-004 +2.000*(-4.785e-003* 1.016e-002*cos(t)+ 1.000e+000* 2.880e-003*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.017e-001, 7.901e-004 center
replot  1.017e-001+ 2.000*( 1.000e+000* 1.909e-002*cos(t)+ 2.388e-003* 2.713e-003*sin(t)),  7.901e-004 +2.000*(-2.388e-003* 1.909e-002*cos(t)+ 1.000e+000* 2.713e-003*sin(t)) not
set out;
set out "DEFchr/VARPIJGR_DEFchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "DEFchr/VARPIJGR_DEFchr_123-21.svg"
set label "50" at  1.779e-003, 8.012e-002 center
# Age 50, p23 - p21
plot [-pi:pi]  1.779e-003+ 2.000*( 3.420e-003* 1.239e-002*cos(t)+ 1.000e+000* 7.937e-004*sin(t)),  8.012e-002 +2.000*(-1.000e+000* 1.239e-002*cos(t)+ 3.420e-003* 7.937e-004*sin(t)) not
# Age 55, p23 - p21
set label "55" at  3.078e-003, 6.478e-002 center
replot  3.078e-003+ 2.000*( 6.245e-003* 7.975e-003*cos(t)+ 1.000e+000* 1.146e-003*sin(t)),  6.478e-002 +2.000*(-1.000e+000* 7.975e-003*cos(t)+ 6.245e-003* 1.146e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  5.278e-003, 5.193e-002 center
replot  5.278e-003+ 2.000*( 1.403e-002* 5.129e-003*cos(t)+ 9.999e-001* 1.586e-003*sin(t)),  5.193e-002 +2.000*(-9.999e-001* 5.129e-003*cos(t)+ 1.403e-002* 1.586e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  8.973e-003, 4.126e-002 center
replot  8.973e-003+ 2.000*( 3.559e-002* 3.853e-003*cos(t)+ 9.994e-001* 2.086e-003*sin(t)),  4.126e-002 +2.000*(-9.994e-001* 3.853e-003*cos(t)+ 3.559e-002* 2.086e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  1.511e-002, 3.247e-002 center
replot  1.511e-002+ 2.000*( 7.298e-002* 3.672e-003*cos(t)+ 9.973e-001* 2.617e-003*sin(t)),  3.247e-002 +2.000*(-9.973e-001* 3.672e-003*cos(t)+ 7.298e-002* 2.617e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  2.513e-002, 2.524e-002 center
replot  2.513e-002+ 2.000*( 2.111e-001* 3.797e-003*cos(t)+ 9.775e-001* 3.349e-003*sin(t)),  2.524e-002 +2.000*(-9.775e-001* 3.797e-003*cos(t)+ 2.111e-001* 3.349e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  4.112e-002, 1.930e-002 center
replot  4.112e-002+ 2.000*( 9.965e-001* 5.321e-003*cos(t)+ 8.357e-002* 3.751e-003*sin(t)),  1.930e-002 +2.000*(-8.357e-002* 5.321e-003*cos(t)+ 9.965e-001* 3.751e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  6.573e-002, 1.442e-002 center
replot  6.573e-002+ 2.000*( 9.994e-001* 1.017e-002*cos(t)+ 3.463e-002* 3.518e-003*sin(t)),  1.442e-002 +2.000*(-3.463e-002* 1.017e-002*cos(t)+ 9.994e-001* 3.518e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.017e-001, 1.042e-002 center
replot  1.017e-001+ 2.000*( 9.997e-001* 1.910e-002*cos(t)+ 2.454e-002* 3.081e-003*sin(t)),  1.042e-002 +2.000*(-2.454e-002* 1.910e-002*cos(t)+ 9.997e-001* 3.081e-003*sin(t)) not
set out;
set out "DEFchr/VARPIJGR_DEFchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "DEFchr/VARMUPTJGR--STABLBASED_DEFchr1.svg";
 plot "DEFchr/PRMORPREV-1-STABLBASED_DEFchr.txt"  u 1:($3) not w l lt 1 
 replot "DEFchr/PRMORPREV-1-STABLBASED_DEFchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "DEFchr/PRMORPREV-1-STABLBASED_DEFchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "DEFchr/VARMUPTJGR--STABLBASED_DEFchr1.svg";replot;set out;
