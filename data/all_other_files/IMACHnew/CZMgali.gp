
# IMaCh-0.99r45
# CZMgali.gp
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


set ter svg size 640, 480;set out "CZMgali/D_CZMgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "CZMgali/ILK_CZMgali-dest.png";
set log y;plot  "CZMgali/ILK_CZMgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "CZMgali/ILK_CZMgali-ori.png";
set log y;plot  "CZMgali/ILK_CZMgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "CZMgali/ILK_CZMgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "CZMgali/ILK_CZMgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "CZMgali/ILK_CZMgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "CZMgali/ILK_CZMgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "CZMgali/V_CZMgali_1-1-1.svg" 

#set out "V_CZMgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "CZMgali/VPL_CZMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"CZMgali/VPL_CZMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"CZMgali/VPL_CZMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"CZMgali/P_CZMgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "CZMgali/V_CZMgali_2-1-1.svg" 

#set out "V_CZMgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "CZMgali/VPL_CZMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"CZMgali/VPL_CZMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"CZMgali/VPL_CZMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"CZMgali/P_CZMgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "CZMgali/E_CZMgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "CZMgali/T_CZMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"CZMgali/T_CZMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"CZMgali/T_CZMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"CZMgali/T_CZMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"CZMgali/T_CZMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"CZMgali/T_CZMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"CZMgali/T_CZMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"CZMgali/T_CZMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"CZMgali/T_CZMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "CZMgali/E_CZMgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "CZMgali/EXP_CZMgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "CZMgali/E_CZMgali.txt" every :::0::0 u 1:2 t "e11" w l ,"CZMgali/E_CZMgali.txt" every :::0::0 u 1:3 t "e12" w l ,"CZMgali/E_CZMgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "CZMgali/EXP_CZMgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "CZMgali/E_CZMgali.txt" every :::0::0 u 1:5 t "e21" w l ,"CZMgali/E_CZMgali.txt" every :::0::0 u 1:6 t "e22" w l ,"CZMgali/E_CZMgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "CZMgali/LIJ_CZMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMgali/PIJ_CZMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "CZMgali/LIJ_CZMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMgali/PIJ_CZMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "CZMgali/LIJT_CZMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMgali/PIJ_CZMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "CZMgali/LIJT_CZMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMgali/PIJ_CZMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "CZMgali/P_CZMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMgali/PIJ_CZMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "CZMgali/P_CZMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMgali/PIJ_CZMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-6.183523; p2=0.039458; 
#   current state 3
p3=-13.082262; p4=0.120736; 
# initial state 2
#   current state 1
p5=-0.318442; p6=-0.022105; 
#   current state 3
p7=-5.211766; p8=0.034193; 
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

set out "CZMgali/PE_CZMgali_1-1-1.svg" 
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

set out "CZMgali/PE_CZMgali_1-2-1.svg" 
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

