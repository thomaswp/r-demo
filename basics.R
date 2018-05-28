# Download: go.ncsu.edu/reu-r-demo


# Install needed packages ahead of time
if (!require("pacman")) install.packages("pacman")
pacman::p_load(plyr, ggplot2, reshape2)



## 1. Loading and Viewing Data ##

# Load the grades
# Tip: Press Ctrl+Enter on a line of code to execute it
grades <- read.csv("data.csv")

# Tip: Open the "grades" dataframe in the top-right "Environment" pane

# Read the column names
names(grades)
# View the first few rows
head(grades)
# View the last two rows
tail(grades, 2)

# Get a single column
grades$Grade_Final
# Plot it as a histogram
hist(grades$Grade_Final)
# Figure out what "hist()" does
?hist
# Alternately plot a density plot to get a smooth curve
plot(density(grades$Grade_Final))

# Get another column
grades$Grade_Test1
# Plot two columns in a scatter plot
plot(grades$Grade_Test1, grades$Grade_Final)
# Add a bit of jitter to make it easier to read
grades$Grade_Test1
jitter(grades$Grade_Test1, 5)
# What do you think jitter will do?
plot(jitter(grades$Grade_Test1, 5), grades$Grade_Final)
# Get the Pearson correlation between the two values
cor(grades$Grade_Test1, grades$Grade_Final)

### CHALLENGE: Using scatter plots, guess which grade has the 
###            strongest correlation with a student's final grade.
### BONUS: Use the cor() function to verify your guess. Was it right? 
###        What happens if you run "cor(grades)"?







## 2. Variables and Vectors in R ##

# Variables assignment in R uses "<-", and variables don't need to be declared
x <- 3
# A "Vector" is a sequence of data with the same type. Create one with c()
x <- c(1, 2, 3)
# We can also create a range of values with ":"
1:5
# Or using the "seq" function (notice that R uses )
seq(from = 1, to = 10, by = 2)
# R can apply operations over vectors
x * 2
# We can also easily apply functions to vectors
sum(x)
mean(x)
max(x)
# The dataframe columns that you retrieve with $ are also usually vectors
mean(grades$Grade_Final)
# You can also add and subtract vectors in a pairwise way:
c(1, 2, 3) + c(6, 4, 2)
# You can even apply comparison operators:
c(1, 2, 3) < c(6, 4, 2)
# You can also compare to a single value, and each element in the vector is compared:
c(1, 2, 3, 2, 5) == 2
# The result of a conparison is a boolean vectors
# These have their own operators, "&" (AND), "|" (OR):
x > 1
x < 3
x > 1 & x < 3
x > 1 | x < 3
# Vectors are always one-dimensional, so combining them will result in a new vector
c(x, 4)
# This is handy for specifying non-uniform ranges:
c(1:3, 8, 9, 10:12)

### CHALLENGE: What is the sum of all odd numbers between 1 and 500 inclusive?
### BONUS: Can you do it using seq() and without using seq()?







## 3. Subsetting data ##

# You can subset data with brackets
# The first index is for row-subsetting
firstFifty <- grades[1:50,] 
# Now view firstFifty in the Environment tab

# The second index is for column-subsetting
twoColumns <- grades[,c("Grade_Final", "Grade_Test1")]
head(twoColumns)
# You can also get columns by their index:
twoColumns <- grades[,1:2]
head(twoColumns)

# you can use any vector of indices to subset a dataframe:
grades[c(1, 3, 5:7),]

# negative indices give you all rows except the given values.
# omit the first 2 rows:
grades[c(-1, -2),]

# Question: How many failing students do I have? 
# This is the boring way to calculate it...
failing <- 0
for (i in 1:nrow(grades)) {
  if (grades[i, "Grade_Final"] < 60) failing <- failing + 1
}
failing

# How many failing students do I have? (the R way)
# Remember that you can apply comparisons to a vector:
grades$Grade_Final < 60
# What do the values in the resulting boolean vector represent?

