using Flux
using Flux: train!

#see https://fluxml.ai/Flux.jl/stable/models/overview/ to start

#create a function to generate data
actual(x) = 4x + 2

#set up train/test data
x_train, x_test = hcat(0:5...), hcat(6:10...)

y_train, y_test = actual.(x_train), actual.(x_test)

#set up basic model
model = Dense(1 => 1)
#2 params -- 1 weight and one bias

#explore default parameters
model.weight
model.bias

#and since we have default weights and biases, we can run our data through this initial model
predict = Dense(1 => 1)
predict(x_train)
#the above is the same as predict.weight * x_train .+ predict.bias

#to train the function, we need to specify a loss function
loss(x, y) = Flux.Losses.mse(predict(x), y)

#initial loss
loss(x_train, y_train)

#we also need to provide an optimizer to train
#in this case, regular gradient descent
opt = Descent()

#create a tuple with x and y
data = [(x_train, y_train)]

#create an object that holds all of our parameters
parameters = Flux.params(predict)

#and then we can run one training pass through all of this
train!(loss, parameters, data, opt)

#and we should be able to see that the loss went down and the parameters were updated
loss(x_train, y_train)
parameters

#and if we want to run multiple passes
for epoch in 1:200
    train!(loss, parameters, data, opt)
end

#these are super close to what we specified
loss(x_train, y_train)
parameters