using CSV
using DataFrames
using Statistics
using Chain
using CairoMakie
using Splines2
using GLM

horror_movies = CSV.read(download("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv"), DataFrame)

#activate cairomakie to get it to load
CairoMakie.activate!()

#check size
size(horror_movies)

#and get first row
first(horror_movies)

#let's check out the column names
show(names(horror_movies))

#let's get the top rated horror movies
#but let's filter to movies that have at least 500 reviews
enough_reviews = subset(horror_movies, :vote_count => x -> (x .>= 500))

top_rated = @chain enough_reviews begin
    sort(:vote_average, rev = true)
    first(10)
    select(:title, :vote_average)
end

#and show everything in the repl
show(top_rated, allrows = true)

#let's check to see if there's a correlation between
#budget and revenue
cor(Matrix(select(horror_movies, :budget, :revenue)))
#ok, so a pretty decent-sized correlation here

#what about between runtime, budget, revenue, and rating
m = Matrix(select(enough_reviews, [:budget, :revenue, :runtime, :vote_average]))

cor(m)
#interesting that these are pretty small relationships
#at least for everything related to vote average

#what if we want to estimate the average rating given budget, runtime, and original language?

#first lets look at languages
unique(enough_reviews.:original_language)


function normalize(x::AbstractVector)
    u = mean(x)
    s = std(x)

    out = Float64[]

    for i in 1:lastindex(x)
        tmp = (x[i] - u) / s
        push!(out, tmp)
    end

    return out
end

X = @chain enough_reviews begin
    transform(
        :original_language => ByRow(x -> ifelse(x == "en", 1, 0)) => :is_english,
        :budget => ByRow(x -> log(2, x)) => :budget,
        :budget => normalize => :budget_norm,
        :runtime => normalize => :runtime_norm
        )
    select(
        :is_english,
        :budget_norm,
        :runtime_norm
    )
end
#this works

##shifting gears a bit -- want to play with splines

df_sp = DataFrame(
    rating = m[:, 4],
    budget_norm = X.:budget_norm
)

#scatter
scatter(df_sp[:, 1], df_sp[:, 2])

#sure let's try

#some random practice stuff
y = df_sp[:, 1]
x = df_sp[:, 2]

scatter(x, y)
#build natural spline

ns_x = ns(x, df = 4)

res = lm(ns_x, y)

preds = predict(res)

CairoMakie.scatter(x, preds)
#play around with a better dataset, probably

#note that to see the basis function, we can plot the corresponding column of the spline outcome against the input

#this is the basis for the first column
scatter(x, ns_x[:, 1])

#and for the 2nd
scatter(x, ns_x[:, 2])

#and for the 3rd
scatter(x, ns_x[:, 3])
#this will probably feel better if I use a better dataset
#but I do think I understand what's going on here generally