
# IMaCh-0.99r45
# ATMadl.gp
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


set ter svg size 640, 480;set out "ATMadl/D_ATMadl_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "ATMadl/ILK_ATMadl-dest.png";
set log y;plot  "ATMadl/ILK_ATMadl.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "ATMadl/ILK_ATMadl-ori.png";
set log y;plot  "ATMadl/ILK_ATMadl.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "ATMadl/ILK_ATMadl-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ATMadl/ILK_ATMadl.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "ATMadl/ILK_ATMadl-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ATMadl/ILK_ATMadl.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "ATMadl/V_ATMadl_1-1-1.svg" 

#set out "V_ATMadl_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ATMadl/VPL_ATMadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"ATMadl/VPL_ATMadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"ATMadl/VPL_ATMadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"ATMadl/P_ATMadl.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "ATMadl/V_ATMadl_2-1-1.svg" 

#set out "V_ATMadl_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ATMadl/VPL_ATMadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"ATMadl/VPL_ATMadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"ATMadl/VPL_ATMadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"ATMadl/P_ATMadl.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "ATMadl/E_ATMadl_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "ATMadl/T_ATMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"ATMadl/T_ATMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"ATMadl/T_ATMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"ATMadl/T_ATMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"ATMadl/T_ATMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"ATMadl/T_ATMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"ATMadl/T_ATMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"ATMadl/T_ATMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"ATMadl/T_ATMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "ATMadl/E_ATMadl_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "ATMadl/EXP_ATMadl_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ATMadl/E_ATMadl.txt" every :::0::0 u 1:2 t "e11" w l ,"ATMadl/E_ATMadl.txt" every :::0::0 u 1:3 t "e12" w l ,"ATMadl/E_ATMadl.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "ATMadl/EXP_ATMadl_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ATMadl/E_ATMadl.txt" every :::0::0 u 1:5 t "e21" w l ,"ATMadl/E_ATMadl.txt" every :::0::0 u 1:6 t "e22" w l ,"ATMadl/E_ATMadl.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "ATMadl/LIJ_ATMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATMadl/PIJ_ATMadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "ATMadl/LIJ_ATMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATMadl/PIJ_ATMadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "ATMadl/LIJT_ATMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATMadl/PIJ_ATMadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "ATMadl/LIJT_ATMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATMadl/PIJ_ATMadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "ATMadl/P_ATMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATMadl/PIJ_ATMadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "ATMadl/P_ATMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATMadl/PIJ_ATMadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-9.248376; p2=0.075789; 
#   current state 3
p3=-11.440856; p4=0.091882; 
# initial state 2
#   current state 1
p5=1.724563; p6=-0.051257; 
#   current state 3
p7=-7.995686; p8=0.074819; 
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

set out "ATMadl/PE_ATMadl_1-1-1.svg" 
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

set out "ATMadl/PE_ATMadl_1-2-1.svg" 
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

