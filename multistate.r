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
library(ggplot2)
library(ggrepel)
library(stringr)
library(xtable)



out.dir <- "C://Users//mmusz//Dropbox//gender_paradox//data"
in.dir <- "C://Users/mmusz//Dropbox//gender_paradox//data//IMACHnew"
setwd(in.dir)


###########################files with probs of transition and starting prevalence
ourlist <- list.dirs('.', recursive=FALSE)
names <- str_replace_all(ourlist,"./","")

i=1
probs <- as.matrix(readLines(paste("C://Users/mmusz//Dropbox//gender_paradox//data//IMACHnew//", names[i],
                                   "//PIJ_", names[i],".txt", sep=""))[-c(1:7)]) 

probs <- data.frame(data.frame(V1 = probs, stringsAsFactors = FALSE)) %>%
  separate(V1, into = paste0("col", 1:9), sep = "\\s+", convert = TRUE)

colnames(probs) <- c("no", "Agex", "Agex_h", "p11", "p12", "p13", 
                    "p21", "p22", "p23")
fprobs <- probs %>%
  filter(as.numeric(Agex_h) == as.numeric(as.character(Agex))+1) %>%
  arrange(as.numeric(Agex)) %>%
  mutate(name=names[i])

setwd(out.dir)
write.table(fprobs, file="tprobs.csv", row.names=FALSE, sep=",")

share <- as.matrix(readLines(paste("C://Users/mmusz//Dropbox//gender_paradox//data//IMACHnew//", names[i],
                                   "//P_", names[i],".txt", sep=""))[6]) 
sharep <- t(c(strsplit(share," ")[[1]][3],names[i]))
setwd(out.dir)
write.table(sharep, file="sharep.csv", row.names=FALSE, sep=",")


for (i in 2:length(names)){
  probs <- as.matrix(readLines(paste("C://Users/mmusz//Dropbox//gender_paradox//data//IMACHnew//", names[i],
                                     "//PIJ_", names[i],".txt", sep=""))[-c(1:7)]) 
  
  probs <- data.frame(data.frame(V1 = probs, stringsAsFactors = FALSE)) %>%
    separate(V1, into = paste0("col", 1:9), sep = "\\s+", convert = TRUE)
  
  colnames(probs) <- c("no", "Agex", "Agex_h", "p11", "p12", "p13", 
                       "p21", "p22", "p23")
  fprobs <- probs %>%
    filter(as.numeric(Agex_h) == as.numeric(as.character(Agex))+1) %>%
    arrange(as.numeric(Agex)) %>%
    mutate(name=names[i])
  
  setwd(out.dir)
  write.table(fprobs, file="tprobs.csv", row.names=FALSE, col.names=FALSE, sep=",", append=TRUE)
  
  share <- as.matrix(readLines(paste("C://Users/mmusz//Dropbox//gender_paradox//data//IMACHnew//", names[i],
                                     "//P_", names[i],".txt", sep=""))[6]) 
  sharep <- t(c(strsplit(share," ")[[1]][3],names[i]))
  setwd(out.dir)
  write.table(sharep, file="sharep.csv",  row.names=FALSE, col.names=FALSE, sep=",", append=TRUE)
  
}
####################################################multistate life tables
fprobs <- read.table(file="tprobs.csv", header=TRUE, sep=",") %>%
  mutate(country=substr(name,1,2),
         health=substr(name,4,6),
         sex=substr(name,3,3))


sharep <- read.table(file="sharep.csv", header=TRUE, sep=",")
colnames(sharep) <- c("healthy","name")
sharep <- sharep %>%
  mutate(country=substr(name,1,2),
         health=substr(name,4,6),
         sex=substr(name,3,3))

countries <- unique(fprobs$country)
health <- unique(fprobs$health)


