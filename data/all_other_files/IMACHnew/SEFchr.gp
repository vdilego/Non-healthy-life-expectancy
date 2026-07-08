
# IMaCh-0.99r45
# SEFchr.gp
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


set ter svg size 640, 480;set out "SEFchr/D_SEFchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "SEFchr/ILK_SEFchr-dest.png";
set log y;plot  "SEFchr/ILK_SEFchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "SEFchr/ILK_SEFchr-ori.png";
set log y;plot  "SEFchr/ILK_SEFchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "SEFchr/ILK_SEFchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "SEFchr/ILK_SEFchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "SEFchr/ILK_SEFchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "SEFchr/ILK_SEFchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "SEFchr/V_SEFchr_1-1-1.svg" 

#set out "V_SEFchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "SEFchr/VPL_SEFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"SEFchr/VPL_SEFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"SEFchr/VPL_SEFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"SEFchr/P_SEFchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "SEFchr/V_SEFchr_2-1-1.svg" 

#set out "V_SEFchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "SEFchr/VPL_SEFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"SEFchr/VPL_SEFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"SEFchr/VPL_SEFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"SEFchr/P_SEFchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "SEFchr/E_SEFchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "SEFchr/T_SEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"SEFchr/T_SEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"SEFchr/T_SEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"SEFchr/T_SEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"SEFchr/T_SEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"SEFchr/T_SEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"SEFchr/T_SEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"SEFchr/T_SEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"SEFchr/T_SEFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "SEFchr/E_SEFchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "SEFchr/EXP_SEFchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "SEFchr/E_SEFchr.txt" every :::0::0 u 1:2 t "e11" w l ,"SEFchr/E_SEFchr.txt" every :::0::0 u 1:3 t "e12" w l ,"SEFchr/E_SEFchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "SEFchr/EXP_SEFchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "SEFchr/E_SEFchr.txt" every :::0::0 u 1:5 t "e21" w l ,"SEFchr/E_SEFchr.txt" every :::0::0 u 1:6 t "e22" w l ,"SEFchr/E_SEFchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "SEFchr/LIJ_SEFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFchr/PIJ_SEFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "SEFchr/LIJ_SEFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFchr/PIJ_SEFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "SEFchr/LIJT_SEFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFchr/PIJ_SEFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "SEFchr/LIJT_SEFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFchr/PIJ_SEFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "SEFchr/P_SEFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFchr/PIJ_SEFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "SEFchr/P_SEFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "SEFchr/PIJ_SEFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-4.317837; p2=0.062618; 
#   current state 3
p3=-39.553974; p4=0.453537; 
# initial state 2
#   current state 1
p5=1.350568; p6=-0.052500; 
#   current state 3
p7=-10.537569; p8=0.103407; 
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

set out "SEFchr/PE_SEFchr_1-1-1.svg" 
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

set out "SEFchr/PE_SEFchr_1-2-1.svg" 
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

