using Flux

#see https://fluxml.ai/Flux.jl/stable/models/overview/ to start

#create a function to generate data
actual(x) = 4x + 2

#set up train/test data
x_train, x_test = hcat(0:5...), hcat(6:10...)

y_train, y_test = actual.(x_train), actual.(x_test)

