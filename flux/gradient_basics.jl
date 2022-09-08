using Flux

#creating a basic function
f(x) = 3x^2 + 2x + 1

#take deriv of f(x)
df(x) = gradient(f, x)[1]

df(2)

#take 2nd deriv of fx
ddf(x) = gradient(df, x)[1]

ddf(2)

#if a function has many parameters, we can get the gradients of each at the same time
f(x, y) = sum((x .- y).^2);

gradient(f, [2, 1], [2, 0])

#another way to do the same
x = [2, 1]
y = [2, 0]

gs = gradient(Flux.params(x, y)) do
    f(x, y)
end

gs[x]
gs[y]

#we can set up a linear regression with gradient descent as well
#generate random W and b
W = rand(2, 5)
b = rand(2)

#specify a linear model
predict(x) = W*x .+ b

#set a loss function
function loss(x, y)
    ŷ = predict(x)
    sum((y .- ŷ).^2)
end

#generate random x and y
x, y = rand(5), rand(2)

#get initial loss
loss(x, y)

#take the gradient of the loss function -- remember this is what we want to minimze
gs = gradient(() -> loss(x, y), Flux.params(W, b))

#get our gradients
W̄ = gs[W]

#update W based on gradients
W .-= 0.1 .* W̄

loss(x, y)

#and we will want to build layers
#one way to do this is via writing functions
function linear(in, out)
    W = randn(out, in)
    b = randn(out)
    x -> W*x .+ b
end

linear1 = linear(5, 3)
linear2 = linear(3, 2)

#note that σ is exported as the sigmoid function
model(x) = linear2(σ.(linear1(x)))

model(rand(5))

#another way to do this is to create a struct that represents the affine layer
struct Affine
    W
    b
end

Affine(in::Integer, out::Integer) =
    Affine(randn(out, in), randn(out))

#then we overload the call so we can use the object as a function
(m::Affine)(x) = m.W * x .+ m.b

a = Affine(10, 5)

a(rand(10))
#the above is basically just the Dense() layer that comes with Flux, albeit without the activation function

# we can also start to chain layers together
model2 = Chain(
    Dense(10 => 5, σ),
    Dense(5 => 2),
    softmax
)

res = model2(rand(10))

#one interesting thing is that Chain() will work with any Julia function
m2 = Chain(x -> x^2, x -> x+1)

m2(5)
