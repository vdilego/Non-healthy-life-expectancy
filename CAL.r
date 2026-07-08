rm(list=ls())

library(tidyr)
library(dplyr)
library(ggplot2)
library(ggrepel)
library(ggpubr)
library(readr)
library(HMDHFDplus)
library(stringr)
library(haven)
library(xtable)
library(stringi)



data.dir <- "C://Users//mmusz//Dropbox//teaching//JKU//sociology_S24//data"
out.dir <- "C://Users//mmusz//Dropbox//gender_paradox//data"

############### prepare health variables and weights
setwd(data.dir)
load(file='easySHARE_rel8_0_0.rda')

setwd(out.dir)

wave7health <- easySHARE_rel8_0_0 %>%
  left_join(read_dta(file="C:\\Users\\mmusz\\SHARE\\sharew7_rel9-0-0_ALL_datasets_stata\\sharew7_rel9-0-0_ph.dta") %>%
              mutate(chr=ifelse(ph006dno==0,2,ph006dno), 
                     gali=ifelse(ph005_==3,0,ph005_),
                     gali=ifelse(ph005_==2,0,gali))) %>%
  left_join(read_sav("C://Users//mmusz//Dropbox//teaching//JKU//sociology_S24//data//sharew7_rel9-0-0_gv_weights.sav") %>%  #add weights
              select(mergeid,cciw_w7)) %>%  #weight for wave 7
  mutate(cname=substr(mergeid,1,2), cname=recode(cname,"Bf"="BE", "Bn"="BE", 
                                                 "Cf"="CH", "Ci"="CH", "Cg"="CH", 
                                                 "F1"="FR", "Eg"="ES", "Ia"="IL",
                                                 "Ih"="IL", "Ir"="IL"), 
         country = cname) %>%
  filter(!country %in% c("NL","IE","RO","MT","CY")) %>% #no wave 7 in NL, IE, no RO in HMD
  mutate(country=dplyr::recode(country, "AT"="AUT", "BE"="BEL", "CH"="CHE", "CZ"="CZE", "DE"="DEUTNP","DK"="DNK", "EE"="EST",
                               "ES"="ESP", "FR"="FRATNP", "GR"="GRC", "HR"="HRV", "HU"="HUN", "IL"="ISR", "IT"="ITA",
                               "LU"="LUX", "PL"="POL", "PT"="PRT", "SE"="SWE", "SI"="SVN", "FI"="FIN","LT"="LTU",
                               "LV"="LVA", "SK"="SVK", "BG"="BGR")) %>%
  filter(wave==7, age>=50, cciw_w7>0) %>%
  mutate(age7=5*floor(age/5),
         age7=ifelse(age7>90,90,age7)) %>%
  filter(adla>=0, gali>=0, sphus>0, chr>0) %>%
  mutate(chr=chr-1,
         sr=ifelse(sphus>3,1,0),
         ADL=ifelse((adla>0 & adla<6) ,1,adla)) %>%
  group_by(female,age7,country) %>%
  summarise(prevADL=weighted.mean(ADL, cciw_w7, na.rm = TRUE),
            prevSR=weighted.mean(sr, cciw_w7, na.rm = TRUE),
            prevGALI=weighted.mean(gali, cciw_w7, na.rm = TRUE),
            prevchr=weighted.mean(chr, cciw_w7, na.rm = TRUE))


countries <- unique(wave7health$country)


########dowload life tables, join prevalence and estimate HE and UHE by country and sex
i=1
countryi <- countries[i]

qx_coh <- readHMDweb(CNTRY=countryi, item="cMx_1x1", username="mmuszynska@gmail.com", password="123Mucha123!") %>%
  mutate(fem_M=as.numeric(Female), male_M=as.numeric(Male)) %>%
  select(Year,Age,fem_M,male_M) %>%
  mutate(Age= ifelse(Age=="110+","110",Age)) %>%
  mutate(cohort2017=2017-as.numeric(Year)-1) %>%
  filter(cohort2017<=110) %>%
  filter(Age==cohort2017) %>%
  mutate(fem_M=ifelse(is.na(fem_M),1, fem_M), 
         male_M=ifelse(is.na(male_M),1,male_M)) %>%
  mutate_all(funs(ifelse(.==".", 0, .))) %>%
  mutate(fem_q=fem_M/(1+(1-0.5)*fem_M),
         male_q=male_M/(1+(1-0.5)*male_M)) %>%
  mutate(fem_p=1-fem_q, male_p=1-male_q) %>%
  filter(Age>=50)

