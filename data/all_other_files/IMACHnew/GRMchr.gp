
# IMaCh-0.99r45
# GRMchr.gp
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


set ter svg size 640, 480;set out "GRMchr/D_GRMchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "GRMchr/ILK_GRMchr-dest.png";
set log y;plot  "GRMchr/ILK_GRMchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "GRMchr/ILK_GRMchr-ori.png";
set log y;plot  "GRMchr/ILK_GRMchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "GRMchr/ILK_GRMchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "GRMchr/ILK_GRMchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "GRMchr/ILK_GRMchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "GRMchr/ILK_GRMchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "GRMchr/V_GRMchr_1-1-1.svg" 

#set out "V_GRMchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "GRMchr/VPL_GRMchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"GRMchr/VPL_GRMchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"GRMchr/VPL_GRMchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"GRMchr/P_GRMchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "GRMchr/V_GRMchr_2-1-1.svg" 

#set out "V_GRMchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "GRMchr/VPL_GRMchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"GRMchr/VPL_GRMchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"GRMchr/VPL_GRMchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"GRMchr/P_GRMchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "GRMchr/E_GRMchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "GRMchr/T_GRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"GRMchr/T_GRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"GRMchr/T_GRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"GRMchr/T_GRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"GRMchr/T_GRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"GRMchr/T_GRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"GRMchr/T_GRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"GRMchr/T_GRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"GRMchr/T_GRMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "GRMchr/E_GRMchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "GRMchr/EXP_GRMchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "GRMchr/E_GRMchr.txt" every :::0::0 u 1:2 t "e11" w l ,"GRMchr/E_GRMchr.txt" every :::0::0 u 1:3 t "e12" w l ,"GRMchr/E_GRMchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "GRMchr/EXP_GRMchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "GRMchr/E_GRMchr.txt" every :::0::0 u 1:5 t "e21" w l ,"GRMchr/E_GRMchr.txt" every :::0::0 u 1:6 t "e22" w l ,"GRMchr/E_GRMchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "GRMchr/LIJ_GRMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMchr/PIJ_GRMchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "GRMchr/LIJ_GRMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMchr/PIJ_GRMchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "GRMchr/LIJT_GRMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMchr/PIJ_GRMchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "GRMchr/LIJT_GRMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMchr/PIJ_GRMchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "GRMchr/P_GRMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMchr/PIJ_GRMchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "GRMchr/P_GRMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "GRMchr/PIJ_GRMchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-6.897749; p2=0.098968; 
#   current state 3
p3=-16.982935; p4=0.209474; 
# initial state 2
#   current state 1
p5=5.428444; p6=-0.116597; 
#   current state 3
p7=-10.679783; p8=0.114388; 
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

set out "GRMchr/PE_GRMchr_1-1-1.svg" 
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

set out "GRMchr/PE_GRMchr_1-2-1.svg" 
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

