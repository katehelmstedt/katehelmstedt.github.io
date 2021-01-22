############ DATA VISUALIZATION ############ 
# R-Ladies meeting
# 28 February 2019
# Example of how to make a simple line plot (but with dates)
# By Geraldine Klarenberg
# For this exercise we're plotting precipitation data for a location in Tanzania from "CHIRPS"

# NOTE: set working directory to source file location !!!!

library(zoo) # for working with time series
library(ggplot2)

# Load the data. This is average monthly precipitation for 7 locations in Tanzania for about 30 years (1981-2016)
df_mn_mm_t <- read.csv("CHIRPS_monthly_precip_mm_mean.csv")

# use earlier created dataframes, convert the 'date' column to proper dates
df_mn_mm_t$date <- as.Date(as.yearmon(as.character(df_mn_mm_t$date),format="%Y%m")) # turn first column into dates
df_mn_mm_t <- read.zoo(df_mn_mm_t) # turn into a zoo dataframe (has advantages for doing time series calculations)

# For each landscape, calculate the monthly average (+sd)
precip_distribution <- data.frame(matrix(NA,ncol=14,nrow=12))
for(i in 1:7){
  for(j in 1:12){
    month_ave <- mean(df_mn_mm_t[as.numeric(format(index(df_mn_mm_t), '%m'))==j,i]) 
    month_sd <- sd(df_mn_mm_t[as.numeric(format(index(df_mn_mm_t), '%m'))==j,i])
    precip_distribution[j,i] <- month_ave
    precip_distribution[j,i+7] <- month_sd
  }
}

# add column names and rows to the new data frame
names(precip_distribution)=c("L18_ave","L19_ave","L20_ave","L22_ave","L03_ave","L10_ave","L11_ave","L18_sd","L19_sd","L20_sd","L22_sd","L03_sd","L10_sd","L11_sd")

# add months and month numbers
precip_distribution$months=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
precip_distribution$month_no=c(1,2,3,4,5,6,7,8,9,10,11,12)

# reorder to represent the rainy season properly (start in July)
precip_distribution_reorder <- rbind(precip_distribution[7:12,], precip_distribution[1:6,])
# we now also need to make sure the month number become factors and that they are ordered "properly" (for our purposes)
precip_distribution_reorder$month_no <- factor(factor(precip_distribution_reorder$month_no, 
                                                      levels = c("7","8","9","10","11","12","1","2","3","4","5","6")))

# make plots
precip_L18<-ggplot(precip_distribution_reorder,aes(x=month_no,y=L18_ave, group=1))+
  geom_line(lwd=1)+
  geom_line(aes(y=L18_ave+L18_sd),lty=2)+
  geom_line(aes(y=L18_ave-L18_sd),lty=2)+
  theme_classic()+
  xlab("")+ylab("Precipitation (mm)")+
  ggtitle("L18")+
  scale_x_discrete(breaks=precip_distribution_reorder$month_no, labels=precip_distribution_reorder$months)+
  scale_y_continuous(expand=c(0,0), limits = c(0,470))

pdf("precip_lineplot.pdf")
precip_L18
dev.off()

# This plot does not look fantastic on its own, but the settings were set in such a way
# that the plots would look good when all put together