#an extension of my multiple regression learning, but with logistic regression

using GLM
using Distributions
using Random
using Optim
using DataFrames
using CairoMakie
using StatsFuns

Random.seed!(0408)

#get X
tmp = randn(100, 3)
𝐗 = hcat(ones(100), tmp)

#get some seed betas to create data
β = rand(Uniform(0, .5), 4)

#write a logistic function
#same as logistic.(𝐗*β)
f₁(x, b) = exp.(x*b) ./ (1 .+ exp.(x*b))

#generate y values
y = Integer.(round.(f₁(𝐗, β)))

#define function
function ml_logreg(x, y, β)

    ŷ = logistic.(x * β)

    res = Float64[]

    for i in 1:lastindex(ŷ)
        push!(res, logpdf.(Bernoulli(ŷ[i]), y[i]))
    end

    ret = -sum(res)

    #the above is the same as this:
    #ll = sum(-1 .* (log.(ŷ) .* y .+ (log.(1 .- ŷ) .* (1 .- y))))
    return ret
end

#this will return the log-likelihood for the starting values of β
test_run = ml_logreg(𝐗, y, β)

#optimize beta
res = optimize(params -> ml_logreg(𝐗, y, params), β)

#extract the best beta values
Optim.minimizer(res)

#and if we check our work
logreg_res = glm(𝐗, y, Binomial())
#huzzah