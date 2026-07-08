
# IMaCh-0.99r45
# PLFgali.gp
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


set ter svg size 640, 480;set out "PLFgali/D_PLFgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "PLFgali/ILK_PLFgali-dest.png";
set log y;plot  "PLFgali/ILK_PLFgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "PLFgali/ILK_PLFgali-ori.png";
set log y;plot  "PLFgali/ILK_PLFgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "PLFgali/ILK_PLFgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "PLFgali/ILK_PLFgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "PLFgali/ILK_PLFgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "PLFgali/ILK_PLFgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "PLFgali/V_PLFgali_1-1-1.svg" 

#set out "V_PLFgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "PLFgali/VPL_PLFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"PLFgali/VPL_PLFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"PLFgali/VPL_PLFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"PLFgali/P_PLFgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "PLFgali/V_PLFgali_2-1-1.svg" 

#set out "V_PLFgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "PLFgali/VPL_PLFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"PLFgali/VPL_PLFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"PLFgali/VPL_PLFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"PLFgali/P_PLFgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "PLFgali/E_PLFgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "PLFgali/T_PLFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"PLFgali/T_PLFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"PLFgali/T_PLFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"PLFgali/T_PLFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"PLFgali/T_PLFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"PLFgali/T_PLFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"PLFgali/T_PLFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"PLFgali/T_PLFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"PLFgali/T_PLFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "PLFgali/E_PLFgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "PLFgali/EXP_PLFgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "PLFgali/E_PLFgali.txt" every :::0::0 u 1:2 t "e11" w l ,"PLFgali/E_PLFgali.txt" every :::0::0 u 1:3 t "e12" w l ,"PLFgali/E_PLFgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "PLFgali/EXP_PLFgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "PLFgali/E_PLFgali.txt" every :::0::0 u 1:5 t "e21" w l ,"PLFgali/E_PLFgali.txt" every :::0::0 u 1:6 t "e22" w l ,"PLFgali/E_PLFgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "PLFgali/LIJ_PLFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFgali/PIJ_PLFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "PLFgali/LIJ_PLFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFgali/PIJ_PLFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "PLFgali/LIJT_PLFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFgali/PIJ_PLFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "PLFgali/LIJT_PLFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFgali/PIJ_PLFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "PLFgali/P_PLFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFgali/PIJ_PLFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "PLFgali/P_PLFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLFgali/PIJ_PLFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-6.808667; p2=0.057879; 
#   current state 3
p3=-13.465774; p4=0.119578; 
# initial state 2
#   current state 1
p5=1.601606; p6=-0.047545; 
#   current state 3
p7=-7.840524; p8=0.068999; 
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

set out "PLFgali/PE_PLFgali_1-1-1.svg" 
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

set out "PLFgali/PE_PLFgali_1-2-1.svg" 
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

