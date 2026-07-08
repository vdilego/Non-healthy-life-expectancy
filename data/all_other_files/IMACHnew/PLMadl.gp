
# IMaCh-0.99r45
# PLMadl.gp
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


set ter svg size 640, 480;set out "PLMadl/D_PLMadl_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "PLMadl/ILK_PLMadl-dest.png";
set log y;plot  "PLMadl/ILK_PLMadl.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "PLMadl/ILK_PLMadl-ori.png";
set log y;plot  "PLMadl/ILK_PLMadl.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "PLMadl/ILK_PLMadl-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "PLMadl/ILK_PLMadl.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "PLMadl/ILK_PLMadl-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "PLMadl/ILK_PLMadl.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "PLMadl/V_PLMadl_1-1-1.svg" 

#set out "V_PLMadl_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "PLMadl/VPL_PLMadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"PLMadl/VPL_PLMadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"PLMadl/VPL_PLMadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"PLMadl/P_PLMadl.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "PLMadl/V_PLMadl_2-1-1.svg" 

#set out "V_PLMadl_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "PLMadl/VPL_PLMadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"PLMadl/VPL_PLMadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"PLMadl/VPL_PLMadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"PLMadl/P_PLMadl.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "PLMadl/E_PLMadl_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "PLMadl/T_PLMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"PLMadl/T_PLMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"PLMadl/T_PLMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"PLMadl/T_PLMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"PLMadl/T_PLMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"PLMadl/T_PLMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"PLMadl/T_PLMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"PLMadl/T_PLMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"PLMadl/T_PLMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "PLMadl/E_PLMadl_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "PLMadl/EXP_PLMadl_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "PLMadl/E_PLMadl.txt" every :::0::0 u 1:2 t "e11" w l ,"PLMadl/E_PLMadl.txt" every :::0::0 u 1:3 t "e12" w l ,"PLMadl/E_PLMadl.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "PLMadl/EXP_PLMadl_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "PLMadl/E_PLMadl.txt" every :::0::0 u 1:5 t "e21" w l ,"PLMadl/E_PLMadl.txt" every :::0::0 u 1:6 t "e22" w l ,"PLMadl/E_PLMadl.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "PLMadl/LIJ_PLMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMadl/PIJ_PLMadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "PLMadl/LIJ_PLMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMadl/PIJ_PLMadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "PLMadl/LIJT_PLMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMadl/PIJ_PLMadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "PLMadl/LIJT_PLMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMadl/PIJ_PLMadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "PLMadl/P_PLMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMadl/PIJ_PLMadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "PLMadl/P_PLMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMadl/PIJ_PLMadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-5.712644; p2=0.033268; 
#   current state 3
p3=-8.191470; p4=0.059781; 
# initial state 2
#   current state 1
p5=2.857186; p6=-0.068769; 
#   current state 3
p7=-7.159388; p8=0.061153; 
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

set out "PLMadl/PE_PLMadl_1-1-1.svg" 
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

set out "PLMadl/PE_PLMadl_1-2-1.svg" 
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

