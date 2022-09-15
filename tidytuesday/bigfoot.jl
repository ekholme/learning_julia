using DataFrames
using CSV
using CairoMakie

#see https://github.com/rfordatascience/tidytuesday/tree/master/data/2022/2022-09-13

bigfoot = CSV.read(download("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-09-13/bigfoot.csv"), DataFrame)

#check out the size
size(bigfoot)

#get the names
names(bigfoot)

#to actually print them all in the repl
show(names(bigfoot))

#let's look at the dates
first(bigfoot.:date, 5)

#so a decent amount of missing data here
#let's see what proportion is missing

sum(ismissing.(bigfoot.:date)) / length(bigfoot.:date)

#and let's write a function to do this for all cols
function sum_miss(x::Symbol)
    sum(ismissing.(bigfoot[:, x])) / length(bigfoot[:, x])
end

sum_miss(nms[1])

#get all column names as symbols
nms = propertynames(bigfoot)

miss_col = Float64[]

for i in nms
    tmp = sum_miss(i)
    push!(miss_col, tmp)
end

miss_df = DataFrame(
    col = String.(nms), #i could have done the above with strings, but wanted to practice with symbols
    miss_pct = miss_col
)

#and plot the above
#need to figure out how the axis stuff works
barplot(
    1:nrow(miss_df),
    miss_df.miss_pct
    #axis = (xticks = (1:nrow(miss_df), String.(nms)))
)