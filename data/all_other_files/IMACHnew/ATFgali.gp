
# IMaCh-0.99r45
# ATFgali.gp
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


set ter svg size 640, 480;set out "ATFgali/D_ATFgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "ATFgali/ILK_ATFgali-dest.png";
set log y;plot  "ATFgali/ILK_ATFgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "ATFgali/ILK_ATFgali-ori.png";
set log y;plot  "ATFgali/ILK_ATFgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "ATFgali/ILK_ATFgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ATFgali/ILK_ATFgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "ATFgali/ILK_ATFgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ATFgali/ILK_ATFgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "ATFgali/V_ATFgali_1-1-1.svg" 

#set out "V_ATFgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ATFgali/VPL_ATFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"ATFgali/VPL_ATFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"ATFgali/VPL_ATFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"ATFgali/P_ATFgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "ATFgali/V_ATFgali_2-1-1.svg" 

#set out "V_ATFgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ATFgali/VPL_ATFgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"ATFgali/VPL_ATFgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"ATFgali/VPL_ATFgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"ATFgali/P_ATFgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "ATFgali/E_ATFgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "ATFgali/T_ATFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"ATFgali/T_ATFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"ATFgali/T_ATFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"ATFgali/T_ATFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"ATFgali/T_ATFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"ATFgali/T_ATFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"ATFgali/T_ATFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"ATFgali/T_ATFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"ATFgali/T_ATFgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "ATFgali/E_ATFgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "ATFgali/EXP_ATFgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ATFgali/E_ATFgali.txt" every :::0::0 u 1:2 t "e11" w l ,"ATFgali/E_ATFgali.txt" every :::0::0 u 1:3 t "e12" w l ,"ATFgali/E_ATFgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "ATFgali/EXP_ATFgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ATFgali/E_ATFgali.txt" every :::0::0 u 1:5 t "e21" w l ,"ATFgali/E_ATFgali.txt" every :::0::0 u 1:6 t "e22" w l ,"ATFgali/E_ATFgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "ATFgali/LIJ_ATFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFgali/PIJ_ATFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "ATFgali/LIJ_ATFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFgali/PIJ_ATFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "ATFgali/LIJT_ATFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFgali/PIJ_ATFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "ATFgali/LIJT_ATFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFgali/PIJ_ATFgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "ATFgali/P_ATFgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFgali/PIJ_ATFgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "ATFgali/P_ATFgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFgali/PIJ_ATFgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-6.230987; p2=0.043967; 
#   current state 3
p3=-18.424637; p4=0.167419; 
# initial state 2
#   current state 1
p5=-0.475321; p6=-0.023150; 
#   current state 3
p7=-9.052733; p8=0.076582; 
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

set out "ATFgali/PE_ATFgali_1-1-1.svg" 
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

set out "ATFgali/PE_ATFgali_1-2-1.svg" 
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

