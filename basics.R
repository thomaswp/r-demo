# Download: go.ncsu.edu/sigcse-r

## Data Basics ##

# install needed packages ahead of time
install.packages(c("plyr", "ggplot2", "Hmisc", "corrplot", "DAAG"))

# load the data
# Tip: Press Ctrl+Enter on a line of code to execute it
data <- read.csv("data.csv")

# Tip: Open the "data" dataframe in the top-left "Environment" pane

# read the column names
names(data)

# get a single column
data$Grade_Final
# plot it as a histogram
hist(data$Grade_Final)
# Figure out what "hist()" does
?hist
# alternately plot a density plot to get a smooth curve
plot(density(data$Grade_Final))

# get another column
data$Grade_Test1
# plot two columns in a scatter plot
plot(data$Grade_Test1, data$Grade_Final)
# add a bit of jitter to make it easier to read
data$Grade_Test1
jitter(data$Grade_Test1, 5)
# What do you think jitter will do?
plot(jitter(data$Grade_Test1, 5), data$Grade_Final)
# Get the Pearson correlation between the two values
cor(data$Grade_Test1, data$Grade_Final)

# you can subset data with brackets
# the first index is for row-subsetting
firstFifty <- data[1:50,]
# the second column is for column subsetting
twoColumns <- data[,c("Grade_Final", "Grade_Test1")]

# How many failing students do I have? (the boring way...)
failing <- 0
for (i in 1:nrow(data)) {
  if (data[i, "Grade_Final"] < 60) failing <- failing + 1
}
failing

# How many failing students do I have? (the R way)
# you can apply element-wise operation over a vector
data$Grade_Final < 60
# then you can aggregate the results (TRUE = 1)
sum(data$Grade_Final < 60)
mean(data$Grade_Final < 60)

# most importantly, you can subset using a boolean vector
lowFinalGrade <- data[data$Grade_Final < 60,]
# plot the HW1 grades of students who failed the class
hist(lowFinalGrade$Grade_H1)

# add new columns to a dataset
data$goodGrade <- data$Grade_Final >= 80

## Summary and Aggregation ##

# the plyr library helps you summarize and aggregate data
library(plyr)

?ddply
# summarize every column of our dataset
ddply(data, c(), colwise(mean))
# summarze specific columns (test grades), but split data based on the "goodGrade" column value
splitGrades <- ddply(data, "goodGrade", summarize, 
                     meanTest1=mean(Grade_Test1), 
                     meanTest2=mean(Grade_Test2), 
                     meanTest3=mean(Grade_Test3))

## Plotting Data ##

# wonderful library for all sorts of graphs and charts
# this could use a tutorial of its own
library(ggplot2)

# we can also make ggplot histograms
ggplot(data, aes(x=PiazzaPostTotal)) + geom_histogram()
# sometimes you want to transfom your data first
data$logPiazza <- log(data$PiazzaPostTotal)
ggplot(data, aes(x=logPiazza)) + geom_histogram()
# ggplot also supports a number of charts, such as boxplots
ggplot(data, aes(x=T, y=logPiazza)) + geom_boxplot()
# this allows us to compare boxplots across a variable
ggplot(data, aes(x=goodGrade, y=logPiazza)) + geom_boxplot()

# since there's no real difference, we can use test score instead
ggplot(data, aes(x=goodGrade, y=Grade_Test1)) + geom_boxplot()
# a violin plot is like a boxplot, but gives a distribution instead
ggplot(data, aes(x=goodGrade, y=Grade_Test1)) + geom_violin()
# we can compose plots with the + operator
ggplot(data, aes(x=goodGrade, y=Grade_Test1)) + geom_violin() + geom_boxplot(width=0.05)

# plot our splitGrades as a bar chart
ggplot(splitGrades) + geom_bar(aes(x=goodGrade, y=meanTest1), stat="identity")

## Statistical testing ##

# Let's some students got an intervention: hints on their homework assignments

# display counts of the different values for "hitns"
table(data$hints)

# display a 2x2 table relating hints and good grades
table(data$goodGrade, data$hints)
# looks like there's a relationship

# We can investigate the difference visually.
ggplot(data, aes(x=hints, y=Grade_Final)) + geom_boxplot()

# Get out two subsets
haveHints <- data[data$hints,]
noHints <- data[!data$hints,]

# One has a higher average grade - so is it better?
mean(haveHints$Grade_Final)
mean(noHints$Grade_Final)

# Median tells a different story
median(haveHints$Grade_Final)
median(noHints$Grade_Final)
# Remember the boxplots


# But to really know, we need to do a stistical test.

# Here's a t-test, which most people will use
# It tests the null hypothesis: the means of the two populations are the same
t.test(haveHints$Grade_Final, noHints$Grade_Final)

