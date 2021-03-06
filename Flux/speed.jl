using Flux

function speed(Nf::Int,FRAMES::Int,DIM_H::Int)
    m=Chain(GRU(Nf,DIM_H),GRU(DIM_H,DIM_H),GRU(DIM_H,DIM_H),Dense(DIM_H,Nf,relu))
        
    p=params(m)
    opt = ADAM(0.0001)

    function loss(data,label)
        fs=[view(data,:,i) for i=1:FRAMES]
        out=m.(fs) 
        pre=hcat(out...)
        return Flux.mse(pre,label)
    end

    for n=1:10
        tl=rand(Float32,Nf,FRAMES) 
        tr=rand(Float32,Nf,FRAMES)
        tm=(tl+tr)/2.0f0
        data=[(tm,tl)]
        @time Flux.train!(loss,p,data,opt,cb=()->Flux.reset!(m))
    end
end

speed(32,128,64)