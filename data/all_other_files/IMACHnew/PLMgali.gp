
# IMaCh-0.99r45
# PLMgali.gp
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


set ter svg size 640, 480;set out "PLMgali/D_PLMgali_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "PLMgali/ILK_PLMgali-dest.png";
set log y;plot  "PLMgali/ILK_PLMgali.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "PLMgali/ILK_PLMgali-ori.png";
set log y;plot  "PLMgali/ILK_PLMgali.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "PLMgali/ILK_PLMgali-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "PLMgali/ILK_PLMgali.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "PLMgali/ILK_PLMgali-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "PLMgali/ILK_PLMgali.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "PLMgali/V_PLMgali_1-1-1.svg" 

#set out "V_PLMgali_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "PLMgali/VPL_PLMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"PLMgali/VPL_PLMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"PLMgali/VPL_PLMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"PLMgali/P_PLMgali.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "PLMgali/V_PLMgali_2-1-1.svg" 

#set out "V_PLMgali_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "PLMgali/VPL_PLMgali.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"PLMgali/VPL_PLMgali.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"PLMgali/VPL_PLMgali.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"PLMgali/P_PLMgali.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "PLMgali/E_PLMgali_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "PLMgali/T_PLMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"PLMgali/T_PLMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"PLMgali/T_PLMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"PLMgali/T_PLMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"PLMgali/T_PLMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"PLMgali/T_PLMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"PLMgali/T_PLMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"PLMgali/T_PLMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"PLMgali/T_PLMgali.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "PLMgali/E_PLMgali_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "PLMgali/EXP_PLMgali_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "PLMgali/E_PLMgali.txt" every :::0::0 u 1:2 t "e11" w l ,"PLMgali/E_PLMgali.txt" every :::0::0 u 1:3 t "e12" w l ,"PLMgali/E_PLMgali.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "PLMgali/EXP_PLMgali_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "PLMgali/E_PLMgali.txt" every :::0::0 u 1:5 t "e21" w l ,"PLMgali/E_PLMgali.txt" every :::0::0 u 1:6 t "e22" w l ,"PLMgali/E_PLMgali.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "PLMgali/LIJ_PLMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMgali/PIJ_PLMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "PLMgali/LIJ_PLMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMgali/PIJ_PLMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "PLMgali/LIJT_PLMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMgali/PIJ_PLMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "PLMgali/LIJT_PLMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMgali/PIJ_PLMgali.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "PLMgali/P_PLMgali_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMgali/PIJ_PLMgali.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "PLMgali/P_PLMgali_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "PLMgali/PIJ_PLMgali.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-4.396788; p2=0.023077; 
#   current state 3
p3=-6.158441; p4=0.025790; 
# initial state 2
#   current state 1
p5=0.244856; p6=-0.033871; 
#   current state 3
p7=-8.778099; p8=0.082507; 
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

set out "PLMgali/PE_PLMgali_1-1-1.svg" 
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

set out "PLMgali/PE_PLMgali_1-2-1.svg" 
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