set out "ATFgali/PE_ATFgali_1-3-1.svg" 
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
set out "ATFgali/VARPIJGR_ATFgali_113-12.svg"
set label "50" at  8.455e-005, 3.484e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  8.455e-005+ 2.000*( 1.980e-003* 6.894e-003*cos(t)+ 1.000e+000* 1.478e-004*sin(t)),  3.484e-002 +2.000*(-1.000e+000* 6.894e-003*cos(t)+ 1.980e-003* 1.478e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.944e-004, 4.321e-002 center
replot  1.944e-004+ 2.000*( 4.060e-003* 6.868e-003*cos(t)+ 1.000e+000* 2.897e-004*sin(t)),  4.321e-002 +2.000*(-1.000e+000* 6.868e-003*cos(t)+ 4.060e-003* 2.897e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  4.466e-004, 5.355e-002 center
replot  4.466e-004+ 2.000*( 8.612e-003* 6.631e-003*cos(t)+ 1.000e+000* 5.512e-004*sin(t)),  5.355e-002 +2.000*(-1.000e+000* 6.631e-003*cos(t)+ 8.612e-003* 5.512e-004*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.025e-003, 6.626e-002 center
replot  1.025e-003+ 2.000*( 1.848e-002* 6.396e-003*cos(t)+ 9.998e-001* 1.008e-003*sin(t)),  6.626e-002 +2.000*(-9.998e-001* 6.396e-003*cos(t)+ 1.848e-002* 1.008e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  2.346e-003, 8.182e-002 center
replot  2.346e-003+ 2.000*( 3.521e-002* 6.901e-003*cos(t)+ 9.994e-001* 1.750e-003*sin(t)),  8.182e-002 +2.000*(-9.994e-001* 6.901e-003*cos(t)+ 3.521e-002* 1.750e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  5.356e-003, 1.008e-001 center
replot  5.356e-003+ 2.000*( 5.249e-002* 9.325e-003*cos(t)+ 9.986e-001* 2.873e-003*sin(t)),  1.008e-001 +2.000*(-9.986e-001* 9.325e-003*cos(t)+ 5.249e-002* 2.873e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  1.218e-002, 1.236e-001 center
replot  1.218e-002+ 2.000*( 7.824e-002* 1.436e-002*cos(t)+ 9.969e-001* 4.859e-003*sin(t)),  1.236e-001 +2.000*(-9.969e-001* 1.436e-002*cos(t)+ 7.824e-002* 4.859e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  2.749e-002, 1.505e-001 center
replot  2.749e-002+ 2.000*( 1.660e-001* 2.232e-002*cos(t)+ 9.861e-001* 1.119e-002*sin(t)),  1.505e-001 +2.000*(-9.861e-001* 2.232e-002*cos(t)+ 1.660e-001* 1.119e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  6.125e-002, 1.809e-001 center
replot  6.125e-002+ 2.000*( 7.744e-001* 3.832e-002*cos(t)+ 6.327e-001* 2.874e-002*sin(t)),  1.809e-001 +2.000*(-6.327e-001* 3.832e-002*cos(t)+ 7.744e-001* 2.874e-002*sin(t)) not
set out;
set out "ATFgali/VARPIJGR_ATFgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ATFgali/VARPIJGR_ATFgali_121-12.svg"
set label "50" at  3.254e-001, 3.484e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  3.254e-001+ 2.000*( 9.996e-001* 6.584e-002*cos(t)+-2.986e-002* 6.611e-003*sin(t)),  3.484e-002 +2.000*( 2.986e-002* 6.584e-002*cos(t)+ 9.996e-001* 6.611e-003*sin(t)) not
# Age 55, p21 - p12
set label "55" at  2.945e-001, 4.321e-002 center
replot  2.945e-001+ 2.000*( 9.992e-001* 4.985e-002*cos(t)+-4.003e-002* 6.577e-003*sin(t)),  4.321e-002 +2.000*( 4.003e-002* 4.985e-002*cos(t)+ 9.992e-001* 6.577e-003*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.657e-001, 5.355e-002 center
replot  2.657e-001+ 2.000*( 9.986e-001* 3.703e-002*cos(t)+-5.360e-002* 6.335e-003*sin(t)),  5.355e-002 +2.000*( 5.360e-002* 3.703e-002*cos(t)+ 9.986e-001* 6.335e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.391e-001, 6.626e-002 center
replot  2.391e-001+ 2.000*( 9.974e-001* 2.795e-002*cos(t)+-7.147e-002* 6.091e-003*sin(t)),  6.626e-002 +2.000*( 7.147e-002* 2.795e-002*cos(t)+ 9.974e-001* 6.091e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.143e-001, 8.182e-002 center
replot  2.143e-001+ 2.000*( 9.954e-001* 2.332e-002*cos(t)+-9.628e-002* 6.552e-003*sin(t)),  8.182e-002 +2.000*( 9.628e-002* 2.332e-002*cos(t)+ 9.954e-001* 6.552e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.911e-001, 1.008e-001 center
replot  1.911e-001+ 2.000*( 9.904e-001* 2.291e-002*cos(t)+-1.386e-001* 8.841e-003*sin(t)),  1.008e-001 +2.000*( 1.386e-001* 2.291e-002*cos(t)+ 9.904e-001* 8.841e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.695e-001, 1.236e-001 center
replot  1.695e-001+ 2.000*( 9.744e-001* 2.507e-002*cos(t)+-2.250e-001* 1.351e-002*sin(t)),  1.236e-001 +2.000*( 2.250e-001* 2.507e-002*cos(t)+ 9.744e-001* 1.351e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.491e-001, 1.505e-001 center
replot  1.491e-001+ 2.000*( 8.962e-001* 2.846e-002*cos(t)+-4.437e-001* 2.023e-002*sin(t)),  1.505e-001 +2.000*( 4.437e-001* 2.846e-002*cos(t)+ 8.962e-001* 2.023e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  1.298e-001, 1.809e-001 center
replot  1.298e-001+ 2.000*( 5.256e-001* 3.511e-002*cos(t)+-8.507e-001* 2.629e-002*sin(t)),  1.809e-001 +2.000*( 8.507e-001* 3.511e-002*cos(t)+ 5.256e-001* 2.629e-002*sin(t)) not
set out;
set out "ATFgali/VARPIJGR_ATFgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ATFgali/VARPIJGR_ATFgali_123-12.svg"
set label "50" at  8.974e-003, 3.484e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  8.974e-003+ 2.000*( 8.677e-002* 6.903e-003*cos(t)+-9.962e-001* 5.560e-003*sin(t)),  3.484e-002 +2.000*( 9.962e-001* 6.903e-003*cos(t)+ 8.677e-002* 5.560e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.337e-002, 4.321e-002 center
replot  1.337e-002+ 2.000*( 8.837e-001* 7.133e-003*cos(t)+-4.681e-001* 6.792e-003*sin(t)),  4.321e-002 +2.000*( 4.681e-001* 7.133e-003*cos(t)+ 8.837e-001* 6.792e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  1.987e-002, 5.355e-002 center
replot  1.987e-002+ 2.000*( 9.967e-001* 8.693e-003*cos(t)+-8.157e-002* 6.614e-003*sin(t)),  5.355e-002 +2.000*( 8.157e-002* 8.693e-003*cos(t)+ 9.967e-001* 6.614e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  2.943e-002, 6.626e-002 center
replot  2.943e-002+ 2.000*( 9.986e-001* 1.029e-002*cos(t)+-5.378e-002* 6.380e-003*sin(t)),  6.626e-002 +2.000*( 5.378e-002* 1.029e-002*cos(t)+ 9.986e-001* 6.380e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  4.342e-002, 8.182e-002 center
replot  4.342e-002+ 2.000*( 9.981e-001* 1.166e-002*cos(t)+-6.121e-002* 6.873e-003*sin(t)),  8.182e-002 +2.000*( 6.121e-002* 1.166e-002*cos(t)+ 9.981e-001* 6.873e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  6.378e-002, 1.008e-001 center
replot  6.378e-002+ 2.000*( 9.912e-001* 1.289e-002*cos(t)+-1.325e-001* 9.237e-003*sin(t)),  1.008e-001 +2.000*( 1.325e-001* 1.289e-002*cos(t)+ 9.912e-001* 9.237e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  9.313e-002, 1.236e-001 center
replot  9.313e-002+ 2.000*( 8.715e-001* 1.581e-002*cos(t)+-4.905e-001* 1.381e-002*sin(t)),  1.236e-001 +2.000*( 4.905e-001* 1.581e-002*cos(t)+ 8.715e-001* 1.381e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.349e-001, 1.505e-001 center
replot  1.349e-001+ 2.000*( 8.553e-001* 2.443e-002*cos(t)+-5.181e-001* 2.117e-002*sin(t)),  1.505e-001 +2.000*( 5.181e-001* 2.443e-002*cos(t)+ 8.553e-001* 2.117e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.933e-001, 1.809e-001 center
replot  1.933e-001+ 2.000*( 9.724e-001* 4.298e-002*cos(t)+-2.335e-001* 3.223e-002*sin(t)),  1.809e-001 +2.000*( 2.335e-001* 4.298e-002*cos(t)+ 9.724e-001* 3.223e-002*sin(t)) not
set out;
set out "ATFgali/VARPIJGR_ATFgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ATFgali/VARPIJGR_ATFgali_121-13.svg"
set label "50" at  3.254e-001, 8.455e-005 center
# Age 50, p21 - p13
plot [-pi:pi]  3.254e-001+ 2.000*( 1.000e+000* 6.581e-002*cos(t)+-5.791e-006* 1.485e-004*sin(t)),  8.455e-005 +2.000*( 5.791e-006* 6.581e-002*cos(t)+ 1.000e+000* 1.485e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  2.945e-001, 1.944e-004 center
replot  2.945e-001+ 2.000*( 1.000e+000* 4.981e-002*cos(t)+-2.065e-005* 2.910e-004*sin(t)),  1.944e-004 +2.000*( 2.065e-005* 4.981e-002*cos(t)+ 1.000e+000* 2.910e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.657e-001, 4.466e-004 center
replot  2.657e-001+ 2.000*( 1.000e+000* 3.698e-002*cos(t)+-8.606e-005* 5.541e-004*sin(t)),  4.466e-004 +2.000*( 8.606e-005* 3.698e-002*cos(t)+ 1.000e+000* 5.541e-004*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.391e-001, 1.025e-003 center
replot  2.391e-001+ 2.000*( 1.000e+000* 2.788e-002*cos(t)+-3.663e-004* 1.015e-003*sin(t)),  1.025e-003 +2.000*( 3.663e-004* 2.788e-002*cos(t)+ 1.000e+000* 1.015e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.143e-001, 2.346e-003 center
replot  2.143e-001+ 2.000*( 1.000e+000* 2.322e-002*cos(t)+-1.293e-003* 1.766e-003*sin(t)),  2.346e-003 +2.000*( 1.293e-003* 2.322e-002*cos(t)+ 1.000e+000* 1.766e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.911e-001, 5.356e-003 center
replot  1.911e-001+ 2.000*( 1.000e+000* 2.273e-002*cos(t)+-3.383e-003* 2.909e-003*sin(t)),  5.356e-003 +2.000*( 3.383e-003* 2.273e-002*cos(t)+ 1.000e+000* 2.909e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.695e-001, 1.218e-002 center
replot  1.695e-001+ 2.000*( 1.000e+000* 2.461e-002*cos(t)+-7.947e-003* 4.969e-003*sin(t)),  1.218e-002 +2.000*( 7.947e-003* 2.461e-002*cos(t)+ 1.000e+000* 4.969e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.491e-001, 2.749e-002 center
replot  1.491e-001+ 2.000*( 9.997e-001* 2.705e-002*cos(t)+-2.420e-002* 1.162e-002*sin(t)),  2.749e-002 +2.000*( 2.420e-002* 2.705e-002*cos(t)+ 9.997e-001* 1.162e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  1.298e-001, 6.125e-002 center
replot  1.298e-001+ 2.000*( 1.349e-001* 3.490e-002*cos(t)+-9.909e-001* 2.888e-002*sin(t)),  6.125e-002 +2.000*( 9.909e-001* 3.490e-002*cos(t)+ 1.349e-001* 2.888e-002*sin(t)) not
set out;
set out "ATFgali/VARPIJGR_ATFgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ATFgali/VARPIJGR_ATFgali_123-13.svg"
set label "50" at  8.974e-003, 8.455e-005 center
# Age 50, p23 - p13
plot [-pi:pi]  8.974e-003+ 2.000*( 1.000e+000* 5.572e-003*cos(t)+ 8.981e-003* 1.398e-004*sin(t)),  8.455e-005 +2.000*(-8.981e-003* 5.572e-003*cos(t)+ 1.000e+000* 1.398e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.337e-002, 1.944e-004 center
replot  1.337e-002+ 2.000*( 9.999e-001* 7.060e-003*cos(t)+ 1.404e-002* 2.736e-004*sin(t)),  1.944e-004 +2.000*(-1.404e-002* 7.060e-003*cos(t)+ 9.999e-001* 2.736e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  1.987e-002, 4.466e-004 center
replot  1.987e-002+ 2.000*( 9.998e-001* 8.683e-003*cos(t)+ 2.208e-002* 5.201e-004*sin(t)),  4.466e-004 +2.000*(-2.208e-002* 8.683e-003*cos(t)+ 9.998e-001* 5.201e-004*sin(t)) not
# Age 65, p23 - p13
set label "65" at  2.943e-002, 1.025e-003 center
replot  2.943e-002+ 2.000*( 9.994e-001* 1.028e-002*cos(t)+ 3.490e-002* 9.501e-004*sin(t)),  1.025e-003 +2.000*(-3.490e-002* 1.028e-002*cos(t)+ 9.994e-001* 9.501e-004*sin(t)) not
# Age 70, p23 - p13
set label "70" at  4.342e-002, 2.346e-003 center
replot  4.342e-002+ 2.000*( 9.985e-001* 1.166e-002*cos(t)+ 5.524e-002* 1.647e-003*sin(t)),  2.346e-003 +2.000*(-5.524e-002* 1.166e-002*cos(t)+ 9.985e-001* 1.647e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  6.378e-002, 5.356e-003 center
replot  6.378e-002+ 2.000*( 9.964e-001* 1.288e-002*cos(t)+ 8.532e-002* 2.705e-003*sin(t)),  5.356e-003 +2.000*(-8.532e-002* 1.288e-002*cos(t)+ 9.964e-001* 2.705e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  9.313e-002, 1.218e-002 center
replot  9.313e-002+ 2.000*( 9.927e-001* 1.545e-002*cos(t)+ 1.207e-001* 4.644e-003*sin(t)),  1.218e-002 +2.000*(-1.207e-001* 1.545e-002*cos(t)+ 9.927e-001* 4.644e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.349e-001, 2.749e-002 center
replot  1.349e-001+ 2.000*( 9.830e-001* 2.392e-002*cos(t)+ 1.836e-001* 1.097e-002*sin(t)),  2.749e-002 +2.000*(-1.836e-001* 2.392e-002*cos(t)+ 9.830e-001* 1.097e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.933e-001, 6.125e-002 center
replot  1.933e-001+ 2.000*( 8.891e-001* 4.490e-002*cos(t)+ 4.578e-001* 3.159e-002*sin(t)),  6.125e-002 +2.000*(-4.578e-001* 4.490e-002*cos(t)+ 8.891e-001* 3.159e-002*sin(t)) not
set out;
set out "ATFgali/VARPIJGR_ATFgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "ATFgali/VARPIJGR_ATFgali_123-21.svg"
set label "50" at  8.974e-003, 3.254e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  8.974e-003+ 2.000*( 2.371e-003* 6.581e-002*cos(t)+ 1.000e+000* 5.570e-003*sin(t)),  3.254e-001 +2.000*(-1.000e+000* 6.581e-002*cos(t)+ 2.371e-003* 5.570e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.337e-002, 2.945e-001 center
replot  1.337e-002+ 2.000*( 3.970e-003* 4.981e-002*cos(t)+ 1.000e+000* 7.057e-003*sin(t)),  2.945e-001 +2.000*(-1.000e+000* 4.981e-002*cos(t)+ 3.970e-003* 7.057e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  1.987e-002, 2.657e-001 center
replot  1.987e-002+ 2.000*( 7.938e-003* 3.698e-002*cos(t)+ 1.000e+000* 8.676e-003*sin(t)),  2.657e-001 +2.000*(-1.000e+000* 3.698e-002*cos(t)+ 7.938e-003* 8.676e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  2.943e-002, 2.391e-001 center
replot  2.943e-002+ 2.000*( 1.801e-002* 2.789e-002*cos(t)+ 9.998e-001* 1.027e-002*sin(t)),  2.391e-001 +2.000*(-9.998e-001* 2.789e-002*cos(t)+ 1.801e-002* 1.027e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  4.342e-002, 2.143e-001 center
replot  4.342e-002+ 2.000*( 3.672e-002* 2.323e-002*cos(t)+ 9.993e-001* 1.162e-002*sin(t)),  2.143e-001 +2.000*(-9.993e-001* 2.323e-002*cos(t)+ 3.672e-002* 1.162e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  6.378e-002, 1.911e-001 center
replot  6.378e-002+ 2.000*( 5.145e-002* 2.275e-002*cos(t)+ 9.987e-001* 1.280e-002*sin(t)),  1.911e-001 +2.000*(-9.987e-001* 2.275e-002*cos(t)+ 5.145e-002* 1.280e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  9.313e-002, 1.695e-001 center
replot  9.313e-002+ 2.000*( 6.549e-002* 2.465e-002*cos(t)+ 9.979e-001* 1.530e-002*sin(t)),  1.695e-001 +2.000*(-9.979e-001* 2.465e-002*cos(t)+ 6.549e-002* 1.530e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.349e-001, 1.491e-001 center
replot  1.349e-001+ 2.000*( 2.399e-001* 2.725e-002*cos(t)+ 9.708e-001* 2.336e-002*sin(t)),  1.491e-001 +2.000*(-9.708e-001* 2.725e-002*cos(t)+ 2.399e-001* 2.336e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.933e-001, 1.298e-001 center
replot  1.933e-001+ 2.000*( 9.925e-001* 4.263e-002*cos(t)+ 1.220e-001* 2.874e-002*sin(t)),  1.298e-001 +2.000*(-1.220e-001* 4.263e-002*cos(t)+ 9.925e-001* 2.874e-002*sin(t)) not
set out;
set out "ATFgali/VARPIJGR_ATFgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "ATFgali/VARMUPTJGR--STABLBASED_ATFgali1.svg";
 plot "ATFgali/PRMORPREV-1-STABLBASED_ATFgali.txt"  u 1:($3) not w l lt 1 
 replot "ATFgali/PRMORPREV-1-STABLBASED_ATFgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "ATFgali/PRMORPREV-1-STABLBASED_ATFgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "ATFgali/VARMUPTJGR--STABLBASED_ATFgali1.svg";replot;set out;
