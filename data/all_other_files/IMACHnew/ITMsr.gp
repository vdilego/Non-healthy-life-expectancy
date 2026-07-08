
# IMaCh-0.99r45
# ITMsr.gp
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


set ter svg size 640, 480;set out "ITMsr/D_ITMsr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "ITMsr/ILK_ITMsr-dest.png";
set log y;plot  "ITMsr/ILK_ITMsr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "ITMsr/ILK_ITMsr-ori.png";
set log y;plot  "ITMsr/ILK_ITMsr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "ITMsr/ILK_ITMsr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ITMsr/ILK_ITMsr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "ITMsr/ILK_ITMsr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ITMsr/ILK_ITMsr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "ITMsr/V_ITMsr_1-1-1.svg" 

#set out "V_ITMsr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ITMsr/VPL_ITMsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"ITMsr/VPL_ITMsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"ITMsr/VPL_ITMsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"ITMsr/P_ITMsr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "ITMsr/V_ITMsr_2-1-1.svg" 

#set out "V_ITMsr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ITMsr/VPL_ITMsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"ITMsr/VPL_ITMsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"ITMsr/VPL_ITMsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"ITMsr/P_ITMsr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "ITMsr/E_ITMsr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "ITMsr/T_ITMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"ITMsr/T_ITMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"ITMsr/T_ITMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"ITMsr/T_ITMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"ITMsr/T_ITMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"ITMsr/T_ITMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"ITMsr/T_ITMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"ITMsr/T_ITMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"ITMsr/T_ITMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "ITMsr/E_ITMsr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "ITMsr/EXP_ITMsr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ITMsr/E_ITMsr.txt" every :::0::0 u 1:2 t "e11" w l ,"ITMsr/E_ITMsr.txt" every :::0::0 u 1:3 t "e12" w l ,"ITMsr/E_ITMsr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "ITMsr/EXP_ITMsr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ITMsr/E_ITMsr.txt" every :::0::0 u 1:5 t "e21" w l ,"ITMsr/E_ITMsr.txt" every :::0::0 u 1:6 t "e22" w l ,"ITMsr/E_ITMsr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "ITMsr/LIJ_ITMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMsr/PIJ_ITMsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "ITMsr/LIJ_ITMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMsr/PIJ_ITMsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "ITMsr/LIJT_ITMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMsr/PIJ_ITMsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "ITMsr/LIJT_ITMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMsr/PIJ_ITMsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "ITMsr/P_ITMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMsr/PIJ_ITMsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "ITMsr/P_ITMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMsr/PIJ_ITMsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-5.886854; p2=0.049987; 
#   current state 3
p3=-13.783381; p4=0.121601; 
# initial state 2
#   current state 1
p5=-1.213585; p6=-0.015458; 
#   current state 3
p7=-11.649677; p8=0.106008; 
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

set out "ITMsr/PE_ITMsr_1-1-1.svg" 
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

set out "ITMsr/PE_ITMsr_1-2-1.svg" 
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

