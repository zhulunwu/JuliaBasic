# 比较一下几种循环处理的速度
using BenchmarkTools

const data=rand(512)

# 一般写法
function test01(data)
    sum=0
    for i=1:length(data)
        @inbounds sum+=data[i]
    end
    return sum
end

# 和第三种情况对应的写法，貌似更优雅一些。
function test02(data)
    sum=0
    for i in eachindex(data)
        @inbounds sum+=data[i]
    end
    return sum
end

# 不用索引号，直接使用数据。
function test03(data)
    sum=0
    for v in data
        sum+=v
    end
    return sum
end

# 不仅要用到数据，而且还要用到数据索引的情况。
function test04(data)
    sum=0
    for (i,v) in enumerate(data)
        sum+=v
    end
    return sum
end

@btime test01(data);
@btime test02(data);
@btime test03(data);
@btime test04(data);

# 结论：几种写法速度差不多，主要看喜好了。