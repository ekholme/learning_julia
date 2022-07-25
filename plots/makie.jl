# See [here](https://makie.juliaplots.org/stable/) for more info

using CairoMakie

#a basic plot
lines(1:10)

#another version
lines(1 .. 10, sin)

#building blocks of the above

#a scene is the prototype object
#similar to ggplot()
Scene(backgroundcolor=:red)

# we usually work with figures rather than scenes
f = Figure(backgroundcolor=:tomato)

#we can see the things within f with f.thing
#eg f.scene, f.attributes

#sort of a cool note, but if you preface some lines with ##
#in vscode it will run them all together

##
f = Figure(backgroundcolor=:tomato)
ax = Axis(f[1, 1], title="My Plot")
f

#we can also go in and hack/change individual elements
ax.blockscene.plots[2].color = :red
f

#RESUME AT 45:00 IN https://live.juliacon.org/talk/FBLWD3