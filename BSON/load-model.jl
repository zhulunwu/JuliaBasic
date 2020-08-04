# 和save-model.jl配合使用
using Flux
using BSON: @load

# 加载模型
@load "mymodel.bson" model
# 查看参数
params(model)