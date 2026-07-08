
# IMaCh-0.99r45
# ESFchr.gp
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


set ter svg size 640, 480;set out "ESFchr/D_ESFchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "ESFchr/ILK_ESFchr-dest.png";
set log y;plot  "ESFchr/ILK_ESFchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "ESFchr/ILK_ESFchr-ori.png";
set log y;plot  "ESFchr/ILK_ESFchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "ESFchr/ILK_ESFchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ESFchr/ILK_ESFchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "ESFchr/ILK_ESFchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ESFchr/ILK_ESFchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "ESFchr/V_ESFchr_1-1-1.svg" 

#set out "V_ESFchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ESFchr/VPL_ESFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"ESFchr/VPL_ESFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"ESFchr/VPL_ESFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"ESFchr/P_ESFchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "ESFchr/V_ESFchr_2-1-1.svg" 

#set out "V_ESFchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ESFchr/VPL_ESFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"ESFchr/VPL_ESFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"ESFchr/VPL_ESFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"ESFchr/P_ESFchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "ESFchr/E_ESFchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "ESFchr/T_ESFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"ESFchr/T_ESFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"ESFchr/T_ESFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"ESFchr/T_ESFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"ESFchr/T_ESFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"ESFchr/T_ESFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"ESFchr/T_ESFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"ESFchr/T_ESFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"ESFchr/T_ESFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "ESFchr/E_ESFchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "ESFchr/EXP_ESFchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ESFchr/E_ESFchr.txt" every :::0::0 u 1:2 t "e11" w l ,"ESFchr/E_ESFchr.txt" every :::0::0 u 1:3 t "e12" w l ,"ESFchr/E_ESFchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "ESFchr/EXP_ESFchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ESFchr/E_ESFchr.txt" every :::0::0 u 1:5 t "e21" w l ,"ESFchr/E_ESFchr.txt" every :::0::0 u 1:6 t "e22" w l ,"ESFchr/E_ESFchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "ESFchr/LIJ_ESFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFchr/PIJ_ESFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "ESFchr/LIJ_ESFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFchr/PIJ_ESFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "ESFchr/LIJT_ESFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFchr/PIJ_ESFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "ESFchr/LIJT_ESFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFchr/PIJ_ESFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "ESFchr/P_ESFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFchr/PIJ_ESFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "ESFchr/P_ESFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFchr/PIJ_ESFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-2.944047; p2=0.046465; 
#   current state 3
p3=-9.159681; p4=0.089391; 
# initial state 2
#   current state 1
p5=2.648714; p6=-0.075875; 
#   current state 3
p7=-12.969479; p8=0.135839; 
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

set out "ESFchr/PE_ESFchr_1-1-1.svg" 
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

set out "ESFchr/PE_ESFchr_1-2-1.svg" 
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

