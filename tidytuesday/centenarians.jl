using CSV
using DataFrames
using CairoMakie
using Chain

centenarians = CSV.read(download("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-05-30/centenarians.csv"), DataFrame)

#describe data
size(centenarians)

#show column names
show(names(centenarians))

#get data types for each column
tps = collect(zip(names(centenarians), eltype.(eachcol(centenarians))))

#check missingness for each column
mapcols(x -> sum(ismissing, x) / length(x), centenarians)

#basic descriptives
#more helpful for numeric variables
show(describe(centenarians), allrows = true)

#counting who's still alive
@chain centenarians begin
    groupby(:still_alive)
    combine(nrow => :count)
end
#ok so most aren't still alive

#let's practice recoding still_alive as boolean
centenarians.:still_alive_bool = centenarians.:still_alive .== "alive"

#another way to do the above
centenarians = transform(centenarians, :still_alive => ByRow(x -> x == "alive") => :alive_bool)

all(centenarians.:still_alive_bool .== centenarians.:alive_bool)

first(centenarians, 3)

#let's make histograms of age by gender
f = Figure()

genders = ["male", "female"]
clrs = ["#074240", "#96f983"]

iter = collect(zip(genders, clrs))

ax = [Axis(f[i, 1]) for i in eachindex(genders)]

#plotting
for i in eachindex(iter)
    g = iter[i][1]
    clr = iter[i][2]
    tmp = subset(centenarians, :gender => x -> x .== g)

    data = tmp.:age
    ax[i].title = g

    xlims!(ax[i], 110, 125)

    hist!(
        ax[i],
        data,
        color = clr
    )
end

f

#let's count countries with the most people
top_countries = @chain centenarians begin
    groupby(:place_of_death_or_residence)
    combine(nrow => :count)
    sort(:count, rev = true)
    first(5)
end

barplot(
    eachindex(top_countries.:place_of_death_or_residence),
    top_countries.:count,
    axis = (
        yticks = (eachindex(top_countries.:place_of_death_or_residence),top_countries.:place_of_death_or_residence),
        title= "# of Top 200 Lifespan People by Country"
    ),
    direction = :x,
    bar_labels = :y,
    flip_labels_at = 10
)
#good enough, although the whole thing kinda needs to be flipped