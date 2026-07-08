
# IMaCh-0.99r45
# SEFgali.gp
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


set ter svg size 640, 480;set out "SEFgali/D_SEFgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "SEFgali/ILK_SEFgali-dest.png";
set log y;plot  "SEFgali/ILK_SEFgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "SEFgali/ILK_SEFgali-ori.png";
set log y;plot  "SEFgali/ILK_SEFgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "SEFgali/ILK_SEFgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "SEFgali/ILK_SEFgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "SEFgali/ILK_SEFgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "SEFgali/ILK_SEFgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "SEFgali/V_SEFgali_1-1-1.svg" 

#set out "V_SEFgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "SEFgali/VPL_SEFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"SEFgali/VPL_SEFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"SEFgali/VPL_SEFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"SEFgali/P_SEFgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "SEFgali/V_SEFgali_2-1-1.svg" 

#set out "V_SEFgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "SEFgali/VPL_SEFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"SEFgali/VPL_SEFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"SEFgali/VPL_SEFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"SEFgali/P_SEFgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "SEFgali/E_SEFgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "SEFgali/T_SEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"SEFgali/T_SEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"SEFgali/T_SEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"SEFgali/T_SEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"SEFgali/T_SEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"SEFgali/T_SEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"SEFgali/T_SEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"SEFgali/T_SEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"SEFgali/T_SEFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "SEFgali/E_SEFgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "SEFgali/EXP_SEFgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "SEFgali/E_SEFgali.txt" every :::0::0 u 1:2 t "e11" w l ,"SEFgali/E_SEFgali.txt" every :::0::0 u 1:3 t "e12" w l ,"SEFgali/E_SEFgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "SEFgali/EXP_SEFgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "SEFgali/E_SEFgali.txt" every :::0::0 u 1:5 t "e21" w l ,"SEFgali/E_SEFgali.txt" every :::0::0 u 1:6 t "e22" w l ,"SEFgali/E_SEFgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "SEFgali/LIJ_SEFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFgali/PIJ_SEFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "SEFgali/LIJ_SEFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFgali/PIJ_SEFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "SEFgali/LIJT_SEFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFgali/PIJ_SEFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "SEFgali/LIJT_SEFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFgali/PIJ_SEFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "SEFgali/P_SEFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFgali/PIJ_SEFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "SEFgali/P_SEFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFgali/PIJ_SEFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-5.441560; p2=0.030587; 
#   current state 3
p3=-11.796028; p4=0.091150; 
# initial state 2
#   current state 1
p5=-1.181207; p6=-0.007982; 
#   current state 3
p7=-14.612390; p8=0.145929; 
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

set out "SEFgali/PE_SEFgali_1-1-1.svg" 
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

set out "SEFgali/PE_SEFgali_1-2-1.svg" 
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

