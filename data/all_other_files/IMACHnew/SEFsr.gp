
# IMaCh-0.99r45
# SEFsr.gp
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


set ter svg size 640, 480;set out "SEFsr/D_SEFsr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "SEFsr/ILK_SEFsr-dest.png";
set log y;plot  "SEFsr/ILK_SEFsr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "SEFsr/ILK_SEFsr-ori.png";
set log y;plot  "SEFsr/ILK_SEFsr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "SEFsr/ILK_SEFsr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "SEFsr/ILK_SEFsr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "SEFsr/ILK_SEFsr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "SEFsr/ILK_SEFsr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "SEFsr/V_SEFsr_1-1-1.svg" 

#set out "V_SEFsr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "SEFsr/VPL_SEFsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"SEFsr/VPL_SEFsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"SEFsr/VPL_SEFsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"SEFsr/P_SEFsr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "SEFsr/V_SEFsr_2-1-1.svg" 

#set out "V_SEFsr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "SEFsr/VPL_SEFsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"SEFsr/VPL_SEFsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"SEFsr/VPL_SEFsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"SEFsr/P_SEFsr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "SEFsr/E_SEFsr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "SEFsr/T_SEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"SEFsr/T_SEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"SEFsr/T_SEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"SEFsr/T_SEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"SEFsr/T_SEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"SEFsr/T_SEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"SEFsr/T_SEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"SEFsr/T_SEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"SEFsr/T_SEFsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "SEFsr/E_SEFsr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "SEFsr/EXP_SEFsr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "SEFsr/E_SEFsr.txt" every :::0::0 u 1:2 t "e11" w l ,"SEFsr/E_SEFsr.txt" every :::0::0 u 1:3 t "e12" w l ,"SEFsr/E_SEFsr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "SEFsr/EXP_SEFsr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "SEFsr/E_SEFsr.txt" every :::0::0 u 1:5 t "e21" w l ,"SEFsr/E_SEFsr.txt" every :::0::0 u 1:6 t "e22" w l ,"SEFsr/E_SEFsr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "SEFsr/LIJ_SEFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFsr/PIJ_SEFsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "SEFsr/LIJ_SEFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFsr/PIJ_SEFsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "SEFsr/LIJT_SEFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFsr/PIJ_SEFsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "SEFsr/LIJT_SEFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFsr/PIJ_SEFsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "SEFsr/P_SEFsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFsr/PIJ_SEFsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "SEFsr/P_SEFsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFsr/PIJ_SEFsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-6.897131; p2=0.054710; 
#   current state 3
p3=-15.130788; p4=0.135615; 
# initial state 2
#   current state 1
p5=-2.289371; p6=-0.002206; 
#   current state 3
p7=-12.057326; p8=0.107795; 
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

set out "SEFsr/PE_SEFsr_1-1-1.svg" 
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

set out "SEFsr/PE_SEFsr_1-2-1.svg" 
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

