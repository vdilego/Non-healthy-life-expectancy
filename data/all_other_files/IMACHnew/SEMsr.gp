
# IMaCh-0.99r45
# SEMsr.gp
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


set ter svg size 640, 480;set out "SEMsr/D_SEMsr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "SEMsr/ILK_SEMsr-dest.png";
set log y;plot  "SEMsr/ILK_SEMsr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "SEMsr/ILK_SEMsr-ori.png";
set log y;plot  "SEMsr/ILK_SEMsr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "SEMsr/ILK_SEMsr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "SEMsr/ILK_SEMsr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "SEMsr/ILK_SEMsr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "SEMsr/ILK_SEMsr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "SEMsr/V_SEMsr_1-1-1.svg" 

#set out "V_SEMsr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "SEMsr/VPL_SEMsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"SEMsr/VPL_SEMsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"SEMsr/VPL_SEMsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"SEMsr/P_SEMsr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "SEMsr/V_SEMsr_2-1-1.svg" 

#set out "V_SEMsr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "SEMsr/VPL_SEMsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"SEMsr/VPL_SEMsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"SEMsr/VPL_SEMsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"SEMsr/P_SEMsr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "SEMsr/E_SEMsr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "SEMsr/T_SEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"SEMsr/T_SEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"SEMsr/T_SEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"SEMsr/T_SEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"SEMsr/T_SEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"SEMsr/T_SEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"SEMsr/T_SEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"SEMsr/T_SEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"SEMsr/T_SEMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "SEMsr/E_SEMsr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "SEMsr/EXP_SEMsr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "SEMsr/E_SEMsr.txt" every :::0::0 u 1:2 t "e11" w l ,"SEMsr/E_SEMsr.txt" every :::0::0 u 1:3 t "e12" w l ,"SEMsr/E_SEMsr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "SEMsr/EXP_SEMsr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "SEMsr/E_SEMsr.txt" every :::0::0 u 1:5 t "e21" w l ,"SEMsr/E_SEMsr.txt" every :::0::0 u 1:6 t "e22" w l ,"SEMsr/E_SEMsr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "SEMsr/LIJ_SEMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEMsr/PIJ_SEMsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "SEMsr/LIJ_SEMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEMsr/PIJ_SEMsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "SEMsr/LIJT_SEMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEMsr/PIJ_SEMsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "SEMsr/LIJT_SEMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEMsr/PIJ_SEMsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "SEMsr/P_SEMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEMsr/PIJ_SEMsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "SEMsr/P_SEMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEMsr/PIJ_SEMsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-5.618883; p2=0.040585; 
#   current state 3
p3=-18.472955; p4=0.174041; 
# initial state 2
#   current state 1
p5=-0.246416; p6=-0.028039; 
#   current state 3
p7=-10.384234; p8=0.095475; 
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

set out "SEMsr/PE_SEMsr_1-1-1.svg" 
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

set out "SEMsr/PE_SEMsr_1-2-1.svg" 
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

