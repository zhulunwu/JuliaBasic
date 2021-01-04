module MTEST
    export hello
    function hello()
        println("hello")
    end
end

# using MTEST
# MTEST.hello()
# 结论：即便在同一个文件中，也不能使用using,直接使用即可。即使在同一个文件夹下也同样不能使用using，可以include以后再直接使用。
# 要使用using 语句，可以将文件路径push到LOAD_PATH
