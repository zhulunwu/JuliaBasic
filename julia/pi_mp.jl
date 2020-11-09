# 多进程并行计算π
# julia -p 8 启动julia
using BenchmarkTools
const np=8

@everywhere function oneplay()
    N=100000000
    sum=0
    for n=1:N
        x=rand()
        y=rand()
        x^2+y^2 <= 1 && (sum+=1)
    end
    return 4*sum/N
end

function splay()
    s=zeros(np)
    for i=1:np
        s[i]=oneplay()
    end
    return sum(s)/np
end

function mplay()
    r=[remotecall(oneplay,i) for i=1:np]
    s=zeros(np)
    for i=1:np
        s[i]=fetch(r[i])
    end
    return sum(s)/np
end

function aplay()
    r=[ @spawnat :any oneplay() for i=1:np]
    s=zeros(np)
    for i=1:np
        s[i]=fetch(r[i])
    end
    return sum(s)/np
end

@btime splay()
@btime mplay()
@btime aplay()