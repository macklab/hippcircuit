# HippCircuit - Behavioural Data of HCP
# Melisa Gumus - November 2020

##### Set up directory ####
setwd("~/Documents/labs/macklab/HCP")
demo <- read.csv("~/Documents/labs/macklab/HCP/HCP_demographics.csv")

# Should have at least 1 T1, 1 T2 and 1 Diffusion
clean_data <- demo[demo$T1_Count>0 & 
                   demo$T2_Count>0 &
                   demo$X3T_dMRI_Compl == "true" &
                   !demo$Age == "36+",]

subjects <- c()
for (i in seq(1,971,10)){
  j = i-1+10
  subjects <- rbind(subjects,clean_data$Subject[i:j])
}
subjects <- data.frame(subjects)
