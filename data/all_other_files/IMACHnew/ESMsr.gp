
# IMaCh-0.99r45
# ESMsr.gp
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


set ter svg size 640, 480;set out "ESMsr/D_ESMsr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "ESMsr/ILK_ESMsr-dest.png";
set log y;plot  "ESMsr/ILK_ESMsr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "ESMsr/ILK_ESMsr-ori.png";
set log y;plot  "ESMsr/ILK_ESMsr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "ESMsr/ILK_ESMsr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ESMsr/ILK_ESMsr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "ESMsr/ILK_ESMsr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ESMsr/ILK_ESMsr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "ESMsr/V_ESMsr_1-1-1.svg" 

#set out "V_ESMsr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ESMsr/VPL_ESMsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"ESMsr/VPL_ESMsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"ESMsr/VPL_ESMsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"ESMsr/P_ESMsr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "ESMsr/V_ESMsr_2-1-1.svg" 

#set out "V_ESMsr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ESMsr/VPL_ESMsr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"ESMsr/VPL_ESMsr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"ESMsr/VPL_ESMsr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"ESMsr/P_ESMsr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "ESMsr/E_ESMsr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "ESMsr/T_ESMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"ESMsr/T_ESMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"ESMsr/T_ESMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"ESMsr/T_ESMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"ESMsr/T_ESMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"ESMsr/T_ESMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"ESMsr/T_ESMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"ESMsr/T_ESMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"ESMsr/T_ESMsr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "ESMsr/E_ESMsr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "ESMsr/EXP_ESMsr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ESMsr/E_ESMsr.txt" every :::0::0 u 1:2 t "e11" w l ,"ESMsr/E_ESMsr.txt" every :::0::0 u 1:3 t "e12" w l ,"ESMsr/E_ESMsr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "ESMsr/EXP_ESMsr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ESMsr/E_ESMsr.txt" every :::0::0 u 1:5 t "e21" w l ,"ESMsr/E_ESMsr.txt" every :::0::0 u 1:6 t "e22" w l ,"ESMsr/E_ESMsr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "ESMsr/LIJ_ESMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMsr/PIJ_ESMsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "ESMsr/LIJ_ESMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMsr/PIJ_ESMsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "ESMsr/LIJT_ESMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMsr/PIJ_ESMsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "ESMsr/LIJT_ESMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMsr/PIJ_ESMsr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "ESMsr/P_ESMsr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMsr/PIJ_ESMsr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "ESMsr/P_ESMsr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ESMsr/PIJ_ESMsr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-4.692699; p2=0.034371; 
#   current state 3
p3=-12.775278; p4=0.103633; 
# initial state 2
#   current state 1
p5=0.079370; p6=-0.033483; 
#   current state 3
p7=-7.249381; p8=0.056197; 
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

set out "ESMsr/PE_ESMsr_1-1-1.svg" 
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

set out "ESMsr/PE_ESMsr_1-2-1.svg" 
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