set out "SEFgali/PE_SEFgali_1-3-1.svg" 
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
set out "SEFgali/VARPIJGR_SEFgali_113-12.svg"
set label "50" at  1.408e-003, 3.918e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  1.408e-003+ 2.000*( 3.413e-002* 8.703e-003*cos(t)+ 9.994e-001* 1.013e-003*sin(t)),  3.918e-002 +2.000*(-9.994e-001* 8.703e-003*cos(t)+ 3.413e-002* 1.013e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  2.212e-003, 4.549e-002 center
replot  2.212e-003+ 2.000*( 3.980e-002* 7.963e-003*cos(t)+ 9.992e-001* 1.303e-003*sin(t)),  4.549e-002 +2.000*(-9.992e-001* 7.963e-003*cos(t)+ 3.980e-002* 1.303e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  3.474e-003, 5.277e-002 center
replot  3.474e-003+ 2.000*( 3.844e-002* 7.018e-003*cos(t)+ 9.993e-001* 1.607e-003*sin(t)),  5.277e-002 +2.000*(-9.993e-001* 7.018e-003*cos(t)+ 3.844e-002* 1.607e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  5.451e-003, 6.117e-002 center
replot  5.451e-003+ 2.000*( 2.238e-002* 6.238e-003*cos(t)+ 9.997e-001* 1.880e-003*sin(t)),  6.117e-002 +2.000*(-9.997e-001* 6.238e-003*cos(t)+ 2.238e-002* 1.880e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  8.541e-003, 7.081e-002 center
replot  8.541e-003+ 2.000*( 3.397e-002* 6.610e-003*cos(t)+ 9.994e-001* 2.199e-003*sin(t)),  7.081e-002 +2.000*(-9.994e-001* 6.610e-003*cos(t)+ 3.397e-002* 2.199e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.336e-002, 8.183e-002 center
replot  1.336e-002+ 2.000*( 1.357e-001* 9.226e-003*cos(t)+ 9.907e-001* 3.098e-003*sin(t)),  8.183e-002 +2.000*(-9.907e-001* 9.226e-003*cos(t)+ 1.357e-001* 3.098e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  2.085e-002, 9.434e-002 center
replot  2.085e-002+ 2.000*( 2.786e-001* 1.440e-002*cos(t)+ 9.604e-001* 5.580e-003*sin(t)),  9.434e-002 +2.000*(-9.604e-001* 1.440e-002*cos(t)+ 2.786e-001* 5.580e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  3.245e-002, 1.084e-001 center
replot  3.245e-002+ 2.000*( 4.627e-001* 2.270e-002*cos(t)+ 8.865e-001* 1.069e-002*sin(t)),  1.084e-001 +2.000*(-8.865e-001* 2.270e-002*cos(t)+ 4.627e-001* 1.069e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  5.026e-002, 1.241e-001 center
replot  5.026e-002+ 2.000*( 6.802e-001* 3.659e-002*cos(t)+ 7.331e-001* 1.871e-002*sin(t)),  1.241e-001 +2.000*(-7.331e-001* 3.659e-002*cos(t)+ 6.802e-001* 1.871e-002*sin(t)) not
set out;
set out "SEFgali/VARPIJGR_SEFgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "SEFgali/VARPIJGR_SEFgali_121-12.svg"
set label "50" at  3.413e-001, 3.918e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  3.413e-001+ 2.000*( 9.992e-001* 6.314e-002*cos(t)+-3.999e-002* 8.330e-003*sin(t)),  3.918e-002 +2.000*( 3.999e-002* 6.314e-002*cos(t)+ 9.992e-001* 8.330e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.300e-001, 4.549e-002 center
replot  3.300e-001+ 2.000*( 9.989e-001* 4.983e-002*cos(t)+-4.708e-002* 7.611e-003*sin(t)),  4.549e-002 +2.000*( 4.708e-002* 4.983e-002*cos(t)+ 9.989e-001* 7.611e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.187e-001, 5.277e-002 center
replot  3.187e-001+ 2.000*( 9.985e-001* 3.857e-002*cos(t)+-5.518e-002* 6.692e-003*sin(t)),  5.277e-002 +2.000*( 5.518e-002* 3.857e-002*cos(t)+ 9.985e-001* 6.692e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.074e-001, 6.117e-002 center
replot  3.074e-001+ 2.000*( 9.979e-001* 3.059e-002*cos(t)+-6.510e-002* 5.922e-003*sin(t)),  6.117e-002 +2.000*( 6.510e-002* 3.059e-002*cos(t)+ 9.979e-001* 5.922e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.955e-001, 7.081e-002 center
replot  2.955e-001+ 2.000*( 9.968e-001* 2.763e-002*cos(t)+-8.005e-002* 6.245e-003*sin(t)),  7.081e-002 +2.000*( 8.005e-002* 2.763e-002*cos(t)+ 9.968e-001* 6.245e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.825e-001, 8.183e-002 center
replot  2.825e-001+ 2.000*( 9.948e-001* 3.004e-002*cos(t)+-1.021e-001* 8.666e-003*sin(t)),  8.183e-002 +2.000*( 1.021e-001* 3.004e-002*cos(t)+ 9.948e-001* 8.666e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.668e-001, 9.434e-002 center
replot  2.668e-001+ 2.000*( 9.917e-001* 3.555e-002*cos(t)+-1.289e-001* 1.325e-002*sin(t)),  9.434e-002 +2.000*( 1.289e-001* 3.555e-002*cos(t)+ 9.917e-001* 1.325e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  2.461e-001, 1.084e-001 center
replot  2.461e-001+ 2.000*( 9.872e-001* 4.139e-002*cos(t)+-1.592e-001* 1.990e-002*sin(t)),  1.084e-001 +2.000*( 1.592e-001* 4.139e-002*cos(t)+ 9.872e-001* 1.990e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  2.172e-001, 1.241e-001 center
replot  2.172e-001+ 2.000*( 9.825e-001* 4.574e-002*cos(t)+-1.861e-001* 2.894e-002*sin(t)),  1.241e-001 +2.000*( 1.861e-001* 4.574e-002*cos(t)+ 9.825e-001* 2.894e-002*sin(t)) not
set out;
set out "SEFgali/VARPIJGR_SEFgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "SEFgali/VARPIJGR_SEFgali_123-12.svg"
set label "50" at  1.102e-003, 3.918e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  1.102e-003+ 2.000*( 2.510e-002* 8.700e-003*cos(t)+-9.997e-001* 1.245e-003*sin(t)),  3.918e-002 +2.000*( 9.997e-001* 8.700e-003*cos(t)+ 2.510e-002* 1.245e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.300e-003, 4.549e-002 center
replot  2.300e-003+ 2.000*( 4.657e-002* 7.964e-003*cos(t)+-9.989e-001* 2.228e-003*sin(t)),  4.549e-002 +2.000*( 9.989e-001* 7.964e-003*cos(t)+ 4.657e-002* 2.228e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  4.796e-003, 5.277e-002 center
replot  4.796e-003+ 2.000*( 9.867e-002* 7.037e-003*cos(t)+-9.951e-001* 3.875e-003*sin(t)),  5.277e-002 +2.000*( 9.951e-001* 7.037e-003*cos(t)+ 9.867e-002* 3.875e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  9.985e-003, 6.117e-002 center
replot  9.985e-003+ 2.000*( 8.717e-001* 6.677e-003*cos(t)+-4.901e-001* 6.090e-003*sin(t)),  6.117e-002 +2.000*( 4.901e-001* 6.677e-003*cos(t)+ 8.717e-001* 6.090e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  2.073e-002, 7.081e-002 center
replot  2.073e-002+ 2.000*( 9.993e-001* 1.032e-002*cos(t)+-3.652e-002* 6.600e-003*sin(t)),  7.081e-002 +2.000*( 3.652e-002* 1.032e-002*cos(t)+ 9.993e-001* 6.600e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  4.276e-002, 8.183e-002 center
replot  4.276e-002+ 2.000*( 9.984e-001* 1.508e-002*cos(t)+-5.611e-002* 9.125e-003*sin(t)),  8.183e-002 +2.000*( 5.611e-002* 1.508e-002*cos(t)+ 9.984e-001* 9.125e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  8.719e-002, 9.434e-002 center
replot  8.719e-002+ 2.000*( 9.736e-001* 2.124e-002*cos(t)+-2.282e-001* 1.340e-002*sin(t)),  9.434e-002 +2.000*( 2.282e-001* 2.124e-002*cos(t)+ 9.736e-001* 1.340e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.736e-001, 1.084e-001 center
replot  1.736e-001+ 2.000*( 9.560e-001* 3.774e-002*cos(t)+-2.932e-001* 1.833e-002*sin(t)),  1.084e-001 +2.000*( 2.932e-001* 3.774e-002*cos(t)+ 9.560e-001* 1.833e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  3.309e-001, 1.241e-001 center
replot  3.309e-001+ 2.000*( 9.868e-001* 8.835e-002*cos(t)+-1.620e-001* 2.636e-002*sin(t)),  1.241e-001 +2.000*( 1.620e-001* 8.835e-002*cos(t)+ 9.868e-001* 2.636e-002*sin(t)) not
set out;
set out "SEFgali/VARPIJGR_SEFgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "SEFgali/VARPIJGR_SEFgali_121-13.svg"
set label "50" at  3.413e-001, 1.408e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  3.413e-001+ 2.000*( 1.000e+000* 6.309e-002*cos(t)+ 6.484e-005* 1.055e-003*sin(t)),  1.408e-003 +2.000*(-6.484e-005* 6.309e-002*cos(t)+ 1.000e+000* 1.055e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.300e-001, 2.212e-003 center
replot  3.300e-001+ 2.000*( 1.000e+000* 4.977e-002*cos(t)+-8.597e-005* 1.340e-003*sin(t)),  2.212e-003 +2.000*( 8.597e-005* 4.977e-002*cos(t)+ 1.000e+000* 1.340e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.187e-001, 3.474e-003 center
replot  3.187e-001+ 2.000*( 1.000e+000* 3.851e-002*cos(t)+-6.379e-004* 1.628e-003*sin(t)),  3.474e-003 +2.000*( 6.379e-004* 3.851e-002*cos(t)+ 1.000e+000* 1.628e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.074e-001, 5.451e-003 center
replot  3.074e-001+ 2.000*( 1.000e+000* 3.053e-002*cos(t)+-1.995e-003* 1.884e-003*sin(t)),  5.451e-003 +2.000*( 1.995e-003* 3.053e-002*cos(t)+ 1.000e+000* 1.884e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.955e-001, 8.541e-003 center
replot  2.955e-001+ 2.000*( 1.000e+000* 2.755e-002*cos(t)+-3.381e-003* 2.207e-003*sin(t)),  8.541e-003 +2.000*( 3.381e-003* 2.755e-002*cos(t)+ 1.000e+000* 2.207e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.825e-001, 1.336e-002 center
replot  2.825e-001+ 2.000*( 1.000e+000* 2.990e-002*cos(t)+-2.720e-003* 3.314e-003*sin(t)),  1.336e-002 +2.000*( 2.720e-003* 2.990e-002*cos(t)+ 1.000e+000* 3.314e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.668e-001, 2.085e-002 center
replot  2.668e-001+ 2.000*( 1.000e+000* 3.530e-002*cos(t)+-2.597e-003* 6.693e-003*sin(t)),  2.085e-002 +2.000*( 2.597e-003* 3.530e-002*cos(t)+ 1.000e+000* 6.693e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  2.461e-001, 3.245e-002 center
replot  2.461e-001+ 2.000*( 9.999e-001* 4.099e-002*cos(t)+-1.597e-002* 1.413e-002*sin(t)),  3.245e-002 +2.000*( 1.597e-002* 4.099e-002*cos(t)+ 9.999e-001* 1.413e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  2.172e-001, 5.026e-002 center
replot  2.172e-001+ 2.000*( 9.928e-001* 4.547e-002*cos(t)+-1.196e-001* 2.809e-002*sin(t)),  5.026e-002 +2.000*( 1.196e-001* 4.547e-002*cos(t)+ 9.928e-001* 2.809e-002*sin(t)) not
set out;
set out "SEFgali/VARPIJGR_SEFgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "SEFgali/VARPIJGR_SEFgali_123-13.svg"
set label "50" at  1.102e-003, 1.408e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  1.102e-003+ 2.000*( 8.392e-001* 1.395e-003*cos(t)+ 5.438e-001* 8.737e-004*sin(t)),  1.408e-003 +2.000*(-5.438e-001* 1.395e-003*cos(t)+ 8.392e-001* 8.737e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.300e-003, 2.212e-003 center
replot  2.300e-003+ 2.000*( 9.505e-001* 2.342e-003*cos(t)+ 3.106e-001* 1.184e-003*sin(t)),  2.212e-003 +2.000*(-3.106e-001* 2.342e-003*cos(t)+ 9.505e-001* 1.184e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  4.796e-003, 3.474e-003 center
replot  4.796e-003+ 2.000*( 9.827e-001* 3.977e-003*cos(t)+ 1.854e-001* 1.477e-003*sin(t)),  3.474e-003 +2.000*(-1.854e-001* 3.977e-003*cos(t)+ 9.827e-001* 1.477e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  9.985e-003, 5.451e-003 center
replot  9.985e-003+ 2.000*( 9.934e-001* 6.582e-003*cos(t)+ 1.147e-001* 1.739e-003*sin(t)),  5.451e-003 +2.000*(-1.147e-001* 6.582e-003*cos(t)+ 9.934e-001* 1.739e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  2.073e-002, 8.541e-003 center
replot  2.073e-002+ 2.000*( 9.973e-001* 1.035e-002*cos(t)+ 7.361e-002* 2.079e-003*sin(t)),  8.541e-003 +2.000*(-7.361e-002* 1.035e-002*cos(t)+ 9.973e-001* 2.079e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  4.276e-002, 1.336e-002 center
replot  4.276e-002+ 2.000*( 9.980e-001* 1.509e-002*cos(t)+ 6.271e-002* 3.183e-003*sin(t)),  1.336e-002 +2.000*(-6.271e-002* 1.509e-002*cos(t)+ 9.980e-001* 3.183e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  8.719e-002, 2.085e-002 center
replot  8.719e-002+ 2.000*( 9.923e-001* 2.105e-002*cos(t)+ 1.242e-001* 6.210e-003*sin(t)),  2.085e-002 +2.000*(-1.242e-001* 2.105e-002*cos(t)+ 9.923e-001* 6.210e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.736e-001, 3.245e-002 center
replot  1.736e-001+ 2.000*( 9.726e-001* 3.741e-002*cos(t)+ 2.326e-001* 1.147e-002*sin(t)),  3.245e-002 +2.000*(-2.326e-001* 3.741e-002*cos(t)+ 9.726e-001* 1.147e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  3.309e-001, 5.026e-002 center
replot  3.309e-001+ 2.000*( 9.796e-001* 8.898e-002*cos(t)+ 2.009e-001* 2.255e-002*sin(t)),  5.026e-002 +2.000*(-2.009e-001* 8.898e-002*cos(t)+ 9.796e-001* 2.255e-002*sin(t)) not
set out;
set out "SEFgali/VARPIJGR_SEFgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "SEFgali/VARPIJGR_SEFgali_123-21.svg"
set label "50" at  1.102e-003, 3.413e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.102e-003+ 2.000*( 1.367e-004* 6.309e-002*cos(t)+ 1.000e+000* 1.263e-003*sin(t)),  3.413e-001 +2.000*(-1.000e+000* 6.309e-002*cos(t)+ 1.367e-004* 1.263e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.300e-003, 3.300e-001 center
replot  2.300e-003+ 2.000*( 7.360e-004* 4.977e-002*cos(t)+ 1.000e+000* 2.256e-003*sin(t)),  3.300e-001 +2.000*(-1.000e+000* 4.977e-002*cos(t)+ 7.360e-004* 2.256e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  4.796e-003, 3.187e-001 center
replot  4.796e-003+ 2.000*( 3.434e-003* 3.851e-002*cos(t)+ 1.000e+000* 3.916e-003*sin(t)),  3.187e-001 +2.000*(-1.000e+000* 3.851e-002*cos(t)+ 3.434e-003* 3.916e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  9.985e-003, 3.074e-001 center
replot  9.985e-003+ 2.000*( 1.383e-002* 3.053e-002*cos(t)+ 9.999e-001* 6.528e-003*sin(t)),  3.074e-001 +2.000*(-9.999e-001* 3.053e-002*cos(t)+ 1.383e-002* 6.528e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  2.073e-002, 2.955e-001 center
replot  2.073e-002+ 2.000*( 4.019e-002* 2.757e-002*cos(t)+ 9.992e-001* 1.027e-002*sin(t)),  2.955e-001 +2.000*(-9.992e-001* 2.757e-002*cos(t)+ 4.019e-002* 1.027e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  4.276e-002, 2.825e-001 center
replot  4.276e-002+ 2.000*( 6.935e-002* 2.995e-002*cos(t)+ 9.976e-001* 1.495e-002*sin(t)),  2.825e-001 +2.000*(-9.976e-001* 2.995e-002*cos(t)+ 6.935e-002* 1.495e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  8.719e-002, 2.668e-001 center
replot  8.719e-002+ 2.000*( 7.926e-002* 3.537e-002*cos(t)+ 9.969e-001* 2.078e-002*sin(t)),  2.668e-001 +2.000*(-9.969e-001* 3.537e-002*cos(t)+ 7.926e-002* 2.078e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.736e-001, 2.461e-001 center
replot  1.736e-001+ 2.000*( 3.081e-001* 4.148e-002*cos(t)+ 9.514e-001* 3.592e-002*sin(t)),  2.461e-001 +2.000*(-9.514e-001* 4.148e-002*cos(t)+ 3.081e-001* 3.592e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  3.309e-001, 2.172e-001 center
replot  3.309e-001+ 2.000*( 9.906e-001* 8.790e-002*cos(t)+ 1.366e-001* 4.406e-002*sin(t)),  2.172e-001 +2.000*(-1.366e-001* 8.790e-002*cos(t)+ 9.906e-001* 4.406e-002*sin(t)) not
set out;
set out "SEFgali/VARPIJGR_SEFgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "SEFgali/VARMUPTJGR--STABLBASED_SEFgali1.svg";
 plot "SEFgali/PRMORPREV-1-STABLBASED_SEFgali.txt"  u 1:($3) not w l lt 1 
 replot "SEFgali/PRMORPREV-1-STABLBASED_SEFgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "SEFgali/PRMORPREV-1-STABLBASED_SEFgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "SEFgali/VARMUPTJGR--STABLBASED_SEFgali1.svg";replot;set out;