set out "SEMsr/PE_SEMsr_1-3-1.svg" 
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
set out "SEMsr/VARPIJGR_SEMsr_113-12.svg"
set label "50" at  1.111e-004, 5.373e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  1.111e-004+ 2.000*( 2.287e-003* 9.705e-003*cos(t)+ 1.000e+000* 2.085e-004*sin(t)),  5.373e-002 +2.000*(-1.000e+000* 9.705e-003*cos(t)+ 2.287e-003* 2.085e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  2.636e-004, 6.542e-002 center
replot  2.636e-004+ 2.000*( 5.686e-003* 9.356e-003*cos(t)+ 1.000e+000* 4.230e-004*sin(t)),  6.542e-002 +2.000*(-1.000e+000* 9.356e-003*cos(t)+ 5.686e-003* 4.230e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  6.247e-004, 7.954e-002 center
replot  6.247e-004+ 2.000*( 1.499e-002* 8.745e-003*cos(t)+ 9.999e-001* 8.331e-004*sin(t)),  7.954e-002 +2.000*(-9.999e-001* 8.745e-003*cos(t)+ 1.499e-002* 8.331e-004*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.478e-003, 9.653e-002 center
replot  1.478e-003+ 2.000*( 3.911e-002* 8.319e-003*cos(t)+ 9.992e-001* 1.575e-003*sin(t)),  9.653e-002 +2.000*(-9.992e-001* 8.319e-003*cos(t)+ 3.911e-002* 1.575e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  3.486e-003, 1.169e-001 center
replot  3.486e-003+ 2.000*( 7.848e-002* 9.305e-003*cos(t)+ 9.969e-001* 2.825e-003*sin(t)),  1.169e-001 +2.000*(-9.969e-001* 9.305e-003*cos(t)+ 7.848e-002* 2.825e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  8.195e-003, 1.410e-001 center
replot  8.195e-003+ 2.000*( 1.037e-001* 1.309e-002*cos(t)+ 9.946e-001* 4.783e-003*sin(t)),  1.410e-001 +2.000*(-9.946e-001* 1.309e-002*cos(t)+ 1.037e-001* 4.783e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  1.915e-002, 1.690e-001 center
replot  1.915e-002+ 2.000*( 1.243e-001* 2.006e-002*cos(t)+ 9.922e-001* 7.930e-003*sin(t)),  1.690e-001 +2.000*(-9.922e-001* 2.006e-002*cos(t)+ 1.243e-001* 7.930e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  4.429e-002, 2.006e-001 center
replot  4.429e-002+ 2.000*( 2.213e-001* 3.037e-002*cos(t)+ 9.752e-001* 1.668e-002*sin(t)),  2.006e-001 +2.000*(-9.752e-001* 3.037e-002*cos(t)+ 2.213e-001* 1.668e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.004e-001, 2.333e-001 center
replot  1.004e-001+ 2.000*( 8.760e-001* 5.524e-002*cos(t)+ 4.824e-001* 3.833e-002*sin(t)),  2.333e-001 +2.000*(-4.824e-001* 5.524e-002*cos(t)+ 8.760e-001* 3.833e-002*sin(t)) not
set out;
set out "SEMsr/VARPIJGR_SEMsr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "SEMsr/VARPIJGR_SEMsr_121-12.svg"
set label "50" at  3.217e-001, 5.373e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  3.217e-001+ 2.000*( 9.990e-001* 7.210e-002*cos(t)+-4.452e-002* 9.168e-003*sin(t)),  5.373e-002 +2.000*( 4.452e-002* 7.210e-002*cos(t)+ 9.990e-001* 9.168e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  2.851e-001, 6.542e-002 center
replot  2.851e-001+ 2.000*( 9.981e-001* 5.180e-002*cos(t)+-6.105e-002* 8.822e-003*sin(t)),  6.542e-002 +2.000*( 6.105e-002* 5.180e-002*cos(t)+ 9.981e-001* 8.822e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.517e-001, 7.954e-002 center
replot  2.517e-001+ 2.000*( 9.964e-001* 3.599e-002*cos(t)+-8.466e-002* 8.225e-003*sin(t)),  7.954e-002 +2.000*( 8.466e-002* 3.599e-002*cos(t)+ 9.964e-001* 8.225e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.213e-001, 9.653e-002 center
replot  2.213e-001+ 2.000*( 9.932e-001* 2.556e-002*cos(t)+-1.168e-001* 7.812e-003*sin(t)),  9.653e-002 +2.000*( 1.168e-001* 2.556e-002*cos(t)+ 9.932e-001* 7.812e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  1.936e-001, 1.169e-001 center
replot  1.936e-001+ 2.000*( 9.875e-001* 2.165e-002*cos(t)+-1.576e-001* 8.738e-003*sin(t)),  1.169e-001 +2.000*( 1.576e-001* 2.165e-002*cos(t)+ 9.875e-001* 8.738e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.681e-001, 1.410e-001 center
replot  1.681e-001+ 2.000*( 9.730e-001* 2.309e-002*cos(t)+-2.306e-001* 1.222e-002*sin(t)),  1.410e-001 +2.000*( 2.306e-001* 2.309e-002*cos(t)+ 9.730e-001* 1.222e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.446e-001, 1.690e-001 center
replot  1.446e-001+ 2.000*( 9.121e-001* 2.686e-002*cos(t)+-4.099e-001* 1.821e-002*sin(t)),  1.690e-001 +2.000*( 4.099e-001* 2.686e-002*cos(t)+ 9.121e-001* 1.821e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.227e-001, 2.006e-001 center
replot  1.227e-001+ 2.000*( 6.279e-001* 3.286e-002*cos(t)+-7.783e-001* 2.450e-002*sin(t)),  2.006e-001 +2.000*( 7.783e-001* 3.286e-002*cos(t)+ 6.279e-001* 2.450e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.019e-001, 2.333e-001 center
replot  1.019e-001+ 2.000*( 2.910e-001* 4.402e-002*cos(t)+-9.567e-001* 2.749e-002*sin(t)),  2.333e-001 +2.000*( 9.567e-001* 4.402e-002*cos(t)+ 2.910e-001* 2.749e-002*sin(t)) not
set out;
set out "SEMsr/VARPIJGR_SEMsr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "SEMsr/VARPIJGR_SEMsr_123-12.svg"
set label "50" at  6.119e-003, 5.373e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  6.119e-003+ 2.000*( 2.885e-002* 9.708e-003*cos(t)+-9.996e-001* 3.922e-003*sin(t)),  5.373e-002 +2.000*( 9.996e-001* 9.708e-003*cos(t)+ 2.885e-002* 3.922e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.006e-002, 6.542e-002 center
replot  1.006e-002+ 2.000*( 6.446e-002* 9.369e-003*cos(t)+-9.979e-001* 5.439e-003*sin(t)),  6.542e-002 +2.000*( 9.979e-001* 9.369e-003*cos(t)+ 6.446e-002* 5.439e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  1.646e-002, 7.954e-002 center
replot  1.646e-002+ 2.000*( 2.422e-001* 8.829e-003*cos(t)+-9.702e-001* 7.238e-003*sin(t)),  7.954e-002 +2.000*( 9.702e-001* 8.829e-003*cos(t)+ 2.422e-001* 7.238e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  2.684e-002, 9.653e-002 center
replot  2.684e-002+ 2.000*( 9.290e-001* 9.657e-003*cos(t)+-3.702e-001* 8.079e-003*sin(t)),  9.653e-002 +2.000*( 3.702e-001* 9.657e-003*cos(t)+ 9.290e-001* 8.079e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  4.354e-002, 1.169e-001 center
replot  4.354e-002+ 2.000*( 9.576e-001* 1.180e-002*cos(t)+-2.880e-001* 9.017e-003*sin(t)),  1.169e-001 +2.000*( 2.880e-001* 1.180e-002*cos(t)+ 9.576e-001* 9.017e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  7.013e-002, 1.410e-001 center
replot  7.013e-002+ 2.000*( 8.214e-001* 1.453e-002*cos(t)+-5.703e-001* 1.225e-002*sin(t)),  1.410e-001 +2.000*( 5.703e-001* 1.453e-002*cos(t)+ 8.214e-001* 1.225e-002*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.119e-001, 1.690e-001 center
replot  1.119e-001+ 2.000*( 5.264e-001* 2.079e-002*cos(t)+-8.502e-001* 1.748e-002*sin(t)),  1.690e-001 +2.000*( 8.502e-001* 2.079e-002*cos(t)+ 5.264e-001* 1.748e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.760e-001, 2.006e-001 center
replot  1.760e-001+ 2.000*( 8.690e-001* 3.339e-002*cos(t)+-4.948e-001* 2.861e-002*sin(t)),  2.006e-001 +2.000*( 4.948e-001* 3.339e-002*cos(t)+ 8.690e-001* 2.861e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.712e-001, 2.333e-001 center
replot  2.712e-001+ 2.000*( 9.868e-001* 6.315e-002*cos(t)+-1.621e-001* 4.218e-002*sin(t)),  2.333e-001 +2.000*( 1.621e-001* 6.315e-002*cos(t)+ 9.868e-001* 4.218e-002*sin(t)) not
set out;
set out "SEMsr/VARPIJGR_SEMsr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "SEMsr/VARPIJGR_SEMsr_121-13.svg"
set label "50" at  3.217e-001, 1.111e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  3.217e-001+ 2.000*( 1.000e+000* 7.203e-002*cos(t)+-3.632e-006* 2.097e-004*sin(t)),  1.111e-004 +2.000*( 3.632e-006* 7.203e-002*cos(t)+ 1.000e+000* 2.097e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  2.851e-001, 2.636e-004 center
replot  2.851e-001+ 2.000*( 1.000e+000* 5.171e-002*cos(t)+ 3.855e-006* 4.263e-004*sin(t)),  2.636e-004 +2.000*(-3.855e-006* 5.171e-002*cos(t)+ 1.000e+000* 4.263e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.517e-001, 6.247e-004 center
replot  2.517e-001+ 2.000*( 1.000e+000* 3.586e-002*cos(t)+ 2.564e-005* 8.432e-004*sin(t)),  6.247e-004 +2.000*(-2.564e-005* 3.586e-002*cos(t)+ 1.000e+000* 8.432e-004*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.213e-001, 1.478e-003 center
replot  2.213e-001+ 2.000*( 1.000e+000* 2.541e-002*cos(t)+-1.198e-004* 1.607e-003*sin(t)),  1.478e-003 +2.000*( 1.198e-004* 2.541e-002*cos(t)+ 1.000e+000* 1.607e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  1.936e-001, 3.486e-003 center
replot  1.936e-001+ 2.000*( 1.000e+000* 2.142e-002*cos(t)+-1.637e-003* 2.909e-003*sin(t)),  3.486e-003 +2.000*( 1.637e-003* 2.142e-002*cos(t)+ 1.000e+000* 2.909e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.681e-001, 8.195e-003 center
replot  1.681e-001+ 2.000*( 1.000e+000* 2.264e-002*cos(t)+-6.487e-003* 4.945e-003*sin(t)),  8.195e-003 +2.000*( 6.487e-003* 2.264e-002*cos(t)+ 1.000e+000* 4.945e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.446e-001, 1.915e-002 center
replot  1.446e-001+ 2.000*( 9.998e-001* 2.561e-002*cos(t)+-1.887e-002* 8.242e-003*sin(t)),  1.915e-002 +2.000*( 1.887e-002* 2.561e-002*cos(t)+ 9.998e-001* 8.242e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.227e-001, 4.429e-002 center
replot  1.227e-001+ 2.000*( 9.969e-001* 2.815e-002*cos(t)+-7.808e-002* 1.752e-002*sin(t)),  4.429e-002 +2.000*( 7.808e-002* 2.815e-002*cos(t)+ 9.969e-001* 1.752e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.019e-001, 1.004e-001 center
replot  1.019e-001+ 2.000*( 7.211e-002* 5.189e-002*cos(t)+-9.974e-001* 2.909e-002*sin(t)),  1.004e-001 +2.000*( 9.974e-001* 5.189e-002*cos(t)+ 7.211e-002* 2.909e-002*sin(t)) not
set out;
set out "SEMsr/VARPIJGR_SEMsr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "SEMsr/VARPIJGR_SEMsr_123-13.svg"
set label "50" at  6.119e-003, 1.111e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  6.119e-003+ 2.000*( 9.997e-001* 3.931e-003*cos(t)+ 2.566e-002* 1.839e-004*sin(t)),  1.111e-004 +2.000*(-2.566e-002* 3.931e-003*cos(t)+ 9.997e-001* 1.839e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.006e-002, 2.636e-004 center
replot  1.006e-002+ 2.000*( 9.993e-001* 5.465e-003*cos(t)+ 3.827e-002* 3.718e-004*sin(t)),  2.636e-004 +2.000*(-3.827e-002* 5.465e-003*cos(t)+ 9.993e-001* 3.718e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  1.646e-002, 6.247e-004 center
replot  1.646e-002+ 2.000*( 9.983e-001* 7.353e-003*cos(t)+ 5.777e-002* 7.297e-004*sin(t)),  6.247e-004 +2.000*(-5.777e-002* 7.353e-003*cos(t)+ 9.983e-001* 7.297e-004*sin(t)) not
# Age 65, p23 - p13
set label "65" at  2.684e-002, 1.478e-003 center
replot  2.684e-002+ 2.000*( 9.961e-001* 9.493e-003*cos(t)+ 8.841e-002* 1.376e-003*sin(t)),  1.478e-003 +2.000*(-8.841e-002* 9.493e-003*cos(t)+ 9.961e-001* 1.376e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  4.354e-002, 3.486e-003 center
replot  4.354e-002+ 2.000*( 9.907e-001* 1.169e-002*cos(t)+ 1.360e-001* 2.459e-003*sin(t)),  3.486e-003 +2.000*(-1.360e-001* 1.169e-002*cos(t)+ 9.907e-001* 2.459e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  7.013e-002, 8.195e-003 center
replot  7.013e-002+ 2.000*( 9.804e-001* 1.408e-002*cos(t)+ 1.969e-001* 4.179e-003*sin(t)),  8.195e-003 +2.000*(-1.969e-001* 1.408e-002*cos(t)+ 9.804e-001* 4.179e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.119e-001, 1.915e-002 center
replot  1.119e-001+ 2.000*( 9.763e-001* 1.884e-002*cos(t)+ 2.163e-001* 7.353e-003*sin(t)),  1.915e-002 +2.000*(-2.163e-001* 1.884e-002*cos(t)+ 9.763e-001* 7.353e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.760e-001, 4.429e-002 center
replot  1.760e-001+ 2.000*( 9.765e-001* 3.286e-002*cos(t)+ 2.156e-001* 1.650e-002*sin(t)),  4.429e-002 +2.000*(-2.156e-001* 3.286e-002*cos(t)+ 9.765e-001* 1.650e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.712e-001, 1.004e-001 center
replot  2.712e-001+ 2.000*( 8.827e-001* 6.651e-002*cos(t)+ 4.699e-001* 4.680e-002*sin(t)),  1.004e-001 +2.000*(-4.699e-001* 6.651e-002*cos(t)+ 8.827e-001* 4.680e-002*sin(t)) not
set out;
set out "SEMsr/VARPIJGR_SEMsr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "SEMsr/VARPIJGR_SEMsr_123-21.svg"
set label "50" at  6.119e-003, 3.217e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  6.119e-003+ 2.000*( 1.843e-003* 7.203e-002*cos(t)+ 1.000e+000* 3.928e-003*sin(t)),  3.217e-001 +2.000*(-1.000e+000* 7.203e-002*cos(t)+ 1.843e-003* 3.928e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.006e-002, 2.851e-001 center
replot  1.006e-002+ 2.000*( 2.778e-003* 5.171e-002*cos(t)+ 1.000e+000* 5.459e-003*sin(t)),  2.851e-001 +2.000*(-1.000e+000* 5.171e-002*cos(t)+ 2.778e-003* 5.459e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  1.646e-002, 2.517e-001 center
replot  1.646e-002+ 2.000*( 4.953e-003* 3.586e-002*cos(t)+ 1.000e+000* 7.338e-003*sin(t)),  2.517e-001 +2.000*(-1.000e+000* 3.586e-002*cos(t)+ 4.953e-003* 7.338e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  2.684e-002, 2.213e-001 center
replot  2.684e-002+ 2.000*( 1.232e-002* 2.541e-002*cos(t)+ 9.999e-001* 9.452e-003*sin(t)),  2.213e-001 +2.000*(-9.999e-001* 2.541e-002*cos(t)+ 1.232e-002* 9.452e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  4.354e-002, 1.936e-001 center
replot  4.354e-002+ 2.000*( 3.227e-002* 2.143e-002*cos(t)+ 9.995e-001* 1.158e-002*sin(t)),  1.936e-001 +2.000*(-9.995e-001* 2.143e-002*cos(t)+ 3.227e-002* 1.158e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  7.013e-002, 1.681e-001 center
replot  7.013e-002+ 2.000*( 5.670e-002* 2.266e-002*cos(t)+ 9.984e-001* 1.379e-002*sin(t)),  1.681e-001 +2.000*(-9.984e-001* 2.266e-002*cos(t)+ 5.670e-002* 1.379e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.119e-001, 1.446e-001 center
replot  1.119e-001+ 2.000*( 1.132e-001* 2.569e-002*cos(t)+ 9.936e-001* 1.835e-002*sin(t)),  1.446e-001 +2.000*(-9.936e-001* 2.569e-002*cos(t)+ 1.132e-001* 1.835e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.760e-001, 1.227e-001 center
replot  1.760e-001+ 2.000*( 9.519e-001* 3.273e-002*cos(t)+ 3.063e-001* 2.757e-002*sin(t)),  1.227e-001 +2.000*(-3.063e-001* 3.273e-002*cos(t)+ 9.519e-001* 2.757e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.712e-001, 1.019e-001 center
replot  2.712e-001+ 2.000*( 9.965e-001* 6.286e-002*cos(t)+ 8.314e-002* 2.888e-002*sin(t)),  1.019e-001 +2.000*(-8.314e-002* 6.286e-002*cos(t)+ 9.965e-001* 2.888e-002*sin(t)) not
set out;
set out "SEMsr/VARPIJGR_SEMsr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "SEMsr/VARMUPTJGR--STABLBASED_SEMsr1.svg";
 plot "SEMsr/PRMORPREV-1-STABLBASED_SEMsr.txt"  u 1:($3) not w l lt 1 
 replot "SEMsr/PRMORPREV-1-STABLBASED_SEMsr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "SEMsr/PRMORPREV-1-STABLBASED_SEMsr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "SEMsr/VARMUPTJGR--STABLBASED_SEMsr1.svg";replot;set out;