HE_ULE <- function(mysharep,myprobs){
  lx <- c(mysharep$healthy*100000,(1-mysharep$healthy)*100000)
  pop <- matrix(0, nrow = n_ages, ncol = 2)
  colnames(pop) <- c("Healthy", "Unhealthy")
  rownames(pop) <- ages
  
  P_h <- list()
  P_u <- list()
  
  # Loop through the data to create matrices
  for (i in 1:nrow(myprobs)) {
    # Extract the transition probabilities
    p_h <- c(myprobs$p11[i], myprobs$p12[i], myprobs$p13[i])
    p_u <- c(myprobs$p21[i], myprobs$p22[i], myprobs$p23[i])
    
    # Combine the probabilities into the respective matrices
    P_h[[i]] <- matrix(p_h, nrow = 3, byrow = TRUE)
    P_u[[i]] <- matrix(p_u, nrow = 3, byrow = TRUE)
  }
  
  pop[1, ] <- lx
  
  # Project the population for each subsequent age
  for (i in 2:n_ages) {
    # Get transition matrices for this age
    P_hi <- P_h[[i - 1]]  # Transition matrix for healthy state
    P_ui <- P_u[[i - 1]]  # Transition matrix for unhealthy state
    
    # Calculate new population distribution for this age
    pop[i, 1] <- pop[i - 1, 1] * P_hi[1, 1] + pop[i - 1, 2] * P_ui[1, 1]  # Healthy 
    pop[i, 2] <- pop[i - 1, 1] * P_hi[2, 1] + pop[i - 1, 2] * P_ui[2, 1]  # Unhealthy
  }
  
  # Calculate the total time spent in each state (population-years)
  expectancy <- colSums(pop)/100000
  return(expectancy)
}

####
i=1
j=1

countryi <- countries[i]
healthst <- health[j]

myprobsF <- fprobs %>%
  filter(country==countryi, health==healthst, sex=="F")
myprobsM <- fprobs %>%
  filter(country==countryi, health==healthst, sex=="M")

ages <- 50:90
n_ages <- length(ages)
########################################################################
#### both HE and ULY for women
mysharep <- sharep%>%
  filter(country==countryi, health==healthst, sex=="F")



myprobsF_M <- myprobsF

myprobsF_M$p13 <- myprobsM$p13
myprobsF_M$p11 <- myprobsF$p11*(1-myprobsF_M$p13)/(1-myprobsF$p13)
myprobsF_M$p12 <- myprobsF$p12*(1-myprobsF_M$p13)/(1-myprobsF$p13)

myprobsF_M$p23 <- myprobsM$p23
myprobsF_M$p21 <- myprobsF$p21*(1-myprobsF_M$p23)/(1-myprobsF$p23)
myprobsF_M$p22 <- myprobsF$p22*(1-myprobsF_M$p23)/(1-myprobsF$p23)


HE_ULE_ff <- c(HE_ULE(mysharep=mysharep,myprobs=myprobsF), countryi, healthst) 
HE_ULE_fm <- c(HE_ULE(mysharep=mysharep,myprobs=myprobsF_M), countryi, healthst) 

setwd(out.dir)
write.table(t(HE_ULE_ff), file="HE_ULE_ff.csv", sep=",", row.names=FALSE)
write.table(t(HE_ULE_fm), file="HE_ULE_fm.csv", sep=",", row.names=FALSE)

#####male
myprobsM_F <- myprobsM

myprobsM_F$p13 <- myprobsF$p13
myprobsM_F$p11 <- myprobsM$p11*(1-myprobsM_F$p13)/(1-myprobsM$p13)
myprobsM_F$p12 <- myprobsM$p12*(1-myprobsM_F$p13)/(1-myprobsM$p13)

myprobsM_F$p23 <- myprobsF$p23
myprobsM_F$p21 <- myprobsM$p21*(1-myprobsM_F$p23)/(1-myprobsM$p23)
myprobsM_F$p22 <- myprobsM$p22*(1-myprobsM_F$p23)/(1-myprobsM$p23)

HE_ULE_mm <- c(HE_ULE(mysharep=mysharep,myprobs=myprobsM), countryi, healthst) 
HE_ULE_mf <- c(HE_ULE(mysharep=mysharep,myprobs=myprobsM_F), countryi, healthst) 
setwd(out.dir)
write.table(t(HE_ULE_mm), file="HE_ULE_mm.csv", sep=",", row.names=FALSE)
write.table(t(HE_ULE_mf), file="HE_ULE_mf.csv", sep=",", row.names=FALSE)