# Then you can aggregate the results (TRUE = 1)
sum(grades$Grade_Final < 60)
mean(grades$Grade_Final < 60)

# Most importantly, you can subset using a boolean vector
lowFinalGrade <- grades[grades$Grade_Final < 60,]
# Plot the HW1 grades of students who failed the class
hist(lowFinalGrade$Grade_H1)

# You can also subset one column to make this quicker
# This should produce the same result as the above code:
hist(grades$Grade_H1[grades$Grade_Final < 60])

# You can also add new columns to a dataframe
grades$goodGrade <- grades$Grade_Final >= 80
grades$goodGrade
# Now view the dataframe in the Environment tab

# To quickly plot out how many students got 100 and 0 on HW1, use table():
table(grades$Grade_H1)
# It tabulates the grades, grouping students with the same grade
# It works better with integer values, so we can also round it:
table(round(grades$Grade_H1))


### CHALLENGE: What was the average final grade (Grade_Final) of students
###            who got 100% on the first homework (Grade_HW1)?
### BONUS: Can you do it in one line?

### CHALLENGE: How many students failed both HW1 and H2 (grade < 60)?
### HINT: Remember that the "&" and "|" operators apply AND and OR over boolean vectors






## 4. Plotting Data##

# wonderful library for all sorts of graphs and charts
# this could use a tutorial of its own
library(ggplot2)

# We can also make histograms with ggplot
ggplot(grades, aes(x=Grade_Test1)) + geom_histogram()
# ggplot also supports a number of charts, such as boxplots
ggplot(grades, aes(x=T, y=Grade_Test1)) + geom_boxplot()

# Things get interesting when we want to compare two groups.
# Lets compare students with good final grades using the goodGrade
# column that we created earlier:
ggplot(grades, aes(x=goodGrade, y=Grade_Test1)) + geom_boxplot()
# a violin plot is like a boxplot, but gives a distribution instead
ggplot(grades, aes(x=goodGrade, y=Grade_Test1)) + geom_violin()
# we can compose plots with the + operator
ggplot(grades, aes(x=goodGrade, y=Grade_Test1)) + geom_violin() + geom_boxplot(width=0.05)

# Question: Does posting on the Piazza forum predict a student's final grade?
# Let's try plotting the distribution of the PiazzaPostsTotal column:
ggplot(grades, aes(x=PiazzaPostTotal)) + geom_histogram()
# This plot is very right-skewed and not very informative.
# We can transform it with the log function:
grades$logPiazza <- log(grades$PiazzaPostTotal + 1) # Add 1 because log(0) isn't defined
ggplot(grades, aes(x=logPiazza)) + geom_histogram()
# Now let's compare the high- and low-performaning students' Piazza activity:
ggplot(grades, aes(x=goodGrade, y=logPiazza)) + geom_boxplot()
# Was there a difference?

### CHALLENGE: Complete the code below so that the "finalPerformance" column is either
###            "Poor" (final grade < 60), "OK" (between 60-85) or "Great" (over 85).
###            Then create a boxplot to compare the HW1 scores of the three groups.

grades$finalPerformance <- NA
grades[grades$Grade_Final < 60,]$finalPerformance <- "Poor"
grades["EDIT ME",]$finalPerformance <- "OK"
grades["EDIT ME",]$finalPerformance <- "Great"
table(grades$finalPerformance)
# Now plot students'H1W scores, split by finalPerformance




##########
# Break! #
##########





## 5. Transforming and Sampling Data (if time permits) ##

# Let's plot student homework grades over time.
# First, get subset the data to get only the homeworks:
homeworks <- grades[,c(1,3:11)]
head(homeworks)

# To draw a line chart, we need a command like this:
# ggplot(homeworks, aes(x=?, y=?)) + geom_line(), where both x and y are columns in our dataframe.
# Which columns could we use from homeworks?

