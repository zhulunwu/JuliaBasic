using Genie

# 用户数据库
users=Dict("zlw"=>"zhulunwu","zcz"=>"1211","phr"=>"1226")

route("/login", method=POST, named = :login) do 
    params=Genie.Router.@params 

    username = Genie.Router.@params(:username)
    password = Genie.Router.@params(:password)

    if (haskey(users,username) && users[username]==password)
        res=params[:RESPONSE]
        sessionid=Genie.Sessions.id()
        Genie.Cookies.set!(res,username,sessionid)
        Genie.Renderer.redirect(:get)
    else
        Genie.Renderer.redirect(:show_login)
    end
end

route("/login",named= :show_login) do 
    """
		<form action="/login" method="POST">
			学号：<input type="text" name="username">	<br>
			密码：<input type="password" name="password"><input type="submit" value="登录"><br> 
		</form>
    """
end

function match(cookies,users)
    items=strip.(split(cookies,";"))
    keys=first.(split.(items,"="))
    for name in keys
        haskey(users,name) && return name
    end
    return false
end

route("/") do 
    sessinfo=Genie.Requests.payload(:REQUEST)
    if haskey(Dict(sessinfo),"cookie")
        username=match(Dict(sessinfo)["cookie"],users)
        if username!=false
            "欢迎$(username)同学,这是你的主页！"
        else
            Genie.Renderer.redirect(:show_login)
        end   
    else
        Genie.Renderer.redirect(:show_login)
    end
end
up()