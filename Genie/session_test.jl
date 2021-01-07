using Genie, Genie.Sessions
using Genie.Router
using HTTP

Sessions.init() #初始化

# 设置服务器url服务
route("/home") do
    sess = Sessions.session(Genie.Router.@params) #客户访问路由时输入参数从而建立session
    Sessions.set!(sess, :visit_count, Sessions.get(sess, :visit_count, 0)+1)
    "$(Sessions.get(sess, :visit_count))"
end
up()

response = HTTP.get("http://127.0.0.1:8000/home")
response.body |> String #转变为字串 

down() #关闭服务
