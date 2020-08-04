using Flux

# 第一种定义层的方法就是定义函数
# 本函数参数为输入和输出的维度，函数体内定义了参数以及线性变换。返回的是一个函数。
function linear(in, out)
    W = randn(out, in)
    b = randn(out)
    x -> W * x .+ b
end

linear1 = linear(5, 3) # we can access linear1.W etc。看起来像是构建了一个对象。
linear2 = linear(3, 2)

model(x) = linear2(σ.(linear1(x)))
model(rand(5)) 


# 另外一种等效的方法是使用结构，有点面向对象的思想。
# 结构中仅仅定义了参数
struct Affine
    W
    b
end
# 下面是定义了构造函数。julia可以在外部定义构造函数，函数名和结构对象相同。
Affine(in::Integer, out::Integer) =   Affine(randn(out, in), randn(out))
  
# 重载调用，对象本身可以当作函数使用，新颖的用法。
# 看起来像函数定义，但是m并不能像普通函数那样调用。
(m::Affine)(x) = m.W * x .+ m.b
  
mdl = Affine(10, 5)
mdl(rand(10)) 