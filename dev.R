
logs <- read.csv("107.csv")

# Get the list of actions and their frequency
actions <- table(logs$message)
# Sort by frequency - how does this line work?
actions <- actions[order(actions)]
actions
# 6 most common actions
tail(actions)

# parse the timestamp
logs$timestamp <- strptime(logs$timestamp, format="%Y-%m-%d %H:%M:%S")
# and convert it to a numeric
logs$time <- as.numeric(logs$timestamp)
# then get the time since we started recording and convert to seconds
logs$delta <- (logs$time - min(logs$time)) / 1000
hist(logs$delta)

# What else could you do with this data?