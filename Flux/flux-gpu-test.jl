using Flux
using Dates
using CuArrays
using Flux: @epochs,gpu

xs = [rand(784), rand(784), rand(784)]
ys = [rand( 10), rand( 10), rand( 10)]
cxs=gpu(xs)
cys=gpu(ys)
data =gpu(zip(xs, ys))

m = Chain(Dense(784, 32, σ),Dense(32, 10), softmax)|>gpu

loss(x, y) = Flux.mse(m(x), y)
ps = Flux.params(m)

Flux.train!(loss, ps, data, opt)