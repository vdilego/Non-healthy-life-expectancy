
# IMaCh-0.99r45
# FRFsr.gp
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


set ter svg size 640, 480;set out "FRFsr/D_FRFsr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "FRFsr/ILK_FRFsr-dest.png";
set log y;plot  "FRFsr/ILK_FRFsr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "FRFsr/ILK_FRFsr-ori.png";
set log y;plot  "FRFsr/ILK_FRFsr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "FRFsr/ILK_FRFsr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "FRFsr/ILK_FRFsr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "FRFsr/ILK_FRFsr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "FRFsr/ILK_FRFsr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "FRFsr/V_FRFsr_1-1-1.svg" 

#set out "V_FRFsr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "FRFsr/VPL_FRFsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"FRFsr/VPL_FRFsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"FRFsr/VPL_FRFsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"FRFsr/P_FRFsr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "FRFsr/V_FRFsr_2-1-1.svg" 

#set out "V_FRFsr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "FRFsr/VPL_FRFsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"FRFsr/VPL_FRFsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"FRFsr/VPL_FRFsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"FRFsr/P_FRFsr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "FRFsr/E_FRFsr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "FRFsr/T_FRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"FRFsr/T_FRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"FRFsr/T_FRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"FRFsr/T_FRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"FRFsr/T_FRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"FRFsr/T_FRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"FRFsr/T_FRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"FRFsr/T_FRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"FRFsr/T_FRFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "FRFsr/E_FRFsr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "FRFsr/EXP_FRFsr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "FRFsr/E_FRFsr.txt" every :::0::0 u 1:2 t "e11" w l ,"FRFsr/E_FRFsr.txt" every :::0::0 u 1:3 t "e12" w l ,"FRFsr/E_FRFsr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "FRFsr/EXP_FRFsr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "FRFsr/E_FRFsr.txt" every :::0::0 u 1:5 t "e21" w l ,"FRFsr/E_FRFsr.txt" every :::0::0 u 1:6 t "e22" w l ,"FRFsr/E_FRFsr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "FRFsr/LIJ_FRFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFsr/PIJ_FRFsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "FRFsr/LIJ_FRFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFsr/PIJ_FRFsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "FRFsr/LIJT_FRFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFsr/PIJ_FRFsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "FRFsr/LIJT_FRFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFsr/PIJ_FRFsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "FRFsr/P_FRFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFsr/PIJ_FRFsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "FRFsr/P_FRFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "FRFsr/PIJ_FRFsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-5.143721; p2=0.034221; 
#   current state 3
p3=-39.992610; p4=0.418961; 
# initial state 2
#   current state 1
p5=-2.339080; p6=-0.001302; 
#   current state 3
p7=-8.950614; p8=0.066563; 
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

set out "FRFsr/PE_FRFsr_1-1-1.svg" 
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

set out "FRFsr/PE_FRFsr_1-2-1.svg" 
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

