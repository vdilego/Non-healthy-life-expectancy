
# IMaCh-0.99r45
# ESFgali.gp
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


set ter svg size 640, 480;set out "ESFgali/D_ESFgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "ESFgali/ILK_ESFgali-dest.png";
set log y;plot  "ESFgali/ILK_ESFgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "ESFgali/ILK_ESFgali-ori.png";
set log y;plot  "ESFgali/ILK_ESFgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "ESFgali/ILK_ESFgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ESFgali/ILK_ESFgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "ESFgali/ILK_ESFgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ESFgali/ILK_ESFgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "ESFgali/V_ESFgali_1-1-1.svg" 

#set out "V_ESFgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ESFgali/VPL_ESFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"ESFgali/VPL_ESFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"ESFgali/VPL_ESFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"ESFgali/P_ESFgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "ESFgali/V_ESFgali_2-1-1.svg" 

#set out "V_ESFgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ESFgali/VPL_ESFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"ESFgali/VPL_ESFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"ESFgali/VPL_ESFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"ESFgali/P_ESFgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "ESFgali/E_ESFgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "ESFgali/T_ESFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"ESFgali/T_ESFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"ESFgali/T_ESFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"ESFgali/T_ESFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"ESFgali/T_ESFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"ESFgali/T_ESFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"ESFgali/T_ESFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"ESFgali/T_ESFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"ESFgali/T_ESFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "ESFgali/E_ESFgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "ESFgali/EXP_ESFgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ESFgali/E_ESFgali.txt" every :::0::0 u 1:2 t "e11" w l ,"ESFgali/E_ESFgali.txt" every :::0::0 u 1:3 t "e12" w l ,"ESFgali/E_ESFgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "ESFgali/EXP_ESFgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ESFgali/E_ESFgali.txt" every :::0::0 u 1:5 t "e21" w l ,"ESFgali/E_ESFgali.txt" every :::0::0 u 1:6 t "e22" w l ,"ESFgali/E_ESFgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "ESFgali/LIJ_ESFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFgali/PIJ_ESFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "ESFgali/LIJ_ESFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFgali/PIJ_ESFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "ESFgali/LIJT_ESFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFgali/PIJ_ESFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "ESFgali/LIJT_ESFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFgali/PIJ_ESFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "ESFgali/P_ESFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFgali/PIJ_ESFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "ESFgali/P_ESFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESFgali/PIJ_ESFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-10.783355; p2=0.098426; 
#   current state 3
p3=-12.516902; p4=0.106036; 
# initial state 2
#   current state 1
p5=-4.526405; p6=0.035946; 
#   current state 3
p7=-13.369637; p8=0.135598; 
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

set out "ESFgali/PE_ESFgali_1-1-1.svg" 
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

set out "ESFgali/PE_ESFgali_1-2-1.svg" 
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

