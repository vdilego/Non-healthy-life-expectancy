
# IMaCh-0.99r45
# CZFgali.gp
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


set ter svg size 640, 480;set out "CZFgali/D_CZFgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "CZFgali/ILK_CZFgali-dest.png";
set log y;plot  "CZFgali/ILK_CZFgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "CZFgali/ILK_CZFgali-ori.png";
set log y;plot  "CZFgali/ILK_CZFgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "CZFgali/ILK_CZFgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "CZFgali/ILK_CZFgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "CZFgali/ILK_CZFgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "CZFgali/ILK_CZFgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "CZFgali/V_CZFgali_1-1-1.svg" 

#set out "V_CZFgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "CZFgali/VPL_CZFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"CZFgali/VPL_CZFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"CZFgali/VPL_CZFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"CZFgali/P_CZFgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "CZFgali/V_CZFgali_2-1-1.svg" 

#set out "V_CZFgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "CZFgali/VPL_CZFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"CZFgali/VPL_CZFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"CZFgali/VPL_CZFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"CZFgali/P_CZFgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "CZFgali/E_CZFgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "CZFgali/T_CZFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"CZFgali/T_CZFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"CZFgali/T_CZFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"CZFgali/T_CZFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"CZFgali/T_CZFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"CZFgali/T_CZFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"CZFgali/T_CZFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"CZFgali/T_CZFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"CZFgali/T_CZFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "CZFgali/E_CZFgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "CZFgali/EXP_CZFgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "CZFgali/E_CZFgali.txt" every :::0::0 u 1:2 t "e11" w l ,"CZFgali/E_CZFgali.txt" every :::0::0 u 1:3 t "e12" w l ,"CZFgali/E_CZFgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "CZFgali/EXP_CZFgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "CZFgali/E_CZFgali.txt" every :::0::0 u 1:5 t "e21" w l ,"CZFgali/E_CZFgali.txt" every :::0::0 u 1:6 t "e22" w l ,"CZFgali/E_CZFgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "CZFgali/LIJ_CZFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFgali/PIJ_CZFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "CZFgali/LIJ_CZFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFgali/PIJ_CZFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "CZFgali/LIJT_CZFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFgali/PIJ_CZFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "CZFgali/LIJT_CZFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFgali/PIJ_CZFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "CZFgali/P_CZFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFgali/PIJ_CZFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "CZFgali/P_CZFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFgali/PIJ_CZFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-7.478327; p2=0.060359; 
#   current state 3
p3=-22.391146; p4=0.223917; 
# initial state 2
#   current state 1
p5=-0.721682; p6=-0.013288; 
#   current state 3
p7=-7.967159; p8=0.069253; 
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

set out "CZFgali/PE_CZFgali_1-1-1.svg" 
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

set out "CZFgali/PE_CZFgali_1-2-1.svg" 
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

