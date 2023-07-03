getwd()
library(tidyverse)
#1.1993 fatalities dataset 
fatalities <- read_csv("StormEvents_details-ftp_v1.0_d1993_c20220425.csv")
colnames(fatalities)
# 2. Limiting the dataset
myvars <- c("BEGIN_YEARMONTH", "EPISODE_ID", "STATE", "STATE_FIPS", "CZ_NAME", "CZ_TYPE", "CZ_FIPS", "EVENT_TYPE")
fatalities1<- fatalities[myvars]
str(fatalities1)

#3.Arrange by State
fatalities1 <- arrange(fatalities1, STATE)

#4. Title case
fatalities1$STATE <- str_to_title(fatalities1$STATE)


#5. Filter CZ_Type
fatalities1 <- filter(fatalities1, CZ_TYPE == "C")
# Remove CZ_Type
fatalities <- select(fatalities1, -CZ_TYPE)

#6.Padding

fatalities1$STATE_FIPS <- str_pad(fatalities1$STATE_FIPS, width = 3,side="left", pad = "0")
fatalities1$CZ_FIPS <- str_pad(fatalities1$CZ_FIPS, width = 3,side="left", pad = "0")

fatalities1 <- unite(fatalities1, "FIPS", STATE_FIPS, CZ_FIPS, sep="", remove = TRUE)
fatalities1$FIPS

#7. Rename
fatalities1 <- rename_all(fatalities1, tolower)
colnames(fatalities1)

#8. US states data
data("state")
us_state_info<-data.frame(state=state.name, region=state.region, area=state.area)

#9. Merge

events<- data.frame(table(fatalities1$state))
events<-rename(events, c("state"="Var1"))

merged <- merge(x=events, y=us_state_info, by.x = "state", by.y = "state", all.y = TRUE)
head(merged)

#10. Plot
library(ggplot2)
storm_plot <-ggplot(merged,aes(x=area,y=Freq))+geom_point(aes(color=region))+
  labs(x="land area(square miles)",y="# of storm events in 1993")
storm_plot       


