
using Wavelets
using Makie
n = 2^11
x0 = testfunction(n,"Doppler")
plot(x0)

y = cwt(x0, wavelet(WT.morl))
plot(abs.(y))
