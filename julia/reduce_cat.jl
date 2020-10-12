# 比较一下cat操作和reduce操作的速度
using BenchmarkTools
list=[rand(100,64) for i=1:128]
x=@btime hcat(list...);
y=@btime reduce(hcat,list);
x==y

x=@btime vcat(list...);
y=@btime reduce(vcat,list);
x==y

# 似乎两者差别不大。但是，仅仅是列向量的情况下，差别比较明显
list=[rand(100) for i=1:128]
x=@btime hcat(list...);
y=@btime reduce(hcat,list);
x==y