using CSV
using DataFrames
using Statistics
using CairoMakie
using Chain
using Dates

#read data in
products = CSV.read(download("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-04/product_hunt.csv"), DataFrame, missingstring = "NA", dateformat="")

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

#parse year and month of release date

#write a function to extract specific elements
function extract_time(x, t)

    @assert t in ["year", "month"]

    seg = if t == "year"
        1:4
    else
        6:7
    end

    ret = parse(Int64, x[seg])

    return(ret)
end

#and then parse out release year and release month
products.:release_year = extract_time.(products.:release_date, "year")
products.:release_month = extract_time.(products.:release_date, "month")

show(names(products))

hist(products.:release_year)

#next -- do a line plot -- will need to aggregate data first
yr_count = @chain begin products
    groupby(:release_year)
    combine(nrow => :count)
end

yr_count

lines(yr_count.:release_year, yr_count.:count)