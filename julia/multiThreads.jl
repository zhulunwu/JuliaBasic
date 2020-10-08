# 查看线程的数量
Threads.nthreads()

#一个耗时的函数
function waste()
    for i=1:100000000
            x=rand()
            x=(sin(x)+cos(exp(x)))/3
    end
    println("done") 
end
@time waste()

function waste_parallel()
    Threads.@threads for i=1:100000000
            x=rand()
            x=(sin(x)+cos(exp(x)))/3
    end
    println("done") 
end
@time waste_parallel()

#上述例子纯粹为了消耗时间，实际问题可能要输出其结果。这就面临数据竞争的问题。
#考虑如下的函数，如果改成并行版本呢？
function waste_y()
    sum=0
    for x=0:0.00001:100       
            sum += sin(x)
    end
    println("sum=",sum) 
end
@time waste_y()

function waste_nt()
    sum = Threads.Atomic{Float64}(0)
    Threads.@threads for x=0:0.00001:100      
        Threads.atomic_add!(sum,sin(x))
    end
    println("sum=",sum) 
end
@time waste_nt()
#貌似效率反而下降了。这可能要看计算和通信的对比。

import Base.Threads.@spawn
function fib(n::Int)
    if n < 2
        return n
    end
    t = @spawn fib(n - 2)
    return fib(n - 1) + fetch(t)
end