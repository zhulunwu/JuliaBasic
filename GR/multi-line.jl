using GR
import SpecialFunctions

x = linspace(0,20,200)
for order in 0:3
  plot(x, SpecialFunctions.besselj.(order, x))
  hold(true)
end