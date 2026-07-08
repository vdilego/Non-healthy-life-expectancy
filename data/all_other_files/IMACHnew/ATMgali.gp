
# IMaCh-0.99r45
# ATMgali.gp
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


set ter svg size 640, 480;set out "ATMgali/D_ATMgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "ATMgali/ILK_ATMgali-dest.png";
set log y;plot  "ATMgali/ILK_ATMgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "ATMgali/ILK_ATMgali-ori.png";
set log y;plot  "ATMgali/ILK_ATMgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "ATMgali/ILK_ATMgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ATMgali/ILK_ATMgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "ATMgali/ILK_ATMgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ATMgali/ILK_ATMgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "ATMgali/V_ATMgali_1-1-1.svg" 

#set out "V_ATMgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ATMgali/VPL_ATMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"ATMgali/VPL_ATMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"ATMgali/VPL_ATMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"ATMgali/P_ATMgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "ATMgali/V_ATMgali_2-1-1.svg" 

#set out "V_ATMgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ATMgali/VPL_ATMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"ATMgali/VPL_ATMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"ATMgali/VPL_ATMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"ATMgali/P_ATMgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "ATMgali/E_ATMgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "ATMgali/T_ATMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"ATMgali/T_ATMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"ATMgali/T_ATMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"ATMgali/T_ATMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"ATMgali/T_ATMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"ATMgali/T_ATMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"ATMgali/T_ATMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"ATMgali/T_ATMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"ATMgali/T_ATMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "ATMgali/E_ATMgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "ATMgali/EXP_ATMgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ATMgali/E_ATMgali.txt" every :::0::0 u 1:2 t "e11" w l ,"ATMgali/E_ATMgali.txt" every :::0::0 u 1:3 t "e12" w l ,"ATMgali/E_ATMgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "ATMgali/EXP_ATMgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ATMgali/E_ATMgali.txt" every :::0::0 u 1:5 t "e21" w l ,"ATMgali/E_ATMgali.txt" every :::0::0 u 1:6 t "e22" w l ,"ATMgali/E_ATMgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "ATMgali/LIJ_ATMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATMgali/PIJ_ATMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "ATMgali/LIJ_ATMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATMgali/PIJ_ATMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "ATMgali/LIJT_ATMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATMgali/PIJ_ATMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "ATMgali/LIJT_ATMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATMgali/PIJ_ATMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "ATMgali/P_ATMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATMgali/PIJ_ATMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "ATMgali/P_ATMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATMgali/PIJ_ATMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-6.410649; p2=0.041761; 
#   current state 3
p3=-16.080402; p4=0.144720; 
# initial state 2
#   current state 1
p5=-0.759510; p6=-0.019314; 
#   current state 3
p7=-8.091528; p8=0.076330; 
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

set out "ATMgali/PE_ATMgali_1-1-1.svg" 
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

set out "ATMgali/PE_ATMgali_1-2-1.svg" 
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

