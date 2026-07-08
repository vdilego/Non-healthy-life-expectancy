
# IMaCh-0.99r45
# DKMgali.gp
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


set ter svg size 640, 480;set out "DKMgali/D_DKMgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "DKMgali/ILK_DKMgali-dest.png";
set log y;plot  "DKMgali/ILK_DKMgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "DKMgali/ILK_DKMgali-ori.png";
set log y;plot  "DKMgali/ILK_DKMgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "DKMgali/ILK_DKMgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "DKMgali/ILK_DKMgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "DKMgali/ILK_DKMgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "DKMgali/ILK_DKMgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "DKMgali/V_DKMgali_1-1-1.svg" 

#set out "V_DKMgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "DKMgali/VPL_DKMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"DKMgali/VPL_DKMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"DKMgali/VPL_DKMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"DKMgali/P_DKMgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "DKMgali/V_DKMgali_2-1-1.svg" 

#set out "V_DKMgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "DKMgali/VPL_DKMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"DKMgali/VPL_DKMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"DKMgali/VPL_DKMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"DKMgali/P_DKMgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "DKMgali/E_DKMgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "DKMgali/T_DKMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"DKMgali/T_DKMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"DKMgali/T_DKMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"DKMgali/T_DKMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"DKMgali/T_DKMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"DKMgali/T_DKMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"DKMgali/T_DKMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"DKMgali/T_DKMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"DKMgali/T_DKMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "DKMgali/E_DKMgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "DKMgali/EXP_DKMgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "DKMgali/E_DKMgali.txt" every :::0::0 u 1:2 t "e11" w l ,"DKMgali/E_DKMgali.txt" every :::0::0 u 1:3 t "e12" w l ,"DKMgali/E_DKMgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "DKMgali/EXP_DKMgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "DKMgali/E_DKMgali.txt" every :::0::0 u 1:5 t "e21" w l ,"DKMgali/E_DKMgali.txt" every :::0::0 u 1:6 t "e22" w l ,"DKMgali/E_DKMgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "DKMgali/LIJ_DKMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKMgali/PIJ_DKMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "DKMgali/LIJ_DKMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKMgali/PIJ_DKMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "DKMgali/LIJT_DKMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKMgali/PIJ_DKMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "DKMgali/LIJT_DKMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKMgali/PIJ_DKMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "DKMgali/P_DKMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKMgali/PIJ_DKMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "DKMgali/P_DKMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "DKMgali/PIJ_DKMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-7.121780; p2=0.048195; 
#   current state 3
p3=-18.808669; p4=0.187118; 
# initial state 2
#   current state 1
p5=-1.048299; p6=-0.015756; 
#   current state 3
p7=-7.389191; p8=0.071495; 
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

set out "DKMgali/PE_DKMgali_1-1-1.svg" 
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

set out "DKMgali/PE_DKMgali_1-2-1.svg" 
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

