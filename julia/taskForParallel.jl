# 协程方式实现并行计算
# 先定义一个函数，这个函数没事可干，就是消耗一些时间
function func()
   sleep(10)
   println("ten second passed,work is done")
end

#一般情况下是这样用的
func()
#然后你会看见repl一直在等待函数运行完毕。

#下面是另一种运行方法，即任务方式。
b=Task(func) #func不要加括号，否则就立即运行了。此代码仅仅创建任务，但是不会立即运行。
#安排任务开始运行
schedule(b) 
#可以发现运行后立即回到repl

#当然也能阻塞方式运行
b=Task(func)
schedule(b);wait(b)

#上述方式感觉有点繁琐，所以有一个宏能一次性完成这些工作
@async func()
#当然这种方式没有其他的控制选项。这种方式可以保留函数的调用形式，值得推荐。

function f(s::String)
    sleep(10)
    println(s)
end

@async f("hello") #可以在形式上支持参数，可见宏方式更直观。

#该函数纯粹就是消耗一些时间和cpu。我们想要看看多个任务同时进行时cpu的利用率如何？
function waste()
    y=0
    for i=1:200000000
            x=rand()
            y=(sin(x)+cos(exp(x)))/3
    end 
    println(y)   
end

b=Task(waste)
schedule(b)
# 执行后并没有回到repl中，而是一直等待任务完成。可见协程并非真正的并行。