
# You have been given data from an experiment, with
# independent variables  a, b, c, d, e and dependent variable "value"
data <- read.csv("model.csv")

# Your job is to use a linear model to determine which variables influence "value"
hist(data$value)

# Here are the tools at your disposal:

# Look for correlations between your variables
cor(data$a, data$value)

# Plot relationships between your variables
plot(data$c, data$values)

# Here's a basic linear model.
# Try to build the best linear model you can.
model <- lm(value ~ a + b + c + d + e, data)

# View your model's fit with summary
# The estimate for each coefficient tells you how much weight it has in the model
# The p-value for each coefficient tells you whether the modeled relationship is significant
# The R-squared value tells you how well it fits altogether
summary(model)


# Plotting the actual value against the model's predicted (fitted) value
# shows you visually how accurate your model is and if there's sytematic bias
# in it's predictions. A perfect x-y line means a perfect fit.
plot(model$model$value ~ model$fitted.values)


# Hint: you can add columns to your dataframe if you want to use them in your model:
data$test <- data$a + data$b
model <- lm(value ~ test + c + d, data)
summary(model)
