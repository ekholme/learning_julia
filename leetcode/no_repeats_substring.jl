# https://leetcode.com/problems/longest-substring-without-repeating-characters/

a = "abccdefgaef"
b = "bbbbb"

function len_unique_substr(x::String)
    l = 0
    s = 1
    li = 1
    for i in eachindex(x)
        z = length(x[s:i])
        if z == length(unique(x[s:i]))
            if z > l
                l = z
            end
            li = i
        else
            s = li + 1
        end
    end
    return l
end