set out "ATMadl/PE_ATMadl_1-3-1.svg" 
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
set out "ATMadl/VARPIJGR_ATMadl_113-12.svg"
set label "50" at  2.115e-003, 8.471e-003 center
# Age 50, p13 - p12
plot [-pi:pi]  2.115e-003+ 2.000*( 6.367e-002* 3.294e-003*cos(t)+ 9.980e-001* 1.267e-003*sin(t)),  8.471e-003 +2.000*(-9.980e-001* 3.294e-003*cos(t)+ 6.367e-002* 1.267e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  3.339e-003, 1.234e-002 center
replot  3.339e-003+ 2.000*( 7.441e-002* 3.914e-003*cos(t)+ 9.972e-001* 1.643e-003*sin(t)),  1.234e-002 +2.000*(-9.972e-001* 3.914e-003*cos(t)+ 7.441e-002* 1.643e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  5.266e-003, 1.796e-002 center
replot  5.266e-003+ 2.000*( 9.198e-002* 4.500e-003*cos(t)+ 9.958e-001* 2.066e-003*sin(t)),  1.796e-002 +2.000*(-9.958e-001* 4.500e-003*cos(t)+ 9.198e-002* 2.066e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  8.290e-003, 2.609e-002 center
replot  8.290e-003+ 2.000*( 1.254e-001* 5.069e-003*cos(t)+ 9.921e-001* 2.546e-003*sin(t)),  2.609e-002 +2.000*(-9.921e-001* 5.069e-003*cos(t)+ 1.254e-001* 2.546e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.301e-002, 3.779e-002 center
replot  1.301e-002+ 2.000*( 1.854e-001* 6.035e-003*cos(t)+ 9.827e-001* 3.260e-003*sin(t)),  3.779e-002 +2.000*(-9.827e-001* 6.035e-003*cos(t)+ 1.854e-001* 3.260e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.035e-002, 5.452e-002 center
replot  2.035e-002+ 2.000*( 2.455e-001* 8.762e-003*cos(t)+ 9.694e-001* 4.936e-003*sin(t)),  5.452e-002 +2.000*(-9.694e-001* 8.762e-003*cos(t)+ 2.455e-001* 4.936e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.163e-002, 7.819e-002 center
replot  3.163e-002+ 2.000*( 2.813e-001* 1.531e-002*cos(t)+ 9.596e-001* 9.029e-003*sin(t)),  7.819e-002 +2.000*(-9.596e-001* 1.531e-002*cos(t)+ 2.813e-001* 9.029e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  4.875e-002, 1.112e-001 center
replot  4.875e-002+ 2.000*( 3.268e-001* 2.785e-002*cos(t)+ 9.451e-001* 1.736e-002*sin(t)),  1.112e-001 +2.000*(-9.451e-001* 2.785e-002*cos(t)+ 3.268e-001* 1.736e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  7.422e-002, 1.562e-001 center
replot  7.422e-002+ 2.000*( 4.027e-001* 4.918e-002*cos(t)+ 9.153e-001* 3.209e-002*sin(t)),  1.562e-001 +2.000*(-9.153e-001* 4.918e-002*cos(t)+ 4.027e-001* 3.209e-002*sin(t)) not
set out;
set out "ATMadl/VARPIJGR_ATMadl_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ATMadl/VARPIJGR_ATMadl_121-12.svg"
set label "50" at  5.979e-001, 8.471e-003 center
# Age 50, p21 - p12
plot [-pi:pi]  5.979e-001+ 2.000*( 1.000e+000* 1.666e-001*cos(t)+-5.081e-003* 3.177e-003*sin(t)),  8.471e-003 +2.000*( 5.081e-003* 1.666e-001*cos(t)+ 1.000e+000* 3.177e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  4.939e-001, 1.234e-002 center
replot  4.939e-001+ 2.000*( 1.000e+000* 1.179e-001*cos(t)+-8.599e-003* 3.772e-003*sin(t)),  1.234e-002 +2.000*( 8.599e-003* 1.179e-001*cos(t)+ 1.000e+000* 3.772e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  4.019e-001, 1.796e-002 center
replot  4.019e-001+ 2.000*( 9.999e-001* 7.971e-002*cos(t)+-1.461e-002* 4.331e-003*sin(t)),  1.796e-002 +2.000*( 1.461e-002* 7.971e-002*cos(t)+ 9.999e-001* 4.331e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.223e-001, 2.609e-002 center
replot  3.223e-001+ 2.000*( 9.997e-001* 5.488e-002*cos(t)+-2.306e-002* 4.879e-003*sin(t)),  2.609e-002 +2.000*( 2.306e-002* 5.488e-002*cos(t)+ 9.997e-001* 4.879e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.546e-001, 3.779e-002 center
replot  2.546e-001+ 2.000*( 9.995e-001* 4.402e-002*cos(t)+-3.152e-002* 5.800e-003*sin(t)),  3.779e-002 +2.000*( 3.152e-002* 4.402e-002*cos(t)+ 9.995e-001* 5.800e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.981e-001, 5.452e-002 center
replot  1.981e-001+ 2.000*( 9.989e-001* 4.210e-002*cos(t)+-4.616e-002* 8.366e-003*sin(t)),  5.452e-002 +2.000*( 4.616e-002* 4.210e-002*cos(t)+ 9.989e-001* 8.366e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.515e-001, 7.819e-002 center
replot  1.515e-001+ 2.000*( 9.963e-001* 4.212e-002*cos(t)+-8.646e-002* 1.451e-002*sin(t)),  7.819e-002 +2.000*( 8.646e-002* 4.212e-002*cos(t)+ 9.963e-001* 1.451e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.136e-001, 1.112e-001 center
replot  1.136e-001+ 2.000*( 9.724e-001* 4.109e-002*cos(t)+-2.334e-001* 2.587e-002*sin(t)),  1.112e-001 +2.000*( 2.334e-001* 4.109e-002*cos(t)+ 9.724e-001* 2.587e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  8.315e-002, 1.562e-001 center
replot  8.315e-002+ 2.000*( 3.461e-001* 4.823e-002*cos(t)+-9.382e-001* 3.499e-002*sin(t)),  1.562e-001 +2.000*( 9.382e-001* 4.823e-002*cos(t)+ 3.461e-001* 3.499e-002*sin(t)) not
set out;
set out "ATMadl/VARPIJGR_ATMadl_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ATMadl/VARPIJGR_ATMadl_123-12.svg"
set label "50" at  1.963e-002, 8.471e-003 center
# Age 50, p23 - p12
plot [-pi:pi]  1.963e-002+ 2.000*( 9.997e-001* 1.511e-002*cos(t)+-2.405e-002* 3.269e-003*sin(t)),  8.471e-003 +2.000*( 2.405e-002* 1.511e-002*cos(t)+ 9.997e-001* 3.269e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  3.045e-002, 1.234e-002 center
replot  3.045e-002+ 2.000*( 9.997e-001* 1.990e-002*cos(t)+-2.570e-002* 3.873e-003*sin(t)),  1.234e-002 +2.000*( 2.570e-002* 1.990e-002*cos(t)+ 9.997e-001* 3.873e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  4.655e-002, 1.796e-002 center
replot  4.655e-002+ 2.000*( 9.996e-001* 2.512e-002*cos(t)+-2.781e-002* 4.431e-003*sin(t)),  1.796e-002 +2.000*( 2.781e-002* 2.512e-002*cos(t)+ 9.996e-001* 4.431e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  7.011e-002, 2.609e-002 center
replot  7.011e-002+ 2.000*( 9.995e-001* 3.018e-002*cos(t)+-3.115e-002* 4.953e-003*sin(t)),  2.609e-002 +2.000*( 3.115e-002* 3.018e-002*cos(t)+ 9.995e-001* 4.953e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  1.041e-001, 3.779e-002 center
replot  1.041e-001+ 2.000*( 9.993e-001* 3.427e-002*cos(t)+-3.742e-002* 5.825e-003*sin(t)),  3.779e-002 +2.000*( 3.742e-002* 3.427e-002*cos(t)+ 9.993e-001* 5.825e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.520e-001, 5.452e-002 center
replot  1.520e-001+ 2.000*( 9.987e-001* 3.719e-002*cos(t)+-5.044e-002* 8.383e-003*sin(t)),  5.452e-002 +2.000*( 5.044e-002* 3.719e-002*cos(t)+ 9.987e-001* 8.383e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  2.184e-001, 7.819e-002 center
replot  2.184e-001+ 2.000*( 9.974e-001* 4.231e-002*cos(t)+-7.272e-002* 1.463e-002*sin(t)),  7.819e-002 +2.000*( 7.272e-002* 4.231e-002*cos(t)+ 9.974e-001* 1.463e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  3.075e-001, 1.112e-001 center
replot  3.075e-001+ 2.000*( 9.964e-001* 5.958e-002*cos(t)+-8.442e-002* 2.654e-002*sin(t)),  1.112e-001 +2.000*( 8.442e-002* 5.958e-002*cos(t)+ 9.964e-001* 2.654e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  4.229e-001, 1.562e-001 center
replot  4.229e-001+ 2.000*( 9.969e-001* 9.757e-002*cos(t)+-7.838e-002* 4.635e-002*sin(t)),  1.562e-001 +2.000*( 7.838e-002* 9.757e-002*cos(t)+ 9.969e-001* 4.635e-002*sin(t)) not
set out;
set out "ATMadl/VARPIJGR_ATMadl_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ATMadl/VARPIJGR_ATMadl_121-13.svg"
set label "50" at  5.979e-001, 2.115e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  5.979e-001+ 2.000*( 1.000e+000* 1.666e-001*cos(t)+-6.675e-005* 1.281e-003*sin(t)),  2.115e-003 +2.000*( 6.675e-005* 1.666e-001*cos(t)+ 1.000e+000* 1.281e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  4.939e-001, 3.339e-003 center
replot  4.939e-001+ 2.000*( 1.000e+000* 1.179e-001*cos(t)+-1.476e-004* 1.664e-003*sin(t)),  3.339e-003 +2.000*( 1.476e-004* 1.179e-001*cos(t)+ 1.000e+000* 1.664e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  4.019e-001, 5.266e-003 center
replot  4.019e-001+ 2.000*( 1.000e+000* 7.970e-002*cos(t)+-4.312e-004* 2.098e-003*sin(t)),  5.266e-003 +2.000*( 4.312e-004* 7.970e-002*cos(t)+ 1.000e+000* 2.098e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.223e-001, 8.290e-003 center
replot  3.223e-001+ 2.000*( 1.000e+000* 5.486e-002*cos(t)+-1.470e-003* 2.603e-003*sin(t)),  8.290e-003 +2.000*( 1.470e-003* 5.486e-002*cos(t)+ 1.000e+000* 2.603e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.546e-001, 1.301e-002 center
replot  2.546e-001+ 2.000*( 1.000e+000* 4.400e-002*cos(t)+-4.060e-003* 3.389e-003*sin(t)),  1.301e-002 +2.000*( 4.060e-003* 4.400e-002*cos(t)+ 1.000e+000* 3.389e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.981e-001, 2.035e-002 center
replot  1.981e-001+ 2.000*( 1.000e+000* 4.205e-002*cos(t)+-8.005e-003* 5.236e-003*sin(t)),  2.035e-002 +2.000*( 8.005e-003* 4.205e-002*cos(t)+ 1.000e+000* 5.236e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.515e-001, 3.163e-002 center
replot  1.515e-001+ 2.000*( 9.999e-001* 4.198e-002*cos(t)+-1.448e-002* 9.658e-003*sin(t)),  3.163e-002 +2.000*( 1.448e-002* 4.198e-002*cos(t)+ 9.999e-001* 9.658e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.136e-001, 4.875e-002 center
replot  1.136e-001+ 2.000*( 9.995e-001* 4.043e-002*cos(t)+-3.152e-002* 1.873e-002*sin(t)),  4.875e-002 +2.000*( 3.152e-002* 4.043e-002*cos(t)+ 9.995e-001* 1.873e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  8.315e-002, 7.422e-002 center
replot  8.315e-002+ 2.000*( 8.985e-001* 3.725e-002*cos(t)+-4.390e-001* 3.497e-002*sin(t)),  7.422e-002 +2.000*( 4.390e-001* 3.725e-002*cos(t)+ 8.985e-001* 3.497e-002*sin(t)) not
set out;
set out "ATMadl/VARPIJGR_ATMadl_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ATMadl/VARPIJGR_ATMadl_123-13.svg"
set label "50" at  1.963e-002, 2.115e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  1.963e-002+ 2.000*( 9.998e-001* 1.511e-002*cos(t)+ 2.020e-002* 1.245e-003*sin(t)),  2.115e-003 +2.000*(-2.020e-002* 1.511e-002*cos(t)+ 9.998e-001* 1.245e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  3.045e-002, 3.339e-003 center
replot  3.045e-002+ 2.000*( 9.998e-001* 1.989e-002*cos(t)+ 2.157e-002* 1.608e-003*sin(t)),  3.339e-003 +2.000*(-2.157e-002* 1.989e-002*cos(t)+ 9.998e-001* 1.608e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  4.655e-002, 5.266e-003 center
replot  4.655e-002+ 2.000*( 9.997e-001* 2.512e-002*cos(t)+ 2.391e-002* 2.011e-003*sin(t)),  5.266e-003 +2.000*(-2.391e-002* 2.512e-002*cos(t)+ 9.997e-001* 2.011e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  7.011e-002, 8.290e-003 center
replot  7.011e-002+ 2.000*( 9.996e-001* 3.018e-002*cos(t)+ 2.799e-002* 2.464e-003*sin(t)),  8.290e-003 +2.000*(-2.799e-002* 3.018e-002*cos(t)+ 9.996e-001* 2.464e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  1.041e-001, 1.301e-002 center
replot  1.041e-001+ 2.000*( 9.994e-001* 3.427e-002*cos(t)+ 3.564e-002* 3.168e-003*sin(t)),  1.301e-002 +2.000*(-3.564e-002* 3.427e-002*cos(t)+ 9.994e-001* 3.168e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.520e-001, 2.035e-002 center
replot  1.520e-001+ 2.000*( 9.987e-001* 3.719e-002*cos(t)+ 5.064e-002* 4.903e-003*sin(t)),  2.035e-002 +2.000*(-5.064e-002* 3.719e-002*cos(t)+ 9.987e-001* 4.903e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  2.184e-001, 3.163e-002 center
replot  2.184e-001+ 2.000*( 9.973e-001* 4.232e-002*cos(t)+ 7.361e-002* 9.186e-003*sin(t)),  3.163e-002 +2.000*(-7.361e-002* 4.232e-002*cos(t)+ 9.973e-001* 9.186e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  3.075e-001, 4.875e-002 center
replot  3.075e-001+ 2.000*( 9.965e-001* 5.960e-002*cos(t)+ 8.380e-002* 1.815e-002*sin(t)),  4.875e-002 +2.000*(-8.380e-002* 5.960e-002*cos(t)+ 9.965e-001* 1.815e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  4.229e-001, 7.422e-002 center
replot  4.229e-001+ 2.000*( 9.969e-001* 9.760e-002*cos(t)+ 7.929e-002* 3.468e-002*sin(t)),  7.422e-002 +2.000*(-7.929e-002* 9.760e-002*cos(t)+ 9.969e-001* 3.468e-002*sin(t)) not
set out;
set out "ATMadl/VARPIJGR_ATMadl_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "ATMadl/VARPIJGR_ATMadl_123-21.svg"
set label "50" at  1.963e-002, 5.979e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.963e-002+ 2.000*( 9.056e-003* 1.666e-001*cos(t)+ 1.000e+000* 1.504e-002*sin(t)),  5.979e-001 +2.000*(-1.000e+000* 1.666e-001*cos(t)+ 9.056e-003* 1.504e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  3.045e-002, 4.939e-001 center
replot  3.045e-002+ 2.000*( 1.383e-002* 1.179e-001*cos(t)+ 9.999e-001* 1.982e-002*sin(t)),  4.939e-001 +2.000*(-9.999e-001* 1.179e-001*cos(t)+ 1.383e-002* 1.982e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  4.655e-002, 4.019e-001 center
replot  4.655e-002+ 2.000*( 2.662e-002* 7.972e-002*cos(t)+ 9.996e-001* 2.503e-002*sin(t)),  4.019e-001 +2.000*(-9.996e-001* 7.972e-002*cos(t)+ 2.662e-002* 2.503e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  7.011e-002, 3.223e-001 center
replot  7.011e-002+ 2.000*( 7.214e-002* 5.496e-002*cos(t)+ 9.974e-001* 2.999e-002*sin(t)),  3.223e-001 +2.000*(-9.974e-001* 5.496e-002*cos(t)+ 7.214e-002* 2.999e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  1.041e-001, 2.546e-001 center
replot  1.041e-001+ 2.000*( 2.123e-001* 4.443e-002*cos(t)+ 9.772e-001* 3.369e-002*sin(t)),  2.546e-001 +2.000*(-9.772e-001* 4.443e-002*cos(t)+ 2.123e-001* 3.369e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.520e-001, 1.981e-001 center
replot  1.520e-001+ 2.000*( 3.830e-001* 4.300e-002*cos(t)+ 9.237e-001* 3.605e-002*sin(t)),  1.981e-001 +2.000*(-9.237e-001* 4.300e-002*cos(t)+ 3.830e-001* 3.605e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  2.184e-001, 1.515e-001 center
replot  2.184e-001+ 2.000*( 7.233e-001* 4.449e-002*cos(t)+ 6.905e-001* 3.955e-002*sin(t)),  1.515e-001 +2.000*(-6.905e-001* 4.449e-002*cos(t)+ 7.233e-001* 3.955e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  3.075e-001, 1.136e-001 center
replot  3.075e-001+ 2.000*( 9.916e-001* 5.969e-002*cos(t)+ 1.296e-001* 4.000e-002*sin(t)),  1.136e-001 +2.000*(-1.296e-001* 5.969e-002*cos(t)+ 9.916e-001* 4.000e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  4.229e-001, 8.315e-002 center
replot  4.229e-001+ 2.000*( 9.987e-001* 9.745e-002*cos(t)+ 5.116e-002* 3.653e-002*sin(t)),  8.315e-002 +2.000*(-5.116e-002* 9.745e-002*cos(t)+ 9.987e-001* 3.653e-002*sin(t)) not
set out;
set out "ATMadl/VARPIJGR_ATMadl_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "ATMadl/VARMUPTJGR--STABLBASED_ATMadl1.svg";
 plot "ATMadl/PRMORPREV-1-STABLBASED_ATMadl.txt"  u 1:($3) not w l lt 1 
 replot "ATMadl/PRMORPREV-1-STABLBASED_ATMadl.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "ATMadl/PRMORPREV-1-STABLBASED_ATMadl.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "ATMadl/VARMUPTJGR--STABLBASED_ATMadl1.svg";replot;set out;
