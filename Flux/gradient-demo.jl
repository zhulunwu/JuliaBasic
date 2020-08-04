#=一个非常简单的关于flux的梯度的测试
假如输入数据为x1和x2
神经元只有一个，该神经元有两个树突，对应两个权值w1和为w2。一个输出，对应偏置b。
数学计算过程为
x1*w1+x2*w2+b=out
L(out,y)=(y-out)^2
所谓梯度，就是求损失函数对各parameters的变化率。这个概念很重要，不然老是说梯度梯度，具体含义是什么？
梯度计算出来后，可以利用梯度进行参数的更新。
2020/4/6更新已适应新的Flux版本
=#

using Flux
# 数据
x=[0.1,-0.1]
y=0.4
# 神经元模型
m=Dense(2,1) #模型参数随机设定，下面将手动修改其参数
# 显示参数，ps其实是指向参数对象的引用
ps=params(m)
#也可以单独显示，w和b同样也是指向参数各部分的引用
w=ps.order[1]
b=ps.order[2]
# 修改参数，注意要加点以表示对矩阵元素赋值，而不是将w和b指向另一个矩阵。
w .= [0.2 0.2]
b .= [0.8]
# 重新查看模型参数
params(m)
# 显然可以直接利用order来修改参数的值
ps.order[1] .= [0.8 0.8]
ps.order[2] .= [0.1]
# 显示修改后模型的参数
params(m) 
# 损失函数
loss(x,y)=(first(m(x))-y)^2
# 获得梯度   
gs = gradient(()->loss(x,y),ps)
gs[w]
gs[b]
# 更新参数
w .= (w.-0.1*gs[w])
b .= (b.-0.1*gs[b])
# 再显示模型参数
params(m)
#或者利用update!函数来完成
using Flux:update!
update!(w,0.1*gs[w])
update!(b,0.1*gs[b])
