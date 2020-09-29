# 测试网络数据有分支情况下自动微分计算，数据分支情况见下面的说明。
# 测试表明，当前版本zygote自动微分似乎不支持这种类型的计算。不过，序列化的工作若放在神经网络内部，则分支是支持的。

using Flux

DIM_H=4
Nf=5 

struct RNet
    rnn
    dnn
end
Flux.@functor RNet

function RNet() 
    rnn=Chain(GRU(Nf,DIM_H),GRU(DIM_H,DIM_H),GRU(DIM_H,DIM_H))
    dnn=Dense(DIM_H,Nf,relu)
    RNet(rnn,dnn)
end

function (m::RNet)(input)
    rnn_out=m.rnn.(input)
    dnn_input=hcat(rnn_out...) 
    y=m.dnn(dnn_input)
    x=hcat(input...)
    Flux.reset!(m.rnn) 
    return x.*y
end
#上述神经网络输出数据包含两支，一支从输入端直接合并到输出端，另外一支流经循环神经网络到输出端。

model=RNet()
p=params(model)
opt = ADAM(0.0001f0)

loss(x,y)=Flux.mse(model(x),y)

tl=rand(Float32,Nf,16)
tr=rand(Float32,Nf,16)

input=[view(tl,:,i) for i=1:16]
data=[(input,tr)]
@time Flux.train!(loss,p,data,opt) 
