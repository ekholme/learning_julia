#how to count entries in a string and assign counts to a dict
y = "abc124azbC"

function count_string(x::String)
    ret = Dict{String,Int}()
    for i in eachindex(x)
        z = string(x[i])
        if (haskey(ret, z))
            ret[z] += 1
        else
            ret[z] = 1
        end
        ret[z] = 1
    end
    return ret
end

z = count_string(y)

x = Dict{String,Int}()

x["a"] = 1

x["a"] += 1