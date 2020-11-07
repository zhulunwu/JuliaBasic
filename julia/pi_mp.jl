# 多进程并行计算π
# julia -p 4 启动julia
using BenchmarkTools
const N=200000000
function spi()
    sum=0
    for n=1:N
        x=rand()
        y=rand()
        x^2+y^2 <= 1 && (sum+=1)
    end
    println("π=",4*sum/N)
end

@everywhere function points_in_circle(n::Int)
    sum=0
    for i=1:n
        x=rand()
        y=rand()
        x^2+y^2 <= 1 && (sum+=1)
    end
    return sum
end

function mpi()
    n=N÷4 #4为进程数量
    s0=points_in_circle(n)
    r1=remotecall(points_in_circle,2,n)
    r2=remotecall(points_in_circle,3,n)
    r3=remotecall(points_in_circle,4,n)
    s1=fetch(r1)
    s2=fetch(r2)
    s3=fetch(r3)
    println("π=",4*(s0+s1+s2+s3)/N)
end


function mpi2()
    n=N÷4 #4为进程数量
    s0=points_in_circle(n)
    r1=@spawnat 2 points_in_circle(n)
    r2=@spawnat 3 points_in_circle(n)
    r3=@spawnat 4 points_in_circle(n)
    s1=fetch(r1)
    s2=fetch(r2)
    s3=fetch(r3)
    println("π=",4*(s0+s1+s2+s3)/N)
end

function mpi3()
    n=N÷4 #4为进程数量
    s0=points_in_circle(n)
    r1=@spawnat :any points_in_circle(n)
    r2=@spawnat :any points_in_circle(n)
    r3=@spawnat :any points_in_circle(n)
    s1=fetch(r1)
    s2=fetch(r2)
    s3=fetch(r3)
    println("π=",4*(s0+s1+s2+s3)/N)
end

@btime spi()
@btime mpi()
@btime mpi2()
@btime mpi3()