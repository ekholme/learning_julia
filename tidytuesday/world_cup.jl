using CSV
using DataFrames
using Chain
using CairoMakie

worldcups = CSV.read(download("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-29/worldcups.csv"), DataFrame)

wc_matches = CSV.read(download("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-29/wcmatches.csv"), DataFrame)

#let's start with the world cups data
size(worldcups)

show(names(worldcups))

#getting year range for world cups
minimum(worldcups.:year)
maximum(worldcups.:year)

#a better way
extrema(worldcups.:year)

#showing everything in the terminal
show(worldcups, allrows = true)

#let's count the winners
wc_winners = @chain worldcups begin
    groupby(:winner)
    combine(nrow => :count)
    sort(:count, rev = true)
end

show(wc_winners, allrows = true)

#hmm, so we can see that there are a few "West Germany" entries
#so maybe we want to clean that up

worldcups_germany = transform(
    worldcups,
    [:winner, :second, :third, :fourth] .=> ByRow(x -> ifelse(x == "West Germany", "Germany", x)) .=> [:winner, :second, :third, :fourth]
)

show(worldcups_germany, allrows = true)

#and now let's redo the wc winners stuff
wc_winners = @chain worldcups_germany begin
    groupby(:winner)
    combine(nrow => :count)
    sort(:count, rev = true)    
end

show(wc_winners, allrows = true)
#so that's better!
#only 8 different countries have won world cups

#and if we wanted to plot this?
f = Figure()
ax = Axis(
    f[1, 1],
    yticks = (
        1:8, reverse(wc_winners.:winner)
    ),
    title = "Number of World Cup Wins",
    subtitle = "Germany includes West Germany"
    )
barplot!(
    ax,
    1:nrow(wc_winners),
    reverse(wc_winners.:count),
    direction = :x
)

f

#and what if we want to get goals per game
worldcups.:goals_per_game = worldcups.:goals_scored ./ worldcups.:games

show(worldcups, allrows = true)