
# IMaCh-0.99r45
# SEFadl.gp
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


set ter svg size 640, 480;set out "SEFadl/D_SEFadl_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "SEFadl/ILK_SEFadl-dest.png";
set log y;plot  "SEFadl/ILK_SEFadl.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "SEFadl/ILK_SEFadl-ori.png";
set log y;plot  "SEFadl/ILK_SEFadl.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "SEFadl/ILK_SEFadl-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "SEFadl/ILK_SEFadl.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "SEFadl/ILK_SEFadl-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "SEFadl/ILK_SEFadl.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "SEFadl/V_SEFadl_1-1-1.svg" 

#set out "V_SEFadl_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "SEFadl/VPL_SEFadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"SEFadl/VPL_SEFadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"SEFadl/VPL_SEFadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"SEFadl/P_SEFadl.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "SEFadl/V_SEFadl_2-1-1.svg" 

#set out "V_SEFadl_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "SEFadl/VPL_SEFadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"SEFadl/VPL_SEFadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"SEFadl/VPL_SEFadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"SEFadl/P_SEFadl.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "SEFadl/E_SEFadl_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "SEFadl/T_SEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"SEFadl/T_SEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"SEFadl/T_SEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"SEFadl/T_SEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"SEFadl/T_SEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"SEFadl/T_SEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"SEFadl/T_SEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"SEFadl/T_SEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"SEFadl/T_SEFadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "SEFadl/E_SEFadl_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "SEFadl/EXP_SEFadl_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "SEFadl/E_SEFadl.txt" every :::0::0 u 1:2 t "e11" w l ,"SEFadl/E_SEFadl.txt" every :::0::0 u 1:3 t "e12" w l ,"SEFadl/E_SEFadl.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "SEFadl/EXP_SEFadl_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "SEFadl/E_SEFadl.txt" every :::0::0 u 1:5 t "e21" w l ,"SEFadl/E_SEFadl.txt" every :::0::0 u 1:6 t "e22" w l ,"SEFadl/E_SEFadl.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "SEFadl/LIJ_SEFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFadl/PIJ_SEFadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "SEFadl/LIJ_SEFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFadl/PIJ_SEFadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "SEFadl/LIJT_SEFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFadl/PIJ_SEFadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "SEFadl/LIJT_SEFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFadl/PIJ_SEFadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "SEFadl/P_SEFadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFadl/PIJ_SEFadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "SEFadl/P_SEFadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFadl/PIJ_SEFadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-10.703980; p2=0.091150; 
#   current state 3
p3=-9.722208; p4=0.062399; 
# initial state 2
#   current state 1
p5=-1.871670; p6=0.001194; 
#   current state 3
p7=-19.356177; p8=0.206740; 
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

set out "SEFadl/PE_SEFadl_1-1-1.svg" 
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

set out "SEFadl/PE_SEFadl_1-2-1.svg" 
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

