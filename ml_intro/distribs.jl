using Distributions
using CairoMakie
using Random

CairoMakie.activate!(type="svg")

#how to set a seed
Random.seed!(0408)

N = 10000
samples = rand(Normal(), N)
samples = (samples).^2

#and if we want to fit a gamme distribution to our samples
g = fit(Gamma, samples)

#get the mean from the distribution
mean(g)

#get the pdf at the value 1
pdf(g, 1)

#or get the logpdf
logpdf(g, 1)

## and let's visualize our pdf
f(x) = pdf(g, x)

#go from 0 to 4 by .1
xs = 0:0.1:4
ys = f.(xs)
lines(xs, ys)
hist!(samples, normalization=:pdf, bins=40, alpha=.4)
current_figure()