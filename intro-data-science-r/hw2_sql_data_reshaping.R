#UCLA Extension
#Introduction to Data Science COM SCI X 450.1 Instructor: Daniel D. Gutierrez

#HOMEWORK 2
#YUN-CHIEH CHEN

# Question 1

library(sqldf)
data(CO2)

sqldf("SELECT Type, AVG(uptake) AS avg_uptake
       FROM CO2
       GROUP BY Type;")
#          Type avg_uptake
# 1 Mississippi   20.88333
# 2      Quebec   33.54286


# Question 2

Died.At <- c(22,40,72,41) 
Writer.At <- c(16, 18, 36, 36)
First.Name <- c("John", "Edgar", "Walt", "Jane")
Second.Name <- c("Doe", "Poe", "Whitman", "Austen")
Sex <- c("MALE", "MALE", "MALE", "FEMALE")
Date.Of.Death <- c("2015-05-10", "1849-10-07", "1892-03-26", "1817-07-18")

# build data frame
df <- data.frame(Died.At, Writer.At, First.Name, Second.Name, Sex, Date.Of.Death)
df
#   Died.At Writer.At First.Name Second.Name    Sex Date.Of.Death
# 1      22        16       John         Doe   MALE    2015-05-10
# 2      40        18      Edgar         Poe   MALE    1849-10-07
# 3      72        36       Walt     Whitman   MALE    1892-03-26
# 4      41        36       Jane      Austen FEMALE    1817-07-18

# turn sex into a factor
df$Sex <- as.factor(df$Sex)
class(df$Sex)
# [1] "factor"

# 3
names(df) <- c("age_at_death", "age_as_writer", "first_name", 
               "surname", "gender", "date_died")
names(df)
# [1] "age_at_death"  "age_as_writer" "first_name"    "surname"      
# [5] "gender"        "date_died"

# 4
df$date_died <- as.Date(df$date_died)

john_death_date <- df$date_died[1]
john_age <- df$age_at_death[1]

death_year  <- as.numeric(format(john_death_date, "%Y"))
birth_year  <- death_year - john_age

month_day <- format(john_death_date, "%m-%d")

birth_date_string <- paste(birth_year, month_day, sep="-")
birth_date <- as.Date(birth_date_string)
birth_date
# [1] "1993-05-10"


# Question 3

library(reshape2)

product <- c("A", "B")
height  <- c(10,20)
width   <- c(5,10)
weight  <- c(2,NA)

observations_wide <- data.frame(product, height, width, weight)
observations_wide
#   product height width weight
# 1       A     10     5      2
# 2       B     20    10     NA

observations_long <- melt(data = observations_wide, id.vars = "product")

# remove NA
observations_long <- observations_long[!is.na(observations_long$value), ]

# order
observations_long <- observations_long[order(observations_long$product), ]
observations_long

#   product variable value
# 1       A   height    10
# 3       A    width     5
# 5       A   weight     2
# 2       B   height    20
# 4       B    width    10


# Question 4

mpg_by_cyl <- split(mtcars$mpg, mtcars$cyl)
result <- sapply(mpg_by_cyl, mean)
result
#        4        6        8 
# 26.66364 19.74286 15.10000 


# Question 5

hp_by_cyl <- split(mtcars$hp, mtcars$cyl)
hp_means <- sapply(hp_by_cyl, mean)
hp_means
#         4         6         8 
#  82.63636 122.28571 209.21429 

diff <- abs(hp_means["4"] - hp_means["8"])
diff
#        4 
# 126.5779 


# Question 6

mean(airquality$Temp[airquality$Month == 6])
# [1] 79.1


# Question 7

library(dplyr)
mtcars %>%
  group_by(am) %>%
  summarize(mean_mpg = mean(mpg)) %>%
  arrange(mean_mpg)

# # A tibble: 2 x 2
#      am mean_mpg
#   <dbl>    <dbl>
# 1     0     17.1
# 2     1     24.4


# Question 8

library(scatterplot3d)
scatterplot3d(x = mtcars$wt, 
              y = mtcars$disp, 
              z = mtcars$mpg,
              main = "MPG vs Weight and Displacement",
              xlab = "Weight (1000 lbs)",
              ylab = "Displacement (cubic inches)",
              zlab = "Miles per Gallon",
              pch = mtcars$am)


# Question 9

quebec_data <- subset(CO2, Type == "Quebec")
quebec_hist <- hist(x = quebec_data$uptake,
                    breaks = 20,
                    col = "cornflowerblue",
                    main = "Quebec",
                    xlab = "CO2 Uptake Rate",
                    ylab = "Frequency")

quebec_hist$breaks

#  [1]  8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46
quebec_hist$counts

#  [1] 1 0 1 3 1 0 1 0 1 2 0 2 3 5 3 8 5 4 2

# Question 10

boxplot(mpg ~ gear, 
        data = mtcars,
        main = "Car Milage Data",
        xlab = "Number of Forward Gears",
        ylab = "Miles Per Gallon",
        varwidth = TRUE)