set out "SEFadl/PE_SEFadl_1-3-1.svg" 
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
set out "SEFadl/VARPIJGR_SEFadl_113-12.svg"
set label "50" at  2.705e-003, 4.267e-003 center
# Age 50, p13 - p12
plot [-pi:pi]  2.705e-003+ 2.000*( 4.978e-001* 1.540e-003*cos(t)+ 8.673e-001* 1.393e-003*sin(t)),  4.267e-003 +2.000*(-8.673e-001* 1.540e-003*cos(t)+ 4.978e-001* 1.393e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  3.689e-003, 6.719e-003 center
replot  3.689e-003+ 2.000*( 1.371e-001* 1.977e-003*cos(t)+ 9.906e-001* 1.557e-003*sin(t)),  6.719e-003 +2.000*(-9.906e-001* 1.977e-003*cos(t)+ 1.371e-001* 1.557e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  5.027e-003, 1.057e-002 center
replot  5.027e-003+ 2.000*( 4.656e-002* 2.502e-003*cos(t)+ 9.989e-001* 1.652e-003*sin(t)),  1.057e-002 +2.000*(-9.989e-001* 2.502e-003*cos(t)+ 4.656e-002* 1.652e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  6.840e-003, 1.661e-002 center
replot  6.840e-003+ 2.000*( 1.934e-002* 3.078e-003*cos(t)+ 9.998e-001* 1.729e-003*sin(t)),  1.661e-002 +2.000*(-9.998e-001* 3.078e-003*cos(t)+ 1.934e-002* 1.729e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  9.289e-003, 2.604e-002 center
replot  9.289e-003+ 2.000*( 5.182e-002* 3.789e-003*cos(t)+ 9.987e-001* 2.008e-003*sin(t)),  2.604e-002 +2.000*(-9.987e-001* 3.789e-003*cos(t)+ 5.182e-002* 2.008e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.257e-002, 4.070e-002 center
replot  1.257e-002+ 2.000*( 1.781e-001* 5.240e-003*cos(t)+ 9.840e-001* 2.915e-003*sin(t)),  4.070e-002 +2.000*(-9.840e-001* 5.240e-003*cos(t)+ 1.781e-001* 2.915e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  1.694e-002, 6.331e-002 center
replot  1.694e-002+ 2.000*( 2.695e-001* 9.031e-003*cos(t)+ 9.630e-001* 4.808e-003*sin(t)),  6.331e-002 +2.000*(-9.630e-001* 9.031e-003*cos(t)+ 2.695e-001* 4.808e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  2.266e-002, 9.777e-002 center
replot  2.266e-002+ 2.000*( 2.529e-001* 1.728e-002*cos(t)+ 9.675e-001* 8.222e-003*sin(t)),  9.777e-002 +2.000*(-9.675e-001* 1.728e-002*cos(t)+ 2.529e-001* 8.222e-003*sin(t)) not
# Age 90, p13 - p12
set label "90" at  2.998e-002, 1.494e-001 center
replot  2.998e-002+ 2.000*( 2.144e-001* 3.268e-002*cos(t)+ 9.767e-001* 1.367e-002*sin(t)),  1.494e-001 +2.000*(-9.767e-001* 3.268e-002*cos(t)+ 2.144e-001* 1.367e-002*sin(t)) not
set out;
set out "SEFadl/VARPIJGR_SEFadl_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "SEFadl/VARPIJGR_SEFadl_121-12.svg"
set label "50" at  2.808e-001, 4.267e-003 center
# Age 50, p21 - p12
plot [-pi:pi]  2.808e-001+ 2.000*( 1.000e+000* 7.980e-002*cos(t)+-3.859e-003* 1.473e-003*sin(t)),  4.267e-003 +2.000*( 3.859e-003* 7.980e-002*cos(t)+ 1.000e+000* 1.473e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  2.822e-001, 6.719e-003 center
replot  2.822e-001+ 2.000*( 1.000e+000* 6.521e-002*cos(t)+-5.987e-003* 1.931e-003*sin(t)),  6.719e-003 +2.000*( 5.987e-003* 6.521e-002*cos(t)+ 1.000e+000* 1.931e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.835e-001, 1.057e-002 center
replot  2.835e-001+ 2.000*( 1.000e+000* 5.191e-002*cos(t)+-9.253e-003* 2.454e-003*sin(t)),  1.057e-002 +2.000*( 9.253e-003* 5.191e-002*cos(t)+ 1.000e+000* 2.454e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.845e-001, 1.661e-002 center
replot  2.845e-001+ 2.000*( 9.999e-001* 4.137e-002*cos(t)+-1.432e-002* 3.021e-003*sin(t)),  1.661e-002 +2.000*( 1.432e-002* 4.137e-002*cos(t)+ 9.999e-001* 3.021e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.848e-001, 2.604e-002 center
replot  2.848e-001+ 2.000*( 9.997e-001* 3.625e-002*cos(t)+-2.250e-002* 3.697e-003*sin(t)),  2.604e-002 +2.000*( 2.250e-002* 3.625e-002*cos(t)+ 9.997e-001* 3.697e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.829e-001, 4.070e-002 center
replot  2.829e-001+ 2.000*( 9.994e-001* 3.872e-002*cos(t)+-3.587e-002* 4.996e-003*sin(t)),  4.070e-002 +2.000*( 3.587e-002* 3.872e-002*cos(t)+ 9.994e-001* 4.996e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.755e-001, 6.331e-002 center
replot  2.755e-001+ 2.000*( 9.984e-001* 4.670e-002*cos(t)+-5.737e-002* 8.388e-003*sin(t)),  6.331e-002 +2.000*( 5.737e-002* 4.670e-002*cos(t)+ 9.984e-001* 8.388e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  2.545e-001, 9.777e-002 center
replot  2.545e-001+ 2.000*( 9.952e-001* 5.469e-002*cos(t)+-9.775e-002* 1.605e-002*sin(t)),  9.777e-002 +2.000*( 9.775e-002* 5.469e-002*cos(t)+ 9.952e-001* 1.605e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  2.084e-001, 1.494e-001 center
replot  2.084e-001+ 2.000*( 9.780e-001* 5.752e-002*cos(t)+-2.088e-001* 3.038e-002*sin(t)),  1.494e-001 +2.000*( 2.088e-001* 5.752e-002*cos(t)+ 9.780e-001* 3.038e-002*sin(t)) not
set out;
set out "SEFadl/VARPIJGR_SEFadl_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "SEFadl/VARPIJGR_SEFadl_123-12.svg"
set label "50" at  2.081e-004, 4.267e-003 center
# Age 50, p23 - p12
plot [-pi:pi]  2.081e-004+ 2.000*( 1.123e-003* 1.505e-003*cos(t)+ 1.000e+000* 3.615e-004*sin(t)),  4.267e-003 +2.000*(-1.000e+000* 1.505e-003*cos(t)+ 1.123e-003* 3.615e-004*sin(t)) not
# Age 55, p23 - p12
set label "55" at  5.845e-004, 6.719e-003 center
replot  5.845e-004+ 2.000*( 1.304e-003* 1.970e-003*cos(t)+-1.000e+000* 8.787e-004*sin(t)),  6.719e-003 +2.000*( 1.000e+000* 1.970e-003*cos(t)+ 1.304e-003* 8.787e-004*sin(t)) not
# Age 60, p23 - p12
set label "60" at  1.641e-003, 1.057e-002 center
replot  1.641e-003+ 2.000*( 3.665e-002* 2.501e-003*cos(t)+-9.993e-001* 2.084e-003*sin(t)),  1.057e-002 +2.000*( 9.993e-001* 2.501e-003*cos(t)+ 3.665e-002* 2.084e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  4.603e-003, 1.661e-002 center
replot  4.603e-003+ 2.000*( 9.993e-001* 4.777e-003*cos(t)+-3.610e-002* 3.075e-003*sin(t)),  1.661e-002 +2.000*( 3.610e-002* 4.777e-003*cos(t)+ 9.993e-001* 3.075e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  1.288e-002, 2.604e-002 center
replot  1.288e-002+ 2.000*( 9.996e-001* 1.038e-002*cos(t)+-2.805e-002* 3.776e-003*sin(t)),  2.604e-002 +2.000*( 2.805e-002* 1.038e-002*cos(t)+ 9.996e-001* 3.776e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  3.575e-002, 4.070e-002 center
replot  3.575e-002+ 2.000*( 9.995e-001* 2.062e-002*cos(t)+-3.103e-002* 5.145e-003*sin(t)),  4.070e-002 +2.000*( 3.103e-002* 2.062e-002*cos(t)+ 9.995e-001* 5.145e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  9.729e-002, 6.331e-002 center
replot  9.729e-002+ 2.000*( 9.990e-001* 3.495e-002*cos(t)+-4.440e-002* 8.663e-003*sin(t)),  6.331e-002 +2.000*( 4.440e-002* 3.495e-002*cos(t)+ 9.990e-001* 8.663e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  2.512e-001, 9.777e-002 center
replot  2.512e-001+ 2.000*( 9.970e-001* 4.982e-002*cos(t)+-7.741e-002* 1.645e-002*sin(t)),  9.777e-002 +2.000*( 7.741e-002* 4.982e-002*cos(t)+ 9.970e-001* 1.645e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  5.749e-001, 1.494e-001 center
replot  5.749e-001+ 2.000*( 9.993e-001* 1.092e-001*cos(t)+-3.637e-002* 3.182e-002*sin(t)),  1.494e-001 +2.000*( 3.637e-002* 1.092e-001*cos(t)+ 9.993e-001* 3.182e-002*sin(t)) not
set out;
set out "SEFadl/VARPIJGR_SEFadl_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "SEFadl/VARPIJGR_SEFadl_121-13.svg"
set label "50" at  2.808e-001, 2.705e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  2.808e-001+ 2.000*( 1.000e+000* 7.979e-002*cos(t)+-3.280e-004* 1.430e-003*sin(t)),  2.705e-003 +2.000*( 3.280e-004* 7.979e-002*cos(t)+ 1.000e+000* 1.430e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  2.822e-001, 3.689e-003 center
replot  2.822e-001+ 2.000*( 1.000e+000* 6.521e-002*cos(t)+-4.731e-004* 1.566e-003*sin(t)),  3.689e-003 +2.000*( 4.731e-004* 6.521e-002*cos(t)+ 1.000e+000* 1.566e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.835e-001, 5.027e-003 center
replot  2.835e-001+ 2.000*( 1.000e+000* 5.191e-002*cos(t)+-7.351e-004* 1.654e-003*sin(t)),  5.027e-003 +2.000*( 7.351e-004* 5.191e-002*cos(t)+ 1.000e+000* 1.654e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.845e-001, 6.840e-003 center
replot  2.845e-001+ 2.000*( 1.000e+000* 4.137e-002*cos(t)+-1.304e-003* 1.729e-003*sin(t)),  6.840e-003 +2.000*( 1.304e-003* 4.137e-002*cos(t)+ 1.000e+000* 1.729e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.848e-001, 9.289e-003 center
replot  2.848e-001+ 2.000*( 1.000e+000* 3.624e-002*cos(t)+-2.539e-003* 2.013e-003*sin(t)),  9.289e-003 +2.000*( 2.539e-003* 3.624e-002*cos(t)+ 1.000e+000* 2.013e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.829e-001, 1.257e-002 center
replot  2.829e-001+ 2.000*( 1.000e+000* 3.870e-002*cos(t)+-4.462e-003* 3.011e-003*sin(t)),  1.257e-002 +2.000*( 4.462e-003* 3.870e-002*cos(t)+ 1.000e+000* 3.011e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.755e-001, 1.694e-002 center
replot  2.755e-001+ 2.000*( 1.000e+000* 4.662e-002*cos(t)+-7.164e-003* 5.220e-003*sin(t)),  1.694e-002 +2.000*( 7.164e-003* 4.662e-002*cos(t)+ 1.000e+000* 5.220e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  2.545e-001, 2.266e-002 center
replot  2.545e-001+ 2.000*( 9.999e-001* 5.446e-002*cos(t)+-1.218e-002* 9.052e-003*sin(t)),  2.266e-002 +2.000*( 1.218e-002* 5.446e-002*cos(t)+ 9.999e-001* 9.052e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  2.084e-001, 2.998e-002 center
replot  2.084e-001+ 2.000*( 9.998e-001* 5.662e-002*cos(t)+-2.197e-002* 1.503e-002*sin(t)),  2.998e-002 +2.000*( 2.197e-002* 5.662e-002*cos(t)+ 9.998e-001* 1.503e-002*sin(t)) not
set out;
set out "SEFadl/VARPIJGR_SEFadl_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "SEFadl/VARPIJGR_SEFadl_123-13.svg"
set label "50" at  2.081e-004, 2.705e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  2.081e-004+ 2.000*( 1.436e-002* 1.431e-003*cos(t)+ 9.999e-001* 3.610e-004*sin(t)),  2.705e-003 +2.000*(-9.999e-001* 1.431e-003*cos(t)+ 1.436e-002* 3.610e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  5.845e-004, 3.689e-003 center
replot  5.845e-004+ 2.000*( 6.216e-002* 1.568e-003*cos(t)+ 9.981e-001* 8.750e-004*sin(t)),  3.689e-003 +2.000*(-9.981e-001* 1.568e-003*cos(t)+ 6.216e-002* 8.750e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  1.641e-003, 5.027e-003 center
replot  1.641e-003+ 2.000*( 9.740e-001* 2.106e-003*cos(t)+ 2.267e-001* 1.627e-003*sin(t)),  5.027e-003 +2.000*(-2.267e-001* 2.106e-003*cos(t)+ 9.740e-001* 1.627e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  4.603e-003, 6.840e-003 center
replot  4.603e-003+ 2.000*( 9.973e-001* 4.786e-003*cos(t)+ 7.322e-002* 1.699e-003*sin(t)),  6.840e-003 +2.000*(-7.322e-002* 4.786e-003*cos(t)+ 9.973e-001* 1.699e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  1.288e-002, 9.289e-003 center
replot  1.288e-002+ 2.000*( 9.987e-001* 1.039e-002*cos(t)+ 5.086e-002* 1.947e-003*sin(t)),  9.289e-003 +2.000*(-5.086e-002* 1.039e-002*cos(t)+ 9.987e-001* 1.947e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  3.575e-002, 1.257e-002 center
replot  3.575e-002+ 2.000*( 9.990e-001* 2.063e-002*cos(t)+ 4.427e-002* 2.878e-003*sin(t)),  1.257e-002 +2.000*(-4.427e-002* 2.063e-002*cos(t)+ 9.990e-001* 2.878e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  9.729e-002, 1.694e-002 center
replot  9.729e-002+ 2.000*( 9.987e-001* 3.496e-002*cos(t)+ 5.041e-002* 4.931e-003*sin(t)),  1.694e-002 +2.000*(-5.041e-002* 3.496e-002*cos(t)+ 9.987e-001* 4.931e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  2.512e-001, 2.266e-002 center
replot  2.512e-001+ 2.000*( 9.974e-001* 4.981e-002*cos(t)+ 7.144e-002* 8.371e-003*sin(t)),  2.266e-002 +2.000*(-7.144e-002* 4.981e-002*cos(t)+ 9.974e-001* 8.371e-003*sin(t)) not
# Age 90, p23 - p13
set label "90" at  5.749e-001, 2.998e-002 center
replot  5.749e-001+ 2.000*( 9.995e-001* 1.091e-001*cos(t)+ 3.143e-002* 1.469e-002*sin(t)),  2.998e-002 +2.000*(-3.143e-002* 1.091e-001*cos(t)+ 9.995e-001* 1.469e-002*sin(t)) not
set out;
set out "SEFadl/VARPIJGR_SEFadl_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "SEFadl/VARPIJGR_SEFadl_123-21.svg"
set label "50" at  2.081e-004, 2.808e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  2.081e-004+ 2.000*( 2.043e-004* 7.979e-002*cos(t)+ 1.000e+000* 3.611e-004*sin(t)),  2.808e-001 +2.000*(-1.000e+000* 7.979e-002*cos(t)+ 2.043e-004* 3.611e-004*sin(t)) not
# Age 55, p23 - p21
set label "55" at  5.845e-004, 2.822e-001 center
replot  5.845e-004+ 2.000*( 7.193e-004* 6.521e-002*cos(t)+ 1.000e+000* 8.775e-004*sin(t)),  2.822e-001 +2.000*(-1.000e+000* 6.521e-002*cos(t)+ 7.193e-004* 8.775e-004*sin(t)) not
# Age 60, p23 - p21
set label "60" at  1.641e-003, 2.835e-001 center
replot  1.641e-003+ 2.000*( 2.659e-003* 5.191e-002*cos(t)+ 1.000e+000* 2.080e-003*sin(t)),  2.835e-001 +2.000*(-1.000e+000* 5.191e-002*cos(t)+ 2.659e-003* 2.080e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  4.603e-003, 2.845e-001 center
replot  4.603e-003+ 2.000*( 1.006e-002* 4.137e-002*cos(t)+ 9.999e-001* 4.757e-003*sin(t)),  2.845e-001 +2.000*(-9.999e-001* 4.137e-002*cos(t)+ 1.006e-002* 4.757e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  1.288e-002, 2.848e-001 center
replot  1.288e-002+ 2.000*( 3.459e-002* 3.626e-002*cos(t)+ 9.994e-001* 1.030e-002*sin(t)),  2.848e-001 +2.000*(-9.994e-001* 3.626e-002*cos(t)+ 3.459e-002* 1.030e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  3.575e-002, 2.829e-001 center
replot  3.575e-002+ 2.000*( 9.521e-002* 3.882e-002*cos(t)+ 9.955e-001* 2.036e-002*sin(t)),  2.829e-001 +2.000*(-9.955e-001* 3.882e-002*cos(t)+ 9.521e-002* 2.036e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  9.729e-002, 2.755e-001 center
replot  9.729e-002+ 2.000*( 2.124e-001* 4.713e-002*cos(t)+ 9.772e-001* 3.423e-002*sin(t)),  2.755e-001 +2.000*(-9.772e-001* 4.713e-002*cos(t)+ 2.124e-001* 3.423e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  2.512e-001, 2.545e-001 center
replot  2.512e-001+ 2.000*( 4.397e-001* 5.588e-002*cos(t)+ 8.981e-001* 4.808e-002*sin(t)),  2.545e-001 +2.000*(-8.981e-001* 5.588e-002*cos(t)+ 4.397e-001* 4.808e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  5.749e-001, 2.084e-001 center
replot  5.749e-001+ 2.000*( 9.860e-001* 1.103e-001*cos(t)+ 1.667e-001* 5.430e-002*sin(t)),  2.084e-001 +2.000*(-1.667e-001* 1.103e-001*cos(t)+ 9.860e-001* 5.430e-002*sin(t)) not
set out;
set out "SEFadl/VARPIJGR_SEFadl_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "SEFadl/VARMUPTJGR--STABLBASED_SEFadl1.svg";
 plot "SEFadl/PRMORPREV-1-STABLBASED_SEFadl.txt"  u 1:($3) not w l lt 1 
 replot "SEFadl/PRMORPREV-1-STABLBASED_SEFadl.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "SEFadl/PRMORPREV-1-STABLBASED_SEFadl.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "SEFadl/VARMUPTJGR--STABLBASED_SEFadl1.svg";replot;set out;
