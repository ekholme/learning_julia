using DataFrames
using OpenML
using CSV

#create a dataframe
df = DataFrame(
    age = [21, 25, 40],
    height = [1.57, 3.5, 3.5],
    married = [true, false, false]
)

#filter a df
filter(df) do row
    row.married == false
end
#although I'm not sure this is the best approach?

#can grab from openML
#see openML.org
#tbl = OpenML.load(42638)

#titanic
titanic0 = CSV.read("ml_intro/data/titanic_train.csv", DataFrame)

#describe the df
describe(titanic0)

#getting rows 1:4, all cols
titanic0[1:4, :]

#getting just the age column
titanic0.Age[:]