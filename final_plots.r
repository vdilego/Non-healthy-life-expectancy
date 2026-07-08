rm(list=ls())
#library(nnet)
library(tidyr)
library(dplyr)
library(purrr)
library(ggplot2)
library(ggrepel)
library(stringr)
library(xtable)


out.dir <- "C://Users//mmusz//Dropbox//gender_paradox//data"
setwd(out.dir)

allmodels<- read.table(file="decompo_long.csv", sep=",", header=TRUE) %>%
  mutate(Type="Multistate") %>%
  rename("dimension"="health") %>%
  mutate(dimension=ifelse(dimension=="gal","GALI",dimension)) %>%
  add_row(read.table(file="decompo_CAL.csv", sep=",", header=TRUE) %>%
            mutate(Type="CAL")) %>%
  add_row(read.table(file="decompo_sullivan.csv", sep=",", header=TRUE) %>%
            mutate(Type="Sullivan")) %>%
  mutate(dimension = str_to_upper(dimension))%>%
  mutate(Type = factor(Type, levels = c("Sullivan", "CAL", "Multistate"))) %>%
  filter(country!="ISR")
  
  
ADLplot <- ggplot(allmodels %>% filter(dimension == "ADL"), aes(x = mort, y = prev, label = country)) +
  geom_text_repel(aes(color = prev > mort), show.legend = FALSE) + # Repelled labels to avoid overlap
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") + # Add horizontal line at y = 0
  facet_wrap(~ Type) + 
#  scale_x_continuous(expand = c(0, 0), limits = c(0, 3), breaks = seq(0, 3, by = 0.5)) + # Custom x-axis breaks
  theme_minimal() +
  labs(x = "Life Years", y = "Health states prevalence", title = "ADL") +
  scale_color_manual(values = c("FALSE" = "black", "TRUE" = "red")) + # Color labels based on condition
  theme(  plot.title = element_text(size = 14),
    strip.text = element_text(size = 12), # Increase size of facet titles
    axis.text.x = element_text(size = 12), # Increase size of x-axis labels
    axis.text.y = element_text(size = 12)  # Increase size of y-axis labels
  )

ggsave(filename = "C:/Users/mmusz/Dropbox/gender_paradox/figures/plotADL.pdf", plot = ADLplot, width = 8, height = 3)


GALIplot <- ggplot(allmodels %>% filter(dimension == "GALI"), aes(x = mort, y = prev, label = country)) +
  geom_text_repel(aes(color = prev > mort), show.legend = FALSE) + # Repelled labels to avoid overlap
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") + # Add horizontal line at y = 0
  facet_wrap(~ Type) + 
 # scale_x_continuous(expand = c(0, 0), limits = c(0, 3), breaks = seq(0, 3, by = 0.5)) + # Custom x-axis breaks
  theme_minimal() +
  labs(x = "Life Years", y = "Health states prevalence", title = "GALI") +
  scale_color_manual(values = c("FALSE" = "black", "TRUE" = "red")) + # Color labels based on condition
  theme(  plot.title = element_text(size = 14),
    strip.text = element_text(size = 12), # Increase size of facet titles
    axis.text.x = element_text(size = 12), # Increase size of x-axis labels
    axis.text.y = element_text(size = 12)  # Increase size of y-axis labels
  )

ggsave(filename = "C:/Users/mmusz/Dropbox/gender_paradox/figures/plotGALI.pdf", plot = GALIplot, width = 8, height = 3)


SRplot <- ggplot(allmodels %>% filter(dimension == "SR"), aes(x = mort, y = prev, label = country)) +
  geom_text_repel(aes(color = prev > mort), show.legend = FALSE) + # Repelled labels to avoid overlap
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") + # Add horizontal line at y = 0
  facet_wrap(~ Type) + 
 # scale_x_continuous(expand = c(0, 0), limits = c(0, 3), breaks = seq(0, 3, by = 0.5)) + # Custom x-axis breaks
  theme_minimal() +
  labs(x = "Life Years", y = "Health states prevalence", title = "Self-rated Health") +
  scale_color_manual(values = c("FALSE" = "black", "TRUE" = "red")) + # Color labels based on condition
  theme(  plot.title = element_text(size = 14),
    strip.text = element_text(size = 12), # Increase size of facet titles
    axis.text.x = element_text(size = 12), # Increase size of x-axis labels
    axis.text.y = element_text(size = 12)  # Increase size of y-axis labels
  )
ggsave(filename = "C:/Users/mmusz/Dropbox/gender_paradox/figures/plotSR.pdf", plot = SRplot, width = 8, height = 3)