# Unfortunately, we want x to be WHICH homework and y to be the GRADE
# That's not how our data looks like right now, so we'll have to reshape it.
# The reshape2 library is great for transforming data
library(reshape2)

meltedHomeworks <- melt(homeworks, id="StudentID", variable.name="homework")
# View the new meltedHomeworks dataframe in the Environment tab
head(meltedHomeworks)
# There's one row for every homework grade. This is perfect for ggplot:
ggplot(meltedHomeworks, aes(x=homework, y=value, group=StudentID)) + geom_line()


# Hmm, that is not very pretty. Maybe we should sample a smaller group of students?
# We can randomly sample some students to show:
sample(homeworks$StudentID, 10)
# Try running it a few times. You get different results:
sample(homeworks$StudentID, 10)
# Now store one sample to use
ids <- sample(homeworks$StudentID, 10)

# We can subset the sampledHomworks dataframe to get only those with a studentID in our sample
sampledHomeworks <- meltedHomeworks[meltedHomeworks$StudentID %in% ids,]
head(sampledHomeworks, 20)
# Now let's plot it again
ggplot(sampledHomeworks, aes(x=homework, y=value, group=StudentID)) + geom_line()
# And add some color to distinguish students
ggplot(sampledHomeworks, aes(x=homework, y=value, group=StudentID, color=StudentID)) + geom_line()

# Try a different sample and look again
ids <- sample(homeworks$StudentID, 10)
sampledHomeworks <- meltedHomeworks[meltedHomeworks$StudentID %in% ids,]
ggplot(sampledHomeworks, aes(x=homework, y=value, group=StudentID, color=StudentID)) + geom_line()

# It might make more sense to average the grades over homeworks
# We can do that very easily with the plry package
library(plyr)
# ddply is good at aggregating data and summarizing it. This call groups the rows in
# meltedHomeworks by their "homework" value, then calculates the mean grade for each group
meanGrades <- ddply(meltedHomeworks, "homework", summarise, meanGrade=mean(value))
meanGrades
# Now we can plot the mean grades
ggplot(meanGrades, aes(x=homework, y=meanGrade, group=1)) + geom_line()
# You may want to set the y-axis to go between 0 and 100
ggplot(meanGrades, aes(x=homework, y=meanGrade, group=1)) + geom_line() + 
  scale_y_continuous(limits=c(0, 100))

# We can even add standard error of the mean by defining a function for it...
se <- function(x) sd(x) / sqrt(length(x))
# ...and adding a new column for it at the end of the ddply call
meanGrades <- ddply(meltedHomeworks, "homework", summarise, meanGrade=mean(value), seGrade=se(value))
meanGrades
# You can plot error bars with geom_errorbar
ggplot(meanGrades, aes(x=homework, y=meanGrade, group=1)) + geom_line() +
  scale_y_continuous(limits=c(0, 100)) +
  geom_errorbar(aes(ymin=meanGrade-seGrade, ymax=meanGrade+seGrade), width=0.2)


### CHALLENGE: Use melt, ddply and ggplot to plot the average grades 
###            for the three tests as a bar chart
### HINT: Use geom_barchart() to draw a bar chart
### BONUS: Add standard error bars




## 6. Statistical testing ##

# Let's say some students got an intervention: hints on their homework assignments

# First, let's reload the dataset, in case we've accidentally modified it so far
grades <- read.csv("data.csv")
# Recreate our "good grade" column
grades$goodGrade <- grades$Grade_Final >= 80

# display counts of the different values for "hitns"
table(grades$hints)

# display a 2x2 table relating hints and good grades
table(grades$goodGrade, grades$hints)
# looks like there's a relationship

# We can investigate the difference visually.
ggplot(grades, aes(x=hints, y=Grade_Final)) + geom_boxplot()
# It's difficult to tell for sure...

# Get out two subsets
haveHints <- grades[grades$hints,]
noHints <- grades[!grades$hints,]

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

