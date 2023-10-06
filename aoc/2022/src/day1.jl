f = open("./aoc/2022/data/day1.txt")

data = readlines(f)

data_int = parse.(Int64, replace.(data, r"^$" => "0"))

#get indices of blanks in vector
inds = vcat(1, findall(==(0), data_int))

#split at indices
z = getindex.(Ref(data_int), (:).(inds[1:end-1], inds[2:end]))

s = sum.(z)

maximum(s)

# Part 2
sum(sort(s)[end-2:end])