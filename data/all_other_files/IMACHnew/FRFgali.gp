
# IMaCh-0.99r45
# FRFgali.gp
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


set ter svg size 640, 480;set out "FRFgali/D_FRFgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "FRFgali/ILK_FRFgali-dest.png";
set log y;plot  "FRFgali/ILK_FRFgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "FRFgali/ILK_FRFgali-ori.png";
set log y;plot  "FRFgali/ILK_FRFgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "FRFgali/ILK_FRFgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "FRFgali/ILK_FRFgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "FRFgali/ILK_FRFgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "FRFgali/ILK_FRFgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "FRFgali/V_FRFgali_1-1-1.svg" 

#set out "V_FRFgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "FRFgali/VPL_FRFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"FRFgali/VPL_FRFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"FRFgali/VPL_FRFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"FRFgali/P_FRFgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "FRFgali/V_FRFgali_2-1-1.svg" 

#set out "V_FRFgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "FRFgali/VPL_FRFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"FRFgali/VPL_FRFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"FRFgali/VPL_FRFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"FRFgali/P_FRFgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "FRFgali/E_FRFgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "FRFgali/T_FRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"FRFgali/T_FRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"FRFgali/T_FRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"FRFgali/T_FRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"FRFgali/T_FRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"FRFgali/T_FRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"FRFgali/T_FRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"FRFgali/T_FRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"FRFgali/T_FRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "FRFgali/E_FRFgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "FRFgali/EXP_FRFgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "FRFgali/E_FRFgali.txt" every :::0::0 u 1:2 t "e11" w l ,"FRFgali/E_FRFgali.txt" every :::0::0 u 1:3 t "e12" w l ,"FRFgali/E_FRFgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "FRFgali/EXP_FRFgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "FRFgali/E_FRFgali.txt" every :::0::0 u 1:5 t "e21" w l ,"FRFgali/E_FRFgali.txt" every :::0::0 u 1:6 t "e22" w l ,"FRFgali/E_FRFgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "FRFgali/LIJ_FRFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFgali/PIJ_FRFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "FRFgali/LIJ_FRFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFgali/PIJ_FRFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "FRFgali/LIJT_FRFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFgali/PIJ_FRFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "FRFgali/LIJT_FRFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFgali/PIJ_FRFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "FRFgali/P_FRFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFgali/PIJ_FRFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "FRFgali/P_FRFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFgali/PIJ_FRFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-5.978157; p2=0.033604; 
#   current state 3
p3=-20.497614; p4=0.198162; 
# initial state 2
#   current state 1
p5=-0.742371; p6=-0.014008; 
#   current state 3
p7=-5.542768; p8=0.028015; 
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

set out "FRFgali/PE_FRFgali_1-1-1.svg" 
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

set out "FRFgali/PE_FRFgali_1-2-1.svg" 
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

