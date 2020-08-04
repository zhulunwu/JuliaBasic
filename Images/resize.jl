using Images

img=[1.0,2,3,4]
imgnew=imresize(img,8)

testdata=rand(Float32,8,1,4)
newdata=imresize(testdata[:,1,:],16)