CHRplot <- ggplot(allmodels %>% filter(dimension == "CHR"), aes(x = mort, y = prev, label = country)) +
  geom_text_repel(aes(color = prev > mort), show.legend = FALSE, max.overlaps = 15) + # Repelled labels to avoid overlap
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") + # Add horizontal line at y = 0
  facet_wrap(~ Type) + 
 # scale_x_continuous(expand = c(0, 0), limits = c(0, 3), breaks = seq(0, 3, by = 0.5)) + # Custom x-axis breaks
  theme_minimal() +
  labs(x = "Life Years", y = "Health states prevalence", title = "Chronic Morbidity") +
  scale_color_manual(values = c("FALSE" = "black", "TRUE" = "red")) + # Color labels based on condition
  theme(  plot.title = element_text(size = 14),
    strip.text = element_text(size = 12), # Increase size of facet titles
    axis.text.x = element_text(size = 12), # Increase size of x-axis labels
    axis.text.y = element_text(size = 12)  # Increase size of y-axis labels
  )
ggsave(filename = "C:/Users/mmusz/Dropbox/gender_paradox/figures/plotCHR.pdf", plot = CHRplot, width = 8, height = 3)


###non-healthy
####################################################################################
allmodels2 <- read.table(file="gap_long.csv", sep=",", header=TRUE) %>%
  mutate(Type="Multistate") %>%
  rename_with(~ str_remove_all(.x, "\\.x|diff_")) %>%
  pivot_longer(cols = -c(country, Type), names_to = "statistic", values_to = "value") %>%
  separate(statistic, into = c( "statistic","dimension"), sep = "_") %>%
  mutate(dimension=ifelse(dimension=="gal","GALI",dimension)) %>%
  add_row(read.table(file="gap_CAL.csv", sep=",", header=TRUE) %>%
            mutate(Type="CAL") %>%
            rename_with(~ str_remove_all(.x, "\\.x|diff_")) %>%
            pivot_longer(cols = -c(country, Type), names_to = "statistic", values_to = "value") %>%
            separate(statistic, into = c( "statistic","dimension"), sep = "_") %>%
            mutate(dimension=ifelse(dimension=="gal","GALI",dimension))) %>%
  add_row(read.table(file="gap_sullivan.csv", sep=",", header=TRUE) %>%
            mutate(Type="Sullivan") %>%
            rename_with(~ str_remove_all(.x, "\\.x|diff_")) %>%
            pivot_longer(cols = -c(country, Type), names_to = "statistic", values_to = "value") %>%
            separate(statistic, into = c( "statistic","dimension"), sep = "_") %>%
            mutate(dimension=ifelse(dimension=="gal","GALI",dimension))) %>%
  mutate(dimension = str_to_upper(dimension))%>%
  mutate(Type = factor(Type, levels = c("Sullivan", "CAL", "Multistate"))) %>%
  pivot_wider(names_from = statistic, values_from = value) %>%
  mutate(country=ifelse(country=="FRATNP","FRA",country),
         country=ifelse(country=="DEUTNP","DEU",country))




ADLplotN <- ggplot(allmodels2 %>% filter(dimension == "ADL"), aes(x = UHE, y = HE, label = country)) +  #HE in model2 = gap in NYE
  geom_text_repel(aes(color = UHE < 0), show.legend = FALSE) + # Color labels based on UHE < 0
  facet_wrap(~ Type) + 
  theme_minimal() +
  labs(x = "Gender gap in ULY", y = "Gender gap in NYE", title = "ADL") +
  scale_color_manual(values = c("TRUE" = "red", "FALSE" = "black")) + # Set red color for UHE < 0
  theme(
    plot.title = element_text(size = 14), # Increase size of the plot title to 14
    strip.text = element_text(size = 12), # Increase size of facet titles
    axis.text.x = element_text(size = 12), # Increase size of x-axis labels
    axis.text.y = element_text(size = 12)  # Increase size of y-axis labels
  )

ggsave(filename = "C:/Users/mmusz/Dropbox/gender_paradox/figures/plotADLNYE.pdf", plot = ADLplotN, width = 8, height = 3)



GALIplotN <- ggplot(allmodels2 %>% filter(dimension == "GALI"), aes(x = UHE, y = HE, label = country)) + #HE in model2 = gap in NYE
  geom_text_repel(aes(color = UHE < 0), show.legend = FALSE) + # Color labels based on UHE < 0
  facet_wrap(~ Type) + 
  theme_minimal() +
  labs(x = "Gender gap in ULY", y = "Gender gap in NYE", title = "GALI") +
  scale_color_manual(values = c("TRUE" = "red", "FALSE" = "black")) + # Set red color for UHE < 0
  theme(
    plot.title = element_text(size = 14), # Increase size of the plot title to 14
    strip.text = element_text(size = 12), # Increase size of facet titles
    axis.text.x = element_text(size = 12), # Increase size of x-axis labels
    axis.text.y = element_text(size = 12)  # Increase size of y-axis labels
  )

