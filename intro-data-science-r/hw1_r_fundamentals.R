#UCLA Extension
#Introduction to Data Science COM SCI X 450.1 Instructor: Daniel D. Gutierrez

#HOMEWORK 1
#YUN-CHIEH CHEN

# Question 1

x <- matrix(1:12, 3, 4, byrow = TRUE)
x
#      [,1] [,2] [,3] [,4]
# [1,]    1    2    3    4
# [2,]    5    6    7    8
# [3,]    9   10   11   12

x <- rbind(c(8,8,8,8), x)
x
#      [,1] [,2] [,3] [,4]
# [1,]    8    8    8    8
# [2,]    1    2    3    4
# [3,]    5    6    7    8
# [4,]    9   10   11   12

x <- cbind(c(9,9,9,9), x)
x
#      [,1] [,2] [,3] [,4] [,5]
# [1,]    9    8    8    8    8
# [2,]    9    1    2    3    4
# [3,]    9    5    6    7    8
# [4,]    9    9   10   11   12


# Question 2

lst <- list(
  names      = c("Ellen", "Catherine", "Stephen"),
  scores     = c(91L, 94L, 100L),
  attendance = matrix(c(TRUE, TRUE, TRUE, FALSE, FALSE, TRUE),
                      nrow = 2, ncol = 3)
)
lst
# $names
# [1] "Ellen"     "Catherine" "Stephen"
#
# $scores
# [1]  91  94 100
#
# $attendance
#      [,1]  [,2]  [,3]
# [1,] TRUE  TRUE FALSE
# [2,] TRUE FALSE  TRUE

lst$names
# [1] "Ellen"     "Catherine" "Stephen"

lst$scores[3]
# [1] 100

lst$attendance[, 2]
# [1]  TRUE FALSE


# Question 3

gender <- c(rep("male", 25), rep("female", 30))
gender
#  [1] "male"   "male"   "male"   "male"   "male"   "male"   "male"
#  [8] "male"   "male"   "male"   "male"   "male"   "male"   "male"
# [15] "male"   "male"   "male"   "male"   "male"   "male"   "male"
# [22] "male"   "male"   "male"   "male"   "female" "female" "female"
# [29] "female" "female" "female" "female" "female" "female" "female"
# [36] "female" "female" "female" "female" "female" "female" "female"
# [43] "female" "female" "female" "female" "female" "female" "female"
# [50] "female" "female" "female" "female" "female"

gender_factor <- factor(gender)
gender_factor
#  [1] male   male   male   male   male   male   male   male   male
# [10] male   male   male   male   male   male   male   male   male
# [19] male   male   male   male   male   male   male   female female
# [28] female female female female female female female female female
# [37] female female female female female female female female female
# [46] female female female female female female female female
# Levels: female male

table(gender_factor)
# gender_factor
# female   male
#     30     25


# Question 4

data(airquality)

count_na <- length(airquality$Ozone[is.na(airquality$Ozone)])
count_na
# [1] 37


# Question 5

filtered <- subset(airquality, Ozone > 31 & Temp > 90)
mean(filtered$Solar.R)
# [1] 212.8


# Question 6

airquality_1 <- airquality

airquality_1$hotcold <- ifelse(airquality_1$Temp > median(airquality_1$Temp),
                               "hot", "cold")

head(airquality_1, 12)
#    Ozone Solar.R Wind Temp Month Day hotcold
# 1     41     190  7.4   67     5   1    cold
# 2     36     118  8.0   72     5   2    cold
# 3     12     149 12.6   74     5   3    cold
# 4     18     313 11.5   62     5   4    cold
# 5     NA      NA 14.3   56     5   5    cold
# 6     28      NA 14.9   66     5   6    cold
# 7     23     299  8.6   65     5   7    cold
# 8     19      99 13.8   59     5   8    cold
# 9      8      19 20.1   61     5   9    cold
# 10    NA     194  8.6   69     5  10    cold
# 11     7      NA  6.9   74     5  11    cold
# 12    16     256  9.7   69     5  12    cold

tail(airquality_1, 12)
#     Ozone Solar.R Wind Temp Month Day hotcold
# 142    24     238 10.3   68     9  19    cold
# 143    16     201  8.0   82     9  20     hot
# 144    13     238 12.6   64     9  21    cold
# 145    23      14  9.2   71     9  22    cold
# 146    36     139 10.3   81     9  23     hot
# 147     7      49 10.3   69     9  24    cold
# 148    14      20 16.6   63     9  25    cold
# 149    30     193  6.9   70     9  26    cold
# 150    NA     145 13.2   77     9  27    cold
# 151    14     191 14.3   75     9  28    cold
# 152    18     131  8.0   76     9  29    cold
# 153    20     223 11.5   68     9  30    cold


# Question 7

total <- 0
for (i in 1:100) {
  sq <- i^2
  if (i %% 2 == 0) {
    total <- total + sq   # even
  } else {
    total <- total - sq   # odd
  }
}
total
# [1] 5050


# Question 8

mat1 <- matrix(rep(seq(4), 4), ncol = 4)
mat1
#      [,1] [,2] [,3] [,4]
# [1,]    1    1    1    1
# [2,]    2    2    2    2
# [3,]    3    3    3    3
# [4,]    4    4    4    4

result <- apply(mat1, MARGIN = 1, FUN = function(x) sum(x) + 2)
result
# [1]  6 10 14 18


# Question 9

scores <- c(95,88,92,84,76,69,91,87,93,90,78,85,82,89,96,77,94,81,83,86)

set.seed(73)

sample_index <- sample(1:length(scores), 6, replace = FALSE)

sample_scores    <- scores[sample_index]
remaining_scores <- scores[-sample_index]

sample_scores
# [1] 91 94 83 96 86 92
mean(sample_scores)
# [1] 90.33333

remaining_scores
#  [1] 95 88 84 76 69 87 93 90 78 85 82 89 77 81
mean(remaining_scores)
# [1] 83.85714


# Question 10

xct <- as.POSIXct("1969-07-20 20:18:00", tz = "UTC")
xct
# [1] "1969-07-20 20:18:00 UTC"

now <- Sys.time()

days_diff  <- as.numeric(difftime(now, xct, units = "days"))
years_diff <- days_diff / 365.25

years_diff
# [1] 57.00237