set out "ESFgali/PE_ESFgali_1-3-1.svg" 
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
set out "ESFgali/VARPIJGR_ESFgali_113-12.svg"
set label "50" at  1.466e-003, 5.670e-003 center
# Age 50, p13 - p12
plot [-pi:pi]  1.466e-003+ 2.000*( 3.375e-002* 1.425e-003*cos(t)+ 9.994e-001* 6.026e-004*sin(t)),  5.670e-003 +2.000*(-9.994e-001* 1.425e-003*cos(t)+ 3.375e-002* 6.026e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  2.485e-003, 9.254e-003 center
replot  2.485e-003+ 2.000*( 3.265e-002* 1.919e-003*cos(t)+ 9.995e-001* 8.535e-004*sin(t)),  9.254e-003 +2.000*(-9.995e-001* 1.919e-003*cos(t)+ 3.265e-002* 8.535e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  4.206e-003, 1.508e-002 center
replot  4.206e-003+ 2.000*( 3.211e-002* 2.504e-003*cos(t)+ 9.995e-001* 1.172e-003*sin(t)),  1.508e-002 +2.000*(-9.995e-001* 2.504e-003*cos(t)+ 3.211e-002* 1.172e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  7.102e-003, 2.452e-002 center
replot  7.102e-003+ 2.000*( 3.655e-002* 3.175e-003*cos(t)+ 9.993e-001* 1.558e-003*sin(t)),  2.452e-002 +2.000*(-9.993e-001* 3.175e-003*cos(t)+ 3.655e-002* 1.558e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.195e-002, 3.969e-002 center
replot  1.195e-002+ 2.000*( 6.039e-002* 4.086e-003*cos(t)+ 9.982e-001* 2.044e-003*sin(t)),  3.969e-002 +2.000*(-9.982e-001* 4.086e-003*cos(t)+ 6.039e-002* 2.044e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.996e-002, 6.386e-002 center
replot  1.996e-002+ 2.000*( 1.138e-001* 6.047e-003*cos(t)+ 9.935e-001* 2.879e-003*sin(t)),  6.386e-002 +2.000*(-9.935e-001* 6.047e-003*cos(t)+ 1.138e-001* 2.879e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.302e-002, 1.017e-001 center
replot  3.302e-002+ 2.000*( 1.621e-001* 1.096e-002*cos(t)+ 9.868e-001* 4.928e-003*sin(t)),  1.017e-001 +2.000*(-9.868e-001* 1.096e-002*cos(t)+ 1.621e-001* 4.928e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  5.375e-002, 1.593e-001 center
replot  5.375e-002+ 2.000*( 1.990e-001* 2.137e-002*cos(t)+ 9.800e-001* 9.756e-003*sin(t)),  1.593e-001 +2.000*(-9.800e-001* 2.137e-002*cos(t)+ 1.990e-001* 9.756e-003*sin(t)) not
# Age 90, p13 - p12
set label "90" at  8.541e-002, 2.437e-001 center
replot  8.541e-002+ 2.000*( 2.483e-001* 4.019e-002*cos(t)+ 9.687e-001* 1.919e-002*sin(t)),  2.437e-001 +2.000*(-9.687e-001* 4.019e-002*cos(t)+ 2.483e-001* 1.919e-002*sin(t)) not
set out;
set out "ESFgali/VARPIJGR_ESFgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ESFgali/VARPIJGR_ESFgali_121-12.svg"
set label "50" at  1.224e-001, 5.670e-003 center
# Age 50, p21 - p12
plot [-pi:pi]  1.224e-001+ 2.000*( 1.000e+000* 5.487e-002*cos(t)+-8.535e-003* 1.345e-003*sin(t)),  5.670e-003 +2.000*( 8.535e-003* 5.487e-002*cos(t)+ 1.000e+000* 1.345e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  1.446e-001, 9.254e-003 center
replot  1.446e-001+ 2.000*( 9.999e-001* 5.334e-002*cos(t)+-1.129e-002* 1.822e-003*sin(t)),  9.254e-003 +2.000*( 1.129e-002* 5.334e-002*cos(t)+ 9.999e-001* 1.822e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  1.702e-001, 1.508e-002 center
replot  1.702e-001+ 2.000*( 9.999e-001* 5.000e-002*cos(t)+-1.480e-002* 2.391e-003*sin(t)),  1.508e-002 +2.000*( 1.480e-002* 5.000e-002*cos(t)+ 9.999e-001* 2.391e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  1.994e-001, 2.452e-002 center
replot  1.994e-001+ 2.000*( 9.998e-001* 4.502e-002*cos(t)+-1.975e-002* 3.047e-003*sin(t)),  2.452e-002 +2.000*( 1.975e-002* 4.502e-002*cos(t)+ 9.998e-001* 3.047e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.320e-001, 3.969e-002 center
replot  2.320e-001+ 2.000*( 9.995e-001* 3.971e-002*cos(t)+-3.026e-002* 3.902e-003*sin(t)),  3.969e-002 +2.000*( 3.026e-002* 3.971e-002*cos(t)+ 9.995e-001* 3.902e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.670e-001, 6.386e-002 center
replot  2.670e-001+ 2.000*( 9.981e-001* 3.792e-002*cos(t)+-6.183e-002* 5.552e-003*sin(t)),  6.386e-002 +2.000*( 6.183e-002* 3.792e-002*cos(t)+ 9.981e-001* 5.552e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  3.017e-001, 1.017e-001 center
replot  3.017e-001+ 2.000*( 9.925e-001* 4.495e-002*cos(t)+-1.225e-001* 9.416e-003*sin(t)),  1.017e-001 +2.000*( 1.225e-001* 4.495e-002*cos(t)+ 9.925e-001* 9.416e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  3.310e-001, 1.593e-001 center
replot  3.310e-001+ 2.000*( 9.814e-001* 6.108e-002*cos(t)+-1.919e-001* 1.780e-002*sin(t)),  1.593e-001 +2.000*( 1.919e-001* 6.108e-002*cos(t)+ 9.814e-001* 1.780e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  3.466e-001, 2.437e-001 center
replot  3.466e-001+ 2.000*( 9.614e-001* 8.230e-002*cos(t)+-2.752e-001* 3.330e-002*sin(t)),  2.437e-001 +2.000*( 2.752e-001* 8.230e-002*cos(t)+ 9.614e-001* 3.330e-002*sin(t)) not
set out;
set out "ESFgali/VARPIJGR_ESFgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ESFgali/VARPIJGR_ESFgali_123-12.svg"
set label "50" at  2.577e-003, 5.670e-003 center
# Age 50, p23 - p12
plot [-pi:pi]  2.577e-003+ 2.000*( 9.984e-001* 2.737e-003*cos(t)+-5.741e-002* 1.417e-003*sin(t)),  5.670e-003 +2.000*( 5.741e-002* 2.737e-003*cos(t)+ 9.984e-001* 1.417e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  5.010e-003, 9.254e-003 center
replot  5.010e-003+ 2.000*( 9.992e-001* 4.565e-003*cos(t)+-4.111e-002* 1.911e-003*sin(t)),  9.254e-003 +2.000*( 4.111e-002* 4.565e-003*cos(t)+ 9.992e-001* 1.911e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  9.707e-003, 1.508e-002 center
replot  9.707e-003+ 2.000*( 9.995e-001* 7.391e-003*cos(t)+-3.175e-002* 2.493e-003*sin(t)),  1.508e-002 +2.000*( 3.175e-002* 7.391e-003*cos(t)+ 9.995e-001* 2.493e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.872e-002, 2.452e-002 center
replot  1.872e-002+ 2.000*( 9.996e-001* 1.148e-002*cos(t)+-2.721e-002* 3.159e-003*sin(t)),  2.452e-002 +2.000*( 2.721e-002* 1.148e-002*cos(t)+ 9.996e-001* 3.159e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  3.585e-002, 3.969e-002 center
replot  3.585e-002+ 2.000*( 9.996e-001* 1.679e-002*cos(t)+-2.828e-002* 4.055e-003*sin(t)),  3.969e-002 +2.000*( 2.828e-002* 1.679e-002*cos(t)+ 9.996e-001* 4.055e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  6.789e-002, 6.386e-002 center
replot  6.789e-002+ 2.000*( 9.992e-001* 2.250e-002*cos(t)+-4.114e-002* 5.950e-003*sin(t)),  6.386e-002 +2.000*( 4.114e-002* 2.250e-002*cos(t)+ 9.992e-001* 5.950e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.263e-001, 1.017e-001 center
replot  1.263e-001+ 2.000*( 9.959e-001* 2.750e-002*cos(t)+-9.071e-002* 1.060e-002*sin(t)),  1.017e-001 +2.000*( 9.071e-002* 2.750e-002*cos(t)+ 9.959e-001* 1.060e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  2.280e-001, 1.593e-001 center
replot  2.280e-001+ 2.000*( 9.845e-001* 3.855e-002*cos(t)+-1.755e-001* 2.023e-002*sin(t)),  1.593e-001 +2.000*( 1.755e-001* 3.855e-002*cos(t)+ 9.845e-001* 2.023e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  3.929e-001, 2.437e-001 center
replot  3.929e-001+ 2.000*( 9.934e-001* 7.979e-002*cos(t)+-1.146e-001* 3.839e-002*sin(t)),  2.437e-001 +2.000*( 1.146e-001* 7.979e-002*cos(t)+ 9.934e-001* 3.839e-002*sin(t)) not
set out;
set out "ESFgali/VARPIJGR_ESFgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ESFgali/VARPIJGR_ESFgali_121-13.svg"
set label "50" at  1.224e-001, 1.466e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  1.224e-001+ 2.000*( 1.000e+000* 5.487e-002*cos(t)+-1.059e-005* 6.041e-004*sin(t)),  1.466e-003 +2.000*( 1.059e-005* 5.487e-002*cos(t)+ 1.000e+000* 6.041e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  1.446e-001, 2.485e-003 center
replot  1.446e-001+ 2.000*( 1.000e+000* 5.334e-002*cos(t)+-4.931e-005* 8.553e-004*sin(t)),  2.485e-003 +2.000*( 4.931e-005* 5.334e-002*cos(t)+ 1.000e+000* 8.553e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  1.702e-001, 4.206e-003 center
replot  1.702e-001+ 2.000*( 1.000e+000* 5.000e-002*cos(t)+-1.380e-004* 1.174e-003*sin(t)),  4.206e-003 +2.000*( 1.380e-004* 5.000e-002*cos(t)+ 1.000e+000* 1.174e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  1.994e-001, 7.102e-003 center
replot  1.994e-001+ 2.000*( 1.000e+000* 4.501e-002*cos(t)+-3.172e-004* 1.562e-003*sin(t)),  7.102e-003 +2.000*( 3.172e-004* 4.501e-002*cos(t)+ 1.000e+000* 1.562e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.320e-001, 1.195e-002 center
replot  2.320e-001+ 2.000*( 1.000e+000* 3.969e-002*cos(t)+-5.327e-004* 2.055e-003*sin(t)),  1.195e-002 +2.000*( 5.327e-004* 3.969e-002*cos(t)+ 1.000e+000* 2.055e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.670e-001, 1.996e-002 center
replot  2.670e-001+ 2.000*( 1.000e+000* 3.785e-002*cos(t)+-1.061e-004* 2.942e-003*sin(t)),  1.996e-002 +2.000*( 1.061e-004* 3.785e-002*cos(t)+ 1.000e+000* 2.942e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  3.017e-001, 3.302e-002 center
replot  3.017e-001+ 2.000*( 1.000e+000* 4.463e-002*cos(t)+ 1.619e-003* 5.177e-003*sin(t)),  3.302e-002 +2.000*(-1.619e-003* 4.463e-002*cos(t)+ 1.000e+000* 5.177e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  3.310e-001, 5.375e-002 center
replot  3.310e-001+ 2.000*( 1.000e+000* 6.005e-002*cos(t)+ 2.661e-003* 1.046e-002*sin(t)),  5.375e-002 +2.000*(-2.661e-003* 6.005e-002*cos(t)+ 1.000e+000* 1.046e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  3.466e-001, 8.541e-002 center
replot  3.466e-001+ 2.000*( 1.000e+000* 7.965e-002*cos(t)+-8.352e-005* 2.110e-002*sin(t)),  8.541e-002 +2.000*( 8.352e-005* 7.965e-002*cos(t)+ 1.000e+000* 2.110e-002*sin(t)) not
set out;
set out "ESFgali/VARPIJGR_ESFgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ESFgali/VARPIJGR_ESFgali_123-13.svg"
set label "50" at  2.577e-003, 1.466e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  2.577e-003+ 2.000*( 9.992e-001* 2.736e-003*cos(t)+ 4.113e-002* 5.941e-004*sin(t)),  1.466e-003 +2.000*(-4.113e-002* 2.736e-003*cos(t)+ 9.992e-001* 5.941e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  5.010e-003, 2.485e-003 center
replot  5.010e-003+ 2.000*( 9.994e-001* 4.564e-003*cos(t)+ 3.512e-002* 8.407e-004*sin(t)),  2.485e-003 +2.000*(-3.512e-002* 4.564e-003*cos(t)+ 9.994e-001* 8.407e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  9.707e-003, 4.206e-003 center
replot  9.707e-003+ 2.000*( 9.995e-001* 7.391e-003*cos(t)+ 3.057e-002* 1.153e-003*sin(t)),  4.206e-003 +2.000*(-3.057e-002* 7.391e-003*cos(t)+ 9.995e-001* 1.153e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.872e-002, 7.102e-003 center
replot  1.872e-002+ 2.000*( 9.996e-001* 1.148e-002*cos(t)+ 2.775e-002* 1.529e-003*sin(t)),  7.102e-003 +2.000*(-2.775e-002* 1.148e-002*cos(t)+ 9.996e-001* 1.529e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  3.585e-002, 1.195e-002 center
replot  3.585e-002+ 2.000*( 9.996e-001* 1.679e-002*cos(t)+ 2.793e-002* 2.002e-003*sin(t)),  1.195e-002 +2.000*(-2.793e-002* 1.679e-002*cos(t)+ 9.996e-001* 2.002e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  6.789e-002, 1.996e-002 center
replot  6.789e-002+ 2.000*( 9.994e-001* 2.249e-002*cos(t)+ 3.577e-002* 2.831e-003*sin(t)),  1.996e-002 +2.000*(-3.577e-002* 2.249e-002*cos(t)+ 9.994e-001* 2.831e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.263e-001, 3.302e-002 center
replot  1.263e-001+ 2.000*( 9.977e-001* 2.747e-002*cos(t)+ 6.814e-002* 4.839e-003*sin(t)),  3.302e-002 +2.000*(-6.814e-002* 2.747e-002*cos(t)+ 9.977e-001* 4.839e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  2.280e-001, 5.375e-002 center
replot  2.280e-001+ 2.000*( 9.922e-001* 3.839e-002*cos(t)+ 1.245e-001* 9.382e-003*sin(t)),  5.375e-002 +2.000*(-1.245e-001* 3.839e-002*cos(t)+ 9.922e-001* 9.382e-003*sin(t)) not
# Age 90, p23 - p13
set label "90" at  3.929e-001, 8.541e-002 center
replot  3.929e-001+ 2.000*( 9.947e-001* 7.978e-002*cos(t)+ 1.024e-001* 1.956e-002*sin(t)),  8.541e-002 +2.000*(-1.024e-001* 7.978e-002*cos(t)+ 9.947e-001* 1.956e-002*sin(t)) not
set out;
set out "ESFgali/VARPIJGR_ESFgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "ESFgali/VARPIJGR_ESFgali_123-21.svg"
set label "50" at  2.577e-003, 1.224e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  2.577e-003+ 2.000*( 2.196e-003* 5.487e-002*cos(t)+-1.000e+000* 2.731e-003*sin(t)),  1.224e-001 +2.000*( 1.000e+000* 5.487e-002*cos(t)+ 2.196e-003* 2.731e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  5.010e-003, 1.446e-001 center
replot  5.010e-003+ 2.000*( 2.646e-003* 5.334e-002*cos(t)+-1.000e+000* 4.559e-003*sin(t)),  1.446e-001 +2.000*( 1.000e+000* 5.334e-002*cos(t)+ 2.646e-003* 4.559e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  9.707e-003, 1.702e-001 center
replot  9.707e-003+ 2.000*( 1.918e-003* 5.000e-002*cos(t)+-1.000e+000* 7.387e-003*sin(t)),  1.702e-001 +2.000*( 1.000e+000* 5.000e-002*cos(t)+ 1.918e-003* 7.387e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.872e-002, 1.994e-001 center
replot  1.872e-002+ 2.000*( 3.433e-003* 4.501e-002*cos(t)+ 1.000e+000* 1.147e-002*sin(t)),  1.994e-001 +2.000*(-1.000e+000* 4.501e-002*cos(t)+ 3.433e-003* 1.147e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  3.585e-002, 2.320e-001 center
replot  3.585e-002+ 2.000*( 2.349e-002* 3.970e-002*cos(t)+ 9.997e-001* 1.676e-002*sin(t)),  2.320e-001 +2.000*(-9.997e-001* 3.970e-002*cos(t)+ 2.349e-002* 1.676e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  6.789e-002, 2.670e-001 center
replot  6.789e-002+ 2.000*( 6.340e-002* 3.790e-002*cos(t)+ 9.980e-001* 2.239e-002*sin(t)),  2.670e-001 +2.000*(-9.980e-001* 3.790e-002*cos(t)+ 6.340e-002* 2.239e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.263e-001, 3.017e-001 center
replot  1.263e-001+ 2.000*( 4.515e-002* 4.466e-002*cos(t)+ 9.990e-001* 2.736e-002*sin(t)),  3.017e-001 +2.000*(-9.990e-001* 4.466e-002*cos(t)+ 4.515e-002* 2.736e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  2.280e-001, 3.310e-001 center
replot  2.280e-001+ 2.000*( 3.269e-002* 6.006e-002*cos(t)+ 9.995e-001* 3.808e-002*sin(t)),  3.310e-001 +2.000*(-9.995e-001* 6.006e-002*cos(t)+ 3.269e-002* 3.808e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  3.929e-001, 3.466e-001 center
replot  3.929e-001+ 2.000*( 6.997e-001* 8.568e-002*cos(t)+ 7.144e-001* 7.284e-002*sin(t)),  3.466e-001 +2.000*(-7.144e-001* 8.568e-002*cos(t)+ 6.997e-001* 7.284e-002*sin(t)) not
set out;
set out "ESFgali/VARPIJGR_ESFgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "ESFgali/VARMUPTJGR--STABLBASED_ESFgali1.svg";
 plot "ESFgali/PRMORPREV-1-STABLBASED_ESFgali.txt"  u 1:($3) not w l lt 1 
 replot "ESFgali/PRMORPREV-1-STABLBASED_ESFgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "ESFgali/PRMORPREV-1-STABLBASED_ESFgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "ESFgali/VARMUPTJGR--STABLBASED_ESFgali1.svg";replot;set out;
