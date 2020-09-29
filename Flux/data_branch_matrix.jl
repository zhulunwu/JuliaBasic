# 测试网络数据有分支情况下自动微分计算，数据分支情况见下面的说明。
# 如果把数据的序列化放在神经网络内部，则可以计算。

using Flux

DIM_H=4
Nf=5
NSEQ=16 

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
    sequence=[view(input,:,i) for i=1:NSEQ]
    rnn_out=m.rnn.(sequence)
    dnn_input=hcat(rnn_out...) 
    y=m.dnn(dnn_input)
    Flux.reset!(m.rnn) 
    return input.*y
end
#上述神经网络输出数据包含两支，一支从输入端直接合并到输出端，另外一支流经循环神经网络到输出端。

model=RNet()
p=Flux.params(model)
opt = ADAM(0.0001f0)

loss(x,y)=Flux.mse(model(x),y)

tl=rand(Float32,Nf,NSEQ)
tr=rand(Float32,Nf,NSEQ)

data=[(tl,tr)]
@time Flux.train!(loss,p,data,opt) 