set out "FRFsr/PE_FRFsr_1-3-1.svg" 
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
set out "FRFsr/VARPIJGR_FRFsr_113-12.svg"
set label "50" at  1.038e-008, 6.258e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  1.038e-008+ 2.000*( 2.099e-007* 9.900e-003*cos(t)+-1.000e+000* 5.901e-008*sin(t)),  6.258e-002 +2.000*( 1.000e+000* 9.900e-003*cos(t)+ 2.099e-007* 5.901e-008*sin(t)) not
# Age 55, p13 - p12
set label "55" at  8.385e-008, 7.383e-002 center
replot  8.385e-008+ 2.000*( 1.076e-006* 9.242e-003*cos(t)+-1.000e+000* 4.154e-007*sin(t)),  7.383e-002 +2.000*( 1.000e+000* 9.242e-003*cos(t)+ 1.076e-006* 4.154e-007*sin(t)) not
# Age 60, p13 - p12
set label "60" at  6.766e-007, 8.701e-002 center
replot  6.766e-007+ 2.000*( 1.621e-006* 8.431e-003*cos(t)+-1.000e+000* 2.858e-006*sin(t)),  8.701e-002 +2.000*( 1.000e+000* 8.431e-003*cos(t)+ 1.621e-006* 2.858e-006*sin(t)) not
# Age 65, p13 - p12
set label "65" at  5.452e-006, 1.024e-001 center
replot  5.452e-006+ 2.000*( 6.192e-005* 8.000e-003*cos(t)+ 1.000e+000* 1.905e-005*sin(t)),  1.024e-001 +2.000*(-1.000e+000* 8.000e-003*cos(t)+ 6.192e-005* 1.905e-005*sin(t)) not
# Age 70, p13 - p12
set label "70" at  4.387e-005, 1.204e-001 center
replot  4.387e-005+ 2.000*( 8.024e-004* 9.077e-003*cos(t)+ 1.000e+000* 1.212e-004*sin(t)),  1.204e-001 +2.000*(-1.000e+000* 9.077e-003*cos(t)+ 8.024e-004* 1.212e-004*sin(t)) not
# Age 75, p13 - p12
set label "75" at  3.524e-004, 1.412e-001 center
replot  3.524e-004+ 2.000*( 4.633e-003* 1.262e-002*cos(t)+ 1.000e+000* 7.178e-004*sin(t)),  1.412e-001 +2.000*(-1.000e+000* 1.262e-002*cos(t)+ 4.633e-003* 7.178e-004*sin(t)) not
# Age 80, p13 - p12
set label "80" at  2.822e-003, 1.652e-001 center
replot  2.822e-003+ 2.000*( 2.062e-002* 1.871e-002*cos(t)+ 9.998e-001* 3.737e-003*sin(t)),  1.652e-001 +2.000*(-9.998e-001* 1.871e-002*cos(t)+ 2.062e-002* 3.737e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  2.236e-002, 1.912e-001 center
replot  2.236e-002+ 2.000*( 1.026e-001* 2.717e-002*cos(t)+ 9.947e-001* 1.465e-002*sin(t)),  1.912e-001 +2.000*(-9.947e-001* 2.717e-002*cos(t)+ 1.026e-001* 1.465e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.655e-001, 2.067e-001 center
replot  1.655e-001+ 2.000*( 9.885e-001* 6.870e-002*cos(t)+ 1.511e-001* 3.475e-002*sin(t)),  2.067e-001 +2.000*(-1.511e-001* 6.870e-002*cos(t)+ 9.885e-001* 3.475e-002*sin(t)) not
set out;
set out "FRFsr/VARPIJGR_FRFsr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "FRFsr/VARPIJGR_FRFsr_121-12.svg"
set label "50" at  1.652e-001, 6.258e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  1.652e-001+ 2.000*( 9.962e-001* 3.026e-002*cos(t)+-8.756e-002* 9.576e-003*sin(t)),  6.258e-002 +2.000*( 8.756e-002* 3.026e-002*cos(t)+ 9.962e-001* 9.576e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  1.640e-001, 7.383e-002 center
replot  1.640e-001+ 2.000*( 9.947e-001* 2.451e-002*cos(t)+-1.029e-001* 8.939e-003*sin(t)),  7.383e-002 +2.000*( 1.029e-001* 2.451e-002*cos(t)+ 9.947e-001* 8.939e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  1.627e-001, 8.701e-002 center
replot  1.627e-001+ 2.000*( 9.924e-001* 1.943e-002*cos(t)+-1.234e-001* 8.145e-003*sin(t)),  8.701e-002 +2.000*( 1.234e-001* 1.943e-002*cos(t)+ 9.924e-001* 8.145e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  1.613e-001, 1.024e-001 center
replot  1.613e-001+ 2.000*( 9.864e-001* 1.558e-002*cos(t)+-1.642e-001* 7.684e-003*sin(t)),  1.024e-001 +2.000*( 1.642e-001* 1.558e-002*cos(t)+ 9.864e-001* 7.684e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  1.598e-001, 1.204e-001 center
replot  1.598e-001+ 2.000*( 9.607e-001* 1.403e-002*cos(t)+-2.775e-001* 8.535e-003*sin(t)),  1.204e-001 +2.000*( 2.775e-001* 1.403e-002*cos(t)+ 9.607e-001* 8.535e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.581e-001, 1.412e-001 center
replot  1.581e-001+ 2.000*( 8.580e-001* 1.580e-002*cos(t)+-5.137e-001* 1.127e-002*sin(t)),  1.412e-001 +2.000*( 5.137e-001* 1.580e-002*cos(t)+ 8.580e-001* 1.127e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.560e-001, 1.652e-001 center
replot  1.560e-001+ 2.000*( 6.573e-001* 2.090e-002*cos(t)+-7.536e-001* 1.535e-002*sin(t)),  1.652e-001 +2.000*( 7.536e-001* 2.090e-002*cos(t)+ 6.573e-001* 1.535e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.537e-001, 1.912e-001 center
replot  1.537e-001+ 2.000*( 4.705e-001* 2.874e-002*cos(t)+-8.824e-001* 2.008e-002*sin(t)),  1.912e-001 +2.000*( 8.824e-001* 2.874e-002*cos(t)+ 4.705e-001* 2.008e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.508e-001, 2.067e-001 center
replot  1.508e-001+ 2.000*( 3.659e-001* 3.728e-002*cos(t)+-9.307e-001* 2.509e-002*sin(t)),  2.067e-001 +2.000*( 9.307e-001* 3.728e-002*cos(t)+ 3.659e-001* 2.509e-002*sin(t)) not
set out;
set out "FRFsr/VARPIJGR_FRFsr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "FRFsr/VARPIJGR_FRFsr_123-12.svg"
set label "50" at  6.610e-003, 6.258e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  6.610e-003+ 2.000*( 1.532e-003* 9.900e-003*cos(t)+ 1.000e+000* 3.336e-003*sin(t)),  6.258e-002 +2.000*(-1.000e+000* 9.900e-003*cos(t)+ 1.532e-003* 3.336e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  9.214e-003, 7.383e-002 center
replot  9.214e-003+ 2.000*( 2.914e-003* 9.242e-003*cos(t)+ 1.000e+000* 3.898e-003*sin(t)),  7.383e-002 +2.000*(-1.000e+000* 9.242e-003*cos(t)+ 2.914e-003* 3.898e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  1.284e-002, 8.701e-002 center
replot  1.284e-002+ 2.000*( 4.992e-003* 8.431e-003*cos(t)+ 1.000e+000* 4.420e-003*sin(t)),  8.701e-002 +2.000*(-1.000e+000* 8.431e-003*cos(t)+ 4.992e-003* 4.420e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.787e-002, 1.024e-001 center
replot  1.787e-002+ 2.000*( 5.013e-003* 8.000e-003*cos(t)+ 1.000e+000* 4.848e-003*sin(t)),  1.024e-001 +2.000*(-1.000e+000* 8.000e-003*cos(t)+ 5.013e-003* 4.848e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  2.485e-002, 1.204e-001 center
replot  2.485e-002+ 2.000*( 3.109e-003* 9.077e-003*cos(t)+-1.000e+000* 5.208e-003*sin(t)),  1.204e-001 +2.000*( 1.000e+000* 9.077e-003*cos(t)+ 3.109e-003* 5.208e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  3.451e-002, 1.412e-001 center
replot  3.451e-002+ 2.000*( 1.089e-002* 1.262e-002*cos(t)+-9.999e-001* 5.911e-003*sin(t)),  1.412e-001 +2.000*( 9.999e-001* 1.262e-002*cos(t)+ 1.089e-002* 5.911e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  4.784e-002, 1.652e-001 center
replot  4.784e-002+ 2.000*( 1.628e-002* 1.871e-002*cos(t)+-9.999e-001* 8.215e-003*sin(t)),  1.652e-001 +2.000*( 9.999e-001* 1.871e-002*cos(t)+ 1.628e-002* 8.215e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  6.614e-002, 1.912e-001 center
replot  6.614e-002+ 2.000*( 2.732e-002* 2.707e-002*cos(t)+-9.996e-001* 1.383e-002*sin(t)),  1.912e-001 +2.000*( 9.996e-001* 2.707e-002*cos(t)+ 2.732e-002* 1.383e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  9.111e-002, 2.067e-001 center
replot  9.111e-002+ 2.000*( 7.851e-002* 3.595e-002*cos(t)+-9.969e-001* 2.420e-002*sin(t)),  2.067e-001 +2.000*( 9.969e-001* 3.595e-002*cos(t)+ 7.851e-002* 2.420e-002*sin(t)) not
set out;
set out "FRFsr/VARPIJGR_FRFsr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "FRFsr/VARPIJGR_FRFsr_121-13.svg"
set label "50" at  1.652e-001, 1.038e-008 center
# Age 50, p21 - p13
plot [-pi:pi]  1.652e-001+ 2.000*( 1.000e+000* 3.016e-002*cos(t)+-0.000e+000* 5.905e-008*sin(t)),  1.038e-008 +2.000*( 0.000e+000* 3.016e-002*cos(t)+ 1.000e+000* 5.905e-008*sin(t)) not
# Age 55, p21 - p13
set label "55" at  1.640e-001, 8.385e-008 center
replot  1.640e-001+ 2.000*( 1.000e+000* 2.440e-002*cos(t)+-8.296e-008* 4.155e-007*sin(t)),  8.385e-008 +2.000*( 8.296e-008* 2.440e-002*cos(t)+ 1.000e+000* 4.155e-007*sin(t)) not
# Age 60, p21 - p13
set label "60" at  1.627e-001, 6.766e-007 center
replot  1.627e-001+ 2.000*( 1.000e+000* 1.930e-002*cos(t)+-9.843e-007* 2.858e-006*sin(t)),  6.766e-007 +2.000*( 9.843e-007* 1.930e-002*cos(t)+ 1.000e+000* 2.858e-006*sin(t)) not
# Age 65, p21 - p13
set label "65" at  1.613e-001, 5.452e-006 center
replot  1.613e-001+ 2.000*( 1.000e+000* 1.542e-002*cos(t)+-1.268e-005* 1.905e-005*sin(t)),  5.452e-006 +2.000*( 1.268e-005* 1.542e-002*cos(t)+ 1.000e+000* 1.905e-005*sin(t)) not
# Age 70, p21 - p13
set label "70" at  1.598e-001, 4.387e-005 center
replot  1.598e-001+ 2.000*( 1.000e+000* 1.368e-002*cos(t)+-1.417e-004* 1.214e-004*sin(t)),  4.387e-005 +2.000*( 1.417e-004* 1.368e-002*cos(t)+ 1.000e+000* 1.214e-004*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.581e-001, 3.524e-004 center
replot  1.581e-001+ 2.000*( 1.000e+000* 1.474e-002*cos(t)+-1.124e-003* 7.200e-004*sin(t)),  3.524e-004 +2.000*( 1.124e-003* 1.474e-002*cos(t)+ 1.000e+000* 7.200e-004*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.560e-001, 2.822e-003 center
replot  1.560e-001+ 2.000*( 1.000e+000* 1.796e-002*cos(t)+-7.323e-003* 3.753e-003*sin(t)),  2.822e-003 +2.000*( 7.323e-003* 1.796e-002*cos(t)+ 1.000e+000* 3.753e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.537e-001, 2.236e-002 center
replot  1.537e-001+ 2.000*( 9.973e-001* 2.232e-002*cos(t)+-7.305e-002* 1.479e-002*sin(t)),  2.236e-002 +2.000*( 7.305e-002* 2.232e-002*cos(t)+ 9.973e-001* 1.479e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.508e-001, 1.655e-001 center
replot  1.508e-001+ 2.000*( 3.981e-002* 6.816e-002*cos(t)+-9.992e-001* 2.693e-002*sin(t)),  1.655e-001 +2.000*( 9.992e-001* 6.816e-002*cos(t)+ 3.981e-002* 2.693e-002*sin(t)) not
set out;
set out "FRFsr/VARPIJGR_FRFsr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "FRFsr/VARPIJGR_FRFsr_123-13.svg"
set label "50" at  6.610e-003, 1.038e-008 center
# Age 50, p23 - p13
plot [-pi:pi]  6.610e-003+ 2.000*( 1.000e+000* 3.336e-003*cos(t)+ 4.025e-007* 5.903e-008*sin(t)),  1.038e-008 +2.000*(-4.025e-007* 3.336e-003*cos(t)+ 1.000e+000* 5.903e-008*sin(t)) not
# Age 55, p23 - p13
set label "55" at  9.214e-003, 8.385e-008 center
replot  9.214e-003+ 2.000*( 1.000e+000* 3.898e-003*cos(t)+ 3.270e-006* 4.153e-007*sin(t)),  8.385e-008 +2.000*(-3.270e-006* 3.898e-003*cos(t)+ 1.000e+000* 4.153e-007*sin(t)) not
# Age 60, p23 - p13
set label "60" at  1.284e-002, 6.766e-007 center
replot  1.284e-002+ 2.000*( 1.000e+000* 4.421e-003*cos(t)+ 2.757e-005* 2.856e-006*sin(t)),  6.766e-007 +2.000*(-2.757e-005* 4.421e-003*cos(t)+ 1.000e+000* 2.856e-006*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.787e-002, 5.452e-006 center
replot  1.787e-002+ 2.000*( 1.000e+000* 4.849e-003*cos(t)+ 2.424e-004* 1.902e-005*sin(t)),  5.452e-006 +2.000*(-2.424e-004* 4.849e-003*cos(t)+ 1.000e+000* 1.902e-005*sin(t)) not
# Age 70, p23 - p13
set label "70" at  2.485e-002, 4.387e-005 center
replot  2.485e-002+ 2.000*( 1.000e+000* 5.208e-003*cos(t)+ 2.157e-003* 1.209e-004*sin(t)),  4.387e-005 +2.000*(-2.157e-003* 5.208e-003*cos(t)+ 1.000e+000* 1.209e-004*sin(t)) not
# Age 75, p23 - p13
set label "75" at  3.451e-002, 3.524e-004 center
replot  3.451e-002+ 2.000*( 9.999e-001* 5.913e-003*cos(t)+ 1.677e-002* 7.134e-004*sin(t)),  3.524e-004 +2.000*(-1.677e-002* 5.913e-003*cos(t)+ 9.999e-001* 7.134e-004*sin(t)) not
# Age 80, p23 - p13
set label "80" at  4.784e-002, 2.822e-003 center
replot  4.784e-002+ 2.000*( 9.950e-001* 8.253e-003*cos(t)+ 9.960e-002* 3.683e-003*sin(t)),  2.822e-003 +2.000*(-9.960e-002* 8.253e-003*cos(t)+ 9.950e-001* 3.683e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  6.614e-002, 2.236e-002 center
replot  6.614e-002+ 2.000*( 5.932e-001* 1.594e-002*cos(t)+ 8.050e-001* 1.256e-002*sin(t)),  2.236e-002 +2.000*(-8.050e-001* 1.594e-002*cos(t)+ 5.932e-001* 1.256e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  9.111e-002, 1.655e-001 center
replot  9.111e-002+ 2.000*( 7.361e-002* 6.828e-002*cos(t)+ 9.973e-001* 2.382e-002*sin(t)),  1.655e-001 +2.000*(-9.973e-001* 6.828e-002*cos(t)+ 7.361e-002* 2.382e-002*sin(t)) not
set out;
set out "FRFsr/VARPIJGR_FRFsr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "FRFsr/VARPIJGR_FRFsr_123-21.svg"
set label "50" at  6.610e-003, 1.652e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  6.610e-003+ 2.000*( 3.099e-003* 3.016e-002*cos(t)+ 1.000e+000* 3.334e-003*sin(t)),  1.652e-001 +2.000*(-1.000e+000* 3.016e-002*cos(t)+ 3.099e-003* 3.334e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  9.214e-003, 1.640e-001 center
replot  9.214e-003+ 2.000*( 4.171e-003* 2.440e-002*cos(t)+ 1.000e+000* 3.896e-003*sin(t)),  1.640e-001 +2.000*(-1.000e+000* 2.440e-002*cos(t)+ 4.171e-003* 3.896e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  1.284e-002, 1.627e-001 center
replot  1.284e-002+ 2.000*( 5.593e-003* 1.930e-002*cos(t)+ 1.000e+000* 4.419e-003*sin(t)),  1.627e-001 +2.000*(-1.000e+000* 1.930e-002*cos(t)+ 5.593e-003* 4.419e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.787e-002, 1.613e-001 center
replot  1.787e-002+ 2.000*( 7.812e-003* 1.542e-002*cos(t)+ 1.000e+000* 4.847e-003*sin(t)),  1.613e-001 +2.000*(-1.000e+000* 1.542e-002*cos(t)+ 7.812e-003* 4.847e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  2.485e-002, 1.598e-001 center
replot  2.485e-002+ 2.000*( 1.319e-002* 1.369e-002*cos(t)+ 9.999e-001* 5.206e-003*sin(t)),  1.598e-001 +2.000*(-9.999e-001* 1.369e-002*cos(t)+ 1.319e-002* 5.206e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  3.451e-002, 1.581e-001 center
replot  3.451e-002+ 2.000*( 2.613e-002* 1.474e-002*cos(t)+ 9.997e-001* 5.901e-003*sin(t)),  1.581e-001 +2.000*(-9.997e-001* 1.474e-002*cos(t)+ 2.613e-002* 5.901e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  4.784e-002, 1.560e-001 center
replot  4.784e-002+ 2.000*( 5.156e-002* 1.798e-002*cos(t)+ 9.987e-001* 8.178e-003*sin(t)),  1.560e-001 +2.000*(-9.987e-001* 1.798e-002*cos(t)+ 5.156e-002* 8.178e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  6.614e-002, 1.537e-001 center
replot  6.614e-002+ 2.000*( 1.149e-001* 2.238e-002*cos(t)+ 9.934e-001* 1.369e-002*sin(t)),  1.537e-001 +2.000*(-9.934e-001* 2.238e-002*cos(t)+ 1.149e-001* 1.369e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  9.111e-002, 1.508e-001 center
replot  9.111e-002+ 2.000*( 4.405e-001* 2.786e-002*cos(t)+ 8.977e-001* 2.334e-002*sin(t)),  1.508e-001 +2.000*(-8.977e-001* 2.786e-002*cos(t)+ 4.405e-001* 2.334e-002*sin(t)) not
set out;
set out "FRFsr/VARPIJGR_FRFsr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "FRFsr/VARMUPTJGR--STABLBASED_FRFsr1.svg";
 plot "FRFsr/PRMORPREV-1-STABLBASED_FRFsr.txt"  u 1:($3) not w l lt 1 
 replot "FRFsr/PRMORPREV-1-STABLBASED_FRFsr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "FRFsr/PRMORPREV-1-STABLBASED_FRFsr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "FRFsr/VARMUPTJGR--STABLBASED_FRFsr1.svg";replot;set out;
