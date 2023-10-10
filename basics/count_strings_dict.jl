#how to count entries in a string and assign counts to a dict
y = "abc124azbC"

function count_string(x::String)
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

z = count_string(y)

maximum(values(z))