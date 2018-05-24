library(Hmisc)
library(DAAG)
library(DMwR)
library(boot)

set.seed(1)

comfun = function(data, desiredCols){
  completeVec = complete.cases(data[, desiredCols])
  return(data[completeVec, ])
}
gr_dr = comfun(grad_data, "Graduation Rate '08")
#View(gr_dr)

dat = data.frame(gr_dr)
imp<-apply(dat, 2, mean, na.rm=TRUE)
def<-dat

for(i in 1:ncol(dat))
{def[is.na(def[,i]),i]<-imp[i]
}

mfit = lm(Graduation.Rate..08 ~.,data = def)
#summary(mfit)

def$predicted = predict(mfit)
def$residuals = residuals(mfit)

ggplot(def, aes(x = CMT.2007.08.3rd.Grade.Math....At.Above.Proficient.Level, y = Graduation.Rate..08)) +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +  # Plot regression slope
  geom_segment(aes(xend = CMT.2007.08.3rd.Grade.Math....At.Above.Proficient.Level, yend = predicted), alpha = .2) +  
  # > Color adjustments made here...
  geom_point(aes(color = (residuals))) + # Color mapped to abs(residuals)
  scale_color_gradient2(low = "blue", mid = "white", high = "red") +  
  guides(color = FALSE) + 
  geom_point(aes(y = predicted), shape = 1) +
  theme_bw()

