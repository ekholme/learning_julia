using CSV
using DataFrames
using Statistics
using CairoMakie

#see https://github.com/rfordatascience/tidytuesday/tree/master/data/2022/2022-11-22

museums = CSV.read(download("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-22/museums.csv"), DataFrame)

size(museums)

first(museums)

show(names(museums))

#get the range of years opened
m1 = minimum(museums.:Year_opened)
m2 = maximum(museums.:Year_opened)

string(m1, " through ", m2)

#the move here is probably to make a map?
#see https://github.com/JuliaGeo/Leaflet.jl