set out "ITMsr/PE_ITMsr_1-3-1.svg" 
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
set out "ITMsr/VARPIJGR_ITMsr_113-12.svg"
set label "50" at  8.728e-004, 6.535e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  8.728e-004+ 2.000*( 7.093e-003* 9.566e-003*cos(t)+ 1.000e+000* 6.964e-004*sin(t)),  6.535e-002 +2.000*(-1.000e+000* 9.566e-003*cos(t)+ 7.093e-003* 6.964e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.588e-003, 8.310e-002 center
replot  1.588e-003+ 2.000*( 9.596e-003* 9.523e-003*cos(t)+ 1.000e+000* 1.046e-003*sin(t)),  8.310e-002 +2.000*(-1.000e+000* 9.523e-003*cos(t)+ 9.596e-003* 1.046e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  2.880e-003, 1.054e-001 center
replot  2.880e-003+ 2.000*( 1.279e-002* 9.205e-003*cos(t)+ 9.999e-001* 1.516e-003*sin(t)),  1.054e-001 +2.000*(-9.999e-001* 9.205e-003*cos(t)+ 1.279e-002* 1.516e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  5.206e-003, 1.332e-001 center
replot  5.206e-003+ 2.000*( 1.885e-002* 9.236e-003*cos(t)+ 9.998e-001* 2.127e-003*sin(t)),  1.332e-001 +2.000*(-9.998e-001* 9.236e-003*cos(t)+ 1.885e-002* 2.127e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  9.366e-003, 1.674e-001 center
replot  9.366e-003+ 2.000*( 3.665e-002* 1.124e-002*cos(t)+ 9.993e-001* 3.008e-003*sin(t)),  1.674e-001 +2.000*(-9.993e-001* 1.124e-002*cos(t)+ 3.665e-002* 3.008e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.674e-002, 2.092e-001 center
replot  1.674e-002+ 2.000*( 7.138e-002* 1.687e-002*cos(t)+ 9.974e-001* 4.874e-003*sin(t)),  2.092e-001 +2.000*(-9.974e-001* 1.687e-002*cos(t)+ 7.138e-002* 4.874e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  2.966e-002, 2.591e-001 center
replot  2.966e-002+ 2.000*( 1.318e-001* 2.665e-002*cos(t)+ 9.913e-001* 9.777e-003*sin(t)),  2.591e-001 +2.000*(-9.913e-001* 2.665e-002*cos(t)+ 1.318e-001* 9.777e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  5.192e-002, 3.170e-001 center
replot  5.192e-002+ 2.000*( 2.641e-001* 4.134e-002*cos(t)+ 9.645e-001* 2.098e-002*sin(t)),  3.170e-001 +2.000*(-9.645e-001* 4.134e-002*cos(t)+ 2.641e-001* 2.098e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  8.940e-002, 3.816e-001 center
replot  8.940e-002+ 2.000*( 5.610e-001* 6.546e-002*cos(t)+ 8.278e-001* 4.044e-002*sin(t)),  3.816e-001 +2.000*(-8.278e-001* 6.546e-002*cos(t)+ 5.610e-001* 4.044e-002*sin(t)) not
set out;
set out "ITMsr/VARPIJGR_ITMsr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ITMsr/VARPIJGR_ITMsr_121-12.svg"
set label "50" at  2.409e-001, 6.535e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  2.409e-001+ 2.000*( 9.968e-001* 3.842e-002*cos(t)+-7.941e-002* 9.095e-003*sin(t)),  6.535e-002 +2.000*( 7.941e-002* 3.842e-002*cos(t)+ 9.968e-001* 9.095e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  2.247e-001, 8.310e-002 center
replot  2.247e-001+ 2.000*( 9.943e-001* 2.886e-002*cos(t)+-1.070e-001* 9.061e-003*sin(t)),  8.310e-002 +2.000*( 1.070e-001* 2.886e-002*cos(t)+ 9.943e-001* 9.061e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.094e-001, 1.054e-001 center
replot  2.094e-001+ 2.000*( 9.888e-001* 2.117e-002*cos(t)+-1.490e-001* 8.745e-003*sin(t)),  1.054e-001 +2.000*( 1.490e-001* 2.117e-002*cos(t)+ 9.888e-001* 8.745e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  1.947e-001, 1.332e-001 center
replot  1.947e-001+ 2.000*( 9.721e-001* 1.612e-002*cos(t)+-2.347e-001* 8.665e-003*sin(t)),  1.332e-001 +2.000*( 2.347e-001* 1.612e-002*cos(t)+ 9.721e-001* 8.665e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  1.806e-001, 1.674e-001 center
replot  1.806e-001+ 2.000*( 8.903e-001* 1.505e-002*cos(t)+-4.554e-001* 1.000e-002*sin(t)),  1.674e-001 +2.000*( 4.554e-001* 1.505e-002*cos(t)+ 8.903e-001* 1.000e-002*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.667e-001, 2.092e-001 center
replot  1.667e-001+ 2.000*( 6.328e-001* 1.893e-002*cos(t)+-7.743e-001* 1.306e-002*sin(t)),  2.092e-001 +2.000*( 7.743e-001* 1.893e-002*cos(t)+ 6.328e-001* 1.306e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.529e-001, 2.591e-001 center
replot  1.529e-001+ 2.000*( 3.772e-001* 2.775e-002*cos(t)+-9.261e-001* 1.662e-002*sin(t)),  2.591e-001 +2.000*( 9.261e-001* 2.775e-002*cos(t)+ 3.772e-001* 1.662e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.387e-001, 3.170e-001 center
replot  1.387e-001+ 2.000*( 2.321e-001* 4.112e-002*cos(t)+-9.727e-001* 1.992e-002*sin(t)),  3.170e-001 +2.000*( 9.727e-001* 4.112e-002*cos(t)+ 2.321e-001* 1.992e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.237e-001, 3.816e-001 center
replot  1.237e-001+ 2.000*( 1.447e-001* 5.928e-002*cos(t)+-9.895e-001* 2.260e-002*sin(t)),  3.816e-001 +2.000*( 9.895e-001* 5.928e-002*cos(t)+ 1.447e-001* 2.260e-002*sin(t)) not
set out;
set out "ITMsr/VARPIJGR_ITMsr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ITMsr/VARPIJGR_ITMsr_123-12.svg"
set label "50" at  3.070e-003, 6.535e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  3.070e-003+ 2.000*( 1.002e-002* 9.567e-003*cos(t)+-9.999e-001* 1.704e-003*sin(t)),  6.535e-002 +2.000*( 9.999e-001* 9.567e-003*cos(t)+ 1.002e-002* 1.704e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  5.257e-003, 8.310e-002 center
replot  5.257e-003+ 2.000*( 1.458e-002* 9.524e-003*cos(t)+-9.999e-001* 2.462e-003*sin(t)),  8.310e-002 +2.000*( 9.999e-001* 9.524e-003*cos(t)+ 1.458e-002* 2.462e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  8.990e-003, 1.054e-001 center
replot  8.990e-003+ 2.000*( 2.239e-002* 9.206e-003*cos(t)+-9.997e-001* 3.445e-003*sin(t)),  1.054e-001 +2.000*( 9.997e-001* 9.206e-003*cos(t)+ 2.239e-002* 3.445e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.534e-002, 1.332e-001 center
replot  1.534e-002+ 2.000*( 3.611e-002* 9.239e-003*cos(t)+-9.993e-001* 4.620e-003*sin(t)),  1.332e-001 +2.000*( 9.993e-001* 9.239e-003*cos(t)+ 3.611e-002* 4.620e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  2.612e-002, 1.674e-001 center
replot  2.612e-002+ 2.000*( 5.032e-002* 1.125e-002*cos(t)+-9.987e-001* 5.887e-003*sin(t)),  1.674e-001 +2.000*( 9.987e-001* 1.125e-002*cos(t)+ 5.032e-002* 5.887e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  4.427e-002, 2.092e-001 center
replot  4.427e-002+ 2.000*( 6.051e-002* 1.685e-002*cos(t)+-9.982e-001* 7.300e-003*sin(t)),  2.092e-001 +2.000*( 9.982e-001* 1.685e-002*cos(t)+ 6.051e-002* 7.300e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  7.452e-002, 2.591e-001 center
replot  7.452e-002+ 2.000*( 8.174e-002* 2.653e-002*cos(t)+-9.967e-001* 1.035e-002*sin(t)),  2.591e-001 +2.000*( 9.967e-001* 2.653e-002*cos(t)+ 8.174e-002* 1.035e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.241e-001, 3.170e-001 center
replot  1.241e-001+ 2.000*( 1.341e-001* 4.054e-002*cos(t)+-9.910e-001* 1.978e-002*sin(t)),  3.170e-001 +2.000*( 9.910e-001* 4.054e-002*cos(t)+ 1.341e-001* 1.978e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.031e-001, 3.816e-001 center
replot  2.031e-001+ 2.000*( 2.940e-001* 6.015e-002*cos(t)+-9.558e-001* 4.113e-002*sin(t)),  3.816e-001 +2.000*( 9.558e-001* 6.015e-002*cos(t)+ 2.940e-001* 4.113e-002*sin(t)) not
set out;
set out "ITMsr/VARPIJGR_ITMsr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ITMsr/VARPIJGR_ITMsr_121-13.svg"
set label "50" at  2.409e-001, 8.728e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  2.409e-001+ 2.000*( 1.000e+000* 3.830e-002*cos(t)+-3.788e-004* 6.996e-004*sin(t)),  8.728e-004 +2.000*( 3.788e-004* 3.830e-002*cos(t)+ 1.000e+000* 6.996e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  2.247e-001, 1.588e-003 center
replot  2.247e-001+ 2.000*( 1.000e+000* 2.871e-002*cos(t)+-7.127e-004* 1.049e-003*sin(t)),  1.588e-003 +2.000*( 7.127e-004* 2.871e-002*cos(t)+ 1.000e+000* 1.049e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.094e-001, 2.880e-003 center
replot  2.094e-001+ 2.000*( 1.000e+000* 2.097e-002*cos(t)+-1.527e-003* 1.520e-003*sin(t)),  2.880e-003 +2.000*( 1.527e-003* 2.097e-002*cos(t)+ 1.000e+000* 1.520e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  1.947e-001, 5.206e-003 center
replot  1.947e-001+ 2.000*( 1.000e+000* 1.580e-002*cos(t)+-4.217e-003* 2.133e-003*sin(t)),  5.206e-003 +2.000*( 4.217e-003* 1.580e-002*cos(t)+ 1.000e+000* 2.133e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  1.806e-001, 9.366e-003 center
replot  1.806e-001+ 2.000*( 9.999e-001* 1.415e-002*cos(t)+-1.211e-002* 3.030e-003*sin(t)),  9.366e-003 +2.000*( 1.211e-002* 1.415e-002*cos(t)+ 9.999e-001* 3.030e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.667e-001, 1.674e-002 center
replot  1.667e-001+ 2.000*( 9.996e-001* 1.568e-002*cos(t)+-2.747e-002* 4.992e-003*sin(t)),  1.674e-002 +2.000*( 2.747e-002* 1.568e-002*cos(t)+ 9.996e-001* 4.992e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.529e-001, 2.966e-002 center
replot  1.529e-001+ 2.000*( 9.978e-001* 1.864e-002*cos(t)+-6.702e-002* 1.026e-002*sin(t)),  2.966e-002 +2.000*( 6.702e-002* 1.864e-002*cos(t)+ 9.978e-001* 1.026e-002*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.387e-001, 5.192e-002 center
replot  1.387e-001+ 2.000*( 4.558e-001* 2.347e-002*cos(t)+-8.901e-001* 2.108e-002*sin(t)),  5.192e-002 +2.000*( 8.901e-001* 2.347e-002*cos(t)+ 4.558e-001* 2.108e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.237e-001, 8.940e-002 center
replot  1.237e-001+ 2.000*( 6.037e-002* 4.976e-002*cos(t)+-9.982e-001* 2.381e-002*sin(t)),  8.940e-002 +2.000*( 9.982e-001* 4.976e-002*cos(t)+ 6.037e-002* 2.381e-002*sin(t)) not
set out;
set out "ITMsr/VARPIJGR_ITMsr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ITMsr/VARPIJGR_ITMsr_123-13.svg"
set label "50" at  3.070e-003, 8.728e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  3.070e-003+ 2.000*( 9.894e-001* 1.722e-003*cos(t)+ 1.452e-001* 6.605e-004*sin(t)),  8.728e-004 +2.000*(-1.452e-001* 1.722e-003*cos(t)+ 9.894e-001* 6.605e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  5.257e-003, 1.588e-003 center
replot  5.257e-003+ 2.000*( 9.882e-001* 2.490e-003*cos(t)+ 1.530e-001* 9.896e-004*sin(t)),  1.588e-003 +2.000*(-1.530e-001* 2.490e-003*cos(t)+ 9.882e-001* 9.896e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  8.990e-003, 2.880e-003 center
replot  8.990e-003+ 2.000*( 9.868e-001* 3.488e-003*cos(t)+ 1.617e-001* 1.431e-003*sin(t)),  2.880e-003 +2.000*(-1.617e-001* 3.488e-003*cos(t)+ 9.868e-001* 1.431e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.534e-002, 5.206e-003 center
replot  1.534e-002+ 2.000*( 9.845e-001* 4.688e-003*cos(t)+ 1.756e-001* 1.999e-003*sin(t)),  5.206e-003 +2.000*(-1.756e-001* 4.688e-003*cos(t)+ 9.845e-001* 1.999e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  2.612e-002, 9.366e-003 center
replot  2.612e-002+ 2.000*( 9.767e-001* 6.016e-003*cos(t)+ 2.146e-001* 2.811e-003*sin(t)),  9.366e-003 +2.000*(-2.146e-001* 6.016e-003*cos(t)+ 9.767e-001* 2.811e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  4.427e-002, 1.674e-002 center
replot  4.427e-002+ 2.000*( 9.306e-001* 7.711e-003*cos(t)+ 3.661e-001* 4.446e-003*sin(t)),  1.674e-002 +2.000*(-3.661e-001* 7.711e-003*cos(t)+ 9.306e-001* 4.446e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  7.452e-002, 2.966e-002 center
replot  7.452e-002+ 2.000*( 7.253e-001* 1.242e-002*cos(t)+ 6.884e-001* 7.932e-003*sin(t)),  2.966e-002 +2.000*(-6.884e-001* 1.242e-002*cos(t)+ 7.253e-001* 7.932e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.241e-001, 5.192e-002 center
replot  1.241e-001+ 2.000*( 6.005e-001* 2.603e-002*cos(t)+ 7.996e-001* 1.628e-002*sin(t)),  5.192e-002 +2.000*(-7.996e-001* 2.603e-002*cos(t)+ 6.005e-001* 1.628e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.031e-001, 8.940e-002 center
replot  2.031e-001+ 2.000*( 5.750e-001* 5.537e-002*cos(t)+ 8.182e-001* 3.552e-002*sin(t)),  8.940e-002 +2.000*(-8.182e-001* 5.537e-002*cos(t)+ 5.750e-001* 3.552e-002*sin(t)) not
set out;
set out "ITMsr/VARPIJGR_ITMsr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "ITMsr/VARPIJGR_ITMsr_123-21.svg"
set label "50" at  3.070e-003, 2.409e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  3.070e-003+ 2.000*( 9.333e-004* 3.830e-002*cos(t)+ 1.000e+000* 1.706e-003*sin(t)),  2.409e-001 +2.000*(-1.000e+000* 3.830e-002*cos(t)+ 9.333e-004* 1.706e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  5.257e-003, 2.247e-001 center
replot  5.257e-003+ 2.000*( 1.973e-003* 2.871e-002*cos(t)+ 1.000e+000* 2.465e-003*sin(t)),  2.247e-001 +2.000*(-1.000e+000* 2.871e-002*cos(t)+ 1.973e-003* 2.465e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  8.990e-003, 2.094e-001 center
replot  8.990e-003+ 2.000*( 5.069e-003* 2.097e-002*cos(t)+ 1.000e+000* 3.448e-003*sin(t)),  2.094e-001 +2.000*(-1.000e+000* 2.097e-002*cos(t)+ 5.069e-003* 3.448e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.534e-002, 1.947e-001 center
replot  1.534e-002+ 2.000*( 1.438e-002* 1.581e-002*cos(t)+ 9.999e-001* 4.624e-003*sin(t)),  1.947e-001 +2.000*(-9.999e-001* 1.581e-002*cos(t)+ 1.438e-002* 4.624e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  2.612e-002, 1.806e-001 center
replot  2.612e-002+ 2.000*( 3.175e-002* 1.416e-002*cos(t)+ 9.995e-001* 5.893e-003*sin(t)),  1.806e-001 +2.000*(-9.995e-001* 1.416e-002*cos(t)+ 3.175e-002* 5.893e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  4.427e-002, 1.667e-001 center
replot  4.427e-002+ 2.000*( 4.500e-002* 1.569e-002*cos(t)+ 9.990e-001* 7.331e-003*sin(t)),  1.667e-001 +2.000*(-9.990e-001* 1.569e-002*cos(t)+ 4.500e-002* 7.331e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  7.452e-002, 1.529e-001 center
replot  7.452e-002+ 2.000*( 6.877e-002* 1.864e-002*cos(t)+ 9.976e-001* 1.048e-002*sin(t)),  1.529e-001 +2.000*(-9.976e-001* 1.864e-002*cos(t)+ 6.877e-002* 1.048e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.241e-001, 1.387e-001 center
replot  1.241e-001+ 2.000*( 4.878e-001* 2.215e-002*cos(t)+ 8.729e-001* 1.974e-002*sin(t)),  1.387e-001 +2.000*(-8.729e-001* 2.215e-002*cos(t)+ 4.878e-001* 1.974e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.031e-001, 1.237e-001 center
replot  2.031e-001+ 2.000*( 9.939e-001* 4.329e-002*cos(t)+ 1.106e-001* 2.362e-002*sin(t)),  1.237e-001 +2.000*(-1.106e-001* 4.329e-002*cos(t)+ 9.939e-001* 2.362e-002*sin(t)) not
set out;
set out "ITMsr/VARPIJGR_ITMsr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "ITMsr/VARMUPTJGR--STABLBASED_ITMsr1.svg";
 plot "ITMsr/PRMORPREV-1-STABLBASED_ITMsr.txt"  u 1:($3) not w l lt 1 
 replot "ITMsr/PRMORPREV-1-STABLBASED_ITMsr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "ITMsr/PRMORPREV-1-STABLBASED_ITMsr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "ITMsr/VARMUPTJGR--STABLBASED_ITMsr1.svg";replot;set out;
