rm(list=ls())
#library(nnet)
library(geepack)
library(utils)
library(HMDHFDplus)
library(xtable)
library(tidyr)
library(dplyr)
library(purrr)
library(nnet)
library(doParallel)
library(haven)
library(stringr)
library(DemoDecomp)

out.dir <- "C://Users//mmusz//Dropbox//gender_paradox//data"
in.dir <- "C://Users/mmusz//Dropbox//gender_paradox//data//IMACHnew"
setwd(in.dir)

ourlist <- list.dirs('.', recursive=FALSE)
names <- str_replace_all(ourlist,"./","")

####### prevalence of decreased health
i=1

prev <- as_tibble(readLines(paste("C://Users/mmusz//Dropbox//gender_paradox//data//IMACHnew//", names[i],"//PL_", names[i],".txt", sep=""),warn=FALSE)[9:49]) %>%
  separate(value, into = c("col1", "col2", "col3", "col4", "col5"), sep = "\\s+") %>%
  mutate(age=col1,prev=col3) %>%
  select(age,prev) %>%
  mutate(ourname=names[i])
write.table(prev, file="C://Users/mmusz//Dropbox//gender_paradox//data//models//prev.csv", row.names=FALSE, sep=",")

for (i in 2:length(names)){
  prev <- as_tibble(readLines(paste("C://Users/mmusz//Dropbox//gender_paradox//data//IMACHnew//", names[i],"//PL_", names[i],".txt", sep=""),warn=FALSE)[9:49]) %>%
    separate(value, into = c("col1", "col2", "col3", "col4", "col5"), sep = "\\s+") %>%
    mutate(age=col1,prev=col3) %>%
    select(age,prev) %>%
    mutate(ourname=names[i])
  write.table(prev, file="C://Users/mmusz//Dropbox//gender_paradox//data//models//prev.csv", row.names=FALSE, col.names=FALSE, append=TRUE, sep=",")
}


replacements <- c("AT" = "AUT", "BE" = "BEL", "CZ"="CZE", "DE" = "DEUTNP", "DK"="DNK", "EE"="EST",
                  "FR" = "FRATNP", "GR"="GRC", "HR"="HRV", "IT" = "ITA",  "PL"="POL", "SE"="SWE")
    
prevall <- read.table(file="C://Users/mmusz//Dropbox//gender_paradox//data//models//prev.csv", sep=",", header=TRUE) %>%
  mutate(country=substr(ourname,1,2),
         country= str_replace_all(country, replacements),
         country=ifelse(country=="ES","ESP",country),
         sex=substr(ourname,3,3),
         htype=substr(ourname,4,6)) %>%
  select(-ourname) %>%
  pivot_wider(names_from = "htype", values_from = "prev")


###read life table files created for Sullivan
hltdata <- read.table(file="C://Users//mmusz//Dropbox//gender_paradox//data//hltdata.csv", sep=",", header=TRUE) %>%
  mutate(age=age7) %>%
  mutate(sex=ifelse(female==1,"F","M")) %>%
  select(country,sex,age,Lx) %>%
  right_join(prevall)

hltlong <- hltdata %>%  
  mutate(adl_Lx=Lx*adl,
         sr_Lx=Lx*sr,
         gal_Lx=Lx*gal,
         chr_Lx=Lx*chr) %>%
  group_by(sex,country) %>%
  summarise(UHE_adl=sum(adl_Lx,na.rm=TRUE),
            UHE_chr=sum(chr_Lx,na.rm=TRUE),
            UHE_gal=sum(gal_Lx,na.rm=TRUE),
            UHE_sr=sum(sr_Lx,na.rm=TRUE),
            ex=sum(Lx,na.rm=TRUE)) %>%
  ungroup() %>%
  mutate(HE_adl=ex-UHE_adl, 
         HE_chr=ex-UHE_chr, 
         HE_gal=ex-UHE_gal,
         HE_sr=ex-UHE_sr) %>%
  select(country,sex, UHE_adl:HE_sr)  

setwd(out.dir)
write.table(hltlong, file="hltlong.csv", sep=",", row.names = FALSE)

########################################################### output tables - table with HE and UHE values can be easily added to the Appendix
hltgap <- hltlong %>%
  filter(sex=="F") %>%
  select(-sex) %>%
  left_join(hltlong %>%
              filter(sex=="M") %>%
              select(-sex), by="country") %>%
  mutate(across(ends_with(".x"), 
                .fns = ~ . - get(gsub("\\.x$", ".y", cur_column())), 
                .names = "diff_{col}")) %>%
  select(c(country),starts_with("diff_")) %>%
  mutate(across(starts_with("diff_HE"), ~ -.x)) %>% #the opposite for HE to estimate the gap in NHE
  select(country,
         diff_UHE_adl.x, diff_HE_adl.x,
         diff_UHE_chr.x, diff_HE_chr.x,
         diff_UHE_gal.x, diff_HE_gal.x,
         diff_UHE_sr.x, diff_HE_sr.x)

print(xtable(hltgap, digits=1), include.rownames = FALSE)

write.table(hltgap, file="gap_long.csv", sep=",", row.names=FALSE)
###tables by sex to appendix
fem_tab <- hltlong %>%
  filter(sex=="F") %>%
  select(-sex) %>%
  select(country, ex, UHE_adl, HE_adl, UHE_chr, HE_chr, UHE_gal, HE_gal, UHE_sr, HE_sr)

