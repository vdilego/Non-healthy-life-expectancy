
# IMaCh-0.99r45
# CZMchr.gp
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


set ter svg size 640, 480;set out "CZMchr/D_CZMchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "CZMchr/ILK_CZMchr-dest.png";
set log y;plot  "CZMchr/ILK_CZMchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "CZMchr/ILK_CZMchr-ori.png";
set log y;plot  "CZMchr/ILK_CZMchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "CZMchr/ILK_CZMchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "CZMchr/ILK_CZMchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "CZMchr/ILK_CZMchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "CZMchr/ILK_CZMchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "CZMchr/V_CZMchr_1-1-1.svg" 

#set out "V_CZMchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "CZMchr/VPL_CZMchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"CZMchr/VPL_CZMchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"CZMchr/VPL_CZMchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"CZMchr/P_CZMchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "CZMchr/V_CZMchr_2-1-1.svg" 

#set out "V_CZMchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "CZMchr/VPL_CZMchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"CZMchr/VPL_CZMchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"CZMchr/VPL_CZMchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"CZMchr/P_CZMchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "CZMchr/E_CZMchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "CZMchr/T_CZMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"CZMchr/T_CZMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"CZMchr/T_CZMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"CZMchr/T_CZMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"CZMchr/T_CZMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"CZMchr/T_CZMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"CZMchr/T_CZMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"CZMchr/T_CZMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"CZMchr/T_CZMchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "CZMchr/E_CZMchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "CZMchr/EXP_CZMchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "CZMchr/E_CZMchr.txt" every :::0::0 u 1:2 t "e11" w l ,"CZMchr/E_CZMchr.txt" every :::0::0 u 1:3 t "e12" w l ,"CZMchr/E_CZMchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "CZMchr/EXP_CZMchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "CZMchr/E_CZMchr.txt" every :::0::0 u 1:5 t "e21" w l ,"CZMchr/E_CZMchr.txt" every :::0::0 u 1:6 t "e22" w l ,"CZMchr/E_CZMchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "CZMchr/LIJ_CZMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMchr/PIJ_CZMchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "CZMchr/LIJ_CZMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMchr/PIJ_CZMchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "CZMchr/LIJT_CZMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMchr/PIJ_CZMchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "CZMchr/LIJT_CZMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMchr/PIJ_CZMchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "CZMchr/P_CZMchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMchr/PIJ_CZMchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "CZMchr/P_CZMchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "CZMchr/PIJ_CZMchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-0.481649; p2=0.012574; 
#   current state 3
p3=-14.511826; p4=0.164829; 
# initial state 2
#   current state 1
p5=0.096306; p6=-0.041979; 
#   current state 3
p7=-7.987393; p8=0.080277; 
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

set out "CZMchr/PE_CZMchr_1-1-1.svg" 
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

set out "CZMchr/PE_CZMchr_1-2-1.svg" 
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

