using GR
function showimage(imagedata)
    w,h=size(imagedata)
    ratio=float(h)/w
    mw,mh,pw,ph=inqdspsize()
    
    setwindow(0,w,0,h)
    setviewport(0,1,0,ratio)
    clearws()
    setwswindow(0,1,0,ratio)
    setwsviewport(0,mw*w/pw,0,mw*w*ratio/pw)
    
    drawimage(0,w,0,h,w,h,imagedata) 
    updatews()
end
data=readimage("d:\\Explore\\DataSets\\images\\gyy.png");

# 能显示，但是颜色不正确
imshow(data[3])

# 如此使用setcolormap毫无用处，看来可能是用法不对。
setcolormap(2)
imshow(data[3])

# 如下方式可以以黑白方式显示，看起来colormap这样用才正确？
imshow(data[3],colormap=2)

# 如何用imshow来显示彩色图形？