set out "ESFchr/PE_ESFchr_1-3-1.svg" 
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
set out "ESFchr/VARPIJGR_ESFchr_113-12.svg"
set label "50" at  2.969e-003, 1.738e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  2.969e-003+ 2.000*( 6.284e-004* 1.785e-002*cos(t)+-1.000e+000* 2.031e-003*sin(t)),  1.738e-001 +2.000*( 1.000e+000* 1.785e-002*cos(t)+ 6.284e-004* 2.031e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  4.243e-003, 2.003e-001 center
replot  4.243e-003+ 2.000*( 9.611e-003* 1.321e-002*cos(t)+ 1.000e+000* 2.249e-003*sin(t)),  2.003e-001 +2.000*(-1.000e+000* 1.321e-002*cos(t)+ 9.611e-003* 2.249e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  5.979e-003, 2.278e-001 center
replot  5.979e-003+ 2.000*( 1.918e-002* 1.206e-002*cos(t)+ 9.998e-001* 2.552e-003*sin(t)),  2.278e-001 +2.000*(-9.998e-001* 1.206e-002*cos(t)+ 1.918e-002* 2.552e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  8.304e-003, 2.552e-001 center
replot  8.304e-003+ 2.000*( 1.588e-002* 1.608e-002*cos(t)+ 9.999e-001* 3.427e-003*sin(t)),  2.552e-001 +2.000*(-9.999e-001* 1.608e-002*cos(t)+ 1.588e-002* 3.427e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.136e-002, 2.817e-001 center
replot  1.136e-002+ 2.000*( 2.647e-002* 2.234e-002*cos(t)+ 9.996e-001* 5.556e-003*sin(t)),  2.817e-001 +2.000*(-9.996e-001* 2.234e-002*cos(t)+ 2.647e-002* 5.556e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.531e-002, 3.063e-001 center
replot  1.531e-002+ 2.000*( 6.759e-002* 2.871e-002*cos(t)+ 9.977e-001* 9.395e-003*sin(t)),  3.063e-001 +2.000*(-9.977e-001* 2.871e-002*cos(t)+ 6.759e-002* 9.395e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  2.033e-002, 3.282e-001 center
replot  2.033e-002+ 2.000*( 1.708e-001* 3.492e-002*cos(t)+ 9.853e-001* 1.498e-002*sin(t)),  3.282e-001 +2.000*(-9.853e-001* 3.492e-002*cos(t)+ 1.708e-001* 1.498e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  2.661e-002, 3.466e-001 center
replot  2.661e-002+ 2.000*( 3.709e-001* 4.267e-002*cos(t)+ 9.287e-001* 2.117e-002*sin(t)),  3.466e-001 +2.000*(-9.287e-001* 4.267e-002*cos(t)+ 3.709e-001* 2.117e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  3.435e-002, 3.610e-001 center
replot  3.435e-002+ 2.000*( 5.764e-001* 5.583e-002*cos(t)+ 8.171e-001* 2.527e-002*sin(t)),  3.610e-001 +2.000*(-8.171e-001* 5.583e-002*cos(t)+ 5.764e-001* 2.527e-002*sin(t)) not
set out;
set out "ESFchr/VARPIJGR_ESFchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ESFchr/VARPIJGR_ESFchr_121-12.svg"
set label "50" at  1.205e-001, 1.738e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  1.205e-001+ 2.000*( 6.600e-002* 1.786e-002*cos(t)+-9.978e-001* 1.383e-002*sin(t)),  1.738e-001 +2.000*( 9.978e-001* 1.786e-002*cos(t)+ 6.600e-002* 1.383e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  8.911e-002, 2.003e-001 center
replot  8.911e-002+ 2.000*( 4.035e-002* 1.322e-002*cos(t)+-9.992e-001* 8.420e-003*sin(t)),  2.003e-001 +2.000*( 9.992e-001* 1.322e-002*cos(t)+ 4.035e-002* 8.420e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  6.439e-002, 2.278e-001 center
replot  6.439e-002+ 2.000*( 2.116e-002* 1.206e-002*cos(t)+-9.998e-001* 5.106e-003*sin(t)),  2.278e-001 +2.000*( 9.998e-001* 1.206e-002*cos(t)+ 2.116e-002* 5.106e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  4.561e-002, 2.552e-001 center
replot  4.561e-002+ 2.000*( 9.762e-003* 1.608e-002*cos(t)+-1.000e+000* 3.721e-003*sin(t)),  2.552e-001 +2.000*( 1.000e+000* 1.608e-002*cos(t)+ 9.762e-003* 3.721e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  3.168e-002, 2.817e-001 center
replot  3.168e-002+ 2.000*( 5.559e-003* 2.233e-002*cos(t)+-1.000e+000* 3.325e-003*sin(t)),  2.817e-001 +2.000*( 1.000e+000* 2.233e-002*cos(t)+ 5.559e-003* 3.325e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.151e-002, 3.063e-001 center
replot  2.151e-002+ 2.000*( 3.472e-003* 2.866e-002*cos(t)+-1.000e+000* 3.036e-003*sin(t)),  3.063e-001 +2.000*( 1.000e+000* 2.866e-002*cos(t)+ 3.472e-003* 3.036e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.415e-002, 3.282e-001 center
replot  1.415e-002+ 2.000*( 2.095e-003* 3.450e-002*cos(t)+-1.000e+000* 2.595e-003*sin(t)),  3.282e-001 +2.000*( 1.000e+000* 3.450e-002*cos(t)+ 2.095e-003* 2.595e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  8.848e-003, 3.466e-001 center
replot  8.848e-003+ 2.000*( 1.092e-003* 4.040e-002*cos(t)+-1.000e+000* 2.028e-003*sin(t)),  3.466e-001 +2.000*( 1.000e+000* 4.040e-002*cos(t)+ 1.092e-003* 2.028e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  5.132e-003, 3.610e-001 center
replot  5.132e-003+ 2.000*( 4.265e-004* 4.789e-002*cos(t)+-1.000e+000* 1.431e-003*sin(t)),  3.610e-001 +2.000*( 1.000e+000* 4.789e-002*cos(t)+ 4.265e-004* 1.431e-003*sin(t)) not
set out;
set out "ESFchr/VARPIJGR_ESFchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ESFchr/VARPIJGR_ESFchr_123-12.svg"
set label "50" at  7.860e-004, 1.738e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  7.860e-004+ 2.000*( 3.277e-005* 1.785e-002*cos(t)+ 1.000e+000* 3.300e-004*sin(t)),  1.738e-001 +2.000*(-1.000e+000* 1.785e-002*cos(t)+ 3.277e-005* 3.300e-004*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.675e-003, 2.003e-001 center
replot  1.675e-003+ 2.000*( 2.054e-005* 1.321e-002*cos(t)+ 1.000e+000* 5.939e-004*sin(t)),  2.003e-001 +2.000*(-1.000e+000* 1.321e-002*cos(t)+ 2.054e-005* 5.939e-004*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.489e-003, 2.278e-001 center
replot  3.489e-003+ 2.000*( 6.923e-005* 1.206e-002*cos(t)+-1.000e+000* 1.013e-003*sin(t)),  2.278e-001 +2.000*( 1.000e+000* 1.206e-002*cos(t)+ 6.923e-005* 1.013e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  7.122e-003, 2.552e-001 center
replot  7.122e-003+ 2.000*( 1.582e-004* 1.608e-002*cos(t)+-1.000e+000* 1.623e-003*sin(t)),  2.552e-001 +2.000*( 1.000e+000* 1.608e-002*cos(t)+ 1.582e-004* 1.623e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  1.426e-002, 2.817e-001 center
replot  1.426e-002+ 2.000*( 2.552e-004* 2.233e-002*cos(t)+-1.000e+000* 2.406e-003*sin(t)),  2.817e-001 +2.000*( 1.000e+000* 2.233e-002*cos(t)+ 2.552e-004* 2.406e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  2.791e-002, 3.063e-001 center
replot  2.791e-002+ 2.000*( 4.451e-004* 2.866e-002*cos(t)+-1.000e+000* 3.299e-003*sin(t)),  3.063e-001 +2.000*( 1.000e+000* 2.866e-002*cos(t)+ 4.451e-004* 3.299e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  5.289e-002, 3.282e-001 center
replot  5.289e-002+ 2.000*( 7.649e-004* 3.450e-002*cos(t)+-1.000e+000* 4.717e-003*sin(t)),  3.282e-001 +2.000*( 1.000e+000* 3.450e-002*cos(t)+ 7.649e-004* 4.717e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  9.537e-002, 3.466e-001 center
replot  9.537e-002+ 2.000*( 1.135e-003* 4.040e-002*cos(t)+-1.000e+000* 8.796e-003*sin(t)),  3.466e-001 +2.000*( 1.000e+000* 4.040e-002*cos(t)+ 1.135e-003* 8.796e-003*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.594e-001, 3.610e-001 center
replot  1.594e-001+ 2.000*( 1.250e-003* 4.789e-002*cos(t)+-1.000e+000* 1.710e-002*sin(t)),  3.610e-001 +2.000*( 1.000e+000* 4.789e-002*cos(t)+ 1.250e-003* 1.710e-002*sin(t)) not
set out;
set out "ESFchr/VARPIJGR_ESFchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ESFchr/VARPIJGR_ESFchr_121-13.svg"
set label "50" at  1.205e-001, 2.969e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  1.205e-001+ 2.000*( 1.000e+000* 1.385e-002*cos(t)+-1.038e-003* 2.031e-003*sin(t)),  2.969e-003 +2.000*( 1.038e-003* 1.385e-002*cos(t)+ 1.000e+000* 2.031e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  8.911e-002, 4.243e-003 center
replot  8.911e-002+ 2.000*( 1.000e+000* 8.430e-003*cos(t)+-1.439e-003* 2.252e-003*sin(t)),  4.243e-003 +2.000*( 1.439e-003* 8.430e-003*cos(t)+ 1.000e+000* 2.252e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  6.439e-002, 5.979e-003 center
replot  6.439e-002+ 2.000*( 1.000e+000* 5.111e-003*cos(t)+-5.152e-003* 2.562e-003*sin(t)),  5.979e-003 +2.000*( 5.152e-003* 5.111e-003*cos(t)+ 1.000e+000* 2.562e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  4.561e-002, 8.304e-003 center
replot  4.561e-002+ 2.000*( 9.941e-001* 3.728e-003*cos(t)+-1.086e-001* 3.433e-003*sin(t)),  8.304e-003 +2.000*( 1.086e-001* 3.728e-003*cos(t)+ 9.941e-001* 3.433e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  3.168e-002, 1.136e-002 center
replot  3.168e-002+ 2.000*( 2.264e-002* 5.586e-003*cos(t)+-9.997e-001* 3.326e-003*sin(t)),  1.136e-002 +2.000*( 9.997e-001* 5.586e-003*cos(t)+ 2.264e-002* 3.326e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.151e-002, 1.531e-002 center
replot  2.151e-002+ 2.000*( 8.899e-003* 9.573e-003*cos(t)+-1.000e+000* 3.037e-003*sin(t)),  1.531e-002 +2.000*( 1.000e+000* 9.573e-003*cos(t)+ 8.899e-003* 3.037e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.415e-002, 2.033e-002 center
replot  1.415e-002+ 2.000*( 4.011e-003* 1.592e-002*cos(t)+-1.000e+000* 2.595e-003*sin(t)),  2.033e-002 +2.000*( 1.000e+000* 1.592e-002*cos(t)+ 4.011e-003* 2.595e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  8.848e-003, 2.661e-002 center
replot  8.848e-003+ 2.000*( 1.803e-003* 2.524e-002*cos(t)+-1.000e+000* 2.028e-003*sin(t)),  2.661e-002 +2.000*( 1.000e+000* 2.524e-002*cos(t)+ 1.803e-003* 2.028e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  5.132e-003, 3.435e-002 center
replot  5.132e-003+ 2.000*( 7.676e-004* 3.824e-002*cos(t)+-1.000e+000* 1.431e-003*sin(t)),  3.435e-002 +2.000*( 1.000e+000* 3.824e-002*cos(t)+ 7.676e-004* 1.431e-003*sin(t)) not
set out;
set out "ESFchr/VARPIJGR_ESFchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ESFchr/VARPIJGR_ESFchr_123-13.svg"
set label "50" at  7.860e-004, 2.969e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  7.860e-004+ 2.000*( 2.045e-003* 2.031e-003*cos(t)+ 1.000e+000* 3.300e-004*sin(t)),  2.969e-003 +2.000*(-1.000e+000* 2.031e-003*cos(t)+ 2.045e-003* 3.300e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.675e-003, 4.243e-003 center
replot  1.675e-003+ 2.000*( 4.806e-003* 2.252e-003*cos(t)+ 1.000e+000* 5.938e-004*sin(t)),  4.243e-003 +2.000*(-1.000e+000* 2.252e-003*cos(t)+ 4.806e-003* 5.938e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.489e-003, 5.979e-003 center
replot  3.489e-003+ 2.000*( 1.099e-002* 2.562e-003*cos(t)+ 9.999e-001* 1.013e-003*sin(t)),  5.979e-003 +2.000*(-9.999e-001* 2.562e-003*cos(t)+ 1.099e-002* 1.013e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  7.122e-003, 8.304e-003 center
replot  7.122e-003+ 2.000*( 1.698e-002* 3.437e-003*cos(t)+ 9.999e-001* 1.622e-003*sin(t)),  8.304e-003 +2.000*(-9.999e-001* 3.437e-003*cos(t)+ 1.698e-002* 1.622e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  1.426e-002, 1.136e-002 center
replot  1.426e-002+ 2.000*( 1.470e-002* 5.586e-003*cos(t)+ 9.999e-001* 2.405e-003*sin(t)),  1.136e-002 +2.000*(-9.999e-001* 5.586e-003*cos(t)+ 1.470e-002* 2.405e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  2.791e-002, 1.531e-002 center
replot  2.791e-002+ 2.000*( 1.014e-002* 9.573e-003*cos(t)+ 9.999e-001* 3.298e-003*sin(t)),  1.531e-002 +2.000*(-9.999e-001* 9.573e-003*cos(t)+ 1.014e-002* 3.298e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  5.289e-002, 2.033e-002 center
replot  5.289e-002+ 2.000*( 6.840e-003* 1.592e-002*cos(t)+ 1.000e+000* 4.716e-003*sin(t)),  2.033e-002 +2.000*(-1.000e+000* 1.592e-002*cos(t)+ 6.840e-003* 4.716e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  9.537e-002, 2.661e-002 center
replot  9.537e-002+ 2.000*( 4.479e-003* 2.524e-002*cos(t)+ 1.000e+000* 8.796e-003*sin(t)),  2.661e-002 +2.000*(-1.000e+000* 2.524e-002*cos(t)+ 4.479e-003* 8.796e-003*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.594e-001, 3.435e-002 center
replot  1.594e-001+ 2.000*( 2.450e-003* 3.824e-002*cos(t)+ 1.000e+000* 1.710e-002*sin(t)),  3.435e-002 +2.000*(-1.000e+000* 3.824e-002*cos(t)+ 2.450e-003* 1.710e-002*sin(t)) not
set out;
set out "ESFchr/VARPIJGR_ESFchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "ESFchr/VARPIJGR_ESFchr_123-21.svg"
set label "50" at  7.860e-004, 1.205e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  7.860e-004+ 2.000*( 1.852e-003* 1.385e-002*cos(t)+ 1.000e+000* 3.290e-004*sin(t)),  1.205e-001 +2.000*(-1.000e+000* 1.385e-002*cos(t)+ 1.852e-003* 3.290e-004*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.675e-003, 8.911e-002 center
replot  1.675e-003+ 2.000*( 3.656e-003* 8.430e-003*cos(t)+ 1.000e+000* 5.931e-004*sin(t)),  8.911e-002 +2.000*(-1.000e+000* 8.430e-003*cos(t)+ 3.656e-003* 5.931e-004*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.489e-003, 6.439e-002 center
replot  3.489e-003+ 2.000*( 8.487e-003* 5.111e-003*cos(t)+ 1.000e+000* 1.012e-003*sin(t)),  6.439e-002 +2.000*(-1.000e+000* 5.111e-003*cos(t)+ 8.487e-003* 1.012e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  7.122e-003, 4.561e-002 center
replot  7.122e-003+ 2.000*( 2.452e-002* 3.725e-003*cos(t)+ 9.997e-001* 1.621e-003*sin(t)),  4.561e-002 +2.000*(-9.997e-001* 3.725e-003*cos(t)+ 2.452e-002* 1.621e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  1.426e-002, 3.168e-002 center
replot  1.426e-002+ 2.000*( 8.113e-002* 3.332e-003*cos(t)+ 9.967e-001* 2.399e-003*sin(t)),  3.168e-002 +2.000*(-9.967e-001* 3.332e-003*cos(t)+ 8.113e-002* 2.399e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  2.791e-002, 2.151e-002 center
replot  2.791e-002+ 2.000*( 9.520e-001* 3.328e-003*cos(t)+ 3.060e-001* 3.006e-003*sin(t)),  2.151e-002 +2.000*(-3.060e-001* 3.328e-003*cos(t)+ 9.520e-001* 3.006e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  5.289e-002, 1.415e-002 center
replot  5.289e-002+ 2.000*( 9.988e-001* 4.721e-003*cos(t)+ 4.998e-002* 2.589e-003*sin(t)),  1.415e-002 +2.000*(-4.998e-002* 4.721e-003*cos(t)+ 9.988e-001* 2.589e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  9.537e-002, 8.848e-003 center
replot  9.537e-002+ 2.000*( 9.998e-001* 8.798e-003*cos(t)+ 2.210e-002* 2.019e-003*sin(t)),  8.848e-003 +2.000*(-2.210e-002* 8.798e-003*cos(t)+ 9.998e-001* 2.019e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.594e-001, 5.132e-003 center
replot  1.594e-001+ 2.000*( 9.999e-001* 1.711e-002*cos(t)+ 1.426e-002* 1.410e-003*sin(t)),  5.132e-003 +2.000*(-1.426e-002* 1.711e-002*cos(t)+ 9.999e-001* 1.410e-003*sin(t)) not
set out;
set out "ESFchr/VARPIJGR_ESFchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "ESFchr/VARMUPTJGR--STABLBASED_ESFchr1.svg";
 plot "ESFchr/PRMORPREV-1-STABLBASED_ESFchr.txt"  u 1:($3) not w l lt 1 
 replot "ESFchr/PRMORPREV-1-STABLBASED_ESFchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "ESFchr/PRMORPREV-1-STABLBASED_ESFchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "ESFchr/VARMUPTJGR--STABLBASED_ESFchr1.svg";replot;set out;
