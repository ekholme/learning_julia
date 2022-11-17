
using Flux
using Flux: DataLoader
using Flux: onehotbatch, onecold, crossentropy, flatten
using Flux: @epochs
using Statistics
using Random
using IterTools

Random.seed!(0408)

#generate some random image data
#similar to mnist -- 28x28, 1 channel, 100 samples
xs = rand(Float32, 28, 28, 1, 100)

ys = rand(0:9, 100)

ys_onehot = onehotbatch(ys, 0:9)

#and just looking at the first image values
xs[:, :, 1, 1]

#make a dataloader
trn_data = DataLoader((xs, ys_onehot); batchsize = 100)

#looking at a demo layer
layer = Conv((5, 5), 1 => 8, relu; pad = 2, stride = 2)

size(layer(xs))
#note that this is helpful in getting the dimensions we want

#and we can extend this further with another layer
layer2 = Conv((3, 3), 8 => 16, relu; pad = 1, stride = 2)

size(layer2(layer(xs)))
#note that stride should be controlling the size of the w x h in the layer output, i think

#defining the actual model
mod = Chain(
    Conv((5, 5), 1 => 8, relu; pad = 2, stride = 2),
    Conv((3, 3), 8 => 16, relu; pad = 1, stride = 2),
    Conv((3, 3), 16 => 32, pad=1, stride=2, relu),
    Conv((3, 3), 32 => 32, pad=1, stride=2, relu),
    GlobalMeanPool(),
    flatten,
    Dense(32, 10),
    softmax
)

#getting an initial set of predictions
ŷ = mod(xs)

#and encoding these back to the int values
ŷ = onecold(ŷ)

#defining some training functions
#accuracy
acc(ŷ, y) = mean(onecold(ŷ) .== onecold(y))
#e.g. acc(ŷ, ys_onehot)

#loss func
my_loss(x, y) = Flux.Losses.crossentropy(mod(x), y)

#learning rate
lr = .1

#optimizer
opt = Descent(lr)

#parameters
ps = Flux.params(mod)

d = (xs, ys_onehot)

#and then train the model
num_epochs = 10
@epochs num_epochs Flux.train!(my_loss, ps, trn_data, opt)

#ok so this works
acc(mod(xs), ys_onehot)
#note that the accuracy is of course going to be bad because we're using just straight-up random data