set out "FRFgali/PE_FRFgali_1-3-1.svg" 
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
set out "FRFgali/VARPIJGR_FRFgali_113-12.svg"
set label "50" at  4.968e-005, 2.683e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  4.968e-005+ 2.000*( 9.006e-005* 6.143e-003*cos(t)+ 1.000e+000* 5.832e-005*sin(t)),  2.683e-002 +2.000*(-1.000e+000* 6.143e-003*cos(t)+ 9.006e-005* 5.832e-005*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.335e-004, 3.166e-002 center
replot  1.335e-004+ 2.000*( 3.723e-004* 5.842e-003*cos(t)+ 1.000e+000* 1.344e-004*sin(t)),  3.166e-002 +2.000*(-1.000e+000* 5.842e-003*cos(t)+ 3.723e-004* 1.344e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  3.584e-004, 3.734e-002 center
replot  3.584e-004+ 2.000*( 1.498e-003* 5.411e-003*cos(t)+ 1.000e+000* 3.016e-004*sin(t)),  3.734e-002 +2.000*(-1.000e+000* 5.411e-003*cos(t)+ 1.498e-003* 3.016e-004*sin(t)) not
# Age 65, p13 - p12
set label "65" at  9.618e-004, 4.400e-002 center
replot  9.618e-004+ 2.000*( 5.677e-003* 5.060e-003*cos(t)+ 1.000e+000* 6.523e-004*sin(t)),  4.400e-002 +2.000*(-1.000e+000* 5.060e-003*cos(t)+ 5.677e-003* 6.523e-004*sin(t)) not
# Age 70, p13 - p12
set label "70" at  2.578e-003, 5.180e-002 center
replot  2.578e-003+ 2.000*( 1.685e-002* 5.342e-003*cos(t)+ 9.999e-001* 1.340e-003*sin(t)),  5.180e-002 +2.000*(-9.999e-001* 5.342e-003*cos(t)+ 1.685e-002* 1.340e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  6.896e-003, 6.086e-002 center
replot  6.896e-003+ 2.000*( 3.289e-002* 6.972e-003*cos(t)+ 9.995e-001* 2.576e-003*sin(t)),  6.086e-002 +2.000*(-9.995e-001* 6.972e-003*cos(t)+ 3.289e-002* 2.576e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  1.836e-002, 7.118e-002 center
replot  1.836e-002+ 2.000*( 5.129e-002* 1.021e-002*cos(t)+ 9.987e-001* 4.759e-003*sin(t)),  7.118e-002 +2.000*(-9.987e-001* 1.021e-002*cos(t)+ 5.129e-002* 4.759e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  4.840e-002, 8.239e-002 center
replot  4.840e-002+ 2.000*( 1.443e-001* 1.497e-002*cos(t)+ 9.895e-001* 1.098e-002*sin(t)),  8.239e-002 +2.000*(-9.895e-001* 1.497e-002*cos(t)+ 1.443e-001* 1.098e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.243e-001, 9.295e-002 center
replot  1.243e-001+ 2.000*( 9.948e-001* 3.687e-002*cos(t)+ 1.016e-001* 2.050e-002*sin(t)),  9.295e-002 +2.000*(-1.016e-001* 3.687e-002*cos(t)+ 9.948e-001* 2.050e-002*sin(t)) not
set out;
set out "FRFgali/VARPIJGR_FRFgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "FRFgali/VARPIJGR_FRFgali_121-12.svg"
set label "50" at  3.774e-001, 2.683e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  3.774e-001+ 2.000*( 9.997e-001* 7.370e-002*cos(t)+-2.369e-002* 5.892e-003*sin(t)),  2.683e-002 +2.000*( 2.369e-002* 7.370e-002*cos(t)+ 9.997e-001* 5.892e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.557e-001, 3.166e-002 center
replot  3.557e-001+ 2.000*( 9.996e-001* 5.844e-002*cos(t)+-2.880e-002* 5.597e-003*sin(t)),  3.166e-002 +2.000*( 2.880e-002* 5.844e-002*cos(t)+ 9.996e-001* 5.597e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.349e-001, 3.734e-002 center
replot  3.349e-001+ 2.000*( 9.994e-001* 4.549e-002*cos(t)+-3.493e-002* 5.176e-003*sin(t)),  3.734e-002 +2.000*( 3.493e-002* 4.549e-002*cos(t)+ 9.994e-001* 5.176e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.150e-001, 4.400e-002 center
replot  3.150e-001+ 2.000*( 9.991e-001* 3.562e-002*cos(t)+-4.254e-002* 4.832e-003*sin(t)),  4.400e-002 +2.000*( 4.254e-002* 3.562e-002*cos(t)+ 9.991e-001* 4.832e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.960e-001, 5.180e-002 center
replot  2.960e-001+ 2.000*( 9.986e-001* 2.998e-002*cos(t)+-5.334e-002* 5.103e-003*sin(t)),  5.180e-002 +2.000*( 5.334e-002* 2.998e-002*cos(t)+ 9.986e-001* 5.103e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.778e-001, 6.086e-002 center
replot  2.778e-001+ 2.000*( 9.975e-001* 2.929e-002*cos(t)+-7.006e-002* 6.676e-003*sin(t)),  6.086e-002 +2.000*( 7.006e-002* 2.929e-002*cos(t)+ 9.975e-001* 6.676e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.604e-001, 7.118e-002 center
replot  2.604e-001+ 2.000*( 9.957e-001* 3.255e-002*cos(t)+-9.302e-002* 9.780e-003*sin(t)),  7.118e-002 +2.000*( 9.302e-002* 3.255e-002*cos(t)+ 9.957e-001* 9.780e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  2.438e-001, 8.239e-002 center
replot  2.438e-001+ 2.000*( 9.926e-001* 3.781e-002*cos(t)+-1.214e-001* 1.428e-002*sin(t)),  8.239e-002 +2.000*( 1.214e-001* 3.781e-002*cos(t)+ 9.926e-001* 1.428e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  2.280e-001, 9.295e-002 center
replot  2.280e-001+ 2.000*( 9.881e-001* 4.368e-002*cos(t)+-1.535e-001* 1.985e-002*sin(t)),  9.295e-002 +2.000*( 1.535e-001* 4.368e-002*cos(t)+ 9.881e-001* 1.985e-002*sin(t)) not
set out;
set out "FRFgali/VARPIJGR_FRFgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "FRFgali/VARPIJGR_FRFgali_123-12.svg"
set label "50" at  2.538e-002, 2.683e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  2.538e-002+ 2.000*( 1.000e+000* 1.416e-002*cos(t)+ 5.158e-003* 6.143e-003*sin(t)),  2.683e-002 +2.000*(-5.158e-003* 1.416e-002*cos(t)+ 1.000e+000* 6.143e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.952e-002, 3.166e-002 center
replot  2.952e-002+ 2.000*( 1.000e+000* 1.380e-002*cos(t)+ 4.976e-003* 5.842e-003*sin(t)),  3.166e-002 +2.000*(-4.976e-003* 1.380e-002*cos(t)+ 1.000e+000* 5.842e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.429e-002, 3.734e-002 center
replot  3.429e-002+ 2.000*( 1.000e+000* 1.314e-002*cos(t)+ 3.723e-003* 5.411e-003*sin(t)),  3.734e-002 +2.000*(-3.723e-003* 1.314e-002*cos(t)+ 1.000e+000* 5.411e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  3.980e-002, 4.400e-002 center
replot  3.980e-002+ 2.000*( 1.000e+000* 1.227e-002*cos(t)+-8.617e-004* 5.060e-003*sin(t)),  4.400e-002 +2.000*( 8.617e-004* 1.227e-002*cos(t)+ 1.000e+000* 5.060e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  4.613e-002, 5.180e-002 center
replot  4.613e-002+ 2.000*( 9.999e-001* 1.162e-002*cos(t)+-1.443e-002* 5.339e-003*sin(t)),  5.180e-002 +2.000*( 1.443e-002* 1.162e-002*cos(t)+ 9.999e-001* 5.339e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  5.342e-002, 6.086e-002 center
replot  5.342e-002+ 2.000*( 9.990e-001* 1.212e-002*cos(t)+-4.523e-002* 6.954e-003*sin(t)),  6.086e-002 +2.000*( 4.523e-002* 1.212e-002*cos(t)+ 9.990e-001* 6.954e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  6.179e-002, 7.118e-002 center
replot  6.179e-002+ 2.000*( 9.965e-001* 1.500e-002*cos(t)+-8.367e-002* 1.016e-002*sin(t)),  7.118e-002 +2.000*( 8.367e-002* 1.500e-002*cos(t)+ 9.965e-001* 1.016e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  7.137e-002, 8.239e-002 center
replot  7.137e-002+ 2.000*( 9.949e-001* 2.082e-002*cos(t)+-1.005e-001* 1.483e-002*sin(t)),  8.239e-002 +2.000*( 1.005e-001* 2.082e-002*cos(t)+ 9.949e-001* 1.483e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  8.234e-002, 9.295e-002 center
replot  8.234e-002+ 2.000*( 9.949e-001* 2.961e-002*cos(t)+-1.011e-001* 2.062e-002*sin(t)),  9.295e-002 +2.000*( 1.011e-001* 2.961e-002*cos(t)+ 9.949e-001* 2.062e-002*sin(t)) not
set out;
set out "FRFgali/VARPIJGR_FRFgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "FRFgali/VARPIJGR_FRFgali_121-13.svg"
set label "50" at  3.774e-001, 4.968e-005 center
# Age 50, p21 - p13
plot [-pi:pi]  3.774e-001+ 2.000*( 1.000e+000* 7.368e-002*cos(t)+-1.360e-005* 5.832e-005*sin(t)),  4.968e-005 +2.000*( 1.360e-005* 7.368e-002*cos(t)+ 1.000e+000* 5.832e-005*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.557e-001, 1.335e-004 center
replot  3.557e-001+ 2.000*( 1.000e+000* 5.841e-002*cos(t)+-3.630e-005* 1.344e-004*sin(t)),  1.335e-004 +2.000*( 3.630e-005* 5.841e-002*cos(t)+ 1.000e+000* 1.344e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.349e-001, 3.584e-004 center
replot  3.349e-001+ 2.000*( 1.000e+000* 4.547e-002*cos(t)+-9.613e-005* 3.016e-004*sin(t)),  3.584e-004 +2.000*( 9.613e-005* 4.547e-002*cos(t)+ 1.000e+000* 3.016e-004*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.150e-001, 9.618e-004 center
replot  3.150e-001+ 2.000*( 1.000e+000* 3.559e-002*cos(t)+-2.637e-004* 6.528e-004*sin(t)),  9.618e-004 +2.000*( 2.637e-004* 3.559e-002*cos(t)+ 1.000e+000* 6.528e-004*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.960e-001, 2.578e-003 center
replot  2.960e-001+ 2.000*( 1.000e+000* 2.994e-002*cos(t)+-8.319e-004* 1.343e-003*sin(t)),  2.578e-003 +2.000*( 8.319e-004* 2.994e-002*cos(t)+ 1.000e+000* 1.343e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.778e-001, 6.896e-003 center
replot  2.778e-001+ 2.000*( 1.000e+000* 2.922e-002*cos(t)+-2.938e-003* 2.583e-003*sin(t)),  6.896e-003 +2.000*( 2.938e-003* 2.922e-002*cos(t)+ 1.000e+000* 2.583e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.604e-001, 1.836e-002 center
replot  2.604e-001+ 2.000*( 1.000e+000* 3.242e-002*cos(t)+-9.751e-003* 4.772e-003*sin(t)),  1.836e-002 +2.000*( 9.751e-003* 3.242e-002*cos(t)+ 1.000e+000* 4.772e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  2.438e-001, 4.840e-002 center
replot  2.438e-001+ 2.000*( 9.995e-001* 3.758e-002*cos(t)+-3.075e-002* 1.102e-002*sin(t)),  4.840e-002 +2.000*( 3.075e-002* 3.758e-002*cos(t)+ 9.995e-001* 1.102e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  2.280e-001, 1.243e-001 center
replot  2.280e-001+ 2.000*( 9.692e-001* 4.368e-002*cos(t)+-2.463e-001* 3.625e-002*sin(t)),  1.243e-001 +2.000*( 2.463e-001* 4.368e-002*cos(t)+ 9.692e-001* 3.625e-002*sin(t)) not
set out;
set out "FRFgali/VARPIJGR_FRFgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "FRFgali/VARPIJGR_FRFgali_123-13.svg"
set label "50" at  2.538e-002, 4.968e-005 center
# Age 50, p23 - p13
plot [-pi:pi]  2.538e-002+ 2.000*( 1.000e+000* 1.416e-002*cos(t)+ 4.809e-004* 5.793e-005*sin(t)),  4.968e-005 +2.000*(-4.809e-004* 1.416e-002*cos(t)+ 1.000e+000* 5.793e-005*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.952e-002, 1.335e-004 center
replot  2.952e-002+ 2.000*( 1.000e+000* 1.380e-002*cos(t)+ 1.167e-003* 1.335e-004*sin(t)),  1.335e-004 +2.000*(-1.167e-003* 1.380e-002*cos(t)+ 1.000e+000* 1.335e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.429e-002, 3.584e-004 center
replot  3.429e-002+ 2.000*( 1.000e+000* 1.314e-002*cos(t)+ 2.874e-003* 2.993e-004*sin(t)),  3.584e-004 +2.000*(-2.874e-003* 1.314e-002*cos(t)+ 1.000e+000* 2.993e-004*sin(t)) not
# Age 65, p23 - p13
set label "65" at  3.980e-002, 9.618e-004 center
replot  3.980e-002+ 2.000*( 1.000e+000* 1.227e-002*cos(t)+ 7.170e-003* 6.469e-004*sin(t)),  9.618e-004 +2.000*(-7.170e-003* 1.227e-002*cos(t)+ 1.000e+000* 6.469e-004*sin(t)) not
# Age 70, p23 - p13
set label "70" at  4.613e-002, 2.578e-003 center
replot  4.613e-002+ 2.000*( 9.998e-001* 1.162e-002*cos(t)+ 1.765e-002* 1.328e-003*sin(t)),  2.578e-003 +2.000*(-1.765e-002* 1.162e-002*cos(t)+ 9.998e-001* 1.328e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  5.342e-002, 6.896e-003 center
replot  5.342e-002+ 2.000*( 9.992e-001* 1.212e-002*cos(t)+ 3.990e-002* 2.541e-003*sin(t)),  6.896e-003 +2.000*(-3.990e-002* 1.212e-002*cos(t)+ 9.992e-001* 2.541e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  6.179e-002, 1.836e-002 center
replot  6.179e-002+ 2.000*( 9.968e-001* 1.501e-002*cos(t)+ 8.024e-002* 4.643e-003*sin(t)),  1.836e-002 +2.000*(-8.024e-002* 1.501e-002*cos(t)+ 9.968e-001* 4.643e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  7.137e-002, 4.840e-002 center
replot  7.137e-002+ 2.000*( 9.834e-001* 2.102e-002*cos(t)+ 1.812e-001* 1.058e-002*sin(t)),  4.840e-002 +2.000*(-1.812e-001* 2.102e-002*cos(t)+ 9.834e-001* 1.058e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  8.234e-002, 1.243e-001 center
replot  8.234e-002+ 2.000*( 3.749e-001* 3.799e-002*cos(t)+ 9.271e-001* 2.790e-002*sin(t)),  1.243e-001 +2.000*(-9.271e-001* 3.799e-002*cos(t)+ 3.749e-001* 2.790e-002*sin(t)) not
set out;
set out "FRFgali/VARPIJGR_FRFgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "FRFgali/VARPIJGR_FRFgali_123-21.svg"
set label "50" at  2.538e-002, 3.774e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  2.538e-002+ 2.000*( 1.191e-002* 7.368e-002*cos(t)+ 9.999e-001* 1.413e-002*sin(t)),  3.774e-001 +2.000*(-9.999e-001* 7.368e-002*cos(t)+ 1.191e-002* 1.413e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.952e-002, 3.557e-001 center
replot  2.952e-002+ 2.000*( 1.361e-002* 5.842e-002*cos(t)+ 9.999e-001* 1.378e-002*sin(t)),  3.557e-001 +2.000*(-9.999e-001* 5.842e-002*cos(t)+ 1.361e-002* 1.378e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.429e-002, 3.349e-001 center
replot  3.429e-002+ 2.000*( 1.602e-002* 4.547e-002*cos(t)+ 9.999e-001* 1.312e-002*sin(t)),  3.349e-001 +2.000*(-9.999e-001* 4.547e-002*cos(t)+ 1.602e-002* 1.312e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  3.980e-002, 3.150e-001 center
replot  3.980e-002+ 2.000*( 2.105e-002* 3.560e-002*cos(t)+ 9.998e-001* 1.225e-002*sin(t)),  3.150e-001 +2.000*(-9.998e-001* 3.560e-002*cos(t)+ 2.105e-002* 1.225e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  4.613e-002, 2.960e-001 center
replot  4.613e-002+ 2.000*( 3.363e-002* 2.996e-002*cos(t)+ 9.994e-001* 1.158e-002*sin(t)),  2.960e-001 +2.000*(-9.994e-001* 2.996e-002*cos(t)+ 3.363e-002* 1.158e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  5.342e-002, 2.778e-001 center
replot  5.342e-002+ 2.000*( 5.641e-002* 2.926e-002*cos(t)+ 9.984e-001* 1.202e-002*sin(t)),  2.778e-001 +2.000*(-9.984e-001* 2.926e-002*cos(t)+ 5.641e-002* 1.202e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  6.179e-002, 2.604e-001 center
replot  6.179e-002+ 2.000*( 8.555e-002* 3.251e-002*cos(t)+ 9.963e-001* 1.476e-002*sin(t)),  2.604e-001 +2.000*(-9.963e-001* 3.251e-002*cos(t)+ 8.555e-002* 1.476e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  7.137e-002, 2.438e-001 center
replot  7.137e-002+ 2.000*( 1.261e-001* 3.778e-002*cos(t)+ 9.920e-001* 2.037e-002*sin(t)),  2.438e-001 +2.000*(-9.920e-001* 3.778e-002*cos(t)+ 1.261e-001* 2.037e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  8.234e-002, 2.280e-001 center
replot  8.234e-002+ 2.000*( 2.013e-001* 4.377e-002*cos(t)+ 9.795e-001* 2.877e-002*sin(t)),  2.280e-001 +2.000*(-9.795e-001* 4.377e-002*cos(t)+ 2.013e-001* 2.877e-002*sin(t)) not
set out;
set out "FRFgali/VARPIJGR_FRFgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "FRFgali/VARMUPTJGR--STABLBASED_FRFgali1.svg";
 plot "FRFgali/PRMORPREV-1-STABLBASED_FRFgali.txt"  u 1:($3) not w l lt 1 
 replot "FRFgali/PRMORPREV-1-STABLBASED_FRFgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "FRFgali/PRMORPREV-1-STABLBASED_FRFgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "FRFgali/VARMUPTJGR--STABLBASED_FRFgali1.svg";replot;set out;
