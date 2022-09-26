using GLM
using Distributions
using Random
using Optim
using DataFrames
using StatsBase
using RDatasets

Random.seed!(0408)

data = RDatasets.dataset("ISLR", "Default")

y = [r.Default == "Yes" ? 1 : 0 for r in eachrow(data)]

X = data[:, [:Balance, :Income]]

Xz = hcat(ones(length(y)), Matrix(mapcols(zscore, X)))

my_logistic(x) = exp(x) / (1 + exp(x))

function ml_logreg(x, y, b)

    ŷ = my_logistic.(x*b)
    res = Float64[]

    for i in 1:lastindex(y)
        push!(res, logpdf(Bernoulli(ŷ[i]), y[i]))
    end

    ret = -sum(res)

    return ret
end

start_vals = [.1, .1, .1]

tst = ml_logreg(Xz, y, start_vals)

#get true values
true_res = glm(Xz, y, Binomial())

#estimate betas
ests = optimize(b -> ml_logreg(Xz, y, b), start_vals)

Optim.minimizer(ests)
#so this works -- now just need to update blog writing
