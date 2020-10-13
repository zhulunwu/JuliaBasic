using Flux
using BenchmarkTools

const Nf=8
const FRAMES=12
const DIM_H=4

const m=Chain(GRU(Nf,DIM_H),GRU(DIM_H,DIM_H),GRU(DIM_H,DIM_H),Dense(DIM_H,Nf,relu))

function loss(data,label)
    out=m.(data)
    pre=hcat(out...)
    y=pre.*hcat(data...)
    l=Flux.mse(y,label)
    Flux.reset!(m)
    return l
end

data=rand(Float32,Nf,FRAMES)
input=[view(data,:,i) for i=1:FRAMES] #先序列化后再输入神经网络则导致梯度计算出错
label=rand(Float32,Nf,FRAMES)

@btime gs=gradient(() -> loss(input, label), Flux.params(m))