using CSV
using DataFrames
using Statistics
using CairoMakie
using Chain

#read data in
products = CSV.read(download("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-04/product_hunt.csv"), DataFrame, missingstring = "NA")

#check out names of dataframe
show(names(products))

#ok, so let's look at the range of the product rankings
sort(unique(products.:product_ranking))

#and let's look at the missingness
sum(ismissing.(products[:, :product_ranking])) / length(products[:, :product_ranking])
#yikes, lots of missing here

#but let's make a histogram of the rankings
prods = collect(skipmissing(products.:product_ranking))
hist(prods)
#ok, so a pretty even distribution

#RESUME HERE