for (j in 1:length(health)){
  countryi <- countries[i]
  healthst <- health[j]
  
  myprobsF <- fprobs %>%
    filter(country==countryi, health==healthst, sex=="F")
  myprobsM <- fprobs %>%
    filter(country==countryi, health==healthst, sex=="M")
  
  ########################################################################
  #### both HE and ULY for women
  mysharep <- sharep%>%
    filter(country==countryi, health==healthst, sex=="F")
  
  myprobsF_M <- myprobsF
  
  myprobsF_M$p13 <- myprobsM$p13
  myprobsF_M$p11 <- myprobsF$p11*(1-myprobsF_M$p13)/(1-myprobsF$p13)
  myprobsF_M$p12 <- myprobsF$p12*(1-myprobsF_M$p13)/(1-myprobsF$p13)
  
  myprobsF_M$p23 <- myprobsM$p23
  myprobsF_M$p21 <- myprobsF$p21*(1-myprobsF_M$p23)/(1-myprobsF$p23)
  myprobsF_M$p22 <- myprobsF$p22*(1-myprobsF_M$p23)/(1-myprobsF$p23)
  
  HE_ULE_ff <- c(HE_ULE(mysharep=mysharep,myprobs=myprobsF), countryi, healthst) 
  HE_ULE_fm <- c(HE_ULE(mysharep=mysharep,myprobs=myprobsF_M), countryi, healthst) 
  
  setwd(out.dir)
  write.table(t(HE_ULE_ff), file="HE_ULE_ff.csv", sep=",", row.names=FALSE, col.names=FALSE, append=TRUE)
  write.table(t(HE_ULE_fm), file="HE_ULE_fm.csv", sep=",", row.names=FALSE, col.names=FALSE, append=TRUE)
  
  #####male
  myprobsM_F <- myprobsM
  
  myprobsM_F$p13 <- myprobsF$p13
  myprobsM_F$p11 <- myprobsM$p11*(1-myprobsM_F$p13)/(1-myprobsM$p13)
  myprobsM_F$p12 <- myprobsM$p12*(1-myprobsM_F$p13)/(1-myprobsM$p13)
  
  myprobsM_F$p23 <- myprobsF$p23
  myprobsM_F$p21 <- myprobsM$p21*(1-myprobsM_F$p23)/(1-myprobsM$p23)
  myprobsM_F$p22 <- myprobsM$p22*(1-myprobsM_F$p23)/(1-myprobsM$p23)
  
  HE_ULE_mm <- c(HE_ULE(mysharep=mysharep,myprobs=myprobsM), countryi, healthst) 
  HE_ULE_mf <- c(HE_ULE(mysharep=mysharep,myprobs=myprobsM_F), countryi, healthst) 
  setwd(out.dir)
  write.table(t(HE_ULE_mm), file="HE_ULE_mm.csv", sep=",", row.names=FALSE, col.names=FALSE, append=TRUE)
  write.table(t(HE_ULE_mf), file="HE_ULE_mf.csv", sep=",", row.names=FALSE, col.names=FALSE, append=TRUE)
}



####
for (i in 2:length(countries)){
  for (j in 1:length(health)){
  countryi <- countries[i]
  healthst <- health[j]

  myprobsF <- fprobs %>%
    filter(country==countryi, health==healthst, sex=="F")
  myprobsM <- fprobs %>%
    filter(country==countryi, health==healthst, sex=="M")

########################################################################
#### both HE and ULY for women
  mysharep <- sharep%>%
    filter(country==countryi, health==healthst, sex=="F")

  myprobsF_M <- myprobsF

  myprobsF_M$p13 <- myprobsM$p13
  myprobsF_M$p11 <- myprobsF$p11*(1-myprobsF_M$p13)/(1-myprobsF$p13)
  myprobsF_M$p12 <- myprobsF$p12*(1-myprobsF_M$p13)/(1-myprobsF$p13)

  myprobsF_M$p23 <- myprobsM$p23
  myprobsF_M$p21 <- myprobsF$p21*(1-myprobsF_M$p23)/(1-myprobsF$p23)
  myprobsF_M$p22 <- myprobsF$p22*(1-myprobsF_M$p23)/(1-myprobsF$p23)

  HE_ULE_ff <- c(HE_ULE(mysharep=mysharep,myprobs=myprobsF), countryi, healthst) 
  HE_ULE_fm <- c(HE_ULE(mysharep=mysharep,myprobs=myprobsF_M), countryi, healthst) 

  setwd(out.dir)
  write.table(t(HE_ULE_ff), file="HE_ULE_ff.csv", sep=",", row.names=FALSE, col.names=FALSE, append=TRUE)
  write.table(t(HE_ULE_fm), file="HE_ULE_fm.csv", sep=",", row.names=FALSE, col.names=FALSE, append=TRUE)

#####male
  myprobsM_F <- myprobsM

  myprobsM_F$p13 <- myprobsF$p13
  myprobsM_F$p11 <- myprobsM$p11*(1-myprobsM_F$p13)/(1-myprobsM$p13)
  myprobsM_F$p12 <- myprobsM$p12*(1-myprobsM_F$p13)/(1-myprobsM$p13)

  myprobsM_F$p23 <- myprobsF$p23
  myprobsM_F$p21 <- myprobsM$p21*(1-myprobsM_F$p23)/(1-myprobsM$p23)
  myprobsM_F$p22 <- myprobsM$p22*(1-myprobsM_F$p23)/(1-myprobsM$p23)

  HE_ULE_mm <- c(HE_ULE(mysharep=mysharep,myprobs=myprobsM), countryi, healthst) 
  HE_ULE_mf <- c(HE_ULE(mysharep=mysharep,myprobs=myprobsM_F), countryi, healthst) 
  setwd(out.dir)
  write.table(t(HE_ULE_mm), file="HE_ULE_mm.csv", sep=",", row.names=FALSE, col.names=FALSE, append=TRUE)
  write.table(t(HE_ULE_mf), file="HE_ULE_mf.csv", sep=",", row.names=FALSE, col.names=FALSE, append=TRUE)
  }
}

