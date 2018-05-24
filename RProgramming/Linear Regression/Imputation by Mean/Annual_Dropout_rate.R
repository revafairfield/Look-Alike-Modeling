library(Hmisc)
library(DAAG)
library(DMwR)
library(boot)
library(scatterplot3d)
library(ggplot2)

comfun = function(data, desiredCols){
  completeVec = complete.cases(data[, desiredCols])
  return(data[completeVec, ])
}
An_dr = comfun(Annual_dropout_rate, "Annual Dropout Rate '08")
View(An_dr)

dat = data.frame(An_dr)
imp<-apply(dat, 2, mean, na.rm=TRUE)
df<-dat

for(i in 1:ncol(dat))
{df[is.na(df[,i]),i]<-imp[i]
}
View(df)

res = lm(Annual.Dropout.Rate..08~.,data = df)
summary(res)


df$predicted = predict(res)
df$residuals = residuals(res)

ggplot(df, aes(x = CMT.2007.08.3rd.Grade.Math....At.Above.Proficient.Level, y = Annual.Dropout.Rate..08)) +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +  # Plot regression slope
  geom_segment(aes(xend = CMT.2007.08.3rd.Grade.Math....At.Above.Proficient.Level, yend = predicted), alpha = .2) +  
  # > Color adjustments made here...
  geom_point(aes(color = (residuals))) + # Color mapped to abs(residuals)
  scale_color_gradient2(low = "blue", mid = "white", high = "red") +  
  guides(color = FALSE) + 
  geom_point(aes(y = predicted), shape = 1) +
  theme_bw()