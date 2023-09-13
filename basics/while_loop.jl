
x = [1, 2, "a", 5.0, nothing, 10]

y = []

i = 1

while !isnothing(x[i])
    println(x[i])
    global i += 1
end

#the following is equivalent
for i in eachindex(x)
    if isnothing(x[i])
        break
    end
    println(x[i])
end
#even though this isn't as succinct, i kinda like it more?