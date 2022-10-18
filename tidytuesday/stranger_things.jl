using CSV
using DataFrames
using Statistics
using CairoMakie
using Chain
using Dates
using Languages

st_things = CSV.read(download("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-18/episodes.csv"), DataFrame)

st_things_dialogue = CSV.read(download("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-18/stranger_things_all_dialogue.csv"), DataFrame)

#let's look at the size of the dialogue df
size(st_things_dialogue)

#and let's look at the first 100 rows in the dialogue
show(st_things_dialogue.:dialogue[1:100])

#we'll include just the rows that have actual dialogue
dialogue_complete = dropmissing(st_things_dialogue, :dialogue)

#and let's just get the head of this for now
dialogue_head = first(dialogue_complete, 100)

#trying out the first string
aa = dialogue_head.:dialogue[1]

#this does what i want on a single string
split(aa, " ")

#tokenize dialogue so that eacy row is a word
dialogue_split = @chain dialogue_head begin
    select(
        :season, 
        :episode,
        :line,
        :dialogue => ByRow(split) => :dialogue_split
        )
    flatten(:dialogue_split)
end
#boom

dialogue_split = @chain dialogue_complete begin
    select(
        :season,
        :episode,
        :line,
        :dialogue => ByRow(split) => :dialogue_split
    )
    flatten(:dialogue_split)
end

#getting a list of stopwords
stps = stopwords(Languages.English())

#doesn't currently work but i'm getting closer
dialogue_no_stops = subset(
    dialogue_split,
    :dialogue_split => x -> !in.(x, stps)
    )