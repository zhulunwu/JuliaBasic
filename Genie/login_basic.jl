using Genie

route("/") do 
    """
		<form action="/user" method="POST">
			学号：<input type="text" name="student_id">	<br>
			密码：<input type="password" name="student_pd"><input type="submit" value="登录"><br> 
		</form>
    """
end
   
route("/user", method=POST) do 
    id = Genie.Router.@params(:student_id)
    "student_id=$id"
end

down() #关闭服务
