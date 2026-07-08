
# IMaCh-0.99r45
# HRFgali.gp
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


set ter svg size 640, 480;set out "HRFgali/D_HRFgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "HRFgali/ILK_HRFgali-dest.png";
set log y;plot  "HRFgali/ILK_HRFgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "HRFgali/ILK_HRFgali-ori.png";
set log y;plot  "HRFgali/ILK_HRFgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "HRFgali/ILK_HRFgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "HRFgali/ILK_HRFgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "HRFgali/ILK_HRFgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "HRFgali/ILK_HRFgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "HRFgali/V_HRFgali_1-1-1.svg" 

#set out "V_HRFgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "HRFgali/VPL_HRFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"HRFgali/VPL_HRFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"HRFgali/VPL_HRFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"HRFgali/P_HRFgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "HRFgali/V_HRFgali_2-1-1.svg" 

#set out "V_HRFgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "HRFgali/VPL_HRFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"HRFgali/VPL_HRFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"HRFgali/VPL_HRFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"HRFgali/P_HRFgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "HRFgali/E_HRFgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "HRFgali/T_HRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"HRFgali/T_HRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"HRFgali/T_HRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"HRFgali/T_HRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"HRFgali/T_HRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"HRFgali/T_HRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"HRFgali/T_HRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"HRFgali/T_HRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"HRFgali/T_HRFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "HRFgali/E_HRFgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "HRFgali/EXP_HRFgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "HRFgali/E_HRFgali.txt" every :::0::0 u 1:2 t "e11" w l ,"HRFgali/E_HRFgali.txt" every :::0::0 u 1:3 t "e12" w l ,"HRFgali/E_HRFgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "HRFgali/EXP_HRFgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "HRFgali/E_HRFgali.txt" every :::0::0 u 1:5 t "e21" w l ,"HRFgali/E_HRFgali.txt" every :::0::0 u 1:6 t "e22" w l ,"HRFgali/E_HRFgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "HRFgali/LIJ_HRFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFgali/PIJ_HRFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "HRFgali/LIJ_HRFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFgali/PIJ_HRFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "HRFgali/LIJT_HRFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFgali/PIJ_HRFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "HRFgali/LIJT_HRFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFgali/PIJ_HRFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "HRFgali/P_HRFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFgali/PIJ_HRFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "HRFgali/P_HRFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "HRFgali/PIJ_HRFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-6.841437; p2=0.059689; 
#   current state 3
p3=-17.511154; p4=0.173741; 
# initial state 2
#   current state 1
p5=-1.721186; p6=0.006025; 
#   current state 3
p7=-9.587851; p8=0.096608; 
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

set out "HRFgali/PE_HRFgali_1-1-1.svg" 
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

set out "HRFgali/PE_HRFgali_1-2-1.svg" 
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

