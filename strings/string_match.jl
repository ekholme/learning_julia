#see for inpsiration
using Random
using BenchmarkTools

Random.seed!(0408)

#function to generate some strings
function make_strings(n::Int)
    v = Vector{String}(undef, n)

    letters = "abcde"
    numbers = "12345"

    for i ∈ eachindex(v)
        x = randstring(letters, 4)
        y = randstring(numbers, 3)
        v[i] = x * y
    end
    return v
end

n = 100_000

x = make_strings(n)

ref = "aade124" #making a reference string to compare against

function compare_strings(x::String, y::String)
    s = 0
    for i ∈ eachindex(x)
        x[i] != y[i] ? break : s += 1
    end
    return s
end

function compare_strings(x::Vector{String}, y::String)
    return [compare_strings(i, y) for i in x]
end

bm = @benchmark compare_strings(x, ref)