set out "GRMchr/PE_GRMchr_1-3-1.svg" 
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
set out "GRMchr/VARPIJGR_GRMchr_113-12.svg"
set label "50" at  6.511e-004, 6.223e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  6.511e-004+ 2.000*( 6.181e-003* 1.604e-002*cos(t)+-1.000e+000* 6.683e-004*sin(t)),  6.223e-002 +2.000*( 1.000e+000* 1.604e-002*cos(t)+ 6.181e-003* 6.683e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.715e-003, 9.433e-002 center
replot  1.715e-003+ 2.000*( 7.025e-003* 1.634e-002*cos(t)+-1.000e+000* 1.434e-003*sin(t)),  9.433e-002 +2.000*( 1.000e+000* 1.634e-002*cos(t)+ 7.025e-003* 1.434e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  4.337e-003, 1.373e-001 center
replot  4.337e-003+ 2.000*( 3.731e-003* 1.528e-002*cos(t)+ 1.000e+000* 2.829e-003*sin(t)),  1.373e-001 +2.000*(-1.000e+000* 1.528e-002*cos(t)+ 3.731e-003* 2.829e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.037e-002, 1.889e-001 center
replot  1.037e-002+ 2.000*( 3.454e-002* 1.673e-002*cos(t)+ 9.994e-001* 5.036e-003*sin(t)),  1.889e-001 +2.000*(-9.994e-001* 1.673e-002*cos(t)+ 3.454e-002* 5.036e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  2.309e-002, 2.420e-001 center
replot  2.309e-002+ 2.000*( 5.425e-002* 2.288e-002*cos(t)+ 9.985e-001* 8.454e-003*sin(t)),  2.420e-001 +2.000*(-9.985e-001* 2.288e-002*cos(t)+ 5.425e-002* 8.454e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  4.716e-002, 2.845e-001 center
replot  4.716e-002+ 2.000*( 1.839e-001* 2.944e-002*cos(t)+ 9.830e-001* 1.489e-002*sin(t)),  2.845e-001 +2.000*(-9.830e-001* 2.944e-002*cos(t)+ 1.839e-001* 1.489e-002*sin(t)) not
# Age 80, p13 - p12
set label "80" at  8.735e-002, 3.033e-001 center
replot  8.735e-002+ 2.000*( 6.363e-001* 4.375e-002*cos(t)+ 7.714e-001* 2.085e-002*sin(t)),  3.033e-001 +2.000*(-7.714e-001* 4.375e-002*cos(t)+ 6.363e-001* 2.085e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  1.455e-001, 2.906e-001 center
replot  1.455e-001+ 2.000*( 7.427e-001* 8.040e-002*cos(t)+ 6.697e-001* 1.762e-002*sin(t)),  2.906e-001 +2.000*(-6.697e-001* 8.040e-002*cos(t)+ 7.427e-001* 1.762e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  2.170e-001, 2.495e-001 center
replot  2.170e-001+ 2.000*( 7.414e-001* 1.260e-001*cos(t)+ 6.711e-001* 1.178e-002*sin(t)),  2.495e-001 +2.000*(-6.711e-001* 1.260e-001*cos(t)+ 7.414e-001* 1.178e-002*sin(t)) not
set out;
set out "GRMchr/VARPIJGR_GRMchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "GRMchr/VARPIJGR_GRMchr_121-12.svg"
set label "50" at  1.996e-001, 6.223e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  1.996e-001+ 2.000*( 1.000e+000* 2.935e-002*cos(t)+-8.911e-003* 1.604e-002*sin(t)),  6.223e-002 +2.000*( 8.911e-003* 2.935e-002*cos(t)+ 1.000e+000* 1.604e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  1.348e-001, 9.433e-002 center
replot  1.348e-001+ 2.000*( 9.975e-001* 1.778e-002*cos(t)+-7.008e-002* 1.634e-002*sin(t)),  9.433e-002 +2.000*( 7.008e-002* 1.778e-002*cos(t)+ 9.975e-001* 1.634e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  8.475e-002, 1.373e-001 center
replot  8.475e-002+ 2.000*( 1.201e-002* 1.528e-002*cos(t)+-9.999e-001* 9.482e-003*sin(t)),  1.373e-001 +2.000*( 9.999e-001* 1.528e-002*cos(t)+ 1.201e-002* 9.482e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  5.039e-002, 1.889e-001 center
replot  5.039e-002+ 2.000*( 4.076e-003* 1.672e-002*cos(t)+-1.000e+000* 5.839e-003*sin(t)),  1.889e-001 +2.000*( 1.000e+000* 1.672e-002*cos(t)+ 4.076e-003* 5.839e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.866e-002, 2.420e-001 center
replot  2.866e-002+ 2.000*( 1.683e-003* 2.285e-002*cos(t)+-1.000e+000* 4.515e-003*sin(t)),  2.420e-001 +2.000*( 1.000e+000* 2.285e-002*cos(t)+ 1.683e-003* 4.515e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.566e-002, 2.845e-001 center
replot  1.566e-002+ 2.000*( 6.719e-004* 2.907e-002*cos(t)+-1.000e+000* 3.462e-003*sin(t)),  2.845e-001 +2.000*( 1.000e+000* 2.907e-002*cos(t)+ 6.719e-004* 3.462e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  8.187e-003, 3.033e-001 center
replot  8.187e-003+ 2.000*( 1.945e-005* 3.627e-002*cos(t)+-1.000e+000* 2.405e-003*sin(t)),  3.033e-001 +2.000*( 1.000e+000* 3.627e-002*cos(t)+ 1.945e-005* 2.405e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  4.051e-003, 2.906e-001 center
replot  4.051e-003+ 2.000*( 1.332e-004* 5.541e-002*cos(t)+ 1.000e+000* 1.503e-003*sin(t)),  2.906e-001 +2.000*(-1.000e+000* 5.541e-002*cos(t)+ 1.332e-004* 1.503e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.871e-003, 2.495e-001 center
replot  1.871e-003+ 2.000*( 6.862e-005* 8.503e-002*cos(t)+ 1.000e+000* 8.473e-004*sin(t)),  2.495e-001 +2.000*(-1.000e+000* 8.503e-002*cos(t)+ 6.862e-005* 8.473e-004*sin(t)) not
set out;
set out "GRMchr/VARPIJGR_GRMchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "GRMchr/VARPIJGR_GRMchr_123-12.svg"
set label "50" at  2.091e-003, 6.223e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  2.091e-003+ 2.000*( 1.230e-004* 1.604e-002*cos(t)+ 1.000e+000* 8.950e-004*sin(t)),  6.223e-002 +2.000*(-1.000e+000* 1.604e-002*cos(t)+ 1.230e-004* 8.950e-004*sin(t)) not
# Age 55, p23 - p12
set label "55" at  4.480e-003, 9.433e-002 center
replot  4.480e-003+ 2.000*( 1.116e-004* 1.634e-002*cos(t)+ 1.000e+000* 1.575e-003*sin(t)),  9.433e-002 +2.000*(-1.000e+000* 1.634e-002*cos(t)+ 1.116e-004* 1.575e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  8.941e-003, 1.373e-001 center
replot  8.941e-003+ 2.000*( 6.025e-005* 1.528e-002*cos(t)+ 1.000e+000* 2.514e-003*sin(t)),  1.373e-001 +2.000*(-1.000e+000* 1.528e-002*cos(t)+ 6.025e-005* 2.514e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.687e-002, 1.889e-001 center
replot  1.687e-002+ 2.000*( 1.539e-005* 1.672e-002*cos(t)+-1.000e+000* 3.623e-003*sin(t)),  1.889e-001 +2.000*( 1.000e+000* 1.672e-002*cos(t)+ 1.539e-005* 3.623e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  3.045e-002, 2.420e-001 center
replot  3.045e-002+ 2.000*( 6.197e-005* 2.285e-002*cos(t)+-1.000e+000* 4.701e-003*sin(t)),  2.420e-001 +2.000*( 1.000e+000* 2.285e-002*cos(t)+ 6.197e-005* 4.701e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  5.281e-002, 2.845e-001 center
replot  5.281e-002+ 2.000*( 2.159e-004* 2.907e-002*cos(t)+-1.000e+000* 5.720e-003*sin(t)),  2.845e-001 +2.000*( 1.000e+000* 2.907e-002*cos(t)+ 2.159e-004* 5.720e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  8.763e-002, 3.033e-001 center
replot  8.763e-002+ 2.000*( 6.443e-004* 3.627e-002*cos(t)+-1.000e+000* 8.036e-003*sin(t)),  3.033e-001 +2.000*( 1.000e+000* 3.627e-002*cos(t)+ 6.443e-004* 8.036e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.376e-001, 2.906e-001 center
replot  1.376e-001+ 2.000*( 9.388e-004* 5.541e-002*cos(t)+-1.000e+000* 1.415e-002*sin(t)),  2.906e-001 +2.000*( 1.000e+000* 5.541e-002*cos(t)+ 9.388e-004* 1.415e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.017e-001, 2.495e-001 center
replot  2.017e-001+ 2.000*( 9.363e-004* 8.503e-002*cos(t)+-1.000e+000* 2.345e-002*sin(t)),  2.495e-001 +2.000*( 1.000e+000* 8.503e-002*cos(t)+ 9.363e-004* 2.345e-002*sin(t)) not
set out;
set out "GRMchr/VARPIJGR_GRMchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "GRMchr/VARPIJGR_GRMchr_121-13.svg"
set label "50" at  1.996e-001, 6.511e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  1.996e-001+ 2.000*( 1.000e+000* 2.935e-002*cos(t)+-7.948e-005* 6.756e-004*sin(t)),  6.511e-004 +2.000*( 7.948e-005* 2.935e-002*cos(t)+ 1.000e+000* 6.756e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  1.348e-001, 1.715e-003 center
replot  1.348e-001+ 2.000*( 1.000e+000* 1.777e-002*cos(t)+-1.736e-004* 1.439e-003*sin(t)),  1.715e-003 +2.000*( 1.736e-004* 1.777e-002*cos(t)+ 1.000e+000* 1.439e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  8.475e-002, 4.337e-003 center
replot  8.475e-002+ 2.000*( 1.000e+000* 9.483e-003*cos(t)+-2.773e-004* 2.830e-003*sin(t)),  4.337e-003 +2.000*( 2.773e-004* 9.483e-003*cos(t)+ 1.000e+000* 2.830e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  5.039e-002, 1.037e-002 center
replot  5.039e-002+ 2.000*( 1.000e+000* 5.839e-003*cos(t)+-5.759e-003* 5.066e-003*sin(t)),  1.037e-002 +2.000*( 5.759e-003* 5.839e-003*cos(t)+ 1.000e+000* 5.066e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.866e-002, 2.309e-002 center
replot  2.866e-002+ 2.000*( 4.203e-003* 8.532e-003*cos(t)+-1.000e+000* 4.515e-003*sin(t)),  2.309e-002 +2.000*( 1.000e+000* 8.532e-003*cos(t)+ 4.203e-003* 4.515e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.566e-002, 4.716e-002 center
replot  1.566e-002+ 2.000*( 2.292e-003* 1.560e-002*cos(t)+-1.000e+000* 3.462e-003*sin(t)),  4.716e-002 +2.000*( 1.000e+000* 1.560e-002*cos(t)+ 2.292e-003* 3.462e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  8.187e-003, 8.735e-002 center
replot  8.187e-003+ 2.000*( 8.000e-004* 3.215e-002*cos(t)+-1.000e+000* 2.405e-003*sin(t)),  8.735e-002 +2.000*( 1.000e+000* 3.215e-002*cos(t)+ 8.000e-004* 2.405e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  4.051e-003, 1.455e-001 center
replot  4.051e-003+ 2.000*( 2.418e-004* 6.087e-002*cos(t)+-1.000e+000* 1.503e-003*sin(t)),  1.455e-001 +2.000*( 1.000e+000* 6.087e-002*cos(t)+ 2.418e-004* 1.503e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.871e-003, 2.170e-001 center
replot  1.871e-003+ 2.000*( 8.009e-005* 9.377e-002*cos(t)+-1.000e+000* 8.473e-004*sin(t)),  2.170e-001 +2.000*( 1.000e+000* 9.377e-002*cos(t)+ 8.009e-005* 8.473e-004*sin(t)) not
set out;
set out "GRMchr/VARPIJGR_GRMchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "GRMchr/VARPIJGR_GRMchr_123-13.svg"
set label "50" at  2.091e-003, 6.511e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  2.091e-003+ 2.000*( 1.000e+000* 8.950e-004*cos(t)+ 4.932e-003* 6.756e-004*sin(t)),  6.511e-004 +2.000*(-4.932e-003* 8.950e-004*cos(t)+ 1.000e+000* 6.756e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  4.480e-003, 1.715e-003 center
replot  4.480e-003+ 2.000*( 9.999e-001* 1.575e-003*cos(t)+ 1.337e-002* 1.439e-003*sin(t)),  1.715e-003 +2.000*(-1.337e-002* 1.575e-003*cos(t)+ 9.999e-001* 1.439e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  8.941e-003, 4.337e-003 center
replot  8.941e-003+ 2.000*( 9.958e-003* 2.830e-003*cos(t)+ 1.000e+000* 2.514e-003*sin(t)),  4.337e-003 +2.000*(-1.000e+000* 2.830e-003*cos(t)+ 9.958e-003* 2.514e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.687e-002, 1.037e-002 center
replot  1.687e-002+ 2.000*( 3.898e-003* 5.067e-003*cos(t)+ 1.000e+000* 3.623e-003*sin(t)),  1.037e-002 +2.000*(-1.000e+000* 5.067e-003*cos(t)+ 3.898e-003* 3.623e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  3.045e-002, 2.309e-002 center
replot  3.045e-002+ 2.000*( 2.720e-003* 8.532e-003*cos(t)+ 1.000e+000* 4.701e-003*sin(t)),  2.309e-002 +2.000*(-1.000e+000* 8.532e-003*cos(t)+ 2.720e-003* 4.701e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  5.281e-002, 4.716e-002 center
replot  5.281e-002+ 2.000*( 1.889e-003* 1.560e-002*cos(t)+ 1.000e+000* 5.720e-003*sin(t)),  4.716e-002 +2.000*(-1.000e+000* 1.560e-002*cos(t)+ 1.889e-003* 5.720e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  8.763e-002, 8.735e-002 center
replot  8.763e-002+ 2.000*( 1.241e-003* 3.215e-002*cos(t)+ 1.000e+000* 8.036e-003*sin(t)),  8.735e-002 +2.000*(-1.000e+000* 3.215e-002*cos(t)+ 1.241e-003* 8.036e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.376e-001, 1.455e-001 center
replot  1.376e-001+ 2.000*( 9.495e-004* 6.087e-002*cos(t)+ 1.000e+000* 1.415e-002*sin(t)),  1.455e-001 +2.000*(-1.000e+000* 6.087e-002*cos(t)+ 9.495e-004* 1.415e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.017e-001, 2.170e-001 center
replot  2.017e-001+ 2.000*( 8.580e-004* 9.377e-002*cos(t)+ 1.000e+000* 2.345e-002*sin(t)),  2.170e-001 +2.000*(-1.000e+000* 9.377e-002*cos(t)+ 8.580e-004* 2.345e-002*sin(t)) not
set out;
set out "GRMchr/VARPIJGR_GRMchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "GRMchr/VARPIJGR_GRMchr_123-21.svg"
set label "50" at  2.091e-003, 1.996e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  2.091e-003+ 2.000*( 6.505e-003* 2.935e-002*cos(t)+ 1.000e+000* 8.744e-004*sin(t)),  1.996e-001 +2.000*(-1.000e+000* 2.935e-002*cos(t)+ 6.505e-003* 8.744e-004*sin(t)) not
# Age 55, p23 - p21
set label "55" at  4.480e-003, 1.348e-001 center
replot  4.480e-003+ 2.000*( 1.127e-002* 1.777e-002*cos(t)+ 9.999e-001* 1.563e-003*sin(t)),  1.348e-001 +2.000*(-9.999e-001* 1.777e-002*cos(t)+ 1.127e-002* 1.563e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  8.941e-003, 8.475e-002 center
replot  8.941e-003+ 2.000*( 2.198e-002* 9.485e-003*cos(t)+ 9.998e-001* 2.506e-003*sin(t)),  8.475e-002 +2.000*(-9.998e-001* 9.485e-003*cos(t)+ 2.198e-002* 2.506e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.687e-002, 5.039e-002 center
replot  1.687e-002+ 2.000*( 6.734e-002* 5.848e-003*cos(t)+ 9.977e-001* 3.610e-003*sin(t)),  5.039e-002 +2.000*(-9.977e-001* 5.848e-003*cos(t)+ 6.734e-002* 3.610e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  3.045e-002, 2.866e-002 center
replot  3.045e-002+ 2.000*( 8.662e-001* 4.791e-003*cos(t)+ 4.997e-001* 4.419e-003*sin(t)),  2.866e-002 +2.000*(-4.997e-001* 4.791e-003*cos(t)+ 8.662e-001* 4.419e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  5.281e-002, 1.566e-002 center
replot  5.281e-002+ 2.000*( 9.979e-001* 5.728e-003*cos(t)+ 6.494e-002* 3.449e-003*sin(t)),  1.566e-002 +2.000*(-6.494e-002* 5.728e-003*cos(t)+ 9.979e-001* 3.449e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  8.763e-002, 8.187e-003 center
replot  8.763e-002+ 2.000*( 9.997e-001* 8.038e-003*cos(t)+ 2.286e-002* 2.398e-003*sin(t)),  8.187e-003 +2.000*(-2.286e-002* 8.038e-003*cos(t)+ 9.997e-001* 2.398e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.376e-001, 4.051e-003 center
replot  1.376e-001+ 2.000*( 9.999e-001* 1.415e-002*cos(t)+ 1.057e-002* 1.496e-003*sin(t)),  4.051e-003 +2.000*(-1.057e-002* 1.415e-002*cos(t)+ 9.999e-001* 1.496e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.017e-001, 1.871e-003 center
replot  2.017e-001+ 2.000*( 1.000e+000* 2.345e-002*cos(t)+ 5.855e-003* 8.361e-004*sin(t)),  1.871e-003 +2.000*(-5.855e-003* 2.345e-002*cos(t)+ 1.000e+000* 8.361e-004*sin(t)) not
set out;
set out "GRMchr/VARPIJGR_GRMchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "GRMchr/VARMUPTJGR--STABLBASED_GRMchr1.svg";
 plot "GRMchr/PRMORPREV-1-STABLBASED_GRMchr.txt"  u 1:($3) not w l lt 1 
 replot "GRMchr/PRMORPREV-1-STABLBASED_GRMchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "GRMchr/PRMORPREV-1-STABLBASED_GRMchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "GRMchr/VARMUPTJGR--STABLBASED_GRMchr1.svg";replot;set out;