HE_ULE_ff <- read.table(file="HE_ULE_ff.csv", sep=",", header=TRUE)
HE_ULE_fm <- read.table(file="HE_ULE_fm.csv", sep=",", header=TRUE)
HE_ULE_mm <- read.table(file="HE_ULE_mm.csv", sep=",", header=TRUE)
HE_ULE_mf <- read.table(file="HE_ULE_mf.csv", sep=",", header=TRUE)

gap1 <- HE_ULE_ff$Unhealthy-HE_ULE_mf$Unhealthy
gap2 <- HE_ULE_fm$Unhealthy-HE_ULE_mm$Unhealthy
gap <- HE_ULE_ff$Unhealthy-HE_ULE_mm$Unhealthy
country <- HE_ULE_ff$X
dimension <- HE_ULE_ff$X.1

gaps <- cbind(gap1,gap2,(gap1+gap2)/2, gap, country,dimension)
write.table(gaps, file="gaps.csv",sep=",",row.names = FALSE)

####################################################################################################################
###### plots

gaps <- read.table(file="gaps.csv",sep=",",header = TRUE) %>%
  distinct() %>%
  mutate(dimension = factor(dimension, levels = c("adl", "chr", "gal","sr"),
                      labels = c("ADL","Chronic Morbidity", "GALI", "Self-rated Health")))


custom_labels <- c("ADL" = "ADL, cor.coeff=0.81**", "Chronic Morbidity" = "Chronic Morbidity, cor.coeff=0.37", 
                   "GALI" = "GALI, cor.coeff=0.51*",  "Self-rated Health"= "Self-rated Health, cor.coeff=0.46")

plotsms<- ggplot(gaps %>% filter(gap>-1), aes(x = gap, y = X, label = country)) +  #HE in model2 = gap in NYE
  geom_text_repel(aes(color = X < gap/4), show.legend = FALSE, max.overlaps = 15) + # Color labels based on UHE < 0
  facet_wrap(~dimension, labeller = labeller(dimension = custom_labels)) +
  theme_minimal() +
  geom_vline(xintercept = 0, linetype = "dashed")+
  geom_hline(yintercept = 0, linetype = "dashed")+
  labs(x = "Gender gap in ULE", y = "Gender gap in MsULE") +
  scale_color_manual(values = c("TRUE" = "red", "FALSE" = "black")) + # Set red color for UHE < 0
  theme(
    plot.title = element_text(size = 14), # Increase size of the plot title to 14
    strip.text = element_text(size = 12), # Increase size of facet titles
    axis.text.x = element_text(size = 12), # Increase size of x-axis labels
    axis.text.y = element_text(size = 12)  # Increase size of y-axis labels
  )

ggsave(filename = "C:/Users/mmusz/Dropbox/gender_paradox/figures/plotMsULE.jpg", plot = plotsms, width = 8, height = 6)

gapsel <- gaps %>%
  filter(dimension=="Self-rated Health")
