using Makie
using Wavelets

J=11; n = 2^J
x = testfunction(n,"Bumps")
plot(x)

y = cwt(x, wavelet(WT.morl))
heatmap(abs.(y))

y = cwt(x, wavelet(WT.dog1))
heatmap(abs.(y))

y = cwt(x, wavelet(WT.paul4))
heatmap(abs.(y))
