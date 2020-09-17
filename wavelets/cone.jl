# 演示小波系数的影响cone现象
using Makie
using Wavelets

x=zeros(1000)
x[500]=1
w=cwt(x,wavelet(WT.morl))
heatmap(abs.(w))
plot(abs.(w[:,1]),color=:blue)
plot!(abs.(w[:,20]),color=:red)
# 结果说明，不同的分解级数导致不同的小波拉伸或者压缩。级数高小波压缩的比较厉害，系数不为零的区域就小。
# cwt算法中的级数不等于理论中的尺度因子a。