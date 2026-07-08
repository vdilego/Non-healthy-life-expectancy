
# IMaCh-0.99r45
# ITMgali.gp
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


set ter svg size 640, 480;set out "ITMgali/D_ITMgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "ITMgali/ILK_ITMgali-dest.png";
set log y;plot  "ITMgali/ILK_ITMgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "ITMgali/ILK_ITMgali-ori.png";
set log y;plot  "ITMgali/ILK_ITMgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "ITMgali/ILK_ITMgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ITMgali/ILK_ITMgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "ITMgali/ILK_ITMgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ITMgali/ILK_ITMgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "ITMgali/V_ITMgali_1-1-1.svg" 

#set out "V_ITMgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ITMgali/VPL_ITMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"ITMgali/VPL_ITMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"ITMgali/VPL_ITMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"ITMgali/P_ITMgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "ITMgali/V_ITMgali_2-1-1.svg" 

#set out "V_ITMgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ITMgali/VPL_ITMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"ITMgali/VPL_ITMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"ITMgali/VPL_ITMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"ITMgali/P_ITMgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "ITMgali/E_ITMgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "ITMgali/T_ITMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"ITMgali/T_ITMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"ITMgali/T_ITMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"ITMgali/T_ITMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"ITMgali/T_ITMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"ITMgali/T_ITMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"ITMgali/T_ITMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"ITMgali/T_ITMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"ITMgali/T_ITMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "ITMgali/E_ITMgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "ITMgali/EXP_ITMgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ITMgali/E_ITMgali.txt" every :::0::0 u 1:2 t "e11" w l ,"ITMgali/E_ITMgali.txt" every :::0::0 u 1:3 t "e12" w l ,"ITMgali/E_ITMgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "ITMgali/EXP_ITMgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ITMgali/E_ITMgali.txt" every :::0::0 u 1:5 t "e21" w l ,"ITMgali/E_ITMgali.txt" every :::0::0 u 1:6 t "e22" w l ,"ITMgali/E_ITMgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "ITMgali/LIJ_ITMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMgali/PIJ_ITMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "ITMgali/LIJ_ITMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMgali/PIJ_ITMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "ITMgali/LIJT_ITMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMgali/PIJ_ITMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "ITMgali/LIJT_ITMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMgali/PIJ_ITMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "ITMgali/P_ITMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMgali/PIJ_ITMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "ITMgali/P_ITMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMgali/PIJ_ITMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-6.656279; p2=0.045186; 
#   current state 3
p3=-13.892638; p4=0.124033; 
# initial state 2
#   current state 1
p5=-0.001875; p6=-0.025472; 
#   current state 3
p7=-9.231171; p8=0.082443; 
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

set out "ITMgali/PE_ITMgali_1-1-1.svg" 
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

set out "ITMgali/PE_ITMgali_1-2-1.svg" 
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

