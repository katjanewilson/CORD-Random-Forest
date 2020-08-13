
coronavirus_data <- data_new
coronavirus_data$State3 <- as.factor(coronavirus_data$State3)
table(coronavirus_data$State3)
# coronavirus_data$outcome <- coronavirus_data$State3
# coronavirus_data <- coronavirus_data%>% mutate(
#   outcome = recode(State3,
#                    `deceased` = 1,
#                    `isolated` = 3,
#                    `released` = 2)) %>%
#   arrange(State3)
# table(coronavirus_data$State3)
# coronavirus_data[[2119,11]] <- 2
# 
# coronavirus_data[[2118,11]] <- 2
coronavirus_data$outcome <- as.factor(coronavirus_data$State3)
save(coronavirus_data, file = "coronavirus_data.Rdata")

table(coronavirus_data$outcome)
# Random Forest
library(randomForest)
set.seed(222)
coronavirus_data$outcome <- as.factor(coronavirus_data$outcome)
coronavirus_data$Sex <- as.factor(coronavirus_data$Sex)
coronavirus_data$Province <- as.factor(coronavirus_data$Province)
coronavirus_data$Source <- as.factor(coronavirus_data$Source)
coronavirus_data$Age   <- as.factor(coronavirus_data$Age)
write.csv(coronavirus_data, file = 'coronavirus_data.csv')
rf <- randomForest(outcome~Sex + Age + Province + Source +
                     Order, data=coronavirus_data,
                   importance = TRUE,
                   sampsize = c(21,12,26))
print(rf)

###variable importance plots
par(mfrow = c(2,2))

varImpPlot(rf, class = 1, type = 1, scale = FALSE, 
           main = "Fig 1.1: Forecasting Importance Plot for Deceased")
varImpPlot(rf, type = 1, scale = FALSE, 
           main = "Fig 1.2: Forecasting Importance Plot Averaged for All")
varImpPlot(rf, class = 2, type = 1, scale = FALSE, 
           main = "Fig 1.3: Forecasting Importance Plot for Released")
varImpPlot(rf, class = 3, type = 1, scale = FALSE, 
           main = "Fig 1.4: Forecasting Importance Plot for Isolated")

####Partial plots
part1<- partialPlot(rf, pred.data = coronavirus_data, x.var = "Age",
                    rug = T, which.class = 1)
part2<- partialPlot(rf, pred.data = coronavirus_data, x.var = "Age",
                    rug = T, which.class = 2)
part3<- partialPlot(rf, pred.data = coronavirus_data, x.var = "Age",
                    rug = T, which.class = 3)
par(mfrow = c(2,2))

#tranform the logs back to probablity
scatter.smooth(part1$x, part1$y, xlab = "Age",
               ylab = "Centered Log Odds of Death", main = "Fig 2.1: Partial Dependence Plot for Death on Age")
##how the other plots change based on outcome
scatter.smooth(part2$x, part2$y, xlab = "Age",
               ylab = "Centered Log Odds of Released", main = "Fig 2.2: Partial Dependence Plot for Released on Age")
scatter.smooth(part3$x, part3$y, xlab = "Age",
               ylab = "Centered Log Odds of Isolated", main = "Fig 2.3: Partial Dependence Plot for Isolated on Age")

par(mfrow = c(2,2))
part2 <- partialPlot(rf, pred.data = coronavirus_data,
                     x.var = Sex, reg = T, prob = T,which.class = 1 ,
                     main = "Fig 3.1: Partial Dependence Plot for Death on Sex",
                     xlab = "Sex", ylab = "Centered Log Odds of Death")
part2
part2 <- partialPlot(rf, pred.data = coronavirus_data,
                     x.var = Order, reg = T, prob = T,which.class = 1 ,
                     main = "Fig 3.2: Partial Dependence Plot for Death on Order",
                     xlab = "Order", ylab = "Centered Log Odds of Death")
part2
part2 <- partialPlot(rf, pred.data = coronavirus_data,
                     x.var = Province, reg = T, prob = T,which.class = 1 ,
                     main = "Fig 3.3: Partial Dependence Plot for Death on Province",
                     xlab = "Province", ylab = "Centered Log Odds of Death")
part2
part2 <- partialPlot(rf, pred.data = coronavirus_data,
                     x.var = Source, reg = T, prob = T,which.class = 1 ,
                     main = "Fig 3.4: Partial Dependence Plot for Death on Source",
                     xlab = "Source", ylab = "Centered Log Odds of Death")
part2
table(coronavirus_data$Source, coronavirus_data$State3)

par(mfrow = c(2,2))
m1<- randomForest::margin(rf)
m1
hist(m1, breaks = 30, main = "Fig 4.1: Histogram of Votes over Trees", xlab = "Margin")
m2 <- subset(m1, names(m1) == 1)
m2
hist(m2, breaks = 30, main = "Fig 4.2: Margin for Death classification", xlab = "Votes for Deceased")
m2
m3 <- subset(m1, names(m1) == 2)
hist(m3,breaks = 30, main = "Fig 4.3: Margin for Released classification", xlab = "Votes for Released")
m3 <- subset(m1, names(m1) == 3)
hist(m3, breaks = 30, main = "Fig 4.4: Margin for Isolated classification", xlab = "Votes for Isolated")
