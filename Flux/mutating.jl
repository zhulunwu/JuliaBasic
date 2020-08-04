using Flux

xs = [rand(784), rand(784), rand(784)]
ys = [rand( 10), rand( 10), rand( 10)]

data = zip(xs, ys)

# 如此定义函数将产生突变错误
function f(x)
    y=zeros(length(x))
    y .= x
    return y
end
# ERROR: Mutating arrays is not supported


m = Chain(Dense(784, 32, σ),Dense(32, 10),f,softmax)

loss(x, y) = Flux.mse(m(x), y)

Flux.train!(loss, params(m), data, ADAM()) 