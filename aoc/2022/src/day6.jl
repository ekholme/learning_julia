f = open("./aoc/2022/data/day6.txt")

data = readlines(f)[1]

# assign character counts to a dict
function count_chars(x::String)
    ret = Dict{Char,Int}()
    for i in eachindex(x)
        z = x[i]
        if (haskey(ret, z))
            ret[z] += 1
        else
            ret[z] = 1
        end
    end
    return ret
end

#wrap the above
function check_marker(x::String, step::Int)
    r = step:length(x)
    size = step - 1
    for i ∈ r
        ss = x[i:-1:i-size]
        tmp = count_chars(ss)
        if maximum(values(tmp)) == 1
            return i
        end
    end
    return "no marker found"
end

p1 = check_marker(data, 4)

p2 = check_marker(data, 14)