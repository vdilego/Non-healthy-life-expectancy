
# IMaCh-0.99r45
# ATFadl.gp
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


set ter svg size 640, 480;set out "ATFadl/D_ATFadl_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "ATFadl/ILK_ATFadl-dest.png";
set log y;plot  "ATFadl/ILK_ATFadl.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "ATFadl/ILK_ATFadl-ori.png";
set log y;plot  "ATFadl/ILK_ATFadl.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "ATFadl/ILK_ATFadl-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ATFadl/ILK_ATFadl.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "ATFadl/ILK_ATFadl-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ATFadl/ILK_ATFadl.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "ATFadl/V_ATFadl_1-1-1.svg" 

#set out "V_ATFadl_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ATFadl/VPL_ATFadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"ATFadl/VPL_ATFadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"ATFadl/VPL_ATFadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"ATFadl/P_ATFadl.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "ATFadl/V_ATFadl_2-1-1.svg" 

#set out "V_ATFadl_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ATFadl/VPL_ATFadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"ATFadl/VPL_ATFadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"ATFadl/VPL_ATFadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"ATFadl/P_ATFadl.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "ATFadl/E_ATFadl_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "ATFadl/T_ATFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"ATFadl/T_ATFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"ATFadl/T_ATFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"ATFadl/T_ATFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"ATFadl/T_ATFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"ATFadl/T_ATFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"ATFadl/T_ATFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"ATFadl/T_ATFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"ATFadl/T_ATFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "ATFadl/E_ATFadl_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "ATFadl/EXP_ATFadl_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ATFadl/E_ATFadl.txt" every :::0::0 u 1:2 t "e11" w l ,"ATFadl/E_ATFadl.txt" every :::0::0 u 1:3 t "e12" w l ,"ATFadl/E_ATFadl.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "ATFadl/EXP_ATFadl_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ATFadl/E_ATFadl.txt" every :::0::0 u 1:5 t "e21" w l ,"ATFadl/E_ATFadl.txt" every :::0::0 u 1:6 t "e22" w l ,"ATFadl/E_ATFadl.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "ATFadl/LIJ_ATFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFadl/PIJ_ATFadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "ATFadl/LIJ_ATFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFadl/PIJ_ATFadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "ATFadl/LIJT_ATFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFadl/PIJ_ATFadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "ATFadl/LIJT_ATFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFadl/PIJ_ATFadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "ATFadl/P_ATFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFadl/PIJ_ATFadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "ATFadl/P_ATFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFadl/PIJ_ATFadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-13.419486; p2=0.129041; 
#   current state 3
p3=-13.306559; p4=0.104211; 
# initial state 2
#   current state 1
p5=1.196228; p6=-0.046334; 
#   current state 3
p7=-7.908990; p8=0.065321; 
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

set out "ATFadl/PE_ATFadl_1-1-1.svg" 
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

set out "ATFadl/PE_ATFadl_1-2-1.svg" 
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

