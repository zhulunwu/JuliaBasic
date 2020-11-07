using Flux

function speed()
    Nf=512
    FRAMES=1024
    DIM_H=256

    m=Chain(GRU(Nf,DIM_H),GRU(DIM_H,DIM_H),GRU(DIM_H,DIM_H),Dense(DIM_H,Nf,relu))
        
    p=params(m)
    opt = ADAM(0.0001)

    function loss(data,label)
        out=m.(data) 
        pre=hcat(out...)
        l=Flux.mse(pre,label)
        Flux.reset!(m)
        return l
    end

    for n=1:10
        tl=rand(Float32,Nf,FRAMES) 
        tr=rand(Float32,Nf,FRAMES)
        tm=(tl+tr)/2.0f0
        fs=[view(tm,:,i) for i=1:FRAMES]
        data=[(fs,tl)]
        @time Flux.train!(loss,p,data,opt)
    end
end

speed()