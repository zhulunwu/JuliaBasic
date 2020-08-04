# 周期图
using DSP
using DelimitedFiles
using Makie

s=rand(128)
ss=arraysplit(s,32,16) #32是信号长度，16是重叠。

# 时频谱
spec=spectrogram(s,32,16; fs=10)
p, f, t = power(spec), freq(spec), time(spec)
# 或者
p=spec.power
f=spec.freq
t=spec.time

pg=periodogram(s,onesided=false)
pg.power
pg.freq