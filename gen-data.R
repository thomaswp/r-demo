
rm(list=ls())

n <- 150
data <- data.frame(a=rnorm(n, 0, 1), b=rep(0, n), c=abs(rnorm(n, 3, 2)), d=rexp(n, 0.2), e=rep(0, n), value=rep(0, n))
data$b <- data$c + runif(n, -0.5, 0.25)
data$e <- data$a + rnorm(n, 2, 2)

data$ma <- runif(n, 2.5, 3)
data$mc <- runif(n, -2, -1.75)
data$md <- runif(n, 0.5, 1)

data$value <- data$a * data$a * data$ma + data$c * data$mc + log(data$d) * data$md

melted <- melt(data, c(), c("a", "b", "c", "d", "e", "value"))
ggplot(melted) + geom_violin(aes(y=value, x=variable))

summary(lm(value ~ a + b + c + d + e, data))

data$a2 <- data$a * data$a
data$logd <- log(data$d)

summary(lm(value ~ a2 + b + c + logd + e, data))

summary(lm(value ~ a2 + c + logd, data))

plot(data$d, data$value)

model <- lm(value ~ a2 + c + logd, data)
plot(model$model$value ~ model$fitted.values)

write.csv(data[,c("a", "b", "c", "d", "e", "value")], "model.csv")