ggsave(filename = "C:/Users/mmusz/Dropbox/gender_paradox/figures/plotGALINYE.pdf", plot = GALIplotN, width = 8, height = 3)



SRplotN <- ggplot(allmodels2 %>% filter(dimension == "SR"), aes(x = UHE, y = HE, label = country)) + #HE in model2 = gap in NYE
  geom_text_repel(aes(color = UHE < 0), show.legend = FALSE) + # Color labels based on UHE < 0
  facet_wrap(~ Type) + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
  theme_minimal() +
  labs(x = "Gender gap in ULY", y = "Gender gap in NYE", title = "Self-rated Health") +
  scale_color_manual(values = c("TRUE" = "red", "FALSE" = "black")) + # Set red color for UHE < 0
  theme(
    plot.title = element_text(size = 14), # Increase size of the plot title to 14
    strip.text = element_text(size = 12), # Increase size of facet titles
    axis.text.x = element_text(size = 12), # Increase size of x-axis labels
    axis.text.y = element_text(size = 12)  # Increase size of y-axis labels
  )

ggsave(filename = "C:/Users/mmusz/Dropbox/gender_paradox/figures/plotSRNYE.pdf", plot = SRplotN, width = 8, height = 3)



CHRplotN <- ggplot(allmodels2 %>% filter(dimension == "CHR"), aes(x = UHE, y = HE, label = country)) + #HE in model2 = gap in NYE
  geom_text_repel(aes(color = UHE < 0), show.legend = FALSE, max.overlaps = 16) + # Color labels based on UHE < 0
  facet_wrap(~ Type) + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
  theme_minimal() +
  labs(x = "Gender gap in ULY", y = "Gender gap in NYE", title = "Chronic Morbidity") +
  scale_color_manual(values = c("TRUE" = "red", "FALSE" = "black")) + # Set red color for UHE < 0
  theme(
    plot.title = element_text(size = 14), # Increase size of the plot title to 14
    strip.text = element_text(size = 12), # Increase size of facet titles
    axis.text.x = element_text(size = 12), # Increase size of x-axis labels
    axis.text.y = element_text(size = 12)  # Increase size of y-axis labels
  )
ggsave(filename = "C:/Users/mmusz/Dropbox/gender_paradox/figures/plotCHRNYE.pdf", plot = CHRplotN, width = 8, height = 3)


#######################corelations
cor.coeff <- allmodels2 %>% 
  group_by(Type,dimension) %>%
  summarise(corHN=cor(UHE,HE),
            p.value = cor.test(UHE, HE)$p.value,
            significance = case_when(p.value < 0.01 ~ "***",p.value < 0.05 ~ "**",p.value < 0.1 ~ "*",TRUE ~ "" )) %>%
  select(dimension,Type,corHN,significance) %>%
  arrange(dimension) %>%
  pivot_wider(values_from = c(corHN,significance), names_from = Type, names_vary="slowest")


print(xtable(cor.coeff, digits=2), include.rownames = FALSE)

########share of mortality contribution
allmodels2 <- read.table(file="gap_long.csv", sep=",", header=TRUE) %>%
  mutate(Type="Multistate") %>%
  rename_with(~ str_remove_all(.x, "\\.x|diff_")) %>%
  pivot_longer(cols = -c(country, Type), names_to = "statistic", values_to = "value") %>%
  separate(statistic, into = c( "statistic","dimension"), sep = "_") %>%
  mutate(dimension=ifelse(dimension=="gal","GALI",dimension)) %>%
  add_row(read.table(file="gap_CAL.csv", sep=",", header=TRUE) %>%
            mutate(Type="CAL") %>%
            rename_with(~ str_remove_all(.x, "\\.x|diff_")) %>%
            pivot_longer(cols = -c(country, Type), names_to = "statistic", values_to = "value") %>%
            separate(statistic, into = c( "statistic","dimension"), sep = "_") %>%
            mutate(dimension=ifelse(dimension=="gal","GALI",dimension))) %>%
  add_row(read.table(file="gap_sullivan.csv", sep=",", header=TRUE) %>%
            mutate(Type="Sullivan") %>%
            rename_with(~ str_remove_all(.x, "\\.x|diff_")) %>%
            pivot_longer(cols = -c(country, Type), names_to = "statistic", values_to = "value") %>%
            separate(statistic, into = c( "statistic","dimension"), sep = "_") %>%
            mutate(dimension=ifelse(dimension=="gal","GALI",dimension))) %>%
  mutate(dimension = str_to_upper(dimension))%>%
  mutate(Type = factor(Type, levels = c("Sullivan", "CAL", "Multistate"))) %>%
  pivot_wider(names_from = statistic, values_from = value) %>%
  mutate(country=ifelse(country=="FRATNP","FRA",country),
         country=ifelse(country=="DEUTNP","DEU",country))