hist(grades$Grade_Final)

# To compare that to a real normal distribution, we can generate one:
# This one will have 100 samples with population mean of 0 and SD of 1
hist(rnorm(100, 0, 1))

# Try running it a few more times to see different distributions
hist(rnorm(100, 0, 1))
hist(rnorm(100, 0, 1))

# It also matters how many bins or "breaks" your histogram has
hist(rnorm(100, 0, 1), breaks = 50)
hist(rnorm(100, 0, 1), breaks = 50)

# With more samples, we can see clear bell curve shape
hist(rnorm(1000, 0, 1), breaks = 50)
hist(rnorm(10000, 0, 1), breaks = 50)
# This illustrates a key difference between a sample a population:
# It can be difficult to know a population's distribution from that of a sample

# There's also the qqnorm function to give you an idea of how normal the quartiles are
qqnorm(grades$Grade_Final)
# Compare that plot to a normal distribution
qqnorm(rnorm(100, 0, 1))

# We can also test for normality
shapiro.test(grades$Grade_Final)
# A p-value < 0.05 here means not normal, but be careful
# since this test is very sensitive to outliers

# Since our data looks non-normal, we should probably use a non-parametric test.
# These are appropriate for normal and non-normal data, but may have less power.
# The Mann-Whitney U-test is our best bet here:

# This performs the actual test
wilcox.test(haveHints$Grade_Final, noHints$Grade_Final)
# The p-value is > 0.05, so we cannot reject the null hypothesis
# Does this mean hints didn't matter?

# The normality question is important because if we had done a t-test...
t.test(haveHints$Grade_Final, noHints$Grade_Final)
# we would have gotten a significant result

# Why the different results?
# So is it partially significant?
# No! Significance is present or not at a given threshold (e.g. 0.05).

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
table(grades$goodGrade, grades$hints)

# We can also test to see if the ratio of good/bad grades is
# different in our two conditions
fisher.test(grades$goodGrade, grades$hints)

# And it is. So what does it tell us that one test was significant
# but not another? Be careful with this question.

# What would happen if we had half as much data?

# Get a subset of every other element
sample <- grades[seq(1, nrow(grades), 2),]
fisher.test(sample$goodGrade, sample$hints)
# What about every 4th?
sample <- grades[seq(1, nrow(grades), 4),]
fisher.test(sample$goodGrade, sample$hints)
# 6th?
sample <- grades[seq(1, nrow(grades), 6),]
fisher.test(sample$goodGrade, sample$hints)

# So how much data do we need to acheive significance?
# Try G*Power: http://www.gpower.hhu.de/en.html

### CHALLENGE: Test the following hypothesis:
###            Students who do well on the first homework (grade >= 80) have a higher
###            Test1 grade than those who do not it.
### BONUS: A research concludes from this test that HW1 teaches critical lessons
###        that are needed to do well on Test1. Is this conclusion supported by
###        the data?






## 7. Modeling data (if there permits) ##

# Install some additional packages
pacman::p_load(Hmisc, corrplot, DAAG)

# remove our "good grade" column, since this would be cheating
grades <- read.csv("data.csv")
# also remove out StudentID column
grades <- grades[,-1]
# create a linear model to predict final grade
model <- lm(Grade_Final ~ ., grades)
summary(model)

model <- lm(Grade_Final ~ Grade_Test1 + Grade_H1 + Grade_H2 + Grade_H3 + Grade_H4, grades)
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
corrMatrix <- rcorr(as.matrix(grades[,c(2:6, 13)]))
corrMatrix$r
corrMatrix$P

library(corrplot)
# Plot the correlation matrix
corrplot(corrMatrix$r)

library(DAAG)
# cross-validate the linear model with 3 folds
cv <- cv.lm(grades, Grade_Final ~ Grade_Test1 + Grade_H1 + Grade_H2 + Grade_H3 + Grade_H4, 3)
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

