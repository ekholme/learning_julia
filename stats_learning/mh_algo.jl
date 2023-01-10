using Statistics
using Distributions
using Random
using RDatasets
using CairoMakie
using StatsBase
Random.seed!(0408)

#note -- big thanks to https://www.bayesrulesbook.com/chapter-7.html#the-big-idea


iris = dataset("datasets", "iris")

#getting some demo y data to play with
y = getindex(iris.:SepalLength, iris.:Species .== "setosa")

ȳ = mean(y)

#assume the model
# Y|μ ~ N(μ, .35²)
# μ ~ N(4, 1²) -- prior for mu

μ_prior = Normal(4, 1)

pdf(μ_prior, 5)


#set parameters & do a single pass
current = 4.5
w = 1
prop_distrib = Uniform(current - w, current + w)
proposal = rand(prop_distrib, 1)[1]

proposal_plaus = pdf(μ_prior, proposal) * pdf(Normal(proposal, .35), ȳ)
current_plaus = pdf(μ_prior, current) * pdf(Normal(current, .35), ȳ)

α = minimum([1.0, proposal_plaus / current_plaus])

opts = [proposal, current]
weights = [α, 1- α]

next_stop = sample(opts, Weights(weights))

#and write a function to do a single pass

function one_mh_iter(w, current)

μ_prior = Normal(4, 1)

prop_distrib = Uniform(current - w, current + w)
proposal = rand(prop_distrib, 1)[1]

proposal_plaus = pdf(μ_prior, proposal) * pdf(Normal(proposal, .35), ȳ)
current_plaus = pdf(μ_prior, current) * pdf(Normal(current, .35), ȳ)

α = minimum([1.0, proposal_plaus / current_plaus])

opts = [proposal, current]
weights = [α, 1- α]

next_stop = sample(opts, Weights(weights))

return next_stop
end

one_mh_iter(1, 6)

#and we can now wrap this in a chain
function mh_chain(w, start, n)

res = Vector{Float64}(undef, n)

current = start

for i in eachindex(res)
    tmp = one_mh_iter(w, current)
    res[i] = tmp
    current = tmp
end

return res

end

z = mh_chain(1, 6, 10000)

#examine results
mean(z)
std(z)

#and make a plot
hist(z)