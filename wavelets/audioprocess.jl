using Wavelets
using Makie
using WAV

data=wavread("D:/Explore/DataSets/audios/login.wav")
adata=data[1]
left=adata[:,1]
right=adata[:,2]

yleft = cwt(left, wavelet(WT.morl))
yright = cwt(right, wavelet(WT.morl))

ampyl=abs.(yleft)
ampyr=abs.(yright)

plot(ampyl[:,28])