
import tensorflow as tf
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

###########################Plotting functions############################
#plot function that is used later on for tracking training process
def plot(title, label, train_loss, val_loss):
    
    epoch_array = np.arange(len(train_loss)) + 1
    train_label, val_label = "Training "+label.lower(), "Validation "+label.lower()
    
    sns.set(style='ticks')

    plt.plot(
        epoch_array, train_loss, epoch_array, val_loss, linestyle='dashed', marker='o'
        )
    legend = ['Train', 'Validation']

    plt.legend(legend)
    plt.xlabel('Epoch')
    plt.ylabel(label)
    plt.title(title)
    
    sns.despine(trim=True, offset=5)
    plt.title(title, fontsize=15)




#########################Model fit functions###############################
def run_training(model, 
                 x, y,
                 loss_fun,
                 num_epochs, 
                 batch_size,
                 lr, 
                 optim):
  
  #compile model
  model.compile(optimizer = optim(learning_rate = lr),
                loss = loss_fun,
                metrics = [tf.keras.metrics.MeanSquaredError()])
  
  #train model
  mfit_history = model.fit(x = x, y = y, 
                           batch_size = batch_size,
                           epochs = num_epochs, verbose=False, 
                           validation_split = 0.25)

  return model, mfit_history


def model_diagnostics(model, mfit_history):

  #get losses and MSE over epochs
  train_loss = mfit_history.history['loss']
  valid_loss = mfit_history.history['val_loss']
  train_mse = mfit_history.history['mean_squared_error']
  valid_mse = mfit_history.history['val_mean_squared_error']

  losses = pd.DataFrame({'train': train_loss, 'valid': valid_loss})
  mses = pd.DataFrame({'train': train_mse, 'valid': valid_mse})

  #predict with model(), as model.predict() doesn't work with last layer
  predictions = model(np.array(x_train))

  return losses, mses, predictions