set out "SEFsr/PE_SEFsr_1-3-1.svg" 
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
set out "SEFsr/VARPIJGR_SEFsr_113-12.svg"
set label "50" at  4.654e-004, 3.068e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  4.654e-004+ 2.000*( 2.747e-002* 6.666e-003*cos(t)+ 9.996e-001* 5.279e-004*sin(t)),  3.068e-002 +2.000*(-9.996e-001* 6.666e-003*cos(t)+ 2.747e-002* 5.279e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  9.123e-004, 4.013e-002 center
replot  9.123e-004+ 2.000*( 4.006e-002* 6.907e-003*cos(t)+ 9.992e-001* 8.652e-004*sin(t)),  4.013e-002 +2.000*(-9.992e-001* 6.907e-003*cos(t)+ 4.006e-002* 8.652e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.785e-003, 5.240e-002 center
replot  1.785e-003+ 2.000*( 5.471e-002* 6.853e-003*cos(t)+ 9.985e-001* 1.367e-003*sin(t)),  5.240e-002 +2.000*(-9.985e-001* 6.853e-003*cos(t)+ 5.471e-002* 1.367e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  3.485e-003, 6.826e-002 center
replot  3.485e-003+ 2.000*( 5.834e-002* 6.669e-003*cos(t)+ 9.983e-001* 2.048e-003*sin(t)),  6.826e-002 +2.000*(-9.983e-001* 6.669e-003*cos(t)+ 5.834e-002* 2.048e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  6.782e-003, 8.864e-002 center
replot  6.782e-003+ 2.000*( 2.436e-002* 7.312e-003*cos(t)+ 9.997e-001* 2.826e-003*sin(t)),  8.864e-002 +2.000*(-9.997e-001* 7.312e-003*cos(t)+ 2.436e-002* 2.826e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.313e-002, 1.146e-001 center
replot  1.313e-002+ 2.000*( 3.378e-002* 1.068e-002*cos(t)+ 9.994e-001* 3.744e-003*sin(t)),  1.146e-001 +2.000*(-9.994e-001* 1.068e-002*cos(t)+ 3.378e-002* 3.744e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  2.526e-002, 1.470e-001 center
replot  2.526e-002+ 2.000*( 1.498e-001* 1.815e-002*cos(t)+ 9.887e-001* 6.639e-003*sin(t)),  1.470e-001 +2.000*(-9.887e-001* 1.815e-002*cos(t)+ 1.498e-001* 6.639e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  4.806e-002, 1.867e-001 center
replot  4.806e-002+ 2.000*( 3.985e-001* 3.179e-002*cos(t)+ 9.172e-001* 1.603e-002*sin(t)),  1.867e-001 +2.000*(-9.172e-001* 3.179e-002*cos(t)+ 3.985e-001* 1.603e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  8.995e-002, 2.331e-001 center
replot  8.995e-002+ 2.000*( 7.518e-001* 6.170e-002*cos(t)+ 6.594e-001* 3.271e-002*sin(t)),  2.331e-001 +2.000*(-6.594e-001* 6.170e-002*cos(t)+ 7.518e-001* 3.271e-002*sin(t)) not
set out;
set out "SEFsr/VARPIJGR_SEFsr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "SEFsr/VARPIJGR_SEFsr_121-12.svg"
set label "50" at  1.662e-001, 3.068e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  1.662e-001+ 2.000*( 9.993e-001* 3.191e-002*cos(t)+-3.811e-002* 6.556e-003*sin(t)),  3.068e-002 +2.000*( 3.811e-002* 3.191e-002*cos(t)+ 9.993e-001* 6.556e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  1.644e-001, 4.013e-002 center
replot  1.644e-001+ 2.000*( 9.988e-001* 2.560e-002*cos(t)+-4.971e-002* 6.791e-003*sin(t)),  4.013e-002 +2.000*( 4.971e-002* 2.560e-002*cos(t)+ 9.988e-001* 6.791e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  1.625e-001, 5.240e-002 center
replot  1.625e-001+ 2.000*( 9.978e-001* 2.006e-002*cos(t)+-6.574e-002* 6.729e-003*sin(t)),  5.240e-002 +2.000*( 6.574e-002* 2.006e-002*cos(t)+ 9.978e-001* 6.729e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  1.605e-001, 6.826e-002 center
replot  1.605e-001+ 2.000*( 9.957e-001* 1.595e-002*cos(t)+-9.263e-002* 6.521e-003*sin(t)),  6.826e-002 +2.000*( 9.263e-002* 1.595e-002*cos(t)+ 9.957e-001* 6.521e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  1.582e-001, 8.864e-002 center
replot  1.582e-001+ 2.000*( 9.885e-001* 1.436e-002*cos(t)+-1.511e-001* 7.063e-003*sin(t)),  8.864e-002 +2.000*( 1.511e-001* 1.436e-002*cos(t)+ 9.885e-001* 7.063e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.555e-001, 1.146e-001 center
replot  1.555e-001+ 2.000*( 9.595e-001* 1.598e-002*cos(t)+-2.819e-001* 1.009e-002*sin(t)),  1.146e-001 +2.000*( 2.819e-001* 1.598e-002*cos(t)+ 9.595e-001* 1.009e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.520e-001, 1.470e-001 center
replot  1.520e-001+ 2.000*( 7.895e-001* 2.067e-002*cos(t)+-6.137e-001* 1.612e-002*sin(t)),  1.470e-001 +2.000*( 6.137e-001* 2.067e-002*cos(t)+ 7.895e-001* 1.612e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.475e-001, 1.867e-001 center
replot  1.475e-001+ 2.000*( 3.408e-001* 3.069e-002*cos(t)+-9.401e-001* 2.235e-002*sin(t)),  1.867e-001 +2.000*( 9.401e-001* 3.069e-002*cos(t)+ 3.408e-001* 2.235e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.411e-001, 2.331e-001 center
replot  1.411e-001+ 2.000*( 1.279e-001* 4.780e-002*cos(t)+-9.918e-001* 2.754e-002*sin(t)),  2.331e-001 +2.000*( 9.918e-001* 4.780e-002*cos(t)+ 1.279e-001* 2.754e-002*sin(t)) not
set out;
set out "SEFsr/VARPIJGR_SEFsr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "SEFsr/VARPIJGR_SEFsr_123-12.svg"
set label "50" at  2.329e-003, 3.068e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  2.329e-003+ 2.000*( 9.825e-002* 6.693e-003*cos(t)+-9.952e-001* 2.006e-003*sin(t)),  3.068e-002 +2.000*( 9.952e-001* 6.693e-003*cos(t)+ 9.825e-002* 2.006e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  3.992e-003, 4.013e-002 center
replot  3.992e-003+ 2.000*( 1.396e-001* 6.957e-003*cos(t)+-9.902e-001* 2.913e-003*sin(t)),  4.013e-002 +2.000*( 9.902e-001* 6.957e-003*cos(t)+ 1.396e-001* 2.913e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  6.840e-003, 5.240e-002 center
replot  6.840e-003+ 2.000*( 2.128e-001* 6.946e-003*cos(t)+-9.771e-001* 4.095e-003*sin(t)),  5.240e-002 +2.000*( 9.771e-001* 6.946e-003*cos(t)+ 2.128e-001* 4.095e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  1.171e-002, 6.826e-002 center
replot  1.171e-002+ 2.000*( 3.775e-001* 6.832e-003*cos(t)+-9.260e-001* 5.500e-003*sin(t)),  6.826e-002 +2.000*( 9.260e-001* 6.832e-003*cos(t)+ 3.775e-001* 5.500e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  2.000e-002, 8.864e-002 center
replot  2.000e-002+ 2.000*( 5.146e-001* 7.393e-003*cos(t)+-8.575e-001* 7.077e-003*sin(t)),  8.864e-002 +2.000*( 8.575e-001* 7.393e-003*cos(t)+ 5.146e-001* 7.077e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  3.408e-002, 1.146e-001 center
replot  3.408e-002+ 2.000*( 2.439e-003* 1.068e-002*cos(t)+ 1.000e+000* 8.348e-003*sin(t)),  1.146e-001 +2.000*(-1.000e+000* 1.068e-002*cos(t)+ 2.439e-003* 8.348e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  5.776e-002, 1.470e-001 center
replot  5.776e-002+ 2.000*( 1.380e-001* 1.809e-002*cos(t)+-9.904e-001* 1.021e-002*sin(t)),  1.470e-001 +2.000*( 9.904e-001* 1.809e-002*cos(t)+ 1.380e-001* 1.021e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  9.709e-002, 1.867e-001 center
replot  9.709e-002+ 2.000*( 3.625e-001* 3.125e-002*cos(t)+-9.320e-001* 1.799e-002*sin(t)),  1.867e-001 +2.000*( 9.320e-001* 3.125e-002*cos(t)+ 3.625e-001* 1.799e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.610e-001, 2.331e-001 center
replot  1.610e-001+ 2.000*( 7.049e-001* 5.711e-002*cos(t)+-7.093e-001* 3.530e-002*sin(t)),  2.331e-001 +2.000*( 7.093e-001* 5.711e-002*cos(t)+ 7.049e-001* 3.530e-002*sin(t)) not
set out;
set out "SEFsr/VARPIJGR_SEFsr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "SEFsr/VARPIJGR_SEFsr_121-13.svg"
set label "50" at  1.662e-001, 4.654e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  1.662e-001+ 2.000*( 1.000e+000* 3.189e-002*cos(t)+-8.691e-004* 5.579e-004*sin(t)),  4.654e-004 +2.000*( 8.691e-004* 3.189e-002*cos(t)+ 1.000e+000* 5.579e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  1.644e-001, 9.123e-004 center
replot  1.644e-001+ 2.000*( 1.000e+000* 2.557e-002*cos(t)+-1.666e-003* 9.067e-004*sin(t)),  9.123e-004 +2.000*( 1.666e-003* 2.557e-002*cos(t)+ 1.000e+000* 9.067e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  1.625e-001, 1.785e-003 center
replot  1.625e-001+ 2.000*( 1.000e+000* 2.003e-002*cos(t)+-3.084e-003* 1.414e-003*sin(t)),  1.785e-003 +2.000*( 3.084e-003* 2.003e-002*cos(t)+ 1.000e+000* 1.414e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  1.605e-001, 3.485e-003 center
replot  1.605e-001+ 2.000*( 1.000e+000* 1.590e-002*cos(t)+-5.229e-003* 2.080e-003*sin(t)),  3.485e-003 +2.000*( 5.229e-003* 1.590e-002*cos(t)+ 1.000e+000* 2.080e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  1.582e-001, 6.782e-003 center
replot  1.582e-001+ 2.000*( 1.000e+000* 1.423e-002*cos(t)+-7.934e-003* 2.829e-003*sin(t)),  6.782e-003 +2.000*( 7.934e-003* 1.423e-002*cos(t)+ 1.000e+000* 2.829e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.555e-001, 1.313e-002 center
replot  1.555e-001+ 2.000*( 9.999e-001* 1.559e-002*cos(t)+-1.460e-002* 3.752e-003*sin(t)),  1.313e-002 +2.000*( 1.460e-002* 1.559e-002*cos(t)+ 9.999e-001* 3.752e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.520e-001, 2.526e-002 center
replot  1.520e-001+ 2.000*( 9.992e-001* 1.910e-002*cos(t)+-4.049e-002* 7.068e-003*sin(t)),  2.526e-002 +2.000*( 4.049e-002* 1.910e-002*cos(t)+ 9.992e-001* 7.068e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.475e-001, 4.806e-002 center
replot  1.475e-001+ 2.000*( 9.606e-001* 2.381e-002*cos(t)+-2.778e-001* 1.899e-002*sin(t)),  4.806e-002 +2.000*( 2.778e-001* 2.381e-002*cos(t)+ 9.606e-001* 1.899e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.411e-001, 8.995e-002 center
replot  1.411e-001+ 2.000*( 1.230e-001* 5.144e-002*cos(t)+-9.924e-001* 2.748e-002*sin(t)),  8.995e-002 +2.000*( 9.924e-001* 5.144e-002*cos(t)+ 1.230e-001* 2.748e-002*sin(t)) not
set out;
set out "SEFsr/VARPIJGR_SEFsr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "SEFsr/VARPIJGR_SEFsr_123-13.svg"
set label "50" at  2.329e-003, 4.654e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  2.329e-003+ 2.000*( 9.863e-001* 2.130e-003*cos(t)+ 1.652e-001* 4.398e-004*sin(t)),  4.654e-004 +2.000*(-1.652e-001* 2.130e-003*cos(t)+ 9.863e-001* 4.398e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  3.992e-003, 9.123e-004 center
replot  3.992e-003+ 2.000*( 9.829e-001* 3.093e-003*cos(t)+ 1.839e-001* 7.196e-004*sin(t)),  9.123e-004 +2.000*(-1.839e-001* 3.093e-003*cos(t)+ 9.829e-001* 7.196e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  6.840e-003, 1.785e-003 center
replot  6.840e-003+ 2.000*( 9.795e-001* 4.348e-003*cos(t)+ 2.013e-001* 1.135e-003*sin(t)),  1.785e-003 +2.000*(-2.013e-001* 4.348e-003*cos(t)+ 9.795e-001* 1.135e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  1.171e-002, 3.485e-003 center
replot  1.171e-002+ 2.000*( 9.769e-001* 5.832e-003*cos(t)+ 2.135e-001* 1.707e-003*sin(t)),  3.485e-003 +2.000*(-2.135e-001* 5.832e-003*cos(t)+ 9.769e-001* 1.707e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  2.000e-002, 6.782e-003 center
replot  2.000e-002+ 2.000*( 9.772e-001* 7.310e-003*cos(t)+ 2.123e-001* 2.423e-003*sin(t)),  6.782e-003 +2.000*(-2.123e-001* 7.310e-003*cos(t)+ 9.772e-001* 2.423e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  3.408e-002, 1.313e-002 center
replot  3.408e-002+ 2.000*( 9.806e-001* 8.485e-003*cos(t)+ 1.960e-001* 3.438e-003*sin(t)),  1.313e-002 +2.000*(-1.960e-001* 8.485e-003*cos(t)+ 9.806e-001* 3.438e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  5.776e-002, 2.526e-002 center
replot  5.776e-002+ 2.000*( 9.340e-001* 1.089e-002*cos(t)+ 3.574e-001* 6.365e-003*sin(t)),  2.526e-002 +2.000*(-3.574e-001* 1.089e-002*cos(t)+ 9.340e-001* 6.365e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  9.709e-002, 4.806e-002 center
replot  9.709e-002+ 2.000*( 7.332e-001* 2.474e-002*cos(t)+ 6.800e-001* 1.318e-002*sin(t)),  4.806e-002 +2.000*(-6.800e-001* 2.474e-002*cos(t)+ 7.332e-001* 1.318e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.610e-001, 8.995e-002 center
replot  1.610e-001+ 2.000*( 6.641e-001* 6.325e-002*cos(t)+ 7.476e-001* 2.940e-002*sin(t)),  8.995e-002 +2.000*(-7.476e-001* 6.325e-002*cos(t)+ 6.641e-001* 2.940e-002*sin(t)) not
set out;
set out "SEFsr/VARPIJGR_SEFsr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "SEFsr/VARPIJGR_SEFsr_123-21.svg"
set label "50" at  2.329e-003, 1.662e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  2.329e-003+ 2.000*( 2.719e-003* 3.189e-002*cos(t)+ 1.000e+000* 2.100e-003*sin(t)),  1.662e-001 +2.000*(-1.000e+000* 3.189e-002*cos(t)+ 2.719e-003* 2.100e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  3.992e-003, 1.644e-001 center
replot  3.992e-003+ 2.000*( 5.125e-003* 2.557e-002*cos(t)+ 1.000e+000* 3.041e-003*sin(t)),  1.644e-001 +2.000*(-1.000e+000* 2.557e-002*cos(t)+ 5.125e-003* 3.041e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  6.840e-003, 1.625e-001 center
replot  6.840e-003+ 2.000*( 1.017e-002* 2.003e-002*cos(t)+ 9.999e-001* 4.261e-003*sin(t)),  1.625e-001 +2.000*(-9.999e-001* 2.003e-002*cos(t)+ 1.017e-002* 4.261e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  1.171e-002, 1.605e-001 center
replot  1.171e-002+ 2.000*( 2.087e-002* 1.590e-002*cos(t)+ 9.998e-001* 5.701e-003*sin(t)),  1.605e-001 +2.000*(-9.998e-001* 1.590e-002*cos(t)+ 2.087e-002* 5.701e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  2.000e-002, 1.582e-001 center
replot  2.000e-002+ 2.000*( 3.739e-002* 1.424e-002*cos(t)+ 9.993e-001* 7.147e-003*sin(t)),  1.582e-001 +2.000*(-9.993e-001* 1.424e-002*cos(t)+ 3.739e-002* 7.147e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  3.408e-002, 1.555e-001 center
replot  3.408e-002+ 2.000*( 4.700e-002* 1.560e-002*cos(t)+ 9.989e-001* 8.325e-003*sin(t)),  1.555e-001 +2.000*(-9.989e-001* 1.560e-002*cos(t)+ 4.700e-002* 8.325e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  5.776e-002, 1.520e-001 center
replot  5.776e-002+ 2.000*( 6.873e-002* 1.912e-002*cos(t)+ 9.976e-001* 1.036e-002*sin(t)),  1.520e-001 +2.000*(-9.976e-001* 1.912e-002*cos(t)+ 6.873e-002* 1.036e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  9.709e-002, 1.475e-001 center
replot  9.709e-002+ 2.000*( 3.505e-001* 2.396e-002*cos(t)+ 9.366e-001* 1.966e-002*sin(t)),  1.475e-001 +2.000*(-9.366e-001* 2.396e-002*cos(t)+ 3.505e-001* 1.966e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.610e-001, 1.411e-001 center
replot  1.610e-001+ 2.000*( 9.862e-001* 4.785e-002*cos(t)+ 1.655e-001* 2.723e-002*sin(t)),  1.411e-001 +2.000*(-1.655e-001* 4.785e-002*cos(t)+ 9.862e-001* 2.723e-002*sin(t)) not
set out;
set out "SEFsr/VARPIJGR_SEFsr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "SEFsr/VARMUPTJGR--STABLBASED_SEFsr1.svg";
 plot "SEFsr/PRMORPREV-1-STABLBASED_SEFsr.txt"  u 1:($3) not w l lt 1 
 replot "SEFsr/PRMORPREV-1-STABLBASED_SEFsr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "SEFsr/PRMORPREV-1-STABLBASED_SEFsr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "SEFsr/VARMUPTJGR--STABLBASED_SEFsr1.svg";replot;set out;
