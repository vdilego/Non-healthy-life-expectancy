
# IMaCh-0.99r45
# ATFchr.gp
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


set ter svg size 640, 480;set out "ATFchr/D_ATFchr_.svg" 
unset log y; plot [-1.2:1.2][yoff-1.2:1.2] 1/0 not; set out;reset;

# Contributions to the Likelihood, mle >=1. For mle=4 no interpolation, pure matrix products.
#

 set log y; unset log x;set xlabel "Age"; set ylabel "Likelihood (-2Log(L))";
set ter pngcairo size 640, 480
set out "ATFchr/ILK_ATFchr-dest.png";
set log y;plot  "ATFchr/ILK_ATFchr.txt" u 2:(-$13):6 t "All sample, transitions colored by destination" with dots lc variable; set out;

set out "ATFchr/ILK_ATFchr-ori.png";
set log y;plot  "ATFchr/ILK_ATFchr.txt" u 2:(-$13):5 t "All sample, transitions colored by origin" with dots lc variable; set out;


set out "ATFchr/ILK_ATFchr-p1j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ATFchr/ILK_ATFchr.txt"  u  2:($5 == 1 && $6==1 ? $10 : 1/0):($12/4.):6 t "p11" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 1 && $6==2 ? $10 : 1/0):($12/4.):6 t "p12" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 1 && $6==3 ? $10 : 1/0):($12/4.):6 t "p13" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out "ATFchr/ILK_ATFchr-p2j.png";set ylabel "Probability for each individual/wave";unset log;
# plot weighted, mean weight should have point size of 0.5
 plot  "ATFchr/ILK_ATFchr.txt"  u  2:($5 == 2 && $6==1 ? $10 : 1/0):($12/4.):6 t "p21" with points pointtype 7 ps variable lc variable \
,\
 "" u  2:($5 == 2 && $6==2 ? $10 : 1/0):($12/4.):6 t "p22" with points pointtype 7 ps variable lc variable ,\
 "" u  2:($5 == 2 && $6==3 ? $10 : 1/0):($12/4.):6 t "p23" with points pointtype 7 ps variable lc variable ;
set out; unset ylabel;

set out;unset log

set ter pngcairo size 640, 480
set out;unset log

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =1 
#

set out "ATFchr/V_ATFchr_1-1-1.svg" 

#set out "V_ATFchr_1-1-1.svg" 
set title "Alive state 1 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ATFchr/VPL_ATFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"Forward prevalence" w l lt 0,"ATFchr/VPL_ATFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"95% CI" w l lt 1,"ATFchr/VPL_ATFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %lf (%lf) %*lf (%*lf)" t"" w l lt 1,"ATFchr/P_ATFchr.txt" u 1:(($2)) t 'Observed prevalence in state 1' with line lt 3
set out ;unset title;

# 1st: Forward (stable period) prevalence with CI: 'VPL_' files  and live state =2 
#

set out "ATFchr/V_ATFchr_2-1-1.svg" 

