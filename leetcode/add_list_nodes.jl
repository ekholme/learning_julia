#https://leetcode.com/problems/add-two-numbers/

l1 = [2, 3, 4]
l2 = [1, 2, 4, 6]

function addLists(x::Vector{Int64}, y::Vector{Int64})
    r1 = reverse(x)
    r2 = reverse(y)

    i1 = parse(Int64, reduce(*, string.(r1)))
    i2 = parse(Int64, reduce(*, string.(r2)))

    tmp = i1 + i2

    res = digits(tmp)

    return res
end

addLists(l1, l2)
