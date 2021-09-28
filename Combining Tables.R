####################
# Combining Tables #
####################

#...........................Key points........................................

# The join functions in the dplyr package combine two tables such that matching
  # rows are together.
# left_join() only keeps rows that have information in the first table.
# right_join() only keeps rows that have information in the second table.
# inner_join() only keeps rows that have information in both tables.
# full_join() keeps all rows from both tables.
# semi_join() keeps the part of first table for which we have information in 
  # the second.
# anti_join() keeps the elements of the first table for which there is no 
  # information in the second.

#..............................................................................

# import US murders data
library(tidyverse)
library(ggrepel)
library(dslabs)

ds_theme_set()
data(murders)
head(murders)
str(murders)

# import US election results data
data(polls_us_election_2016)
head(results_us_election_2016)
str(results_us_election_2016)
identical(results_us_election_2016$state, murders$state)

# join the murders table and US election results table
tab <- left_join(murders, results_us_election_2016, by = "state")
head(tab)

# plot electoral votes versus population
tab %>% ggplot(aes(population/10^6, electoral_votes, label = abb)) +
  geom_point() +
  geom_text_repel() + 
  scale_x_continuous(trans = "log2") +
  scale_y_continuous(trans = "log2") +
  geom_smooth(method = "lm", se = FALSE)

# make two smaller tables to demonstrate joins
tab1 <- slice(murders, 1:6) %>% select(state, population)
tab1
tab2 <- slice(results_us_election_2016, c(1:3, 5, 7:8)) %>% select(state, electoral_votes)
tab2
obj<-1:6
obj
# experiment with different joins
left_join(tab1, tab2)
tab1 %>% left_join(tab2)
tab1 %>% right_join(tab2)
inner_join(tab1, tab2)
semi_join(tab1, tab2)
anti_join(tab1, tab2)
full_join(tab1, tab2)
###########
# Binding #
###########

# Unlike the join functions, the binding functions do not try to match 
# by a variable, but rather just combine datasets.

# bind_cols() binds two objects by making them columns in a tibble. 
# The R-base function cbind() binds columns but makes a data frame or matrix.
# The bind_rows() function is similar but binds rows instead of columns. 
# The R-base function rbind() binds rows but makes a data frame or matrix instead.

# For example, if we quickly want to make a data
# frame consisting of just numbers, we can use something like this.
# The function requires that we assign names to the columns.
# Here we chose A and B, but it could be anything.
bind_cols(a = 1:3, b = 4:6)
# Bind_cols can also bind data frames.
# For example, here we break up the tab data frame
# and then bind them back together.
# So we break it up into three with different columns,
# and then we simply bind them back together.
tab
tab[, 1:3]
tab1.1 <- tab[, 1:3]
tab2.1 <- tab[, 4:6]
tab3.1 <- tab[, 7:9]
head(tab)
head(tab1.1)
head(tab2.1)
head(tab2.1)
new_tab <- bind_cols(tab1.1, tab2.1, tab3.1)
head(new_tab)
new_tab_a <-cbind(tab1.1, tab2.1, tab3.1)
identical(new_tab,new_tab_a)
class(new_tab)
class(new_tab_a)
class(murders)
class(results_us_election_2016)
tab1.2 <- tab[1:2,]
tab2.2 <- tab[3:4,]
bind_rows(tab1.2, tab2.2)

a<-c(1,2,3)
b<-c(4,5,6)

df<-as.data.frame(x=n,y=a )
df
data.frame(x=b,y=a)
#################
# Set Operators #
#################

# By default, the set operators in R-base work on vectors. 
# If tidyverse/dplyr are loaded, they also work on data frames.
# You can take intersections of vectors using intersect(). 
# This returns the elements common to both sets.
# You can take the union of vectors using union(). 
# This returns the elements that are in either set.
# The set difference between a first and second argument 
# can be obtained with setdiff(). 
# Note that this function is not symmetric.
# The function set_equal() tells us if two sets are the same, 
# regardless of the order of elements.

# intersect vectors or data frames
intersect(1:10, 6:15)
intersect(c("a","b","c"), c("b","c","d"))
tab1.3 <- tab[1:5,]
tab2.3 <- tab[3:7,]
intersect(tab1.3, tab2.3)

# perform a union of vectors or data frames
union(1:10, 6:15)
union(c("a","b","c"), c("b","c","d"))
tab1.4 <- tab[1:5,]
tab2.4 <- tab[3:7,]
union(tab1.4, tab2.4)

# set difference of vectors or data frames
setdiff(1:10, 6:15)
setdiff(6:15, 1:10)
tab1.5 <- tab[1:5,]
tab2.5 <- tab[3:7,]
setdiff(tab1.5, tab2.5)

# setequal determines whether sets have the same elements, regardless of order
setequal(1:5, 1:6)
setequal(1:5, 5:1)
setequal(tab1.5, tab2.5)

