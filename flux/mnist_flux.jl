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

#resume here -- see also p. 116ish of Deep Learning in R book