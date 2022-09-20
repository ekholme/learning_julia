# Setup ------------------------
using Flux
using RDatasets
using DataFrames
using GLM
using Flux: train!
using StatsBase

dfs = RDatasets.datasets()

iris = RDatasets.dataset("datasets", "iris")

#isolating variables
y = iris.:SepalLength
X = iris[:, [:SepalWidth, :PetalLength, :PetalWidth]]

Xz = Matrix(mapcols(zscore, X))
yz = zscore(y)



X_ones = hcat(ones(length(y)), Xz)
#getting the OLS solution
ols_res = lm(X_ones, yz)

# Fitting a Flux Model --------------

#define the model
mod = Dense(3 => 1)

#define loss
loss(x, y) = Flux.Losses.mse(mod(x)', y)

#define optimizer
opt = Descent(0.01)

#define data
data = [(Xz', yz)]

#isolate parameters
parameters = Flux.params(mod)

#get initial loss
loss(Xz', yz)
parameters

train!(loss, parameters, data, opt)

loss(Xz', yz)
parameters

for epoch in 1:4000
    train!(loss, parameters, data, opt)
end
parameters

loss(Xz', y)

# Another way to define the model --------------

function f₂(x)
    x * β
end

#initialize beta
β = randn(4)

#mse
function my_loss(x, y)
    ŷ = f₂(x)
    sum((ŷ .- y) .^ 2)
end

#we'll use the same optimizer as before, but let's just redfine here
opt2 = Descent(0.01)

#set parameters as the betas in our model
θ = Flux.params([β])

#set up data
data2 = [(X_ones, yz)]



#train model
train!(my_loss, θ, data2, opt2)

θ

for epoch in 1:4000
    train!(my_loss, θ, data2, opt2)
end

θ
#so this gives me NaNs, but I imagine that's due to the starting values and relatively small amount of data, although it's possible that something else is going on?