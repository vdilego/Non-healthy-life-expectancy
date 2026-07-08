
# IMaCh-0.99r45
# ITMchr.gp
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


set ter svg size 640, 480;set out "ITMchr/D_ITMchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "ITMchr/ILK_ITMchr-dest.png";
set log y;plot  "ITMchr/ILK_ITMchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "ITMchr/ILK_ITMchr-ori.png";
set log y;plot  "ITMchr/ILK_ITMchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "ITMchr/ILK_ITMchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ITMchr/ILK_ITMchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "ITMchr/ILK_ITMchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ITMchr/ILK_ITMchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "ITMchr/V_ITMchr_1-1-1.svg" 

#set out "V_ITMchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ITMchr/VPL_ITMchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"ITMchr/VPL_ITMchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"ITMchr/VPL_ITMchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"ITMchr/P_ITMchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "ITMchr/V_ITMchr_2-1-1.svg" 

#set out "V_ITMchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ITMchr/VPL_ITMchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"ITMchr/VPL_ITMchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"ITMchr/VPL_ITMchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"ITMchr/P_ITMchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "ITMchr/E_ITMchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "ITMchr/T_ITMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"ITMchr/T_ITMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"ITMchr/T_ITMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"ITMchr/T_ITMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"ITMchr/T_ITMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"ITMchr/T_ITMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"ITMchr/T_ITMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"ITMchr/T_ITMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"ITMchr/T_ITMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "ITMchr/E_ITMchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "ITMchr/EXP_ITMchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ITMchr/E_ITMchr.txt" every :::0::0 u 1:2 t "e11" w l ,"ITMchr/E_ITMchr.txt" every :::0::0 u 1:3 t "e12" w l ,"ITMchr/E_ITMchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "ITMchr/EXP_ITMchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ITMchr/E_ITMchr.txt" every :::0::0 u 1:5 t "e21" w l ,"ITMchr/E_ITMchr.txt" every :::0::0 u 1:6 t "e22" w l ,"ITMchr/E_ITMchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "ITMchr/LIJ_ITMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMchr/PIJ_ITMchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "ITMchr/LIJ_ITMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMchr/PIJ_ITMchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "ITMchr/LIJT_ITMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMchr/PIJ_ITMchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "ITMchr/LIJT_ITMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMchr/PIJ_ITMchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "ITMchr/P_ITMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMchr/PIJ_ITMchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "ITMchr/P_ITMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ITMchr/PIJ_ITMchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-5.519178; p2=0.081153; 
#   current state 3
p3=-10.233738; p4=0.093503; 
# initial state 2
#   current state 1
p5=2.863717; p6=-0.069255; 
#   current state 3
p7=-10.975461; p8=0.114321; 
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

set out "ITMchr/PE_ITMchr_1-1-1.svg" 
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

set out "ITMchr/PE_ITMchr_1-2-1.svg" 
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