set out "ITMgali/PE_ITMgali_1-3-1.svg" 
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
set out "ITMgali/VARPIJGR_ITMgali_113-12.svg"
set label "50" at  9.023e-004, 2.432e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  9.023e-004+ 2.000*( 8.382e-003* 5.267e-003*cos(t)+ 1.000e+000* 5.350e-004*sin(t)),  2.432e-002 +2.000*(-1.000e+000* 5.267e-003*cos(t)+ 8.382e-003* 5.350e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.672e-003, 3.038e-002 center
replot  1.672e-003+ 2.000*( 1.366e-002* 5.313e-003*cos(t)+ 9.999e-001* 8.297e-004*sin(t)),  3.038e-002 +2.000*(-9.999e-001* 5.313e-003*cos(t)+ 1.366e-002* 8.297e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  3.094e-003, 3.791e-002 center
replot  3.094e-003+ 2.000*( 2.375e-002* 5.203e-003*cos(t)+ 9.997e-001* 1.245e-003*sin(t)),  3.791e-002 +2.000*(-9.997e-001* 5.203e-003*cos(t)+ 2.375e-002* 1.245e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  5.718e-003, 4.722e-002 center
replot  5.718e-003+ 2.000*( 4.494e-002* 5.090e-003*cos(t)+ 9.990e-001* 1.795e-003*sin(t)),  4.722e-002 +2.000*(-9.990e-001* 5.090e-003*cos(t)+ 4.494e-002* 1.795e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.054e-002, 5.870e-002 center
replot  1.054e-002+ 2.000*( 8.339e-002* 5.521e-003*cos(t)+ 9.965e-001* 2.497e-003*sin(t)),  5.870e-002 +2.000*(-9.965e-001* 5.521e-003*cos(t)+ 8.339e-002* 2.497e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.937e-002, 7.271e-002 center
replot  1.937e-002+ 2.000*( 1.250e-001* 7.425e-003*cos(t)+ 9.922e-001* 3.603e-003*sin(t)),  7.271e-002 +2.000*(-9.922e-001* 7.425e-003*cos(t)+ 1.250e-001* 3.603e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.539e-002, 8.957e-002 center
replot  3.539e-002+ 2.000*( 1.941e-001* 1.146e-002*cos(t)+ 9.810e-001* 6.439e-003*sin(t)),  8.957e-002 +2.000*(-9.810e-001* 1.146e-002*cos(t)+ 1.941e-001* 6.439e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  6.409e-002, 1.094e-001 center
replot  6.409e-002+ 2.000*( 4.786e-001* 1.846e-002*cos(t)+ 8.780e-001* 1.380e-002*sin(t)),  1.094e-001 +2.000*(-8.780e-001* 1.846e-002*cos(t)+ 4.786e-001* 1.380e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.144e-001, 1.316e-001 center
replot  1.144e-001+ 2.000*( 9.256e-001* 3.574e-002*cos(t)+ 3.785e-001* 2.413e-002*sin(t)),  1.316e-001 +2.000*(-3.785e-001* 3.574e-002*cos(t)+ 9.256e-001* 2.413e-002*sin(t)) not
set out;
set out "ITMgali/VARPIJGR_ITMgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ITMgali/VARPIJGR_ITMgali_121-12.svg"
set label "50" at  4.346e-001, 2.432e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  4.346e-001+ 2.000*( 9.998e-001* 8.337e-002*cos(t)+-1.851e-002* 5.036e-003*sin(t)),  2.432e-002 +2.000*( 1.851e-002* 8.337e-002*cos(t)+ 9.998e-001* 5.036e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.919e-001, 3.038e-002 center
replot  3.919e-001+ 2.000*( 9.997e-001* 6.230e-002*cos(t)+-2.527e-002* 5.075e-003*sin(t)),  3.038e-002 +2.000*( 2.527e-002* 6.230e-002*cos(t)+ 9.997e-001* 5.075e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.519e-001, 3.791e-002 center
replot  3.519e-001+ 2.000*( 9.994e-001* 4.529e-002*cos(t)+-3.443e-002* 4.965e-003*sin(t)),  3.791e-002 +2.000*( 3.443e-002* 4.529e-002*cos(t)+ 9.994e-001* 4.965e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.147e-001, 4.722e-002 center
replot  3.147e-001+ 2.000*( 9.990e-001* 3.348e-002*cos(t)+-4.542e-002* 4.858e-003*sin(t)),  4.722e-002 +2.000*( 4.542e-002* 3.348e-002*cos(t)+ 9.990e-001* 4.858e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.799e-001, 5.870e-002 center
replot  2.799e-001+ 2.000*( 9.984e-001* 2.824e-002*cos(t)+-5.606e-002* 5.281e-003*sin(t)),  5.870e-002 +2.000*( 5.606e-002* 2.824e-002*cos(t)+ 9.984e-001* 5.281e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.472e-001, 7.271e-002 center
replot  2.472e-001+ 2.000*( 9.975e-001* 2.898e-002*cos(t)+-7.015e-002* 7.113e-003*sin(t)),  7.271e-002 +2.000*( 7.015e-002* 2.898e-002*cos(t)+ 9.975e-001* 7.113e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.165e-001, 8.957e-002 center
replot  2.165e-001+ 2.000*( 9.953e-001* 3.254e-002*cos(t)+-9.677e-002* 1.092e-002*sin(t)),  8.957e-002 +2.000*( 9.677e-002* 3.254e-002*cos(t)+ 9.953e-001* 1.092e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.873e-001, 1.094e-001 center
replot  1.873e-001+ 2.000*( 9.894e-001* 3.631e-002*cos(t)+-1.455e-001* 1.687e-002*sin(t)),  1.094e-001 +2.000*( 1.455e-001* 3.631e-002*cos(t)+ 9.894e-001* 1.687e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.595e-001, 1.316e-001 center
replot  1.595e-001+ 2.000*( 9.684e-001* 3.922e-002*cos(t)+-2.495e-001* 2.500e-002*sin(t)),  1.316e-001 +2.000*( 2.495e-001* 3.922e-002*cos(t)+ 9.684e-001* 2.500e-002*sin(t)) not
set out;
set out "ITMgali/VARPIJGR_ITMgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ITMgali/VARPIJGR_ITMgali_123-12.svg"
set label "50" at  9.402e-003, 2.432e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  9.402e-003+ 2.000*( 9.851e-001* 6.286e-003*cos(t)+-1.719e-001* 5.232e-003*sin(t)),  2.432e-002 +2.000*( 1.719e-001* 6.286e-003*cos(t)+ 9.851e-001* 5.232e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.454e-002, 3.038e-002 center
replot  1.454e-002+ 2.000*( 9.970e-001* 8.208e-003*cos(t)+-7.761e-002* 5.290e-003*sin(t)),  3.038e-002 +2.000*( 7.761e-002* 8.208e-003*cos(t)+ 9.970e-001* 5.290e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  2.240e-002, 3.791e-002 center
replot  2.240e-002+ 2.000*( 9.985e-001* 1.040e-002*cos(t)+-5.459e-002* 5.178e-003*sin(t)),  3.791e-002 +2.000*( 5.459e-002* 1.040e-002*cos(t)+ 9.985e-001* 5.178e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  3.436e-002, 4.722e-002 center
replot  3.436e-002+ 2.000*( 9.988e-001* 1.266e-002*cos(t)+-4.882e-002* 5.054e-003*sin(t)),  4.722e-002 +2.000*( 4.882e-002* 1.266e-002*cos(t)+ 9.988e-001* 5.054e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  5.241e-002, 5.870e-002 center
replot  5.241e-002+ 2.000*( 9.984e-001* 1.474e-002*cos(t)+-5.681e-002* 5.450e-003*sin(t)),  5.870e-002 +2.000*( 5.681e-002* 1.474e-002*cos(t)+ 9.984e-001* 5.450e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  7.941e-002, 7.271e-002 center
replot  7.941e-002+ 2.000*( 9.961e-001* 1.686e-002*cos(t)+-8.785e-002* 7.259e-003*sin(t)),  7.271e-002 +2.000*( 8.785e-002* 1.686e-002*cos(t)+ 9.961e-001* 7.259e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.193e-001, 8.957e-002 center
replot  1.193e-001+ 2.000*( 9.909e-001* 2.152e-002*cos(t)+-1.343e-001* 1.104e-002*sin(t)),  8.957e-002 +2.000*( 1.343e-001* 2.152e-002*cos(t)+ 9.909e-001* 1.104e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.770e-001, 1.094e-001 center
replot  1.770e-001+ 2.000*( 9.926e-001* 3.500e-002*cos(t)+-1.214e-001* 1.711e-002*sin(t)),  1.094e-001 +2.000*( 1.214e-001* 3.500e-002*cos(t)+ 9.926e-001* 1.711e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.586e-001, 1.316e-001 center
replot  2.586e-001+ 2.000*( 9.964e-001* 6.352e-002*cos(t)+-8.502e-002* 2.564e-002*sin(t)),  1.316e-001 +2.000*( 8.502e-002* 6.352e-002*cos(t)+ 9.964e-001* 2.564e-002*sin(t)) not
set out;
set out "ITMgali/VARPIJGR_ITMgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ITMgali/VARPIJGR_ITMgali_121-13.svg"
set label "50" at  4.346e-001, 9.023e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  4.346e-001+ 2.000*( 1.000e+000* 8.336e-002*cos(t)+-2.082e-004* 5.365e-004*sin(t)),  9.023e-004 +2.000*( 2.082e-004* 8.336e-002*cos(t)+ 1.000e+000* 5.365e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.919e-001, 1.672e-003 center
replot  3.919e-001+ 2.000*( 1.000e+000* 6.228e-002*cos(t)+-3.577e-004* 8.325e-004*sin(t)),  1.672e-003 +2.000*( 3.577e-004* 6.228e-002*cos(t)+ 1.000e+000* 8.325e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.519e-001, 3.094e-003 center
replot  3.519e-001+ 2.000*( 1.000e+000* 4.526e-002*cos(t)+-5.910e-004* 1.251e-003*sin(t)),  3.094e-003 +2.000*( 5.910e-004* 4.526e-002*cos(t)+ 1.000e+000* 1.251e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.147e-001, 5.718e-003 center
replot  3.147e-001+ 2.000*( 1.000e+000* 3.345e-002*cos(t)+-1.139e-003* 1.808e-003*sin(t)),  5.718e-003 +2.000*( 1.139e-003* 3.345e-002*cos(t)+ 1.000e+000* 1.808e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.799e-001, 1.054e-002 center
replot  2.799e-001+ 2.000*( 1.000e+000* 2.820e-002*cos(t)+-3.529e-003* 2.529e-003*sin(t)),  1.054e-002 +2.000*( 3.529e-003* 2.820e-002*cos(t)+ 1.000e+000* 2.529e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.472e-001, 1.937e-002 center
replot  2.472e-001+ 2.000*( 9.999e-001* 2.892e-002*cos(t)+-1.102e-002* 3.679e-003*sin(t)),  1.937e-002 +2.000*( 1.102e-002* 2.892e-002*cos(t)+ 9.999e-001* 3.679e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.165e-001, 3.539e-002 center
replot  2.165e-001+ 2.000*( 9.996e-001* 3.242e-002*cos(t)+-2.816e-002* 6.637e-003*sin(t)),  3.539e-002 +2.000*( 2.816e-002* 3.242e-002*cos(t)+ 9.996e-001* 6.637e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.873e-001, 6.409e-002 center
replot  1.873e-001+ 2.000*( 9.973e-001* 3.609e-002*cos(t)+-7.383e-002* 1.480e-002*sin(t)),  6.409e-002 +2.000*( 7.383e-002* 3.609e-002*cos(t)+ 9.973e-001* 1.480e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.595e-001, 1.144e-001 center
replot  1.595e-001+ 2.000*( 8.934e-001* 3.980e-002*cos(t)+-4.493e-001* 3.278e-002*sin(t)),  1.144e-001 +2.000*( 4.493e-001* 3.980e-002*cos(t)+ 8.934e-001* 3.278e-002*sin(t)) not
set out;
set out "ITMgali/VARPIJGR_ITMgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ITMgali/VARPIJGR_ITMgali_123-13.svg"
set label "50" at  9.402e-003, 9.023e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  9.402e-003+ 2.000*( 9.997e-001* 6.260e-003*cos(t)+ 2.513e-002* 5.134e-004*sin(t)),  9.023e-004 +2.000*(-2.513e-002* 6.260e-003*cos(t)+ 9.997e-001* 5.134e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.454e-002, 1.672e-003 center
replot  1.454e-002+ 2.000*( 9.995e-001* 8.197e-003*cos(t)+ 3.021e-002* 7.955e-004*sin(t)),  1.672e-003 +2.000*(-3.021e-002* 8.197e-003*cos(t)+ 9.995e-001* 7.955e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  2.240e-002, 3.094e-003 center
replot  2.240e-002+ 2.000*( 9.993e-001* 1.039e-002*cos(t)+ 3.666e-002* 1.192e-003*sin(t)),  3.094e-003 +2.000*(-3.666e-002* 1.039e-002*cos(t)+ 9.993e-001* 1.192e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  3.436e-002, 5.718e-003 center
replot  3.436e-002+ 2.000*( 9.990e-001* 1.266e-002*cos(t)+ 4.532e-002* 1.716e-003*sin(t)),  5.718e-003 +2.000*(-4.532e-002* 1.266e-002*cos(t)+ 9.990e-001* 1.716e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  5.241e-002, 1.054e-002 center
replot  5.241e-002+ 2.000*( 9.983e-001* 1.474e-002*cos(t)+ 5.839e-002* 2.384e-003*sin(t)),  1.054e-002 +2.000*(-5.839e-002* 1.474e-002*cos(t)+ 9.983e-001* 2.384e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  7.941e-002, 1.937e-002 center
replot  7.941e-002+ 2.000*( 9.966e-001* 1.686e-002*cos(t)+ 8.216e-002* 3.435e-003*sin(t)),  1.937e-002 +2.000*(-8.216e-002* 1.686e-002*cos(t)+ 9.966e-001* 3.435e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.193e-001, 3.539e-002 center
replot  1.193e-001+ 2.000*( 9.921e-001* 2.153e-002*cos(t)+ 1.251e-001* 6.180e-003*sin(t)),  3.539e-002 +2.000*(-1.251e-001* 2.153e-002*cos(t)+ 9.921e-001* 6.180e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.770e-001, 6.409e-002 center
replot  1.770e-001+ 2.000*( 9.848e-001* 3.526e-002*cos(t)+ 1.738e-001* 1.390e-002*sin(t)),  6.409e-002 +2.000*(-1.738e-001* 3.526e-002*cos(t)+ 9.848e-001* 1.390e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.586e-001, 1.144e-001 center
replot  2.586e-001+ 2.000*( 9.743e-001* 6.458e-002*cos(t)+ 2.253e-001* 3.190e-002*sin(t)),  1.144e-001 +2.000*(-2.253e-001* 6.458e-002*cos(t)+ 9.743e-001* 3.190e-002*sin(t)) not
set out;
set out "ITMgali/VARPIJGR_ITMgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "ITMgali/VARPIJGR_ITMgali_123-21.svg"
set label "50" at  9.402e-003, 4.346e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  9.402e-003+ 2.000*( 4.030e-003* 8.336e-002*cos(t)+ 1.000e+000* 6.249e-003*sin(t)),  4.346e-001 +2.000*(-1.000e+000* 8.336e-002*cos(t)+ 4.030e-003* 6.249e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.454e-002, 3.919e-001 center
replot  1.454e-002+ 2.000*( 6.493e-003* 6.228e-002*cos(t)+ 1.000e+000* 8.184e-003*sin(t)),  3.919e-001 +2.000*(-1.000e+000* 6.228e-002*cos(t)+ 6.493e-003* 8.184e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  2.240e-002, 3.519e-001 center
replot  2.240e-002+ 2.000*( 1.221e-002* 4.526e-002*cos(t)+ 9.999e-001* 1.037e-002*sin(t)),  3.519e-001 +2.000*(-9.999e-001* 4.526e-002*cos(t)+ 1.221e-002* 1.037e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  3.436e-002, 3.147e-001 center
replot  3.436e-002+ 2.000*( 2.798e-002* 3.346e-002*cos(t)+ 9.996e-001* 1.262e-002*sin(t)),  3.147e-001 +2.000*(-9.996e-001* 3.346e-002*cos(t)+ 2.798e-002* 1.262e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  5.241e-002, 2.799e-001 center
replot  5.241e-002+ 2.000*( 6.346e-002* 2.824e-002*cos(t)+ 9.980e-001* 1.464e-002*sin(t)),  2.799e-001 +2.000*(-9.980e-001* 2.824e-002*cos(t)+ 6.346e-002* 1.464e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  7.941e-002, 2.472e-001 center
replot  7.941e-002+ 2.000*( 1.050e-001* 2.902e-002*cos(t)+ 9.945e-001* 1.662e-002*sin(t)),  2.472e-001 +2.000*(-9.945e-001* 2.902e-002*cos(t)+ 1.050e-001* 1.662e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.193e-001, 2.165e-001 center
replot  1.193e-001+ 2.000*( 1.748e-001* 3.270e-002*cos(t)+ 9.846e-001* 2.092e-002*sin(t)),  2.165e-001 +2.000*(-9.846e-001* 3.270e-002*cos(t)+ 1.748e-001* 2.092e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.770e-001, 1.873e-001 center
replot  1.770e-001+ 2.000*( 6.399e-001* 3.859e-002*cos(t)+ 7.684e-001* 3.192e-002*sin(t)),  1.873e-001 +2.000*(-7.684e-001* 3.859e-002*cos(t)+ 6.399e-001* 3.192e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.586e-001, 1.595e-001 center
replot  2.586e-001+ 2.000*( 9.800e-001* 6.418e-002*cos(t)+ 1.991e-001* 3.705e-002*sin(t)),  1.595e-001 +2.000*(-1.991e-001* 6.418e-002*cos(t)+ 9.800e-001* 3.705e-002*sin(t)) not
set out;
set out "ITMgali/VARPIJGR_ITMgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "ITMgali/VARMUPTJGR--STABLBASED_ITMgali1.svg";
 plot "ITMgali/PRMORPREV-1-STABLBASED_ITMgali.txt"  u 1:($3) not w l lt 1 
 replot "ITMgali/PRMORPREV-1-STABLBASED_ITMgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "ITMgali/PRMORPREV-1-STABLBASED_ITMgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "ITMgali/VARMUPTJGR--STABLBASED_ITMgali1.svg";replot;set out;
