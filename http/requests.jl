#fiddling around with the open5e api
using HTTP
using JSON3
using DataFrames

monsters = "https://api.open5e.com/monsters"

cr3 = monsters * "/?challenge_rating=3"

#make request
resp = HTTP.get(cr3; require_ssl_verification = false)

println(resp.headers)

str = String(resp.body)

js = JSON3.read(resp.body)

js.results[1]

#this works, now the challenge will be getting it into a useful form

#trying to corral a few columsn into a df
l = length(js.results)
#so this is only getting the first page, unfortunately
#trying to get subset ones -- there should be 4 total
resp2 = HTTP.get(js.next; require_ssl_verification = false)
resp3 = HTTP.get(JSON3.read(resp2.body).next; require_ssl_verification = false)
resp4 = HTTP.get(JSON3.read(resp3.body).next; require_ssl_verification = false)
#ok, so there's probably some for or while loop that could be done here
#to get all of the pages in a single call

#trying to corral a few columsn into a df
#using the incomplete data for now
mons_names = Vector{String}(undef, l)
mons_types = Vector{String}(undef, l)

for i in firstindex(js.results):lastindex(js.results)
    mons_names[i] = js.results[i].name
    mons_types[i] = js.results[i].type
end

mons_tbl = DataFrame(
    name = mons_names,
    type = mons_types
)


typeof(js)
#see https://quinnj.github.io/JSON3.jl/stable/#Read-JSON-into-a-type for reading JSON data into a user-defined type
#see also https://quinnj.github.io/JSON3.jl/stable/#Generated-Types for generating types

tmp = js.results[1]

#try generating a type
a = JSON3.generate_type(tmp)
b = JSON3.generate_exprs(a)
z = JSON3.generate_struct_type_module(b, :MyModule)
#eventually want to write this out to a file via JSON3.writetypes()