ltcoh <- qx_coh %>%
              arrange(Age) %>%
              mutate(fem_lx= cumprod(fem_p),
                     male_lx= cumprod(male_p),
                     Age=as.numeric(Age)+1) %>%
              select(Year,Age,fem_lx,male_lx)%>% 
  add_row(data.frame(Year = 1970, Age = 50, fem_lx = 1, male_lx = 1)) %>%  #add the radix of the life table
  arrange(Age) %>%
  mutate(fem_Lx=fem_lx-0.5*(fem_lx-lead(fem_lx)), male_Lx=male_lx-0.5*(male_lx-lead(male_lx)),
         Age5=5*floor(Age/5)) %>%
  filter(Age<110) %>%
  group_by(Age5) %>%
  summarise(fem_Lx=sum(fem_Lx),
            male_Lx=sum(male_Lx)) %>%
  rename("Age"="Age5") %>%
  pivot_longer(fem_Lx:male_Lx, names_to = "sex", values_to = "Lx") %>%
  mutate(female=ifelse(sex=="male_Lx",0,1), country=countryi) %>%
  select(Age,Lx,female)


lt90 <- ltcoh %>%
  filter(Age>=90) %>%
  group_by(female) %>%
  summarise(Lx=sum(Lx)) %>%
  mutate(Age=90)

hltdata <-ltcoh %>%
  select(female,Age,Lx) %>%
  filter(Age<90) %>%
  add_row(lt90) %>%
  mutate(country=countryi) %>%
  left_join(wave7health %>%
              mutate(Age=age7) %>%
              mutate(across(c(prevADL:prevchr), ~ ifelse(is.na(.), 0, .))))


hlt <- hltdata %>%
          mutate(ADl_Lx=Lx*prevADL,
          SR_Lx=Lx*prevSR,
          GALI_Lx=Lx*prevGALI,
          CHR_Lx=Lx*prevchr) %>%
          group_by(female,country) %>%
          summarise(UHE_ADL=sum(ADl_Lx,na.rm=TRUE),
                    UHE_CHR=sum(CHR_Lx,na.rm=TRUE),
                    UHE_GALI=sum(GALI_Lx,na.rm=TRUE),
                    UHE_SR=sum(SR_Lx,na.rm=TRUE),
                    ex=sum(Lx,na.rm=TRUE))  %>%
  mutate(HE_ADL=ex-UHE_ADL, HE_CHR=ex-UHE_CHR, HE_GALI=ex-UHE_GALI, HE_SR=ex-UHE_SR,
         sex=ifelse(female==0, "male", "female")) %>%
  select(country,sex, UHE_ADL:HE_SR)


setwd(out.dir)
write.table(hlt, file="calhlt.csv", sep=",", row.names = FALSE, append=FALSE)
write.table(hltdata, file="calhltdata.csv", sep=",", row.names = FALSE, append=FALSE)


