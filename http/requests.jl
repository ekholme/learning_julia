#fiddling around with the open5e api
using HTTP
using JSON

monsters = "https://api.open5e.com/monsters"

cr3 = monsters * "/?challenge_rating=3"

#make request
resp = HTTP.get(cr3; require_ssl_verification = false)

println(resp.headers)

str = String(resp.body)
js = JSON.Parser.parse(str)

keys(js)

js["results"][1]
#this works, now the challenge will be getting it into a useful form