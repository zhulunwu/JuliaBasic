# 测试一下一维卷积
using Flux

#数据和卷积核
x = reshape([3,4,1,5,6],(5,1,1))
k = [1,2,-2] # 理论文档中可能是翻转的，即[-2,2,1]

# 一维full卷积,正确结果应为[3.0, 10.0, 3.0,-1.0,14.0, 2.0,-12.0]
m=Conv(tuple(3),1=>1,pad=2)
params(m).order[1] .= k
m(x)

#一维same卷积，正确结果应为[10.0, 3.0,-1.0,14.0, 2.0]
m=Conv(tuple(3),1=>1,pad=1)
params(m).order[1] .= k
m(x)

#一维Valid卷积正确结果应为[3.0,-1.0,14.0]
m=Conv(tuple(3),1=>1)
params(m).order[1] .= k
m(x)