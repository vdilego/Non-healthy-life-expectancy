
# IMaCh-0.99r45
# CZFchr.gp
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


set ter svg size 640, 480;set out "CZFchr/D_CZFchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "CZFchr/ILK_CZFchr-dest.png";
set log y;plot  "CZFchr/ILK_CZFchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "CZFchr/ILK_CZFchr-ori.png";
set log y;plot  "CZFchr/ILK_CZFchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "CZFchr/ILK_CZFchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "CZFchr/ILK_CZFchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "CZFchr/ILK_CZFchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "CZFchr/ILK_CZFchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "CZFchr/V_CZFchr_1-1-1.svg" 

#set out "V_CZFchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "CZFchr/VPL_CZFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"CZFchr/VPL_CZFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"CZFchr/VPL_CZFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"CZFchr/P_CZFchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "CZFchr/V_CZFchr_2-1-1.svg" 

#set out "V_CZFchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "CZFchr/VPL_CZFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"CZFchr/VPL_CZFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"CZFchr/VPL_CZFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"CZFchr/P_CZFchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "CZFchr/E_CZFchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "CZFchr/T_CZFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"CZFchr/T_CZFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"CZFchr/T_CZFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"CZFchr/T_CZFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"CZFchr/T_CZFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"CZFchr/T_CZFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"CZFchr/T_CZFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"CZFchr/T_CZFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"CZFchr/T_CZFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "CZFchr/E_CZFchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "CZFchr/EXP_CZFchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "CZFchr/E_CZFchr.txt" every :::0::0 u 1:2 t "e11" w l ,"CZFchr/E_CZFchr.txt" every :::0::0 u 1:3 t "e12" w l ,"CZFchr/E_CZFchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "CZFchr/EXP_CZFchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "CZFchr/E_CZFchr.txt" every :::0::0 u 1:5 t "e21" w l ,"CZFchr/E_CZFchr.txt" every :::0::0 u 1:6 t "e22" w l ,"CZFchr/E_CZFchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "CZFchr/LIJ_CZFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFchr/PIJ_CZFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "CZFchr/LIJ_CZFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFchr/PIJ_CZFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "CZFchr/LIJT_CZFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFchr/PIJ_CZFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "CZFchr/LIJT_CZFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFchr/PIJ_CZFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "CZFchr/P_CZFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFchr/PIJ_CZFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "CZFchr/P_CZFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZFchr/PIJ_CZFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-1.236188; p2=0.014251; 
#   current state 3
p3=-17.156433; p4=0.190889; 
# initial state 2
#   current state 1
p5=-0.157271; p6=-0.041249; 
#   current state 3
p7=-12.872371; p8=0.136925; 
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

set out "CZFchr/PE_CZFchr_1-1-1.svg" 
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

set out "CZFchr/PE_CZFchr_1-2-1.svg" 
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

