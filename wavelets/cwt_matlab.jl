# matlab中的cwt函数,只考虑morl小波。

using DSP

function intwave(wt::String,p::Int)
    ψ(x) = exp(-x^2/2)cos(5x)
    x=range(-8,8,length=2^p) #8怎么来的还需要讨论
    step=x[2]-x[1]
    return cumsum(ψ.(x))step,x
end

# 该算法根据matlab源码算法编写
function cwt(signal,scale)
    val_WAV,xWAV = intwave("morl",10)
    stepWAV = xWAV[2]-xWAV[1]
    xWAV = xWAV .- xWAV[1]
    xMaxWAV = xWAV[end]

    j = 1 .+ floor.(Int,(0:scale*xMaxWAV)/(scale*stepWAV))
    f = reverse(val_WAV[j])
    c = diff(conv(signal,f))

    lenSIG  = length(signal)
    d = (length(c)-lenSIG)/2
    first = 1+floor(Int,d)
    last = length(c)-ceil(Int,d)

    cof = -sqrt(scale)*c[first:last]
    return cof
end

#测试和matlab比较  signal=cos(0:0.1:1.5);cwt(signal,2,'morl')
signal=cos.(0:0.1:1.5)
cwt(signal,2)
# 结论：结果一致

# 根据理论公式进行计算，只计算中间点，即shift参数为0的情况。
# 注意，直接内积计算仅适用于小波时间尺度和信号时间尺度相同，本例中取scale=64则满足此条件。
t=range(-8,8,length=1024)
f=cos.(t)
ψ(x) = exp(-x^2/2)cos(5x)
w=ψ.(t)
dt=t[2]-t[1]
scale=64
c0=sqrt(scale)*sum(f .* w)*dt   #按照理论公式直接内积，计算结果是shift参数为0的情况
w0=cwt(f,scale)[513]            #c0近似和w0相等
# 计算多个点（也可以通过卷积计算）
z=sqrt(scale)*conv(f,reverse(w))*dt
first=1+floor(Int, (length(z)-1024)/2)
z=z[first:first+1023] #取中间部分
fig1=plot(z)
fig2=plot(cwt(f,scale))
hbox(fig1,fig2)
# 结论：从图上看两者基本一致。