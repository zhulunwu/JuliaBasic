using Makie

s1=plot(rand(10),rand(10))
s2=scatter(rand(10),rand(10))
s3=heatmap(rand(10,10))
hbox(s1,vbox(s2,s3))
# 说明hbox不是理解为多个图水平放置，而是图图之间水平轴相连，或者拼接。
# 同理，vbox表示将图按竖直轴拼接