using Makie

fig=plot(rand(10),rand(10),color=:blue)
fig[Axis].names[:title]="here is a figure title"
# 可以看到，标题是通过属性设置来完成的。不过，显然没有如下的方法方便。
title(fig,"标题测试")