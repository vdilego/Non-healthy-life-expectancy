
# IMaCh-0.99r45
# ESMadl.gp
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


set ter svg size 640, 480;set out "ESMadl/D_ESMadl_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "ESMadl/ILK_ESMadl-dest.png";
set log y;plot  "ESMadl/ILK_ESMadl.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "ESMadl/ILK_ESMadl-ori.png";
set log y;plot  "ESMadl/ILK_ESMadl.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "ESMadl/ILK_ESMadl-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ESMadl/ILK_ESMadl.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "ESMadl/ILK_ESMadl-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ESMadl/ILK_ESMadl.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "ESMadl/V_ESMadl_1-1-1.svg" 

#set out "V_ESMadl_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ESMadl/VPL_ESMadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"ESMadl/VPL_ESMadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"ESMadl/VPL_ESMadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"ESMadl/P_ESMadl.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "ESMadl/V_ESMadl_2-1-1.svg" 

#set out "V_ESMadl_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ESMadl/VPL_ESMadl.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"ESMadl/VPL_ESMadl.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"ESMadl/VPL_ESMadl.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"ESMadl/P_ESMadl.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "ESMadl/E_ESMadl_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "ESMadl/T_ESMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"ESMadl/T_ESMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"ESMadl/T_ESMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"ESMadl/T_ESMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"ESMadl/T_ESMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"ESMadl/T_ESMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"ESMadl/T_ESMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"ESMadl/T_ESMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"ESMadl/T_ESMadl.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "ESMadl/E_ESMadl_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "ESMadl/EXP_ESMadl_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ESMadl/E_ESMadl.txt" every :::0::0 u 1:2 t "e11" w l ,"ESMadl/E_ESMadl.txt" every :::0::0 u 1:3 t "e12" w l ,"ESMadl/E_ESMadl.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "ESMadl/EXP_ESMadl_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ESMadl/E_ESMadl.txt" every :::0::0 u 1:5 t "e21" w l ,"ESMadl/E_ESMadl.txt" every :::0::0 u 1:6 t "e22" w l ,"ESMadl/E_ESMadl.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "ESMadl/LIJ_ESMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMadl/PIJ_ESMadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "ESMadl/LIJ_ESMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMadl/PIJ_ESMadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "ESMadl/LIJT_ESMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMadl/PIJ_ESMadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "ESMadl/LIJT_ESMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMadl/PIJ_ESMadl.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "ESMadl/P_ESMadl_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMadl/PIJ_ESMadl.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "ESMadl/P_ESMadl_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMadl/PIJ_ESMadl.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-12.090041; p2=0.112945; 
#   current state 3
p3=-9.046547; p4=0.066050; 
# initial state 2
#   current state 1
p5=-3.590508; p6=0.023879; 
#   current state 3
p7=-8.222881; p8=0.074194; 
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

set out "ESMadl/PE_ESMadl_1-1-1.svg" 
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

set out "ESMadl/PE_ESMadl_1-2-1.svg" 
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

