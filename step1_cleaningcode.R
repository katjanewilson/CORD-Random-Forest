###import code
install.packages("car")
install.packages("tidyverse")
install.packages("randomForest")
install.packages("pdp")
install.packages("caret")
library(tidyverse)
library(randomForest)
library(pdp)
library(caret)
library(car)


##have to recode all of this

###recoding
rm(list = ls())
Patient <- read.csv("PatientInfo.csv", na.strings = c("",NA))
save(Patient, file = "Patient.rdata")
Patient$ID <- as.numeric(as.character(Patient$patient_id))
Patient$Sex <- Patient$sex
Patient$Age <- as.numeric(Patient$age)
data_new <- Patient %>%
  mutate(Sex = ifelse(is.na(Sex), "absent", Sex)) %>%
  mutate(age = ifelse(is.na(age), "20s", age)) %>%
  mutate(Age = case_when(age %in% c(1:10) ~ "10s",
                         age %in% c(11:20) ~ "20s",
                         age %in% c(21:30) ~ "30s",
                         age %in% c(31:40) ~ "40s",
                         age %in% c(41:50) ~ "50s",
                         age %in% c(51:60) ~ "60s",
                         age %in% c(61:70) ~ "70s",
                         age %in% c(71:80) ~ "80s",
                         age %in% c(81:120) ~ "90s")) %>%
  mutate(Province = ifelse(is.na(province), "absent", province)) %>%
  mutate(Source = ifelse(is.na(infection_case), "absent", infection_case)) %>%
  mutate(Order = ifelse(is.na(infection_order), "4", infection_order)) %>%
  mutate(confirmed_date = ifelse(is.na(confirmed_date), '2020-02-20', confirmed_date)) %>%
  mutate(State3 = ifelse(is.na(state), 'deceased', state)) %>%
  mutate(State2 = as.factor(ifelse(State3 == "deceased", "Died", "Lived"))) %>%
  mutate(State2 = ifelse(is.na(State2), "Lived", State2)) %>%
  mutate(birthyear = ifelse(is.na(birth_year), 1960, birth_year)) %>%
  mutate(Age = ifelse(is.na(Age), "20s", Age))%>%
  select(ID, Sex, birth_year, Age, Province, Source,
         Order, confirmed_date, State3, State2)
data_new$birth_year <- as.numeric(data_new$birth_year)
data_new <- data_new %>%
  mutate(birth_year = ifelse(is.na(birth_year), 1960, birth_year)) %>%
  filter(State3 != "deceased")

summary(data_new)
save(data_new, file = "work1.rdata")
