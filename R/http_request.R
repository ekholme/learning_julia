library(httr2)

monsters <- "https://api.open5e.com/monsters/?challege_rating=3"

resp <- request(monsters) |>
    req_perform()

x <- resp_body_json(resp)
