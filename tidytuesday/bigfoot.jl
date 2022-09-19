using DataFrames
using CSV
using CairoMakie
using Chain

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

#and let's do a little describe of each column
describe(bigfoot)

#so a decent amount of missing data here
#let's see what proportion is missing

sum(ismissing.(bigfoot.:date)) / length(bigfoot.:date)

#and let's write a function to do this for all cols
function sum_miss(x::Symbol)
    sum(ismissing.(bigfoot[:, x])) / length(bigfoot[:, x])
end

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
barplot(
    1:nrow(miss_df),
    miss_df.miss_pct,
    axis = (
        yticks = (1:28, String.(nms)),
        title = "Missing Plot"
        ),
    direction = :x,
    bar_labels = :y,
    flip_labels_at = .5,
)

#what states are bigfoot sightings most common in?
state_counts = sort!(combine(groupby(bigfoot, [:state]), nrow => :count), [:count], rev = true)

#another way using chain
state_counts2 = @chain bigfoot begin
    groupby(:state)
    combine(nrow => :count)
    sort(:count, rev = true)
end

#resume by plotting here
