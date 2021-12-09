library(dplyr)

sample_data %>%
  mutate(ID = factor(ID, levels = unique(ID))) %>%
  group_by(ID) %>%
  group_split() %>%
  #arrange(DATE) %>%
  setNames(unique(sample_data$ID)) -> t

lapply(t, D2_Method) #we need to parallel this lapply


 tt = sample_data

 data.table::setDT(tt)
 tt = tt[order(as.Date(tt$DATE, format="%m/%d/%Y")),]
 tt=split(tt, by = "ID")

 lapply(tt, D2_Method)
