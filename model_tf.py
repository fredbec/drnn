import tensorflow as tf


class DDR_MLP_basic(tf.keras.Model):
  def __init__(self, num_hidden_layers, num_hidden_units, activation_fun = "relu", 
    output_units = 2):

    super(DDR_MLP, self).__init__()
    self.num_hidden_layers = num_hidden_layers
    self.num_hidden_units = num_hidden_units
    self.act_fun = activation_fun


    #check for valid combination of hidden unit list and number of hidden layers
    if isinstance(self.num_hidden_units, int):
      self.num_hidden_units = np.full(self.num_hidden_layers, self.num_hidden_units)
    elif self.num_hidden_layers > len(self.num_hidden_units):
      raise ValueError("not enough values of hidden units supplied") 


    ##### model architecture #####
    #setup and input layer
    self.arch = tf.keras.Sequential()
    self.arch.add(tf.keras.layers.InputLayer(input_shape=(11)))

    #add hidden layers
    for i in range(self.num_hidden_layers):
      self.arch.add(tf.keras.layers.Dense(self.num_hidden_units[i], activation='relu'))

    #output layers
    self.arch.add(tf.keras.layers.Dense(output_units)) #no activation function in last layer

  def call(self, inputs):
    x = self.arch(inputs)
    return x
