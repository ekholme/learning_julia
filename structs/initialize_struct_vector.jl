#this will show how to initialize a vector of a custom composite type, i.e. a vector of structs

using Random

# define a type
mutable struct MyType
    x::String
    y::Int64
    z::Vector{Float64}
end

#create a single instance of MyType
a = MyType("Hello", 1, [1.0, 2.0, 3.0])

#create an empty n-vector where each entry is MyType
n = 10
foo = Vector{MyType}(undef, n)

#populate each entry
for i ∈ eachindex(foo)
    foo[i] = MyType(
        randstring(5),
        rand(1:100),
        rand(Float64, 3)
    )
end

#ensure that the types are correct - we don't want types to be coerced to Any
typeof(foo)

typeof(foo[1])