set out "HRFgali/PE_HRFgali_1-3-1.svg" 
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
set out "HRFgali/VARPIJGR_HRFgali_113-12.svg"
set label "50" at  2.882e-004, 4.138e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  2.882e-004+ 2.000*( 3.589e-003* 1.003e-002*cos(t)+ 1.000e+000* 3.598e-004*sin(t)),  4.138e-002 +2.000*(-1.000e+000* 1.003e-002*cos(t)+ 3.589e-003* 3.598e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  6.819e-004, 5.536e-002 center
replot  6.819e-004+ 2.000*( 7.399e-003* 1.062e-002*cos(t)+ 1.000e+000* 7.190e-004*sin(t)),  5.536e-002 +2.000*(-1.000e+000* 1.062e-002*cos(t)+ 7.399e-003* 7.190e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.609e-003, 7.387e-002 center
replot  1.609e-003+ 2.000*( 1.574e-002* 1.086e-002*cos(t)+ 9.999e-001* 1.388e-003*sin(t)),  7.387e-002 +2.000*(-9.999e-001* 1.086e-002*cos(t)+ 1.574e-002* 1.388e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  3.783e-003, 9.819e-002 center
replot  3.783e-003+ 2.000*( 3.242e-002* 1.120e-002*cos(t)+ 9.995e-001* 2.554e-003*sin(t)),  9.819e-002 +2.000*(-9.995e-001* 1.120e-002*cos(t)+ 3.242e-002* 2.554e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  8.845e-003, 1.298e-001 center
replot  8.845e-003+ 2.000*( 5.111e-002* 1.337e-002*cos(t)+ 9.987e-001* 4.414e-003*sin(t)),  1.298e-001 +2.000*(-9.987e-001* 1.337e-002*cos(t)+ 5.111e-002* 4.414e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.050e-002, 1.700e-001 center
replot  2.050e-002+ 2.000*( 5.658e-002* 2.004e-002*cos(t)+ 9.984e-001* 7.157e-003*sin(t)),  1.700e-001 +2.000*(-9.984e-001* 2.004e-002*cos(t)+ 5.658e-002* 7.157e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  4.681e-002, 2.196e-001 center
replot  4.681e-002+ 2.000*( 7.808e-002* 3.264e-002*cos(t)+ 9.969e-001* 1.255e-002*sin(t)),  2.196e-001 +2.000*(-9.969e-001* 3.264e-002*cos(t)+ 7.808e-002* 1.255e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  1.042e-001, 2.764e-001 center
replot  1.042e-001+ 2.000*( 2.339e-001* 5.209e-002*cos(t)+ 9.723e-001* 3.125e-002*sin(t)),  2.764e-001 +2.000*(-9.723e-001* 5.209e-002*cos(t)+ 2.339e-001* 3.125e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  2.218e-001, 3.326e-001 center
replot  2.218e-001+ 2.000*( 8.606e-001* 1.012e-001*cos(t)+ 5.093e-001* 6.498e-002*sin(t)),  3.326e-001 +2.000*(-5.093e-001* 1.012e-001*cos(t)+ 8.606e-001* 6.498e-002*sin(t)) not
set out;
set out "HRFgali/VARPIJGR_HRFgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "HRFgali/VARPIJGR_HRFgali_121-12.svg"
set label "50" at  3.867e-001, 4.138e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  3.867e-001+ 2.000*( 9.993e-001* 8.869e-002*cos(t)+-3.839e-002* 9.443e-003*sin(t)),  4.138e-002 +2.000*( 3.839e-002* 8.869e-002*cos(t)+ 9.993e-001* 9.443e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.945e-001, 5.536e-002 center
replot  3.945e-001+ 2.000*( 9.989e-001* 7.211e-002*cos(t)+-4.788e-002* 1.006e-002*sin(t)),  5.536e-002 +2.000*( 4.788e-002* 7.211e-002*cos(t)+ 9.989e-001* 1.006e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  4.014e-001, 7.387e-002 center
replot  4.014e-001+ 2.000*( 9.982e-001* 5.707e-002*cos(t)+-5.965e-002* 1.033e-002*sin(t)),  7.387e-002 +2.000*( 5.965e-002* 5.707e-002*cos(t)+ 9.982e-001* 1.033e-002*sin(t)) not
# Age 65, p21 - p12
set label "65" at  4.067e-001, 9.819e-002 center
replot  4.067e-001+ 2.000*( 9.968e-001* 4.610e-002*cos(t)+-8.045e-002* 1.059e-002*sin(t)),  9.819e-002 +2.000*( 8.045e-002* 4.610e-002*cos(t)+ 9.968e-001* 1.059e-002*sin(t)) not
# Age 70, p21 - p12
set label "70" at  4.094e-001, 1.298e-001 center
replot  4.094e-001+ 2.000*( 9.915e-001* 4.326e-002*cos(t)+-1.299e-001* 1.222e-002*sin(t)),  1.298e-001 +2.000*( 1.299e-001* 4.326e-002*cos(t)+ 9.915e-001* 1.222e-002*sin(t)) not
# Age 75, p21 - p12
set label "75" at  4.081e-001, 1.700e-001 center
replot  4.081e-001+ 2.000*( 9.782e-001* 5.028e-002*cos(t)+-2.077e-001* 1.745e-002*sin(t)),  1.700e-001 +2.000*( 2.077e-001* 5.028e-002*cos(t)+ 9.782e-001* 1.745e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  4.007e-001, 2.196e-001 center
replot  4.007e-001+ 2.000*( 9.544e-001* 6.379e-002*cos(t)+-2.985e-001* 2.767e-002*sin(t)),  2.196e-001 +2.000*( 2.985e-001* 6.379e-002*cos(t)+ 9.544e-001* 2.767e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  3.849e-001, 2.764e-001 center
replot  3.849e-001+ 2.000*( 9.114e-001* 8.003e-002*cos(t)+-4.116e-001* 4.297e-002*sin(t)),  2.764e-001 +2.000*( 4.116e-001* 8.003e-002*cos(t)+ 9.114e-001* 4.297e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  3.583e-001, 3.326e-001 center
replot  3.583e-001+ 2.000*( 8.223e-001* 9.710e-002*cos(t)+-5.690e-001* 6.355e-002*sin(t)),  3.326e-001 +2.000*( 5.690e-001* 9.710e-002*cos(t)+ 8.223e-001* 6.355e-002*sin(t)) not
set out;
set out "HRFgali/VARPIJGR_HRFgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "HRFgali/VARPIJGR_HRFgali_123-12.svg"
set label "50" at  1.374e-002, 4.138e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  1.374e-002+ 2.000*( 1.938e-001* 1.009e-002*cos(t)+-9.810e-001* 8.284e-003*sin(t)),  4.138e-002 +2.000*( 9.810e-001* 1.009e-002*cos(t)+ 1.938e-001* 8.284e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.204e-002, 5.536e-002 center
replot  2.204e-002+ 2.000*( 8.984e-001* 1.144e-002*cos(t)+-4.392e-001* 1.042e-002*sin(t)),  5.536e-002 +2.000*( 4.392e-001* 1.144e-002*cos(t)+ 8.984e-001* 1.042e-002*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.528e-002, 7.387e-002 center
replot  3.528e-002+ 2.000*( 9.930e-001* 1.466e-002*cos(t)+-1.180e-001* 1.080e-002*sin(t)),  7.387e-002 +2.000*( 1.180e-001* 1.466e-002*cos(t)+ 9.930e-001* 1.080e-002*sin(t)) not
# Age 65, p23 - p12
set label "65" at  5.622e-002, 9.819e-002 center
replot  5.622e-002+ 2.000*( 9.975e-001* 1.812e-002*cos(t)+-7.108e-002* 1.115e-002*sin(t)),  9.819e-002 +2.000*( 7.108e-002* 1.812e-002*cos(t)+ 9.975e-001* 1.115e-002*sin(t)) not
# Age 70, p23 - p12
set label "70" at  8.903e-002, 1.298e-001 center
replot  8.903e-002+ 2.000*( 9.972e-001* 2.117e-002*cos(t)+-7.485e-002* 1.330e-002*sin(t)),  1.298e-001 +2.000*( 7.485e-002* 2.117e-002*cos(t)+ 9.972e-001* 1.330e-002*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.396e-001, 1.700e-001 center
replot  1.396e-001+ 2.000*( 9.772e-001* 2.420e-002*cos(t)+-2.123e-001* 1.980e-002*sin(t)),  1.700e-001 +2.000*( 2.123e-001* 2.420e-002*cos(t)+ 9.772e-001* 1.980e-002*sin(t)) not
# Age 80, p23 - p12
set label "80" at  2.156e-001, 2.196e-001 center
replot  2.156e-001+ 2.000*( 6.137e-001* 3.387e-002*cos(t)+-7.895e-001* 3.027e-002*sin(t)),  2.196e-001 +2.000*( 7.895e-001* 3.387e-002*cos(t)+ 6.137e-001* 3.027e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  3.256e-001, 2.764e-001 center
replot  3.256e-001+ 2.000*( 8.572e-001* 5.672e-002*cos(t)+-5.150e-001* 4.902e-002*sin(t)),  2.764e-001 +2.000*( 5.150e-001* 5.672e-002*cos(t)+ 8.572e-001* 4.902e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  4.768e-001, 3.326e-001 center
replot  4.768e-001+ 2.000*( 9.615e-001* 1.006e-001*cos(t)+-2.749e-001* 7.369e-002*sin(t)),  3.326e-001 +2.000*( 2.749e-001* 1.006e-001*cos(t)+ 9.615e-001* 7.369e-002*sin(t)) not
set out;
set out "HRFgali/VARPIJGR_HRFgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "HRFgali/VARPIJGR_HRFgali_121-13.svg"
set label "50" at  3.867e-001, 2.882e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  3.867e-001+ 2.000*( 1.000e+000* 8.863e-002*cos(t)+-1.450e-004* 3.614e-004*sin(t)),  2.882e-004 +2.000*( 1.450e-004* 8.863e-002*cos(t)+ 1.000e+000* 3.614e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.945e-001, 6.819e-004 center
replot  3.945e-001+ 2.000*( 1.000e+000* 7.203e-002*cos(t)+-3.523e-004* 7.228e-004*sin(t)),  6.819e-004 +2.000*( 3.523e-004* 7.203e-002*cos(t)+ 1.000e+000* 7.228e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  4.014e-001, 1.609e-003 center
replot  4.014e-001+ 2.000*( 1.000e+000* 5.697e-002*cos(t)+-8.940e-004* 1.397e-003*sin(t)),  1.609e-003 +2.000*( 8.940e-004* 5.697e-002*cos(t)+ 1.000e+000* 1.397e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  4.067e-001, 3.783e-003 center
replot  4.067e-001+ 2.000*( 1.000e+000* 4.596e-002*cos(t)+-2.309e-003* 2.577e-003*sin(t)),  3.783e-003 +2.000*( 2.309e-003* 4.596e-002*cos(t)+ 1.000e+000* 2.577e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  4.094e-001, 8.845e-003 center
replot  4.094e-001+ 2.000*( 1.000e+000* 4.292e-002*cos(t)+-5.274e-003* 4.456e-003*sin(t)),  8.845e-003 +2.000*( 5.274e-003* 4.292e-002*cos(t)+ 1.000e+000* 4.456e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  4.081e-001, 2.050e-002 center
replot  4.081e-001+ 2.000*( 9.999e-001* 4.932e-002*cos(t)+-1.033e-002* 7.217e-003*sin(t)),  2.050e-002 +2.000*( 1.033e-002* 4.932e-002*cos(t)+ 9.999e-001* 7.217e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  4.007e-001, 4.681e-002 center
replot  4.007e-001+ 2.000*( 9.997e-001* 6.145e-002*cos(t)+-2.241e-002* 1.270e-002*sin(t)),  4.681e-002 +2.000*( 2.241e-002* 6.145e-002*cos(t)+ 9.997e-001* 1.270e-002*sin(t)) not
# Age 85, p21 - p13
set label "85" at  3.849e-001, 1.042e-001 center
replot  3.849e-001+ 2.000*( 9.977e-001* 7.519e-002*cos(t)+-6.771e-002* 3.241e-002*sin(t)),  1.042e-001 +2.000*( 6.771e-002* 7.519e-002*cos(t)+ 9.977e-001* 3.241e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  3.583e-001, 2.218e-001 center
replot  3.583e-001+ 2.000*( 5.534e-001* 9.730e-002*cos(t)+-8.329e-001* 8.304e-002*sin(t)),  2.218e-001 +2.000*( 8.329e-001* 9.730e-002*cos(t)+ 5.534e-001* 8.304e-002*sin(t)) not
set out;
set out "HRFgali/VARPIJGR_HRFgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "HRFgali/VARPIJGR_HRFgali_123-13.svg"
set label "50" at  1.374e-002, 2.882e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  1.374e-002+ 2.000*( 9.999e-001* 8.360e-003*cos(t)+ 1.592e-002* 3.363e-004*sin(t)),  2.882e-004 +2.000*(-1.592e-002* 8.360e-003*cos(t)+ 9.999e-001* 3.363e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.204e-002, 6.819e-004 center
replot  2.204e-002+ 2.000*( 9.997e-001* 1.126e-002*cos(t)+ 2.374e-002* 6.723e-004*sin(t)),  6.819e-004 +2.000*(-2.374e-002* 1.126e-002*cos(t)+ 9.997e-001* 6.723e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.528e-002, 1.609e-003 center
replot  3.528e-002+ 2.000*( 9.994e-001* 1.462e-002*cos(t)+ 3.552e-002* 1.299e-003*sin(t)),  1.609e-003 +2.000*(-3.552e-002* 1.462e-002*cos(t)+ 9.994e-001* 1.299e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  5.622e-002, 3.783e-003 center
replot  5.622e-002+ 2.000*( 9.986e-001* 1.811e-002*cos(t)+ 5.332e-002* 2.394e-003*sin(t)),  3.783e-003 +2.000*(-5.332e-002* 1.811e-002*cos(t)+ 9.986e-001* 2.394e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  8.903e-002, 8.845e-003 center
replot  8.903e-002+ 2.000*( 9.968e-001* 2.120e-002*cos(t)+ 7.965e-002* 4.143e-003*sin(t)),  8.845e-003 +2.000*(-7.965e-002* 2.120e-002*cos(t)+ 9.968e-001* 4.143e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.396e-001, 2.050e-002 center
replot  1.396e-001+ 2.000*( 9.935e-001* 2.416e-002*cos(t)+ 1.135e-001* 6.738e-003*sin(t)),  2.050e-002 +2.000*(-1.135e-001* 2.416e-002*cos(t)+ 9.935e-001* 6.738e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  2.156e-001, 4.681e-002 center
replot  2.156e-001+ 2.000*( 9.884e-001* 3.199e-002*cos(t)+ 1.517e-001* 1.195e-002*sin(t)),  4.681e-002 +2.000*(-1.517e-001* 3.199e-002*cos(t)+ 9.884e-001* 1.195e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  3.256e-001, 1.042e-001 center
replot  3.256e-001+ 2.000*( 9.629e-001* 5.626e-002*cos(t)+ 2.699e-001* 3.012e-002*sin(t)),  1.042e-001 +2.000*(-2.699e-001* 5.626e-002*cos(t)+ 9.629e-001* 3.012e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  4.768e-001, 2.218e-001 center
replot  4.768e-001+ 2.000*( 7.652e-001* 1.113e-001*cos(t)+ 6.438e-001* 7.783e-002*sin(t)),  2.218e-001 +2.000*(-6.438e-001* 1.113e-001*cos(t)+ 7.652e-001* 7.783e-002*sin(t)) not
set out;
set out "HRFgali/VARPIJGR_HRFgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "HRFgali/VARPIJGR_HRFgali_123-21.svg"
set label "50" at  1.374e-002, 3.867e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.374e-002+ 2.000*( 6.648e-004* 8.863e-002*cos(t)+ 1.000e+000* 8.359e-003*sin(t)),  3.867e-001 +2.000*(-1.000e+000* 8.863e-002*cos(t)+ 6.648e-004* 8.359e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.204e-002, 3.945e-001 center
replot  2.204e-002+ 2.000*( 3.738e-003* 7.203e-002*cos(t)+ 1.000e+000* 1.125e-002*sin(t)),  3.945e-001 +2.000*(-1.000e+000* 7.203e-002*cos(t)+ 3.738e-003* 1.125e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.528e-002, 4.014e-001 center
replot  3.528e-002+ 2.000*( 1.322e-002* 5.698e-002*cos(t)+ 9.999e-001* 1.459e-002*sin(t)),  4.014e-001 +2.000*(-9.999e-001* 5.698e-002*cos(t)+ 1.322e-002* 1.459e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  5.622e-002, 4.067e-001 center
replot  5.622e-002+ 2.000*( 3.769e-002* 4.598e-002*cos(t)+ 9.993e-001* 1.802e-002*sin(t)),  4.067e-001 +2.000*(-9.993e-001* 4.598e-002*cos(t)+ 3.769e-002* 1.802e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  8.903e-002, 4.094e-001 center
replot  8.903e-002+ 2.000*( 6.783e-002* 4.300e-002*cos(t)+ 9.977e-001* 2.098e-002*sin(t)),  4.094e-001 +2.000*(-9.977e-001* 4.300e-002*cos(t)+ 6.783e-002* 2.098e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.396e-001, 4.081e-001 center
replot  1.396e-001+ 2.000*( 6.670e-002* 4.940e-002*cos(t)+ 9.978e-001* 2.385e-002*sin(t)),  4.081e-001 +2.000*(-9.978e-001* 4.940e-002*cos(t)+ 6.670e-002* 2.385e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  2.156e-001, 4.007e-001 center
replot  2.156e-001+ 2.000*( 7.988e-002* 6.158e-002*cos(t)+ 9.968e-001* 3.139e-002*sin(t)),  4.007e-001 +2.000*(-9.968e-001* 6.158e-002*cos(t)+ 7.988e-002* 3.139e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  3.256e-001, 3.849e-001 center
replot  3.256e-001+ 2.000*( 2.434e-001* 7.622e-002*cos(t)+ 9.699e-001* 5.314e-002*sin(t)),  3.849e-001 +2.000*(-9.699e-001* 7.622e-002*cos(t)+ 2.434e-001* 5.314e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  4.768e-001, 3.583e-001 center
replot  4.768e-001+ 2.000*( 8.371e-001* 1.064e-001*cos(t)+ 5.470e-001* 7.832e-002*sin(t)),  3.583e-001 +2.000*(-5.470e-001* 1.064e-001*cos(t)+ 8.371e-001* 7.832e-002*sin(t)) not
set out;
set out "HRFgali/VARPIJGR_HRFgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "HRFgali/VARMUPTJGR--STABLBASED_HRFgali1.svg";
 plot "HRFgali/PRMORPREV-1-STABLBASED_HRFgali.txt"  u 1:($3) not w l lt 1 
 replot "HRFgali/PRMORPREV-1-STABLBASED_HRFgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "HRFgali/PRMORPREV-1-STABLBASED_HRFgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "HRFgali/VARMUPTJGR--STABLBASED_HRFgali1.svg";replot;set out;
