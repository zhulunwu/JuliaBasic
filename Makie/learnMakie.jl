using Makie

x=0:0.1:8
y=sin.(x)
plot(x,y)
plot(x,y,color=:blue)

x=-1:0.1:1
y=-1:0.1:1
z=[exp(-x^2-y^2) for x=x,y=y]
surface(x,y,z)

#左键滚动放大或缩小，右键平移。左键点击并拖动进行窗口放大（貌似没实现）。
x = rand(10)
y = rand(10)
colors = rand(10)
scatter(x, y, color = colors)

#改变散点图大小
x = 1:10
y = 1:10
sizevec = x ./ 10
scene = scatter(x, y, markersize = sizevec)

#节点
x=Node(0.0)
on(x) do val
    println("x=",val)
end
#当赋值x[]=5时即触发事件，然后函数就自动调用。

# 节点动画
ϕ=Node(0.0)
x=0:0.1:8
y=@lift(sin.(x.+$ϕ))
plot(x,y)
for ϕ[]=0:0.02:8
    sleep(1/24)
end

# 或者如下方式
ϕ=Node(0.0)
x=0:0.1:8
y=lift(ϕ) do ϕ
    return sin.(x.+ϕ)
end
plot(x,y)
for ϕ[]=0:0.02:8
    sleep(1/24)
end

# 数组节点
x=Node(rand(10))
y=lift(x) do x
    return x
end
plot(y)
for i=1:10
    x[]=rand(10)
    sleep(0.1)
end
    
# 属性动画
x=0:0.1:8
y=sin.(x)
h=plot(x,y)
p=h[end]
for phi=0:0.01:π
    p[2]=sin.(x.+phi)
    sleep(1/24)
end

# 节点动画的另一个形式，没有使用宏，感觉更自然。节点之间的连接关系比较清晰。
ϕ=Node(0.0)
x=0:0.1:8
f(ϕ)=sin.(x.+ϕ) 
y=lift(f,ϕ) # 合并为一步就是y=lift(ϕ->sin.(x.+ϕ),ϕ)，前面的ϕ是形参，和节点没有关系，所以不必担心混淆。
plot(x,y)
for ϕ[]=0:0.02:8
    sleep(1/24)
end

# 添加和删除
using Base.Iterators
t=0:0.1:1
x=rand(length(t))
h=plot(t,x)
p=h[end]
for i=1:10
    p[1][]=collect(drop(p[1][],1))
    push!(p[1][],[0.1*i,rand()])
    sleep(0.5)
end

# 数据收集的动画
x=Node(rand(10))
h=plot(x)
for i=1:40
    x[]=vcat(x[],rand())
    update_limits!(h)
    update!(h)
    sleep(0.1)
end

#直方图
using Distributions
using StatsMakie
data=rand(Normal(0,2),1000)
plot(histogram(nbins=50),data,color=:green)