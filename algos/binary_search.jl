#example of a binary search algorithm to get the mean of a dataset
using Distributions
using Random

Random.seed!(0408)
d = Normal(1, 2)

s = rand(d, 10000)

function bs_mean(s::Vector{Float64})
    low = 0
    high = maximum(s)
    guess = (low + high) / 2
    mn = mean(s)
    sens = .001
    counter = 1

    while abs(guess - mn) >= sens
       println(counter, "\tGuess = $guess") 
       if guess < mn
            low = guess
       else
            high = guess
       end
       counter += 1
       guess = (low + high) / 2
    end

    #display final result
    println(counter, "\tThe mean estimate is $guess")

end

bs_mean(s)