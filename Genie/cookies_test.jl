
using Genie
using HTTP

route("/") do 
    params=Genie.Router.@params 
    req=params[:REQUEST]
    res=params[:RESPONSE]
    sid=Genie.Sessions.id()
    Genie.Cookies.set!(res,"zlw",sid)
    "hello"
end
HTTP.get("http://127.0.0.1:8000")
route("/test") do 
    params=Genie.Router.@params
    req=params[:REQUEST]
    Genie.Cookies.getcookies(req)
end
HTTP.get("http://127.0.0.1:8000/test")
