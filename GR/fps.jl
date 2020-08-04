using GR
x = collect(0:0.01:2*pi)
a=@timed begin
    for i = 1:100
        plot(x, sin.(x .+ i / 10.0))
        sleep(0.01) 
    end
end
fps_gr = round(100 / a[2])