set out "CZFchr/PE_CZFchr_1-3-1.svg" 
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
set out "CZFchr/VARPIJGR_CZFchr_113-12.svg"
set label "50" at  1.552e-004, 1.859e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  1.552e-004+ 2.000*( 6.424e-005* 2.339e-002*cos(t)+ 1.000e+000* 2.548e-004*sin(t)),  1.859e-001 +2.000*(-1.000e+000* 2.339e-002*cos(t)+ 6.424e-005* 2.548e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  3.922e-004, 1.942e-001 center
replot  3.922e-004+ 2.000*( 3.631e-004* 1.766e-002*cos(t)+ 1.000e+000* 5.408e-004*sin(t)),  1.942e-001 +2.000*(-1.000e+000* 1.766e-002*cos(t)+ 3.631e-004* 5.408e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  9.890e-004, 2.025e-001 center
replot  9.890e-004+ 2.000*( 2.272e-003* 1.368e-002*cos(t)+ 1.000e+000* 1.110e-003*sin(t)),  2.025e-001 +2.000*(-1.000e+000* 1.368e-002*cos(t)+ 2.272e-003* 1.110e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  2.486e-003, 2.105e-001 center
replot  2.486e-003+ 2.000*( 9.688e-003* 1.362e-002*cos(t)+ 1.000e+000* 2.177e-003*sin(t)),  2.105e-001 +2.000*(-1.000e+000* 1.362e-002*cos(t)+ 9.688e-003* 2.177e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  6.215e-003, 2.176e-001 center
replot  6.215e-003+ 2.000*( 2.411e-002* 1.771e-002*cos(t)+ 9.997e-001* 4.056e-003*sin(t)),  2.176e-001 +2.000*(-9.997e-001* 1.771e-002*cos(t)+ 2.411e-002* 4.056e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.534e-002, 2.221e-001 center
replot  1.534e-002+ 2.000*( 5.696e-002* 2.386e-002*cos(t)+ 9.984e-001* 7.429e-003*sin(t)),  2.221e-001 +2.000*(-9.984e-001* 2.386e-002*cos(t)+ 5.696e-002* 7.429e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.684e-002, 2.205e-001 center
replot  3.684e-002+ 2.000*( 2.032e-001* 3.112e-002*cos(t)+ 9.791e-001* 1.521e-002*sin(t)),  2.205e-001 +2.000*(-9.791e-001* 3.112e-002*cos(t)+ 2.032e-001* 1.521e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  8.318e-002, 2.058e-001 center
replot  8.318e-002+ 2.000*( 7.251e-001* 5.014e-002*cos(t)+ 6.886e-001* 2.657e-002*sin(t)),  2.058e-001 +2.000*(-6.886e-001* 5.014e-002*cos(t)+ 7.251e-001* 2.657e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.667e-001, 1.705e-001 center
replot  1.667e-001+ 2.000*( 8.594e-001* 1.002e-001*cos(t)+ 5.113e-001* 2.733e-002*sin(t)),  1.705e-001 +2.000*(-5.113e-001* 1.002e-001*cos(t)+ 8.594e-001* 2.733e-002*sin(t)) not
set out;
set out "CZFchr/VARPIJGR_CZFchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "CZFchr/VARPIJGR_CZFchr_121-12.svg"
set label "50" at  4.889e-002, 1.859e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  4.889e-002+ 2.000*( 8.118e-003* 2.339e-002*cos(t)+-1.000e+000* 8.307e-003*sin(t)),  1.859e-001 +2.000*( 1.000e+000* 2.339e-002*cos(t)+ 8.118e-003* 8.307e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  4.043e-002, 1.942e-001 center
replot  4.043e-002+ 2.000*( 6.729e-003* 1.766e-002*cos(t)+-1.000e+000* 5.333e-003*sin(t)),  1.942e-001 +2.000*( 1.000e+000* 1.766e-002*cos(t)+ 6.729e-003* 5.333e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.325e-002, 2.025e-001 center
replot  3.325e-002+ 2.000*( 5.874e-003* 1.368e-002*cos(t)+-1.000e+000* 3.450e-003*sin(t)),  2.025e-001 +2.000*( 1.000e+000* 1.368e-002*cos(t)+ 5.874e-003* 3.450e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.716e-002, 2.105e-001 center
replot  2.716e-002+ 2.000*( 4.921e-003* 1.362e-002*cos(t)+-1.000e+000* 2.662e-003*sin(t)),  2.105e-001 +2.000*( 1.000e+000* 1.362e-002*cos(t)+ 4.921e-003* 2.662e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.194e-002, 2.176e-001 center
replot  2.194e-002+ 2.000*( 3.670e-003* 1.771e-002*cos(t)+-1.000e+000* 2.633e-003*sin(t)),  2.176e-001 +2.000*( 1.000e+000* 1.771e-002*cos(t)+ 3.670e-003* 2.633e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.741e-002, 2.221e-001 center
replot  1.741e-002+ 2.000*( 2.625e-003* 2.383e-002*cos(t)+-1.000e+000* 2.778e-003*sin(t)),  2.221e-001 +2.000*( 1.000e+000* 2.383e-002*cos(t)+ 2.625e-003* 2.778e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.337e-002, 2.205e-001 center
replot  1.337e-002+ 2.000*( 1.717e-003* 3.062e-002*cos(t)+-1.000e+000* 2.778e-003*sin(t)),  2.205e-001 +2.000*( 1.000e+000* 3.062e-002*cos(t)+ 1.717e-003* 2.778e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  9.737e-003, 2.058e-001 center
replot  9.737e-003+ 2.000*( 7.473e-004* 3.954e-002*cos(t)+-1.000e+000* 2.540e-003*sin(t)),  2.058e-001 +2.000*( 1.000e+000* 3.954e-002*cos(t)+ 7.473e-004* 2.540e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  6.527e-003, 1.705e-001 center
replot  6.527e-003+ 2.000*( 1.624e-005* 5.637e-002*cos(t)+-1.000e+000* 2.088e-003*sin(t)),  1.705e-001 +2.000*( 1.000e+000* 5.637e-002*cos(t)+ 1.624e-005* 2.088e-003*sin(t)) not
set out;
set out "CZFchr/VARPIJGR_CZFchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "CZFchr/VARPIJGR_CZFchr_123-12.svg"
set label "50" at  1.087e-003, 1.859e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  1.087e-003+ 2.000*( 1.099e-004* 2.339e-002*cos(t)+-1.000e+000* 4.090e-004*sin(t)),  1.859e-001 +2.000*( 1.000e+000* 2.339e-002*cos(t)+ 1.099e-004* 4.090e-004*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.190e-003, 1.942e-001 center
replot  2.190e-003+ 2.000*( 1.492e-004* 1.766e-002*cos(t)+-1.000e+000* 6.873e-004*sin(t)),  1.942e-001 +2.000*( 1.000e+000* 1.766e-002*cos(t)+ 1.492e-004* 6.873e-004*sin(t)) not
# Age 60, p23 - p12
set label "60" at  4.391e-003, 2.025e-001 center
replot  4.391e-003+ 2.000*( 3.773e-006* 1.368e-002*cos(t)+-1.000e+000* 1.109e-003*sin(t)),  2.025e-001 +2.000*( 1.000e+000* 1.368e-002*cos(t)+ 3.773e-006* 1.109e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  8.740e-003, 2.105e-001 center
replot  8.740e-003+ 2.000*( 2.956e-004* 1.362e-002*cos(t)+ 1.000e+000* 1.695e-003*sin(t)),  2.105e-001 +2.000*(-1.000e+000* 1.362e-002*cos(t)+ 2.956e-004* 1.695e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  1.721e-002, 2.176e-001 center
replot  1.721e-002+ 2.000*( 1.729e-004* 1.771e-002*cos(t)+-1.000e+000* 2.437e-003*sin(t)),  2.176e-001 +2.000*( 1.000e+000* 1.771e-002*cos(t)+ 1.729e-004* 2.437e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  3.327e-002, 2.221e-001 center
replot  3.327e-002+ 2.000*( 1.737e-003* 2.383e-002*cos(t)+-1.000e+000* 3.474e-003*sin(t)),  2.221e-001 +2.000*( 1.000e+000* 2.383e-002*cos(t)+ 1.737e-003* 3.474e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  6.231e-002, 2.205e-001 center
replot  6.231e-002+ 2.000*( 5.386e-003* 3.062e-002*cos(t)+-1.000e+000* 5.965e-003*sin(t)),  2.205e-001 +2.000*( 1.000e+000* 3.062e-002*cos(t)+ 5.386e-003* 5.965e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.106e-001, 2.058e-001 center
replot  1.106e-001+ 2.000*( 1.319e-002* 3.954e-002*cos(t)+-9.999e-001* 1.213e-002*sin(t)),  2.058e-001 +2.000*( 9.999e-001* 3.954e-002*cos(t)+ 1.319e-002* 1.213e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.806e-001, 1.705e-001 center
replot  1.806e-001+ 2.000*( 2.002e-002* 5.638e-002*cos(t)+-9.998e-001* 2.195e-002*sin(t)),  1.705e-001 +2.000*( 9.998e-001* 5.638e-002*cos(t)+ 2.002e-002* 2.195e-002*sin(t)) not
set out;
set out "CZFchr/VARPIJGR_CZFchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "CZFchr/VARPIJGR_CZFchr_121-13.svg"
set label "50" at  4.889e-002, 1.552e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  4.889e-002+ 2.000*( 1.000e+000* 8.309e-003*cos(t)+-8.946e-005* 2.548e-004*sin(t)),  1.552e-004 +2.000*( 8.946e-005* 8.309e-003*cos(t)+ 1.000e+000* 2.548e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  4.043e-002, 3.922e-004 center
replot  4.043e-002+ 2.000*( 1.000e+000* 5.334e-003*cos(t)+-4.880e-004* 5.408e-004*sin(t)),  3.922e-004 +2.000*( 4.880e-004* 5.334e-003*cos(t)+ 1.000e+000* 5.408e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.325e-002, 9.890e-004 center
replot  3.325e-002+ 2.000*( 1.000e+000* 3.451e-003*cos(t)+-2.859e-003* 1.110e-003*sin(t)),  9.890e-004 +2.000*( 2.859e-003* 3.451e-003*cos(t)+ 1.000e+000* 1.110e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.716e-002, 2.486e-003 center
replot  2.716e-002+ 2.000*( 9.996e-001* 2.663e-003*cos(t)+-2.854e-002* 2.181e-003*sin(t)),  2.486e-003 +2.000*( 2.854e-002* 2.663e-003*cos(t)+ 9.996e-001* 2.181e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.194e-002, 6.215e-003 center
replot  2.194e-002+ 2.000*( 1.448e-002* 4.078e-003*cos(t)+-9.999e-001* 2.633e-003*sin(t)),  6.215e-003 +2.000*( 9.999e-001* 4.078e-003*cos(t)+ 1.448e-002* 2.633e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.741e-002, 1.534e-002 center
replot  1.741e-002+ 2.000*( 5.786e-003* 7.540e-003*cos(t)+-1.000e+000* 2.779e-003*sin(t)),  1.534e-002 +2.000*( 1.000e+000* 7.540e-003*cos(t)+ 5.786e-003* 2.779e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.337e-002, 3.684e-002 center
replot  1.337e-002+ 2.000*( 2.236e-003* 1.618e-002*cos(t)+-1.000e+000* 2.778e-003*sin(t)),  3.684e-002 +2.000*( 1.000e+000* 1.618e-002*cos(t)+ 2.236e-003* 2.778e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  9.737e-003, 8.318e-002 center
replot  9.737e-003+ 2.000*( 7.085e-004* 4.070e-002*cos(t)+-1.000e+000* 2.540e-003*sin(t)),  8.318e-002 +2.000*( 1.000e+000* 4.070e-002*cos(t)+ 7.085e-004* 2.540e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  6.527e-003, 1.667e-001 center
replot  6.527e-003+ 2.000*( 2.918e-004* 8.726e-002*cos(t)+-1.000e+000* 2.088e-003*sin(t)),  1.667e-001 +2.000*( 1.000e+000* 8.726e-002*cos(t)+ 2.918e-004* 2.088e-003*sin(t)) not
set out;
set out "CZFchr/VARPIJGR_CZFchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "CZFchr/VARPIJGR_CZFchr_123-13.svg"
set label "50" at  1.087e-003, 1.552e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  1.087e-003+ 2.000*( 9.997e-001* 4.091e-004*cos(t)+ 2.275e-002* 2.547e-004*sin(t)),  1.552e-004 +2.000*(-2.275e-002* 4.091e-004*cos(t)+ 9.997e-001* 2.547e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.190e-003, 3.922e-004 center
replot  2.190e-003+ 2.000*( 9.990e-001* 6.875e-004*cos(t)+ 4.419e-002* 5.405e-004*sin(t)),  3.922e-004 +2.000*(-4.419e-002* 6.875e-004*cos(t)+ 9.990e-001* 5.405e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  4.391e-003, 9.890e-004 center
replot  4.391e-003+ 2.000*( 6.838e-001* 1.121e-003*cos(t)+ 7.296e-001* 1.098e-003*sin(t)),  9.890e-004 +2.000*(-7.296e-001* 1.121e-003*cos(t)+ 6.838e-001* 1.098e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  8.740e-003, 2.486e-003 center
replot  8.740e-003+ 2.000*( 3.669e-002* 2.182e-003*cos(t)+ 9.993e-001* 1.695e-003*sin(t)),  2.486e-003 +2.000*(-9.993e-001* 2.182e-003*cos(t)+ 3.669e-002* 1.695e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  1.721e-002, 6.215e-003 center
replot  1.721e-002+ 2.000*( 1.658e-002* 4.078e-003*cos(t)+ 9.999e-001* 2.437e-003*sin(t)),  6.215e-003 +2.000*(-9.999e-001* 4.078e-003*cos(t)+ 1.658e-002* 2.437e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  3.327e-002, 1.534e-002 center
replot  3.327e-002+ 2.000*( 1.267e-002* 7.541e-003*cos(t)+ 9.999e-001* 3.473e-003*sin(t)),  1.534e-002 +2.000*(-9.999e-001* 7.541e-003*cos(t)+ 1.267e-002* 3.473e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  6.231e-002, 3.684e-002 center
replot  6.231e-002+ 2.000*( 1.434e-002* 1.618e-002*cos(t)+ 9.999e-001* 5.963e-003*sin(t)),  3.684e-002 +2.000*(-9.999e-001* 1.618e-002*cos(t)+ 1.434e-002* 5.963e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.106e-001, 8.318e-002 center
replot  1.106e-001+ 2.000*( 1.300e-002* 4.070e-002*cos(t)+ 9.999e-001* 1.213e-002*sin(t)),  8.318e-002 +2.000*(-9.999e-001* 4.070e-002*cos(t)+ 1.300e-002* 1.213e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.806e-001, 1.667e-001 center
replot  1.806e-001+ 2.000*( 1.055e-002* 8.726e-002*cos(t)+ 9.999e-001* 2.196e-002*sin(t)),  1.667e-001 +2.000*(-9.999e-001* 8.726e-002*cos(t)+ 1.055e-002* 2.196e-002*sin(t)) not
set out;
set out "CZFchr/VARPIJGR_CZFchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "CZFchr/VARPIJGR_CZFchr_123-21.svg"
set label "50" at  1.087e-003, 4.889e-002 center
# Age 50, p23 - p21
plot [-pi:pi]  1.087e-003+ 2.000*( 1.685e-003* 8.309e-003*cos(t)+ 1.000e+000* 4.088e-004*sin(t)),  4.889e-002 +2.000*(-1.000e+000* 8.309e-003*cos(t)+ 1.685e-003* 4.088e-004*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.190e-003, 4.043e-002 center
replot  2.190e-003+ 2.000*( 3.478e-003* 5.334e-003*cos(t)+ 1.000e+000* 6.870e-004*sin(t)),  4.043e-002 +2.000*(-1.000e+000* 5.334e-003*cos(t)+ 3.478e-003* 6.870e-004*sin(t)) not
# Age 60, p23 - p21
set label "60" at  4.391e-003, 3.325e-002 center
replot  4.391e-003+ 2.000*( 9.704e-003* 3.451e-003*cos(t)+ 1.000e+000* 1.108e-003*sin(t)),  3.325e-002 +2.000*(-1.000e+000* 3.451e-003*cos(t)+ 9.704e-003* 1.108e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  8.740e-003, 2.716e-002 center
replot  8.740e-003+ 2.000*( 3.865e-002* 2.664e-003*cos(t)+ 9.993e-001* 1.693e-003*sin(t)),  2.716e-002 +2.000*(-9.993e-001* 2.664e-003*cos(t)+ 3.865e-002* 1.693e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  1.721e-002, 2.194e-002 center
replot  1.721e-002+ 2.000*( 2.631e-001* 2.648e-003*cos(t)+ 9.648e-001* 2.421e-003*sin(t)),  2.194e-002 +2.000*(-9.648e-001* 2.648e-003*cos(t)+ 2.631e-001* 2.421e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  3.327e-002, 1.741e-002 center
replot  3.327e-002+ 2.000*( 9.933e-001* 3.483e-003*cos(t)+ 1.155e-001* 2.768e-003*sin(t)),  1.741e-002 +2.000*(-1.155e-001* 3.483e-003*cos(t)+ 9.933e-001* 2.768e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  6.231e-002, 1.337e-002 center
replot  6.231e-002+ 2.000*( 9.992e-001* 5.971e-003*cos(t)+ 4.061e-002* 2.770e-003*sin(t)),  1.337e-002 +2.000*(-4.061e-002* 5.971e-003*cos(t)+ 9.992e-001* 2.770e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.106e-001, 9.737e-003 center
replot  1.106e-001+ 2.000*( 9.997e-001* 1.215e-002*cos(t)+ 2.517e-002* 2.522e-003*sin(t)),  9.737e-003 +2.000*(-2.517e-002* 1.215e-002*cos(t)+ 9.997e-001* 2.522e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.806e-001, 6.527e-003 center
replot  1.806e-001+ 2.000*( 9.998e-001* 2.198e-002*cos(t)+ 1.966e-002* 2.043e-003*sin(t)),  6.527e-003 +2.000*(-1.966e-002* 2.198e-002*cos(t)+ 9.998e-001* 2.043e-003*sin(t)) not
set out;
set out "CZFchr/VARPIJGR_CZFchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "CZFchr/VARMUPTJGR--STABLBASED_CZFchr1.svg";
 plot "CZFchr/PRMORPREV-1-STABLBASED_CZFchr.txt"  u 1:($3) not w l lt 1 
 replot "CZFchr/PRMORPREV-1-STABLBASED_CZFchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "CZFchr/PRMORPREV-1-STABLBASED_CZFchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "CZFchr/VARMUPTJGR--STABLBASED_CZFchr1.svg";replot;set out;
