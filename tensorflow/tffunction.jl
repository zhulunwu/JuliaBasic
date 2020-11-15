using PyCall

tf=pyimport("tensorflow")

py"""
import tensorflow as tf
def f(x,y):
    a=tf.add(x,y)+tf.multiply(x,y)
    return a
"""

myfun=py"f"
myfun(3,4)
mytffun=tf.function(myfun)
mytffun(3,4)

@pydef mutable struct JF
    function jf(x,y)
        return 2*x+y
    end
end
JF.jf(2,3)
myjf=tf.function(JF.jf)
myjf(2,3).numpy()