set out "ESMadl/PE_ESMadl_1-3-1.svg" 
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
set out "ESMadl/VARPIJGR_ESMadl_113-12.svg"
set label "50" at  6.373e-003, 3.169e-003 center
# Age 50, p13 - p12
plot [-pi:pi]  6.373e-003+ 2.000*( 9.984e-001* 1.830e-003*cos(t)+ 5.718e-002* 1.050e-003*sin(t)),  3.169e-003 +2.000*(-5.718e-002* 1.830e-003*cos(t)+ 9.984e-001* 1.050e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  8.845e-003, 5.560e-003 center
replot  8.845e-003+ 2.000*( 9.950e-001* 2.048e-003*cos(t)+ 9.986e-002* 1.515e-003*sin(t)),  5.560e-003 +2.000*(-9.986e-002* 2.048e-003*cos(t)+ 9.950e-001* 1.515e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.226e-002, 9.743e-003 center
replot  1.226e-002+ 2.000*( 8.945e-001* 2.250e-003*cos(t)+ 4.470e-001* 2.093e-003*sin(t)),  9.743e-003 +2.000*(-4.470e-001* 2.250e-003*cos(t)+ 8.945e-001* 2.093e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.695e-002, 1.703e-002 center
replot  1.695e-002+ 2.000*( 1.904e-001* 2.902e-003*cos(t)+ 9.817e-001* 2.404e-003*sin(t)),  1.703e-002 +2.000*(-9.817e-001* 2.902e-003*cos(t)+ 1.904e-001* 2.404e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  2.336e-002, 2.967e-002 center
replot  2.336e-002+ 2.000*( 1.978e-001* 4.031e-003*cos(t)+ 9.802e-001* 2.930e-003*sin(t)),  2.967e-002 +2.000*(-9.802e-001* 4.031e-003*cos(t)+ 1.978e-001* 2.930e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  3.199e-002, 5.138e-002 center
replot  3.199e-002+ 2.000*( 2.641e-001* 6.563e-003*cos(t)+ 9.645e-001* 4.362e-003*sin(t)),  5.138e-002 +2.000*(-9.645e-001* 6.563e-003*cos(t)+ 2.641e-001* 4.362e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  4.339e-002, 8.810e-002 center
replot  4.339e-002+ 2.000*( 2.348e-001* 1.296e-002*cos(t)+ 9.720e-001* 7.370e-003*sin(t)),  8.810e-002 +2.000*(-9.720e-001* 1.296e-002*cos(t)+ 2.348e-001* 7.370e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  5.795e-002, 1.487e-001 center
replot  5.795e-002+ 2.000*( 1.828e-001* 2.706e-002*cos(t)+ 9.831e-001* 1.248e-002*sin(t)),  1.487e-001 +2.000*(-9.831e-001* 2.706e-002*cos(t)+ 1.828e-001* 1.248e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  7.550e-002, 2.450e-001 center
replot  7.550e-002+ 2.000*( 1.553e-001* 5.369e-002*cos(t)+ 9.879e-001* 1.997e-002*sin(t)),  2.450e-001 +2.000*(-9.879e-001* 5.369e-002*cos(t)+ 1.553e-001* 1.997e-002*sin(t)) not
set out;
set out "ESMadl/VARPIJGR_ESMadl_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ESMadl/VARPIJGR_ESMadl_121-12.svg"
set label "50" at  1.652e-001, 3.169e-003 center
# Age 50, p21 - p12
plot [-pi:pi]  1.652e-001+ 2.000*( 1.000e+000* 5.901e-002*cos(t)+-4.538e-003* 1.019e-003*sin(t)),  3.169e-003 +2.000*( 4.538e-003* 5.901e-002*cos(t)+ 1.000e+000* 1.019e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  1.834e-001, 5.560e-003 center
replot  1.834e-001+ 2.000*( 1.000e+000* 5.313e-002*cos(t)+-6.667e-003* 1.479e-003*sin(t)),  5.560e-003 +2.000*( 6.667e-003* 5.313e-002*cos(t)+ 1.000e+000* 1.479e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.030e-001, 9.743e-003 center
replot  2.030e-001+ 2.000*( 1.000e+000* 4.619e-002*cos(t)+-9.537e-003* 2.079e-003*sin(t)),  9.743e-003 +2.000*( 9.537e-003* 4.619e-002*cos(t)+ 1.000e+000* 2.079e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.239e-001, 1.703e-002 center
replot  2.239e-001+ 2.000*( 9.999e-001* 3.915e-002*cos(t)+-1.387e-002* 2.834e-003*sin(t)),  1.703e-002 +2.000*( 1.387e-002* 3.915e-002*cos(t)+ 9.999e-001* 2.834e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.456e-001, 2.967e-002 center
replot  2.456e-001+ 2.000*( 9.997e-001* 3.447e-002*cos(t)+-2.568e-002* 3.895e-003*sin(t)),  2.967e-002 +2.000*( 2.568e-002* 3.447e-002*cos(t)+ 9.997e-001* 3.895e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.677e-001, 5.138e-002 center
replot  2.677e-001+ 2.000*( 9.981e-001* 3.628e-002*cos(t)+-6.231e-002* 6.036e-003*sin(t)),  5.138e-002 +2.000*( 6.231e-002* 3.628e-002*cos(t)+ 9.981e-001* 6.036e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.894e-001, 8.810e-002 center
replot  2.894e-001+ 2.000*( 9.918e-001* 4.658e-002*cos(t)+-1.274e-001* 1.134e-002*sin(t)),  8.810e-002 +2.000*( 1.274e-001* 4.658e-002*cos(t)+ 9.918e-001* 1.134e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  3.094e-001, 1.487e-001 center
replot  3.094e-001+ 2.000*( 9.751e-001* 6.368e-002*cos(t)+-2.216e-001* 2.324e-002*sin(t)),  1.487e-001 +2.000*( 2.216e-001* 6.368e-002*cos(t)+ 9.751e-001* 2.324e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  3.264e-001, 2.450e-001 center
replot  3.264e-001+ 2.000*( 9.253e-001* 8.655e-002*cos(t)+-3.792e-001* 4.516e-002*sin(t)),  2.450e-001 +2.000*( 3.792e-001* 8.655e-002*cos(t)+ 9.253e-001* 4.516e-002*sin(t)) not
set out;
set out "ESMadl/VARPIJGR_ESMadl_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ESMadl/VARPIJGR_ESMadl_123-12.svg"
set label "50" at  1.990e-002, 3.169e-003 center
# Age 50, p23 - p12
plot [-pi:pi]  1.990e-002+ 2.000*( 1.000e+000* 1.289e-002*cos(t)+-8.443e-003* 1.048e-003*sin(t)),  3.169e-003 +2.000*( 8.443e-003* 1.289e-002*cos(t)+ 1.000e+000* 1.048e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.841e-002, 5.560e-003 center
replot  2.841e-002+ 2.000*( 1.000e+000* 1.557e-002*cos(t)+-9.851e-003* 1.514e-003*sin(t)),  5.560e-003 +2.000*( 9.851e-003* 1.557e-002*cos(t)+ 1.000e+000* 1.514e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  4.044e-002, 9.743e-003 center
replot  4.044e-002+ 2.000*( 9.999e-001* 1.823e-002*cos(t)+-1.173e-002* 2.115e-003*sin(t)),  9.743e-003 +2.000*( 1.173e-002* 1.823e-002*cos(t)+ 9.999e-001* 2.115e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  5.734e-002, 1.703e-002 center
replot  5.734e-002+ 2.000*( 9.999e-001* 2.053e-002*cos(t)+-1.505e-002* 2.869e-003*sin(t)),  1.703e-002 +2.000*( 1.505e-002* 2.053e-002*cos(t)+ 9.999e-001* 2.869e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  8.091e-002, 2.967e-002 center
replot  8.091e-002+ 2.000*( 9.997e-001* 2.216e-002*cos(t)+-2.352e-002* 3.960e-003*sin(t)),  2.967e-002 +2.000*( 2.352e-002* 2.216e-002*cos(t)+ 9.997e-001* 3.960e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.134e-001, 5.138e-002 center
replot  1.134e-001+ 2.000*( 9.987e-001* 2.357e-002*cos(t)+-5.037e-002* 6.332e-003*sin(t)),  5.138e-002 +2.000*( 5.037e-002* 2.357e-002*cos(t)+ 9.987e-001* 6.332e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.577e-001, 8.810e-002 center
replot  1.577e-001+ 2.000*( 9.926e-001* 2.799e-002*cos(t)+-1.218e-001* 1.235e-002*sin(t)),  8.810e-002 +2.000*( 1.218e-001* 2.799e-002*cos(t)+ 9.926e-001* 1.235e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  2.168e-001, 1.487e-001 center
replot  2.168e-001+ 2.000*( 9.759e-001* 4.221e-002*cos(t)+-2.184e-001* 2.568e-002*sin(t)),  1.487e-001 +2.000*( 2.184e-001* 4.221e-002*cos(t)+ 9.759e-001* 2.568e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  2.941e-001, 2.450e-001 center
replot  2.941e-001+ 2.000*( 9.546e-001* 7.117e-002*cos(t)+-2.980e-001* 5.103e-002*sin(t)),  2.450e-001 +2.000*( 2.980e-001* 7.117e-002*cos(t)+ 9.546e-001* 5.103e-002*sin(t)) not
set out;
set out "ESMadl/VARPIJGR_ESMadl_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ESMadl/VARPIJGR_ESMadl_121-13.svg"
set label "50" at  1.652e-001, 6.373e-003 center
# Age 50, p21 - p13
plot [-pi:pi]  1.652e-001+ 2.000*( 1.000e+000* 5.901e-002*cos(t)+-1.877e-004* 1.828e-003*sin(t)),  6.373e-003 +2.000*( 1.877e-004* 5.901e-002*cos(t)+ 1.000e+000* 1.828e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  1.834e-001, 8.845e-003 center
replot  1.834e-001+ 2.000*( 1.000e+000* 5.313e-002*cos(t)+-3.473e-004* 2.043e-003*sin(t)),  8.845e-003 +2.000*( 3.473e-004* 5.313e-002*cos(t)+ 1.000e+000* 2.043e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.030e-001, 1.226e-002 center
replot  2.030e-001+ 2.000*( 1.000e+000* 4.619e-002*cos(t)+-6.288e-004* 2.220e-003*sin(t)),  1.226e-002 +2.000*( 6.288e-004* 4.619e-002*cos(t)+ 1.000e+000* 2.220e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.239e-001, 1.695e-002 center
replot  2.239e-001+ 2.000*( 1.000e+000* 3.914e-002*cos(t)+-1.092e-003* 2.423e-003*sin(t)),  1.695e-002 +2.000*( 1.092e-003* 3.914e-002*cos(t)+ 1.000e+000* 2.423e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.456e-001, 2.336e-002 center
replot  2.456e-001+ 2.000*( 1.000e+000* 3.446e-002*cos(t)+-1.613e-003* 2.980e-003*sin(t)),  2.336e-002 +2.000*( 1.613e-003* 3.446e-002*cos(t)+ 1.000e+000* 2.980e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.677e-001, 3.199e-002 center
replot  2.677e-001+ 2.000*( 1.000e+000* 3.621e-002*cos(t)+-1.552e-003* 4.550e-003*sin(t)),  3.199e-002 +2.000*( 1.552e-003* 3.621e-002*cos(t)+ 1.000e+000* 4.550e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.894e-001, 4.339e-002 center
replot  2.894e-001+ 2.000*( 1.000e+000* 4.623e-002*cos(t)+-8.241e-004* 7.783e-003*sin(t)),  4.339e-002 +2.000*( 8.241e-004* 4.623e-002*cos(t)+ 1.000e+000* 7.783e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  3.094e-001, 5.795e-002 center
replot  3.094e-001+ 2.000*( 1.000e+000* 6.231e-002*cos(t)+ 3.105e-004* 1.323e-002*sin(t)),  5.795e-002 +2.000*(-3.105e-004* 6.231e-002*cos(t)+ 1.000e+000* 1.323e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  3.264e-001, 7.550e-002 center
replot  3.264e-001+ 2.000*( 1.000e+000* 8.189e-002*cos(t)+ 2.577e-003* 2.141e-002*sin(t)),  7.550e-002 +2.000*(-2.577e-003* 8.189e-002*cos(t)+ 1.000e+000* 2.141e-002*sin(t)) not
set out;
set out "ESMadl/VARPIJGR_ESMadl_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ESMadl/VARPIJGR_ESMadl_123-13.svg"
set label "50" at  1.990e-002, 6.373e-003 center
# Age 50, p23 - p13
plot [-pi:pi]  1.990e-002+ 2.000*( 9.999e-001* 1.289e-002*cos(t)+ 1.654e-002* 1.815e-003*sin(t)),  6.373e-003 +2.000*(-1.654e-002* 1.289e-002*cos(t)+ 9.999e-001* 1.815e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.841e-002, 8.845e-003 center
replot  2.841e-002+ 2.000*( 9.999e-001* 1.557e-002*cos(t)+ 1.516e-002* 2.030e-003*sin(t)),  8.845e-003 +2.000*(-1.516e-002* 1.557e-002*cos(t)+ 9.999e-001* 2.030e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  4.044e-002, 1.226e-002 center
replot  4.044e-002+ 2.000*( 9.999e-001* 1.823e-002*cos(t)+ 1.457e-002* 2.204e-003*sin(t)),  1.226e-002 +2.000*(-1.457e-002* 1.823e-002*cos(t)+ 9.999e-001* 2.204e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  5.734e-002, 1.695e-002 center
replot  5.734e-002+ 2.000*( 9.999e-001* 2.053e-002*cos(t)+ 1.624e-002* 2.401e-003*sin(t)),  1.695e-002 +2.000*(-1.624e-002* 2.053e-002*cos(t)+ 9.999e-001* 2.401e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  8.091e-002, 2.336e-002 center
replot  8.091e-002+ 2.000*( 9.997e-001* 2.216e-002*cos(t)+ 2.468e-002* 2.931e-003*sin(t)),  2.336e-002 +2.000*(-2.468e-002* 2.216e-002*cos(t)+ 9.997e-001* 2.931e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.134e-001, 3.199e-002 center
replot  1.134e-001+ 2.000*( 9.987e-001* 2.357e-002*cos(t)+ 5.157e-002* 4.391e-003*sin(t)),  3.199e-002 +2.000*(-5.157e-002* 2.357e-002*cos(t)+ 9.987e-001* 4.391e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.577e-001, 4.339e-002 center
replot  1.577e-001+ 2.000*( 9.948e-001* 2.796e-002*cos(t)+ 1.016e-001* 7.284e-003*sin(t)),  4.339e-002 +2.000*(-1.016e-001* 2.796e-002*cos(t)+ 9.948e-001* 7.284e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  2.168e-001, 5.795e-002 center
replot  2.168e-001+ 2.000*( 9.924e-001* 4.186e-002*cos(t)+ 1.232e-001* 1.227e-002*sin(t)),  5.795e-002 +2.000*(-1.232e-001* 4.186e-002*cos(t)+ 9.924e-001* 1.227e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  2.941e-001, 7.550e-002 center
replot  2.941e-001+ 2.000*( 9.941e-001* 7.000e-002*cos(t)+ 1.087e-001* 2.014e-002*sin(t)),  7.550e-002 +2.000*(-1.087e-001* 7.000e-002*cos(t)+ 9.941e-001* 2.014e-002*sin(t)) not
set out;
set out "ESMadl/VARPIJGR_ESMadl_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "ESMadl/VARPIJGR_ESMadl_123-21.svg"
set label "50" at  1.990e-002, 1.652e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.990e-002+ 2.000*( 3.906e-003* 5.901e-002*cos(t)+-1.000e+000* 1.289e-002*sin(t)),  1.652e-001 +2.000*( 1.000e+000* 5.901e-002*cos(t)+ 3.906e-003* 1.289e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.841e-002, 1.834e-001 center
replot  2.841e-002+ 2.000*( 1.806e-003* 5.313e-002*cos(t)+ 1.000e+000* 1.557e-002*sin(t)),  1.834e-001 +2.000*(-1.000e+000* 5.313e-002*cos(t)+ 1.806e-003* 1.557e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  4.044e-002, 2.030e-001 center
replot  4.044e-002+ 2.000*( 1.608e-002* 4.619e-002*cos(t)+ 9.999e-001* 1.822e-002*sin(t)),  2.030e-001 +2.000*(-9.999e-001* 4.619e-002*cos(t)+ 1.608e-002* 1.822e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  5.734e-002, 2.239e-001 center
replot  5.734e-002+ 2.000*( 4.890e-002* 3.918e-002*cos(t)+ 9.988e-001* 2.047e-002*sin(t)),  2.239e-001 +2.000*(-9.988e-001* 3.918e-002*cos(t)+ 4.890e-002* 2.047e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  8.091e-002, 2.456e-001 center
replot  8.091e-002+ 2.000*( 9.827e-002* 3.456e-002*cos(t)+ 9.952e-001* 2.200e-002*sin(t)),  2.456e-001 +2.000*(-9.952e-001* 3.456e-002*cos(t)+ 9.827e-002* 2.200e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.134e-001, 2.677e-001 center
replot  1.134e-001+ 2.000*( 7.885e-002* 3.628e-002*cos(t)+ 9.969e-001* 2.344e-002*sin(t)),  2.677e-001 +2.000*(-9.969e-001* 3.628e-002*cos(t)+ 7.885e-002* 2.344e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.577e-001, 2.894e-001 center
replot  1.577e-001+ 2.000*( 2.690e-002* 4.624e-002*cos(t)+ 9.996e-001* 2.780e-002*sin(t)),  2.894e-001 +2.000*(-9.996e-001* 4.624e-002*cos(t)+ 2.690e-002* 2.780e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  2.168e-001, 3.094e-001 center
replot  2.168e-001+ 2.000*( 4.856e-002* 6.235e-002*cos(t)+ 9.988e-001* 4.151e-002*sin(t)),  3.094e-001 +2.000*(-9.988e-001* 6.235e-002*cos(t)+ 4.856e-002* 4.151e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  2.941e-001, 3.264e-001 center
replot  2.941e-001+ 2.000*( 2.890e-001* 8.302e-002*cos(t)+ 9.573e-001* 6.827e-002*sin(t)),  3.264e-001 +2.000*(-9.573e-001* 8.302e-002*cos(t)+ 2.890e-001* 6.827e-002*sin(t)) not
set out;
set out "ESMadl/VARPIJGR_ESMadl_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "ESMadl/VARMUPTJGR--STABLBASED_ESMadl1.svg";
 plot "ESMadl/PRMORPREV-1-STABLBASED_ESMadl.txt"  u 1:($3) not w l lt 1 
 replot "ESMadl/PRMORPREV-1-STABLBASED_ESMadl.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "ESMadl/PRMORPREV-1-STABLBASED_ESMadl.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "ESMadl/VARMUPTJGR--STABLBASED_ESMadl1.svg";replot;set out;
