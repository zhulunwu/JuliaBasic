# 本例演示用结构来定义层以及消除mutating的方法，可以和mutating.jl进行比较。

using Flux

# 神经网络输入
input=rand(Float32,64,2,3)
label=rand(Float32,64,2,3)

dsmp(x)=x[1:2:end,:,:]
function usmp(x)
    xx(x::Array{Float32,1})=vcat([[x[i],Float32(0.5)*(x[i]+x[i+1])] for i=1:length(x)-1]...,[x[end],x[end]])
    out=cat([hcat([xx(x[:,i,1]) for i=1:size(x)[2]]...) for j=1:size(x)[3]]...,dims=3)
    return out
end


struct UNet
    lconv1
    lconv2
    rconv2
    rconv1
end

function UNet()
    lconv1=Conv(tuple(15), 2=>2,relu,pad=7)
    lconv2=Conv(tuple(15),2=>2,relu,pad=7)   
    rconv2=Conv(tuple(5),2=>2,relu,pad=2)
    rconv1=Conv(tuple(5),2=>2,relu,pad=2) 
    UNet(lconv1,lconv2,rconv2,rconv1)
end


# 神经网络层
function (u::UNet)(input)
    lout1=u.lconv1(input)
    lout2=u.lconv2(dsmp(lout1))

    rout2=u.rconv2(usmp(lout2))
    rout1=u.rconv1(rout2)

    return rout1
end

model=UNet()

loss(input,label)=Flux.mse(model(input),label)
@time Flux.train!(loss, params(model), [(input,label)],ADAM())
