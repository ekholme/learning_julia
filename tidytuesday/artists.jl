using DataFrames
using CSV
using CairoMakie
using Chain

#added the missingstring option to parse NA as missing
artists = CSV.read(download("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-09-27/artists.csv"), DataFrame, missingstring = "NA")

#data is from ACS between 2015-2019

#get the size of the data
size(artists)

#let's take a look at the unique values in race
unique(artists.:race)
#so this is only by race, there's not an "all" category, although I guess we could add one

#what are the unique professions we're looking at
show(unique(artists.:type))

#let's just look at white race -- what's the lowest share in each state?
res = @chain artists begin
    dropmissing
    subset(:race => ByRow(race -> race == "White"))
    groupby(:state)
    combine(a -> first(groupby(a, :artists_share, sort=true)))
end

#and this will get the highest share
res2 = @chain artists begin
    dropmissing
    subset(:race => ByRow(race -> race == "White"))
    groupby(:state)
    combine(a -> last(groupby(a, :artists_share, sort=true)))
end
#interesting that it's designers everywhere but DC

#next -- make a map!

# Extra ------
#note -- don't need to do this anymore, since I read the data in correctly, but going to keep this here as reference

#not the most elegant way to do it, but w/e
artists.artists_share = replace(artists.artists_share, "NA" => missing)
artists.location_quotient = replace(artists.location_quotient, "NA" => missing)
