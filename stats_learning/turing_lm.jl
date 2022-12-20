using Turing
using Random
using Distributions
using LinearAlgebra
using DataFrames
using Plots
using StatsPlots

Random.seed!(0408)

#generate some data
n = 1000

𝐗 = randn(n, 3)

β = [1., 2., 3.]

f(x) = .5 .+ x*β

ϵ = rand(Normal(0, .2), n)

y = f(𝐗) + ϵ


#define model
@model function linear_regression(x, y)
    #housekeeping
    n_feat = size(x, 2)
    
    #priors
    α ~ Normal(0, 2)
    σ ~ Exponential(1)
    b ~ MvNormal(zeros(n_feat), 5 * I)

    #likelihood
    for i ∈ eachindex(y)
        y[i] ~ Normal(α + x[i,:]' * b, σ)
    end
end

#instantiate model
model = linear_regression(𝐗, y)

#sample
chn = sample(model, NUTS(), MCMCThreads(), 1_000, 2)

#plot posterior distributions
plot(chn)

#explore output
df_x = DataFrame(chn)

#sample from the posterior/make predictions
#see https://github.com/TuringLang/TuringTutorials/issues/332

pred_mod = linear_regression(
    𝐗, 
    Vector{Union{Missing, Float64}}(undef, length(y))
)

preds = predict(pred_mod, chn);

#to get summary statistics
summarize(preds)

#to get the chain for the first y value
y_1 = getindex(preds, "y[1]")

#and to access the predicted values
#this will have fitted values from both chains
y_1.data

#to get the avg predicted value
mean(y_1.data)

#and to plot the distribution of fitted values
density(y_1.data)

#and to get the mean predicted values for each data point
#note that 2 happens to be the col # in the resulting df
#that has the mean value
mean_preds = summarize(preds)[:, 2]