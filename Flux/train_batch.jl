# 最基本的神经网络计算过程
using Flux
m=Dense(2,1)
ps=params(m)
ps.order[1] .= [0.2 0.3] #强制设定初始参数
w=ps.order[1]
b=ps.order[2]

x=[1.0 5.0;2.0 6.0]
y=[1.0 2.5]
loss(x,y)=Flux.mse(m(x),y)
loss(x,y) #0.065  可由如下算式给出：0.5*sum((m(x).-y).^2)

# 计算梯度，所谓梯度，指的是损失函数对参数的导数。如果是深度神经网络，则需要考虑复合函数求导法则
grads = gradient(() -> loss(x, y), ps)
grads[w] #1.3 1.4 见下面的分析

η = 0.1 # Learning Rate
for p in ps
  Flux.update!(p, η * grads[p])
end
println(w)

#=以上计算的理论过程如下
z=((w1*x1+w2*x2+b-y1)^2+(w1*X1+w2*X2+b-y2)^2)/2
∂z/∂w1=(2(w1*x1+w2*x2+b-y1)*x1+2(w1*X1+w2*X2+b-y2)*X1)/2
=2(w1*x1+w2*x2+b-y1)(x1+X1)/2
=(-0.4+3)/2=1.3
其余可类推
因此批处理多个样本计算时，由于损失函数其实是各个样本的平均，因此计算出来的梯度也是各个样本单独计算时梯度的平均。
至少mse这个损失函数可以这么认为。
=#
