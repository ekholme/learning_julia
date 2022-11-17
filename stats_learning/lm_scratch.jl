#estimating a linear model by hand
using Statistics
using Random
using Distributions
using GLM
using LinearAlgebra #for diag()

Random.seed!(0408)

#design matrix
X = hcat(ones(100), randn(100, 3))

#error
ϵ = rand(Normal(0, .1), size(X)[1])

#ground truth betas
β = [0, .5, 1, 2]

#ground truth func
f₁(x) = x*β

#estimate y
y = f₁(X) .+ ϵ

#solve
β̂ = (X'*X)^-1*X'*y

#beta hat is pretty close to beta
#but we can check that we get the same value as we would from lm()
lm_res = lm(X, y)


#and if we want to estimate the std errors
mse = sum((y .- X*β̂).^2) / length(y)

err_b = sqrt.(diag(mse .* (X' * X)^-1))
#see https://stats.stackexchange.com/questions/44838/how-are-the-standard-errors-of-coefficients-calculated-in-a-regression/44841#44841

#and if we look at the following, they're not *exactly* the same
#but are the same down to the 10k_th decimal, which is fine
lm_res
err_b