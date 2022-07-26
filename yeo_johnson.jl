#some practice writing a YeoJohnson transformation
#see here https://en.wikipedia.org/wiki/Power_transform#Yeo%E2%80%93Johnson_transformation
#and here https://github.com/tk3369/YeoJohnsonTrans.jl

using Statistics
using Distributions
using Optim
using CairoMakie

a = collect(1:10)
b = collect(11:20)

#transform data given a vector x and λ
function YJTransform(x, λ)
    y = similar(x, Float64)
    for (i, v) in enumerate(x)
        if v >= 0
            y[i] = λ ≈ 0 ? log(v + 1) : ((v + 1)^λ - 1) / λ
        else
            y[i] = λ ≈ 2 ? -log(-v + 1) : -((-v + 1)^(2-λ)-1) / (2-λ)
        end
    end
    y
end


#calculate the log likelihood of the distribution/parameters given a vector x
function log_ll(x, λ)
    𝐱 = YJTransform(x, λ)

    μ = mean(skipmissing(𝐱))
    σ = std(skipmissing(𝐱), corrected = false)

    d = Distributions.Normal(μ, σ)

    res = -loglikelihood(d, 𝐱)
    #the above is the same is -sum(logpdf.(d, x))
    return res
end

#estimate lambda for a given vector x
function lambda(x; interval=(-2.0, 2.0))
    i1, i2 = interval
    #see here for more on optimizing
    #https://julianlsolvers.github.io/Optim.jl/stable/#user/minimization/#minimizing-a-univariate-function-on-a-bounded-interval
    res = optimize(λ -> log_ll(x, λ), i1, i2)
    Optim.minimizer(res)
end

#transform a vector just given lambda
function YJTransform(x)
    λ = lambda(x)

    YJTransform(x, λ)
end

#and let's test this out now
s = rand(LogNormal(), 1000)
tt = log.(s)

aa = YJTransform(s)

#so this isn't right
hist(aa)
hist(s)

#and let's see what value of lambda this gets us
lam = lambda(s)

#let's try with a normal distribution -- this should give us a lambda of 1
s_n = rand(Normal(), 10000)
mean(s_n)
std(s_n)

lam_sn = lambda(s_n)
#ok that's about right

#and then we can convert this
s_n′ = YJTransform(s_n)


