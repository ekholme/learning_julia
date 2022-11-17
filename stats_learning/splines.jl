#playing around with some spline stuff
using Splines2
using GLM
using CairoMakie

#creating some dummy data
x = collect(1.:1:100.)
y = log.(x)

lines(x, y)

#spline out the x data
#note that the default order is 4, which corresponds to a cubic spline
X = ns(x, df = 3)

#plot the individual basis functions against the raw X values
fig = Figure()
ax = Axis(fig[1, 1])
fig
lines!(ax, x, X[:, 1], color = "red")
lines!(ax, x, X[:, 2], color = "blue")
lines!(ax, x, X[:, 3], color = "green")

fig

#and then fit the basis function outputs in a linear model
res = lm(X, y)

preds = predict(res)

p2 = Figure()
ax = Axis(p2[1, 1])
lines!(ax, x, y, color = "blue")
lines!(ax, x, preds, color = "red")
p2
#so this isn't great, but we might be able to do better if we added more df

X₂ = ns(x, df = 6)

res2 = lm(X₂, y)

preds2 = predict(res2)

p3 = Figure()
ax3 = Axis(p3[1, 1])
lines!(ax3, x, y, color = "blue")
lines!(ax3, x, preds2, color = "red")
p3
#this gets us closer, but it does look wonky