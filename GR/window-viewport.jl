using GR

function draw()
    rx=[0,1,1,0]
    ry=[0,0,1,1]
    gx=[-1,0,0,-1]
    gy=[0,0,1,1]
    bx=[-1,0,0,-1]
    by=[0,0,-1,-1]
    yx=[0,1,1,0]
    yy=[0,0,-1,-1]

    setfillintstyle(1)
    setcolorrep(0,1,0,0)
    setcolorrep(1,0,1,0)
    setcolorrep(2,0,0,1)
    setcolorrep(3,1,1,0)

    setfillcolorind(0)
    fillarea(rx,ry)
    setfillcolorind(1)
    fillarea(gx,gy)
    setfillcolorind(2)
    fillarea(bx,by)
    setfillcolorind(3)
    fillarea(yx,yy)
end

# 测试代码。先设置，再作图，而不是反过来。
setwindow(-1,1,-1,1) #注意窗口的坐标范围
setviewport(0,1,0,0.5)
clearws()
setwswindow(0,1,0,0.5)
setwsviewport(0,0.1,0,0.1) #屏幕上视口的大小为10cm*10cm
draw()
updatews()