for (i in c(2:12, 14:length(countries))){
  countryi <- countries[i]

  qx_coh <- readHMDweb(CNTRY=countryi, item="cMx_1x1", username="mmuszynska@gmail.com", password="123Mucha123!") %>%
    mutate(fem_M=as.numeric(Female), male_M=as.numeric(Male)) %>%
    select(Year,Age,fem_M,male_M) %>%
    mutate(Age= ifelse(Age=="110+","110",Age)) %>%
    mutate(cohort2017=2017-as.numeric(Year)-1) %>%
    filter(cohort2017<=110) %>%
    filter(Age==cohort2017) %>%
    mutate(fem_M=ifelse(is.na(fem_M),1, fem_M), 
           male_M=ifelse(is.na(male_M),1,male_M)) %>%
    mutate_all(funs(ifelse(.==".", 0, .))) %>%
    mutate(fem_q=fem_M/(1+(1-0.5)*fem_M),
           male_q=male_M/(1+(1-0.5)*male_M)) %>%
    mutate(fem_p=1-fem_q, male_p=1-male_q) %>%
    filter(Age>=50)
  
  ltcoh <- qx_coh %>%
    arrange(Age) %>%
    mutate(fem_lx= cumprod(fem_p),
           male_lx= cumprod(male_p),
           Age=as.numeric(Age)+1) %>%
    select(Year,Age,fem_lx,male_lx)%>% 
    add_row(data.frame(Year = 1970, Age = 50, fem_lx = 1, male_lx = 1)) %>%  #add the radix of the life table
    arrange(Age) %>%
    mutate(fem_Lx=fem_lx-0.5*(fem_lx-lead(fem_lx)), male_Lx=male_lx-0.5*(male_lx-lead(male_lx)),
           Age5=5*floor(Age/5)) %>%
    filter(Age<110) %>%
    group_by(Age5) %>%
    summarise(fem_Lx=sum(fem_Lx),
              male_Lx=sum(male_Lx)) %>%
    rename("Age"="Age5") %>%
    pivot_longer(fem_Lx:male_Lx, names_to = "sex", values_to = "Lx") %>%
    mutate(female=ifelse(sex=="male_Lx",0,1), country=countryi) %>%
    select(Age,Lx,female)
  
  
  lt90 <- ltcoh %>%
    filter(Age>=90) %>%
    group_by(female) %>%
    summarise(Lx=sum(Lx, na.rm=TRUE)) %>%
    mutate(Age=90)
  
  hltdata <-ltcoh %>%
    select(female,Age,Lx) %>%
    filter(Age<90) %>%
    add_row(lt90) %>%
    mutate(country=countryi) %>%
    left_join(wave7health %>%
                mutate(Age=age7)) %>%
    mutate(across(c(prevADL:prevchr), ~ ifelse(is.na(.), 0, .)))
  
  
  hlt <- hltdata %>%
    mutate(ADl_Lx=Lx*prevADL,
           SR_Lx=Lx*prevSR,
           GALI_Lx=Lx*prevGALI,
           CHR_Lx=Lx*prevchr) %>%
    group_by(female,country) %>%
    summarise(UHE_ADL=sum(ADl_Lx,na.rm=TRUE),
              UHE_CHR=sum(CHR_Lx,na.rm=TRUE),
              UHE_GALI=sum(GALI_Lx,na.rm=TRUE),
              UHE_SR=sum(SR_Lx,na.rm=TRUE),
              ex=sum(Lx,na.rm=TRUE))  %>%
    mutate(HE_ADL=ex-UHE_ADL, HE_CHR=ex-UHE_CHR, HE_GALI=ex-UHE_GALI, HE_SR=ex-UHE_SR,
           sex=ifelse(female==0, "male", "female")) %>%
    select(country,sex, UHE_ADL:HE_SR)
  
   setwd(out.dir)
write.table(hlt, file="calhlt.csv", sep=",", row.names = FALSE, col.names=FALSE, append=TRUE)
write.table(hltdata, file="calhltdata.csv", sep=",", row.names = FALSE, col.names=FALSE, append=TRUE)

}


########################################################### output tables - table with HE and UHE values can be easily added to the Appendix
hlt <- read.table(file="calhlt.csv",sep=",",header=TRUE) %>%
  filter(HE_ADL>5)   #only countries with cohort life tables

