#显示激活函数的图像
#算法原理
#激活函数是神经元中对加权计算后的数进行的非线性计算。
#为简单考虑，先考虑两个输入一个输出的神经元。
using Flux
using Makie

# relu, sigmoid,tanh,elu
m=Dense(2,1,sigmoid)
#查看一下神经元的参数
ps=params(m)
#手动设置偏置值
ps.order[1] .= [0.4 0.6]
#输入数据
x=[[a,a] for a=-10:0.1:10]
y=m.(x)
y=vcat(y...)
plot(y)