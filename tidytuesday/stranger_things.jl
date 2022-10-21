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

function strip_specials(x)
    strip(x, [',', ';', '.', '?', '!'])
end

dialogue_split = @chain dialogue_complete begin
    select(
        :season,
        :episode,
        :line,
        :dialogue => ByRow(split) => :dialogue_split
    )
    flatten(:dialogue_split)
    transform(:dialogue_split => ByRow(lowercase) => :dialogue_split)
    transform(:dialogue_split => ByRow(strip_specials) => :dialogue_stripped)
end

#getting a list of stopwords
stps = stopwords(Languages.English())

#trying the stop word filter
zz = dialogue_split.:dialogue_split[1:10]

.!in.(zz, Ref(stps))

#so this works -- we need to broadcast the !
#also need to use Ref(), although I'm not sure why
dialogue_no_stops = subset(
    dialogue_split,
    :dialogue_stripped => x -> .!in.(x, Ref(stps))
    )

#summarize by word
top_100 = @chain dialogue_no_stops begin
    groupby(:dialogue_stripped)
    combine(nrow => :count)
    sort(:count, rev = true)
    first(100)
end

#and make a bar chart
nms = (:a, :b, :c)
vls = [1, 2, 3]

yy = NamedTuple{nms}(vls)

#getting there with this -- need to make it a tuple

barplot(
    1:nrow(top_100),
    reverse(top_100.count),
    direction = :x,
    #bar_labels = :y,
    #flip_labels_at = .5,
)