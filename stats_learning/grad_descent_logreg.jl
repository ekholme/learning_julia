using RDatasets
using GLM
using Statistics
using ForwardDiff

data = RDatasets.dataset("ISLR", "Default")

y = [r.Default == "Yes" ? 1 : 0 for r in eachrow(data)]

X = Matrix(data[:, [:Balance, :Income]])

#write some util funcs
function sigmoid(x)
    return exp(x) / (1 + exp(x))
end

function binary_crossentropy(X, y, β)
    ŷ = sigmoid.(X*β)

    ŷ = clamp.(ŷ, 1e-10, 1 - 1e-10)

    return -mean(y .* log.(ŷ) .+ (1 .- y) .* log.(1 .- ŷ))
end

function z_score(x)
        u = mean(x)
    s = std(x)

    res = Float64[]
    for i in 1:lastindex(x)
        tmp = (x[i] - u) / s
        push!(res, tmp)
    end

    return res
end

#write gradient descent
function grad_desc(X, y; lr = .01, tol = .01, max_iter = 1_000, noisy = false)
    β = zeros(size(X, 2))

    err = 1e10

    iter = 0

    d(b) = ForwardDiff.gradient(params -> binary_crossentropy(X, y, params), b)

    while err > tol && iter < max_iter
        β -= lr*d(β)
        err = binary_crossentropy(X, y, β)
        if (noisy == true)
            println("Iteration $(iter): current error is $(err)")
        end
        iter += 1
    end
    return β
end

Xz = reduce(hcat, [z_score(i) for i in eachcol(X)])
Xz = hcat(ones(length(y)), Xz)

#ground truth
aa = glm(Xz, y, Binomial())

#ok so this works -- add to eeML.
#problem before is that it was just taking too long to converge and the learning rate needed to be higher
#plus it needed normalized data
zz = grad_desc(Xz, y; lr = .5, max_iter = 5_000, noisy = false)