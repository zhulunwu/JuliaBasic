using PyCall
include("data_mnist.jl")

tf=pyimport("tensorflow")

imgs_train=mnist_images()
data_train=zeros(length(imgs_train),28,28)
for i=1:length(imgs_train)
  data_train[i,:,:]=Float32.(imgs_train[i])
end

lbls_train=Int8.(mnist_labels())

layers=tf.keras.layers
model = tf.keras.models.Sequential([
  layers.Flatten(input_shape=(28, 28)),
  layers.Dense(128, activation="relu"),
  layers.Dropout(0.2),
  layers.Dense(10, activation="softmax")
])

model.compile(optimizer="adam", loss="sparse_categorical_crossentropy", metrics=["accuracy"])
model.fit(data_train, lbls_train, epochs=5)

imgs_test=mnist_images(:test)
data_test=zeros(length(imgs_test),28,28)
for i=1:length(imgs_test)
  data_test[i,:,:]=Float32.(imgs_test[i])
end

lbls_test=Int8.(mnist_labels("test"))
model.evaluate(data_test,lbls_test,verbose=2)