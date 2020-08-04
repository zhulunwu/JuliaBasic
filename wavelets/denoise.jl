
using Wavelets
using Makie

n = 2^11
x0 = testfunction(n,"Doppler")
x = x0 + 0.05*randn(n)
y = denoise(x,TI=true)

s1=plot(x0,color=:blue)
s1[Axis].names[:title]="原始信号"
ylims!(s1,-0.6,0.6)

s2=plot(x,color=:green)
s2[Axis].names[:title]="含噪信号"
ylims!(s2,-0.6,0.6)

s3=plot(y,color=:red)
s3[Axis].names[:title]="去噪信号 (TI VisuShrink)"
ylims!(s3,-0.6,0.6)

imgs=hbox(s3,s2,s1)
save("denoise_doppler.png",imgs)
