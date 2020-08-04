using Flux
using Dates
using CuArrays
using Flux: @epochs

const Nf=512
const FRAMES=1024
const DIM_H=256

cl=Dense(DIM_H,Nf,relu) |>gpu
cr=Dense(DIM_H,Nf,relu) |>gpu
rnn=Chain(GRU(Nf,DIM_H),GRU(DIM_H,DIM_H),GRU(DIM_H,DIM_H))|>gpu
    
p=params(cl,cr,rnn)|>gpu
opt = ADAM(0.0001)

function loss(data,label)
    hout=[rnn(data[:,i]) for i=1:FRAMES] 
    h=hcat(hout...)
    lout=cl(h)
    rout=cr(h)
    lpre=data.*lout./(lout+rout.+eps())
    rpre=data.*rout./(lout+rout.+eps())
    pre=vcat(lpre,rpre)   
    l=Flux.mse(pre,label)
    Flux.reset!(rnn)
    return l
end


tl=rand(Nf,FRAMES)|>gpu
tr=rand(Nf,FRAMES)|>gpu
tm=0.5(tl+tr)|>gpu
label=vcat(tl,tr)|>gpu
data=[(tm,label)]|>gpu

@epochs 2 Flux.train!(loss,p,data,opt)