calhltgap <- hlt %>%
  filter(sex=="female") %>%
  select(-sex) %>%
  left_join(hlt %>%
              filter(sex=="male") %>%
              select(-sex), by="country") %>%
  mutate(across(ends_with(".x"), 
                .fns = ~ . - get(gsub("\\.x$", ".y", cur_column())), 
                .names = "diff_{col}")) %>%
  select(c(country),starts_with("diff_")) %>%
  mutate(across(starts_with("diff_HE"), ~ -.x)) %>% #the opposite for HE to estimate the gap in NHE
  select(country,
         diff_UHE_ADL.x, diff_HE_ADL.x,
         diff_UHE_CHR.x, diff_HE_CHR.x,
         diff_UHE_GALI.x, diff_HE_GALI.x,
         diff_UHE_SR.x, diff_HE_SR.x)

  
print(xtable(calhltgap, digits=1), include.rownames = FALSE)

write.table(calhltgap, file="gap_CAL.csv", sep=",", row.names=FALSE)

########################################################### output tables - table with HE and UHE values can be easily added to the Appendix
###tables by sex to appendix
fem_tab <- hlt %>%
  filter(sex=="female") %>%
  select(-sex) %>%
  select(country, ex, UHE_ADL, HE_ADL, UHE_CHR, HE_CHR, UHE_GALI, HE_GALI, UHE_SR, HE_SR)

fem_tab2 <- fem_tab %>%
  select(country, ex, HE_ADL, HE_CHR, HE_GALI, HE_SR, UHE_ADL, UHE_CHR, UHE_GALI, UHE_SR)

write.table(fem_tab2, file="femCAL.csv", sep=",", row.names=FALSE)

male_tab <- hlt %>%
  filter(sex=="male") %>%
  select(-sex) %>%
  select(country, ex, UHE_ADL, HE_ADL, UHE_CHR, HE_CHR, UHE_GALI, HE_GALI, UHE_SR, HE_SR)
male_tab2 <- male_tab %>%
  select(country, ex, HE_ADL, HE_CHR, HE_GALI, HE_SR, UHE_ADL, UHE_CHR, UHE_GALI, UHE_SR)

write.table(male_tab2, file="maleCAL.csv", sep=",", row.names=FALSE)



##################################################################################
######## horiuchi decomposition
ULYf <- function(Lxpx){ # function for Horiuchi for l(0)=1
  lengthvec <- length(Lxpx)
  Lx <- Lxpx[1:(lengthvec / 2)]
  px <- Lxpx[(lengthvec / 2 + 1):lengthvec]
  ULY <- sum(Lx*px)
  return(ULY)
}


contrib <- function(mydata1, mydata2){
  HE_Decomp_Cont <- horiuchi(
    func=ULYf,
    pars1 = as.vector(mydata2),
    pars2 = as.vector(mydata1),
    N=20)
  cont_Lx <- sum(HE_Decomp_Cont[1:(length(HE_Decomp_Cont)/2)])
  cont_pi <- sum(HE_Decomp_Cont[(length(HE_Decomp_Cont)/2+1):length(HE_Decomp_Cont)])
  return(c(cont_Lx,cont_pi))
}


hltdata <- read.table(file="CALhltdata.csv", sep=",", header=TRUE)


countries <- sort(unique(hltdata$country))

prevhealth <- c("prevADL","prevSR","prevGALI","prevchr")


i=1
countryi <- countries[i]

j=1
healthj <- prevhealth[j]

newdata <- hltdata %>%
  filter(country==countryi) %>%
  pivot_longer(prevADL:prevchr, names_to = "type", values_to = "prev")

femLxpx <- t(newdata %>%
               filter(type==healthj,female==1) %>%
               select(Lx,prev) %>%
               pivot_longer(Lx:prev) %>%
               arrange(name) %>%
               select(value))


maleLxpx <- t(newdata %>%
                filter(type==healthj,female==0) %>%
                select(Lx,prev) %>%
                pivot_longer(Lx:prev) %>%
                arrange(name) %>%
                select(value))

mydecompo <- cbind(t(contrib(mydata1=femLxpx, mydata2=maleLxpx)), countryi,healthj)
colnames(mydecompo) <- c("cont_mort","cont_prev","country","health")
write.table(mydecompo, file="CAL_horiuchi.csv", sep=",", row.names = FALSE, append=FALSE)

