#the task here is to generate a dataset where x and y are correlated at r = .8
using Statistics
using Distributions
using CairoMakie

#specify correlation matrix
Σ = [[1.0, .8] [.8, 1]]

#specify mean vector
#this doesn't really matter for the example, though
μ = zeros(2)

#define a multivariate normal distribution parameterized by Σ and μ
d = Distributions.MvNormal(μ, Σ)

#draw a sample from this distribution
s = rand(d, 100)

#plot the sample
CairoMakie.scatter(s)

#confirm that we get the correct answer
r = cor(s')