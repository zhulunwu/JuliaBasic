using PyCall
include("data_mnist.jl")

#导入一些要用的函数
tf=pyimport("tensorflow")
Dense=tf.keras.layers.Dense
Flatten=tf.keras.layers.Flatten
Conv2D=tf.keras.layers.Conv2D
Model=tf.keras.Model

imgs_train=mnist_images()
data_train=zeros(Float32,length(imgs_train),28,28,1)
for i=1:length(imgs_train)
  data_train[i,:,:,1]=Float32.(imgs_train[i])
end

lbls_train=Int8.(mnist_labels())

# 自定义神经网络
@pydef mutable struct MyModel <: Model
    function __init__(self)
        pybuiltin(:super)(MyModel,self).__init__()
        self.conv1 = Conv2D(32, 3, activation="relu")
        self.flatten = Flatten()
        self.d1 = Dense(128, activation="relu")
        self.d2 = Dense(10)
    end
    function call(self::PyObject, x::PyObject;training=nothing)
        x = self.conv1(x)
        x = self.flatten(x)
        x = self.d1(x)
        return self.d2(x)
    end
end

model = MyModel()

loss_object = tf.keras.losses.SparseCategoricalCrossentropy(from_logits=true)
optimizer = tf.keras.optimizers.Adam()

train_loss = tf.keras.metrics.Mean(name="train_loss")
train_accuracy = tf.keras.metrics.SparseCategoricalAccuracy(name="train_accuracy")

test_loss = tf.keras.metrics.Mean(name="test_loss")
test_accuracy = tf.keras.metrics.SparseCategoricalAccuracy(name="test_accuracy")

@pydef mutable struct tt
    function step_train(images, labels) 
        tape=PyNULL() 
        loss=PyNULL()  
        predictions=PyNULL()    
        @pywith tf.GradientTape() as tape begin
            predictions = model(images,training=true)
            loss = loss_object(labels, predictions)
        end
    
        gradients = tape.gradient(loss, model.trainable_variables)
        optimizer.apply_gradients(zip(gradients, model.trainable_variables))
    
        train_loss(loss)
        train_accuracy(labels, predictions)
    end

    function step_test(images, labels)
        predictions = model(images, training=false)
        t_loss = loss_object(labels, predictions)

        test_loss(t_loss)
        test_accuracy(labels, predictions) 
    end  
end

train_step=tf.function(tt.step_train)
test_step =tf.function(tt.step_test)

#训练
batch_size=32
nbatch=length(lbls_train)÷batch_size
data_batched=[(data_train[32*i-31:32*i,:,:,:],lbls_train[32*i-31:32*i]) for i=1:nbatch]

#测试数据
imgs_test=mnist_images(:test)
data_test=zeros(length(imgs_test),28,28,1)
for i=1:length(imgs_test)
  data_test[i,:,:,1]=Float32.(imgs_test[i])
end
lbls_test=Int8.(mnist_labels("test"))


EPOCHS = 5
for epoch=1:EPOCHS
    train_loss.reset_states()
    train_accuracy.reset_states()
    test_loss.reset_states()
    test_accuracy.reset_states()
    
    for (imgs,lbls) in data_batched
        train_step(imgs,lbls)
    end

    test_step(data_test,lbls_test)

    println("train loss=",train_loss.result().numpy(),
            "\ntrain accuracy=",train_accuracy.result().numpy()*100,
            "\ntest loss=",test_loss.result().numpy(), 
            "\ntest accuracy=",test_accuracy.result().numpy()*100)
end