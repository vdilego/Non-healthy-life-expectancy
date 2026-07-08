
# IMaCh-0.99r45
# SEMgali.gp
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


set ter svg size 640, 480;set out "SEMgali/D_SEMgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "SEMgali/ILK_SEMgali-dest.png";
set log y;plot  "SEMgali/ILK_SEMgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "SEMgali/ILK_SEMgali-ori.png";
set log y;plot  "SEMgali/ILK_SEMgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "SEMgali/ILK_SEMgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "SEMgali/ILK_SEMgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "SEMgali/ILK_SEMgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "SEMgali/ILK_SEMgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "SEMgali/V_SEMgali_1-1-1.svg" 

#set out "V_SEMgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "SEMgali/VPL_SEMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"SEMgali/VPL_SEMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"SEMgali/VPL_SEMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"SEMgali/P_SEMgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "SEMgali/V_SEMgali_2-1-1.svg" 

#set out "V_SEMgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "SEMgali/VPL_SEMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"SEMgali/VPL_SEMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"SEMgali/VPL_SEMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"SEMgali/P_SEMgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "SEMgali/E_SEMgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "SEMgali/T_SEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"SEMgali/T_SEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"SEMgali/T_SEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"SEMgali/T_SEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"SEMgali/T_SEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"SEMgali/T_SEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"SEMgali/T_SEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"SEMgali/T_SEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"SEMgali/T_SEMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "SEMgali/E_SEMgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "SEMgali/EXP_SEMgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "SEMgali/E_SEMgali.txt" every :::0::0 u 1:2 t "e11" w l ,"SEMgali/E_SEMgali.txt" every :::0::0 u 1:3 t "e12" w l ,"SEMgali/E_SEMgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "SEMgali/EXP_SEMgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "SEMgali/E_SEMgali.txt" every :::0::0 u 1:5 t "e21" w l ,"SEMgali/E_SEMgali.txt" every :::0::0 u 1:6 t "e22" w l ,"SEMgali/E_SEMgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "SEMgali/LIJ_SEMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEMgali/PIJ_SEMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "SEMgali/LIJ_SEMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEMgali/PIJ_SEMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "SEMgali/LIJT_SEMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEMgali/PIJ_SEMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "SEMgali/LIJT_SEMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEMgali/PIJ_SEMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "SEMgali/P_SEMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEMgali/PIJ_SEMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "SEMgali/P_SEMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEMgali/PIJ_SEMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-8.651575; p2=0.072788; 
#   current state 3
p3=-17.096585; p4=0.162962; 
# initial state 2
#   current state 1
p5=-0.822623; p6=-0.013413; 
#   current state 3
p7=-8.965924; p8=0.082392; 
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

set out "SEMgali/PE_SEMgali_1-1-1.svg" 
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

set out "SEMgali/PE_SEMgali_1-2-1.svg" 
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

