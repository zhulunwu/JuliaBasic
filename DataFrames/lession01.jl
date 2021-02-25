using DataFrames

inventory = DataFrame(  item = ["Mars Rover","Venus Explorer","%Lunar Rover","30% Sun Filter"],
                        quantity = [3,1,12,100],
                        description = ["mars buggy","venus spaceship","Neil's used car","Sun filter"])

# 查找和替换（注意冒号）
for i in eachrow(inventory)
	i[:description] = replace(i[:description], "mars"=>"Mars")
	i[:description] = replace(i[:description], "venus"=>"Venus")
end

# 过滤或者查找功能
rovers = filter(x -> any(occursin.(["Rover"], x.item)),	inventory)

# 按序号看表项
inventory[1,:]

filter(r->r.item=="Venus Explorer",inventory)
filter(:item=>x->x=="Venus Explorer",inventory) #据说这种方式比较快