set out "PLFgali/PE_PLFgali_1-3-1.svg" 
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
set out "PLFgali/VARPIJGR_PLFgali_113-12.svg"
set label "50" at  1.098e-003, 3.909e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  1.098e-003+ 2.000*( 2.601e-002* 1.092e-002*cos(t)+ 9.997e-001* 1.200e-003*sin(t)),  3.909e-002 +2.000*(-9.997e-001* 1.092e-002*cos(t)+ 2.601e-002* 1.200e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.983e-003, 5.185e-002 center
replot  1.983e-003+ 2.000*( 3.590e-002* 1.159e-002*cos(t)+ 9.994e-001* 1.801e-003*sin(t)),  5.185e-002 +2.000*(-9.994e-001* 1.159e-002*cos(t)+ 3.590e-002* 1.801e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  3.572e-003, 6.859e-002 center
replot  3.572e-003+ 2.000*( 4.901e-002* 1.186e-002*cos(t)+ 9.988e-001* 2.605e-003*sin(t)),  6.859e-002 +2.000*(-9.988e-001* 1.186e-002*cos(t)+ 4.901e-002* 2.605e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  6.411e-003, 9.044e-002 center
replot  6.411e-003+ 2.000*( 6.364e-002* 1.202e-002*cos(t)+ 9.980e-001* 3.602e-003*sin(t)),  9.044e-002 +2.000*(-9.980e-001* 1.202e-002*cos(t)+ 6.364e-002* 3.602e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.145e-002, 1.187e-001 center
replot  1.145e-002+ 2.000*( 7.455e-002* 1.350e-002*cos(t)+ 9.972e-001* 4.799e-003*sin(t)),  1.187e-001 +2.000*(-9.972e-001* 1.350e-002*cos(t)+ 7.455e-002* 4.799e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.033e-002, 1.547e-001 center
replot  2.033e-002+ 2.000*( 9.773e-002* 1.913e-002*cos(t)+ 9.952e-001* 6.767e-003*sin(t)),  1.547e-001 +2.000*(-9.952e-001* 1.913e-002*cos(t)+ 9.773e-002* 6.767e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.573e-002, 1.998e-001 center
replot  3.573e-002+ 2.000*( 1.656e-001* 3.120e-002*cos(t)+ 9.862e-001* 1.227e-002*sin(t)),  1.998e-001 +2.000*(-9.862e-001* 3.120e-002*cos(t)+ 1.656e-001* 1.227e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  6.199e-002, 2.546e-001 center
replot  6.199e-002+ 2.000*( 3.154e-001* 5.170e-002*cos(t)+ 9.490e-001* 2.621e-002*sin(t)),  2.546e-001 +2.000*(-9.490e-001* 5.170e-002*cos(t)+ 3.154e-001* 2.621e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.055e-001, 3.184e-001 center
replot  1.055e-001+ 2.000*( 5.881e-001* 8.759e-002*cos(t)+ 8.088e-001* 5.118e-002*sin(t)),  3.184e-001 +2.000*(-8.088e-001* 8.759e-002*cos(t)+ 5.881e-001* 5.118e-002*sin(t)) not
set out;
set out "PLFgali/VARPIJGR_PLFgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "PLFgali/VARPIJGR_PLFgali_121-12.svg"
set label "50" at  6.252e-001, 3.909e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  6.252e-001+ 2.000*( 9.996e-001* 1.590e-001*cos(t)+-2.860e-002* 9.928e-003*sin(t)),  3.909e-002 +2.000*( 2.860e-002* 1.590e-001*cos(t)+ 9.996e-001* 9.928e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  5.259e-001, 5.185e-002 center
replot  5.259e-001+ 2.000*( 9.991e-001* 1.150e-001*cos(t)+-4.243e-002* 1.051e-002*sin(t)),  5.185e-002 +2.000*( 4.243e-002* 1.150e-001*cos(t)+ 9.991e-001* 1.051e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  4.366e-001, 6.859e-002 center
replot  4.366e-001+ 2.000*( 9.979e-001* 7.897e-002*cos(t)+-6.414e-002* 1.073e-002*sin(t)),  6.859e-002 +2.000*( 6.414e-002* 7.897e-002*cos(t)+ 9.979e-001* 1.073e-002*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.580e-001, 9.044e-002 center
replot  3.580e-001+ 2.000*( 9.953e-001* 5.362e-002*cos(t)+-9.663e-002* 1.087e-002*sin(t)),  9.044e-002 +2.000*( 9.663e-002* 5.362e-002*cos(t)+ 9.953e-001* 1.087e-002*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.899e-001, 1.187e-001 center
replot  2.899e-001+ 2.000*( 9.900e-001* 4.103e-002*cos(t)+-1.411e-001* 1.228e-002*sin(t)),  1.187e-001 +2.000*( 1.411e-001* 4.103e-002*cos(t)+ 9.900e-001* 1.228e-002*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.319e-001, 1.547e-001 center
replot  2.319e-001+ 2.000*( 9.751e-001* 3.911e-002*cos(t)+-2.218e-001* 1.740e-002*sin(t)),  1.547e-001 +2.000*( 2.218e-001* 3.911e-002*cos(t)+ 9.751e-001* 1.740e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.830e-001, 1.998e-001 center
replot  1.830e-001+ 2.000*( 8.929e-001* 4.235e-002*cos(t)+-4.502e-001* 2.714e-002*sin(t)),  1.998e-001 +2.000*( 4.502e-001* 4.235e-002*cos(t)+ 8.929e-001* 2.714e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.422e-001, 2.546e-001 center
replot  1.422e-001+ 2.000*( 4.820e-001* 5.330e-002*cos(t)+-8.762e-001* 3.561e-002*sin(t)),  2.546e-001 +2.000*( 8.762e-001* 5.330e-002*cos(t)+ 4.820e-001* 3.561e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.087e-001, 3.184e-001 center
replot  1.087e-001+ 2.000*( 1.954e-001* 7.814e-002*cos(t)+-9.807e-001* 3.675e-002*sin(t)),  3.184e-001 +2.000*( 9.807e-001* 7.814e-002*cos(t)+ 1.954e-001* 3.675e-002*sin(t)) not
set out;
set out "PLFgali/VARPIJGR_PLFgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "PLFgali/VARPIJGR_PLFgali_123-12.svg"
set label "50" at  1.683e-002, 3.909e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  1.683e-002+ 2.000*( 9.442e-001* 1.331e-002*cos(t)+-3.294e-001* 1.059e-002*sin(t)),  3.909e-002 +2.000*( 3.294e-001* 1.331e-002*cos(t)+ 9.442e-001* 1.059e-002*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.535e-002, 5.185e-002 center
replot  2.535e-002+ 2.000*( 9.805e-001* 1.659e-002*cos(t)+-1.963e-001* 1.134e-002*sin(t)),  5.185e-002 +2.000*( 1.963e-001* 1.659e-002*cos(t)+ 9.805e-001* 1.134e-002*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.770e-002, 6.859e-002 center
replot  3.770e-002+ 2.000*( 9.907e-001* 1.985e-002*cos(t)+-1.359e-001* 1.165e-002*sin(t)),  6.859e-002 +2.000*( 1.359e-001* 1.985e-002*cos(t)+ 9.907e-001* 1.165e-002*sin(t)) not
# Age 65, p23 - p12
set label "65" at  5.536e-002, 9.044e-002 center
replot  5.536e-002+ 2.000*( 9.948e-001* 2.246e-002*cos(t)+-1.015e-001* 1.184e-002*sin(t)),  9.044e-002 +2.000*( 1.015e-001* 2.246e-002*cos(t)+ 9.948e-001* 1.184e-002*sin(t)) not
# Age 70, p23 - p12
set label "70" at  8.029e-002, 1.187e-001 center
replot  8.029e-002+ 2.000*( 9.958e-001* 2.373e-002*cos(t)+-9.121e-002* 1.335e-002*sin(t)),  1.187e-001 +2.000*( 9.121e-002* 2.373e-002*cos(t)+ 9.958e-001* 1.335e-002*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.150e-001, 1.547e-001 center
replot  1.150e-001+ 2.000*( 9.760e-001* 2.409e-002*cos(t)+-2.179e-001* 1.877e-002*sin(t)),  1.547e-001 +2.000*( 2.179e-001* 2.409e-002*cos(t)+ 9.760e-001* 1.877e-002*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.625e-001, 1.998e-001 center
replot  1.625e-001+ 2.000*( 5.187e-001* 3.231e-002*cos(t)+-8.549e-001* 2.642e-002*sin(t)),  1.998e-001 +2.000*( 8.549e-001* 3.231e-002*cos(t)+ 5.187e-001* 2.642e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  2.263e-001, 2.546e-001 center
replot  2.263e-001+ 2.000*( 6.279e-001* 5.420e-002*cos(t)+-7.783e-001* 4.203e-002*sin(t)),  2.546e-001 +2.000*( 7.783e-001* 5.420e-002*cos(t)+ 6.279e-001* 4.203e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  3.097e-001, 3.184e-001 center
replot  3.097e-001+ 2.000*( 8.265e-001* 9.321e-002*cos(t)+-5.630e-001* 6.813e-002*sin(t)),  3.184e-001 +2.000*( 5.630e-001* 9.321e-002*cos(t)+ 8.265e-001* 6.813e-002*sin(t)) not
set out;
set out "PLFgali/VARPIJGR_PLFgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "PLFgali/VARPIJGR_PLFgali_121-13.svg"
set label "50" at  6.252e-001, 1.098e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  6.252e-001+ 2.000*( 1.000e+000* 1.590e-001*cos(t)+-2.061e-004* 1.232e-003*sin(t)),  1.098e-003 +2.000*( 2.061e-004* 1.590e-001*cos(t)+ 1.000e+000* 1.232e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  5.259e-001, 1.983e-003 center
replot  5.259e-001+ 2.000*( 1.000e+000* 1.149e-001*cos(t)+-4.694e-004* 1.847e-003*sin(t)),  1.983e-003 +2.000*( 4.694e-004* 1.149e-001*cos(t)+ 1.000e+000* 1.847e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  4.366e-001, 3.572e-003 center
replot  4.366e-001+ 2.000*( 1.000e+000* 7.881e-002*cos(t)+-1.133e-003* 2.665e-003*sin(t)),  3.572e-003 +2.000*( 1.133e-003* 7.881e-002*cos(t)+ 1.000e+000* 2.665e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.580e-001, 6.411e-003 center
replot  3.580e-001+ 2.000*( 1.000e+000* 5.338e-002*cos(t)+-2.705e-003* 3.673e-003*sin(t)),  6.411e-003 +2.000*( 2.705e-003* 5.338e-002*cos(t)+ 1.000e+000* 3.673e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.899e-001, 1.145e-002 center
replot  2.899e-001+ 2.000*( 1.000e+000* 4.065e-002*cos(t)+-5.318e-003* 4.886e-003*sin(t)),  1.145e-002 +2.000*( 5.318e-003* 4.065e-002*cos(t)+ 1.000e+000* 4.886e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.319e-001, 2.033e-002 center
replot  2.319e-001+ 2.000*( 1.000e+000* 3.833e-002*cos(t)+-8.846e-003* 6.982e-003*sin(t)),  2.033e-002 +2.000*( 8.846e-003* 3.833e-002*cos(t)+ 1.000e+000* 6.982e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.830e-001, 3.573e-002 center
replot  1.830e-001+ 2.000*( 9.998e-001* 3.974e-002*cos(t)+-2.004e-002* 1.313e-002*sin(t)),  3.573e-002 +2.000*( 2.004e-002* 3.974e-002*cos(t)+ 9.998e-001* 1.313e-002*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.422e-001, 6.199e-002 center
replot  1.422e-001+ 2.000*( 9.945e-001* 4.052e-002*cos(t)+-1.049e-001* 2.960e-002*sin(t)),  6.199e-002 +2.000*( 1.049e-001* 4.052e-002*cos(t)+ 9.945e-001* 2.960e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.087e-001, 1.055e-001 center
replot  1.087e-001+ 2.000*( 7.783e-002* 6.621e-002*cos(t)+-9.970e-001* 3.892e-002*sin(t)),  1.055e-001 +2.000*( 9.970e-001* 6.621e-002*cos(t)+ 7.783e-002* 3.892e-002*sin(t)) not
set out;
set out "PLFgali/VARPIJGR_PLFgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "PLFgali/VARPIJGR_PLFgali_123-13.svg"
set label "50" at  1.683e-002, 1.098e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  1.683e-002+ 2.000*( 9.988e-001* 1.306e-002*cos(t)+ 4.933e-002* 1.053e-003*sin(t)),  1.098e-003 +2.000*(-4.933e-002* 1.306e-002*cos(t)+ 9.988e-001* 1.053e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.535e-002, 1.983e-003 center
replot  2.535e-002+ 2.000*( 9.983e-001* 1.645e-002*cos(t)+ 5.857e-002* 1.579e-003*sin(t)),  1.983e-003 +2.000*(-5.857e-002* 1.645e-002*cos(t)+ 9.983e-001* 1.579e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.770e-002, 3.572e-003 center
replot  3.770e-002+ 2.000*( 9.976e-001* 1.978e-002*cos(t)+ 6.974e-002* 2.287e-003*sin(t)),  3.572e-003 +2.000*(-6.974e-002* 1.978e-002*cos(t)+ 9.976e-001* 2.287e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  5.536e-002, 6.411e-003 center
replot  5.536e-002+ 2.000*( 9.966e-001* 2.245e-002*cos(t)+ 8.287e-002* 3.181e-003*sin(t)),  6.411e-003 +2.000*(-8.287e-002* 2.245e-002*cos(t)+ 9.966e-001* 3.181e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  8.029e-002, 1.145e-002 center
replot  8.029e-002+ 2.000*( 9.952e-001* 2.377e-002*cos(t)+ 9.805e-002* 4.320e-003*sin(t)),  1.145e-002 +2.000*(-9.805e-002* 2.377e-002*cos(t)+ 9.952e-001* 4.320e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.150e-001, 2.033e-002 center
replot  1.150e-001+ 2.000*( 9.924e-001* 2.403e-002*cos(t)+ 1.228e-001* 6.384e-003*sin(t)),  2.033e-002 +2.000*(-1.228e-001* 2.403e-002*cos(t)+ 9.924e-001* 6.384e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.625e-001, 3.573e-002 center
replot  1.625e-001+ 2.000*( 9.777e-001* 2.865e-002*cos(t)+ 2.099e-001* 1.196e-002*sin(t)),  3.573e-002 +2.000*(-2.099e-001* 2.865e-002*cos(t)+ 9.777e-001* 1.196e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  2.263e-001, 6.199e-002 center
replot  2.263e-001+ 2.000*( 9.328e-001* 4.964e-002*cos(t)+ 3.604e-001* 2.547e-002*sin(t)),  6.199e-002 +2.000*(-3.604e-001* 4.964e-002*cos(t)+ 9.328e-001* 2.547e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  3.097e-001, 1.055e-001 center
replot  3.097e-001+ 2.000*( 8.638e-001* 9.472e-002*cos(t)+ 5.038e-001* 5.291e-002*sin(t)),  1.055e-001 +2.000*(-5.038e-001* 9.472e-002*cos(t)+ 8.638e-001* 5.291e-002*sin(t)) not
set out;
set out "PLFgali/VARPIJGR_PLFgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "PLFgali/VARPIJGR_PLFgali_123-21.svg"
set label "50" at  1.683e-002, 6.252e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.683e-002+ 2.000*( 8.905e-003* 1.590e-001*cos(t)+ 1.000e+000* 1.297e-002*sin(t)),  6.252e-001 +2.000*(-1.000e+000* 1.590e-001*cos(t)+ 8.905e-003* 1.297e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.535e-002, 5.259e-001 center
replot  2.535e-002+ 2.000*( 1.283e-002* 1.149e-001*cos(t)+ 9.999e-001* 1.635e-002*sin(t)),  5.259e-001 +2.000*(-9.999e-001* 1.149e-001*cos(t)+ 1.283e-002* 1.635e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.770e-002, 4.366e-001 center
replot  3.770e-002+ 2.000*( 2.045e-002* 7.882e-002*cos(t)+ 9.998e-001* 1.967e-002*sin(t)),  4.366e-001 +2.000*(-9.998e-001* 7.882e-002*cos(t)+ 2.045e-002* 1.967e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  5.536e-002, 3.580e-001 center
replot  5.536e-002+ 2.000*( 3.824e-002* 5.341e-002*cos(t)+ 9.993e-001* 2.230e-002*sin(t)),  3.580e-001 +2.000*(-9.993e-001* 5.341e-002*cos(t)+ 3.824e-002* 2.230e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  8.029e-002, 2.899e-001 center
replot  8.029e-002+ 2.000*( 6.995e-002* 4.072e-002*cos(t)+ 9.976e-001* 2.354e-002*sin(t)),  2.899e-001 +2.000*(-9.976e-001* 4.072e-002*cos(t)+ 6.995e-002* 2.354e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.150e-001, 2.319e-001 center
replot  1.150e-001+ 2.000*( 8.406e-002* 3.841e-002*cos(t)+ 9.965e-001* 2.372e-002*sin(t)),  2.319e-001 +2.000*(-9.965e-001* 3.841e-002*cos(t)+ 8.406e-002* 2.372e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.625e-001, 1.830e-001 center
replot  1.625e-001+ 2.000*( 1.227e-001* 3.989e-002*cos(t)+ 9.924e-001* 2.790e-002*sin(t)),  1.830e-001 +2.000*(-9.924e-001* 3.989e-002*cos(t)+ 1.227e-001* 2.790e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  2.263e-001, 1.422e-001 center
replot  2.263e-001+ 2.000*( 9.597e-001* 4.779e-002*cos(t)+ 2.811e-001* 3.972e-002*sin(t)),  1.422e-001 +2.000*(-2.811e-001* 4.779e-002*cos(t)+ 9.597e-001* 3.972e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  3.097e-001, 1.087e-001 center
replot  3.097e-001+ 2.000*( 9.972e-001* 8.625e-002*cos(t)+ 7.459e-002* 3.871e-002*sin(t)),  1.087e-001 +2.000*(-7.459e-002* 8.625e-002*cos(t)+ 9.972e-001* 3.871e-002*sin(t)) not
set out;
set out "PLFgali/VARPIJGR_PLFgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "PLFgali/VARMUPTJGR--STABLBASED_PLFgali1.svg";
 plot "PLFgali/PRMORPREV-1-STABLBASED_PLFgali.txt"  u 1:($3) not w l lt 1 
 replot "PLFgali/PRMORPREV-1-STABLBASED_PLFgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "PLFgali/PRMORPREV-1-STABLBASED_PLFgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "PLFgali/VARMUPTJGR--STABLBASED_PLFgali1.svg";replot;set out;