set out "PLMgali/PE_PLMgali_1-3-1.svg" 
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
set out "PLMgali/VARPIJGR_PLMgali_113-12.svg"
set label "50" at  1.468e-002, 7.461e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  1.468e-002+ 2.000*( 5.670e-002* 1.880e-002*cos(t)+ 9.984e-001* 7.293e-003*sin(t)),  7.461e-002 +2.000*(-9.984e-001* 1.880e-002*cos(t)+ 5.670e-002* 7.293e-003*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.660e-002, 8.327e-002 center
replot  1.660e-002+ 2.000*( 4.406e-002* 1.627e-002*cos(t)+ 9.990e-001* 6.280e-003*sin(t)),  8.327e-002 +2.000*(-9.990e-001* 1.627e-002*cos(t)+ 4.406e-002* 6.280e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  1.877e-002, 9.288e-002 center
replot  1.877e-002+ 2.000*( 3.893e-002* 1.385e-002*cos(t)+ 9.992e-001* 5.416e-003*sin(t)),  9.288e-002 +2.000*(-9.992e-001* 1.385e-002*cos(t)+ 3.893e-002* 5.416e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  2.121e-002, 1.035e-001 center
replot  2.121e-002+ 2.000*( 8.185e-002* 1.289e-002*cos(t)+ 9.966e-001* 5.497e-003*sin(t)),  1.035e-001 +2.000*(-9.966e-001* 1.289e-002*cos(t)+ 8.185e-002* 5.497e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  2.394e-002, 1.153e-001 center
replot  2.394e-002+ 2.000*( 1.750e-001* 1.544e-002*cos(t)+ 9.846e-001* 7.193e-003*sin(t)),  1.153e-001 +2.000*(-9.846e-001* 1.544e-002*cos(t)+ 1.750e-001* 7.193e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  2.700e-002, 1.283e-001 center
replot  2.700e-002+ 2.000*( 2.258e-001* 2.197e-002*cos(t)+ 9.742e-001* 1.049e-002*sin(t)),  1.283e-001 +2.000*(-9.742e-001* 2.197e-002*cos(t)+ 2.258e-001* 1.049e-002*sin(t)) not
# Age 80, p13 - p12
set label "80" at  3.042e-002, 1.426e-001 center
replot  3.042e-002+ 2.000*( 2.404e-001* 3.165e-002*cos(t)+ 9.707e-001* 1.523e-002*sin(t)),  1.426e-001 +2.000*(-9.707e-001* 3.165e-002*cos(t)+ 2.404e-001* 1.523e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  3.424e-002, 1.583e-001 center
replot  3.424e-002+ 2.000*( 2.459e-001* 4.405e-002*cos(t)+ 9.693e-001* 2.136e-002*sin(t)),  1.583e-001 +2.000*(-9.693e-001* 4.405e-002*cos(t)+ 2.459e-001* 2.136e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  3.849e-002, 1.755e-001 center
replot  3.849e-002+ 2.000*( 2.509e-001* 5.911e-002*cos(t)+ 9.680e-001* 2.891e-002*sin(t)),  1.755e-001 +2.000*(-9.680e-001* 5.911e-002*cos(t)+ 2.509e-001* 2.891e-002*sin(t)) not
set out;
set out "PLMgali/VARPIJGR_PLMgali_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "PLMgali/VARPIJGR_PLMgali_121-12.svg"
set label "50" at  3.775e-001, 7.461e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  3.775e-001+ 2.000*( 9.980e-001* 1.005e-001*cos(t)+-6.365e-002* 1.769e-002*sin(t)),  7.461e-002 +2.000*( 6.365e-002* 1.005e-001*cos(t)+ 9.980e-001* 1.769e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  3.270e-001, 8.327e-002 center
replot  3.270e-001+ 2.000*( 9.965e-001* 6.909e-002*cos(t)+-8.329e-002* 1.525e-002*sin(t)),  8.327e-002 +2.000*( 8.329e-002* 6.909e-002*cos(t)+ 9.965e-001* 1.525e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.815e-001, 9.288e-002 center
replot  2.815e-001+ 2.000*( 9.940e-001* 4.652e-002*cos(t)+-1.091e-001* 1.295e-002*sin(t)),  9.288e-002 +2.000*( 1.091e-001* 4.652e-002*cos(t)+ 9.940e-001* 1.295e-002*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.407e-001, 1.035e-001 center
replot  2.407e-001+ 2.000*( 9.913e-001* 3.495e-002*cos(t)+-1.315e-001* 1.211e-002*sin(t)),  1.035e-001 +2.000*( 1.315e-001* 3.495e-002*cos(t)+ 9.913e-001* 1.211e-002*sin(t)) not
# Age 70, p21 - p12
set label "70" at  2.041e-001, 1.153e-001 center
replot  2.041e-001+ 2.000*( 9.886e-001* 3.415e-002*cos(t)+-1.506e-001* 1.452e-002*sin(t)),  1.153e-001 +2.000*( 1.506e-001* 3.415e-002*cos(t)+ 9.886e-001* 1.452e-002*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.713e-001, 1.283e-001 center
replot  1.713e-001+ 2.000*( 9.788e-001* 3.836e-002*cos(t)+-2.047e-001* 2.048e-002*sin(t)),  1.283e-001 +2.000*( 2.047e-001* 3.836e-002*cos(t)+ 9.788e-001* 2.048e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.419e-001, 1.426e-001 center
replot  1.419e-001+ 2.000*( 9.377e-001* 4.290e-002*cos(t)+-3.473e-001* 2.891e-002*sin(t)),  1.426e-001 +2.000*( 3.473e-001* 4.290e-002*cos(t)+ 9.377e-001* 2.891e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.155e-001, 1.583e-001 center
replot  1.155e-001+ 2.000*( 7.079e-001* 4.815e-002*cos(t)+-7.063e-001* 3.721e-002*sin(t)),  1.583e-001 +2.000*( 7.063e-001* 4.815e-002*cos(t)+ 7.079e-001* 3.721e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  9.187e-002, 1.755e-001 center
replot  9.187e-002+ 2.000*( 3.240e-001* 5.944e-002*cos(t)+-9.461e-001* 3.966e-002*sin(t)),  1.755e-001 +2.000*( 9.461e-001* 5.944e-002*cos(t)+ 3.240e-001* 3.966e-002*sin(t)) not
set out;
set out "PLMgali/VARPIJGR_PLMgali_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "PLMgali/VARPIJGR_PLMgali_123-12.svg"
set label "50" at  1.533e-002, 7.461e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  1.533e-002+ 2.000*( 2.908e-002* 1.878e-002*cos(t)+-9.996e-001* 9.208e-003*sin(t)),  7.461e-002 +2.000*( 9.996e-001* 1.878e-002*cos(t)+ 2.908e-002* 9.208e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.376e-002, 8.327e-002 center
replot  2.376e-002+ 2.000*( 8.600e-002* 1.628e-002*cos(t)+-9.963e-001* 1.186e-002*sin(t)),  8.327e-002 +2.000*( 9.963e-001* 1.628e-002*cos(t)+ 8.600e-002* 1.186e-002*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.660e-002, 9.288e-002 center
replot  3.660e-002+ 2.000*( 9.184e-001* 1.503e-002*cos(t)+-3.957e-001* 1.361e-002*sin(t)),  9.288e-002 +2.000*( 3.957e-001* 1.503e-002*cos(t)+ 9.184e-001* 1.361e-002*sin(t)) not
# Age 65, p23 - p12
set label "65" at  5.599e-002, 1.035e-001 center
replot  5.599e-002+ 2.000*( 9.888e-001* 1.785e-002*cos(t)+-1.491e-001* 1.272e-002*sin(t)),  1.035e-001 +2.000*( 1.491e-001* 1.785e-002*cos(t)+ 9.888e-001* 1.272e-002*sin(t)) not
# Age 70, p23 - p12
set label "70" at  8.496e-002, 1.153e-001 center
replot  8.496e-002+ 2.000*( 9.792e-001* 2.113e-002*cos(t)+-2.028e-001* 1.495e-002*sin(t)),  1.153e-001 +2.000*( 2.028e-001* 2.113e-002*cos(t)+ 9.792e-001* 1.495e-002*sin(t)) not
# Age 75, p23 - p12
set label "75" at  1.276e-001, 1.283e-001 center
replot  1.276e-001+ 2.000*( 9.396e-001* 2.712e-002*cos(t)+-3.422e-001* 2.068e-002*sin(t)),  1.283e-001 +2.000*( 3.422e-001* 2.712e-002*cos(t)+ 9.396e-001* 2.068e-002*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.891e-001, 1.426e-001 center
replot  1.891e-001+ 2.000*( 9.541e-001* 4.114e-002*cos(t)+-2.996e-001* 2.974e-002*sin(t)),  1.426e-001 +2.000*( 2.996e-001* 4.114e-002*cos(t)+ 9.541e-001* 2.974e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  2.755e-001, 1.583e-001 center
replot  2.755e-001+ 2.000*( 9.856e-001* 6.984e-002*cos(t)+-1.692e-001* 4.196e-002*sin(t)),  1.583e-001 +2.000*( 1.692e-001* 6.984e-002*cos(t)+ 9.856e-001* 4.196e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  3.921e-001, 1.755e-001 center
replot  3.921e-001+ 2.000*( 9.947e-001* 1.176e-001*cos(t)+-1.030e-001* 5.670e-002*sin(t)),  1.755e-001 +2.000*( 1.030e-001* 1.176e-001*cos(t)+ 9.947e-001* 5.670e-002*sin(t)) not
set out;
set out "PLMgali/VARPIJGR_PLMgali_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "PLMgali/VARPIJGR_PLMgali_121-13.svg"
set label "50" at  3.775e-001, 1.468e-002 center
# Age 50, p21 - p13
plot [-pi:pi]  3.775e-001+ 2.000*( 1.000e+000* 1.003e-001*cos(t)+ 1.950e-004* 7.359e-003*sin(t)),  1.468e-002 +2.000*(-1.950e-004* 1.003e-001*cos(t)+ 1.000e+000* 7.359e-003*sin(t)) not
# Age 55, p21 - p13
set label "55" at  3.270e-001, 1.660e-002 center
replot  3.270e-001+ 2.000*( 1.000e+000* 6.886e-002*cos(t)+-2.371e-004* 6.315e-003*sin(t)),  1.660e-002 +2.000*( 2.371e-004* 6.886e-002*cos(t)+ 1.000e+000* 6.315e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.815e-001, 1.877e-002 center
replot  2.815e-001+ 2.000*( 1.000e+000* 4.626e-002*cos(t)+-2.087e-003* 5.438e-003*sin(t)),  1.877e-002 +2.000*( 2.087e-003* 4.626e-002*cos(t)+ 1.000e+000* 5.438e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.407e-001, 2.121e-002 center
replot  2.407e-001+ 2.000*( 1.000e+000* 3.469e-002*cos(t)+-6.772e-003* 5.574e-003*sin(t)),  2.121e-002 +2.000*( 6.772e-003* 3.469e-002*cos(t)+ 1.000e+000* 5.574e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  2.041e-001, 2.394e-002 center
replot  2.041e-001+ 2.000*( 9.999e-001* 3.384e-002*cos(t)+-1.107e-002* 7.571e-003*sin(t)),  2.394e-002 +2.000*( 1.107e-002* 3.384e-002*cos(t)+ 9.999e-001* 7.571e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.713e-001, 2.700e-002 center
replot  1.713e-001+ 2.000*( 9.999e-001* 3.778e-002*cos(t)+-1.351e-002* 1.135e-002*sin(t)),  2.700e-002 +2.000*( 1.351e-002* 3.778e-002*cos(t)+ 9.999e-001* 1.135e-002*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.419e-001, 3.042e-002 center
replot  1.419e-001+ 2.000*( 9.998e-001* 4.147e-002*cos(t)+-1.802e-002* 1.662e-002*sin(t)),  3.042e-002 +2.000*( 1.802e-002* 4.147e-002*cos(t)+ 9.998e-001* 1.662e-002*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.155e-001, 3.424e-002 center
replot  1.155e-001+ 2.000*( 9.995e-001* 4.305e-002*cos(t)+-3.031e-002* 2.334e-002*sin(t)),  3.424e-002 +2.000*( 3.031e-002* 4.305e-002*cos(t)+ 9.995e-001* 2.334e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  9.187e-002, 3.849e-002 center
replot  9.187e-002+ 2.000*( 9.970e-001* 4.223e-002*cos(t)+-7.759e-002* 3.160e-002*sin(t)),  3.849e-002 +2.000*( 7.759e-002* 4.223e-002*cos(t)+ 9.970e-001* 3.160e-002*sin(t)) not
set out;
set out "PLMgali/VARPIJGR_PLMgali_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "PLMgali/VARPIJGR_PLMgali_123-13.svg"
set label "50" at  1.533e-002, 1.468e-002 center
# Age 50, p23 - p13
plot [-pi:pi]  1.533e-002+ 2.000*( 9.548e-001* 9.398e-003*cos(t)+ 2.971e-001* 7.131e-003*sin(t)),  1.468e-002 +2.000*(-2.971e-001* 9.398e-003*cos(t)+ 9.548e-001* 7.131e-003*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.376e-002, 1.660e-002 center
replot  2.376e-002+ 2.000*( 9.917e-001* 1.197e-002*cos(t)+ 1.289e-001* 6.175e-003*sin(t)),  1.660e-002 +2.000*(-1.289e-001* 1.197e-002*cos(t)+ 9.917e-001* 6.175e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.660e-002, 1.877e-002 center
replot  3.660e-002+ 2.000*( 9.957e-001* 1.487e-002*cos(t)+ 9.234e-002* 5.285e-003*sin(t)),  1.877e-002 +2.000*(-9.234e-002* 1.487e-002*cos(t)+ 9.957e-001* 5.285e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  5.599e-002, 2.121e-002 center
replot  5.599e-002+ 2.000*( 9.957e-001* 1.782e-002*cos(t)+ 9.278e-002* 5.351e-003*sin(t)),  2.121e-002 +2.000*(-9.278e-002* 1.782e-002*cos(t)+ 9.957e-001* 5.351e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  8.496e-002, 2.394e-002 center
replot  8.496e-002+ 2.000*( 9.922e-001* 2.105e-002*cos(t)+ 1.247e-001* 7.167e-003*sin(t)),  2.394e-002 +2.000*(-1.247e-001* 2.105e-002*cos(t)+ 9.922e-001* 7.167e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  1.276e-001, 2.700e-002 center
replot  1.276e-001+ 2.000*( 9.853e-001* 2.678e-002*cos(t)+ 1.709e-001* 1.055e-002*sin(t)),  2.700e-002 +2.000*(-1.709e-001* 2.678e-002*cos(t)+ 9.853e-001* 1.055e-002*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.891e-001, 3.042e-002 center
replot  1.891e-001+ 2.000*( 9.869e-001* 4.071e-002*cos(t)+ 1.614e-001* 1.548e-002*sin(t)),  3.042e-002 +2.000*(-1.614e-001* 4.071e-002*cos(t)+ 9.869e-001* 1.548e-002*sin(t)) not
# Age 85, p23 - p13
set label "85" at  2.755e-001, 3.424e-002 center
replot  2.755e-001+ 2.000*( 9.936e-001* 6.960e-002*cos(t)+ 1.129e-001* 2.215e-002*sin(t)),  3.424e-002 +2.000*(-1.129e-001* 6.960e-002*cos(t)+ 9.936e-001* 2.215e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  3.921e-001, 3.849e-002 center
replot  3.921e-001+ 2.000*( 9.970e-001* 1.174e-001*cos(t)+ 7.737e-002* 3.044e-002*sin(t)),  3.849e-002 +2.000*(-7.737e-002* 1.174e-001*cos(t)+ 9.970e-001* 3.044e-002*sin(t)) not
set out;
set out "PLMgali/VARPIJGR_PLMgali_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "PLMgali/VARPIJGR_PLMgali_123-21.svg"
set label "50" at  1.533e-002, 3.775e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.533e-002+ 2.000*( 4.893e-003* 1.003e-001*cos(t)+ 1.000e+000* 9.208e-003*sin(t)),  3.775e-001 +2.000*(-1.000e+000* 1.003e-001*cos(t)+ 4.893e-003* 9.208e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.376e-002, 3.270e-001 center
replot  2.376e-002+ 2.000*( 8.704e-003* 6.887e-002*cos(t)+ 1.000e+000* 1.189e-002*sin(t)),  3.270e-001 +2.000*(-1.000e+000* 6.887e-002*cos(t)+ 8.704e-003* 1.189e-002*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.660e-002, 2.815e-001 center
replot  3.660e-002+ 2.000*( 2.102e-002* 4.627e-002*cos(t)+ 9.998e-001* 1.479e-002*sin(t)),  2.815e-001 +2.000*(-9.998e-001* 4.627e-002*cos(t)+ 2.102e-002* 1.479e-002*sin(t)) not
# Age 65, p23 - p21
set label "65" at  5.599e-002, 2.407e-001 center
replot  5.599e-002+ 2.000*( 5.644e-002* 3.473e-002*cos(t)+ 9.984e-001* 1.767e-002*sin(t)),  2.407e-001 +2.000*(-9.984e-001* 3.473e-002*cos(t)+ 5.644e-002* 1.767e-002*sin(t)) not
# Age 70, p23 - p21
set label "70" at  8.496e-002, 2.041e-001 center
replot  8.496e-002+ 2.000*( 9.358e-002* 3.393e-002*cos(t)+ 9.956e-001* 2.076e-002*sin(t)),  2.041e-001 +2.000*(-9.956e-001* 3.393e-002*cos(t)+ 9.358e-002* 2.076e-002*sin(t)) not
# Age 75, p23 - p21
set label "75" at  1.276e-001, 1.713e-001 center
replot  1.276e-001+ 2.000*( 1.202e-001* 3.792e-002*cos(t)+ 9.927e-001* 2.624e-002*sin(t)),  1.713e-001 +2.000*(-9.927e-001* 3.792e-002*cos(t)+ 1.202e-001* 2.624e-002*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.891e-001, 1.419e-001 center
replot  1.891e-001+ 2.000*( 5.715e-001* 4.258e-002*cos(t)+ 8.206e-001* 3.907e-002*sin(t)),  1.419e-001 +2.000*(-8.206e-001* 4.258e-002*cos(t)+ 5.715e-001* 3.907e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  2.755e-001, 1.155e-001 center
replot  2.755e-001+ 2.000*( 9.961e-001* 6.937e-002*cos(t)+ 8.865e-002* 4.277e-002*sin(t)),  1.155e-001 +2.000*(-8.865e-002* 6.937e-002*cos(t)+ 9.961e-001* 4.277e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  3.921e-001, 9.187e-002 center
replot  3.921e-001+ 2.000*( 9.987e-001* 1.172e-001*cos(t)+ 5.031e-002* 4.181e-002*sin(t)),  9.187e-002 +2.000*(-5.031e-002* 1.172e-001*cos(t)+ 9.987e-001* 4.181e-002*sin(t)) not
set out;
set out "PLMgali/VARPIJGR_PLMgali_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "PLMgali/VARMUPTJGR--STABLBASED_PLMgali1.svg";
 plot "PLMgali/PRMORPREV-1-STABLBASED_PLMgali.txt"  u 1:($3) not w l lt 1 
 replot "PLMgali/PRMORPREV-1-STABLBASED_PLMgali.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "PLMgali/PRMORPREV-1-STABLBASED_PLMgali.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "PLMgali/VARMUPTJGR--STABLBASED_PLMgali1.svg";replot;set out;