#set out "V_ATFchr_2-1-1.svg" 
set title "Alive state 2 () model=1+age+" font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
plot [50:90] "ATFchr/VPL_ATFchr.txt" every :::0::0 u 1:($2==1 ? $3:1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"Forward prevalence" w l lt 0,"ATFchr/VPL_ATFchr.txt" every :::0::0 u 1:($2==1 ? $3+1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"95% CI" w l lt 1,"ATFchr/VPL_ATFchr.txt" every :::0::0 u 1:($2==1 ? $3-1.96*$4 : 1/0) "%lf %lf %*lf (%*lf) %lf (%lf)" t"" w l lt 1,"ATFchr/P_ATFchr.txt" u 1:(($5)) t 'Observed prevalence in state 2' with line lt 3
set out ;unset title;

# 2nd: Total life expectancy with CI: 't' files 
#

set out "ATFchr/E_ATFchr_1-1.svg" 

set label "popbased 0 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ylabel "Years" 
set ter svg size 640, 480
plot [50:90] "ATFchr/T_ATFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"TLE" w l lt 1, \
"ATFchr/T_ATFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,"ATFchr/T_ATFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %lf (%lf) %*lf (%*lf) %*lf (%*lf)" t"" w l lt 0,\
"ATFchr/T_ATFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"LE in state (1)" w l lt 3, \
"ATFchr/T_ATFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,"ATFchr/T_ATFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %lf (%lf) %*lf (%*lf)" t"" w l lt 0,\
"ATFchr/T_ATFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ?$4 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"LE in state (2)" w l lt 4, \
"ATFchr/T_ATFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4-$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0,"ATFchr/T_ATFchr.txt" every :::0::0 u 1:($2==0 && $4!=0 ? $4+$5*2 : 1/0) "%lf %lf %lf %*lf (%*lf) %*lf (%*lf) %lf (%lf)" t"" w l lt 0
set out;set out "ATFchr/E_ATFchr_1-1.svg"; replot; set out; unset label;


# 3d: Life expectancy with EXP_ files:  combination=1 state=1
#

set out "ATFchr/EXP_ATFchr_1-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ATFchr/E_ATFchr.txt" every :::0::0 u 1:2 t "e11" w l ,"ATFchr/E_ATFchr.txt" every :::0::0 u 1:3 t "e12" w l ,"ATFchr/E_ATFchr.txt" every :::0::0 u 1:4 t "e1." w l

# 3d: Life expectancy with EXP_ files:  combination=1 state=2
#

set out "ATFchr/EXP_ATFchr_2-1-1.svg" 
set label "()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set ter svg size 640, 480
plot [50:90] "ATFchr/E_ATFchr.txt" every :::0::0 u 1:5 t "e21" w l ,"ATFchr/E_ATFchr.txt" every :::0::0 u 1:6 t "e22" w l ,"ATFchr/E_ATFchr.txt" every :::0::0 u 1:7 t "e2." w l
unset label;

#
#
# Survival functions in state 1 : 'LIJ_' files, cov=1 state=1
#

set out "ATFchr/LIJ_ATFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFchr/PIJ_ATFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5+$6)) t "l(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8+$9)) t "l(2,1)" w l
set out; unset label;

#
#
# Survival functions in state 2 : 'LIJ_' files, cov=1 state=2
#

set out "ATFchr/LIJ_ATFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFchr/PIJ_ATFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5+$6)) t "l(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8+$9)) t "l(2,2)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=1
#

