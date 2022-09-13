# Setup ------------------------
using Flux
using RDatasets
using DataFrames
using GLM
using Flux: train!

dfs = RDatasets.datasets()

iris = RDatasets.dataset("datasets", "iris")

#isolating variables
y = iris.:SepalLength
X = Matrix(iris[:, [:SepalWidth, :PetalLength, :PetalWidth]])

X_ones = hcat(ones(length(y)), X)
#getting the OLS solution
ols_res = lm(X_ones, y)

# Fitting a Flux Model --------------

#define the model
mod = Dense(3 => 1)

#define loss
loss(x, y) = Flux.Losses.mse(mod(x)', y)

#define optimizer
opt = Descent(.05)

#define data
data = [(X', y)]

#isolate parameters
parameters = Flux.params(mod)

#get initial loss
loss(X', y)
parameters

train!(loss, parameters, data, opt)

loss(X', y)
parameters

for epoch in 1:2000
    train!(loss, parameters, data, opt)
end
parameters

loss(X', y)
