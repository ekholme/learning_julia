#using https://towardsdatascience.com/deep-learning-with-julia-flux-jl-story-7544c99728ca
#as a tutorial

#see also
#https://fluxml.ai/tutorials/2021/02/07/convnet.html
using Flux
using Flux: DataLoader
using Flux: onehotbatch, onecold, crossentropy
using Flux: @epochs
using Statistics
using MLDatasets

ENV["DATADEPS_ALWAYS_ACCEPT"] = true


x_train, y_train = MLDatasets.MNIST(:train)[:]
x_tst, y_tst = MLDatasets.MNIST(:test)[:]

#let's grab the first sample
x1 = MNIST(:train)[1]
size(x1[1])
x1[2]

#let's just take a peek at the first value
show(x_train[1:28*28])
y_train[1]

#adding the channel layer
#this just adds a 1-dimension channel here since this is grayscale
x_train = Flux.unsqueeze(x_train, 3)
x_tst = Flux.unsqueeze(x_tst, 3)

#one-hot encoding targets
y_train = onehotbatch(y_train, 0:9)
y_tst = onehotbatch(y_tst, 0:9)

#and create a dataloader
train_data = DataLoader((data = x_train, label = y_train), batchsize = 128, shuffle = true)
test_data = DataLoader((data = x_tst, label = y_tst), batchsize = 128, shuffle = true)

#specifying the model
#note that I can't run this at work bc aws is blocked, so I can't get the data
model = Chain(
    # 28x28 => 14x14
    Conv((5, 5), 1=>8, pad=2, stride=2, relu),
    # 14x14 => 7x7
    Conv((3, 3), 8=>16, pad=1, stride=2, relu),
    # 7x7 => 4x4
    Conv((3, 3), 16=>32, pad=1, stride=2, relu),
    # 4x4 => 2x2
    Conv((3, 3), 32=>32, pad=1, stride=2, relu),
    
    # Average pooling on each width x height feature map
    GlobalMeanPool(),
    flatten,
    
    Dense(32, 10),
)