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
library(purrr)
library(DemoDecomp)



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
            prevchr=weighted.mean(chr, cciw_w7, na.rm = TRUE)) %>%
  mutate(across(c(prevADL, prevSR, prevGALI), ~ ifelse(is.na(.), 0, .)))%>%
  mutate(age7=as.numeric(age7), age7plus = age7+4) %>%
  rowwise() %>%
  mutate(age7 = list(seq(age7, age7plus))) %>% # Create a list-column of ages
  unnest(cols = c(age7)) %>% # Unnest the list-column to get individual rows
  ungroup() %>%
  filter(age7<=90)
  
countries <- unique(wave7health$country)


########dowload life tables, join prevalence and estimate HE and UHE by country and sex
i=1
countryi <- countries[i]

lt <- readHMDweb(CNTRY=countryi, item="fltper_1x1", username="mmuszynska@gmail.com", password="123Mucha123!") %>%
  filter(Year==2017, Age>=50) %>%
  mutate(female=1, country=countryi, age7=Age) %>%
  add_row(mlt <- readHMDweb(CNTRY=countryi, item="mltper_1x1", username="mmuszynska@gmail.com", password="123Mucha123!") %>%
            filter(Year==2017, Age>=50) %>%
            mutate(female=0, country=countryi, age7=Age)) 

lt90 <- lt %>%
  filter(age7>=90) %>%
  group_by(female) %>%
  summarise(Lx=sum(Lx)) %>%
  mutate(age7=90)


hltdata <-lt %>%
  select(female,age7,Lx, country) %>%
  filter(age7<90) %>%
  add_row(lt90) %>%
  mutate(country=countryi) %>%
  left_join(wave7health) %>%
  mutate(across(c(prevADL:prevchr), ~ ifelse(is.na(.), 0, .)))%>%
  left_join(lt %>%
              filter(age7==50) %>%
              select(female,lx)) %>%
  mutate(Lx=Lx/lx)


                 
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
                           ex=sum(Lx,na.rm=TRUE)) %>%
  ungroup() %>%
  mutate(HE_ADL=ex-UHE_ADL, 
         HE_CHR=ex-UHE_CHR, 
         HE_GALI=ex-UHE_GALI,
         HE_SR=ex-UHE_SR,
         sex=ifelse(female==0, "male", "female")) %>%
  select(country,sex, UHE_ADL:HE_SR)


setwd(out.dir)
write.table(hlt, file="hlt.csv", sep=",", row.names = FALSE, append=FALSE)
write.table(hltdata, file="hltdata.csv", sep=",", row.names = FALSE, append=FALSE)

for (i in 2:length(countries)){
  countryi <- countries[i]

  lt <- readHMDweb(CNTRY=countryi, item="fltper_1x1", username="mmuszynska@gmail.com", password="123Mucha123!") %>%
    filter(Year==2017, Age>=50) %>%
    mutate(female=1, country=countryi, age7=Age) %>%
    add_row(mlt <- readHMDweb(CNTRY=countryi, item="mltper_1x1", username="mmuszynska@gmail.com", password="123Mucha123!") %>%
              filter(Year==2017, Age>=50) %>%
              mutate(female=0, country=countryi, age7=Age)) 
  
  
  lt90 <- lt %>%
    filter(age7>=90) %>%
    group_by(female) %>%
    summarise(Lx=sum(Lx)) %>%
    mutate(age7=90)
  
  hltdata <-lt %>%
    select(female,age7,Lx, country) %>%
    filter(age7<90) %>%
    add_row(lt90) %>%
    mutate(country=countryi) %>%
    left_join(wave7health) %>%
    mutate(across(c(prevADL:prevchr), ~ ifelse(is.na(.), 0, .)))%>%
    left_join(lt %>%
                filter(age7==50) %>%
                select(female,lx)) %>%
    mutate(Lx=Lx/lx)
  
  
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
              ex=sum(Lx,na.rm=TRUE)) %>%
    ungroup() %>%
    mutate(HE_ADL=ex-UHE_ADL, 
           HE_CHR=ex-UHE_CHR, 
           HE_GALI=ex-UHE_GALI,
           HE_SR=ex-UHE_SR,
           sex=ifelse(female==0, "male", "female")) %>%
    select(country,sex, UHE_ADL:HE_SR)  
  
setwd(out.dir)
write.table(hltdata, file="hltdata.csv", sep=",", row.names = FALSE, col.names=FALSE, append=TRUE)
write.table(hlt, file="hlt.csv", sep=",", row.names = FALSE, col.names=FALSE, append=TRUE)
}


########################################################### output tables - table with HE and UHE values can be easily added to the Appendix
hlt <- read.table(file="hlt.csv",sep=",",header=TRUE)

###tables by sex to appendix
fem_tab <- hlt %>%
  filter(sex=="female") %>%
  select(-sex) %>%
  select(country, ex, UHE_ADL, HE_ADL, UHE_CHR, HE_CHR, UHE_GALI, HE_GALI, UHE_SR, HE_SR)

print(xtable(fem_tab, digits=1), include.rownames = FALSE)

male_tab <- hlt %>%
  filter(sex=="male") %>%
  select(-sex) %>%
  select(country, ex, UHE_ADL, HE_ADL, UHE_CHR, HE_CHR, UHE_GALI, HE_GALI, UHE_SR, HE_SR)

print(xtable(male_tab, digits=1), include.rownames = FALSE)



hltgap <- hlt %>%
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
  
print(xtable(hltgap, digits=1), include.rownames = FALSE)

write.table(hltgap, file="gap_Sullivan.csv", sep=",", row.names=FALSE)

#############################################################################################################################################
########### Horiuchi decomposition
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

hltdata <- read.table(file="hltdata.csv", sep=",", header=TRUE)

countries <- sort(unique(hltgap$country))
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
write.table(mydecompo, file="sullivan_horiuchi.csv", sep=",", row.names = FALSE, append=FALSE)

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
  write.table(mydecompo, file="sullivan_horiuchi.csv", sep=",", row.names = FALSE, col.names=FALSE, append=TRUE)
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
  write.table(mydecompo, file="sullivan_horiuchi.csv", sep=",", row.names = FALSE, col.names=FALSE, append=TRUE)
 }
}


horiuchi <- read.table(file="sullivan_horiuchi.csv", sep=",", header=TRUE) %>%
  pivot_wider(values_from = c("cont_mort","cont_prev"), names_from = "health", names_vary = "slowest") %>%
  left_join(hltgap) %>%
  select(country,diff_UHE_ADL.x, cont_mort_prevADL,cont_prev_prevADL,
         diff_UHE_CHR.x, cont_mort_prevchr,cont_prev_prevchr,
         diff_UHE_GALI.x, cont_mort_prevGALI,cont_prev_prevGALI,
         diff_UHE_SR.x, cont_mort_prevSR,cont_prev_prevSR)

print(xtable(horiuchi, digits=1), include.rownames = FALSE)

##################################################################################################################
# prepare for final plots
plot_H <- read.table(file="sullivan_horiuchi.csv", sep=",", header=TRUE) %>%
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


write.table(data_long, file="decompo_sullivan.csv", sep=",", row.names=FALSE)
