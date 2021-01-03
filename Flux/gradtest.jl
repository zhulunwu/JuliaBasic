using Flux

const Nf=128
const FRAMES=1024
const DIM_H=128

const m=Chain(LSTM(Nf,DIM_H),LSTM(DIM_H,DIM_H),LSTM(DIM_H,DIM_H),Dense(DIM_H,Nf,relu))

function loss(data::Array{Float32,2},label::Array{Float32,2})
    seq=[view(data,:,i) for i=1:FRAMES]
    out=m.(seq)
    pre=hcat(out...)
    l=Flux.mse(pre,label)
    Flux.reset!(m)
    return l
end

input=rand(Float32,Nf,FRAMES)
label=rand(Float32,Nf,FRAMES)

@time gs=gradient(() -> loss(input, label), Flux.params(m))