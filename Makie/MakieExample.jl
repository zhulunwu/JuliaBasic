using Makie
using AbstractPlotting

 x = rand(10)
 y = rand(10)
 colors = rand(10)
 scene = scatter(x, y, color = colors)

 x = 1:10
 y = 1:10
 sizevec = [s for s = 1:length(x)] ./ 10
 scene = scatter(x, y, markersize = sizevec)

 x = range(0, stop = 2pi, length = 40)
 f(x) = sin.(x)
 y = f(x)
 scene = lines(x, y, color = :blue)

 x = range(0, stop = 2pi, length = 80)
 f1(x) = sin.(x)
 f2(x) = exp.(-x) .* cos.(2pi*x)
 y1 = f1(x)
 y2 = f2(x)

 scene = lines(x, y1, color = :blue)
 scatter!(scene, x, y1, color = :red, markersize = 0.1)

 lines!(scene, x, y2, color = :black)
 scatter!(scene, x, y2, color = :green, marker = :utriangle, markersize = 0.1)


 x = range(0, stop = 10, length = 40)
 y = x
 #= specify the scene limits, note that the arguments for FRect are
     x_min, y_min, x_dist, y_dist,
     therefore, the maximum x and y limits are then x_min + x_dist and y_min + y_dist
 =#
 limits = FRect(-5, -10, 20, 30)

 scene = lines(x, y, color = :blue, limits = limits)


 x = range(0, stop = 2pi, length = 40)
 f(x) = cos.(x)
 y = f(x)
 scene = lines(x, y, color = :blue)

 axis = scene[Axis] # get the axis object from the scene
 axis[:grid][:linecolor] = ((:red, 0.5), (:blue, 0.5))
 axis[:names][:textcolor] = ((:red, 1.0), (:blue, 1.0))
 axis[:names][:axisnames] = ("x", "y = cos(x)")
 scene


 using StatsMakie
 N = 1000
 a = rand(1:2, N) # a discrete variable
 b = rand(1:2, N) # a discrete variable
 x = randn(N) # a continuous variable
 y = @. x * a + 0.8*randn() # a continuous variable
 z = x .+ y # a continuous variable
 scatter(x, y, markersize = 0.2)
 scatter(Group(a), x, y, markersize = 0.2)
 scatter(Group(a), x, y, color = [:black, :red], markersize = 0.2)
 scatter(Group(marker = a), x, y, markersize = 0.2)
 scatter(Group(marker = a, color = b), x, y, markersize = 0.2)
 scatter(Group(marker = a), Style(color = z), x, y)
 scatter(Group(color = a), x, y, Style(markersize = z ./ 10))

 using StatsMakie: linear, smooth
 plot(linear, x, y)
 plot(linear, Group(a), x, y)
 scatter(Group(a), x, y, markersize = 0.2)
 plot!(linear, Group(a), x, y)
 plot(linear, Group(linestyle = a), x, y)


 plot(linear, Group(linestyle = a), x, y)
 N = 200
 x = 10 .* rand(N)
 a = rand(1:2, N)
 y = sin.(x) .+ 0.5 .* rand(N) .+ cos.(x) .* a

 scatter(Group(a), x, y)
 plot!(smooth, Group(a), x, y)

 plot(histogram, y)
 plot(histogram, x, y)

 plot(histogram(nbins = 30), x, y)

 wireframe(histogram(nbins = 30), x, y)


 iris = RDatasets.dataset("datasets", "iris")
 scatter(Data(iris), Group(:Species), :SepalLength, :SepalWidth)

r = 1:10
for i = 1:length(r)
    push!(s[:markersize], r[i])
    AbstractPlotting.force_update!()
    sleep(1/24)
end


using AbstractPlotting
using ColorSchemes      # colormaps galore


 t = range(0, stop=1, length=500) # time steps

 θ = (6π) .* t    # angles

 x = t .* cos.(θ) # x coords of spiral
 y = t .* sin.(θ) # y coords of spiral

 p1 = lines(
     x,
     y,
     color = t,
     colormap = ColorSchemes.magma.colors,
     linewidth=8)

 cm = colorlegend(
     p1[end],             # access the plot of Scene p1
     raw = true,          # without axes or grid
     camera = campixel!,  # gives a concrete bounding box in pixels
                          # so that the `vbox` gives you the right size
     width = (            # make the colorlegend longer so it looks nicer
         30,              # the width
         540              # the height
     )
     )

 scene_final = vbox(p1, cm)