set out "SEFchr/PE_SEFchr_1-3-1.svg" 
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
set out "SEFchr/VARPIJGR_SEFchr_113-12.svg"
set label "50" at  1.793e-008, 1.169e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  1.793e-008+ 2.000*( 1.506e-007* 1.608e-002*cos(t)+-1.000e+000* 9.547e-008*sin(t)),  1.169e-001 +2.000*( 1.000e+000* 1.608e-002*cos(t)+ 1.506e-007* 9.547e-008*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.595e-007, 1.472e-001 center
replot  1.595e-007+ 2.000*( 9.454e-007* 1.399e-002*cos(t)+-1.000e+000* 7.377e-007*sin(t)),  1.472e-001 +2.000*( 1.000e+000* 1.399e-002*cos(t)+ 9.454e-007* 7.377e-007*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.390e-006, 1.817e-001 center
replot  1.390e-006+ 2.000*( 3.638e-006* 1.180e-002*cos(t)+-1.000e+000* 5.460e-006*sin(t)),  1.817e-001 +2.000*( 1.000e+000* 1.180e-002*cos(t)+ 3.638e-006* 5.460e-006*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.184e-005, 2.192e-001 center
replot  1.184e-005+ 2.000*( 1.258e-005* 1.170e-002*cos(t)+ 1.000e+000* 3.828e-005*sin(t)),  2.192e-001 +2.000*(-1.000e+000* 1.170e-002*cos(t)+ 1.258e-005* 3.828e-005*sin(t)) not
# Age 70, p13 - p12
set label "70" at  9.843e-005, 2.581e-001 center
replot  9.843e-005+ 2.000*( 2.639e-004* 1.479e-002*cos(t)+ 1.000e+000* 2.501e-004*sin(t)),  2.581e-001 +2.000*(-1.000e+000* 1.479e-002*cos(t)+ 2.639e-004* 2.501e-004*sin(t)) not
# Age 75, p13 - p12
set label "75" at  7.978e-004, 2.963e-001 center
replot  7.978e-004+ 2.000*( 4.116e-003* 1.921e-002*cos(t)+ 1.000e+000* 1.478e-003*sin(t)),  2.963e-001 +2.000*(-1.000e+000* 1.921e-002*cos(t)+ 4.116e-003* 1.478e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  6.255e-003, 3.290e-001 center
replot  6.255e-003+ 2.000*( 7.651e-002* 2.341e-002*cos(t)+ 9.971e-001* 7.178e-003*sin(t)),  3.290e-001 +2.000*(-9.971e-001* 2.341e-002*cos(t)+ 7.651e-002* 7.178e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  4.474e-002, 3.332e-001 center
replot  4.474e-002+ 2.000*( 6.083e-001* 3.557e-002*cos(t)+ 7.937e-001* 1.643e-002*sin(t)),  3.332e-001 +2.000*(-7.937e-001* 3.557e-002*cos(t)+ 6.083e-001* 1.643e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  2.139e-001, 2.257e-001 center
replot  2.139e-001+ 2.000*( 7.736e-001* 8.991e-002*cos(t)+ 6.336e-001* 1.157e-002*sin(t)),  2.257e-001 +2.000*(-6.336e-001* 8.991e-002*cos(t)+ 7.736e-001* 1.157e-002*sin(t)) not
set out;
set out "SEFchr/VARPIJGR_SEFchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "SEFchr/VARPIJGR_SEFchr_121-12.svg"
set label "50" at  1.089e-001, 1.169e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  1.089e-001+ 2.000*( 9.883e-001* 1.776e-002*cos(t)+-1.527e-001* 1.604e-002*sin(t)),  1.169e-001 +2.000*( 1.527e-001* 1.776e-002*cos(t)+ 9.883e-001* 1.604e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  8.792e-002, 1.472e-001 center
replot  8.792e-002+ 2.000*( 8.665e-002* 1.401e-002*cos(t)+-9.962e-001* 1.160e-002*sin(t)),  1.472e-001 +2.000*( 9.962e-001* 1.401e-002*cos(t)+ 8.665e-002* 1.160e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  7.017e-002, 1.817e-001 center
replot  7.017e-002+ 2.000*( 3.557e-002* 1.181e-002*cos(t)+-9.994e-001* 7.343e-003*sin(t)),  1.817e-001 +2.000*( 9.994e-001* 1.181e-002*cos(t)+ 3.557e-002* 7.343e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  5.534e-002, 2.192e-001 center
replot  5.534e-002+ 2.000*( 1.840e-002* 1.170e-002*cos(t)+-9.998e-001* 5.089e-003*sin(t)),  2.192e-001 +2.000*( 9.998e-001* 1.170e-002*cos(t)+ 1.840e-002* 5.089e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  4.311e-002, 2.581e-001 center
replot  4.311e-002+ 2.000*( 1.013e-002* 1.479e-002*cos(t)+-9.999e-001* 4.538e-003*sin(t)),  2.581e-001 +2.000*( 9.999e-001* 1.479e-002*cos(t)+ 1.013e-002* 4.538e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  3.309e-002, 2.963e-001 center
replot  3.309e-002+ 2.000*( 6.654e-003* 1.921e-002*cos(t)+-1.000e+000* 4.640e-003*sin(t)),  2.963e-001 +2.000*( 1.000e+000* 1.921e-002*cos(t)+ 6.654e-003* 4.640e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.491e-002, 3.290e-001 center
replot  2.491e-002+ 2.000*( 3.902e-003* 2.335e-002*cos(t)+-1.000e+000* 4.648e-003*sin(t)),  3.290e-001 +2.000*( 1.000e+000* 2.335e-002*cos(t)+ 3.902e-003* 4.648e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.826e-002, 3.332e-001 center
replot  1.826e-002+ 2.000*( 1.233e-003* 2.995e-002*cos(t)+ 1.000e+000* 4.364e-003*sin(t)),  3.332e-001 +2.000*(-1.000e+000* 2.995e-002*cos(t)+ 1.233e-003* 4.364e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.291e-002, 2.257e-001 center
replot  1.291e-002+ 2.000*( 2.111e-003* 5.767e-002*cos(t)+ 1.000e+000* 3.819e-003*sin(t)),  2.257e-001 +2.000*(-1.000e+000* 5.767e-002*cos(t)+ 2.111e-003* 3.819e-003*sin(t)) not
set out;
set out "SEFchr/VARPIJGR_SEFchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "SEFchr/VARPIJGR_SEFchr_123-12.svg"
set label "50" at  1.817e-003, 1.169e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  1.817e-003+ 2.000*( 3.987e-004* 1.608e-002*cos(t)+-1.000e+000* 8.478e-004*sin(t)),  1.169e-001 +2.000*( 1.000e+000* 1.608e-002*cos(t)+ 3.987e-004* 8.478e-004*sin(t)) not
# Age 55, p23 - p12
set label "55" at  3.200e-003, 1.472e-001 center
replot  3.200e-003+ 2.000*( 4.283e-004* 1.399e-002*cos(t)+-1.000e+000* 1.251e-003*sin(t)),  1.472e-001 +2.000*( 1.000e+000* 1.399e-002*cos(t)+ 4.283e-004* 1.251e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  5.569e-003, 1.817e-001 center
replot  5.569e-003+ 2.000*( 2.722e-005* 1.180e-002*cos(t)+ 1.000e+000* 1.768e-003*sin(t)),  1.817e-001 +2.000*(-1.000e+000* 1.180e-002*cos(t)+ 2.722e-005* 1.768e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  9.577e-003, 2.192e-001 center
replot  9.577e-003+ 2.000*( 1.012e-003* 1.170e-002*cos(t)+ 1.000e+000* 2.371e-003*sin(t)),  2.192e-001 +2.000*(-1.000e+000* 1.170e-002*cos(t)+ 1.012e-003* 2.371e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  1.627e-002, 2.581e-001 center
replot  1.627e-002+ 2.000*( 5.382e-004* 1.479e-002*cos(t)+ 1.000e+000* 3.008e-003*sin(t)),  2.581e-001 +2.000*(-1.000e+000* 1.479e-002*cos(t)+ 5.382e-004* 3.008e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  2.722e-002, 2.963e-001 center
replot  2.722e-002+ 2.000*( 1.656e-003* 1.921e-002*cos(t)+-1.000e+000* 3.775e-003*sin(t)),  2.963e-001 +2.000*( 1.000e+000* 1.921e-002*cos(t)+ 1.656e-003* 3.775e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  4.469e-002, 3.290e-001 center
replot  4.469e-002+ 2.000*( 6.516e-003* 2.335e-002*cos(t)+-1.000e+000* 5.551e-003*sin(t)),  3.290e-001 +2.000*( 1.000e+000* 2.335e-002*cos(t)+ 6.516e-003* 5.551e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  7.144e-002, 3.332e-001 center
replot  7.144e-002+ 2.000*( 1.989e-002* 2.995e-002*cos(t)+-9.998e-001* 1.021e-002*sin(t)),  3.332e-001 +2.000*( 9.998e-001* 2.995e-002*cos(t)+ 1.989e-002* 1.021e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.101e-001, 2.257e-001 center
replot  1.101e-001+ 2.000*( 2.058e-002* 5.768e-002*cos(t)+-9.998e-001* 1.903e-002*sin(t)),  2.257e-001 +2.000*( 9.998e-001* 5.768e-002*cos(t)+ 2.058e-002* 1.903e-002*sin(t)) not
set out;
set out "SEFchr/VARPIJGR_SEFchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "SEFchr/VARPIJGR_SEFchr_121-13.svg"
set label "50" at  1.089e-001, 1.793e-008 center
# Age 50, p21 - p13
plot [-pi:pi]  1.089e-001+ 2.000*( 1.000e+000* 1.772e-002*cos(t)+ 3.114e-008* 9.550e-008*sin(t)),  1.793e-008 +2.000*(-3.114e-008* 1.772e-002*cos(t)+ 1.000e+000* 9.550e-008*sin(t)) not
# Age 55, p21 - p13
set label "55" at  8.792e-002, 1.595e-007 center
replot  8.792e-002+ 2.000*( 1.000e+000* 1.162e-002*cos(t)+ 2.305e-007* 7.378e-007*sin(t)),  1.595e-007 +2.000*(-2.305e-007* 1.162e-002*cos(t)+ 1.000e+000* 7.378e-007*sin(t)) not
# Age 60, p21 - p13
set label "60" at  7.017e-002, 1.390e-006 center
replot  7.017e-002+ 2.000*( 1.000e+000* 7.350e-003*cos(t)+ 1.285e-007* 5.460e-006*sin(t)),  1.390e-006 +2.000*(-1.285e-007* 7.350e-003*cos(t)+ 1.000e+000* 5.460e-006*sin(t)) not
# Age 65, p21 - p13
set label "65" at  5.534e-002, 1.184e-005 center
replot  5.534e-002+ 2.000*( 1.000e+000* 5.093e-003*cos(t)+-4.753e-005* 3.828e-005*sin(t)),  1.184e-005 +2.000*( 4.753e-005* 5.093e-003*cos(t)+ 1.000e+000* 3.828e-005*sin(t)) not
# Age 70, p21 - p13
set label "70" at  4.311e-002, 9.843e-005 center
replot  4.311e-002+ 2.000*( 1.000e+000* 4.541e-003*cos(t)+-7.304e-004* 2.502e-004*sin(t)),  9.843e-005 +2.000*( 7.304e-004* 4.541e-003*cos(t)+ 1.000e+000* 2.502e-004*sin(t)) not
# Age 75, p21 - p13
set label "75" at  3.309e-002, 7.978e-004 center
replot  3.309e-002+ 2.000*( 1.000e+000* 4.642e-003*cos(t)+-6.572e-003* 1.480e-003*sin(t)),  7.978e-004 +2.000*( 6.572e-003* 4.642e-003*cos(t)+ 1.000e+000* 1.480e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.491e-002, 6.255e-003 center
replot  2.491e-002+ 2.000*( 2.678e-002* 7.379e-003*cos(t)+-9.996e-001* 4.646e-003*sin(t)),  6.255e-003 +2.000*( 9.996e-001* 7.379e-003*cos(t)+ 2.678e-002* 4.646e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.826e-002, 4.474e-002 center
replot  1.826e-002+ 2.000*( 7.511e-003* 2.526e-002*cos(t)+-1.000e+000* 4.360e-003*sin(t)),  4.474e-002 +2.000*( 1.000e+000* 2.526e-002*cos(t)+ 7.511e-003* 4.360e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.291e-002, 2.139e-001 center
replot  1.291e-002+ 2.000*( 2.122e-003* 6.995e-002*cos(t)+-1.000e+000* 3.818e-003*sin(t)),  2.139e-001 +2.000*( 1.000e+000* 6.995e-002*cos(t)+ 2.122e-003* 3.818e-003*sin(t)) not
set out;
set out "SEFchr/VARPIJGR_SEFchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "SEFchr/VARPIJGR_SEFchr_123-13.svg"
set label "50" at  1.817e-003, 1.793e-008 center
# Age 50, p23 - p13
plot [-pi:pi]  1.817e-003+ 2.000*( 1.000e+000* 8.479e-004*cos(t)+ 2.900e-007* 9.550e-008*sin(t)),  1.793e-008 +2.000*(-2.900e-007* 8.479e-004*cos(t)+ 1.000e+000* 9.550e-008*sin(t)) not
# Age 55, p23 - p13
set label "55" at  3.200e-003, 1.595e-007 center
replot  3.200e-003+ 2.000*( 1.000e+000* 1.251e-003*cos(t)+ 1.836e-006* 7.378e-007*sin(t)),  1.595e-007 +2.000*(-1.836e-006* 1.251e-003*cos(t)+ 1.000e+000* 7.378e-007*sin(t)) not
# Age 60, p23 - p13
set label "60" at  5.569e-003, 1.390e-006 center
replot  5.569e-003+ 2.000*( 1.000e+000* 1.768e-003*cos(t)+ 1.207e-005* 5.460e-006*sin(t)),  1.390e-006 +2.000*(-1.207e-005* 1.768e-003*cos(t)+ 1.000e+000* 5.460e-006*sin(t)) not
# Age 65, p23 - p13
set label "65" at  9.577e-003, 1.184e-005 center
replot  9.577e-003+ 2.000*( 1.000e+000* 2.371e-003*cos(t)+ 8.537e-005* 3.828e-005*sin(t)),  1.184e-005 +2.000*(-8.537e-005* 2.371e-003*cos(t)+ 1.000e+000* 3.828e-005*sin(t)) not
# Age 70, p23 - p13
set label "70" at  1.627e-002, 9.843e-005 center
replot  1.627e-002+ 2.000*( 1.000e+000* 3.008e-003*cos(t)+ 6.774e-004* 2.502e-004*sin(t)),  9.843e-005 +2.000*(-6.774e-004* 3.008e-003*cos(t)+ 1.000e+000* 2.502e-004*sin(t)) not
# Age 75, p23 - p13
set label "75" at  2.722e-002, 7.978e-004 center
replot  2.722e-002+ 2.000*( 1.000e+000* 3.775e-003*cos(t)+ 6.585e-003* 1.480e-003*sin(t)),  7.978e-004 +2.000*(-6.585e-003* 3.775e-003*cos(t)+ 1.000e+000* 1.480e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  4.469e-002, 6.255e-003 center
replot  4.469e-002+ 2.000*( 4.490e-002* 7.381e-003*cos(t)+ 9.990e-001* 5.549e-003*sin(t)),  6.255e-003 +2.000*(-9.990e-001* 7.381e-003*cos(t)+ 4.490e-002* 5.549e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  7.144e-002, 4.474e-002 center
replot  7.144e-002+ 2.000*( 2.357e-002* 2.527e-002*cos(t)+ 9.997e-001* 1.021e-002*sin(t)),  4.474e-002 +2.000*(-9.997e-001* 2.527e-002*cos(t)+ 2.357e-002* 1.021e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.101e-001, 2.139e-001 center
replot  1.101e-001+ 2.000*( 1.478e-002* 6.995e-002*cos(t)+ 9.999e-001* 1.903e-002*sin(t)),  2.139e-001 +2.000*(-9.999e-001* 6.995e-002*cos(t)+ 1.478e-002* 1.903e-002*sin(t)) not
set out;
set out "SEFchr/VARPIJGR_SEFchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "SEFchr/VARPIJGR_SEFchr_123-21.svg"
set label "50" at  1.817e-003, 1.089e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.817e-003+ 2.000*( 3.728e-003* 1.772e-002*cos(t)+ 1.000e+000* 8.453e-004*sin(t)),  1.089e-001 +2.000*(-1.000e+000* 1.772e-002*cos(t)+ 3.728e-003* 8.453e-004*sin(t)) not
# Age 55, p23 - p21
set label "55" at  3.200e-003, 8.792e-002 center
replot  3.200e-003+ 2.000*( 6.169e-003* 1.162e-002*cos(t)+ 1.000e+000* 1.249e-003*sin(t)),  8.792e-002 +2.000*(-1.000e+000* 1.162e-002*cos(t)+ 6.169e-003* 1.249e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  5.569e-003, 7.017e-002 center
replot  5.569e-003+ 2.000*( 1.169e-002* 7.351e-003*cos(t)+ 9.999e-001* 1.766e-003*sin(t)),  7.017e-002 +2.000*(-9.999e-001* 7.351e-003*cos(t)+ 1.169e-002* 1.766e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  9.577e-003, 5.534e-002 center
replot  9.577e-003+ 2.000*( 2.868e-002* 5.094e-003*cos(t)+ 9.996e-001* 2.367e-003*sin(t)),  5.534e-002 +2.000*(-9.996e-001* 5.094e-003*cos(t)+ 2.868e-002* 2.367e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  1.627e-002, 4.311e-002 center
replot  1.627e-002+ 2.000*( 6.930e-002* 4.547e-003*cos(t)+ 9.976e-001* 2.999e-003*sin(t)),  4.311e-002 +2.000*(-9.976e-001* 4.547e-003*cos(t)+ 6.930e-002* 2.999e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  2.722e-002, 3.309e-002 center
replot  2.722e-002+ 2.000*( 1.663e-001* 4.665e-003*cos(t)+ 9.861e-001* 3.747e-003*sin(t)),  3.309e-002 +2.000*(-9.861e-001* 4.665e-003*cos(t)+ 1.663e-001* 3.747e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  4.469e-002, 2.491e-002 center
replot  4.469e-002+ 2.000*( 9.738e-001* 5.601e-003*cos(t)+ 2.274e-001* 4.591e-003*sin(t)),  2.491e-002 +2.000*(-2.274e-001* 5.601e-003*cos(t)+ 9.738e-001* 4.591e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  7.144e-002, 1.826e-002 center
replot  7.144e-002+ 2.000*( 9.982e-001* 1.024e-002*cos(t)+ 6.018e-002* 4.328e-003*sin(t)),  1.826e-002 +2.000*(-6.018e-002* 1.024e-002*cos(t)+ 9.982e-001* 4.328e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.101e-001, 1.291e-002 center
replot  1.101e-001+ 2.000*( 9.994e-001* 1.907e-002*cos(t)+ 3.570e-002* 3.762e-003*sin(t)),  1.291e-002 +2.000*(-3.570e-002* 1.907e-002*cos(t)+ 9.994e-001* 3.762e-003*sin(t)) not
set out;
set out "SEFchr/VARPIJGR_SEFchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "SEFchr/VARMUPTJGR--STABLBASED_SEFchr1.svg";
 plot "SEFchr/PRMORPREV-1-STABLBASED_SEFchr.txt"  u 1:($3) not w l lt 1 
 replot "SEFchr/PRMORPREV-1-STABLBASED_SEFchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "SEFchr/PRMORPREV-1-STABLBASED_SEFchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "SEFchr/VARMUPTJGR--STABLBASED_SEFchr1.svg";replot;set out;
