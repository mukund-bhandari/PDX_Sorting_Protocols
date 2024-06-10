library(tidyverse)
library(dplyr)
library(ggplot2)
library(readxl)
library(ggthemes)
library(stringr)
library(ggprism)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(readxl)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(readxl)

df_combined <- read_xlsx(path= "Master_Table.xlsx", sheet=12)

df_combined<- df_combined %>%
  mutate(CON_TAB = case_when(
    SORTED_AS == "HUMAN" & ORIGINAL_TAG == "HUMAN" ~ "cH",
    SORTED_AS == "MOUSE" & ORIGINAL_TAG == "MOUSE" ~ "cM",
    SORTED_AS == "HUMAN" & ORIGINAL_TAG == "MOUSE" ~ "iH",
    SORTED_AS == "MOUSE" & ORIGINAL_TAG == "HUMAN" ~ "iM")
  ) %>%
  arrange(RATIO,Tools, RUN_NUMBER , CON_TAB ) 


############# extract table to get total correct, total incorrect etc #############
df_wide <- df_combined %>%
  select(RATIO, Tools, RUN_NUMBER, CON_TAB, Number_uniq ) %>%
  pivot_wider(names_from = CON_TAB, values_from = Number_uniq) 

##################          ################

df_wide <- df_wide %>% 
  mutate(aH = case_when(
    RATIO == "1090" ~ (9000000-(cH+iM)), 
    RATIO == "2080" ~ (8000000-(cH+iM)),
    RATIO == "4060" ~ (6000000-(cH+iM))
  ))  %>% 
  mutate(aM = case_when(
    RATIO == "1090" ~ (1000000-(cM+iH)), 
    RATIO == "2080" ~ (2000000-(cM+iH)),
    RATIO == "4060" ~ (4000000-(cM+iH))
  ))


df_wide <- df_wide %>%
  mutate(MIX = case_when( RATIO == 1090 ~ "90HOMO:10MUS_MIX",
                          RATIO == 2080 ~ "80HOMO:20MUS_MIX",
                          RATIO == 4060 ~ "60HOMO:40MUS_MIX")
  )

########################## prediction accuracy ###########################
df_wide <- df_wide %>% 
  mutate(Correctly_Prediction_Accuracy = ((cH+cM)*100)/10000000)
######################## plot it ###############################

df_plot<- df_wide %>% 
  mutate(Tools = factor(Tools, levels = c(   "XenofilteR_HISAT",
                                             "XenofilteR_STAR",
                                             "Disambiguate_HISAT",
                                             "bamcmp_HISAT",
                                             "bamcmp_STAR",
                                             "Disambiguate_STAR",
                                             "Xenome",
                                             "Bbsplit", 
                                             "Xengsort")))

p2 <- ggplot(df_plot, aes(x=Tools, y=Correctly_Prediction_Accuracy, color=Tools, fill=Tools)) + 
  geom_boxplot(notch = F, size=1.5, outlier.colour = "red", outlier.shape = 1) +
  #geom_jitter(width = 0.2)+
  facet_wrap(~MIX)+
  theme_prism(border = TRUE)+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  scale_y_continuous(limits = c(92, 98), breaks = seq(92, 98, by = 1))+
  theme(strip.text = element_text(size=18))+
  #ggtitle("Percentage of reads correctly sorted by different tools as human or mouse reads") +
  ylab("Correctly Classified (%)")+
  xlab("Protocols")+
  theme(plot.title = element_text(hjust = 0.5, face = "italic", family = "serif"))+
  theme(axis.text.x = element_text(size=18),axis.title=element_text(size=18,face="bold"),
        axis.text.y = element_text(size=18),
  )+
  theme(legend.position = "none")

p2





####################### % of Human reads classified as mouse reads #################
####################### % of Mouse reads classified as Human reads #################
df_wide <-df_wide %>% 
  mutate(Tools = factor(Tools, levels = c(   "XenofilteR_HISAT",
                                             "XenofilteR_STAR",
                                             "Disambiguate_HISAT",
                                             "bamcmp_HISAT",
                                             "bamcmp_STAR",
                                             "Disambiguate_STAR",
                                             "Xenome",
                                             "Bbsplit", 
                                             "Xengsort")))


df_wide <- df_wide %>%
  mutate(iM_Percent = case_when(RATIO == 1090 ~ iM/90000,
                                RATIO == 2080 ~ iM/80000,
                                RATIO == 4060 ~ iM/60000)
  ) %>%
  mutate(iH_Percent = case_when(RATIO == 1090 ~ iH/10000,
                                RATIO == 2080 ~ iH/20000,
                                RATIO == 4060 ~ iH/40000)
  )