set out "CZMchr/PE_CZMchr_1-3-1.svg" 
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
set out "CZMchr/VARPIJGR_CZMchr_113-12.svg"
set label "50" at  4.378e-004, 2.681e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  4.378e-004+ 2.000*( 2.059e-004* 2.253e-002*cos(t)+ 1.000e+000* 5.962e-004*sin(t)),  2.681e-001 +2.000*(-1.000e+000* 2.253e-002*cos(t)+ 2.059e-004* 5.962e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  9.635e-004, 2.756e-001 center
replot  9.635e-004+ 2.000*( 2.164e-003* 1.638e-002*cos(t)+ 1.000e+000* 1.079e-003*sin(t)),  2.756e-001 +2.000*(-1.000e+000* 1.638e-002*cos(t)+ 2.164e-003* 1.079e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  2.116e-003, 2.827e-001 center
replot  2.116e-003+ 2.000*( 1.076e-002* 1.354e-002*cos(t)+ 9.999e-001* 1.878e-003*sin(t)),  2.827e-001 +2.000*(-9.999e-001* 1.354e-002*cos(t)+ 1.076e-002* 1.878e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  4.629e-003, 2.889e-001 center
replot  4.629e-003+ 2.000*( 2.388e-002* 1.566e-002*cos(t)+ 9.997e-001* 3.147e-003*sin(t)),  2.889e-001 +2.000*(-9.997e-001* 1.566e-002*cos(t)+ 2.388e-002* 3.147e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  1.006e-002, 2.931e-001 center
replot  1.006e-002+ 2.000*( 4.016e-002* 2.100e-002*cos(t)+ 9.992e-001* 5.281e-003*sin(t)),  2.931e-001 +2.000*(-9.992e-001* 2.100e-002*cos(t)+ 4.016e-002* 5.281e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.156e-002, 2.934e-001 center
replot  2.156e-002+ 2.000*( 9.939e-002* 2.755e-002*cos(t)+ 9.950e-001* 9.972e-003*sin(t)),  2.934e-001 +2.000*(-9.950e-001* 2.755e-002*cos(t)+ 9.939e-002* 9.972e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  4.496e-002, 2.858e-001 center
replot  4.496e-002+ 2.000*( 4.029e-001* 3.752e-002*cos(t)+ 9.152e-001* 2.029e-002*sin(t)),  2.858e-001 +2.000*(-9.152e-001* 3.752e-002*cos(t)+ 4.029e-001* 2.029e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  8.896e-002, 2.642e-001 center
replot  8.896e-002+ 2.000*( 7.555e-001* 6.939e-002*cos(t)+ 6.551e-001* 2.756e-002*sin(t)),  2.642e-001 +2.000*(-6.551e-001* 6.939e-002*cos(t)+ 7.555e-001* 2.756e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.607e-001, 2.229e-001 center
replot  1.607e-001+ 2.000*( 8.150e-001* 1.287e-001*cos(t)+ 5.794e-001* 2.728e-002*sin(t)),  2.229e-001 +2.000*(-5.794e-001* 1.287e-001*cos(t)+ 8.150e-001* 2.728e-002*sin(t)) not
set out;
set out "CZMchr/VARPIJGR_CZMchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "CZMchr/VARPIJGR_CZMchr_121-12.svg"
set label "50" at  5.849e-002, 2.681e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  5.849e-002+ 2.000*( 2.362e-002* 2.254e-002*cos(t)+-9.997e-001* 1.219e-002*sin(t)),  2.681e-001 +2.000*( 9.997e-001* 2.254e-002*cos(t)+ 2.362e-002* 1.219e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  4.810e-002, 2.756e-001 center
replot  4.810e-002+ 2.000*( 1.958e-002* 1.638e-002*cos(t)+-9.998e-001* 7.660e-003*sin(t)),  2.756e-001 +2.000*( 9.998e-001* 1.638e-002*cos(t)+ 1.958e-002* 7.660e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  3.923e-002, 2.827e-001 center
replot  3.923e-002+ 2.000*( 1.288e-002* 1.354e-002*cos(t)+-9.999e-001* 4.771e-003*sin(t)),  2.827e-001 +2.000*( 9.999e-001* 1.354e-002*cos(t)+ 1.288e-002* 4.771e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  3.169e-002, 2.889e-001 center
replot  3.169e-002+ 2.000*( 6.528e-003* 1.566e-002*cos(t)+-1.000e+000* 3.608e-003*sin(t)),  2.889e-001 +2.000*( 1.000e+000* 1.566e-002*cos(t)+ 6.528e-003* 3.608e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.530e-002, 2.931e-001 center
replot  2.530e-002+ 2.000*( 3.951e-003* 2.098e-002*cos(t)+-1.000e+000* 3.650e-003*sin(t)),  2.931e-001 +2.000*( 1.000e+000* 2.098e-002*cos(t)+ 3.951e-003* 3.650e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.990e-002, 2.934e-001 center
replot  1.990e-002+ 2.000*( 2.439e-003* 2.743e-002*cos(t)+-1.000e+000* 3.934e-003*sin(t)),  2.934e-001 +2.000*( 1.000e+000* 2.743e-002*cos(t)+ 2.439e-003* 3.934e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.536e-002, 2.858e-001 center
replot  1.536e-002+ 2.000*( 7.508e-004* 3.530e-002*cos(t)+-1.000e+000* 4.013e-003*sin(t)),  2.858e-001 +2.000*( 1.000e+000* 3.530e-002*cos(t)+ 7.508e-004* 4.013e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.156e-002, 2.642e-001 center
replot  1.156e-002+ 2.000*( 7.208e-004* 5.000e-002*cos(t)+ 1.000e+000* 3.821e-003*sin(t)),  2.642e-001 +2.000*(-1.000e+000* 5.000e-002*cos(t)+ 7.208e-004* 3.821e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  8.440e-003, 2.229e-001 center
replot  8.440e-003+ 2.000*( 9.841e-004* 7.779e-002*cos(t)+ 1.000e+000* 3.408e-003*sin(t)),  2.229e-001 +2.000*(-1.000e+000* 7.779e-002*cos(t)+ 9.841e-004* 3.408e-003*sin(t)) not
set out;
set out "CZMchr/VARPIJGR_CZMchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "CZMchr/VARPIJGR_CZMchr_123-12.svg"
set label "50" at  8.150e-003, 2.681e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  8.150e-003+ 2.000*( 2.204e-005* 2.253e-002*cos(t)+ 1.000e+000* 2.277e-003*sin(t)),  2.681e-001 +2.000*(-1.000e+000* 2.253e-002*cos(t)+ 2.204e-005* 2.277e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.235e-002, 2.756e-001 center
replot  1.235e-002+ 2.000*( 1.707e-005* 1.638e-002*cos(t)+ 1.000e+000* 2.772e-003*sin(t)),  2.756e-001 +2.000*(-1.000e+000* 1.638e-002*cos(t)+ 1.707e-005* 2.772e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  1.856e-002, 2.827e-001 center
replot  1.856e-002+ 2.000*( 6.031e-005* 1.353e-002*cos(t)+-1.000e+000* 3.216e-003*sin(t)),  2.827e-001 +2.000*( 1.000e+000* 1.353e-002*cos(t)+ 6.031e-005* 3.216e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  2.763e-002, 2.889e-001 center
replot  2.763e-002+ 2.000*( 3.777e-004* 1.566e-002*cos(t)+-1.000e+000* 3.577e-003*sin(t)),  2.889e-001 +2.000*( 1.000e+000* 1.566e-002*cos(t)+ 3.777e-004* 3.577e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  4.065e-002, 2.931e-001 center
replot  4.065e-002+ 2.000*( 9.137e-004* 2.098e-002*cos(t)+-1.000e+000* 4.108e-003*sin(t)),  2.931e-001 +2.000*( 1.000e+000* 2.098e-002*cos(t)+ 9.137e-004* 4.108e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  5.893e-002, 2.934e-001 center
replot  5.893e-002+ 2.000*( 2.077e-003* 2.743e-002*cos(t)+-1.000e+000* 5.778e-003*sin(t)),  2.934e-001 +2.000*( 1.000e+000* 2.743e-002*cos(t)+ 2.077e-003* 5.778e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  8.379e-002, 2.858e-001 center
replot  8.379e-002+ 2.000*( 4.932e-003* 3.530e-002*cos(t)+-1.000e+000* 9.748e-003*sin(t)),  2.858e-001 +2.000*( 1.000e+000* 3.530e-002*cos(t)+ 4.932e-003* 9.748e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.162e-001, 2.642e-001 center
replot  1.162e-001+ 2.000*( 8.831e-003* 5.000e-002*cos(t)+-1.000e+000* 1.636e-002*sin(t)),  2.642e-001 +2.000*( 1.000e+000* 5.000e-002*cos(t)+ 8.831e-003* 1.636e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.564e-001, 2.229e-001 center
replot  1.564e-001+ 2.000*( 9.942e-003* 7.780e-002*cos(t)+-1.000e+000* 2.513e-002*sin(t)),  2.229e-001 +2.000*( 1.000e+000* 7.780e-002*cos(t)+ 9.942e-003* 2.513e-002*sin(t)) not
set out;
set out "CZMchr/VARPIJGR_CZMchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "CZMchr/VARPIJGR_CZMchr_121-13.svg"
set label "50" at  5.849e-002, 4.378e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  5.849e-002+ 2.000*( 1.000e+000* 1.220e-002*cos(t)+-8.728e-004* 5.961e-004*sin(t)),  4.378e-004 +2.000*( 8.728e-004* 1.220e-002*cos(t)+ 1.000e+000* 5.961e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  4.810e-002, 9.635e-004 center
replot  4.810e-002+ 2.000*( 1.000e+000* 7.665e-003*cos(t)+-2.260e-003* 1.079e-003*sin(t)),  9.635e-004 +2.000*( 2.260e-003* 7.665e-003*cos(t)+ 1.000e+000* 1.079e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  3.923e-002, 2.116e-003 center
replot  3.923e-002+ 2.000*( 1.000e+000* 4.774e-003*cos(t)+-5.890e-003* 1.883e-003*sin(t)),  2.116e-003 +2.000*( 5.890e-003* 4.774e-003*cos(t)+ 1.000e+000* 1.883e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  3.169e-002, 4.629e-003 center
replot  3.169e-002+ 2.000*( 9.992e-001* 3.610e-003*cos(t)+-3.881e-002* 3.168e-003*sin(t)),  4.629e-003 +2.000*( 3.881e-002* 3.610e-003*cos(t)+ 9.992e-001* 3.168e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.530e-002, 1.006e-002 center
replot  2.530e-002+ 2.000*( 1.894e-002* 5.344e-003*cos(t)+-9.998e-001* 3.651e-003*sin(t)),  1.006e-002 +2.000*( 9.998e-001* 5.344e-003*cos(t)+ 1.894e-002* 3.651e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.990e-002, 2.156e-002 center
replot  1.990e-002+ 2.000*( 1.140e-002* 1.029e-002*cos(t)+-9.999e-001* 3.933e-003*sin(t)),  2.156e-002 +2.000*( 9.999e-001* 1.029e-002*cos(t)+ 1.140e-002* 3.933e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.536e-002, 4.496e-002 center
replot  1.536e-002+ 2.000*( 5.608e-003* 2.395e-002*cos(t)+-1.000e+000* 4.011e-003*sin(t)),  4.496e-002 +2.000*( 1.000e+000* 2.395e-002*cos(t)+ 5.608e-003* 4.011e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.156e-002, 8.896e-002 center
replot  1.156e-002+ 2.000*( 2.405e-003* 5.544e-002*cos(t)+-1.000e+000* 3.818e-003*sin(t)),  8.896e-002 +2.000*( 1.000e+000* 5.544e-002*cos(t)+ 2.405e-003* 3.818e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  8.440e-003, 1.607e-001 center
replot  8.440e-003+ 2.000*( 1.140e-003* 1.060e-001*cos(t)+-1.000e+000* 3.407e-003*sin(t)),  1.607e-001 +2.000*( 1.000e+000* 1.060e-001*cos(t)+ 1.140e-003* 3.407e-003*sin(t)) not
set out;
set out "CZMchr/VARPIJGR_CZMchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "CZMchr/VARPIJGR_CZMchr_123-13.svg"
set label "50" at  8.150e-003, 4.378e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  8.150e-003+ 2.000*( 1.000e+000* 2.277e-003*cos(t)+ 6.192e-003* 5.961e-004*sin(t)),  4.378e-004 +2.000*(-6.192e-003* 2.277e-003*cos(t)+ 1.000e+000* 5.961e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.235e-002, 9.635e-004 center
replot  1.235e-002+ 2.000*( 1.000e+000* 2.772e-003*cos(t)+ 9.456e-003* 1.079e-003*sin(t)),  9.635e-004 +2.000*(-9.456e-003* 2.772e-003*cos(t)+ 1.000e+000* 1.079e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  1.856e-002, 2.116e-003 center
replot  1.856e-002+ 2.000*( 9.999e-001* 3.216e-003*cos(t)+ 1.690e-002* 1.883e-003*sin(t)),  2.116e-003 +2.000*(-1.690e-002* 3.216e-003*cos(t)+ 9.999e-001* 1.883e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  2.763e-002, 4.629e-003 center
replot  2.763e-002+ 2.000*( 9.975e-001* 3.578e-003*cos(t)+ 7.084e-002* 3.166e-003*sin(t)),  4.629e-003 +2.000*(-7.084e-002* 3.578e-003*cos(t)+ 9.975e-001* 3.166e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  4.065e-002, 1.006e-002 center
replot  4.065e-002+ 2.000*( 3.300e-002* 5.344e-003*cos(t)+ 9.995e-001* 4.107e-003*sin(t)),  1.006e-002 +2.000*(-9.995e-001* 5.344e-003*cos(t)+ 3.300e-002* 4.107e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  5.893e-002, 2.156e-002 center
replot  5.893e-002+ 2.000*( 1.829e-002* 1.030e-002*cos(t)+ 9.998e-001* 5.776e-003*sin(t)),  2.156e-002 +2.000*(-9.998e-001* 1.030e-002*cos(t)+ 1.829e-002* 5.776e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  8.379e-002, 4.496e-002 center
replot  8.379e-002+ 2.000*( 1.307e-002* 2.395e-002*cos(t)+ 9.999e-001* 9.745e-003*sin(t)),  4.496e-002 +2.000*(-9.999e-001* 2.395e-002*cos(t)+ 1.307e-002* 9.745e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.162e-001, 8.896e-002 center
replot  1.162e-001+ 2.000*( 9.059e-003* 5.545e-002*cos(t)+ 1.000e+000* 1.636e-002*sin(t)),  8.896e-002 +2.000*(-1.000e+000* 5.545e-002*cos(t)+ 9.059e-003* 1.636e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.564e-001, 1.607e-001 center
replot  1.564e-001+ 2.000*( 7.006e-003* 1.060e-001*cos(t)+ 1.000e+000* 2.513e-002*sin(t)),  1.607e-001 +2.000*(-1.000e+000* 1.060e-001*cos(t)+ 7.006e-003* 2.513e-002*sin(t)) not
set out;
set out "CZMchr/VARPIJGR_CZMchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "CZMchr/VARPIJGR_CZMchr_123-21.svg"
set label "50" at  8.150e-003, 5.849e-002 center
# Age 50, p23 - p21
plot [-pi:pi]  8.150e-003+ 2.000*( 1.417e-002* 1.220e-002*cos(t)+ 9.999e-001* 2.270e-003*sin(t)),  5.849e-002 +2.000*(-9.999e-001* 1.220e-002*cos(t)+ 1.417e-002* 2.270e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.235e-002, 4.810e-002 center
replot  1.235e-002+ 2.000*( 2.509e-002* 7.667e-003*cos(t)+ 9.997e-001* 2.766e-003*sin(t)),  4.810e-002 +2.000*(-9.997e-001* 7.667e-003*cos(t)+ 2.509e-002* 2.766e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  1.856e-002, 3.923e-002 center
replot  1.856e-002+ 2.000*( 7.165e-002* 4.781e-003*cos(t)+ 9.974e-001* 3.206e-003*sin(t)),  3.923e-002 +2.000*(-9.974e-001* 4.781e-003*cos(t)+ 7.165e-002* 3.206e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  2.763e-002, 3.169e-002 center
replot  2.763e-002+ 2.000*( 6.563e-001* 3.709e-003*cos(t)+ 7.545e-001* 3.473e-003*sin(t)),  3.169e-002 +2.000*(-7.545e-001* 3.709e-003*cos(t)+ 6.563e-001* 3.473e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  4.065e-002, 2.530e-002 center
replot  4.065e-002+ 2.000*( 9.629e-001* 4.145e-003*cos(t)+ 2.698e-001* 3.610e-003*sin(t)),  2.530e-002 +2.000*(-2.698e-001* 4.145e-003*cos(t)+ 9.629e-001* 3.610e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  5.893e-002, 1.990e-002 center
replot  5.893e-002+ 2.000*( 9.950e-001* 5.794e-003*cos(t)+ 9.950e-002* 3.911e-003*sin(t)),  1.990e-002 +2.000*(-9.950e-002* 5.794e-003*cos(t)+ 9.950e-001* 3.911e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  8.379e-002, 1.536e-002 center
replot  8.379e-002+ 2.000*( 9.989e-001* 9.758e-003*cos(t)+ 4.639e-002* 3.992e-003*sin(t)),  1.536e-002 +2.000*(-4.639e-002* 9.758e-003*cos(t)+ 9.989e-001* 3.992e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.162e-001, 1.156e-002 center
replot  1.162e-001+ 2.000*( 9.995e-001* 1.637e-002*cos(t)+ 3.019e-002* 3.790e-003*sin(t)),  1.156e-002 +2.000*(-3.019e-002* 1.637e-002*cos(t)+ 9.995e-001* 3.790e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.564e-001, 8.440e-003 center
replot  1.564e-001+ 2.000*( 9.997e-001* 2.515e-002*cos(t)+ 2.286e-002* 3.361e-003*sin(t)),  8.440e-003 +2.000*(-2.286e-002* 2.515e-002*cos(t)+ 9.997e-001* 3.361e-003*sin(t)) not
set out;
set out "CZMchr/VARPIJGR_CZMchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "CZMchr/VARMUPTJGR--STABLBASED_CZMchr1.svg";
 plot "CZMchr/PRMORPREV-1-STABLBASED_CZMchr.txt"  u 1:($3) not w l lt 1 
 replot "CZMchr/PRMORPREV-1-STABLBASED_CZMchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "CZMchr/PRMORPREV-1-STABLBASED_CZMchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "CZMchr/VARMUPTJGR--STABLBASED_CZMchr1.svg";replot;set out;