set out "DKMgali/PE_DKMgali_1-3-1.svg" 
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
set out "DKMgali/VARPIJGR_DKMgali_113-12.svg"
set label "50" at  1.555e-004, 1.781e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  1.555e-004+ 2.000*( 2.002e-003* 4.795e-003*cos(t)+ 1.000e+000* 1.375e-004*sin(t)),  1.781e-002 +2.000*(-1.000e+000* 4.795e-003*cos(t)+ 2.002e-003* 1.375e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  3.954e-004, 2.261e-002 center
replot  3.954e-004+ 2.000*( 4.935e-003* 4.776e-003*cos(t)+ 1.000e+000* 2.982e-004*sin(t)),  2.261e-002 +2.000*(-1.000e+000* 4.776e-003*cos(t)+ 4.935e-003* 2.982e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.004e-003, 2.867e-002 center
replot  1.004e-003+ 2.000*( 1.369e-002* 4.607e-003*cos(t)+ 9.999e-001* 6.285e-004*sin(t)),  2.867e-002 +2.000*(-9.999e-001* 4.607e-003*cos(t)+ 1.369e-002* 6.285e-004*sin(t)) not
# Age 65, p13 - p12
set label "65" at  2.548e-003, 3.631e-002 center
replot  2.548e-003+ 2.000*( 4.157e-002* 4.589e-003*cos(t)+ 9.991e-001* 1.273e-003*sin(t)),  3.631e-002 +2.000*(-9.991e-001* 4.589e-003*cos(t)+ 4.157e-002* 1.273e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  6.450e-003, 4.589e-002 center
replot  6.450e-003+ 2.000*( 1.053e-001* 5.623e-003*cos(t)+ 9.944e-001* 2.447e-003*sin(t)),  4.589e-002 +2.000*(-9.944e-001* 5.623e-003*cos(t)+ 1.053e-001* 2.447e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.626e-002, 5.775e-002 center
replot  1.626e-002+ 2.000*( 1.855e-001* 8.755e-003*cos(t)+ 9.826e-001* 4.472e-003*sin(t)),  5.775e-002 +2.000*(-9.826e-001* 8.755e-003*cos(t)+ 1.855e-001* 4.472e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  4.060e-002, 7.201e-002 center
replot  4.060e-002+ 2.000*( 3.185e-001* 1.460e-002*cos(t)+ 9.479e-001* 8.395e-003*sin(t)),  7.201e-002 +2.000*(-9.479e-001* 1.460e-002*cos(t)+ 3.185e-001* 8.395e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  9.938e-002, 8.800e-002 center
replot  9.938e-002+ 2.000*( 7.483e-001* 2.641e-002*cos(t)+ 6.633e-001* 1.793e-002*sin(t)),  8.800e-002 +2.000*(-6.633e-001* 2.641e-002*cos(t)+ 7.483e-001* 1.793e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  2.326e-001, 1.028e-001 center
replot  2.326e-001+ 2.000*( 9.729e-001* 6.729e-002*cos(t)+ 2.314e-001* 2.901e-002*sin(t)),  1.028e-001 +2.000*(-2.314e-001* 6.729e-002*cos(t)+ 9.729e-001* 2.901e-002*sin(t)) not
set out;
set out "DKMgali/VARPIJGR_DKMgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "DKMgali/VARPIJGR_DKMgali_121-12.svg"
set label "50" at  2.699e-001, 1.781e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  2.699e-001+ 2.000*( 9.999e-001* 7.948e-002*cos(t)+-1.212e-002* 4.698e-003*sin(t)),  1.781e-002 +2.000*( 1.212e-002* 7.948e-002*cos(t)+ 9.999e-001* 4.698e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  2.500e-001, 2.261e-002 center
replot  2.500e-001+ 2.000*( 9.999e-001* 5.941e-002*cos(t)+-1.671e-002* 4.672e-003*sin(t)),  2.261e-002 +2.000*( 1.671e-002* 5.941e-002*cos(t)+ 9.999e-001* 4.672e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.306e-001, 2.867e-002 center
replot  2.306e-001+ 2.000*( 9.997e-001* 4.397e-002*cos(t)+-2.295e-002* 4.496e-003*sin(t)),  2.867e-002 +2.000*( 2.295e-002* 4.397e-002*cos(t)+ 9.997e-001* 4.496e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.115e-001, 3.631e-002 center
replot  2.115e-001+ 2.000*( 9.995e-001* 3.483e-002*cos(t)+-3.027e-002* 4.465e-003*sin(t)),  3.631e-002 +2.000*( 3.027e-002* 3.483e-002*cos(t)+ 9.995e-001* 4.465e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  1.925e-001, 4.589e-002 center
replot  1.925e-001+ 2.000*( 9.993e-001* 3.304e-002*cos(t)+-3.761e-002* 5.461e-003*sin(t)),  4.589e-002 +2.000*( 3.761e-002* 3.304e-002*cos(t)+ 9.993e-001* 5.461e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.735e-001, 5.775e-002 center
replot  1.735e-001+ 2.000*( 9.989e-001* 3.643e-002*cos(t)+-4.782e-002* 8.476e-003*sin(t)),  5.775e-002 +2.000*( 4.782e-002* 3.643e-002*cos(t)+ 9.989e-001* 8.476e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.544e-001, 7.201e-002 center
replot  1.544e-001+ 2.000*( 9.979e-001* 4.138e-002*cos(t)+-6.499e-002* 1.387e-002*sin(t)),  7.201e-002 +2.000*( 6.499e-002* 4.138e-002*cos(t)+ 9.979e-001* 1.387e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.350e-001, 8.800e-002 center
replot  1.350e-001+ 2.000*( 9.956e-001* 4.559e-002*cos(t)+-9.420e-002* 2.174e-002*sin(t)),  8.800e-002 +2.000*( 9.420e-002* 4.559e-002*cos(t)+ 9.956e-001* 2.174e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.155e-001, 1.028e-001 center
replot  1.155e-001+ 2.000*( 9.885e-001* 4.808e-002*cos(t)+-1.511e-001* 3.177e-002*sin(t)),  1.028e-001 +2.000*( 1.511e-001* 4.808e-002*cos(t)+ 9.885e-001* 3.177e-002*sin(t)) not
set out;
set out "DKMgali/VARPIJGR_DKMgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "DKMgali/VARPIJGR_DKMgali_123-12.svg"
set label "50" at  3.733e-002, 1.781e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  3.733e-002+ 2.000*( 9.999e-001* 1.703e-002*cos(t)+-1.412e-002* 4.790e-003*sin(t)),  1.781e-002 +2.000*( 1.412e-002* 1.703e-002*cos(t)+ 9.999e-001* 4.790e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  5.348e-002, 2.261e-002 center
replot  5.348e-002+ 2.000*( 1.000e+000* 2.022e-002*cos(t)+-9.664e-003* 4.772e-003*sin(t)),  2.261e-002 +2.000*( 9.664e-003* 2.022e-002*cos(t)+ 1.000e+000* 4.772e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  7.631e-002, 2.867e-002 center
replot  7.631e-002+ 2.000*( 1.000e+000* 2.318e-002*cos(t)+-7.208e-003* 4.604e-003*sin(t)),  2.867e-002 +2.000*( 7.208e-003* 2.318e-002*cos(t)+ 1.000e+000* 4.604e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.083e-001, 3.631e-002 center
replot  1.083e-001+ 2.000*( 1.000e+000* 2.563e-002*cos(t)+-9.510e-003* 4.579e-003*sin(t)),  3.631e-002 +2.000*( 9.510e-003* 2.563e-002*cos(t)+ 1.000e+000* 4.579e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  1.525e-001, 4.589e-002 center
replot  1.525e-001+ 2.000*( 9.997e-001* 2.804e-002*cos(t)+-2.389e-002* 5.559e-003*sin(t)),  4.589e-002 +2.000*( 2.389e-002* 2.804e-002*cos(t)+ 9.997e-001* 5.559e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  2.126e-001, 5.775e-002 center
replot  2.126e-001+ 2.000*( 9.984e-001* 3.331e-002*cos(t)+-5.615e-002* 8.452e-003*sin(t)),  5.775e-002 +2.000*( 5.615e-002* 3.331e-002*cos(t)+ 9.984e-001* 8.452e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  2.925e-001, 7.201e-002 center
replot  2.925e-001+ 2.000*( 9.967e-001* 4.733e-002*cos(t)+-8.119e-002* 1.361e-002*sin(t)),  7.201e-002 +2.000*( 8.119e-002* 4.733e-002*cos(t)+ 9.967e-001* 1.361e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  3.956e-001, 8.800e-002 center
replot  3.956e-001+ 2.000*( 9.966e-001* 7.451e-002*cos(t)+-8.186e-002* 2.128e-002*sin(t)),  8.800e-002 +2.000*( 8.186e-002* 7.451e-002*cos(t)+ 9.966e-001* 2.128e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  5.238e-001, 1.028e-001 center
replot  5.238e-001+ 2.000*( 9.971e-001* 1.149e-001*cos(t)+-7.563e-002* 3.113e-002*sin(t)),  1.028e-001 +2.000*( 7.563e-002* 1.149e-001*cos(t)+ 9.971e-001* 3.113e-002*sin(t)) not
set out;
set out "DKMgali/VARPIJGR_DKMgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "DKMgali/VARPIJGR_DKMgali_121-13.svg"
set label "50" at  2.699e-001, 1.555e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  2.699e-001+ 2.000*( 1.000e+000* 7.947e-002*cos(t)+-2.950e-005* 1.378e-004*sin(t)),  1.555e-004 +2.000*( 2.950e-005* 7.947e-002*cos(t)+ 1.000e+000* 1.378e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  2.500e-001, 3.954e-004 center
replot  2.500e-001+ 2.000*( 1.000e+000* 5.940e-002*cos(t)+-7.874e-005* 2.991e-004*sin(t)),  3.954e-004 +2.000*( 7.874e-005* 5.940e-002*cos(t)+ 1.000e+000* 2.991e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.306e-001, 1.004e-003 center
replot  2.306e-001+ 2.000*( 1.000e+000* 4.396e-002*cos(t)+-2.070e-004* 6.315e-004*sin(t)),  1.004e-003 +2.000*( 2.070e-004* 4.396e-002*cos(t)+ 1.000e+000* 6.315e-004*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.115e-001, 2.548e-003 center
replot  2.115e-001+ 2.000*( 1.000e+000* 3.481e-002*cos(t)+-5.343e-004* 1.286e-003*sin(t)),  2.548e-003 +2.000*( 5.343e-004* 3.481e-002*cos(t)+ 1.000e+000* 1.286e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  1.925e-001, 6.450e-003 center
replot  1.925e-001+ 2.000*( 1.000e+000* 3.302e-002*cos(t)+-1.460e-003* 2.504e-003*sin(t)),  6.450e-003 +2.000*( 1.460e-003* 3.302e-002*cos(t)+ 1.000e+000* 2.504e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.735e-001, 1.626e-002 center
replot  1.735e-001+ 2.000*( 1.000e+000* 3.640e-002*cos(t)+-4.457e-003* 4.683e-003*sin(t)),  1.626e-002 +2.000*( 4.457e-003* 3.640e-002*cos(t)+ 1.000e+000* 4.683e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.544e-001, 4.060e-002 center
replot  1.544e-001+ 2.000*( 9.999e-001* 4.130e-002*cos(t)+-1.449e-002* 9.199e-003*sin(t)),  4.060e-002 +2.000*( 1.449e-002* 4.130e-002*cos(t)+ 9.999e-001* 9.199e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.350e-001, 9.938e-002 center
replot  1.350e-001+ 2.000*( 9.983e-001* 4.549e-002*cos(t)+-5.762e-002* 2.295e-002*sin(t)),  9.938e-002 +2.000*( 5.762e-002* 4.549e-002*cos(t)+ 9.983e-001* 2.295e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.155e-001, 2.326e-001 center
replot  1.155e-001+ 2.000*( 1.368e-001* 6.611e-002*cos(t)+-9.906e-001* 4.735e-002*sin(t)),  2.326e-001 +2.000*( 9.906e-001* 6.611e-002*cos(t)+ 1.368e-001* 4.735e-002*sin(t)) not
set out;
set out "DKMgali/VARPIJGR_DKMgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "DKMgali/VARPIJGR_DKMgali_123-13.svg"
set label "50" at  3.733e-002, 1.555e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  3.733e-002+ 2.000*( 1.000e+000* 1.703e-002*cos(t)+ 1.472e-003* 1.355e-004*sin(t)),  1.555e-004 +2.000*(-1.472e-003* 1.703e-002*cos(t)+ 1.000e+000* 1.355e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  5.348e-002, 3.954e-004 center
replot  5.348e-002+ 2.000*( 1.000e+000* 2.022e-002*cos(t)+ 2.773e-003* 2.938e-004*sin(t)),  3.954e-004 +2.000*(-2.773e-003* 2.022e-002*cos(t)+ 1.000e+000* 2.938e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  7.631e-002, 1.004e-003 center
replot  7.631e-002+ 2.000*( 1.000e+000* 2.317e-002*cos(t)+ 5.363e-003* 6.192e-004*sin(t)),  1.004e-003 +2.000*(-5.363e-003* 2.317e-002*cos(t)+ 1.000e+000* 6.192e-004*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.083e-001, 2.548e-003 center
replot  1.083e-001+ 2.000*( 9.999e-001* 2.563e-002*cos(t)+ 1.070e-002* 1.257e-003*sin(t)),  2.548e-003 +2.000*(-1.070e-002* 2.563e-002*cos(t)+ 9.999e-001* 1.257e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  1.525e-001, 6.450e-003 center
replot  1.525e-001+ 2.000*( 9.998e-001* 2.804e-002*cos(t)+ 2.157e-002* 2.431e-003*sin(t)),  6.450e-003 +2.000*(-2.157e-002* 2.804e-002*cos(t)+ 9.998e-001* 2.431e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  2.126e-001, 1.626e-002 center
replot  2.126e-001+ 2.000*( 9.992e-001* 3.329e-002*cos(t)+ 3.981e-002* 4.498e-003*sin(t)),  1.626e-002 +2.000*(-3.981e-002* 3.329e-002*cos(t)+ 9.992e-001* 4.498e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  2.925e-001, 4.060e-002 center
replot  2.925e-001+ 2.000*( 9.980e-001* 4.727e-002*cos(t)+ 6.243e-002* 8.749e-003*sin(t)),  4.060e-002 +2.000*(-6.243e-002* 4.727e-002*cos(t)+ 9.980e-001* 8.749e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  3.956e-001, 9.938e-002 center
replot  3.956e-001+ 2.000*( 9.950e-001* 7.462e-002*cos(t)+ 9.992e-002* 2.194e-002*sin(t)),  9.938e-002 +2.000*(-9.992e-002* 7.462e-002*cos(t)+ 9.950e-001* 2.194e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  5.238e-001, 2.326e-001 center
replot  5.238e-001+ 2.000*( 9.789e-001* 1.164e-001*cos(t)+ 2.045e-001* 6.268e-002*sin(t)),  2.326e-001 +2.000*(-2.045e-001* 1.164e-001*cos(t)+ 9.789e-001* 6.268e-002*sin(t)) not
set out;
set out "DKMgali/VARPIJGR_DKMgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "DKMgali/VARPIJGR_DKMgali_123-21.svg"
set label "50" at  3.733e-002, 2.699e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  3.733e-002+ 2.000*( 1.266e-002* 7.948e-002*cos(t)+ 9.999e-001* 1.700e-002*sin(t)),  2.699e-001 +2.000*(-9.999e-001* 7.948e-002*cos(t)+ 1.266e-002* 1.700e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  5.348e-002, 2.500e-001 center
replot  5.348e-002+ 2.000*( 2.237e-002* 5.942e-002*cos(t)+ 9.997e-001* 2.018e-002*sin(t)),  2.500e-001 +2.000*(-9.997e-001* 5.942e-002*cos(t)+ 2.237e-002* 2.018e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  7.631e-002, 2.306e-001 center
replot  7.631e-002+ 2.000*( 4.845e-002* 4.399e-002*cos(t)+ 9.988e-001* 2.310e-002*sin(t)),  2.306e-001 +2.000*(-9.988e-001* 4.399e-002*cos(t)+ 4.845e-002* 2.310e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.083e-001, 2.115e-001 center
replot  1.083e-001+ 2.000*( 1.274e-001* 3.494e-002*cos(t)+ 9.918e-001* 2.545e-002*sin(t)),  2.115e-001 +2.000*(-9.918e-001* 3.494e-002*cos(t)+ 1.274e-001* 2.545e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  1.525e-001, 1.925e-001 center
replot  1.525e-001+ 2.000*( 2.626e-001* 3.339e-002*cos(t)+ 9.649e-001* 2.760e-002*sin(t)),  1.925e-001 +2.000*(-9.649e-001* 3.339e-002*cos(t)+ 2.626e-001* 2.760e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  2.126e-001, 1.735e-001 center
replot  2.126e-001+ 2.000*( 4.331e-001* 3.728e-002*cos(t)+ 9.014e-001* 3.226e-002*sin(t)),  1.735e-001 +2.000*(-9.014e-001* 3.728e-002*cos(t)+ 4.331e-001* 3.226e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  2.925e-001, 1.544e-001 center
replot  2.925e-001+ 2.000*( 9.244e-001* 4.830e-002*cos(t)+ 3.814e-001* 3.999e-002*sin(t)),  1.544e-001 +2.000*(-3.814e-001* 4.830e-002*cos(t)+ 9.244e-001* 3.999e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  3.956e-001, 1.350e-001 center
replot  3.956e-001+ 2.000*( 9.883e-001* 7.485e-002*cos(t)+ 1.524e-001* 4.450e-002*sin(t)),  1.350e-001 +2.000*(-1.524e-001* 7.485e-002*cos(t)+ 9.883e-001* 4.450e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  5.238e-001, 1.155e-001 center
replot  5.238e-001+ 2.000*( 9.949e-001* 1.151e-001*cos(t)+ 1.008e-001* 4.657e-002*sin(t)),  1.155e-001 +2.000*(-1.008e-001* 1.151e-001*cos(t)+ 9.949e-001* 4.657e-002*sin(t)) not
set out;
set out "DKMgali/VARPIJGR_DKMgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "DKMgali/VARMUPTJGR--STABLBASED_DKMgali1.svg";
 plot "DKMgali/PRMORPREV-1-STABLBASED_DKMgali.txt"  u 1:($3) not w l lt 1 
 replot "DKMgali/PRMORPREV-1-STABLBASED_DKMgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "DKMgali/PRMORPREV-1-STABLBASED_DKMgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "DKMgali/VARMUPTJGR--STABLBASED_DKMgali1.svg";replot;set out;