set out "ATFadl/PE_ATFadl_1-3-1.svg" 
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
set out "ATFadl/VARPIJGR_ATFadl_113-12.svg"
set label "50" at  6.087e-004, 1.882e-003 center
# Age 50, p13 - p12
plot [-pi:pi]  6.087e-004+ 2.000*( 1.257e-001* 7.814e-004*cos(t)+ 9.921e-001* 5.072e-004*sin(t)),  1.882e-003 +2.000*(-9.921e-001* 7.814e-004*cos(t)+ 1.257e-001* 5.072e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.024e-003, 3.584e-003 center
replot  1.024e-003+ 2.000*( 1.002e-001* 1.248e-003*cos(t)+ 9.950e-001* 7.123e-004*sin(t)),  3.584e-003 +2.000*(-9.950e-001* 1.248e-003*cos(t)+ 1.002e-001* 7.123e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.721e-003, 6.818e-003 center
replot  1.721e-003+ 2.000*( 8.636e-002* 1.933e-003*cos(t)+ 9.963e-001* 9.709e-004*sin(t)),  6.818e-003 +2.000*(-9.963e-001* 1.933e-003*cos(t)+ 8.636e-002* 9.709e-004*sin(t)) not
# Age 65, p13 - p12
set label "65" at  2.887e-003, 1.295e-002 center
replot  2.887e-003+ 2.000*( 8.073e-002* 2.877e-003*cos(t)+ 9.967e-001* 1.285e-003*sin(t)),  1.295e-002 +2.000*(-9.967e-001* 2.877e-003*cos(t)+ 8.073e-002* 1.285e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  4.827e-003, 2.452e-002 center
replot  4.827e-003+ 2.000*( 8.343e-002* 4.113e-003*cos(t)+ 9.965e-001* 1.699e-003*sin(t)),  2.452e-002 +2.000*(-9.965e-001* 4.113e-003*cos(t)+ 8.343e-002* 1.699e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  8.026e-003, 4.615e-002 center
replot  8.026e-003+ 2.000*( 9.351e-002* 5.953e-003*cos(t)+ 9.956e-001* 2.476e-003*sin(t)),  4.615e-002 +2.000*(-9.956e-001* 5.953e-003*cos(t)+ 9.351e-002* 2.476e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  1.320e-002, 8.595e-002 center
replot  1.320e-002+ 2.000*( 9.349e-002* 1.033e-002*cos(t)+ 9.956e-001* 4.420e-003*sin(t)),  8.595e-002 +2.000*(-9.956e-001* 1.033e-002*cos(t)+ 9.349e-002* 4.420e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  2.130e-002, 1.570e-001 center
replot  2.130e-002+ 2.000*( 8.080e-002* 2.239e-002*cos(t)+ 9.967e-001* 8.868e-003*sin(t)),  1.570e-001 +2.000*(-9.967e-001* 2.239e-002*cos(t)+ 8.080e-002* 8.868e-003*sin(t)) not
# Age 90, p13 - p12
set label "90" at  3.326e-002, 2.776e-001 center
replot  3.326e-002+ 2.000*( 8.093e-002* 4.905e-002*cos(t)+ 9.967e-001* 1.743e-002*sin(t)),  2.776e-001 +2.000*(-9.967e-001* 4.905e-002*cos(t)+ 8.093e-002* 1.743e-002*sin(t)) not
set out;
set out "ATFadl/VARPIJGR_ATFadl_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ATFadl/VARPIJGR_ATFadl_121-12.svg"
set label "50" at  4.883e-001, 1.882e-003 center
# Age 50, p21 - p12
plot [-pi:pi]  4.883e-001+ 2.000*( 1.000e+000* 1.213e-001*cos(t)+-1.015e-003* 7.680e-004*sin(t)),  1.882e-003 +2.000*( 1.015e-003* 1.213e-001*cos(t)+ 1.000e+000* 7.680e-004*sin(t)) not
# Age 55, p21 - p12
set label "55" at  4.067e-001, 3.584e-003 center
replot  4.067e-001+ 2.000*( 1.000e+000* 8.756e-002*cos(t)+-2.211e-003* 1.229e-003*sin(t)),  3.584e-003 +2.000*( 2.211e-003* 8.756e-002*cos(t)+ 1.000e+000* 1.229e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.354e-001, 6.818e-003 center
replot  3.354e-001+ 2.000*( 1.000e+000* 6.090e-002*cos(t)+-4.839e-003* 1.905e-003*sin(t)),  6.818e-003 +2.000*( 4.839e-003* 6.090e-002*cos(t)+ 1.000e+000* 1.905e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.739e-001, 1.295e-002 center
replot  2.739e-001+ 2.000*( 9.999e-001* 4.212e-002*cos(t)+-1.037e-002* 2.836e-003*sin(t)),  1.295e-002 +2.000*( 1.037e-002* 4.212e-002*cos(t)+ 9.999e-001* 2.836e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.217e-001, 2.452e-002 center
replot  2.217e-001+ 2.000*( 9.998e-001* 3.143e-002*cos(t)+-2.124e-002* 4.047e-003*sin(t)),  2.452e-002 +2.000*( 2.124e-002* 3.143e-002*cos(t)+ 9.998e-001* 4.047e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.778e-001, 4.615e-002 center
replot  1.778e-001+ 2.000*( 9.990e-001* 2.742e-002*cos(t)+-4.431e-002* 5.812e-003*sin(t)),  4.615e-002 +2.000*( 4.431e-002* 2.742e-002*cos(t)+ 9.990e-001* 5.812e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.413e-001, 8.595e-002 center
replot  1.413e-001+ 2.000*( 9.943e-001* 2.679e-002*cos(t)+-1.067e-001* 9.949e-003*sin(t)),  8.595e-002 +2.000*( 1.067e-001* 2.679e-002*cos(t)+ 9.943e-001* 9.949e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.112e-001, 1.570e-001 center
replot  1.112e-001+ 2.000*( 8.858e-001* 2.779e-002*cos(t)+-4.641e-001* 2.057e-002*sin(t)),  1.570e-001 +2.000*( 4.641e-001* 2.779e-002*cos(t)+ 8.858e-001* 2.057e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  8.645e-002, 2.776e-001 center
replot  8.645e-002+ 2.000*( 1.563e-001* 4.936e-002*cos(t)+-9.877e-001* 2.457e-002*sin(t)),  2.776e-001 +2.000*( 9.877e-001* 4.936e-002*cos(t)+ 1.563e-001* 2.457e-002*sin(t)) not
set out;
set out "ATFadl/VARPIJGR_ATFadl_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ATFadl/VARPIJGR_ATFadl_123-12.svg"
set label "50" at  1.442e-002, 1.882e-003 center
# Age 50, p23 - p12
plot [-pi:pi]  1.442e-002+ 2.000*( 1.000e+000* 1.156e-002*cos(t)+-6.867e-003* 7.738e-004*sin(t)),  1.882e-003 +2.000*( 6.867e-003* 1.156e-002*cos(t)+ 1.000e+000* 7.738e-004*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.099e-002, 3.584e-003 center
replot  2.099e-002+ 2.000*( 1.000e+000* 1.438e-002*cos(t)+-9.537e-003* 1.237e-003*sin(t)),  3.584e-003 +2.000*( 9.537e-003* 1.438e-002*cos(t)+ 1.000e+000* 1.237e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.024e-002, 6.818e-003 center
replot  3.024e-002+ 2.000*( 9.999e-001* 1.724e-002*cos(t)+-1.337e-002* 1.914e-003*sin(t)),  6.818e-003 +2.000*( 1.337e-002* 1.724e-002*cos(t)+ 9.999e-001* 1.914e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  4.317e-002, 1.295e-002 center
replot  4.317e-002+ 2.000*( 9.998e-001* 1.975e-002*cos(t)+-1.898e-002* 2.845e-003*sin(t)),  1.295e-002 +2.000*( 1.898e-002* 1.975e-002*cos(t)+ 9.998e-001* 2.845e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  6.106e-002, 2.452e-002 center
replot  6.106e-002+ 2.000*( 9.996e-001* 2.137e-002*cos(t)+-2.742e-002* 4.060e-003*sin(t)),  2.452e-002 +2.000*( 2.742e-002* 2.137e-002*cos(t)+ 9.996e-001* 4.060e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  8.560e-002, 4.615e-002 center
replot  8.560e-002+ 2.000*( 9.992e-001* 2.164e-002*cos(t)+-4.060e-002* 5.871e-003*sin(t)),  4.615e-002 +2.000*( 4.060e-002* 2.164e-002*cos(t)+ 9.992e-001* 5.871e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.189e-001, 8.595e-002 center
replot  1.189e-001+ 2.000*( 9.979e-001* 2.152e-002*cos(t)+-6.456e-002* 1.022e-002*sin(t)),  8.595e-002 +2.000*( 6.456e-002* 2.152e-002*cos(t)+ 9.979e-001* 1.022e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.634e-001, 1.570e-001 center
replot  1.634e-001+ 2.000*( 9.865e-001* 2.701e-002*cos(t)+-1.639e-001* 2.218e-002*sin(t)),  1.570e-001 +2.000*( 1.639e-001* 2.701e-002*cos(t)+ 9.865e-001* 2.218e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.221e-001, 2.776e-001 center
replot  2.221e-001+ 2.000*( 3.983e-001* 4.946e-002*cos(t)+-9.173e-001* 4.584e-002*sin(t)),  2.776e-001 +2.000*( 9.173e-001* 4.946e-002*cos(t)+ 3.983e-001* 4.584e-002*sin(t)) not
set out;
set out "ATFadl/VARPIJGR_ATFadl_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ATFadl/VARPIJGR_ATFadl_121-13.svg"
set label "50" at  4.883e-001, 6.087e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  4.883e-001+ 2.000*( 1.000e+000* 1.213e-001*cos(t)+-3.118e-006* 5.127e-004*sin(t)),  6.087e-004 +2.000*( 3.118e-006* 1.213e-001*cos(t)+ 1.000e+000* 5.127e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  4.067e-001, 1.024e-003 center
replot  4.067e-001+ 2.000*( 1.000e+000* 8.756e-002*cos(t)+-6.486e-006* 7.197e-004*sin(t)),  1.024e-003 +2.000*( 6.486e-006* 8.756e-002*cos(t)+ 1.000e+000* 7.197e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.354e-001, 1.721e-003 center
replot  3.354e-001+ 2.000*( 1.000e+000* 6.090e-002*cos(t)+-3.785e-005* 9.815e-004*sin(t)),  1.721e-003 +2.000*( 3.785e-005* 6.090e-002*cos(t)+ 1.000e+000* 9.815e-004*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.739e-001, 2.887e-003 center
replot  2.739e-001+ 2.000*( 1.000e+000* 4.211e-002*cos(t)+-2.395e-004* 1.302e-003*sin(t)),  2.887e-003 +2.000*( 2.395e-004* 4.211e-002*cos(t)+ 1.000e+000* 1.302e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.217e-001, 4.827e-003 center
replot  2.217e-001+ 2.000*( 1.000e+000* 3.142e-002*cos(t)+-1.100e-003* 1.727e-003*sin(t)),  4.827e-003 +2.000*( 1.100e-003* 3.142e-002*cos(t)+ 1.000e+000* 1.727e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.778e-001, 8.026e-003 center
replot  1.778e-001+ 2.000*( 1.000e+000* 2.739e-002*cos(t)+-3.235e-003* 2.526e-003*sin(t)),  8.026e-003 +2.000*( 3.235e-003* 2.739e-002*cos(t)+ 1.000e+000* 2.526e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.413e-001, 1.320e-002 center
replot  1.413e-001+ 2.000*( 1.000e+000* 2.666e-002*cos(t)+-6.955e-003* 4.502e-003*sin(t)),  1.320e-002 +2.000*( 6.955e-003* 2.666e-002*cos(t)+ 1.000e+000* 4.502e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.112e-001, 2.130e-002 center
replot  1.112e-001+ 2.000*( 9.999e-001* 2.640e-002*cos(t)+-1.406e-002* 9.015e-003*sin(t)),  2.130e-002 +2.000*( 1.406e-002* 2.640e-002*cos(t)+ 9.999e-001* 9.015e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  8.645e-002, 3.326e-002 center
replot  8.645e-002+ 2.000*( 9.991e-001* 2.548e-002*cos(t)+-4.162e-002* 1.780e-002*sin(t)),  3.326e-002 +2.000*( 4.162e-002* 2.548e-002*cos(t)+ 9.991e-001* 1.780e-002*sin(t)) not
set out;
set out "ATFadl/VARPIJGR_ATFadl_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ATFadl/VARPIJGR_ATFadl_123-13.svg"
set label "50" at  1.442e-002, 6.087e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  1.442e-002+ 2.000*( 1.000e+000* 1.156e-002*cos(t)+ 8.626e-003* 5.030e-004*sin(t)),  6.087e-004 +2.000*(-8.626e-003* 1.156e-002*cos(t)+ 1.000e+000* 5.030e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.099e-002, 1.024e-003 center
replot  2.099e-002+ 2.000*( 9.999e-001* 1.438e-002*cos(t)+ 1.033e-002* 7.043e-004*sin(t)),  1.024e-003 +2.000*(-1.033e-002* 1.438e-002*cos(t)+ 9.999e-001* 7.043e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.024e-002, 1.721e-003 center
replot  3.024e-002+ 2.000*( 9.999e-001* 1.724e-002*cos(t)+ 1.270e-002* 9.569e-004*sin(t)),  1.721e-003 +2.000*(-1.270e-002* 1.724e-002*cos(t)+ 9.999e-001* 9.569e-004*sin(t)) not
# Age 65, p23 - p13
set label "65" at  4.317e-002, 2.887e-003 center
replot  4.317e-002+ 2.000*( 9.999e-001* 1.975e-002*cos(t)+ 1.625e-002* 1.262e-003*sin(t)),  2.887e-003 +2.000*(-1.625e-002* 1.975e-002*cos(t)+ 9.999e-001* 1.262e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  6.106e-002, 4.827e-003 center
replot  6.106e-002+ 2.000*( 9.998e-001* 2.137e-002*cos(t)+ 2.219e-002* 1.661e-003*sin(t)),  4.827e-003 +2.000*(-2.219e-002* 2.137e-002*cos(t)+ 9.998e-001* 1.661e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  8.560e-002, 8.026e-003 center
replot  8.560e-002+ 2.000*( 9.994e-001* 2.163e-002*cos(t)+ 3.379e-002* 2.420e-003*sin(t)),  8.026e-003 +2.000*(-3.379e-002* 2.163e-002*cos(t)+ 9.994e-001* 2.420e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.189e-001, 1.320e-002 center
replot  1.189e-001+ 2.000*( 9.983e-001* 2.152e-002*cos(t)+ 5.754e-002* 4.339e-003*sin(t)),  1.320e-002 +2.000*(-5.754e-002* 2.152e-002*cos(t)+ 9.983e-001* 4.339e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.634e-001, 2.130e-002 center
replot  1.634e-001+ 2.000*( 9.969e-001* 2.697e-002*cos(t)+ 7.836e-002* 8.798e-003*sin(t)),  2.130e-002 +2.000*(-7.836e-002* 2.697e-002*cos(t)+ 9.969e-001* 8.798e-003*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.221e-001, 3.326e-002 center
replot  2.221e-001+ 2.000*( 9.976e-001* 4.653e-002*cos(t)+ 6.953e-002* 1.756e-002*sin(t)),  3.326e-002 +2.000*(-6.953e-002* 4.653e-002*cos(t)+ 9.976e-001* 1.756e-002*sin(t)) not
set out;
set out "ATFadl/VARPIJGR_ATFadl_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "ATFadl/VARPIJGR_ATFadl_123-21.svg"
set label "50" at  1.442e-002, 4.883e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.442e-002+ 2.000*( 5.132e-003* 1.213e-001*cos(t)+ 1.000e+000* 1.154e-002*sin(t)),  4.883e-001 +2.000*(-1.000e+000* 1.213e-001*cos(t)+ 5.132e-003* 1.154e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.099e-002, 4.067e-001 center
replot  2.099e-002+ 2.000*( 7.320e-003* 8.756e-002*cos(t)+ 1.000e+000* 1.436e-002*sin(t)),  4.067e-001 +2.000*(-1.000e+000* 8.756e-002*cos(t)+ 7.320e-003* 1.436e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.024e-002, 3.354e-001 center
replot  3.024e-002+ 2.000*( 1.291e-002* 6.090e-002*cos(t)+ 9.999e-001* 1.722e-002*sin(t)),  3.354e-001 +2.000*(-9.999e-001* 6.090e-002*cos(t)+ 1.291e-002* 1.722e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  4.317e-002, 2.739e-001 center
replot  4.317e-002+ 2.000*( 3.059e-002* 4.213e-002*cos(t)+ 9.995e-001* 1.972e-002*sin(t)),  2.739e-001 +2.000*(-9.995e-001* 4.213e-002*cos(t)+ 3.059e-002* 1.972e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  6.106e-002, 2.217e-001 center
replot  6.106e-002+ 2.000*( 8.356e-002* 3.148e-002*cos(t)+ 9.965e-001* 2.128e-002*sin(t)),  2.217e-001 +2.000*(-9.965e-001* 3.148e-002*cos(t)+ 8.356e-002* 2.128e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  8.560e-002, 1.778e-001 center
replot  8.560e-002+ 2.000*( 1.555e-001* 2.752e-002*cos(t)+ 9.878e-001* 2.146e-002*sin(t)),  1.778e-001 +2.000*(-9.878e-001* 2.752e-002*cos(t)+ 1.555e-001* 2.146e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.189e-001, 1.413e-001 center
replot  1.189e-001+ 2.000*( 1.657e-001* 2.679e-002*cos(t)+ 9.862e-001* 2.131e-002*sin(t)),  1.413e-001 +2.000*(-9.862e-001* 2.679e-002*cos(t)+ 1.657e-001* 2.131e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.634e-001, 1.112e-001 center
replot  1.634e-001+ 2.000*( 7.969e-001* 2.755e-002*cos(t)+ 6.041e-001* 2.572e-002*sin(t)),  1.112e-001 +2.000*(-6.041e-001* 2.755e-002*cos(t)+ 7.969e-001* 2.572e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.221e-001, 8.645e-002 center
replot  2.221e-001+ 2.000*( 9.984e-001* 4.648e-002*cos(t)+ 5.592e-002* 2.537e-002*sin(t)),  8.645e-002 +2.000*(-5.592e-002* 4.648e-002*cos(t)+ 9.984e-001* 2.537e-002*sin(t)) not
set out;
set out "ATFadl/VARPIJGR_ATFadl_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "ATFadl/VARMUPTJGR--STABLBASED_ATFadl1.svg";
 plot "ATFadl/PRMORPREV-1-STABLBASED_ATFadl.txt"  u 1:($3) not w l lt 1 
 replot "ATFadl/PRMORPREV-1-STABLBASED_ATFadl.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "ATFadl/PRMORPREV-1-STABLBASED_ATFadl.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "ATFadl/VARMUPTJGR--STABLBASED_ATFadl1.svg";replot;set out;
