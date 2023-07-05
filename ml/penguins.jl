using DataFrames
using CSV
using Chain
using MLJ
using Random
using Statistics

Random.seed!(0408)

penguins = CSV.read(download("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-28/penguins.csv"), DataFrame, missingstring="NA")

#filter to those without missing body mass
dropmissing!(penguins, :body_mass_g)

#extract body mass as y
y, X = unpack(penguins, ==(:body_mass_g))

# coercing textual columns to multiclass for modeling
coerce_nms = [:species, :sex, :island]

c_dict = Dict(zip(coerce_nms, repeat([Multiclass], 3)))

coerce!(
    X,
    c_dict
)

#get training and validation indices
trn, val = partition(eachindex(y), 0.8; shuffle=true)

#define pipeline components
imp = FillImputer();
stand = Standardizer();
oh = OneHotEncoder(drop_last=true);
LinearRegression = @load LinearRegressor pkg = GLM add = true
mod = LinearRegression()

#define pipeline
m = Pipeline(imp, stand, oh, mod)

#define machine
mach = machine(m, X, y);

#fit machine on training rows
fit!(mach, rows=trn)

#predicting training y's
ŷ = MLJ.predict_mean(mach, X[trn, :])

#evaluate model
cv = CV(nfolds=3)

MLJ.evaluate!(mach, rows=val, resampling=cv, measure=rmse)

#note -- call measures() to see all available measures