shares <- allmodels2 %>%
   mutate(share_NLY=(UHE-HE)/(-HE),
         dimension = toupper(dimension)) %>%
  left_join(allmodels %>%
  mutate(share_ULY=mort/(mort+prev)))


adl <- shares %>%
  filter(dimension=="ADL", share_ULY>0, share_NLY<2)

ADLshares <- ggplot(adl, aes(x = share_ULY, y = share_NLY, label = country)) +  #HE in model2 = gap in NYE
  geom_text_repel(show.legend = FALSE, max.overlaps = Inf) + # Color labels based on UHE < 0
  facet_wrap(~ Type) + 
  theme_minimal() +
  labs(x = "Contribution to Gap in ULY", y = "Contribution to Gap in NYE", title = "ADL") +
  scale_color_manual(values = c("TRUE" = "red", "FALSE" = "black")) + # Set red color for UHE < 0
  theme(
    plot.title = element_text(size = 14), # Increase size of the plot title to 14
    strip.text = element_text(size = 12), # Increase size of facet titles
    axis.text.x = element_text(size = 12), # Increase size of x-axis labels
    axis.text.y = element_text(size = 12)  # Increase size of y-axis labels
  )

ggsave(filename = "C:/Users/mmusz/Dropbox/gender_paradox/figures/shares_ADL.pdf", plot = ADLshares, width = 8, height = 3)


gali <- shares %>%
  filter(dimension=="GALI", share_NLY<3)

galishares <- ggplot(gali, aes(x = share_ULY, y = share_NLY, label = country)) +  #HE in model2 = gap in NYE
  geom_text_repel(show.legend = FALSE, max.overlaps = Inf) + # Color labels based on UHE < 0
  facet_wrap(~ Type) + 
  theme_minimal() +
  labs(x = "Contribution to Gap in ULY", y = "Contribution to Gap in NYE", title = "GALI") +
  scale_color_manual(values = c("TRUE" = "red", "FALSE" = "black")) + # Set red color for UHE < 0
  theme(
    plot.title = element_text(size = 14), # Increase size of the plot title to 14
    strip.text = element_text(size = 12), # Increase size of facet titles
    axis.text.x = element_text(size = 12), # Increase size of x-axis labels
    axis.text.y = element_text(size = 12)  # Increase size of y-axis labels
  )

ggsave(filename = "C:/Users/mmusz/Dropbox/gender_paradox/figures/shares_GALIL.pdf", plot = galishares, width = 8, height = 3)


chr <- shares %>%
  filter(dimension=="CHR", share_NLY>-25)

chrshares <- ggplot(chr, aes(x = share_ULY, y = share_NLY, label = country)) +  #HE in model2 = gap in NYE
  geom_text_repel(show.legend = FALSE, max.overlaps = Inf) + # Color labels based on UHE < 0
  facet_wrap(~ Type) + 
  theme_minimal() +
  labs(x = "Contribution to Gap in ULY", y = "Contribution to Gap in NYE", title = "Chronic morbidity") +
  scale_color_manual(values = c("TRUE" = "red", "FALSE" = "black")) + # Set red color for UHE < 0
  theme(
    plot.title = element_text(size = 14), # Increase size of the plot title to 14
    strip.text = element_text(size = 12), # Increase size of facet titles
    axis.text.x = element_text(size = 12), # Increase size of x-axis labels
    axis.text.y = element_text(size = 12)  # Increase size of y-axis labels
  )

ggsave(filename = "C:/Users/mmusz/Dropbox/gender_paradox/figures/shares_chr.pdf", plot = chrshares, width = 8, height = 3)



cor.coeff.shares <- adl %>% 
  add_row(gali) %>%
  group_by(Type,dimension) %>%
  summarise(corHN=cor(share_NLY,share_ULY),
            p.value = cor.test(share_NLY,share_ULY)$p.value,
            significance = case_when(p.value < 0.01 ~ "***",p.value < 0.05 ~ "**",p.value < 0.1 ~ "*",TRUE ~ "" )) %>%
  select(dimension,Type,corHN,significance) %>%
  arrange(dimension) %>%
  pivot_wider(values_from = c(corHN,significance), names_from = Type, names_vary="slowest")


print(xtable(cor.coeff.shares, digits=2), include.rownames = FALSE)