set out "CZMgali/PE_CZMgali_1-3-1.svg" 
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
set out "CZMgali/VARPIJGR_CZMgali_113-12.svg"
set label "50" at  1.716e-003, 2.922e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  1.716e-003+ 2.000*( 1.271e-002* 6.741e-003*cos(t)+ 9.999e-001* 8.507e-004*sin(t)),  2.922e-002 +2.000*(-9.999e-001* 6.741e-003*cos(t)+ 1.271e-002* 8.507e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  3.126e-003, 3.545e-002 center
replot  3.126e-003+ 2.000*( 2.246e-002* 6.429e-003*cos(t)+ 9.997e-001* 1.284e-003*sin(t)),  3.545e-002 +2.000*(-9.997e-001* 6.429e-003*cos(t)+ 2.246e-002* 1.284e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  5.687e-003, 4.296e-002 center
replot  5.687e-003+ 2.000*( 4.284e-002* 5.943e-003*cos(t)+ 9.991e-001* 1.870e-003*sin(t)),  4.296e-002 +2.000*(-9.991e-001* 5.943e-003*cos(t)+ 4.284e-002* 1.870e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.033e-002, 5.196e-002 center
replot  1.033e-002+ 2.000*( 8.455e-002* 5.669e-003*cos(t)+ 9.964e-001* 2.616e-003*sin(t)),  5.196e-002 +2.000*(-9.964e-001* 5.669e-003*cos(t)+ 8.455e-002* 2.616e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.870e-002, 6.267e-002 center
replot  1.870e-002+ 2.000*( 1.282e-001* 6.588e-003*cos(t)+ 9.917e-001* 3.602e-003*sin(t)),  6.267e-002 +2.000*(-9.917e-001* 6.588e-003*cos(t)+ 1.282e-001* 3.602e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  3.371e-002, 7.524e-002 center
replot  3.371e-002+ 2.000*( 1.523e-001* 9.647e-003*cos(t)+ 9.883e-001* 5.485e-003*sin(t)),  7.524e-002 +2.000*(-9.883e-001* 9.647e-003*cos(t)+ 1.523e-001* 5.485e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  6.031e-002, 8.967e-002 center
replot  6.031e-002+ 2.000*( 2.718e-001* 1.514e-002*cos(t)+ 9.624e-001* 1.054e-002*sin(t)),  8.967e-002 +2.000*(-9.624e-001* 1.514e-002*cos(t)+ 2.718e-001* 1.054e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  1.066e-001, 1.056e-001 center
replot  1.066e-001+ 2.000*( 8.326e-001* 2.586e-002*cos(t)+ 5.539e-001* 2.048e-002*sin(t)),  1.056e-001 +2.000*(-5.539e-001* 2.586e-002*cos(t)+ 8.326e-001* 2.048e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.847e-001, 1.218e-001 center
replot  1.847e-001+ 2.000*( 9.739e-001* 5.350e-002*cos(t)+ 2.268e-001* 3.011e-002*sin(t)),  1.218e-001 +2.000*(-2.268e-001* 5.350e-002*cos(t)+ 9.739e-001* 3.011e-002*sin(t)) not
set out;
set out "CZMgali/VARPIJGR_CZMgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "CZMgali/VARPIJGR_CZMgali_121-12.svg"
set label "50" at  3.790e-001, 2.922e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  3.790e-001+ 2.000*( 9.997e-001* 7.339e-002*cos(t)+-2.464e-002* 6.495e-003*sin(t)),  2.922e-002 +2.000*( 2.464e-002* 7.339e-002*cos(t)+ 9.997e-001* 6.495e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.446e-001, 3.545e-002 center
replot  3.446e-001+ 2.000*( 9.995e-001* 5.303e-002*cos(t)+-3.276e-002* 6.191e-003*sin(t)),  3.545e-002 +2.000*( 3.276e-002* 5.303e-002*cos(t)+ 9.995e-001* 6.191e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.125e-001, 4.296e-002 center
replot  3.125e-001+ 2.000*( 9.991e-001* 3.729e-002*cos(t)+-4.340e-002* 5.718e-003*sin(t)),  4.296e-002 +2.000*( 4.340e-002* 3.729e-002*cos(t)+ 9.991e-001* 5.718e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.826e-001, 5.196e-002 center
replot  2.826e-001+ 2.000*( 9.985e-001* 2.809e-002*cos(t)+-5.448e-002* 5.450e-003*sin(t)),  5.196e-002 +2.000*( 5.448e-002* 2.809e-002*cos(t)+ 9.985e-001* 5.450e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.549e-001, 6.267e-002 center
replot  2.549e-001+ 2.000*( 9.980e-001* 2.705e-002*cos(t)+-6.399e-002* 6.330e-003*sin(t)),  6.267e-002 +2.000*( 6.399e-002* 2.705e-002*cos(t)+ 9.980e-001* 6.330e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.292e-001, 7.524e-002 center
replot  2.292e-001+ 2.000*( 9.968e-001* 3.160e-002*cos(t)+-8.039e-002* 9.258e-003*sin(t)),  7.524e-002 +2.000*( 8.039e-002* 3.160e-002*cos(t)+ 9.968e-001* 9.258e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.054e-001, 8.967e-002 center
replot  2.054e-001+ 2.000*( 9.940e-001* 3.776e-002*cos(t)+-1.091e-001* 1.435e-002*sin(t)),  8.967e-002 +2.000*( 1.091e-001* 3.776e-002*cos(t)+ 9.940e-001* 1.435e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.835e-001, 1.056e-001 center
replot  1.835e-001+ 2.000*( 9.878e-001* 4.359e-002*cos(t)+-1.558e-001* 2.147e-002*sin(t)),  1.056e-001 +2.000*( 1.558e-001* 4.359e-002*cos(t)+ 9.878e-001* 2.147e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.634e-001, 1.218e-001 center
replot  1.634e-001+ 2.000*( 9.712e-001* 4.853e-002*cos(t)+-2.383e-001* 3.043e-002*sin(t)),  1.218e-001 +2.000*( 2.383e-001* 4.853e-002*cos(t)+ 9.712e-001* 3.043e-002*sin(t)) not
set out;
set out "CZMgali/VARPIJGR_CZMgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "CZMgali/VARPIJGR_CZMgali_123-12.svg"
set label "50" at  4.742e-002, 2.922e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  4.742e-002+ 2.000*( 9.995e-001* 1.806e-002*cos(t)+-3.044e-002* 6.721e-003*sin(t)),  2.922e-002 +2.000*( 3.044e-002* 1.806e-002*cos(t)+ 9.995e-001* 6.721e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  5.714e-002, 3.545e-002 center
replot  5.714e-002+ 2.000*( 9.995e-001* 1.764e-002*cos(t)+-3.011e-002* 6.408e-003*sin(t)),  3.545e-002 +2.000*( 3.011e-002* 1.764e-002*cos(t)+ 9.995e-001* 6.408e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  6.866e-002, 4.296e-002 center
replot  6.866e-002+ 2.000*( 9.995e-001* 1.672e-002*cos(t)+-3.136e-002* 5.918e-003*sin(t)),  4.296e-002 +2.000*( 3.136e-002* 1.672e-002*cos(t)+ 9.995e-001* 5.918e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  8.229e-002, 5.196e-002 center
replot  8.229e-002+ 2.000*( 9.992e-001* 1.572e-002*cos(t)+-3.978e-002* 5.623e-003*sin(t)),  5.196e-002 +2.000*( 3.978e-002* 1.572e-002*cos(t)+ 9.992e-001* 5.623e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  9.833e-002, 6.267e-002 center
replot  9.833e-002+ 2.000*( 9.978e-001* 1.600e-002*cos(t)+-6.621e-002* 6.477e-003*sin(t)),  6.267e-002 +2.000*( 6.621e-002* 1.600e-002*cos(t)+ 9.978e-001* 6.477e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.171e-001, 7.524e-002 center
replot  1.171e-001+ 2.000*( 9.947e-001* 1.985e-002*cos(t)+-1.027e-001* 9.401e-003*sin(t)),  7.524e-002 +2.000*( 1.027e-001* 1.985e-002*cos(t)+ 9.947e-001* 9.401e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.391e-001, 8.967e-002 center
replot  1.391e-001+ 2.000*( 9.927e-001* 2.864e-002*cos(t)+-1.208e-001* 1.454e-002*sin(t)),  8.967e-002 +2.000*( 1.208e-001* 2.864e-002*cos(t)+ 9.927e-001* 1.454e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.647e-001, 1.056e-001 center
replot  1.647e-001+ 2.000*( 9.922e-001* 4.246e-002*cos(t)+-1.247e-001* 2.180e-002*sin(t)),  1.056e-001 +2.000*( 1.247e-001* 4.246e-002*cos(t)+ 9.922e-001* 2.180e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.943e-001, 1.218e-001 center
replot  1.943e-001+ 2.000*( 9.920e-001* 6.136e-002*cos(t)+-1.264e-001* 3.103e-002*sin(t)),  1.218e-001 +2.000*( 1.264e-001* 6.136e-002*cos(t)+ 9.920e-001* 3.103e-002*sin(t)) not
set out;
set out "CZMgali/VARPIJGR_CZMgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "CZMgali/VARPIJGR_CZMgali_121-13.svg"
set label "50" at  3.790e-001, 1.716e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  3.790e-001+ 2.000*( 1.000e+000* 7.337e-002*cos(t)+-6.751e-004* 8.535e-004*sin(t)),  1.716e-003 +2.000*( 6.751e-004* 7.337e-002*cos(t)+ 1.000e+000* 8.535e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.446e-001, 3.126e-003 center
replot  3.446e-001+ 2.000*( 1.000e+000* 5.300e-002*cos(t)+-1.321e-003* 1.290e-003*sin(t)),  3.126e-003 +2.000*( 1.321e-003* 5.300e-002*cos(t)+ 1.000e+000* 1.290e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.125e-001, 5.687e-003 center
replot  3.125e-001+ 2.000*( 1.000e+000* 3.726e-002*cos(t)+-2.553e-003* 1.883e-003*sin(t)),  5.687e-003 +2.000*( 2.553e-003* 3.726e-002*cos(t)+ 1.000e+000* 1.883e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.826e-001, 1.033e-002 center
replot  2.826e-001+ 2.000*( 1.000e+000* 2.805e-002*cos(t)+-4.838e-003* 2.647e-003*sin(t)),  1.033e-002 +2.000*( 4.838e-003* 2.805e-002*cos(t)+ 1.000e+000* 2.647e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.549e-001, 1.870e-002 center
replot  2.549e-001+ 2.000*( 1.000e+000* 2.700e-002*cos(t)+-9.508e-003* 3.662e-003*sin(t)),  1.870e-002 +2.000*( 9.508e-003* 2.700e-002*cos(t)+ 1.000e+000* 3.662e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.292e-001, 3.371e-002 center
replot  2.292e-001+ 2.000*( 9.998e-001* 3.152e-002*cos(t)+-1.975e-002* 5.583e-003*sin(t)),  3.371e-002 +2.000*( 1.975e-002* 3.152e-002*cos(t)+ 9.998e-001* 5.583e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.054e-001, 6.031e-002 center
replot  2.054e-001+ 2.000*( 9.991e-001* 3.760e-002*cos(t)+-4.245e-002* 1.084e-002*sin(t)),  6.031e-002 +2.000*( 4.245e-002* 3.760e-002*cos(t)+ 9.991e-001* 1.084e-002*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.835e-001, 1.066e-001 center
replot  1.835e-001+ 2.000*( 9.938e-001* 4.337e-002*cos(t)+-1.111e-001* 2.400e-002*sin(t)),  1.066e-001 +2.000*( 1.111e-001* 4.337e-002*cos(t)+ 9.938e-001* 2.400e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.634e-001, 1.847e-001 center
replot  1.634e-001+ 2.000*( 4.534e-001* 5.415e-002*cos(t)+-8.913e-001* 4.586e-002*sin(t)),  1.847e-001 +2.000*( 8.913e-001* 5.415e-002*cos(t)+ 4.534e-001* 4.586e-002*sin(t)) not
set out;
set out "CZMgali/VARPIJGR_CZMgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "CZMgali/VARPIJGR_CZMgali_123-13.svg"
set label "50" at  4.742e-002, 1.716e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  4.742e-002+ 2.000*( 9.999e-001* 1.805e-002*cos(t)+ 1.195e-002* 8.273e-004*sin(t)),  1.716e-003 +2.000*(-1.195e-002* 1.805e-002*cos(t)+ 9.999e-001* 8.273e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  5.714e-002, 3.126e-003 center
replot  5.714e-002+ 2.000*( 9.998e-001* 1.764e-002*cos(t)+ 1.872e-002* 1.249e-003*sin(t)),  3.126e-003 +2.000*(-1.872e-002* 1.764e-002*cos(t)+ 9.998e-001* 1.249e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  6.866e-002, 5.687e-003 center
replot  6.866e-002+ 2.000*( 9.996e-001* 1.672e-002*cos(t)+ 2.965e-002* 1.820e-003*sin(t)),  5.687e-003 +2.000*(-2.965e-002* 1.672e-002*cos(t)+ 9.996e-001* 1.820e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  8.229e-002, 1.033e-002 center
replot  8.229e-002+ 2.000*( 9.989e-001* 1.572e-002*cos(t)+ 4.688e-002* 2.548e-003*sin(t)),  1.033e-002 +2.000*(-4.688e-002* 1.572e-002*cos(t)+ 9.989e-001* 2.548e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  9.833e-002, 1.870e-002 center
replot  9.833e-002+ 2.000*( 9.975e-001* 1.601e-002*cos(t)+ 7.000e-002* 3.504e-003*sin(t)),  1.870e-002 +2.000*(-7.000e-002* 1.601e-002*cos(t)+ 9.975e-001* 3.504e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.171e-001, 3.371e-002 center
replot  1.171e-001+ 2.000*( 9.954e-001* 1.986e-002*cos(t)+ 9.582e-002* 5.309e-003*sin(t)),  3.371e-002 +2.000*(-9.582e-002* 1.986e-002*cos(t)+ 9.954e-001* 5.309e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.391e-001, 6.031e-002 center
replot  1.391e-001+ 2.000*( 9.903e-001* 2.873e-002*cos(t)+ 1.386e-001* 1.029e-002*sin(t)),  6.031e-002 +2.000*(-1.386e-001* 2.873e-002*cos(t)+ 9.903e-001* 1.029e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.647e-001, 1.066e-001 center
replot  1.647e-001+ 2.000*( 9.713e-001* 4.310e-002*cos(t)+ 2.379e-001* 2.272e-002*sin(t)),  1.066e-001 +2.000*(-2.379e-001* 4.310e-002*cos(t)+ 9.713e-001* 2.272e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.943e-001, 1.847e-001 center
replot  1.943e-001+ 2.000*( 8.545e-001* 6.543e-002*cos(t)+ 5.195e-001* 4.691e-002*sin(t)),  1.847e-001 +2.000*(-5.195e-001* 6.543e-002*cos(t)+ 8.545e-001* 4.691e-002*sin(t)) not
set out;
set out "CZMgali/VARPIJGR_CZMgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "CZMgali/VARPIJGR_CZMgali_123-21.svg"
set label "50" at  4.742e-002, 3.790e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  4.742e-002+ 2.000*( 2.892e-002* 7.340e-002*cos(t)+ 9.996e-001* 1.794e-002*sin(t)),  3.790e-001 +2.000*(-9.996e-001* 7.340e-002*cos(t)+ 2.892e-002* 1.794e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  5.714e-002, 3.446e-001 center
replot  5.714e-002+ 2.000*( 3.648e-002* 5.303e-002*cos(t)+ 9.993e-001* 1.754e-002*sin(t)),  3.446e-001 +2.000*(-9.993e-001* 5.303e-002*cos(t)+ 3.648e-002* 1.754e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  6.866e-002, 3.125e-001 center
replot  6.866e-002+ 2.000*( 4.993e-002* 3.729e-002*cos(t)+ 9.988e-001* 1.663e-002*sin(t)),  3.125e-001 +2.000*(-9.988e-001* 3.729e-002*cos(t)+ 4.993e-002* 1.663e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  8.229e-002, 2.826e-001 center
replot  8.229e-002+ 2.000*( 7.923e-002* 2.811e-002*cos(t)+ 9.969e-001* 1.560e-002*sin(t)),  2.826e-001 +2.000*(-9.969e-001* 2.811e-002*cos(t)+ 7.923e-002* 1.560e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  9.833e-002, 2.549e-001 center
replot  9.833e-002+ 2.000*( 1.224e-001* 2.713e-002*cos(t)+ 9.925e-001* 1.574e-002*sin(t)),  2.549e-001 +2.000*(-9.925e-001* 2.713e-002*cos(t)+ 1.224e-001* 1.574e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.171e-001, 2.292e-001 center
replot  1.171e-001+ 2.000*( 1.757e-001* 3.182e-002*cos(t)+ 9.845e-001* 1.926e-002*sin(t)),  2.292e-001 +2.000*(-9.845e-001* 3.182e-002*cos(t)+ 1.757e-001* 1.926e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.391e-001, 2.054e-001 center
replot  1.391e-001+ 2.000*( 2.984e-001* 3.843e-002*cos(t)+ 9.545e-001* 2.732e-002*sin(t)),  2.054e-001 +2.000*(-9.545e-001* 3.843e-002*cos(t)+ 2.984e-001* 2.732e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.647e-001, 1.835e-001 center
replot  1.647e-001+ 2.000*( 6.658e-001* 4.680e-002*cos(t)+ 7.461e-001* 3.817e-002*sin(t)),  1.835e-001 +2.000*(-7.461e-001* 4.680e-002*cos(t)+ 6.658e-001* 3.817e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.943e-001, 1.634e-001 center
replot  1.943e-001+ 2.000*( 9.411e-001* 6.273e-002*cos(t)+ 3.382e-001* 4.538e-002*sin(t)),  1.634e-001 +2.000*(-3.382e-001* 6.273e-002*cos(t)+ 9.411e-001* 4.538e-002*sin(t)) not
set out;
set out "CZMgali/VARPIJGR_CZMgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "CZMgali/VARMUPTJGR--STABLBASED_CZMgali1.svg";
 plot "CZMgali/PRMORPREV-1-STABLBASED_CZMgali.txt"  u 1:($3) not w l lt 1 
 replot "CZMgali/PRMORPREV-1-STABLBASED_CZMgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "CZMgali/PRMORPREV-1-STABLBASED_CZMgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "CZMgali/VARMUPTJGR--STABLBASED_CZMgali1.svg";replot;set out;
