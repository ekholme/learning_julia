#using https://towardsdatascience.com/deep-learning-with-julia-flux-jl-story-7544c99728ca
#as a tutorial

#see also
#https://fluxml.ai/tutorialposts/2021-02-07-convnet/
using Flux
using Flux: DataLoader
using Flux: onehotbatch, onecold, crossentropy, flatten
using Flux: @epochs
using Statistics
using MLDatasets
using CUDA
using Random

ENV["DATADEPS_ALWAYS_ACCEPT"] = true

Random.seed!(0408)

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
train_data = DataLoader((data=x_train, label=y_train), batchsize=128, shuffle=true)
test_data = DataLoader((data=x_tst, label=y_tst), batchsize=128, shuffle=true)

#specifying the model
#note that I can't run this at work bc aws is blocked, so I can't get the data
model = Chain(
    # 28x28 => 14x14
    Conv((5, 5), 1 => 8, pad=2, stride=2, relu),
    # 14x14 => 7x7
    Conv((3, 3), 8 => 16, pad=1, stride=2, relu),
    # 7x7 => 4x4
    Conv((3, 3), 16 => 32, pad=1, stride=2, relu),
    # 4x4 => 2x2
    Conv((3, 3), 32 => 32, pad=1, stride=2, relu),

    # Average pooling on each width x height feature map
    GlobalMeanPool(),
    flatten, 
    Dense(32, 10),
    softmax
) |> gpu

#getting an initial set of predictions on the test data
ŷ = onecold(model(x_train))

#checking intial accuracy -- it should be bad
mean(ŷ .== onecold(y_train))

#set loss function
my_loss(x, y) = Flux.Losses.crossentropy(model(x), y)

#learning rate
lr = .1

#optimizer
opt = Descent(lr)

#parameters
ps = Flux.params(model)


#train in gpu
nepochs = 10

for epoch in 1:nepochs
    for (xtrain_batch, ytrain_batch) in train_data
        x, y = gpu(xtrain_batch), gpu(ytrain_batch)
        gradients = gradient(() -> my_loss(x, y), ps)
        Flux.Optimise.update!(opt, ps, gradients)
    end
end

#look at accuracy now
ŷ2 = onecold(model(x_train |> gpu))

ŷ2 = cpu(ŷ2)

mean(ŷ2 .== onecold(y_train))
#boom

#and let's get the test set accuracy
y_pred = onecold(model(x_tst |> gpu))

y_pred_cpu = cpu(y_pred)

mean(y_pred_cpu .== onecold(y_tst))
#hey that's pretty good!