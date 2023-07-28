using DataFrames

struct MyStruct
    a::Union{String,Int64}
    b::Float64
    c::Union{String,Missing}
end

z = fieldtypes(MyStruct)

typeof(z)

#coercing to a dataframe

v1 = MyStruct("a", 1.1, "b")
v2 = MyStruct(1, 2.0, missing)
v = [v1, v2]

n_rows = 2
n_cols = 3

nms = fieldnames(MyStruct)
tps = fieldtypes(MyStruct)

k = zip(tps, 1:n_cols)

x = [Vector{j}(undef, n_rows) for j in tps]
aa = [Vector{Any}(undef, n_rows) for _ in 1:n_cols]

for i ∈ 1:n_cols
    x[i] = getproperty.(v, nms[i])
end
x

r = DataFrame(hcat(x...), collect(nms))
#hmm -- these get coerced to Any -- maybe that's the best it can do?

res = sum(r.:b)