set out "CZFgali/PE_CZFgali_1-3-1.svg" 
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
set out "CZFgali/VARPIJGR_CZFgali_113-12.svg"
set label "50" at  2.716e-005, 2.285e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  2.716e-005+ 2.000*( 9.927e-004* 4.460e-003*cos(t)+ 1.000e+000* 4.731e-005*sin(t)),  2.285e-002 +2.000*(-1.000e+000* 4.460e-003*cos(t)+ 9.927e-004* 4.731e-005*sin(t)) not
# Age 55, p13 - p12
set label "55" at  8.288e-005, 3.078e-002 center
replot  8.288e-005+ 2.000*( 2.904e-003* 4.801e-003*cos(t)+ 1.000e+000* 1.232e-004*sin(t)),  3.078e-002 +2.000*(-1.000e+000* 4.801e-003*cos(t)+ 2.904e-003* 1.232e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  2.525e-004, 4.139e-002 center
replot  2.525e-004+ 2.000*( 9.056e-003* 4.989e-003*cos(t)+ 1.000e+000* 3.110e-004*sin(t)),  4.139e-002 +2.000*(-1.000e+000* 4.989e-003*cos(t)+ 9.056e-003* 3.110e-004*sin(t)) not
# Age 65, p13 - p12
set label "65" at  7.678e-004, 5.555e-002 center
replot  7.678e-004+ 2.000*( 2.886e-002* 5.158e-003*cos(t)+ 9.996e-001* 7.502e-004*sin(t)),  5.555e-002 +2.000*(-9.996e-001* 5.158e-003*cos(t)+ 2.886e-002* 7.502e-004*sin(t)) not
# Age 70, p13 - p12
set label "70" at  2.328e-003, 7.434e-002 center
replot  2.328e-003+ 2.000*( 7.667e-002* 6.012e-003*cos(t)+ 9.971e-001* 1.695e-003*sin(t)),  7.434e-002 +2.000*(-9.971e-001* 6.012e-003*cos(t)+ 7.667e-002* 1.695e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  7.022e-003, 9.899e-002 center
replot  7.022e-003+ 2.000*( 1.324e-001* 8.931e-003*cos(t)+ 9.912e-001* 3.508e-003*sin(t)),  9.899e-002 +2.000*(-9.912e-001* 8.931e-003*cos(t)+ 1.324e-001* 3.508e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  2.100e-002, 1.306e-001 center
replot  2.100e-002+ 2.000*( 1.800e-001* 1.503e-002*cos(t)+ 9.837e-001* 6.638e-003*sin(t)),  1.306e-001 +2.000*(-9.837e-001* 1.503e-002*cos(t)+ 1.800e-001* 6.638e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  6.157e-002, 1.691e-001 center
replot  6.157e-002+ 2.000*( 3.753e-001* 2.553e-002*cos(t)+ 9.269e-001* 1.614e-002*sin(t)),  1.691e-001 +2.000*(-9.269e-001* 2.553e-002*cos(t)+ 3.753e-001* 1.614e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.725e-001, 2.092e-001 center
replot  1.725e-001+ 2.000*( 9.666e-001* 7.129e-002*cos(t)+ 2.562e-001* 3.458e-002*sin(t)),  2.092e-001 +2.000*(-2.562e-001* 7.129e-002*cos(t)+ 9.666e-001* 3.458e-002*sin(t)) not
set out;
set out "CZFgali/VARPIJGR_CZFgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "CZFgali/VARPIJGR_CZFgali_121-12.svg"
set label "50" at  3.966e-001, 2.285e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  3.966e-001+ 2.000*( 9.998e-001* 5.817e-002*cos(t)+-2.164e-002* 4.280e-003*sin(t)),  2.285e-002 +2.000*( 2.164e-002* 5.817e-002*cos(t)+ 9.998e-001* 4.280e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.745e-001, 3.078e-002 center
replot  3.745e-001+ 2.000*( 9.995e-001* 4.454e-002*cos(t)+-3.009e-002* 4.613e-003*sin(t)),  3.078e-002 +2.000*( 3.009e-002* 4.454e-002*cos(t)+ 9.995e-001* 4.613e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.528e-001, 4.139e-002 center
replot  3.528e-001+ 2.000*( 9.991e-001* 3.343e-002*cos(t)+-4.192e-002* 4.792e-003*sin(t)),  4.139e-002 +2.000*( 4.192e-002* 3.343e-002*cos(t)+ 9.991e-001* 4.792e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.315e-001, 5.555e-002 center
replot  3.315e-001+ 2.000*( 9.983e-001* 2.615e-002*cos(t)+-5.913e-002* 4.928e-003*sin(t)),  5.555e-002 +2.000*( 5.913e-002* 2.615e-002*cos(t)+ 9.983e-001* 4.928e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  3.102e-001, 7.434e-002 center
replot  3.102e-001+ 2.000*( 9.963e-001* 2.425e-002*cos(t)+-8.565e-002* 5.645e-003*sin(t)),  7.434e-002 +2.000*( 8.565e-002* 2.425e-002*cos(t)+ 9.963e-001* 5.645e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.889e-001, 9.899e-002 center
replot  2.889e-001+ 2.000*( 9.920e-001* 2.724e-002*cos(t)+-1.261e-001* 8.237e-003*sin(t)),  9.899e-002 +2.000*( 1.261e-001* 2.724e-002*cos(t)+ 9.920e-001* 8.237e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.672e-001, 1.306e-001 center
replot  2.672e-001+ 2.000*( 9.818e-001* 3.270e-002*cos(t)+-1.900e-001* 1.372e-002*sin(t)),  1.306e-001 +2.000*( 1.900e-001* 3.270e-002*cos(t)+ 9.818e-001* 1.372e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  2.450e-001, 1.691e-001 center
replot  2.450e-001+ 2.000*( 9.529e-001* 3.892e-002*cos(t)+-3.034e-001* 2.244e-002*sin(t)),  1.691e-001 +2.000*( 3.034e-001* 3.892e-002*cos(t)+ 9.529e-001* 2.244e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  2.221e-001, 2.092e-001 center
replot  2.221e-001+ 2.000*( 8.360e-001* 4.567e-002*cos(t)+-5.487e-001* 3.431e-002*sin(t)),  2.092e-001 +2.000*( 5.487e-001* 4.567e-002*cos(t)+ 8.360e-001* 3.431e-002*sin(t)) not
set out;
set out "CZFgali/VARPIJGR_CZFgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "CZFgali/VARPIJGR_CZFgali_123-12.svg"
set label "50" at  1.754e-002, 2.285e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  1.754e-002+ 2.000*( 9.984e-001* 7.195e-003*cos(t)+-5.642e-002* 4.449e-003*sin(t)),  2.285e-002 +2.000*( 5.642e-002* 7.195e-003*cos(t)+ 9.984e-001* 4.449e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.502e-002, 3.078e-002 center
replot  2.502e-002+ 2.000*( 9.989e-001* 8.590e-003*cos(t)+-4.741e-002* 4.789e-003*sin(t)),  3.078e-002 +2.000*( 4.741e-002* 8.590e-003*cos(t)+ 9.989e-001* 4.789e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.562e-002, 4.139e-002 center
replot  3.562e-002+ 2.000*( 9.990e-001* 9.943e-003*cos(t)+-4.397e-002* 4.974e-003*sin(t)),  4.139e-002 +2.000*( 4.397e-002* 9.943e-003*cos(t)+ 9.990e-001* 4.974e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  5.056e-002, 5.555e-002 center
replot  5.056e-002+ 2.000*( 9.987e-001* 1.113e-002*cos(t)+-5.114e-002* 5.132e-003*sin(t)),  5.555e-002 +2.000*( 5.114e-002* 1.113e-002*cos(t)+ 9.987e-001* 5.132e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  7.150e-002, 7.434e-002 center
replot  7.150e-002+ 2.000*( 9.963e-001* 1.223e-002*cos(t)+-8.571e-002* 5.925e-003*sin(t)),  7.434e-002 +2.000*( 8.571e-002* 1.223e-002*cos(t)+ 9.963e-001* 5.925e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.006e-001, 9.899e-002 center
replot  1.006e-001+ 2.000*( 9.823e-001* 1.429e-002*cos(t)+-1.875e-001* 8.602e-003*sin(t)),  9.899e-002 +2.000*( 1.875e-001* 1.429e-002*cos(t)+ 9.823e-001* 8.602e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.406e-001, 1.306e-001 center
replot  1.406e-001+ 2.000*( 9.466e-001* 2.021e-002*cos(t)+-3.224e-001* 1.408e-002*sin(t)),  1.306e-001 +2.000*( 3.224e-001* 2.021e-002*cos(t)+ 9.466e-001* 1.408e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.948e-001, 1.691e-001 center
replot  1.948e-001+ 2.000*( 9.436e-001* 3.313e-002*cos(t)+-3.311e-001* 2.313e-002*sin(t)),  1.691e-001 +2.000*( 3.311e-001* 3.313e-002*cos(t)+ 9.436e-001* 2.313e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.667e-001, 2.092e-001 center
replot  2.667e-001+ 2.000*( 9.524e-001* 5.551e-002*cos(t)+-3.049e-001* 3.583e-002*sin(t)),  2.092e-001 +2.000*( 3.049e-001* 5.551e-002*cos(t)+ 9.524e-001* 3.583e-002*sin(t)) not
set out;
set out "CZFgali/VARPIJGR_CZFgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "CZFgali/VARPIJGR_CZFgali_121-13.svg"
set label "50" at  3.966e-001, 2.716e-005 center
# Age 50, p21 - p13
plot [-pi:pi]  3.966e-001+ 2.000*( 1.000e+000* 5.816e-002*cos(t)+-3.736e-005* 4.746e-005*sin(t)),  2.716e-005 +2.000*( 3.736e-005* 5.816e-002*cos(t)+ 1.000e+000* 4.746e-005*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.745e-001, 8.288e-005 center
replot  3.745e-001+ 2.000*( 1.000e+000* 4.452e-002*cos(t)+-9.365e-005* 1.239e-004*sin(t)),  8.288e-005 +2.000*( 9.365e-005* 4.452e-002*cos(t)+ 1.000e+000* 1.239e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.528e-001, 2.525e-004 center
replot  3.528e-001+ 2.000*( 1.000e+000* 3.340e-002*cos(t)+-1.400e-004* 3.142e-004*sin(t)),  2.525e-004 +2.000*( 1.400e-004* 3.340e-002*cos(t)+ 1.000e+000* 3.142e-004*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.315e-001, 7.678e-004 center
replot  3.315e-001+ 2.000*( 1.000e+000* 2.611e-002*cos(t)+ 3.397e-004* 7.644e-004*sin(t)),  7.678e-004 +2.000*(-3.397e-004* 2.611e-002*cos(t)+ 1.000e+000* 7.644e-004*sin(t)) not
# Age 70, p21 - p13
set label "70" at  3.102e-001, 2.328e-003 center
replot  3.102e-001+ 2.000*( 1.000e+000* 2.416e-002*cos(t)+ 2.408e-003* 1.751e-003*sin(t)),  2.328e-003 +2.000*(-2.408e-003* 2.416e-002*cos(t)+ 1.000e+000* 1.751e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.889e-001, 7.022e-003 center
replot  2.889e-001+ 2.000*( 1.000e+000* 2.704e-002*cos(t)+ 3.335e-003* 3.671e-003*sin(t)),  7.022e-003 +2.000*(-3.335e-003* 2.704e-002*cos(t)+ 1.000e+000* 3.671e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.672e-001, 2.100e-002 center
replot  2.672e-001+ 2.000*( 1.000e+000* 3.221e-002*cos(t)+-9.443e-003* 7.062e-003*sin(t)),  2.100e-002 +2.000*( 9.443e-003* 3.221e-002*cos(t)+ 1.000e+000* 7.062e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  2.450e-001, 6.157e-002 center
replot  2.450e-001+ 2.000*( 9.955e-001* 3.784e-002*cos(t)+-9.500e-002* 1.748e-002*sin(t)),  6.157e-002 +2.000*( 9.500e-002* 3.784e-002*cos(t)+ 9.955e-001* 1.748e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  2.221e-001, 1.725e-001 center
replot  2.221e-001+ 2.000*( 1.847e-001* 7.027e-002*cos(t)+-9.828e-001* 4.126e-002*sin(t)),  1.725e-001 +2.000*( 9.828e-001* 7.027e-002*cos(t)+ 1.847e-001* 4.126e-002*sin(t)) not
set out;
set out "CZFgali/VARPIJGR_CZFgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "CZFgali/VARPIJGR_CZFgali_123-13.svg"
set label "50" at  1.754e-002, 2.716e-005 center
# Age 50, p23 - p13
plot [-pi:pi]  1.754e-002+ 2.000*( 1.000e+000* 7.188e-003*cos(t)+ 2.568e-003* 4.378e-005*sin(t)),  2.716e-005 +2.000*(-2.568e-003* 7.188e-003*cos(t)+ 1.000e+000* 4.378e-005*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.502e-002, 8.288e-005 center
replot  2.502e-002+ 2.000*( 1.000e+000* 8.584e-003*cos(t)+ 5.688e-003* 1.140e-004*sin(t)),  8.288e-005 +2.000*(-5.688e-003* 8.584e-003*cos(t)+ 1.000e+000* 1.140e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.562e-002, 2.525e-004 center
replot  3.562e-002+ 2.000*( 9.999e-001* 9.936e-003*cos(t)+ 1.268e-002* 2.879e-004*sin(t)),  2.525e-004 +2.000*(-1.268e-002* 9.936e-003*cos(t)+ 9.999e-001* 2.879e-004*sin(t)) not
# Age 65, p23 - p13
set label "65" at  5.056e-002, 7.678e-004 center
replot  5.056e-002+ 2.000*( 9.996e-001* 1.112e-002*cos(t)+ 2.824e-002* 6.973e-004*sin(t)),  7.678e-004 +2.000*(-2.824e-002* 1.112e-002*cos(t)+ 9.996e-001* 6.973e-004*sin(t)) not
# Age 70, p23 - p13
set label "70" at  7.150e-002, 2.328e-003 center
replot  7.150e-002+ 2.000*( 9.982e-001* 1.221e-002*cos(t)+ 6.075e-002* 1.590e-003*sin(t)),  2.328e-003 +2.000*(-6.075e-002* 1.221e-002*cos(t)+ 9.982e-001* 1.590e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.006e-001, 7.022e-003 center
replot  1.006e-001+ 2.000*( 9.935e-001* 1.421e-002*cos(t)+ 1.138e-001* 3.319e-003*sin(t)),  7.022e-003 +2.000*(-1.138e-001* 1.421e-002*cos(t)+ 9.935e-001* 3.319e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.406e-001, 2.100e-002 center
replot  1.406e-001+ 2.000*( 9.851e-001* 1.993e-002*cos(t)+ 1.721e-001* 6.274e-003*sin(t)),  2.100e-002 +2.000*(-1.721e-001* 1.993e-002*cos(t)+ 9.851e-001* 6.274e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.948e-001, 6.157e-002 center
replot  1.948e-001+ 2.000*( 9.492e-001* 3.354e-002*cos(t)+ 3.147e-001* 1.505e-002*sin(t)),  6.157e-002 +2.000*(-3.147e-001* 3.354e-002*cos(t)+ 9.492e-001* 1.505e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.667e-001, 1.725e-001 center
replot  2.667e-001+ 2.000*( 4.851e-001* 7.535e-002*cos(t)+ 8.745e-001* 4.543e-002*sin(t)),  1.725e-001 +2.000*(-8.745e-001* 7.535e-002*cos(t)+ 4.851e-001* 4.543e-002*sin(t)) not
set out;
set out "CZFgali/VARPIJGR_CZFgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "CZFgali/VARPIJGR_CZFgali_123-21.svg"
set label "50" at  1.754e-002, 3.966e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.754e-002+ 2.000*( 7.725e-003* 5.816e-002*cos(t)+ 1.000e+000* 7.175e-003*sin(t)),  3.966e-001 +2.000*(-1.000e+000* 5.816e-002*cos(t)+ 7.725e-003* 7.175e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.502e-002, 3.745e-001 center
replot  2.502e-002+ 2.000*( 1.074e-002* 4.452e-002*cos(t)+ 9.999e-001* 8.571e-003*sin(t)),  3.745e-001 +2.000*(-9.999e-001* 4.452e-002*cos(t)+ 1.074e-002* 8.571e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.562e-002, 3.528e-001 center
replot  3.562e-002+ 2.000*( 1.504e-002* 3.340e-002*cos(t)+ 9.999e-001* 9.924e-003*sin(t)),  3.528e-001 +2.000*(-9.999e-001* 3.340e-002*cos(t)+ 1.504e-002* 9.924e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  5.056e-002, 3.315e-001 center
replot  5.056e-002+ 2.000*( 2.140e-002* 2.611e-002*cos(t)+ 9.998e-001* 1.110e-002*sin(t)),  3.315e-001 +2.000*(-9.998e-001* 2.611e-002*cos(t)+ 2.140e-002* 1.110e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  7.150e-002, 3.102e-001 center
replot  7.150e-002+ 2.000*( 3.312e-002* 2.417e-002*cos(t)+ 9.995e-001* 1.217e-002*sin(t)),  3.102e-001 +2.000*(-9.995e-001* 2.417e-002*cos(t)+ 3.312e-002* 1.217e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.006e-001, 2.889e-001 center
replot  1.006e-001+ 2.000*( 5.992e-002* 2.707e-002*cos(t)+ 9.982e-001* 1.406e-002*sin(t)),  2.889e-001 +2.000*(-9.982e-001* 2.707e-002*cos(t)+ 5.992e-002* 1.406e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.406e-001, 2.672e-001 center
replot  1.406e-001+ 2.000*( 1.294e-001* 3.238e-002*cos(t)+ 9.916e-001* 1.937e-002*sin(t)),  2.672e-001 +2.000*(-9.916e-001* 3.238e-002*cos(t)+ 1.294e-001* 1.937e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.948e-001, 2.450e-001 center
replot  1.948e-001+ 2.000*( 4.176e-001* 3.905e-002*cos(t)+ 9.086e-001* 3.054e-002*sin(t)),  2.450e-001 +2.000*(-9.086e-001* 3.905e-002*cos(t)+ 4.176e-001* 3.054e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.667e-001, 2.221e-001 center
replot  2.667e-001+ 2.000*( 9.261e-001* 5.598e-002*cos(t)+ 3.774e-001* 3.991e-002*sin(t)),  2.221e-001 +2.000*(-3.774e-001* 5.598e-002*cos(t)+ 9.261e-001* 3.991e-002*sin(t)) not
set out;
set out "CZFgali/VARPIJGR_CZFgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "CZFgali/VARMUPTJGR--STABLBASED_CZFgali1.svg";
 plot "CZFgali/PRMORPREV-1-STABLBASED_CZFgali.txt"  u 1:($3) not w l lt 1 
 replot "CZFgali/PRMORPREV-1-STABLBASED_CZFgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "CZFgali/PRMORPREV-1-STABLBASED_CZFgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "CZFgali/VARMUPTJGR--STABLBASED_CZFgali1.svg";replot;set out;
