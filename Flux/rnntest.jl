using Flux

const Nf=513
const FRAMES=1872
const DIM_H=256

const m=Chain(GRU(Nf,DIM_H),GRU(DIM_H,DIM_H),GRU(DIM_H,DIM_H),Dense(DIM_H,Nf,relu))

function loss(data::Array{Float32,2},label::Array{Float32,2})
    sum=0
    for f=1:FRAMES
        out=m(view(data,f,:))
        sum+=Flux.mse(out,view(label,f,:))
    end
    return sum/FRAMES
end

input=rand(Float32,Nf,FRAMES)
label=rand(Float32,Nf,FRAMES)

@time gs=gradient(() -> loss(input, label), Flux.params(m))
Flux.reset!(m)