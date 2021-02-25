# 刷新页面会导致session信息变化吗？
using Genie, Genie.Sessions
using Genie.Router

Genie.secret_token!()
Sessions.init()
route("/home") do
    req=Genie.Requests.payload(:REQUEST)
    Dict(req)
end
up()