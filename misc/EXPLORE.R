
day1_win = day1_win%>% mutate(wesd = wesd* 20.88543* 0.00980665)
day2_win = day2_win %>% mutate(sum_changes =sum_changes* 20.88543* 0.00980665)
par(mfrow=c(1,2))
plotdist(day1_win$wesd, histo = TRUE, demp = TRUE)
plotdist(day2_win$sum_changes, histo = TRUE, demp = TRUE)

fit_gev1=extRemes::fevd(x = day1_win$wesd, type = "GEV",
                         method = "Lmoments", time.units = "days")
fit_gev2=extRemes::fevd(x = day2_win$sum_changes, type = "GEV",
                         method = "Lmoments", time.units = "days")

extRemes::return.level(fit_gev1, return.period = c(50))
extRemes::return.level(fit_gev2, return.period = c(50))


s1 = s1 %>% mutate(wesd = wesd* 20.88543* 0.00980665)
s2 = s2 %>% mutate(sum_changes =sum_changes* 20.88543* 0.00980665)
s3 = s3 %>% mutate(sum_changes =sum_changes* 20.88543* 0.00980665)
fit_gev1=extRemes::fevd(x = s1$wesd, type = "GEV",
                        method = "Lmoments", time.units = "days")
fit_gev2=extRemes::fevd(x = s2$sum_changes, type = "GEV",
                        method = "Lmoments", time.units = "days")
fit_gev3=extRemes::fevd(x = s3$sum_changes, type = "GEV",
                        method = "Lmoments", time.units = "days")
fit_gev1
fit_gev2
fit_gev3

extRemes::return.level(fit_gev1, return.period = c(50))
extRemes::return.level(fit_gev2, return.period = c(50))
extRemes::return.level(fit_gev3, return.period = c(50))

d1= COMBINED_D123 %>% filter(DAY_CHANGE ==1)
d2= COMBINED_D123 %>% filter(DAY_CHANGE ==2)
d3= COMBINED_D123 %>% filter(DAY_CHANGE ==3)
cor(d1$EVENT50, d1$EVENT50_ANNUAL, use = "pairwise.complete.obs")
cor(d2$EVENT50, d2$EVENT50_ANNUAL, use = "pairwise.complete.obs")

cor(d3$EVENT50, d3$EVENT50_ANNUAL, use = "pairwise.complete.obs")

descdist(d1$EVENT50, discrete=FALSE, boot=500)
t =extRemes::fevd(x = d1$EVENT50, type = "GEV", method = "Lmoments", time.units = "days")
descdist(d2$EVENT50, discrete=FALSE, boot=500)
t =extRemes::fevd(x = d2$EVENT50, type = "GEV", method = "Lmoments", time.units = "days")
descdist(d3$EVENT50, discrete=FALSE, boot=500)
t=extRemes::fevd(x = d3$EVENT50, type = "GEV", method = "Lmoments", time.units = "days")


##################################################################################
#####################SCATTER PLOT##########################################
###########################################################################

d1= COMBINED_D123 %>% filter(DAY_CHANGE ==1)
d2= COMBINED_D123 %>% filter(DAY_CHANGE ==2)
d3= COMBINED_D123 %>% filter(DAY_CHANGE ==3)

ggplot(data =  d1, aes(x=EVENT50_ANNUAL, y= EVENT50))+
  geom_point()+
  geom_smooth(method=lm) +labs(x = "Annual 50-year Event Load", y = "Day-1 50-year Event Load")

ggplot(data =  d2, aes(x=EVENT50_ANNUAL, y= EVENT50))+
  geom_point()+
  geom_smooth(method=lm) +labs(x = "Annual 50-year Event Load", y = "Day-2 50-year Event Load")

ggplot(data =  d3, aes(x=EVENT50_ANNUAL, y= EVENT50))+
  geom_point()+
  geom_smooth(method=lm) +labs(x = "Annual 50-year Event Load", y = "Day-3 50-year Event Load")



d11 = d1%>% filter(EVENT50_ANNUAL <= 70)
cor(d11$EVENT50_ANNUAL, d11$EVENT50)


d22 = d2%>% filter(EVENT50_ANNUAL <= 70)
cor(d22$EVENT50_ANNUAL, d22$EVENT50)

d33 = d3%>% filter(EVENT50_ANNUAL <= 56)
cor(d33$EVENT50_ANNUAL, d33$EVENT50)

boxplot.stats(d1$EVENT50_ANNUAL)$out

ggplot(data =  d11, aes(x=EVENT50_ANNUAL, y= EVENT50))+
  geom_point()+
  geom_smooth(method=lm) +labs(x = "Annual 50-year Event Load", y = "Day-1 50-year Event Load")

ggplot(data =  d22, aes(x=EVENT50_ANNUAL, y= EVENT50))+
  geom_point()+
  geom_smooth(method=lm) +labs(x = "Annual 50-year Event Load", y = "Day-2 50-year Event Load")

ggplot(data =  d33, aes(x=EVENT50_ANNUAL, y= EVENT50))+
  geom_point()+
  geom_smooth(method=lm) +labs(x = "Annual 50-year Event Load", y = "Day-3 50-year Event Load")