for (j in 2:length(prevhealth)){
  healthj <- prevhealth[j]
  
  newdata <- hltdata %>%
    filter(country==countryi) %>%
    pivot_longer(prevADL:prevchr, names_to = "type", values_to = "prev")
  
  femLxpx <- t(newdata %>%
                 filter(type==healthj,female==1) %>%
                 select(Lx,prev) %>%
                 pivot_longer(Lx:prev) %>%
                 arrange(name) %>%
                 select(value))
  
  
  maleLxpx <- t(newdata %>%
                  filter(type==healthj,female==0) %>%
                  select(Lx,prev) %>%
                  pivot_longer(Lx:prev) %>%
                  arrange(name) %>%
                  select(value))
  
  mydecompo <- cbind(t(contrib(mydata1=femLxpx, mydata2=maleLxpx)), countryi,healthj)
  write.table(mydecompo, file="CAL_horiuchi.csv", sep=",", row.names = FALSE, col.names=FALSE, append=TRUE)
}


for (i in 2:length(countries)){
  countryi <- countries[i]
  for (j in 1:length(prevhealth)){
    healthj <- prevhealth[j]
    
    newdata <- hltdata %>%
      filter(country==countryi) %>%
      pivot_longer(prevADL:prevchr, names_to = "type", values_to = "prev")
    
    femLxpx <- t(newdata %>%
                   filter(type==healthj,female==1) %>%
                   select(Lx,prev) %>%
                   pivot_longer(Lx:prev) %>%
                   arrange(name) %>%
                   select(value))
    
    
    maleLxpx <- t(newdata %>%
                    filter(type==healthj,female==0) %>%
                    select(Lx,prev) %>%
                    pivot_longer(Lx:prev) %>%
                    arrange(name) %>%
                    select(value))
    
    mydecompo <- cbind(t(contrib(mydata1=femLxpx, mydata2=maleLxpx)), countryi,healthj)
    write.table(mydecompo, file="CAL_horiuchi.csv", sep=",", row.names = FALSE, col.names=FALSE, append=TRUE)
  }
}

###output table
horiuchi <- read.table(file="CAL_horiuchi.csv", sep=",", header=TRUE) %>%
  pivot_wider(values_from = c("cont_mort","cont_prev"), names_from = "health", names_vary = "slowest") %>%
  left_join(calhltgap) %>%
  select(country,diff_UHE_ADL.x, cont_mort_prevADL,cont_prev_prevADL,
         diff_UHE_CHR.x, cont_mort_prevchr,cont_prev_prevchr,
         diff_UHE_GALI.x, cont_mort_prevGALI,cont_prev_prevGALI,
         diff_UHE_SR.x, cont_mort_prevSR,cont_prev_prevSR)

print(xtable(horiuchi, digits=1), include.rownames = FALSE)

write.table(horiuchi, file="decomp_HCAL.csv", sep=",", row.names=FALSE)

# prepare for final plots
plot_H <- read.table(file="CAL_horiuchi.csv", sep=",", header=TRUE) %>%
  pivot_wider(values_from = c("cont_mort","cont_prev"), names_from = "health", names_vary = "slowest") %>%
  select(country,cont_mort_prevADL,cont_prev_prevADL,
         cont_mort_prevchr,cont_prev_prevchr,
         cont_mort_prevGALI,cont_prev_prevGALI,
         cont_mort_prevSR,cont_prev_prevSR) %>%
mutate(country=ifelse(country=="DEUTNP","DEU",country),
       country=ifelse(country=="FRATNP","FRA",country))


data_long <- plot_H %>%
  rename_with(~ str_replace_all(., c("cont_" = ""))) %>%
  pivot_longer(cols = -country, names_to = c("type", "dimension"), names_sep = "_") %>%
  pivot_wider(names_from = type, values_from = value)%>%
  mutate(dimension = str_replace_all(dimension, "prev", ""))


write.table(data_long, file="decompo_CAL.csv", sep=",", row.names=FALSE)




