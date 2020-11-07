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

using BenchmarkTools
# π计算的串行程序。
function spi()
    N=100000000
    sum=0
    for n=1:N
        x=rand()
        y=rand()
        x^2+y^2 <= 1 && (sum+=1)
    end
    println("π=",4*sum/N)
end
# π计算的并行程序。粗粒化并行。
function points_in_circle(n::Int)
    sum=0
    for i=1:n
        x=rand()
        y=rand()
        x^2+y^2 <= 1 && (sum+=1)
    end
    return sum
end
function mpi()
    N=100000000
    n=N÷100
    sum=Threads.Atomic{Int}(0)
    Threads.@threads for i=1:100
        sum_part=points_in_circle(n)
        Threads.atomic_add!(sum,sum_part)
    end
    println("π=",4*sum[]/N)
end