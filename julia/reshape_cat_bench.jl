# 添加维度的两种方法：reshape和cat，本文件比较一下两者的速度。
using BenchmarkTools

testimage=rand(1024,1024)
x = @btime reshape(testimage,(size(testimage)...,1));#368ns
y = @btime cat(testimage,dims=3);#3.0ms
x==y
# 结论是reshape速度要比cat快,另外，cat不能添加第一维，而reshape则可以。