set out "ITMchr/PE_ITMchr_1-3-1.svg" 
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
set out "ITMchr/VARPIJGR_ITMchr_113-12.svg"
set label "50" at  1.560e-003, 9.382e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  1.560e-003+ 2.000*( 2.349e-003* 1.289e-002*cos(t)+-1.000e+000* 1.484e-003*sin(t)),  9.382e-002 +2.000*( 1.000e+000* 1.289e-002*cos(t)+ 2.349e-003* 1.484e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  2.272e-003, 1.285e-001 center
replot  2.272e-003+ 2.000*( 2.748e-003* 1.209e-002*cos(t)+ 1.000e+000* 1.702e-003*sin(t)),  1.285e-001 +2.000*(-1.000e+000* 1.209e-002*cos(t)+ 2.748e-003* 1.702e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  3.205e-003, 1.704e-001 center
replot  3.205e-003+ 2.000*( 1.078e-002* 1.095e-002*cos(t)+ 9.999e-001* 1.862e-003*sin(t)),  1.704e-001 +2.000*(-9.999e-001* 1.095e-002*cos(t)+ 1.078e-002* 1.862e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  4.355e-003, 2.177e-001 center
replot  4.355e-003+ 2.000*( 1.466e-002* 1.162e-002*cos(t)+ 9.999e-001* 2.113e-003*sin(t)),  2.177e-001 +2.000*(-9.999e-001* 1.162e-002*cos(t)+ 1.466e-002* 2.113e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  5.683e-003, 2.671e-001 center
replot  5.683e-003+ 2.000*( 1.798e-002* 1.486e-002*cos(t)+ 9.998e-001* 2.844e-003*sin(t)),  2.671e-001 +2.000*(-9.998e-001* 1.486e-002*cos(t)+ 1.798e-002* 2.844e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  7.119e-003, 3.145e-001 center
replot  7.119e-003+ 2.000*( 3.724e-002* 1.860e-002*cos(t)+ 9.993e-001* 4.363e-003*sin(t)),  3.145e-001 +2.000*(-9.993e-001* 1.860e-002*cos(t)+ 3.724e-002* 4.363e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  8.587e-003, 3.566e-001 center
replot  8.587e-003+ 2.000*( 8.922e-002* 2.119e-002*cos(t)+ 9.960e-001* 6.581e-003*sin(t)),  3.566e-001 +2.000*(-9.960e-001* 2.119e-002*cos(t)+ 8.922e-002* 6.581e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  1.002e-002, 3.914e-001 center
replot  1.002e-002+ 2.000*( 2.063e-001* 2.260e-002*cos(t)+ 9.785e-001* 9.019e-003*sin(t)),  3.914e-001 +2.000*(-9.785e-001* 2.260e-002*cos(t)+ 2.063e-001* 9.019e-003*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.140e-002, 4.184e-001 center
replot  1.140e-002+ 2.000*( 4.026e-001* 2.428e-002*cos(t)+ 9.154e-001* 1.062e-002*sin(t)),  4.184e-001 +2.000*(-9.154e-001* 2.428e-002*cos(t)+ 4.026e-001* 1.062e-002*sin(t)) not
set out;
set out "ITMchr/VARPIJGR_ITMchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ITMchr/VARPIJGR_ITMchr_121-12.svg"
set label "50" at  1.767e-001, 9.382e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  1.767e-001+ 2.000*( 9.994e-001* 1.688e-002*cos(t)+-3.513e-002* 1.289e-002*sin(t)),  9.382e-002 +2.000*( 3.513e-002* 1.688e-002*cos(t)+ 9.994e-001* 1.289e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  1.390e-001, 1.285e-001 center
replot  1.390e-001+ 2.000*( 1.523e-001* 1.211e-002*cos(t)+-9.883e-001* 1.133e-002*sin(t)),  1.285e-001 +2.000*( 9.883e-001* 1.211e-002*cos(t)+ 1.523e-001* 1.133e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  1.064e-001, 1.704e-001 center
replot  1.064e-001+ 2.000*( 2.677e-002* 1.095e-002*cos(t)+-9.996e-001* 7.404e-003*sin(t)),  1.704e-001 +2.000*( 9.996e-001* 1.095e-002*cos(t)+ 2.677e-002* 7.404e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  7.946e-002, 2.177e-001 center
replot  7.946e-002+ 2.000*( 1.395e-002* 1.162e-002*cos(t)+-9.999e-001* 5.539e-003*sin(t)),  2.177e-001 +2.000*( 9.999e-001* 1.162e-002*cos(t)+ 1.395e-002* 5.539e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  5.784e-002, 2.671e-001 center
replot  5.784e-002+ 2.000*( 8.234e-003* 1.486e-002*cos(t)+-1.000e+000* 5.101e-003*sin(t)),  2.671e-001 +2.000*( 1.000e+000* 1.486e-002*cos(t)+ 8.234e-003* 5.101e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  4.094e-002, 3.145e-001 center
replot  4.094e-002+ 2.000*( 5.318e-003* 1.859e-002*cos(t)+-1.000e+000* 4.903e-003*sin(t)),  3.145e-001 +2.000*( 1.000e+000* 1.859e-002*cos(t)+ 5.318e-003* 4.903e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.798e-002, 3.566e-001 center
replot  2.798e-002+ 2.000*( 3.497e-003* 2.112e-002*cos(t)+-1.000e+000* 4.427e-003*sin(t)),  3.566e-001 +2.000*( 1.000e+000* 2.112e-002*cos(t)+ 3.497e-003* 4.427e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.825e-002, 3.914e-001 center
replot  1.825e-002+ 2.000*( 2.073e-003* 2.219e-002*cos(t)+-1.000e+000* 3.673e-003*sin(t)),  3.914e-001 +2.000*( 1.000e+000* 2.219e-002*cos(t)+ 2.073e-003* 3.673e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.119e-002, 4.184e-001 center
replot  1.119e-002+ 2.000*( 8.848e-004* 2.264e-002*cos(t)+-1.000e+000* 2.798e-003*sin(t)),  4.184e-001 +2.000*( 1.000e+000* 2.264e-002*cos(t)+ 8.848e-004* 2.798e-003*sin(t)) not
set out;
set out "ITMchr/VARPIJGR_ITMchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ITMchr/VARPIJGR_ITMchr_123-12.svg"
set label "50" at  1.672e-003, 9.382e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  1.672e-003+ 2.000*( 8.948e-005* 1.289e-002*cos(t)+ 1.000e+000* 7.007e-004*sin(t)),  9.382e-002 +2.000*(-1.000e+000* 1.289e-002*cos(t)+ 8.948e-005* 7.007e-004*sin(t)) not
# Age 55, p23 - p12
set label "55" at  3.293e-003, 1.285e-001 center
replot  3.293e-003+ 2.000*( 1.365e-005* 1.209e-002*cos(t)+-1.000e+000* 1.148e-003*sin(t)),  1.285e-001 +2.000*( 1.000e+000* 1.209e-002*cos(t)+ 1.365e-005* 1.148e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  6.315e-003, 1.704e-001 center
replot  6.315e-003+ 2.000*( 4.395e-004* 1.095e-002*cos(t)+-1.000e+000* 1.769e-003*sin(t)),  1.704e-001 +2.000*( 1.000e+000* 1.095e-002*cos(t)+ 4.395e-004* 1.769e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.180e-002, 2.177e-001 center
replot  1.180e-002+ 2.000*( 1.178e-003* 1.162e-002*cos(t)+-1.000e+000* 2.537e-003*sin(t)),  2.177e-001 +2.000*( 1.000e+000* 1.162e-002*cos(t)+ 1.178e-003* 2.537e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  2.152e-002, 2.671e-001 center
replot  2.152e-002+ 2.000*( 1.529e-003* 1.486e-002*cos(t)+-1.000e+000* 3.365e-003*sin(t)),  2.671e-001 +2.000*( 1.000e+000* 1.486e-002*cos(t)+ 1.529e-003* 3.365e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  3.813e-002, 3.145e-001 center
replot  3.813e-002+ 2.000*( 1.772e-003* 1.859e-002*cos(t)+-1.000e+000* 4.341e-003*sin(t)),  3.145e-001 +2.000*( 1.000e+000* 1.859e-002*cos(t)+ 1.772e-003* 4.341e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  6.526e-002, 3.566e-001 center
replot  6.526e-002+ 2.000*( 2.401e-003* 2.112e-002*cos(t)+-1.000e+000* 6.693e-003*sin(t)),  3.566e-001 +2.000*( 1.000e+000* 2.112e-002*cos(t)+ 2.401e-003* 6.693e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.066e-001, 3.914e-001 center
replot  1.066e-001+ 2.000*( 4.592e-003* 2.219e-002*cos(t)+-1.000e+000* 1.269e-002*sin(t)),  3.914e-001 +2.000*( 1.000e+000* 2.219e-002*cos(t)+ 4.592e-003* 1.269e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.637e-001, 4.184e-001 center
replot  1.637e-001+ 2.000*( 5.956e-001* 2.267e-002*cos(t)+-8.033e-001* 2.257e-002*sin(t)),  4.184e-001 +2.000*( 8.033e-001* 2.267e-002*cos(t)+ 5.956e-001* 2.257e-002*sin(t)) not
set out;
set out "ITMchr/VARPIJGR_ITMchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ITMchr/VARPIJGR_ITMchr_121-13.svg"
set label "50" at  1.767e-001, 1.560e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  1.767e-001+ 2.000*( 1.000e+000* 1.687e-002*cos(t)+-6.401e-004* 1.484e-003*sin(t)),  1.560e-003 +2.000*( 6.401e-004* 1.687e-002*cos(t)+ 1.000e+000* 1.484e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  1.390e-001, 2.272e-003 center
replot  1.390e-001+ 2.000*( 1.000e+000* 1.135e-002*cos(t)+-8.236e-004* 1.702e-003*sin(t)),  2.272e-003 +2.000*( 8.236e-004* 1.135e-002*cos(t)+ 1.000e+000* 1.702e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  1.064e-001, 3.205e-003 center
replot  1.064e-001+ 2.000*( 1.000e+000* 7.407e-003*cos(t)+-1.352e-003* 1.866e-003*sin(t)),  3.205e-003 +2.000*( 1.352e-003* 7.407e-003*cos(t)+ 1.000e+000* 1.866e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  7.946e-002, 4.355e-003 center
replot  7.946e-002+ 2.000*( 1.000e+000* 5.541e-003*cos(t)+-4.533e-003* 2.119e-003*sin(t)),  4.355e-003 +2.000*( 4.533e-003* 5.541e-003*cos(t)+ 1.000e+000* 2.119e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  5.784e-002, 5.683e-003 center
replot  5.784e-002+ 2.000*( 9.999e-001* 5.103e-003*cos(t)+-1.431e-002* 2.856e-003*sin(t)),  5.683e-003 +2.000*( 1.431e-002* 5.103e-003*cos(t)+ 9.999e-001* 2.856e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  4.094e-002, 7.119e-003 center
replot  4.094e-002+ 2.000*( 9.954e-001* 4.908e-003*cos(t)+-9.593e-002* 4.410e-003*sin(t)),  7.119e-003 +2.000*( 9.593e-002* 4.908e-003*cos(t)+ 9.954e-001* 4.410e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.798e-002, 8.587e-003 center
replot  2.798e-002+ 2.000*( 2.290e-002* 6.823e-003*cos(t)+-9.997e-001* 4.426e-003*sin(t)),  8.587e-003 +2.000*( 9.997e-001* 6.823e-003*cos(t)+ 2.290e-002* 4.426e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.825e-002, 1.002e-002 center
replot  1.825e-002+ 2.000*( 8.372e-003* 9.981e-003*cos(t)+-1.000e+000* 3.672e-003*sin(t)),  1.002e-002 +2.000*( 1.000e+000* 9.981e-003*cos(t)+ 8.372e-003* 3.672e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.119e-002, 1.140e-002 center
replot  1.119e-002+ 2.000*( 3.954e-003* 1.379e-002*cos(t)+-1.000e+000* 2.797e-003*sin(t)),  1.140e-002 +2.000*( 1.000e+000* 1.379e-002*cos(t)+ 3.954e-003* 2.797e-003*sin(t)) not
set out;
set out "ITMchr/VARPIJGR_ITMchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ITMchr/VARPIJGR_ITMchr_123-13.svg"
set label "50" at  1.672e-003, 1.560e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  1.672e-003+ 2.000*( 8.020e-003* 1.484e-003*cos(t)+ 1.000e+000* 7.006e-004*sin(t)),  1.560e-003 +2.000*(-1.000e+000* 1.484e-003*cos(t)+ 8.020e-003* 7.006e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  3.293e-003, 2.272e-003 center
replot  3.293e-003+ 2.000*( 2.015e-002* 1.702e-003*cos(t)+ 9.998e-001* 1.148e-003*sin(t)),  2.272e-003 +2.000*(-9.998e-001* 1.702e-003*cos(t)+ 2.015e-002* 1.148e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  6.315e-003, 3.205e-003 center
replot  6.315e-003+ 2.000*( 1.913e-001* 1.870e-003*cos(t)+ 9.815e-001* 1.765e-003*sin(t)),  3.205e-003 +2.000*(-9.815e-001* 1.870e-003*cos(t)+ 1.913e-001* 1.765e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.180e-002, 4.355e-003 center
replot  1.180e-002+ 2.000*( 9.970e-001* 2.540e-003*cos(t)+ 7.796e-002* 2.116e-003*sin(t)),  4.355e-003 +2.000*(-7.796e-002* 2.540e-003*cos(t)+ 9.970e-001* 2.116e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  2.152e-002, 5.683e-003 center
replot  2.152e-002+ 2.000*( 9.952e-001* 3.369e-003*cos(t)+ 9.786e-002* 2.851e-003*sin(t)),  5.683e-003 +2.000*(-9.786e-002* 3.369e-003*cos(t)+ 9.952e-001* 2.851e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  3.813e-002, 7.119e-003 center
replot  3.813e-002+ 2.000*( 5.147e-001* 4.456e-003*cos(t)+ 8.574e-001* 4.298e-003*sin(t)),  7.119e-003 +2.000*(-8.574e-001* 4.456e-003*cos(t)+ 5.147e-001* 4.298e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  6.526e-002, 8.587e-003 center
replot  6.526e-002+ 2.000*( 4.368e-001* 6.862e-003*cos(t)+ 8.995e-001* 6.653e-003*sin(t)),  8.587e-003 +2.000*(-8.995e-001* 6.862e-003*cos(t)+ 4.368e-001* 6.653e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.066e-001, 1.002e-002 center
replot  1.066e-001+ 2.000*( 9.995e-001* 1.270e-002*cos(t)+ 3.034e-002* 9.978e-003*sin(t)),  1.002e-002 +2.000*(-3.034e-002* 1.270e-002*cos(t)+ 9.995e-001* 9.978e-003*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.637e-001, 1.140e-002 center
replot  1.637e-001+ 2.000*( 1.000e+000* 2.261e-002*cos(t)+ 8.837e-003* 1.379e-002*sin(t)),  1.140e-002 +2.000*(-8.837e-003* 2.261e-002*cos(t)+ 1.000e+000* 1.379e-002*sin(t)) not
set out;
set out "ITMchr/VARPIJGR_ITMchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "ITMchr/VARPIJGR_ITMchr_123-21.svg"
set label "50" at  1.672e-003, 1.767e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.672e-003+ 2.000*( 4.212e-003* 1.687e-002*cos(t)+ 1.000e+000* 6.971e-004*sin(t)),  1.767e-001 +2.000*(-1.000e+000* 1.687e-002*cos(t)+ 4.212e-003* 6.971e-004*sin(t)) not
# Age 55, p23 - p21
set label "55" at  3.293e-003, 1.390e-001 center
replot  3.293e-003+ 2.000*( 7.651e-003* 1.135e-002*cos(t)+ 1.000e+000* 1.145e-003*sin(t)),  1.390e-001 +2.000*(-1.000e+000* 1.135e-002*cos(t)+ 7.651e-003* 1.145e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  6.315e-003, 1.064e-001 center
replot  6.315e-003+ 2.000*( 1.681e-002* 7.408e-003*cos(t)+ 9.999e-001* 1.765e-003*sin(t)),  1.064e-001 +2.000*(-9.999e-001* 7.408e-003*cos(t)+ 1.681e-002* 1.765e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.180e-002, 7.946e-002 center
replot  1.180e-002+ 2.000*( 4.366e-002* 5.545e-003*cos(t)+ 9.990e-001* 2.528e-003*sin(t)),  7.946e-002 +2.000*(-9.990e-001* 5.545e-003*cos(t)+ 4.366e-002* 2.528e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  2.152e-002, 5.784e-002 center
replot  2.152e-002+ 2.000*( 9.933e-002* 5.117e-003*cos(t)+ 9.951e-001* 3.343e-003*sin(t)),  5.784e-002 +2.000*(-9.951e-001* 5.117e-003*cos(t)+ 9.933e-002* 3.343e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  3.813e-002, 4.094e-002 center
replot  3.813e-002+ 2.000*( 3.171e-001* 4.970e-003*cos(t)+ 9.484e-001* 4.265e-003*sin(t)),  4.094e-002 +2.000*(-9.484e-001* 4.970e-003*cos(t)+ 3.171e-001* 4.265e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  6.526e-002, 2.798e-002 center
replot  6.526e-002+ 2.000*( 9.929e-001* 6.720e-003*cos(t)+ 1.187e-001* 4.387e-003*sin(t)),  2.798e-002 +2.000*(-1.187e-001* 6.720e-003*cos(t)+ 9.929e-001* 4.387e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.066e-001, 1.825e-002 center
replot  1.066e-001+ 2.000*( 9.989e-001* 1.271e-002*cos(t)+ 4.750e-002* 3.627e-003*sin(t)),  1.825e-002 +2.000*(-4.750e-002* 1.271e-002*cos(t)+ 9.989e-001* 3.627e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.637e-001, 1.119e-002 center
replot  1.637e-001+ 2.000*( 9.995e-001* 2.262e-002*cos(t)+ 3.125e-002* 2.708e-003*sin(t)),  1.119e-002 +2.000*(-3.125e-002* 2.262e-002*cos(t)+ 9.995e-001* 2.708e-003*sin(t)) not
set out;
set out "ITMchr/VARPIJGR_ITMchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "ITMchr/VARMUPTJGR--STABLBASED_ITMchr1.svg";
 plot "ITMchr/PRMORPREV-1-STABLBASED_ITMchr.txt"  u 1:($3) not w l lt 1 
 replot "ITMchr/PRMORPREV-1-STABLBASED_ITMchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "ITMchr/PRMORPREV-1-STABLBASED_ITMchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "ITMchr/VARMUPTJGR--STABLBASED_ITMchr1.svg";replot;set out;
