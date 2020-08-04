# 连续训练测试
# 先定义一个模型，不失一般性，定义一个GRU网络。
using Flux
using BSON: @save
m=GRU(1,1)
# 看一下网络的参数
p=params(m)
# 准备一些数据
input=rand(100)
label=rand(100)
data=[(input,label)]
# 损失函数以及优化方法
opt=ADAM(0.01)
loss(x,y)=Flux.mse(vcat(m.(x)...),y)

# 训练
Flux.train!(loss,p,data,opt)

# 保存模型
model=cpu(m)
@save "mymodel.bson" model