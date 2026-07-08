
# IMaCh-0.99r45
# ATFgali.gp
set datafile missing 'NaNq'
cd "C:/Users/mmusz/Dropbox/gender_paradox/data/IMACH" 

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

##############
#9eme MLE estimated parameters
#############
# initial state 1
#   current state 2
p1=-6.788017; p2=0.042316; 
#   current state 3
p3=-24.517119; p4=0.227166; 
# initial state 2
#   current state 1
p5=-1.243188; p6=-0.022381; 
#   current state 3
p7=-10.274301; p8=0.083779; 
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
#Number of graphics: first is logit, 2nd is probabilities, third is incidences per year
#model=1+age+ 
# Type of graphic ng=2
#   k1=1 to 2^0=1
#Number of graphics: first is logit, 2nd is probabilities, third is incidences per year
#model=1+age+ 
# Type of graphic ng=3
#   k1=1 to 2^0=1

# Routine varprob