set out "ESMsr/PE_ESMsr_1-3-1.svg" 
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
set out "ESMsr/VARPIJGR_ESMsr_113-12.svg"
set label "50" at  9.579e-004, 9.717e-002 center
# Age 50, p13 - p12
plot [-pi:pi]  9.579e-004+ 2.000*( 1.399e-003* 1.270e-002*cos(t)+ 1.000e+000* 7.566e-004*sin(t)),  9.717e-002 +2.000*(-1.000e+000* 1.270e-002*cos(t)+ 1.399e-003* 7.566e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.593e-003, 1.143e-001 center
replot  1.593e-003+ 2.000*( 2.716e-003* 1.175e-002*cos(t)+ 1.000e+000* 1.053e-003*sin(t)),  1.143e-001 +2.000*(-1.000e+000* 1.175e-002*cos(t)+ 2.716e-003* 1.053e-003*sin(t)) not
# Age 60, p13 - p12
set label "60" at  2.645e-003, 1.342e-001 center
replot  2.645e-003+ 2.000*( 6.370e-003* 1.062e-002*cos(t)+ 1.000e+000* 1.429e-003*sin(t)),  1.342e-001 +2.000*(-1.000e+000* 1.062e-002*cos(t)+ 6.370e-003* 1.429e-003*sin(t)) not
# Age 65, p13 - p12
set label "65" at  4.382e-003, 1.573e-001 center
replot  4.382e-003+ 2.000*( 1.625e-002* 1.003e-002*cos(t)+ 9.999e-001* 1.909e-003*sin(t)),  1.573e-001 +2.000*(-9.999e-001* 1.003e-002*cos(t)+ 1.625e-002* 1.909e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  7.239e-003, 1.838e-001 center
replot  7.239e-003+ 2.000*( 3.249e-002* 1.143e-002*cos(t)+ 9.995e-001* 2.609e-003*sin(t)),  1.838e-001 +2.000*(-9.995e-001* 1.143e-002*cos(t)+ 3.249e-002* 2.609e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  1.192e-002, 2.140e-001 center
replot  1.192e-002+ 2.000*( 4.732e-002* 1.588e-002*cos(t)+ 9.989e-001* 3.997e-003*sin(t)),  2.140e-001 +2.000*(-9.989e-001* 1.588e-002*cos(t)+ 4.732e-002* 3.997e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  1.954e-002, 2.482e-001 center
replot  1.954e-002+ 2.000*( 6.685e-002* 2.329e-002*cos(t)+ 9.978e-001* 7.212e-003*sin(t)),  2.482e-001 +2.000*(-9.978e-001* 2.329e-002*cos(t)+ 6.685e-002* 7.212e-003*sin(t)) not
# Age 85, p13 - p12
set label "85" at  3.186e-002, 2.862e-001 center
replot  3.186e-002+ 2.000*( 1.098e-001* 3.340e-002*cos(t)+ 9.940e-001* 1.415e-002*sin(t)),  2.862e-001 +2.000*(-9.940e-001* 3.340e-002*cos(t)+ 1.098e-001* 1.415e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  5.155e-002, 3.275e-001 center
replot  5.155e-002+ 2.000*( 2.291e-001* 4.658e-002*cos(t)+ 9.734e-001* 2.746e-002*sin(t)),  3.275e-001 +2.000*(-9.734e-001* 4.658e-002*cos(t)+ 2.291e-001* 2.746e-002*sin(t)) not
set out;
set out "ESMsr/VARPIJGR_ESMsr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ESMsr/VARPIJGR_ESMsr_121-12.svg"
set label "50" at  3.342e-001, 9.717e-002 center
# Age 50, p21 - p12
plot [-pi:pi]  3.342e-001+ 2.000*( 9.940e-001* 4.280e-002*cos(t)+-1.098e-001* 1.187e-002*sin(t)),  9.717e-002 +2.000*( 1.098e-001* 4.280e-002*cos(t)+ 9.940e-001* 1.187e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  2.892e-001, 1.143e-001 center
replot  2.892e-001+ 2.000*( 9.877e-001* 2.996e-002*cos(t)+-1.562e-001* 1.092e-002*sin(t)),  1.143e-001 +2.000*( 1.562e-001* 2.996e-002*cos(t)+ 9.877e-001* 1.092e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  2.491e-001, 1.342e-001 center
replot  2.491e-001+ 2.000*( 9.737e-001* 2.091e-002*cos(t)+-2.278e-001* 9.753e-003*sin(t)),  1.342e-001 +2.000*( 2.278e-001* 2.091e-002*cos(t)+ 9.737e-001* 9.753e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  2.136e-001, 1.573e-001 center
replot  2.136e-001+ 2.000*( 9.480e-001* 1.626e-002*cos(t)+-3.183e-001* 9.067e-003*sin(t)),  1.573e-001 +2.000*( 3.183e-001* 1.626e-002*cos(t)+ 9.480e-001* 9.067e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  1.822e-001, 1.838e-001 center
replot  1.822e-001+ 2.000*( 9.004e-001* 1.589e-002*cos(t)+-4.351e-001* 1.010e-002*sin(t)),  1.838e-001 +2.000*( 4.351e-001* 1.589e-002*cos(t)+ 9.004e-001* 1.010e-002*sin(t)) not
# Age 75, p21 - p12
set label "75" at  1.547e-001, 2.140e-001 center
replot  1.547e-001+ 2.000*( 7.350e-001* 1.861e-002*cos(t)+-6.781e-001* 1.308e-002*sin(t)),  2.140e-001 +2.000*( 6.781e-001* 1.861e-002*cos(t)+ 7.350e-001* 1.308e-002*sin(t)) not
# Age 80, p21 - p12
set label "80" at  1.306e-001, 2.482e-001 center
replot  1.306e-001+ 2.000*( 4.320e-001* 2.462e-002*cos(t)+-9.019e-001* 1.590e-002*sin(t)),  2.482e-001 +2.000*( 9.019e-001* 2.462e-002*cos(t)+ 4.320e-001* 1.590e-002*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.096e-001, 2.862e-001 center
replot  1.096e-001+ 2.000*( 2.472e-001* 3.401e-002*cos(t)+-9.690e-001* 1.744e-002*sin(t)),  2.862e-001 +2.000*( 9.690e-001* 3.401e-002*cos(t)+ 2.472e-001* 1.744e-002*sin(t)) not
# Age 90, p21 - p12
set label "90" at  9.130e-002, 3.275e-001 center
replot  9.130e-002+ 2.000*( 1.557e-001* 4.625e-002*cos(t)+-9.878e-001* 1.800e-002*sin(t)),  3.275e-001 +2.000*( 9.878e-001* 4.625e-002*cos(t)+ 1.557e-001* 1.800e-002*sin(t)) not
set out;
set out "ESMsr/VARPIJGR_ESMsr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ESMsr/VARPIJGR_ESMsr_123-12.svg"
set label "50" at  1.943e-002, 9.717e-002 center
# Age 50, p23 - p12
plot [-pi:pi]  1.943e-002+ 2.000*( 7.943e-003* 1.270e-002*cos(t)+ 1.000e+000* 5.256e-003*sin(t)),  9.717e-002 +2.000*(-1.000e+000* 1.270e-002*cos(t)+ 7.943e-003* 5.256e-003*sin(t)) not
# Age 55, p23 - p12
set label "55" at  2.633e-002, 1.143e-001 center
replot  2.633e-002+ 2.000*( 5.883e-003* 1.175e-002*cos(t)+ 1.000e+000* 5.924e-003*sin(t)),  1.143e-001 +2.000*(-1.000e+000* 1.175e-002*cos(t)+ 5.883e-003* 5.924e-003*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.551e-002, 1.342e-001 center
replot  3.551e-002+ 2.000*( 1.871e-003* 1.062e-002*cos(t)+-1.000e+000* 6.468e-003*sin(t)),  1.342e-001 +2.000*( 1.000e+000* 1.062e-002*cos(t)+ 1.871e-003* 6.468e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  4.767e-002, 1.573e-001 center
replot  4.767e-002+ 2.000*( 2.691e-002* 1.004e-002*cos(t)+-9.996e-001* 6.871e-003*sin(t)),  1.573e-001 +2.000*( 9.996e-001* 1.004e-002*cos(t)+ 2.691e-002* 6.871e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  6.370e-002, 1.838e-001 center
replot  6.370e-002+ 2.000*( 5.240e-002* 1.144e-002*cos(t)+-9.986e-001* 7.343e-003*sin(t)),  1.838e-001 +2.000*( 9.986e-001* 1.144e-002*cos(t)+ 5.240e-002* 7.343e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  8.468e-002, 2.140e-001 center
replot  8.468e-002+ 2.000*( 5.426e-002* 1.588e-002*cos(t)+-9.985e-001* 8.719e-003*sin(t)),  2.140e-001 +2.000*( 9.985e-001* 1.588e-002*cos(t)+ 5.426e-002* 8.719e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  1.119e-001, 2.482e-001 center
replot  1.119e-001+ 2.000*( 5.650e-002* 2.327e-002*cos(t)+-9.984e-001* 1.247e-002*sin(t)),  2.482e-001 +2.000*( 9.984e-001* 2.327e-002*cos(t)+ 5.650e-002* 1.247e-002*sin(t)) not
# Age 85, p23 - p12
set label "85" at  1.471e-001, 2.862e-001 center
replot  1.471e-001+ 2.000*( 6.889e-002* 3.329e-002*cos(t)+-9.976e-001* 1.985e-002*sin(t)),  2.862e-001 +2.000*( 9.976e-001* 3.329e-002*cos(t)+ 6.889e-002* 1.985e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.918e-001, 3.275e-001 center
replot  1.918e-001+ 2.000*( 1.009e-001* 4.589e-002*cos(t)+-9.949e-001* 3.171e-002*sin(t)),  3.275e-001 +2.000*( 9.949e-001* 4.589e-002*cos(t)+ 1.009e-001* 3.171e-002*sin(t)) not
set out;
set out "ESMsr/VARPIJGR_ESMsr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ESMsr/VARPIJGR_ESMsr_121-13.svg"
set label "50" at  3.342e-001, 9.579e-004 center
# Age 50, p21 - p13
plot [-pi:pi]  3.342e-001+ 2.000*( 1.000e+000* 4.256e-002*cos(t)+-5.940e-004* 7.564e-004*sin(t)),  9.579e-004 +2.000*( 5.940e-004* 4.256e-002*cos(t)+ 1.000e+000* 7.564e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  2.892e-001, 1.593e-003 center
replot  2.892e-001+ 2.000*( 1.000e+000* 2.964e-002*cos(t)+-1.116e-003* 1.053e-003*sin(t)),  1.593e-003 +2.000*( 1.116e-003* 2.964e-002*cos(t)+ 1.000e+000* 1.053e-003*sin(t)) not
# Age 60, p21 - p13
set label "60" at  2.491e-001, 2.645e-003 center
replot  2.491e-001+ 2.000*( 1.000e+000* 2.048e-002*cos(t)+-2.004e-003* 1.430e-003*sin(t)),  2.645e-003 +2.000*( 2.004e-003* 2.048e-002*cos(t)+ 1.000e+000* 1.430e-003*sin(t)) not
# Age 65, p21 - p13
set label "65" at  2.136e-001, 4.382e-003 center
replot  2.136e-001+ 2.000*( 1.000e+000* 1.568e-002*cos(t)+-3.191e-003* 1.915e-003*sin(t)),  4.382e-003 +2.000*( 3.191e-003* 1.568e-002*cos(t)+ 1.000e+000* 1.915e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  1.822e-001, 7.239e-003 center
replot  1.822e-001+ 2.000*( 1.000e+000* 1.497e-002*cos(t)+-4.988e-003* 2.633e-003*sin(t)),  7.239e-003 +2.000*( 4.988e-003* 1.497e-002*cos(t)+ 1.000e+000* 2.633e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  1.547e-001, 1.192e-002 center
replot  1.547e-001+ 2.000*( 1.000e+000* 1.631e-002*cos(t)+-9.499e-003* 4.060e-003*sin(t)),  1.192e-002 +2.000*( 9.499e-003* 1.631e-002*cos(t)+ 1.000e+000* 4.060e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  1.306e-001, 1.954e-002 center
replot  1.306e-001+ 2.000*( 9.998e-001* 1.786e-002*cos(t)+-2.175e-002* 7.354e-003*sin(t)),  1.954e-002 +2.000*( 2.175e-002* 1.786e-002*cos(t)+ 9.998e-001* 7.354e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.096e-001, 3.186e-002 center
replot  1.096e-001+ 2.000*( 9.959e-001* 1.890e-002*cos(t)+-9.038e-002* 1.449e-002*sin(t)),  3.186e-002 +2.000*( 9.038e-002* 1.890e-002*cos(t)+ 9.959e-001* 1.449e-002*sin(t)) not
# Age 90, p21 - p13
set label "90" at  9.130e-002, 5.155e-002 center
replot  9.130e-002+ 2.000*( 6.094e-002* 2.881e-002*cos(t)+-9.981e-001* 1.914e-002*sin(t)),  5.155e-002 +2.000*( 9.981e-001* 2.881e-002*cos(t)+ 6.094e-002* 1.914e-002*sin(t)) not
set out;
set out "ESMsr/VARPIJGR_ESMsr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ESMsr/VARPIJGR_ESMsr_123-13.svg"
set label "50" at  1.943e-002, 9.579e-004 center
# Age 50, p23 - p13
plot [-pi:pi]  1.943e-002+ 2.000*( 9.997e-001* 5.258e-003*cos(t)+ 2.398e-002* 7.464e-004*sin(t)),  9.579e-004 +2.000*(-2.398e-002* 5.258e-003*cos(t)+ 9.997e-001* 7.464e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  2.633e-002, 1.593e-003 center
replot  2.633e-002+ 2.000*( 9.995e-001* 5.927e-003*cos(t)+ 3.094e-002* 1.038e-003*sin(t)),  1.593e-003 +2.000*(-3.094e-002* 5.927e-003*cos(t)+ 9.995e-001* 1.038e-003*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.551e-002, 2.645e-003 center
replot  3.551e-002+ 2.000*( 9.991e-001* 6.474e-003*cos(t)+ 4.175e-002* 1.407e-003*sin(t)),  2.645e-003 +2.000*(-4.175e-002* 6.474e-003*cos(t)+ 9.991e-001* 1.407e-003*sin(t)) not
# Age 65, p23 - p13
set label "65" at  4.767e-002, 4.382e-003 center
replot  4.767e-002+ 2.000*( 9.982e-001* 6.885e-003*cos(t)+ 6.076e-002* 1.873e-003*sin(t)),  4.382e-003 +2.000*(-6.076e-002* 6.885e-003*cos(t)+ 9.982e-001* 1.873e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  6.370e-002, 7.239e-003 center
replot  6.370e-002+ 2.000*( 9.953e-001* 7.388e-003*cos(t)+ 9.703e-002* 2.546e-003*sin(t)),  7.239e-003 +2.000*(-9.703e-002* 7.388e-003*cos(t)+ 9.953e-001* 2.546e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  8.468e-002, 1.192e-002 center
replot  8.468e-002+ 2.000*( 9.877e-001* 8.836e-003*cos(t)+ 1.562e-001* 3.868e-003*sin(t)),  1.192e-002 +2.000*(-1.562e-001* 8.836e-003*cos(t)+ 9.877e-001* 3.868e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  1.119e-001, 1.954e-002 center
replot  1.119e-001+ 2.000*( 9.746e-001* 1.274e-002*cos(t)+ 2.237e-001* 6.964e-003*sin(t)),  1.954e-002 +2.000*(-2.237e-001* 1.274e-002*cos(t)+ 9.746e-001* 6.964e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  1.471e-001, 3.186e-002 center
replot  1.471e-001+ 2.000*( 9.481e-001* 2.052e-002*cos(t)+ 3.179e-001* 1.370e-002*sin(t)),  3.186e-002 +2.000*(-3.179e-001* 2.052e-002*cos(t)+ 9.481e-001* 1.370e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.918e-001, 5.155e-002 center
replot  1.918e-001+ 2.000*( 8.436e-001* 3.383e-002*cos(t)+ 5.369e-001* 2.646e-002*sin(t)),  5.155e-002 +2.000*(-5.369e-001* 3.383e-002*cos(t)+ 8.436e-001* 2.646e-002*sin(t)) not
set out;
set out "ESMsr/VARPIJGR_ESMsr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "ESMsr/VARPIJGR_ESMsr_123-21.svg"
set label "50" at  1.943e-002, 3.342e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  1.943e-002+ 2.000*( 7.627e-003* 4.256e-002*cos(t)+ 1.000e+000* 5.247e-003*sin(t)),  3.342e-001 +2.000*(-1.000e+000* 4.256e-002*cos(t)+ 7.627e-003* 5.247e-003*sin(t)) not
# Age 55, p23 - p21
set label "55" at  2.633e-002, 2.892e-001 center
replot  2.633e-002+ 2.000*( 1.051e-002* 2.964e-002*cos(t)+ 9.999e-001* 5.916e-003*sin(t)),  2.892e-001 +2.000*(-9.999e-001* 2.964e-002*cos(t)+ 1.051e-002* 5.916e-003*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.551e-002, 2.491e-001 center
replot  3.551e-002+ 2.000*( 1.619e-002* 2.048e-002*cos(t)+ 9.999e-001* 6.461e-003*sin(t)),  2.491e-001 +2.000*(-9.999e-001* 2.048e-002*cos(t)+ 1.619e-002* 6.461e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  4.767e-002, 2.136e-001 center
replot  4.767e-002+ 2.000*( 2.610e-002* 1.569e-002*cos(t)+ 9.997e-001* 6.863e-003*sin(t)),  2.136e-001 +2.000*(-9.997e-001* 1.569e-002*cos(t)+ 2.610e-002* 6.863e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  6.370e-002, 1.822e-001 center
replot  6.370e-002+ 2.000*( 3.411e-002* 1.498e-002*cos(t)+ 9.994e-001* 7.344e-003*sin(t)),  1.822e-001 +2.000*(-9.994e-001* 1.498e-002*cos(t)+ 3.411e-002* 7.344e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  8.468e-002, 1.547e-001 center
replot  8.468e-002+ 2.000*( 4.209e-002* 1.632e-002*cos(t)+ 9.991e-001* 8.729e-003*sin(t)),  1.547e-001 +2.000*(-9.991e-001* 1.632e-002*cos(t)+ 4.209e-002* 8.729e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  1.119e-001, 1.306e-001 center
replot  1.119e-001+ 2.000*( 7.784e-002* 1.788e-002*cos(t)+ 9.970e-001* 1.248e-002*sin(t)),  1.306e-001 +2.000*(-9.970e-001* 1.788e-002*cos(t)+ 7.784e-002* 1.248e-002*sin(t)) not
# Age 85, p23 - p21
set label "85" at  1.471e-001, 1.096e-001 center
replot  1.471e-001+ 2.000*( 9.140e-001* 2.019e-002*cos(t)+ 4.058e-001* 1.860e-002*sin(t)),  1.096e-001 +2.000*(-4.058e-001* 2.019e-002*cos(t)+ 9.140e-001* 1.860e-002*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.918e-001, 9.130e-002 center
replot  1.918e-001+ 2.000*( 9.977e-001* 3.193e-002*cos(t)+ 6.780e-002* 1.911e-002*sin(t)),  9.130e-002 +2.000*(-6.780e-002* 3.193e-002*cos(t)+ 9.977e-001* 1.911e-002*sin(t)) not
set out;
set out "ESMsr/VARPIJGR_ESMsr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "ESMsr/VARMUPTJGR--STABLBASED_ESMsr1.svg";
 plot "ESMsr/PRMORPREV-1-STABLBASED_ESMsr.txt"  u 1:($3) not w l lt 1 
 replot "ESMsr/PRMORPREV-1-STABLBASED_ESMsr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "ESMsr/PRMORPREV-1-STABLBASED_ESMsr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "ESMsr/VARMUPTJGR--STABLBASED_ESMsr1.svg";replot;set out;
