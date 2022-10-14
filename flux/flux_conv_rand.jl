
using Flux
using Flux: DataLoader
using Flux: onehotbatch, onecold, crossentropy
using Flux: @epochs
using Statistics
using Random

Random.seed!(0408)

#generate some random image data
#similar to mnist -- 28x28, 1 channel, 100 samples
xs = rand(Float32, 28, 28, 1, 100)

ys = rand(0:9, 100)

ys_onehot = onehotbatch(ys, 0:9)

#and just looking at the first image values
xs[:, :, 1, 1]

#make a dataloader
trn_data = DataLoader((data = xs, label = ys_onehot), batchsize = 32, shuffle = true)

#looking at a demo layer
layer = Conv((5, 5), 1 => 8, relu; pad = 2, stride = 2)

size(layer(xs))
#note that this is helpful in getting the dimensions we want

#and we can extend this further with another layer
layer2 = Conv((3, 3), 8 => 16, relu; pad = 1, stride = 2)

size(layer2(layer(xs)))
#note that stride should be controlling the size of the w x h in the layer output, i think

##RESUME HERE