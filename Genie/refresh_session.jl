# 刷新页面会导致session信息变化吗？
using Genie, Genie.Sessions
using Genie.Router

Genie.secret_token!()
Sessions.init()
route("/home") do
    Genie.Requests.payload(:SESSION)
end
up()
#结果发现刷新导致session id 不同。