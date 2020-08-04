using Flux
using BenchmarkTools

const Nf=128
const FRAMES=512
const DIM_H=128

const m=Chain(GRU(Nf,DIM_H),GRU(DIM_H,DIM_H),GRU(DIM_H,DIM_H),Dense(DIM_H,Nf,relu))

function loss(data::Array{Float32,2},label::Array{Float32,2})
    out=[m(data[:,i]) for i=1:FRAMES]
    pre=hcat(out...)
    l=Flux.mse(pre,label)
    Flux.reset!(m)
    return l
end

input=rand(Float32,Nf,FRAMES)
label=rand(Float32,Nf,FRAMES)

@benchmark gs=gradient(() -> loss(input, label), params(m))