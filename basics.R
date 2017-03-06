
# load the data
data <- read.csv("data.csv")

# read the column names
names(data)

# get a single column
data$Grade_Final
# plot it as a histogram
hist(data$Grade_Final)

# get another column
data$Grade_Test1
# plot two columns in a scatter plot
plot(data$Grade_Test1, data$Grade_Final)
# add a bit of jitter to make it easier to read
plot(jitter(data$Grade_Test1, 5), data$Grade_Final)

# you can apply element-wise operation over a vector
data$Grade_Final < 60
# then you can aggregate the results (TRUE = 1)
sum(data$Grade_Final < 60)
mean(data$Grade_Final < 60)

# you can subset data with brackets
# the first index is for row-subsetting
firstFifty <- data[1:50,]
# the second column is for column subsetting
twoColumns <- data[,c("Grade_Final", "Grade_Test1")]

# most importantly, you can subset using a boolean vector
lowFinalGrade <- data[data$Grade_Final < 60,]
# plot the HW1 grades of students who failed the class
hist(lowFinalGrade$Grade_H1)

# add new columns to a dataset
data$goodGrade <- data$Grade_Final >= 80

# the plyr library helps you summarize and aggregate data
library(plyr)

# summarize every column of our dataset
ddply(data, c(), colwise(mean))
# summarze specific columns (test grades), but split data based on the "goodGrade" column value
splitGrades <- ddply(data, "goodGrade", summarize, meanTest1=mean(Grade_Test1), meanTest2=mean(Grade_Test2), meanTest3=mean(Grade_Test3))

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
ggplot(data, aes(x=goodGrade, y=Grade_Test1)) + geom_violin() + geom_boxplot(width=0.1)

# plot our splitGrades as a bar chart
ggplot(splitGrades) + geom_bar(aes(x=goodGrade, y=meanTest1), stat="identity")



# remove our "good grade" column, since this would be cheating
data <- data[,-16]
# create a linear model to predict final grade
model <- lm(Grade_Final ~ ., data)
summary(model)

model <- lm(Grade_Final ~ Grade_Test1 + Grade_H1 + Grade_H2 + Grade_H3 + Grade_H4, data)
summary(model)
