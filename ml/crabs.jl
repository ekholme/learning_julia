using DataFrames
using CSV
using Chain
using MLJ
using Random
using Statistics

Random.seed!(0408)

crabs = CSV.read("./data/crabs_train.csv", DataFrame)

#rename columns
nms = names(crabs)
rep_names = lowercase.(replace.(nms, " " => "_"))

rename!(crabs, rep_names)

#see schema of data
tps = collect(zip(names(crabs), eltype.(eachcol(crabs))))

show(tps)

#extract y and drop id
y, X = unpack(crabs, ==(:age), !=(:id))

X = coerce(X, :sex => Multiclass)

#get training and validation indices
trn, val = partition(eachindex(y), 0.8; shuffle=true)

# define pipeline components
stand = Standardizer();
oh = OneHotEncoder(drop_last=true);
reg = @load LinearCountRegressor pkg = GLM add = true
mod = reg()

#define pipeline
m = Pipeline(stand, oh, mod)

#define machine
mach = machine(m, X, y);

#fit machine on training rows
fit!(mach, rows=trn)

#predict training y's
ŷ = MLJ.predict(mach, X[trn, :])

#evaluate model
cv = CV(nfolds=3)

MLJ.evaluate!(mach, rows=val, resampling=cv, measure=log_score)