set out "SEMgali/PE_SEMgali_1-3-1.svg" 
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
set out "SEMgali/VARPIJGR_SEMgali_113-12.svg"
set label "50" at  2.581e-004, 1.322e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  2.581e-004+ 2.000*( 6.300e-003* 3.639e-003*cos(t)+ 1.000e+000* 2.257e-004*sin(t)),  1.322e-002 +2.000*(-1.000e+000* 3.639e-003*cos(t)+ 6.300e-003* 2.257e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  5.812e-004, 1.897e-002 center
replot  5.812e-004+ 2.000*( 1.125e-002* 4.225e-003*cos(t)+ 9.999e-001* 4.325e-004*sin(t)),  1.897e-002 +2.000*(-9.999e-001* 4.225e-003*cos(t)+ 1.125e-002* 4.325e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.307e-003, 2.717e-002 center
replot  1.307e-003+ 2.000*( 2.145e-002* 4.740e-003*cos(t)+ 9.998e-001* 8.051e-004*sin(t)),  2.717e-002 +2.000*(-9.998e-001* 4.740e-003*cos(t)+ 2.145e-002* 8.051e-004*sin(t)) not
# Age 65, p13 - p12
set label "65" at  2.932e-003, 3.884e-002 center
replot  2.932e-003+ 2.000*( 4.427e-002* 5.235e-003*cos(t)+ 9.990e-001* 1.442e-003*sin(t)),  3.884e-002 +2.000*(-9.990e-001* 5.235e-003*cos(t)+ 4.427e-002* 1.442e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  6.555e-003, 5.532e-002 center
replot  6.555e-003+ 2.000*( 8.890e-002* 6.240e-003*cos(t)+ 9.960e-001* 2.461e-003*sin(t)),  5.532e-002 +2.000*(-9.960e-001* 6.240e-003*cos(t)+ 8.890e-002* 2.461e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.457e-002, 7.832e-002 center
replot  1.457e-002+ 2.000*( 1.320e-001* 9.222e-003*cos(t)+ 9.912e-001* 4.071e-003*sin(t)),  7.832e-002 +2.000*(-9.912e-001* 9.222e-003*cos(t)+ 1.320e-001* 4.071e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.206e-002, 1.098e-001 center
replot  3.206e-002+ 2.000*( 1.697e-001* 1.601e-002*cos(t)+ 9.855e-001* 7.298e-003*sin(t)),  1.098e-001 +2.000*(-9.855e-001* 1.601e-002*cos(t)+ 1.697e-001* 7.298e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  6.935e-002, 1.513e-001 center
replot  6.935e-002+ 2.000*( 2.971e-001* 2.848e-002*cos(t)+ 9.549e-001* 1.653e-002*sin(t)),  1.513e-001 +2.000*(-9.549e-001* 2.848e-002*cos(t)+ 2.971e-001* 1.653e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.455e-001, 2.022e-001 center
replot  1.455e-001+ 2.000*( 7.361e-001* 5.402e-002*cos(t)+ 6.769e-001* 3.735e-002*sin(t)),  2.022e-001 +2.000*(-6.769e-001* 5.402e-002*cos(t)+ 7.361e-001* 3.735e-002*sin(t)) not
set out;
set out "SEMgali/VARPIJGR_SEMgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "SEMgali/VARPIJGR_SEMgali_121-12.svg"
set label "50" at  3.645e-001, 1.322e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  3.645e-001+ 2.000*( 9.999e-001* 9.549e-002*cos(t)+-1.052e-002* 3.498e-003*sin(t)),  1.322e-002 +2.000*( 1.052e-002* 9.549e-002*cos(t)+ 9.999e-001* 3.498e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.438e-001, 1.897e-002 center
replot  3.438e-001+ 2.000*( 9.999e-001* 7.212e-002*cos(t)+-1.581e-002* 4.069e-003*sin(t)),  1.897e-002 +2.000*( 1.581e-002* 7.212e-002*cos(t)+ 9.999e-001* 4.069e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.235e-001, 2.717e-002 center
replot  3.235e-001+ 2.000*( 9.997e-001* 5.306e-002*cos(t)+-2.373e-002* 4.570e-003*sin(t)),  2.717e-002 +2.000*( 2.373e-002* 5.306e-002*cos(t)+ 9.997e-001* 4.570e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.034e-001, 3.884e-002 center
replot  3.034e-001+ 2.000*( 9.994e-001* 4.071e-002*cos(t)+-3.530e-002* 5.032e-003*sin(t)),  3.884e-002 +2.000*( 3.530e-002* 4.071e-002*cos(t)+ 9.994e-001* 5.032e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.833e-001, 5.532e-002 center
replot  2.833e-001+ 2.000*( 9.987e-001* 3.792e-002*cos(t)+-5.169e-002* 5.910e-003*sin(t)),  5.532e-002 +2.000*( 5.169e-002* 3.792e-002*cos(t)+ 9.987e-001* 5.910e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.628e-001, 7.832e-002 center
replot  2.628e-001+ 2.000*( 9.971e-001* 4.344e-002*cos(t)+-7.620e-002* 8.563e-003*sin(t)),  7.832e-002 +2.000*( 7.620e-002* 4.344e-002*cos(t)+ 9.971e-001* 8.563e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.416e-001, 1.098e-001 center
replot  2.416e-001+ 2.000*( 9.934e-001* 5.244e-002*cos(t)+-1.150e-001* 1.473e-002*sin(t)),  1.098e-001 +2.000*( 1.150e-001* 5.244e-002*cos(t)+ 9.934e-001* 1.473e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  2.193e-001, 1.513e-001 center
replot  2.193e-001+ 2.000*( 9.836e-001* 6.166e-002*cos(t)+-1.805e-001* 2.571e-002*sin(t)),  1.513e-001 +2.000*( 1.805e-001* 6.166e-002*cos(t)+ 9.836e-001* 2.571e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.956e-001, 2.022e-001 center
replot  1.956e-001+ 2.000*( 9.496e-001* 6.999e-002*cos(t)+-3.134e-001* 4.227e-002*sin(t)),  2.022e-001 +2.000*( 3.134e-001* 6.999e-002*cos(t)+ 9.496e-001* 4.227e-002*sin(t)) not
set out;
set out "SEMgali/VARPIJGR_SEMgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "SEMgali/VARPIJGR_SEMgali_123-12.svg"
set label "50" at  1.275e-002, 1.322e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  1.275e-002+ 2.000*( 9.993e-001* 9.264e-003*cos(t)+-3.801e-002* 3.625e-003*sin(t)),  1.322e-002 +2.000*( 3.801e-002* 9.264e-003*cos(t)+ 9.993e-001* 3.625e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.942e-002, 1.897e-002 center
replot  1.942e-002+ 2.000*( 9.994e-001* 1.184e-002*cos(t)+-3.403e-002* 4.208e-003*sin(t)),  1.897e-002 +2.000*( 3.403e-002* 1.184e-002*cos(t)+ 9.994e-001* 4.208e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  2.950e-002, 2.717e-002 center
replot  2.950e-002+ 2.000*( 9.995e-001* 1.466e-002*cos(t)+-3.182e-002* 4.719e-003*sin(t)),  2.717e-002 +2.000*( 3.182e-002* 1.466e-002*cos(t)+ 9.995e-001* 4.719e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  4.467e-002, 3.884e-002 center
replot  4.467e-002+ 2.000*( 9.994e-001* 1.749e-002*cos(t)+-3.394e-002* 5.200e-003*sin(t)),  3.884e-002 +2.000*( 3.394e-002* 1.749e-002*cos(t)+ 9.994e-001* 5.200e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  6.733e-002, 5.532e-002 center
replot  6.733e-002+ 2.000*( 9.989e-001* 2.028e-002*cos(t)+-4.775e-002* 6.150e-003*sin(t)),  5.532e-002 +2.000*( 4.775e-002* 2.028e-002*cos(t)+ 9.989e-001* 6.150e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.009e-001, 7.832e-002 center
replot  1.009e-001+ 2.000*( 9.962e-001* 2.436e-002*cos(t)+-8.687e-002* 8.943e-003*sin(t)),  7.832e-002 +2.000*( 8.687e-002* 2.436e-002*cos(t)+ 9.962e-001* 8.943e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.497e-001, 1.098e-001 center
replot  1.497e-001+ 2.000*( 9.909e-001* 3.480e-002*cos(t)+-1.347e-001* 1.526e-002*sin(t)),  1.098e-001 +2.000*( 1.347e-001* 3.480e-002*cos(t)+ 9.909e-001* 1.526e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  2.194e-001, 1.513e-001 center
replot  2.194e-001+ 2.000*( 9.901e-001* 5.930e-002*cos(t)+-1.407e-001* 2.661e-002*sin(t)),  1.513e-001 +2.000*( 1.407e-001* 5.930e-002*cos(t)+ 9.901e-001* 2.661e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  3.158e-001, 2.022e-001 center
replot  3.158e-001+ 2.000*( 9.916e-001* 1.036e-001*cos(t)+-1.292e-001* 4.411e-002*sin(t)),  2.022e-001 +2.000*( 1.292e-001* 1.036e-001*cos(t)+ 9.916e-001* 4.411e-002*sin(t)) not
set out;
set out "SEMgali/VARPIJGR_SEMgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "SEMgali/VARPIJGR_SEMgali_121-13.svg"
set label "50" at  3.645e-001, 2.581e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  3.645e-001+ 2.000*( 1.000e+000* 9.549e-002*cos(t)+-5.009e-005* 2.268e-004*sin(t)),  2.581e-004 +2.000*( 5.009e-005* 9.549e-002*cos(t)+ 1.000e+000* 2.268e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.438e-001, 5.812e-004 center
replot  3.438e-001+ 2.000*( 1.000e+000* 7.211e-002*cos(t)+-1.254e-004* 4.350e-004*sin(t)),  5.812e-004 +2.000*( 1.254e-004* 7.211e-002*cos(t)+ 1.000e+000* 4.350e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.235e-001, 1.307e-003 center
replot  3.235e-001+ 2.000*( 1.000e+000* 5.305e-002*cos(t)+-3.285e-004* 8.112e-004*sin(t)),  1.307e-003 +2.000*( 3.285e-004* 5.305e-002*cos(t)+ 1.000e+000* 8.112e-004*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.034e-001, 2.932e-003 center
replot  3.034e-001+ 2.000*( 1.000e+000* 4.069e-002*cos(t)+-8.696e-004* 1.459e-003*sin(t)),  2.932e-003 +2.000*( 8.696e-004* 4.069e-002*cos(t)+ 1.000e+000* 1.459e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.833e-001, 6.555e-003 center
replot  2.833e-001+ 2.000*( 1.000e+000* 3.787e-002*cos(t)+-2.027e-003* 2.512e-003*sin(t)),  6.555e-003 +2.000*( 2.027e-003* 3.787e-002*cos(t)+ 1.000e+000* 2.512e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.628e-001, 1.457e-002 center
replot  2.628e-001+ 2.000*( 1.000e+000* 4.332e-002*cos(t)+-4.284e-003* 4.211e-003*sin(t)),  1.457e-002 +2.000*( 4.284e-003* 4.332e-002*cos(t)+ 1.000e+000* 4.211e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.416e-001, 3.206e-002 center
replot  2.416e-001+ 2.000*( 1.000e+000* 5.212e-002*cos(t)+-9.876e-003* 7.671e-003*sin(t)),  3.206e-002 +2.000*( 9.876e-003* 5.212e-002*cos(t)+ 1.000e+000* 7.671e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  2.193e-001, 6.935e-002 center
replot  2.193e-001+ 2.000*( 9.996e-001* 6.084e-002*cos(t)+-2.674e-002* 1.784e-002*sin(t)),  6.935e-002 +2.000*( 2.674e-002* 6.084e-002*cos(t)+ 9.996e-001* 1.784e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.956e-001, 1.455e-001 center
replot  1.956e-001+ 2.000*( 9.924e-001* 6.805e-002*cos(t)+-1.233e-001* 4.672e-002*sin(t)),  1.455e-001 +2.000*( 1.233e-001* 6.805e-002*cos(t)+ 9.924e-001* 4.672e-002*sin(t)) not
set out;
set out "SEMgali/VARPIJGR_SEMgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "SEMgali/VARPIJGR_SEMgali_123-13.svg"
set label "50" at  1.275e-002, 2.581e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  1.275e-002+ 2.000*( 1.000e+000* 9.259e-003*cos(t)+ 7.892e-003* 2.148e-004*sin(t)),  2.581e-004 +2.000*(-7.892e-003* 9.259e-003*cos(t)+ 1.000e+000* 2.148e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.942e-002, 5.812e-004 center
replot  1.942e-002+ 2.000*( 9.999e-001* 1.183e-002*cos(t)+ 1.206e-002* 4.110e-004*sin(t)),  5.812e-004 +2.000*(-1.206e-002* 1.183e-002*cos(t)+ 9.999e-001* 4.110e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  2.950e-002, 1.307e-003 center
replot  2.950e-002+ 2.000*( 9.998e-001* 1.465e-002*cos(t)+ 1.871e-002* 7.638e-004*sin(t)),  1.307e-003 +2.000*(-1.871e-002* 1.465e-002*cos(t)+ 9.998e-001* 7.638e-004*sin(t)) not
# Age 65, p23 - p13
set label "65" at  4.467e-002, 2.932e-003 center
replot  4.467e-002+ 2.000*( 9.996e-001* 1.748e-002*cos(t)+ 2.959e-002* 1.365e-003*sin(t)),  2.932e-003 +2.000*(-2.959e-002* 1.748e-002*cos(t)+ 9.996e-001* 1.365e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  6.733e-002, 6.555e-003 center
replot  6.733e-002+ 2.000*( 9.989e-001* 2.028e-002*cos(t)+ 4.761e-002* 2.323e-003*sin(t)),  6.555e-003 +2.000*(-4.761e-002* 2.028e-002*cos(t)+ 9.989e-001* 2.323e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.009e-001, 1.457e-002 center
replot  1.009e-001+ 2.000*( 9.973e-001* 2.434e-002*cos(t)+ 7.408e-002* 3.821e-003*sin(t)),  1.457e-002 +2.000*(-7.408e-002* 2.434e-002*cos(t)+ 9.973e-001* 3.821e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.497e-001, 3.206e-002 center
replot  1.497e-001+ 2.000*( 9.949e-001* 3.471e-002*cos(t)+ 1.011e-001* 6.875e-003*sin(t)),  3.206e-002 +2.000*(-1.011e-001* 3.471e-002*cos(t)+ 9.949e-001* 6.875e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  2.194e-001, 6.935e-002 center
replot  2.194e-001+ 2.000*( 9.910e-001* 5.932e-002*cos(t)+ 1.337e-001* 1.620e-002*sin(t)),  6.935e-002 +2.000*(-1.337e-001* 5.932e-002*cos(t)+ 9.910e-001* 1.620e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  3.158e-001, 1.455e-001 center
replot  3.158e-001+ 2.000*( 9.795e-001* 1.047e-001*cos(t)+ 2.014e-001* 4.302e-002*sin(t)),  1.455e-001 +2.000*(-2.014e-001* 1.047e-001*cos(t)+ 9.795e-001* 4.302e-002*sin(t)) not
set out;
set out "SEMgali/VARPIJGR_SEMgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "SEMgali/VARPIJGR_SEMgali_123-21.svg"
set label "50" at  1.275e-002, 3.645e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.275e-002+ 2.000*( 4.424e-003* 9.549e-002*cos(t)+ 1.000e+000* 9.249e-003*sin(t)),  3.645e-001 +2.000*(-1.000e+000* 9.549e-002*cos(t)+ 4.424e-003* 9.249e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.942e-002, 3.438e-001 center
replot  1.942e-002+ 2.000*( 7.724e-003* 7.211e-002*cos(t)+ 1.000e+000* 1.182e-002*sin(t)),  3.438e-001 +2.000*(-1.000e+000* 7.211e-002*cos(t)+ 7.724e-003* 1.182e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  2.950e-002, 3.235e-001 center
replot  2.950e-002+ 2.000*( 1.556e-002* 5.306e-002*cos(t)+ 9.999e-001* 1.463e-002*sin(t)),  3.235e-001 +2.000*(-9.999e-001* 5.306e-002*cos(t)+ 1.556e-002* 1.463e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  4.467e-002, 3.034e-001 center
replot  4.467e-002+ 2.000*( 3.436e-002* 4.071e-002*cos(t)+ 9.994e-001* 1.743e-002*sin(t)),  3.034e-001 +2.000*(-9.994e-001* 4.071e-002*cos(t)+ 3.436e-002* 1.743e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  6.733e-002, 2.833e-001 center
replot  6.733e-002+ 2.000*( 6.002e-002* 3.792e-002*cos(t)+ 9.982e-001* 2.016e-002*sin(t)),  2.833e-001 +2.000*(-9.982e-001* 3.792e-002*cos(t)+ 6.002e-002* 2.016e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.009e-001, 2.628e-001 center
replot  1.009e-001+ 2.000*( 7.787e-002* 4.341e-002*cos(t)+ 9.970e-001* 2.411e-002*sin(t)),  2.628e-001 +2.000*(-9.970e-001* 4.341e-002*cos(t)+ 7.787e-002* 2.411e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.497e-001, 2.416e-001 center
replot  1.497e-001+ 2.000*( 1.368e-001* 5.240e-002*cos(t)+ 9.906e-001* 3.411e-002*sin(t)),  2.416e-001 +2.000*(-9.906e-001* 5.240e-002*cos(t)+ 1.368e-001* 3.411e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  2.194e-001, 2.193e-001 center
replot  2.194e-001+ 2.000*( 6.270e-001* 6.433e-002*cos(t)+ 7.790e-001* 5.497e-002*sin(t)),  2.193e-001 +2.000*(-7.790e-001* 6.433e-002*cos(t)+ 6.270e-001* 5.497e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  3.158e-001, 1.956e-001 center
replot  3.158e-001+ 2.000*( 9.757e-001* 1.045e-001*cos(t)+ 2.192e-001* 6.538e-002*sin(t)),  1.956e-001 +2.000*(-2.192e-001* 1.045e-001*cos(t)+ 9.757e-001* 6.538e-002*sin(t)) not
set out;
set out "SEMgali/VARPIJGR_SEMgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "SEMgali/VARMUPTJGR--STABLBASED_SEMgali1.svg";
 plot "SEMgali/PRMORPREV-1-STABLBASED_SEMgali.txt"  u 1:($3) not w l lt 1 
 replot "SEMgali/PRMORPREV-1-STABLBASED_SEMgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "SEMgali/PRMORPREV-1-STABLBASED_SEMgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "SEMgali/VARMUPTJGR--STABLBASED_SEMgali1.svg";replot;set out;