set out "ATFchr/LIJT_ATFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFchr/PIJ_ATFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4) t "l(1,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($5) t "l(1,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($4 +$5) t"l(1,.)" w l
set out; unset label;

#
#
# Survival functions in state j and all livestates from state i by final state j: 'lij' files, cov=1 state=2
#

set out "ATFchr/LIJT_ATFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability to be alive" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFchr/PIJ_ATFchr.txt" u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7) t "l(2,1)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($8) t "l(2,2)" w l, ''  u (($1==1 && (floor($2)%5 == 0)) ? ($3):1/0):($7 +$8) t"l(2,.)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=1
#

set out "ATFchr/P_ATFchr_1-1-1.svg" 
set label "Alive state 1 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFchr/PIJ_ATFchr.txt" u ($1==1 ? ($3):1/0):($4/($4+$5)) t "prev(1,1)" w l, ''  u ($1==1 ? ($3):1/0):($7/($7+$8)) t "prev(2,1)" w l
set out; unset label;

#
#
#CV preval stable (forward): 'pij' files, covariatecombination#=1 state=2
#

set out "ATFchr/P_ATFchr_2-1-1.svg" 
set label "Alive state 2 ()" at graph 0.98,0.5 center rotate font "Helvetica,12"
set xlabel "Age" 
set ylabel "Probability" 
set ter svg size 640, 480
unset log y
plot [50:90]  "ATFchr/PIJ_ATFchr.txt" u ($1==1 ? ($3):1/0):($5/($4+$5)) t "prev(1,2)" w l, ''  u ($1==1 ? ($3):1/0):($8/($7+$8)) t "prev(2,2)" w l
set out; unset label;

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-2.149412; p2=0.028194; 
#   current state 3
p3=-19.775010; p4=0.217175; 
# initial state 2
#   current state 1
p5=1.509481; p6=-0.056671; 
#   current state 3
p7=-12.549287; p8=0.127917; 
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

set out "ATFchr/PE_ATFchr_1-1-1.svg" 
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

set out "ATFchr/PE_ATFchr_1-2-1.svg" 
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

set out "ATFchr/PE_ATFchr_1-3-1.svg" 
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
set out "ATFchr/VARPIJGR_ATFchr_113-12.svg"
set label "50" at  4.541e-005, 1.615e-001 center
# Age 50, p13 - p12
plot [-pi:pi]  4.541e-005+ 2.000*( 8.812e-005* 2.391e-002*cos(t)+-1.000e+000* 1.240e-004*sin(t)),  1.615e-001 +2.000*( 1.000e+000* 2.391e-002*cos(t)+ 8.812e-005* 1.240e-004*sin(t)) not
# Age 55, p13 - p12
set label "55" at  1.282e-004, 1.773e-001 center
replot  1.282e-004+ 2.000*( 1.034e-004* 1.856e-002*cos(t)+-1.000e+000* 2.924e-004*sin(t)),  1.773e-001 +2.000*( 1.000e+000* 1.856e-002*cos(t)+ 1.034e-004* 2.924e-004*sin(t)) not
# Age 60, p13 - p12
set label "60" at  3.603e-004, 1.936e-001 center
replot  3.603e-004+ 2.000*( 5.684e-004* 1.439e-002*cos(t)+ 1.000e+000* 6.621e-004*sin(t)),  1.936e-001 +2.000*(-1.000e+000* 1.439e-002*cos(t)+ 5.684e-004* 6.621e-004*sin(t)) not
# Age 65, p13 - p12
set label "65" at  1.007e-003, 2.103e-001 center
replot  1.007e-003+ 2.000*( 4.175e-003* 1.391e-002*cos(t)+ 1.000e+000* 1.420e-003*sin(t)),  2.103e-001 +2.000*(-1.000e+000* 1.391e-002*cos(t)+ 4.175e-003* 1.420e-003*sin(t)) not
# Age 70, p13 - p12
set label "70" at  2.793e-003, 2.268e-001 center
replot  2.793e-003+ 2.000*( 1.055e-002* 1.804e-002*cos(t)+ 9.999e-001* 2.849e-003*sin(t)),  2.268e-001 +2.000*(-9.999e-001* 1.804e-002*cos(t)+ 1.055e-002* 2.849e-003*sin(t)) not
# Age 75, p13 - p12
set label "75" at  7.663e-003, 2.419e-001 center
replot  7.663e-003+ 2.000*( 2.336e-002* 2.457e-002*cos(t)+ 9.997e-001* 5.569e-003*sin(t)),  2.419e-001 +2.000*(-9.997e-001* 2.457e-002*cos(t)+ 2.336e-002* 5.569e-003*sin(t)) not
# Age 80, p13 - p12
set label "80" at  2.057e-002, 2.524e-001 center
replot  2.057e-002+ 2.000*( 1.100e-001* 3.195e-002*cos(t)+ 9.939e-001* 1.330e-002*sin(t)),  2.524e-001 +2.000*(-9.939e-001* 3.195e-002*cos(t)+ 1.100e-001* 1.330e-002*sin(t)) not
# Age 85, p13 - p12
set label "85" at  5.266e-002, 2.512e-001 center
replot  5.266e-002+ 2.000*( 7.099e-001* 5.408e-002*cos(t)+ 7.043e-001* 2.872e-002*sin(t)),  2.512e-001 +2.000*(-7.043e-001* 5.408e-002*cos(t)+ 7.099e-001* 2.872e-002*sin(t)) not
# Age 90, p13 - p12
set label "90" at  1.216e-001, 2.255e-001 center
replot  1.216e-001+ 2.000*( 8.425e-001* 1.391e-001*cos(t)+ 5.387e-001* 3.038e-002*sin(t)),  2.255e-001 +2.000*(-5.387e-001* 1.391e-001*cos(t)+ 8.425e-001* 3.038e-002*sin(t)) not
set out;
set out "ATFchr/VARPIJGR_ATFchr_113-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ATFchr/VARPIJGR_ATFchr_121-12.svg"
set label "50" at  1.049e-001, 1.615e-001 center
# Age 50, p21 - p12
plot [-pi:pi]  1.049e-001+ 2.000*( 4.356e-002* 2.393e-002*cos(t)+-9.991e-001* 1.584e-002*sin(t)),  1.615e-001 +2.000*( 9.991e-001* 2.393e-002*cos(t)+ 4.356e-002* 1.584e-002*sin(t)) not
# Age 55, p21 - p12
set label "55" at  8.319e-002, 1.773e-001 center
replot  8.319e-002+ 2.000*( 2.890e-002* 1.856e-002*cos(t)+-9.996e-001* 1.005e-002*sin(t)),  1.773e-001 +2.000*( 9.996e-001* 1.856e-002*cos(t)+ 2.890e-002* 1.005e-002*sin(t)) not
# Age 60, p21 - p12
set label "60" at  6.515e-002, 1.936e-001 center
replot  6.515e-002+ 2.000*( 2.089e-002* 1.439e-002*cos(t)+-9.998e-001* 6.273e-003*sin(t)),  1.936e-001 +2.000*( 9.998e-001* 1.439e-002*cos(t)+ 2.089e-002* 6.273e-003*sin(t)) not
# Age 65, p21 - p12
set label "65" at  5.039e-002, 2.103e-001 center
replot  5.039e-002+ 2.000*( 1.427e-002* 1.391e-002*cos(t)+-9.999e-001* 4.590e-003*sin(t)),  2.103e-001 +2.000*( 9.999e-001* 1.391e-002*cos(t)+ 1.427e-002* 4.590e-003*sin(t)) not
# Age 70, p21 - p12
set label "70" at  3.847e-002, 2.268e-001 center
replot  3.847e-002+ 2.000*( 9.371e-003* 1.804e-002*cos(t)+-1.000e+000* 4.352e-003*sin(t)),  2.268e-001 +2.000*( 1.000e+000* 1.804e-002*cos(t)+ 9.371e-003* 4.352e-003*sin(t)) not
# Age 75, p21 - p12
set label "75" at  2.889e-002, 2.419e-001 center
replot  2.889e-002+ 2.000*( 6.496e-003* 2.456e-002*cos(t)+-1.000e+000* 4.432e-003*sin(t)),  2.419e-001 +2.000*( 1.000e+000* 2.456e-002*cos(t)+ 6.496e-003* 4.432e-003*sin(t)) not
# Age 80, p21 - p12
set label "80" at  2.118e-002, 2.524e-001 center
replot  2.118e-002+ 2.000*( 4.434e-003* 3.179e-002*cos(t)+-1.000e+000* 4.289e-003*sin(t)),  2.524e-001 +2.000*( 1.000e+000* 3.179e-002*cos(t)+ 4.434e-003* 4.289e-003*sin(t)) not
# Age 85, p21 - p12
set label "85" at  1.496e-002, 2.512e-001 center
replot  1.496e-002+ 2.000*( 2.152e-003* 4.320e-002*cos(t)+-1.000e+000* 3.836e-003*sin(t)),  2.512e-001 +2.000*( 1.000e+000* 4.320e-002*cos(t)+ 2.152e-003* 3.836e-003*sin(t)) not
# Age 90, p21 - p12
set label "90" at  9.975e-003, 2.255e-001 center
replot  9.975e-003+ 2.000*( 3.361e-004* 7.919e-002*cos(t)+-1.000e+000* 3.147e-003*sin(t)),  2.255e-001 +2.000*( 1.000e+000* 7.919e-002*cos(t)+ 3.361e-004* 3.147e-003*sin(t)) not
set out;
set out "ATFchr/VARPIJGR_ATFchr_121-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p12 (year-1)"
set ter svg size 640, 480
set out "ATFchr/VARPIJGR_ATFchr_123-12.svg"
set label "50" at  8.383e-004, 1.615e-001 center
# Age 50, p23 - p12
plot [-pi:pi]  8.383e-004+ 2.000*( 4.337e-005* 2.391e-002*cos(t)+ 1.000e+000* 4.517e-004*sin(t)),  1.615e-001 +2.000*(-1.000e+000* 2.391e-002*cos(t)+ 4.337e-005* 4.517e-004*sin(t)) not
# Age 55, p23 - p12
set label "55" at  1.673e-003, 1.773e-001 center
replot  1.673e-003+ 2.000*( 5.859e-005* 1.856e-002*cos(t)+ 1.000e+000* 7.595e-004*sin(t)),  1.773e-001 +2.000*(-1.000e+000* 1.856e-002*cos(t)+ 5.859e-005* 7.595e-004*sin(t)) not
# Age 60, p23 - p12
set label "60" at  3.297e-003, 1.936e-001 center
replot  3.297e-003+ 2.000*( 4.829e-005* 1.439e-002*cos(t)+ 1.000e+000* 1.222e-003*sin(t)),  1.936e-001 +2.000*(-1.000e+000* 1.439e-002*cos(t)+ 4.829e-005* 1.222e-003*sin(t)) not
# Age 65, p23 - p12
set label "65" at  6.419e-003, 2.103e-001 center
replot  6.419e-003+ 2.000*( 4.461e-005* 1.391e-002*cos(t)+-1.000e+000* 1.864e-003*sin(t)),  2.103e-001 +2.000*( 1.000e+000* 1.391e-002*cos(t)+ 4.461e-005* 1.864e-003*sin(t)) not
# Age 70, p23 - p12
set label "70" at  1.233e-002, 2.268e-001 center
replot  1.233e-002+ 2.000*( 1.475e-004* 1.804e-002*cos(t)+-1.000e+000* 2.666e-003*sin(t)),  2.268e-001 +2.000*( 1.000e+000* 1.804e-002*cos(t)+ 1.475e-004* 2.666e-003*sin(t)) not
# Age 75, p23 - p12
set label "75" at  2.331e-002, 2.419e-001 center
replot  2.331e-002+ 2.000*( 2.375e-004* 2.456e-002*cos(t)+-1.000e+000* 3.654e-003*sin(t)),  2.419e-001 +2.000*( 1.000e+000* 2.456e-002*cos(t)+ 2.375e-004* 3.654e-003*sin(t)) not
# Age 80, p23 - p12
set label "80" at  4.300e-002, 2.524e-001 center
replot  4.300e-002+ 2.000*( 5.031e-004* 3.179e-002*cos(t)+-1.000e+000* 5.591e-003*sin(t)),  2.524e-001 +2.000*( 1.000e+000* 3.179e-002*cos(t)+ 5.031e-004* 5.591e-003*sin(t)) not
# Age 85, p23 - p12
set label "85" at  7.643e-002, 2.512e-001 center
replot  7.643e-002+ 2.000*( 1.902e-003* 4.320e-002*cos(t)+-1.000e+000* 1.098e-002*sin(t)),  2.512e-001 +2.000*( 1.000e+000* 4.320e-002*cos(t)+ 1.902e-003* 1.098e-002*sin(t)) not
# Age 90, p23 - p12
set label "90" at  1.283e-001, 2.255e-001 center
replot  1.283e-001+ 2.000*( 3.712e-003* 7.919e-002*cos(t)+-1.000e+000* 2.186e-002*sin(t)),  2.255e-001 +2.000*( 1.000e+000* 7.919e-002*cos(t)+ 3.712e-003* 2.186e-002*sin(t)) not
set out;
set out "ATFchr/VARPIJGR_ATFchr_123-12.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p21 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ATFchr/VARPIJGR_ATFchr_121-13.svg"
set label "50" at  1.049e-001, 4.541e-005 center
# Age 50, p21 - p13
plot [-pi:pi]  1.049e-001+ 2.000*( 1.000e+000* 1.586e-002*cos(t)+-3.065e-005* 1.240e-004*sin(t)),  4.541e-005 +2.000*( 3.065e-005* 1.586e-002*cos(t)+ 1.000e+000* 1.240e-004*sin(t)) not
# Age 55, p21 - p13
set label "55" at  8.319e-002, 1.282e-004 center
replot  8.319e-002+ 2.000*( 1.000e+000* 1.006e-002*cos(t)+-1.479e-004* 2.924e-004*sin(t)),  1.282e-004 +2.000*( 1.479e-004* 1.006e-002*cos(t)+ 1.000e+000* 2.924e-004*sin(t)) not
# Age 60, p21 - p13
set label "60" at  6.515e-002, 3.603e-004 center
replot  6.515e-002+ 2.000*( 1.000e+000* 6.279e-003*cos(t)+-7.871e-004* 6.622e-004*sin(t)),  3.603e-004 +2.000*( 7.871e-004* 6.279e-003*cos(t)+ 1.000e+000* 6.622e-004*sin(t)) not
# Age 65, p21 - p13
set label "65" at  5.039e-002, 1.007e-003 center
replot  5.039e-002+ 2.000*( 1.000e+000* 4.594e-003*cos(t)+-3.524e-003* 1.421e-003*sin(t)),  1.007e-003 +2.000*( 3.524e-003* 4.594e-003*cos(t)+ 1.000e+000* 1.421e-003*sin(t)) not
# Age 70, p21 - p13
set label "70" at  3.847e-002, 2.793e-003 center
replot  3.847e-002+ 2.000*( 9.999e-001* 4.356e-003*cos(t)+-1.424e-002* 2.855e-003*sin(t)),  2.793e-003 +2.000*( 1.424e-002* 4.356e-003*cos(t)+ 9.999e-001* 2.855e-003*sin(t)) not
# Age 75, p21 - p13
set label "75" at  2.889e-002, 7.663e-003 center
replot  2.889e-002+ 2.000*( 3.040e-002* 5.598e-003*cos(t)+-9.995e-001* 4.434e-003*sin(t)),  7.663e-003 +2.000*( 9.995e-001* 5.598e-003*cos(t)+ 3.040e-002* 4.434e-003*sin(t)) not
# Age 80, p21 - p13
set label "80" at  2.118e-002, 2.057e-002 center
replot  2.118e-002+ 2.000*( 4.686e-003* 1.368e-002*cos(t)+-1.000e+000* 4.291e-003*sin(t)),  2.057e-002 +2.000*( 1.000e+000* 1.368e-002*cos(t)+ 4.686e-003* 4.291e-003*sin(t)) not
# Age 85, p21 - p13
set label "85" at  1.496e-002, 5.266e-002 center
replot  1.496e-002+ 2.000*( 8.893e-004* 4.340e-002*cos(t)+-1.000e+000* 3.837e-003*sin(t)),  5.266e-002 +2.000*( 1.000e+000* 4.340e-002*cos(t)+ 8.893e-004* 3.837e-003*sin(t)) not
# Age 90, p21 - p13
set label "90" at  9.975e-003, 1.216e-001 center
replot  9.975e-003+ 2.000*( 2.231e-004* 1.183e-001*cos(t)+-1.000e+000* 3.147e-003*sin(t)),  1.216e-001 +2.000*( 1.000e+000* 1.183e-001*cos(t)+ 2.231e-004* 3.147e-003*sin(t)) not
set out;
set out "ATFchr/VARPIJGR_ATFchr_121-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p13 (year-1)"
set ter svg size 640, 480
set out "ATFchr/VARPIJGR_ATFchr_123-13.svg"
set label "50" at  8.383e-004, 4.541e-005 center
# Age 50, p23 - p13
plot [-pi:pi]  8.383e-004+ 2.000*( 1.000e+000* 4.518e-004*cos(t)+ 6.730e-003* 1.240e-004*sin(t)),  4.541e-005 +2.000*(-6.730e-003* 4.518e-004*cos(t)+ 1.000e+000* 1.240e-004*sin(t)) not
# Age 55, p23 - p13
set label "55" at  1.673e-003, 1.282e-004 center
replot  1.673e-003+ 2.000*( 9.999e-001* 7.596e-004*cos(t)+ 1.042e-002* 2.923e-004*sin(t)),  1.282e-004 +2.000*(-1.042e-002* 7.596e-004*cos(t)+ 9.999e-001* 2.923e-004*sin(t)) not
# Age 60, p23 - p13
set label "60" at  3.297e-003, 3.603e-004 center
replot  3.297e-003+ 2.000*( 9.998e-001* 1.222e-003*cos(t)+ 1.806e-002* 6.619e-004*sin(t)),  3.603e-004 +2.000*(-1.806e-002* 1.222e-003*cos(t)+ 9.998e-001* 6.619e-004*sin(t)) not
# Age 65, p23 - p13
set label "65" at  6.419e-003, 1.007e-003 center
replot  6.419e-003+ 2.000*( 9.990e-001* 1.865e-003*cos(t)+ 4.395e-002* 1.420e-003*sin(t)),  1.007e-003 +2.000*(-4.395e-002* 1.865e-003*cos(t)+ 9.990e-001* 1.420e-003*sin(t)) not
# Age 70, p23 - p13
set label "70" at  1.233e-002, 2.793e-003 center
replot  1.233e-002+ 2.000*( 1.716e-001* 2.861e-003*cos(t)+ 9.852e-001* 2.660e-003*sin(t)),  2.793e-003 +2.000*(-9.852e-001* 2.861e-003*cos(t)+ 1.716e-001* 2.660e-003*sin(t)) not
# Age 75, p23 - p13
set label "75" at  2.331e-002, 7.663e-003 center
replot  2.331e-002+ 2.000*( 2.600e-002* 5.598e-003*cos(t)+ 9.997e-001* 3.652e-003*sin(t)),  7.663e-003 +2.000*(-9.997e-001* 5.598e-003*cos(t)+ 2.600e-002* 3.652e-003*sin(t)) not
# Age 80, p23 - p13
set label "80" at  4.300e-002, 2.057e-002 center
replot  4.300e-002+ 2.000*( 7.967e-003* 1.368e-002*cos(t)+ 1.000e+000* 5.590e-003*sin(t)),  2.057e-002 +2.000*(-1.000e+000* 1.368e-002*cos(t)+ 7.967e-003* 5.590e-003*sin(t)) not
# Age 85, p23 - p13
set label "85" at  7.643e-002, 5.266e-002 center
replot  7.643e-002+ 2.000*( 3.536e-003* 4.340e-002*cos(t)+ 1.000e+000* 1.098e-002*sin(t)),  5.266e-002 +2.000*(-1.000e+000* 4.340e-002*cos(t)+ 3.536e-003* 1.098e-002*sin(t)) not
# Age 90, p23 - p13
set label "90" at  1.283e-001, 1.216e-001 center
replot  1.283e-001+ 2.000*( 2.671e-003* 1.183e-001*cos(t)+ 1.000e+000* 2.186e-002*sin(t)),  1.216e-001 +2.000*(-1.000e+000* 1.183e-001*cos(t)+ 2.671e-003* 2.186e-002*sin(t)) not
set out;
set out "ATFchr/VARPIJGR_ATFchr_123-13.svg";replot;set out;
# Ellipsoids of confidence
#

set parametric;unset label
set log y;set log x; set xlabel "p23 (year-1)";set ylabel "p21 (year-1)"
set ter svg size 640, 480
set out "ATFchr/VARPIJGR_ATFchr_123-21.svg"
set label "50" at  8.383e-004, 1.049e-001 center
# Age 50, p23 - p21
plot [-pi:pi]  8.383e-004+ 2.000*( 1.631e-003* 1.586e-002*cos(t)+ 1.000e+000* 4.510e-004*sin(t)),  1.049e-001 +2.000*(-1.000e+000* 1.586e-002*cos(t)+ 1.631e-003* 4.510e-004*sin(t)) not
# Age 55, p23 - p21
set label "55" at  1.673e-003, 8.319e-002 center
replot  1.673e-003+ 2.000*( 3.041e-003* 1.006e-002*cos(t)+ 1.000e+000* 7.589e-004*sin(t)),  8.319e-002 +2.000*(-1.000e+000* 1.006e-002*cos(t)+ 3.041e-003* 7.589e-004*sin(t)) not
# Age 60, p23 - p21
set label "60" at  3.297e-003, 6.515e-002 center
replot  3.297e-003+ 2.000*( 6.964e-003* 6.279e-003*cos(t)+ 1.000e+000* 1.222e-003*sin(t)),  6.515e-002 +2.000*(-1.000e+000* 6.279e-003*cos(t)+ 6.964e-003* 1.222e-003*sin(t)) not
# Age 65, p23 - p21
set label "65" at  6.419e-003, 5.039e-002 center
replot  6.419e-003+ 2.000*( 2.039e-002* 4.595e-003*cos(t)+ 9.998e-001* 1.862e-003*sin(t)),  5.039e-002 +2.000*(-9.998e-001* 4.595e-003*cos(t)+ 2.039e-002* 1.862e-003*sin(t)) not
# Age 70, p23 - p21
set label "70" at  1.233e-002, 3.847e-002 center
replot  1.233e-002+ 2.000*( 5.141e-002* 4.359e-003*cos(t)+ 9.987e-001* 2.661e-003*sin(t)),  3.847e-002 +2.000*(-9.987e-001* 4.359e-003*cos(t)+ 5.141e-002* 2.661e-003*sin(t)) not
# Age 75, p23 - p21
set label "75" at  2.331e-002, 2.889e-002 center
replot  2.331e-002+ 2.000*( 1.481e-001* 4.452e-003*cos(t)+ 9.890e-001* 3.634e-003*sin(t)),  2.889e-002 +2.000*(-9.890e-001* 4.452e-003*cos(t)+ 1.481e-001* 3.634e-003*sin(t)) not
# Age 80, p23 - p21
set label "80" at  4.300e-002, 2.118e-002 center
replot  4.300e-002+ 2.000*( 9.924e-001* 5.609e-003*cos(t)+ 1.228e-001* 4.268e-003*sin(t)),  2.118e-002 +2.000*(-1.228e-001* 5.609e-003*cos(t)+ 9.924e-001* 4.268e-003*sin(t)) not
# Age 85, p23 - p21
set label "85" at  7.643e-002, 1.496e-002 center
replot  7.643e-002+ 2.000*( 9.993e-001* 1.098e-002*cos(t)+ 3.860e-002* 3.816e-003*sin(t)),  1.496e-002 +2.000*(-3.860e-002* 1.098e-002*cos(t)+ 9.993e-001* 3.816e-003*sin(t)) not
# Age 90, p23 - p21
set label "90" at  1.283e-001, 9.975e-003 center
replot  1.283e-001+ 2.000*( 9.997e-001* 2.187e-002*cos(t)+ 2.554e-002* 3.098e-003*sin(t)),  9.975e-003 +2.000*(-2.554e-002* 2.187e-002*cos(t)+ 9.997e-001* 3.098e-003*sin(t)) not
set out;
set out "ATFchr/VARPIJGR_ATFchr_123-21.svg";replot;set out;
# Routine varevsij
unset title 

unset parametric;unset label; set ter svg size 640, 480
 set log y; unset log x;set xlabel "Age"; set ylabel "Force of mortality (year-1)";
set out "ATFchr/VARMUPTJGR--STABLBASED_ATFchr1.svg";
 plot "ATFchr/PRMORPREV-1-STABLBASED_ATFchr.txt"  u 1:($3) not w l lt 1 
 replot "ATFchr/PRMORPREV-1-STABLBASED_ATFchr.txt"  u 1:(($3+1.96*$4)) t "95% interval" w l lt 2 
 replot "ATFchr/PRMORPREV-1-STABLBASED_ATFchr.txt"  u 1:(($3-1.96*$4)) not w l lt 2 
set out;
set out "ATFchr/VARMUPTJGR--STABLBASED_ATFchr1.svg";replot;set out;