# To see what test is most appropriate for your data,
# you can use this chart: stats-test-chart.jpg

# One important question is whether our response data is normally distributed.
# You can investigate that a few ways, but the simplest is a histogram.

hist(data$Grade_Final)

# To compare that to a real normal distribution, we can generate one:
# This one will have 100 samples with population mean of 0 and SD of 1
hist(rnorm(100, 0, 1))

# There's also the qqnorm function to give you an idea of how normal the quartiles are
qqnorm(data$Grade_Final)
# Compare that plot to a normal distribution
qqnorm(rnorm(100, 0, 1))

# We can also test for normality
shapiro.test(data$Grade_Final)
# A p-value < 0.05 here means not normal, but be careful
# since this test is very sensitive to outliers


# Since out data looks non-normal, we should probably use a non-parametric test.
# These are appropriate for normal and non-normal data, but may have less power.
# The Mann-Whitney U-test is our best bet here:

# This performs the actual test
wilcox.test(haveHints$Grade_Final, noHints$Grade_Final)
# The p-value is > 0.05, so we cannot reject the null hypothesis
# Does this mean hints didn't matter?

# The normality question is important because if we had done a t-test...
t.test(haveHints$Grade_Final, noHints$Grade_Final)
# we would have gotten a significant result

# So why the different results?

# Hope is not lost, though! Maybe hints affected the assignments themselves
wilcox.test(haveHints$Grade_H1, noHints$Grade_H1)
wilcox.test(haveHints$Grade_H2, noHints$Grade_H2)
wilcox.test(haveHints$Grade_H3, noHints$Grade_H3)
wilcox.test(haveHints$Grade_Test1, noHints$Grade_Test1)
wilcox.test(haveHints$Grade_Test2, noHints$Grade_Test2)
# We found some! But be careful with too many tests...
# https://xkcd.com/882/

# Still, there are other ways of looking at the question:
# Remember out table:
table(data$goodGrade, data$hints)

# We can also test to see if the ratio of good/bad grades is
# different in our two conditions
fisher.test(data$goodGrade, data$hints)

# And it is. So what does it tell us that one test was significant
# but not another? Be careful with this question.

# What would happen if we had half as much data?

# Get a subset of every other element
sample <- data[seq(1, nrow(data), 2),]
fisher.test(sample$goodGrade, sample$hints)
# What about every 4th?
sample <- data[seq(1, nrow(data), 4),]
fisher.test(sample$goodGrade, sample$hints)
# 6th?
sample <- data[seq(1, nrow(data), 6),]
fisher.test(sample$goodGrade, sample$hints)

# So how much data do we need to acheive significance?
# Try G*Power: http://www.gpower.hhu.de/en.html


## Modeling data ##

# remove our "good grade" column, since this would be cheating
data <- read.csv("data.csv")
# create a linear model to predict final grade
model <- lm(Grade_Final ~ ., data)
summary(model)

model <- lm(Grade_Final ~ Grade_Test1 + Grade_H1 + Grade_H2 + Grade_H3 + Grade_H4, data)
summary(model)

# Not every relationship is linear, so be careful with a linear model

# x is an exponential distribution
# This is a common distribution to see for time data
x <- rexp(100, 6)
hist(x)
# y is related to the log of x (plus some noise)
y <- log(x) + runif(100, 0, 1)
hist(y)
# This is not a linear relationsip!
plot(x, y)
cor(x, y)
# One model is better than the other
summary(lm(y ~ x))
summary(lm(y ~ log(x)))

library(Hmisc)
# Create a correlation matrix of the data, selecting only the 
# columns that we used in our model (1 through 5 and 12)
corrMatrix <- rcorr(as.matrix(data[,c(1:5, 12)]))
corrMatrix$r
corrMatrix$P

library(corrplot)
# Plot the correlation matrix
corrplot(corrMatrix$r)

library(DAAG)
# cross-validate the linear model with 3 folds
cv <- cv.lm(data, Grade_Final ~ Grade_Test1 + Grade_H1 + Grade_H2 + Grade_H3 + Grade_H4, 3)
# plot the same chart using R
plot(cv$cvpred, cv$Grade_Final)
# get a histogram of the error of the model
hist(cv$Grade_Final - cv$cvpred)
# get a histogram of the absolute error
hist(abs(cv$Grade_Final - cv$cvpred))
# mean absolute error
mean(abs(cv$Grade_Final - cv$cvpred))
# Root Mean-Squared Error (RMSE)
sqrt(mean((cv$Grade_Final - cv$cvpred)^2))
# RMSE for the non-cross-validated model
sqrt(mean((cv$Grade_Final - cv$Predicted)^2))

