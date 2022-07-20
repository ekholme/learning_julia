using DataFrames
using MLJ

#load in data
titanic = CSV.read("ml_intro/data/titanic_train.csv", DataFrame)

#look at first 5 row
first(titanic, 5)

#and look at the last 5 rows
last(titanic, 5)

#and get the total dims
size(titanic)

#describe the data
describe(titanic)

#and another way to look at the data types
schema(titanic)

#writing a little function to collapse cabin values
function replace_cabin(x)
    if ismissing(x)
        return "without"
    else
        return "with"
    end
end


#and executing this
titanic2 = DataFrames.transform(titanic, :Cabin => ByRow(replace_cabin) => :Cabin)

df2 = select(titanic2, Not([:Name, :PassengerId, :Ticket]))

#and coercing to multiclass
titanic3 = coerce(df2, :Cabin => Multiclass)
titanic3 = coerce(titanic3, :Embarked => Multiclass)
titanic3 = coerce(titanic3, :Sex => Multiclass)
titanic3 = coerce(titanic3, :Survived => Multiclass)

#split data
trn, tst = partition(titanic3, 0.7, rng=0408)

#create a transform for missing vals
imputer = FillImputer(features=[:Embarked, :Age])

#in MLJ, the 'machine' is what actually does the training
#the 'model' defines what should be done
mach = machine(imputer, trn)
fit!(mach)
#so, we've trained the transformer to get rid of missing vals here

#and here we can see the fitted values
fitted_params(mach)

#and getting a complete dataset
trn_c = MLJ.transform(mach, trn)
tst_c = MLJ.transform(mach, tst)

#using 'unpack' will separate the target from the features
y, X = unpack(trn_c, ==(:Survived))
y_tst, X_tst = unpack(tst_c, ==(:Survived))

#we can see available models
models(matching(X, y)) |> DataFrame

#create a tree classifier
Tree = @load DecisionTreeClassifier pkg=BetaML
tree = Tree()

#and create a machine
mach_tree = machine(tree, X, y)
fit!(mach_tree)

#and predict from it
#something wrong here -- we're not getting probs
p = predict(mach_tree, X_tst)
p[2]

predict_mode(mach_tree, X_tst)

#kids are home, so need to resume later...
#resume toward end of vid