set out "ATMgali/PE_ATMgali_1-3-1.svg" 
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
set out "ATMgali/VARPIJGR_ATMgali_113-12.svg"
set label "50" at  2.846e-004, 2.618e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  2.846e-004+ 2.000*( 5.346e-003* 6.922e-003*cos(t)+ 1.000e+000* 3.772e-004*sin(t)),  2.618e-002 +2.000*(-1.000e+000* 6.922e-003*cos(t)+ 5.346e-003* 3.772e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  5.848e-004, 3.216e-002 center
replot  5.848e-004+ 2.000*( 1.101e-002* 6.757e-003*cos(t)+ 9.999e-001* 6.547e-004*sin(t)),  3.216e-002 +2.000*(-9.999e-001* 6.757e-003*cos(t)+ 1.101e-002* 6.547e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.201e-003, 3.946e-002 center
replot  1.201e-003+ 2.000*( 2.442e-002* 6.410e-003*cos(t)+ 9.997e-001* 1.102e-003*sin(t)),  3.946e-002 +2.000*(-9.997e-001* 6.410e-003*cos(t)+ 2.442e-002* 1.102e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  2.463e-003, 4.837e-002 center
replot  2.463e-003+ 2.000*( 5.547e-002* 6.213e-003*cos(t)+ 9.985e-001* 1.781e-003*sin(t)),  4.837e-002 +2.000*(-9.985e-001* 6.213e-003*cos(t)+ 5.547e-002* 1.781e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  5.044e-003, 5.920e-002 center
replot  5.044e-003+ 2.000*( 1.005e-001* 7.093e-003*cos(t)+ 9.949e-001* 2.761e-003*sin(t)),  5.920e-002 +2.000*(-9.949e-001* 7.093e-003*cos(t)+ 1.005e-001* 2.761e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.030e-002, 7.225e-002 center
replot  1.030e-002+ 2.000*( 1.254e-001* 1.016e-002*cos(t)+ 9.921e-001* 4.287e-003*sin(t)),  7.225e-002 +2.000*(-9.921e-001* 1.016e-002*cos(t)+ 1.254e-001* 4.287e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  2.095e-002, 8.781e-002 center
replot  2.095e-002+ 2.000*( 1.613e-001* 1.586e-002*cos(t)+ 9.869e-001* 7.733e-003*sin(t)),  8.781e-002 +2.000*(-9.869e-001* 1.586e-002*cos(t)+ 1.613e-001* 7.733e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  4.230e-002, 1.059e-001 center
replot  4.230e-002+ 2.000*( 3.695e-001* 2.487e-002*cos(t)+ 9.292e-001* 1.772e-002*sin(t)),  1.059e-001 +2.000*(-9.292e-001* 2.487e-002*cos(t)+ 3.695e-001* 1.772e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  8.428e-002, 1.262e-001 center
replot  8.428e-002+ 2.000*( 9.465e-001* 4.978e-002*cos(t)+ 3.227e-001* 3.315e-002*sin(t)),  1.262e-001 +2.000*(-3.227e-001* 4.978e-002*cos(t)+ 9.465e-001* 3.315e-002*sin(t)) not
set out;
set out "ATMgali/VARPIJGR_ATMgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ATMgali/VARPIJGR_ATMgali_121-12.svg"
set label "50" at  2.989e-001, 2.618e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  2.989e-001+ 2.000*( 9.998e-001* 7.442e-002*cos(t)+-2.130e-002* 6.739e-003*sin(t)),  2.618e-002 +2.000*( 2.130e-002* 7.442e-002*cos(t)+ 9.998e-001* 6.739e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  2.736e-001, 3.216e-002 center
replot  2.736e-001+ 2.000*( 9.996e-001* 5.439e-002*cos(t)+-2.880e-002* 6.575e-003*sin(t)),  3.216e-002 +2.000*( 2.880e-002* 5.439e-002*cos(t)+ 9.996e-001* 6.575e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.496e-001, 3.946e-002 center
replot  2.496e-001+ 2.000*( 9.993e-001* 3.915e-002*cos(t)+-3.871e-002* 6.231e-003*sin(t)),  3.946e-002 +2.000*( 3.871e-002* 3.915e-002*cos(t)+ 9.993e-001* 6.231e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.265e-001, 4.837e-002 center
replot  2.265e-001+ 2.000*( 9.988e-001* 3.046e-002*cos(t)+-4.928e-002* 6.027e-003*sin(t)),  4.837e-002 +2.000*( 4.928e-002* 3.046e-002*cos(t)+ 9.988e-001* 6.027e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.043e-001, 5.920e-002 center
replot  2.043e-001+ 2.000*( 9.982e-001* 2.935e-002*cos(t)+-5.929e-002* 6.857e-003*sin(t)),  5.920e-002 +2.000*( 5.929e-002* 2.935e-002*cos(t)+ 9.982e-001* 6.857e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.826e-001, 7.225e-002 center
replot  1.826e-001+ 2.000*( 9.971e-001* 3.316e-002*cos(t)+-7.656e-002* 9.794e-003*sin(t)),  7.225e-002 +2.000*( 7.656e-002* 3.316e-002*cos(t)+ 9.971e-001* 9.794e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.613e-001, 8.781e-002 center
replot  1.613e-001+ 2.000*( 9.940e-001* 3.814e-002*cos(t)+-1.095e-001* 1.523e-002*sin(t)),  8.781e-002 +2.000*( 1.095e-001* 3.814e-002*cos(t)+ 9.940e-001* 1.523e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.403e-001, 1.059e-001 center
replot  1.403e-001+ 2.000*( 9.844e-001* 4.229e-002*cos(t)+-1.758e-001* 2.320e-002*sin(t)),  1.059e-001 +2.000*( 1.758e-001* 4.229e-002*cos(t)+ 9.844e-001* 2.320e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.195e-001, 1.262e-001 center
replot  1.195e-001+ 2.000*( 9.315e-001* 4.524e-002*cos(t)+-3.636e-001* 3.347e-002*sin(t)),  1.262e-001 +2.000*( 3.636e-001* 4.524e-002*cos(t)+ 9.315e-001* 3.347e-002*sin(t)) not
set out;
set out "ATMgali/VARPIJGR_ATMgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ATMgali/VARPIJGR_ATMgali_123-12.svg"
set label "50" at  2.334e-002, 2.618e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  2.334e-002+ 2.000*( 9.995e-001* 1.069e-002*cos(t)+-3.235e-002* 6.917e-003*sin(t)),  2.618e-002 +2.000*( 3.235e-002* 1.069e-002*cos(t)+ 9.995e-001* 6.917e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  3.447e-002, 3.216e-002 center
replot  3.447e-002+ 2.000*( 9.997e-001* 1.324e-002*cos(t)+-2.615e-002* 6.750e-003*sin(t)),  3.216e-002 +2.000*( 2.615e-002* 1.324e-002*cos(t)+ 9.997e-001* 6.750e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  5.073e-002, 3.946e-002 center
replot  5.073e-002+ 2.000*( 9.997e-001* 1.589e-002*cos(t)+-2.549e-002* 6.398e-003*sin(t)),  3.946e-002 +2.000*( 2.549e-002* 1.589e-002*cos(t)+ 9.997e-001* 6.398e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  7.428e-002, 4.837e-002 center
replot  7.428e-002+ 2.000*( 9.996e-001* 1.845e-002*cos(t)+-2.970e-002* 6.183e-003*sin(t)),  4.837e-002 +2.000*( 2.970e-002* 1.845e-002*cos(t)+ 9.996e-001* 6.183e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  1.081e-001, 5.920e-002 center
replot  1.081e-001+ 2.000*( 9.992e-001* 2.105e-002*cos(t)+-4.105e-002* 7.016e-003*sin(t)),  5.920e-002 +2.000*( 4.105e-002* 2.105e-002*cos(t)+ 9.992e-001* 7.016e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.558e-001, 7.225e-002 center
replot  1.558e-001+ 2.000*( 9.983e-001* 2.525e-002*cos(t)+-5.913e-002* 9.996e-003*sin(t)),  7.225e-002 +2.000*( 5.913e-002* 2.525e-002*cos(t)+ 9.983e-001* 9.996e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  2.221e-001, 8.781e-002 center
replot  2.221e-001+ 2.000*( 9.978e-001* 3.530e-002*cos(t)+-6.631e-002* 1.556e-002*sin(t)),  8.781e-002 +2.000*( 6.631e-002* 3.530e-002*cos(t)+ 9.978e-001* 1.556e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  3.115e-001, 1.059e-001 center
replot  3.115e-001+ 2.000*( 9.985e-001* 5.619e-002*cos(t)+-5.549e-002* 2.385e-002*sin(t)),  1.059e-001 +2.000*( 5.549e-002* 5.619e-002*cos(t)+ 9.985e-001* 2.385e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  4.280e-001, 1.262e-001 center
replot  4.280e-001+ 2.000*( 9.990e-001* 9.025e-002*cos(t)+-4.551e-002* 3.505e-002*sin(t)),  1.262e-001 +2.000*( 4.551e-002* 9.025e-002*cos(t)+ 9.990e-001* 3.505e-002*sin(t)) not
set out;
set out "ATMgali/VARPIJGR_ATMgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ATMgali/VARPIJGR_ATMgali_121-13.svg"
set label "50" at  2.989e-001, 2.846e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  2.989e-001+ 2.000*( 1.000e+000* 7.440e-002*cos(t)+-1.472e-004* 3.788e-004*sin(t)),  2.846e-004 +2.000*( 1.472e-004* 7.440e-002*cos(t)+ 1.000e+000* 3.788e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  2.736e-001, 5.848e-004 center
replot  2.736e-001+ 2.000*( 1.000e+000* 5.436e-002*cos(t)+-3.041e-004* 6.587e-004*sin(t)),  5.848e-004 +2.000*( 3.041e-004* 5.436e-002*cos(t)+ 1.000e+000* 6.587e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.496e-001, 1.201e-003 center
replot  2.496e-001+ 2.000*( 1.000e+000* 3.912e-002*cos(t)+-5.874e-004* 1.112e-003*sin(t)),  1.201e-003 +2.000*( 5.874e-004* 3.912e-002*cos(t)+ 1.000e+000* 1.112e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.265e-001, 2.463e-003 center
replot  2.265e-001+ 2.000*( 1.000e+000* 3.043e-002*cos(t)+-1.062e-003* 1.811e-003*sin(t)),  2.463e-003 +2.000*( 1.062e-003* 3.043e-002*cos(t)+ 1.000e+000* 1.811e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.043e-001, 5.044e-003 center
replot  2.043e-001+ 2.000*( 1.000e+000* 2.930e-002*cos(t)+-2.351e-003* 2.837e-003*sin(t)),  5.044e-003 +2.000*( 2.351e-003* 2.930e-002*cos(t)+ 1.000e+000* 2.837e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.826e-001, 1.030e-002 center
replot  1.826e-001+ 2.000*( 1.000e+000* 3.307e-002*cos(t)+-6.410e-003* 4.435e-003*sin(t)),  1.030e-002 +2.000*( 6.410e-003* 3.307e-002*cos(t)+ 1.000e+000* 4.435e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.613e-001, 2.095e-002 center
replot  1.613e-001+ 2.000*( 9.998e-001* 3.796e-002*cos(t)+-1.758e-002* 8.022e-003*sin(t)),  2.095e-002 +2.000*( 1.758e-002* 3.796e-002*cos(t)+ 9.998e-001* 8.022e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.403e-001, 4.230e-002 center
replot  1.403e-001+ 2.000*( 9.985e-001* 4.188e-002*cos(t)+-5.455e-002* 1.875e-002*sin(t)),  4.230e-002 +2.000*( 5.455e-002* 4.188e-002*cos(t)+ 9.985e-001* 1.875e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.195e-001, 8.428e-002 center
replot  1.195e-001+ 2.000*( 3.947e-001* 4.927e-002*cos(t)+-9.188e-001* 4.279e-002*sin(t)),  8.428e-002 +2.000*( 9.188e-001* 4.927e-002*cos(t)+ 3.947e-001* 4.279e-002*sin(t)) not
set out;
set out "ATMgali/VARPIJGR_ATMgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ATMgali/VARPIJGR_ATMgali_123-13.svg"
set label "50" at  2.334e-002, 2.846e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  2.334e-002+ 2.000*( 1.000e+000* 1.069e-002*cos(t)+ 8.815e-003* 3.671e-004*sin(t)),  2.846e-004 +2.000*(-8.815e-003* 1.069e-002*cos(t)+ 1.000e+000* 3.671e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  3.447e-002, 5.848e-004 center
replot  3.447e-002+ 2.000*( 9.999e-001* 1.324e-002*cos(t)+ 1.286e-002* 6.366e-004*sin(t)),  5.848e-004 +2.000*(-1.286e-002* 1.324e-002*cos(t)+ 9.999e-001* 6.366e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  5.073e-002, 1.201e-003 center
replot  5.073e-002+ 2.000*( 9.998e-001* 1.589e-002*cos(t)+ 1.907e-002* 1.071e-003*sin(t)),  1.201e-003 +2.000*(-1.907e-002* 1.589e-002*cos(t)+ 9.998e-001* 1.071e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  7.428e-002, 2.463e-003 center
replot  7.428e-002+ 2.000*( 9.996e-001* 1.845e-002*cos(t)+ 2.867e-002* 1.733e-003*sin(t)),  2.463e-003 +2.000*(-2.867e-002* 1.845e-002*cos(t)+ 9.996e-001* 1.733e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  1.081e-001, 5.044e-003 center
replot  1.081e-001+ 2.000*( 9.991e-001* 2.105e-002*cos(t)+ 4.260e-002* 2.695e-003*sin(t)),  5.044e-003 +2.000*(-4.260e-002* 2.105e-002*cos(t)+ 9.991e-001* 2.695e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.558e-001, 1.030e-002 center
replot  1.558e-001+ 2.000*( 9.984e-001* 2.526e-002*cos(t)+ 5.730e-002* 4.204e-003*sin(t)),  1.030e-002 +2.000*(-5.730e-002* 2.526e-002*cos(t)+ 9.984e-001* 4.204e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  2.221e-001, 2.095e-002 center
replot  2.221e-001+ 2.000*( 9.979e-001* 3.531e-002*cos(t)+ 6.553e-002* 7.726e-003*sin(t)),  2.095e-002 +2.000*(-6.553e-002* 3.531e-002*cos(t)+ 9.979e-001* 7.726e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  3.115e-001, 4.230e-002 center
replot  3.115e-001+ 2.000*( 9.968e-001* 5.628e-002*cos(t)+ 7.982e-002* 1.838e-002*sin(t)),  4.230e-002 +2.000*(-7.982e-002* 5.628e-002*cos(t)+ 9.968e-001* 1.838e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  4.280e-001, 8.428e-002 center
replot  4.280e-001+ 2.000*( 9.911e-001* 9.076e-002*cos(t)+ 1.332e-001* 4.720e-002*sin(t)),  8.428e-002 +2.000*(-1.332e-001* 9.076e-002*cos(t)+ 9.911e-001* 4.720e-002*sin(t)) not
set out;
set out "ATMgali/VARPIJGR_ATMgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "ATMgali/VARPIJGR_ATMgali_123-21.svg"
set label "50" at  2.334e-002, 2.989e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  2.334e-002+ 2.000*( 6.998e-003* 7.441e-002*cos(t)+ 1.000e+000* 1.068e-002*sin(t)),  2.989e-001 +2.000*(-1.000e+000* 7.441e-002*cos(t)+ 6.998e-003* 1.068e-002*sin(t)) not
# Age 55, p23 - p21
set label "55" at  3.447e-002, 2.736e-001 center
replot  3.447e-002+ 2.000*( 1.203e-002* 5.437e-002*cos(t)+ 9.999e-001* 1.322e-002*sin(t)),  2.736e-001 +2.000*(-9.999e-001* 5.437e-002*cos(t)+ 1.203e-002* 1.322e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  5.073e-002, 2.496e-001 center
replot  5.073e-002+ 2.000*( 2.577e-002* 3.913e-002*cos(t)+ 9.997e-001* 1.586e-002*sin(t)),  2.496e-001 +2.000*(-9.997e-001* 3.913e-002*cos(t)+ 2.577e-002* 1.586e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  7.428e-002, 2.265e-001 center
replot  7.428e-002+ 2.000*( 6.460e-002* 3.047e-002*cos(t)+ 9.979e-001* 1.837e-002*sin(t)),  2.265e-001 +2.000*(-9.979e-001* 3.047e-002*cos(t)+ 6.460e-002* 1.837e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  1.081e-001, 2.043e-001 center
replot  1.081e-001+ 2.000*( 1.191e-001* 2.940e-002*cos(t)+ 9.929e-001* 2.089e-002*sin(t)),  2.043e-001 +2.000*(-9.929e-001* 2.940e-002*cos(t)+ 1.191e-001* 2.089e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.558e-001, 1.826e-001 center
replot  1.558e-001+ 2.000*( 1.616e-001* 3.326e-002*cos(t)+ 9.869e-001* 2.496e-002*sin(t)),  1.826e-001 +2.000*(-9.869e-001* 3.326e-002*cos(t)+ 1.616e-001* 2.496e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  2.221e-001, 1.613e-001 center
replot  2.221e-001+ 2.000*( 4.571e-001* 3.888e-002*cos(t)+ 8.894e-001* 3.421e-002*sin(t)),  1.613e-001 +2.000*(-8.894e-001* 3.888e-002*cos(t)+ 4.571e-001* 3.421e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  3.115e-001, 1.403e-001 center
replot  3.115e-001+ 2.000*( 9.809e-001* 5.663e-002*cos(t)+ 1.947e-001* 4.114e-002*sin(t)),  1.403e-001 +2.000*(-1.947e-001* 5.663e-002*cos(t)+ 9.809e-001* 4.114e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  4.280e-001, 1.195e-001 center
replot  4.280e-001+ 2.000*( 9.951e-001* 9.051e-002*cos(t)+ 9.897e-002* 4.315e-002*sin(t)),  1.195e-001 +2.000*(-9.897e-002* 9.051e-002*cos(t)+ 9.951e-001* 4.315e-002*sin(t)) not
set out;
set out "ATMgali/VARPIJGR_ATMgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "ATMgali/VARMUPTJGR--STABLBASED_ATMgali1.svg";
 plot "ATMgali/PRMORPREV-1-STABLBASED_ATMgali.txt"  u 1:($3) not w l lt 1 
 replot "ATMgali/PRMORPREV-1-STABLBASED_ATMgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "ATMgali/PRMORPREV-1-STABLBASED_ATMgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "ATMgali/VARMUPTJGR--STABLBASED_ATMgali1.svg";replot;set out;