print(xtable(fem_tab, digits=1), include.rownames = FALSE)

fem_tab2 <- fem_tab%>%
  select(country, ex, HE_adl, HE_chr, HE_gal, HE_sr, UHE_adl, UHE_chr, UHE_gal, UHE_sr)
write.table(fem_tab2, file="femlong.csv",sep=",",row.names=TRUE)


male_tab <- hltlong %>%
  filter(sex=="M") %>%
  select(-sex) %>%
  select(country, ex, UHE_adl, HE_adl, UHE_chr, HE_chr, UHE_gal, HE_gal, UHE_sr, HE_sr)

print(xtable(male_tab, digits=1), include.rownames = FALSE)


male_tab2 <- male_tab%>%
  select(country, ex, HE_adl, HE_chr, HE_gal, HE_sr, UHE_adl, UHE_chr, UHE_gal, UHE_sr)


write.table(male_tab2, file="malelong.csv",sep=",",row.names=TRUE)

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

countries <- sort(unique(hltgap$country))
prevhealth <- c("adl","chr","gal","sr")


i=1
countryi <- countries[i]

j=1
healthj <- prevhealth[j]

newdata <- hltdata %>%
  filter(country==countryi) %>%
  pivot_longer(adl:sr, names_to = "type", values_to = "prev")

femLxpx <- t(newdata %>%
               filter(type==healthj,sex=="F") %>%
               select(Lx,prev) %>%
               pivot_longer(Lx:prev) %>%
               arrange(name) %>%
               select(value))


maleLxpx <- t(newdata %>%
                filter(type==healthj,sex=="M") %>%
                select(Lx,prev) %>%
                pivot_longer(Lx:prev) %>%
                arrange(name) %>%
                select(value))

mydecompo <- cbind(t(contrib(mydata1=femLxpx, mydata2=maleLxpx)), countryi,healthj)
colnames(mydecompo) <- c("cont_mort","cont_prev","country","health")
write.table(mydecompo, file="longitudinal_horiuchi.csv", sep=",", row.names = FALSE, append=FALSE)

for (j in 2:length(prevhealth)){
  healthj <- prevhealth[j]
  
  newdata <- hltdata %>%
    filter(country==countryi) %>%
    pivot_longer(adl:sr, names_to = "type", values_to = "prev")
  
  femLxpx <- t(newdata %>%
                 filter(type==healthj,sex=="F") %>%
                 select(Lx,prev) %>%
                 pivot_longer(Lx:prev) %>%
                 arrange(name) %>%
                 select(value))
  
  
  maleLxpx <- t(newdata %>%
                  filter(type==healthj,sex=="M") %>%
                  select(Lx,prev) %>%
                  pivot_longer(Lx:prev) %>%
                  arrange(name) %>%
                  select(value))
  
  mydecompo <- cbind(t(contrib(mydata1=femLxpx, mydata2=maleLxpx)), countryi,healthj)
  write.table(mydecompo, file="longitudinal_horiuchi.csv", sep=",", row.names = FALSE, col.names=FALSE, append=TRUE)
}


for (i in 2:length(countries)){
  countryi <- countries[i]
  for (j in 1:length(prevhealth)){
    healthj <- prevhealth[j]
    
    newdata <- hltdata %>%
      filter(country==countryi) %>%
      pivot_longer(adl:sr, names_to = "type", values_to = "prev")
    
    femLxpx <- t(newdata %>%
                   filter(type==healthj,sex=="F") %>%
                   select(Lx,prev) %>%
                   pivot_longer(Lx:prev) %>%
                   arrange(name) %>%
                   select(value))
    
    
    maleLxpx <- t(newdata %>%
                    filter(type==healthj,sex=="M") %>%
                    select(Lx,prev) %>%
                    pivot_longer(Lx:prev) %>%
                    arrange(name) %>%
                    select(value))
    
    mydecompo <- cbind(t(contrib(mydata1=femLxpx, mydata2=maleLxpx)), countryi,healthj)
    write.table(mydecompo, file="longitudinal_horiuchi.csv", sep=",", row.names = FALSE, col.names=FALSE, append=TRUE)
  }
}

horiuchi <- read.table(file="longitudinal_horiuchi.csv", sep=",", header=TRUE) %>%
  pivot_wider(values_from = c("cont_mort","cont_prev"), names_from = "health", names_vary = "slowest") %>%
  left_join(hltgap) %>%
  select(country,diff_UHE_adl.x, cont_mort_adl,cont_prev_adl,
         diff_UHE_chr.x, cont_mort_chr,cont_prev_chr,
         diff_UHE_gal.x, cont_mort_gal,cont_prev_gal,
         diff_UHE_sr.x, cont_mort_sr,cont_prev_sr)

print(xtable(horiuchi, digits=1), include.rownames = FALSE)

write.table(horiuchi, file="decomp_long.csv", sep=",", row.names=TRUE)

# prepare for final plots
plot_H <- read.table(file="longitudinal_horiuchi.csv", sep=",", header=TRUE) %>%
   mutate(country=ifelse(country=="DEUTNP","DEU",country),
         country=ifelse(country=="FRATNP","FRA",country))

data_long <- plot_H %>%
  rename_with(~ str_replace_all(., c("cont_" = ""))) 


write.table(data_long, file="decompo_long.csv", sep=",", row.names=FALSE)






