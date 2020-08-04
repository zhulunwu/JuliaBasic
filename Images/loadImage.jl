using Images
using Makie
img=load("girl.png")
image(img)
image(mosaicview([img img;img img]))
