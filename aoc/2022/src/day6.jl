f = open("./aoc/2022/data/day6.txt")

data = readlines(f)[1]

iter = 4:length(data)

res = []
for i in iter
    y = occursin(data[i], data[i-1:-1:i-3])
    push!(res, y)
end

#check for 4 falses in a row
marker_ind = 0
for i in eachindex(res)
    if sum(res[i:i+3]) == 0
        global marker_ind = i
        break
    end
    println(i)
end

num_chars = marker_ind + 4

#part 2

iter2 = 14:length(data)

res2 = []

for i in iter2
    y = occursin(data[i], data[i:-1:i-13])
    push!(res2, y)
end

marker2 = 0
for i in eachindex(res2)
    if sum(res2[i:i+13]) == 0
        global marker2 = i
        break
    end
    println(i)
end
#this isn't working -- need to think on this more