using DataFrames
using CSV

#get data
wheels = CSV.read(download("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-08-09/wheels.csv"), DataFrame)

#get the first 5 rows 
first(wheels, 5)

#get the size
size(wheels)

#pull out just the names column
wheels.name

#another way to do the same
#although this will make a copy, whereas the previous approach will not
wheels[:, :name]

# we can test that this makes a copy
wheels.name === wheels[:, :name]

# we can get the names of a df with names()
names(wheels)

#we can subset by indices similar to how R works
wheels[1:3, :]

wheels[1:3, 1:3]

# or by column names
wheels[:, [:name, :height]]
#sort of misc note, but prefacing something with : in julia (e.g. :name) denotes that it is a symbol

# we can subset columns with a regular expression
wheels[:, r"^h"]
#will get columns that start with h

# we can also exclude columns with Not()
wheels[:, Not(:height)]
wheels[:, Not([:height, :name])]

# Between() gets columns in a range
wheels[:, Between(:name, :country)]

#and we can use Cols() to do some more advanced selection
wheels[:, Cols(x -> startswith(x, "h"))]
#remember that the x -> function(x, ...) is julia's syntax for lambda functions
