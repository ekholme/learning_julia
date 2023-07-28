# solving a regression from a covariance matrix
using Random
using GLM #to check answer
using Distributions
using Statistics

Random.seed!(0408)


#define our covariance matrix
Σ = [[1.0, 0.8, 0.7] [0.8, 1.0, 0.6] [0.7, 0.6, 1.0]]
μ = zeros(3)

D = Distributions.MvNormal(μ, Σ)

s = rand(D, 200)'


# compute cov from generated data
y = s[:, 1]
X = s[:, 2:end]

a = cov(X)
b = cov(X, y)

β = a \ b
# note that this part will be less hand-wavy when i read about gaussian elimination in my linear algebra book

#glm answer
res = lm(X, y)