# 画墨西哥帽函数的图像
using Makie
ψ(t)=(1-t^2)exp(-t^2/2) # 小波十讲
t=-5:0.1:5
y=ψ.(t)
plot(t,y)
# 该函数形式不满足积分等于1的条件，所以后面的做了调整，多了一个系数。

#matlab的mexh函数图像 
# matlab代码： [PSI,XVAL] = WAVEFUN('mexh',7);plot(XVAL,PSI)
ϕ(t)=ψ(t)*(2/√3)*π^(-1/4)
t=range(-8,8,length=128)
y=ϕ.(t)
plot(t,y)