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
opt = Descent(.01)

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

for epoch in 1:3000
    train!(loss, parameters, data, opt)
end
parameters

loss(X', y)

# Another way to define the model --------------

function f₂(x)
    x*β
end

#initialize beta
β = [.1, .1, .1, .1]

#mse
function my_loss(x, y)
    ŷ = f₂(x)
    sum((ŷ .- y).^2)
end

#we'll use the same optimizer as before, but let's just redfine here
opt2 = Descent(.01)

#set parameters as the betas in our model
θ = Flux.params([β])

#set up data
data2 = [(X_ones, y)]



#train model
train!(my_loss, θ, data2, opt2)

θ

for epoch in 1:3000
    train!(my_loss, θ, data2, opt2)
end

θ
#so this works, but see here for some explanation why I'm getting NaN parameter values
#https://discourse.julialang.org/t/how-come-flux-jls-network-parameters-go-to-nan/16439/3