set out "PLMadl/PE_PLMadl_1-3-1.svg" 
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
set out "PLMadl/VARPIJGR_PLMadl_113-12.svg"
set label "50" at  1.076e-002, 3.409e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  1.076e-002+ 2.000*( 4.618e-002* 1.209e-002*cos(t)+ 9.989e-001* 4.431e-003*sin(t)),  3.409e-002 +2.000*(-9.989e-001* 1.209e-002*cos(t)+ 4.618e-002* 4.431e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.444e-002, 4.006e-002 center
replot  1.444e-002+ 2.000*( 5.156e-002* 1.122e-002*cos(t)+ 9.987e-001* 4.763e-003*sin(t)),  4.006e-002 +2.000*(-9.987e-001* 1.122e-002*cos(t)+ 5.156e-002* 4.763e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.935e-002, 4.702e-002 center
replot  1.935e-002+ 2.000*( 6.070e-002* 1.012e-002*cos(t)+ 9.982e-001* 4.990e-003*sin(t)),  4.702e-002 +2.000*(-9.982e-001* 1.012e-002*cos(t)+ 6.070e-002* 4.990e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  2.589e-002, 5.511e-002 center
replot  2.589e-002+ 2.000*( 9.421e-002* 9.419e-003*cos(t)+ 9.956e-001* 5.328e-003*sin(t)),  5.511e-002 +2.000*(-9.956e-001* 9.419e-003*cos(t)+ 9.421e-002* 5.328e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  3.458e-002, 6.447e-002 center
replot  3.458e-002+ 2.000*( 1.873e-001* 1.064e-002*cos(t)+ 9.823e-001* 6.515e-003*sin(t)),  6.447e-002 +2.000*(-9.823e-001* 1.064e-002*cos(t)+ 1.873e-001* 6.515e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  4.608e-002, 7.525e-002 center
replot  4.608e-002+ 2.000*( 2.966e-001* 1.520e-002*cos(t)+ 9.550e-001* 9.724e-003*sin(t)),  7.525e-002 +2.000*(-9.550e-001* 1.520e-002*cos(t)+ 2.966e-001* 9.724e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  6.123e-002, 8.757e-002 center
replot  6.123e-002+ 2.000*( 4.086e-001* 2.335e-002*cos(t)+ 9.127e-001* 1.587e-002*sin(t)),  8.757e-002 +2.000*(-9.127e-001* 2.335e-002*cos(t)+ 4.086e-001* 1.587e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  8.106e-002, 1.015e-001 center
replot  8.106e-002+ 2.000*( 5.499e-001* 3.553e-002*cos(t)+ 8.353e-001* 2.542e-002*sin(t)),  1.015e-001 +2.000*(-8.353e-001* 3.553e-002*cos(t)+ 5.499e-001* 2.542e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.068e-001, 1.172e-001 center
replot  1.068e-001+ 2.000*( 7.024e-001* 5.318e-002*cos(t)+ 7.118e-001* 3.837e-002*sin(t)),  1.172e-001 +2.000*(-7.118e-001* 5.318e-002*cos(t)+ 7.024e-001* 3.837e-002*sin(t)) not
set out;
set out "PLMadl/VARPIJGR_PLMadl_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "PLMadl/VARPIJGR_PLMadl_121-12.svg"
set label "50" at  7.098e-001, 3.409e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  7.098e-001+ 2.000*( 9.998e-001* 2.009e-001*cos(t)+-2.142e-002* 1.129e-002*sin(t)),  3.409e-002 +2.000*( 2.142e-002* 2.009e-001*cos(t)+ 9.998e-001* 1.129e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  5.588e-001, 4.006e-002 center
replot  5.588e-001+ 2.000*( 9.995e-001* 1.361e-001*cos(t)+-3.055e-002* 1.041e-002*sin(t)),  4.006e-002 +2.000*( 3.055e-002* 1.361e-001*cos(t)+ 9.995e-001* 1.041e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  4.287e-001, 4.702e-002 center
replot  4.287e-001+ 2.000*( 9.990e-001* 8.605e-002*cos(t)+-4.451e-002* 9.356e-003*sin(t)),  4.702e-002 +2.000*( 4.451e-002* 8.605e-002*cos(t)+ 9.990e-001* 9.356e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.213e-001, 5.511e-002 center
replot  3.213e-001+ 2.000*( 9.984e-001* 5.749e-002*cos(t)+-5.588e-002* 8.838e-003*sin(t)),  5.511e-002 +2.000*( 5.588e-002* 5.749e-002*cos(t)+ 9.984e-001* 8.838e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.360e-001, 6.447e-002 center
replot  2.360e-001+ 2.000*( 9.984e-001* 4.868e-002*cos(t)+-5.584e-002* 1.018e-002*sin(t)),  6.447e-002 +2.000*( 5.584e-002* 4.868e-002*cos(t)+ 9.984e-001* 1.018e-002*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.704e-001, 7.525e-002 center
replot  1.704e-001+ 2.000*( 9.976e-001* 4.754e-002*cos(t)+-6.975e-002* 1.446e-002*sin(t)),  7.525e-002 +2.000*( 6.975e-002* 4.754e-002*cos(t)+ 9.976e-001* 1.446e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.210e-001, 8.757e-002 center
replot  1.210e-001+ 2.000*( 9.923e-001* 4.569e-002*cos(t)+-1.239e-001* 2.171e-002*sin(t)),  8.757e-002 +2.000*( 1.239e-001* 4.569e-002*cos(t)+ 9.923e-001* 2.171e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  8.460e-002, 1.015e-001 center
replot  8.460e-002+ 2.000*( 9.358e-001* 4.216e-002*cos(t)+-3.525e-001* 3.125e-002*sin(t)),  1.015e-001 +2.000*( 3.525e-001* 4.216e-002*cos(t)+ 9.358e-001* 3.125e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  5.824e-002, 1.172e-001 center
replot  5.824e-002+ 2.000*( 2.921e-001* 4.750e-002*cos(t)+-9.564e-001* 3.352e-002*sin(t)),  1.172e-001 +2.000*( 9.564e-001* 4.750e-002*cos(t)+ 2.921e-001* 3.352e-002*sin(t)) not
set out;
set out "PLMadl/VARPIJGR_PLMadl_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "PLMadl/VARPIJGR_PLMadl_123-12.svg"
set label "50" at  2.100e-002, 3.409e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  2.100e-002+ 2.000*( 9.946e-001* 1.784e-002*cos(t)+-1.036e-001* 1.200e-002*sin(t)),  3.409e-002 +2.000*( 1.036e-001* 1.784e-002*cos(t)+ 9.946e-001* 1.200e-002*sin(t)) not
# Age 55, p23 - p12
set label "55" at  3.166e-002, 4.006e-002 center
replot  3.166e-002+ 2.000*( 9.979e-001* 2.218e-002*cos(t)+-6.539e-002* 1.114e-002*sin(t)),  4.006e-002 +2.000*( 6.539e-002* 2.218e-002*cos(t)+ 9.979e-001* 1.114e-002*sin(t)) not
# Age 60, p23 - p12
set label "60" at  4.650e-002, 4.702e-002 center
replot  4.650e-002+ 2.000*( 9.988e-001* 2.607e-002*cos(t)+-4.934e-002* 1.003e-002*sin(t)),  4.702e-002 +2.000*( 4.934e-002* 2.607e-002*cos(t)+ 9.988e-001* 1.003e-002*sin(t)) not
# Age 65, p23 - p12
set label "65" at  6.674e-002, 5.511e-002 center
replot  6.674e-002+ 2.000*( 9.990e-001* 2.891e-002*cos(t)+-4.417e-002* 9.312e-003*sin(t)),  5.511e-002 +2.000*( 4.417e-002* 2.891e-002*cos(t)+ 9.990e-001* 9.312e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  9.388e-002, 6.447e-002 center
replot  9.388e-002+ 2.000*( 9.984e-001* 3.097e-002*cos(t)+-5.637e-002* 1.040e-002*sin(t)),  6.447e-002 +2.000*( 5.637e-002* 3.097e-002*cos(t)+ 9.984e-001* 1.040e-002*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.297e-001, 7.525e-002 center
replot  1.297e-001+ 2.000*( 9.953e-001* 3.562e-002*cos(t)+-9.715e-002* 1.446e-002*sin(t)),  7.525e-002 +2.000*( 9.715e-002* 3.562e-002*cos(t)+ 9.953e-001* 1.446e-002*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.764e-001, 8.757e-002 center
replot  1.764e-001+ 2.000*( 9.923e-001* 5.096e-002*cos(t)+-1.239e-001* 2.153e-002*sin(t)),  8.757e-002 +2.000*( 1.239e-001* 5.096e-002*cos(t)+ 9.923e-001* 2.153e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  2.362e-001, 1.015e-001 center
replot  2.362e-001+ 2.000*( 9.941e-001* 8.393e-002*cos(t)+-1.088e-001* 3.169e-002*sin(t)),  1.015e-001 +2.000*( 1.088e-001* 8.393e-002*cos(t)+ 9.941e-001* 3.169e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  3.114e-001, 1.172e-001 center
replot  3.114e-001+ 2.000*( 9.960e-001* 1.372e-001*cos(t)+-8.902e-002* 4.502e-002*sin(t)),  1.172e-001 +2.000*( 8.902e-002* 1.372e-001*cos(t)+ 9.960e-001* 4.502e-002*sin(t)) not
set out;
set out "PLMadl/VARPIJGR_PLMadl_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "PLMadl/VARPIJGR_PLMadl_121-13.svg"
set label "50" at  7.098e-001, 1.076e-002 center
# Age 50, p21 - p13
plot [-pi:pi]  7.098e-001+ 2.000*( 1.000e+000* 2.008e-001*cos(t)+ 2.155e-004* 4.461e-003*sin(t)),  1.076e-002 +2.000*(-2.155e-004* 2.008e-001*cos(t)+ 1.000e+000* 4.461e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  5.588e-001, 1.444e-002 center
replot  5.588e-001+ 2.000*( 1.000e+000* 1.361e-001*cos(t)+ 2.720e-004* 4.792e-003*sin(t)),  1.444e-002 +2.000*(-2.720e-004* 1.361e-001*cos(t)+ 1.000e+000* 4.792e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  4.287e-001, 1.935e-002 center
replot  4.287e-001+ 2.000*( 1.000e+000* 8.597e-002*cos(t)+-7.754e-005* 5.018e-003*sin(t)),  1.935e-002 +2.000*( 7.754e-005* 8.597e-002*cos(t)+ 1.000e+000* 5.018e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.213e-001, 2.589e-002 center
replot  3.213e-001+ 2.000*( 1.000e+000* 5.740e-002*cos(t)+-2.370e-003* 5.376e-003*sin(t)),  2.589e-002 +2.000*( 2.370e-003* 5.740e-002*cos(t)+ 1.000e+000* 5.376e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.360e-001, 3.458e-002 center
replot  2.360e-001+ 2.000*( 1.000e+000* 4.861e-002*cos(t)+-7.016e-003* 6.695e-003*sin(t)),  3.458e-002 +2.000*( 7.016e-003* 4.861e-002*cos(t)+ 1.000e+000* 6.695e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.704e-001, 4.608e-002 center
replot  1.704e-001+ 2.000*( 9.999e-001* 4.744e-002*cos(t)+-1.232e-002* 1.031e-002*sin(t)),  4.608e-002 +2.000*( 1.232e-002* 4.744e-002*cos(t)+ 9.999e-001* 1.031e-002*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.210e-001, 6.123e-002 center
replot  1.210e-001+ 2.000*( 9.998e-001* 4.542e-002*cos(t)+-2.224e-002* 1.732e-002*sin(t)),  6.123e-002 +2.000*( 2.224e-002* 4.542e-002*cos(t)+ 9.998e-001* 1.732e-002*sin(t)) not
# Age 85, p21 - p13
set label "85" at  8.460e-002, 8.106e-002 center
replot  8.460e-002+ 2.000*( 9.978e-001* 4.101e-002*cos(t)+-6.615e-002* 2.879e-002*sin(t)),  8.106e-002 +2.000*( 6.615e-002* 4.101e-002*cos(t)+ 9.978e-001* 2.879e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  5.824e-002, 1.068e-001 center
replot  5.824e-002+ 2.000*( 8.544e-002* 4.635e-002*cos(t)+-9.963e-001* 3.483e-002*sin(t)),  1.068e-001 +2.000*( 9.963e-001* 4.635e-002*cos(t)+ 8.544e-002* 3.483e-002*sin(t)) not
set out;
set out "PLMadl/VARPIJGR_PLMadl_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "PLMadl/VARPIJGR_PLMadl_123-13.svg"
set label "50" at  2.100e-002, 1.076e-002 center
# Age 50, p23 - p13
plot [-pi:pi]  2.100e-002+ 2.000*( 9.986e-001* 1.781e-002*cos(t)+ 5.316e-002* 4.366e-003*sin(t)),  1.076e-002 +2.000*(-5.316e-002* 1.781e-002*cos(t)+ 9.986e-001* 4.366e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  3.166e-002, 1.444e-002 center
replot  3.166e-002+ 2.000*( 9.989e-001* 2.217e-002*cos(t)+ 4.603e-002* 4.687e-003*sin(t)),  1.444e-002 +2.000*(-4.603e-002* 2.217e-002*cos(t)+ 9.989e-001* 4.687e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  4.650e-002, 1.935e-002 center
replot  4.650e-002+ 2.000*( 9.991e-001* 2.606e-002*cos(t)+ 4.202e-002* 4.902e-003*sin(t)),  1.935e-002 +2.000*(-4.202e-002* 2.606e-002*cos(t)+ 9.991e-001* 4.902e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  6.674e-002, 2.589e-002 center
replot  6.674e-002+ 2.000*( 9.991e-001* 2.892e-002*cos(t)+ 4.300e-002* 5.237e-003*sin(t)),  2.589e-002 +2.000*(-4.300e-002* 2.892e-002*cos(t)+ 9.991e-001* 5.237e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  9.388e-002, 3.458e-002 center
replot  9.388e-002+ 2.000*( 9.984e-001* 3.097e-002*cos(t)+ 5.572e-002* 6.487e-003*sin(t)),  3.458e-002 +2.000*(-5.572e-002* 3.097e-002*cos(t)+ 9.984e-001* 6.487e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.297e-001, 4.608e-002 center
replot  1.297e-001+ 2.000*( 9.961e-001* 3.560e-002*cos(t)+ 8.823e-002* 9.871e-003*sin(t)),  4.608e-002 +2.000*(-8.823e-002* 3.560e-002*cos(t)+ 9.961e-001* 9.871e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.764e-001, 6.123e-002 center
replot  1.764e-001+ 2.000*( 9.936e-001* 5.093e-002*cos(t)+ 1.131e-001* 1.647e-002*sin(t)),  6.123e-002 +2.000*(-1.131e-001* 5.093e-002*cos(t)+ 9.936e-001* 1.647e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  2.362e-001, 8.106e-002 center
replot  2.362e-001+ 2.000*( 9.939e-001* 8.395e-002*cos(t)+ 1.100e-001* 2.750e-002*sin(t)),  8.106e-002 +2.000*(-1.100e-001* 8.395e-002*cos(t)+ 9.939e-001* 2.750e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  3.114e-001, 1.068e-001 center
replot  3.114e-001+ 2.000*( 9.948e-001* 1.373e-001*cos(t)+ 1.018e-001* 4.434e-002*sin(t)),  1.068e-001 +2.000*(-1.018e-001* 1.373e-001*cos(t)+ 9.948e-001* 4.434e-002*sin(t)) not
set out;
set out "PLMadl/VARPIJGR_PLMadl_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "PLMadl/VARPIJGR_PLMadl_123-21.svg"
set label "50" at  2.100e-002, 7.098e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  2.100e-002+ 2.000*( 9.504e-003* 2.008e-001*cos(t)+ 1.000e+000* 1.769e-002*sin(t)),  7.098e-001 +2.000*(-1.000e+000* 2.008e-001*cos(t)+ 9.504e-003* 1.769e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  3.166e-002, 5.588e-001 center
replot  3.166e-002+ 2.000*( 1.194e-002* 1.361e-001*cos(t)+ 9.999e-001* 2.209e-002*sin(t)),  5.588e-001 +2.000*(-9.999e-001* 1.361e-001*cos(t)+ 1.194e-002* 2.209e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  4.650e-002, 4.287e-001 center
replot  4.650e-002+ 2.000*( 1.982e-002* 8.598e-002*cos(t)+ 9.998e-001* 2.599e-002*sin(t)),  4.287e-001 +2.000*(-9.998e-001* 8.598e-002*cos(t)+ 1.982e-002* 2.599e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  6.674e-002, 3.213e-001 center
replot  6.674e-002+ 2.000*( 5.421e-002* 5.747e-002*cos(t)+ 9.985e-001* 2.876e-002*sin(t)),  3.213e-001 +2.000*(-9.985e-001* 5.747e-002*cos(t)+ 5.421e-002* 2.876e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  9.388e-002, 2.360e-001 center
replot  9.388e-002+ 2.000*( 1.211e-001* 4.882e-002*cos(t)+ 9.926e-001* 3.058e-002*sin(t)),  2.360e-001 +2.000*(-9.926e-001* 4.882e-002*cos(t)+ 1.211e-001* 3.058e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.297e-001, 1.704e-001 center
replot  1.297e-001+ 2.000*( 2.026e-001* 4.790e-002*cos(t)+ 9.793e-001* 3.484e-002*sin(t)),  1.704e-001 +2.000*(-9.793e-001* 4.790e-002*cos(t)+ 2.026e-001* 3.484e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.764e-001, 1.210e-001 center
replot  1.764e-001+ 2.000*( 9.230e-001* 5.168e-002*cos(t)+ 3.849e-001* 4.423e-002*sin(t)),  1.210e-001 +2.000*(-3.849e-001* 5.168e-002*cos(t)+ 9.230e-001* 4.423e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  2.362e-001, 8.460e-002 center
replot  2.362e-001+ 2.000*( 9.980e-001* 8.362e-002*cos(t)+ 6.242e-002* 4.071e-002*sin(t)),  8.460e-002 +2.000*(-6.242e-002* 8.362e-002*cos(t)+ 9.980e-001* 4.071e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  3.114e-001, 5.824e-002 center
replot  3.114e-001+ 2.000*( 9.996e-001* 1.368e-001*cos(t)+ 2.913e-002* 3.472e-002*sin(t)),  5.824e-002 +2.000*(-2.913e-002* 1.368e-001*cos(t)+ 9.996e-001* 3.472e-002*sin(t)) not
set out;
set out "PLMadl/VARPIJGR_PLMadl_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "PLMadl/VARMUPTJGR--STABLBASED_PLMadl1.svg";
 plot "PLMadl/PRMORPREV-1-STABLBASED_PLMadl.txt"  u 1:($3) not w l lt 1 
 replot "PLMadl/PRMORPREV-1-STABLBASED_PLMadl.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "PLMadl/PRMORPREV-1-STABLBASED_PLMadl.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "PLMadl/VARMUPTJGR--STABLBASED_PLMadl1.svg";replot;set out;