################################ human as mouse reads ###################
p3 <- ggplot(df_wide, aes(x=Tools, y=iM_Percent, color=Tools, fill=Tools)) + 
  geom_boxplot() +
  facet_wrap(~MIX)+
  theme_prism(border = TRUE)+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  scale_y_continuous(limits = c(0, 2), breaks = seq(0, 2, by = 0.2))+
  #ggtitle("Percentage of human reads incorrectly sorted by different tools as mouse reads in 50 mix sampling") +
  theme(plot.title = element_text(hjust = 0.5, face = "italic", family = "serif"))+
  theme(axis.text.x = element_text(size=18),axis.title=element_text(size=18,face="bold"),
        axis.text.y = element_text(size=18),
  )+
  theme(legend.position = "none")+
  theme(strip.text = element_text(size=18))+
  ylab("Incorrectly classified as Mouse reads (%)")+
  xlab("Protocols")

p3





################################ mouse as human reads ##############  
p4 <- ggplot(df_wide, aes(x=Tools, y=iH_Percent, color=Tools, fill=Tools)) + 
  geom_boxplot() +
  facet_wrap(~MIX)+
  theme_prism(border = TRUE)+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  scale_y_continuous(limits = c(0.5, 1.1), breaks = seq(0.5, 1.1, by = 0.1))+
  #ggtitle("Percentage of mouse reads incorrectly sorted by different tools as human reads in 50 mix sampling") +
  theme(plot.title = element_text(hjust = 0.5, face = "italic", family = "serif"))+
  theme(axis.text.x = element_text(size=18),axis.title=element_text(size=18,face="bold"),
        axis.text.y = element_text(size=18),
  )+
  theme(legend.position = "none")+
  theme(strip.text = element_text(size=18))+
  ylab("Incorrectly classified as Human reads (%)")+
  xlab("Protocols")
#ggtitle(NULL) +
#labs(caption = "Percentage of mouse reads incorrectly sorted by tools as human reads") +
#theme(plot.caption = element_text(hjust = 0.5, face = "italic", family = "serif"))


p4





#############
############ambigious reads ############


df_combined <- read_xlsx(path= "Master_Table.xlsx", sheet=12)

df_combined<- df_combined %>%
  mutate(CON_TAB = case_when(
    SORTED_AS == "HUMAN" & ORIGINAL_TAG == "HUMAN" ~ "cH",
    SORTED_AS == "MOUSE" & ORIGINAL_TAG == "MOUSE" ~ "cM",
    SORTED_AS == "HUMAN" & ORIGINAL_TAG == "MOUSE" ~ "iH",
    SORTED_AS == "MOUSE" & ORIGINAL_TAG == "HUMAN" ~ "iM")
  ) %>%
  arrange(RATIO,Tools, RUN_NUMBER , CON_TAB ) 


############# extract table to get total correct, total incorrect etc #############
df_wide <- df_combined %>%
  select(RATIO, Tools, RUN_NUMBER, CON_TAB, Number_uniq ) %>%
  pivot_wider(names_from = CON_TAB, values_from = Number_uniq) 

##################          ################

df_wide <- df_wide %>% 
  mutate(aH = case_when(
    RATIO == "1090" ~ (9000000-(cH+iM)), 
    RATIO == "2080" ~ (8000000-(cH+iM)),
    RATIO == "4060" ~ (6000000-(cH+iM))
  ))  %>% 
  mutate(aM = case_when(
    RATIO == "1090" ~ (1000000-(cM+iH)), 
    RATIO == "2080" ~ (2000000-(cM+iH)),
    RATIO == "4060" ~ (4000000-(cM+iH))
  ))


df_wide <- df_wide %>%
  mutate(MIX = case_when( RATIO == 1090 ~ "90HOMO:10MUS_MIX",
                          RATIO == 2080 ~ "80HOMO:20MUS_MIX",
                          RATIO == 4060 ~ "60HOMO:40MUS_MIX")
  )

df_wide <- df_wide %>%
  mutate(total_ambiguous = aH + aM)

########################## ambigious percentage ###########################
df_wide <- df_wide %>% 
  mutate(total_ambiguous_percentage = ((total_ambiguous)*100)/10000000)
######################## plot it ###############################

df_plot<- df_wide %>% 
  mutate(Tools = factor(Tools, levels = c(   "XenofilteR_HISAT",
                                             "XenofilteR_STAR",
                                             "Disambiguate_HISAT",
                                             "bamcmp_HISAT",
                                             "bamcmp_STAR",
                                             "Disambiguate_STAR",
                                             "Xenome",
                                             "Bbsplit", 
                                             "Xengsort")))

p2 <- ggplot(df_plot, aes(x=Tools, y=total_ambiguous_percentage, color=Tools, fill=Tools)) + 
  geom_boxplot() +
  facet_wrap(~MIX)+
  theme_prism(border = TRUE)+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  scale_y_continuous(limits = c(1, 7), breaks = seq(1, 7, by = 1))+
  #ggtitle("Percentage of ambigious reads in different methods at different mix proportions") +
  #theme(plot.title = element_text(hjust = 0.5, face = "italic", family = "serif"))+
  theme(axis.text.x = element_text(size=18),axis.title=element_text(size=18,face="bold"),
        axis.text.y = element_text(size=18),
  )+
  theme(legend.position = "none")+
  theme(strip.text = element_text(size=18))+
  ylab("Ambigious reads (%)")+
  xlab("Protocols")

p2






