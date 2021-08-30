
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



def plot1d(yhat, yhatsd, x, y):
    
    sorter = np.argsort(x.reshape(10000))
    xplot = x[sorter]
    plt.figure(figsize=[12,5])  # inches
    plt.plot(x, y, 'b.', label='observed', alpha = 0.5, color = "steelblue");
    
    m = np.array(yhat)[sorter]
    s = np.array(yhatsd)[sorter]
    
    plt.plot(xplot, m, linewidth=1, label='mean', color = 'firebrick')
    plt.plot(xplot, m + 1.96 * s, linewidth=1, label=r'mean + 2 stddev', color = 'yellowgreen')
    plt.plot(xplot, m - 1.96 * s, linewidth=1, label=r'mean + 2 stddev', color = 'yellowgreen')
    plt.title('Fitted Neural Network Predictions')
    plt.xlabel('x')
    plt.ylabel('y')
    plt.savefig('fit_fct.png')


#########################Model fit functions###############################
def run_training(model, 
                 x, y,
                 loss_fun,
                 num_epochs, 
                 batch_size,
                 lr, 
                 optim, 
                 schedule = False,
                 earlystop = True,
                 pat = 5):
  
  #compile model
  model.compile(optimizer = optim(learning_rate = lr),
                loss = loss_fun,
                metrics = [tf.keras.metrics.MeanSquaredError()])
  
  def scheduler(epoch, lr):
        if epoch < 300:
            return lr
        else:
            return lr * tf.math.exp(-0.001)
  
  if schedule & earlystop:
    #print("doing schedule and earlystop")
    callback = [tf.keras.callbacks.LearningRateScheduler(scheduler),
                tf.keras.callbacks.EarlyStopping(monitor='val_loss', patience=pat,
                                                 restore_best_weights = True)]

  elif schedule:
    #print("doing schedule")
    callback = [tf.keras.callbacks.LearningRateScheduler(scheduler)]
  
  elif earlystop:
    #print("doing earlystop")
    callback = [tf.keras.callbacks.EarlyStopping(monitor='val_loss', patience=pat,
                                                 restore_best_weights = True)]

  else:
    #print("doing nothing")
    callback = None

  mfit_history = model.fit(x = x, y = y, 
                           batch_size = batch_size,
                           callbacks = callback,
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
  
  
def oldrdsearch_hu(num_sets, rd_seed, max_num_hidden_layers, max_hidden_units):
  hu_list = []
  np.random.seed(rd_seed)

  for k in range(num_sets):
    curr_max = max_hidden_units
    curr_hu = []
    for i in range(max_num_hidden_layers):
      diff = (max_num_hidden_layers - i) * 50
      if curr_max < 200:
        diff = 100
      if curr_max < 100:
        diff = 50
      if curr_max < 50:
        break
      
      rd_int = np.random.randint(curr_max-diff, curr_max)
      if rd_int < 5:
        break
      curr_max = rd_int
      curr_hu.append(rd_int)
      stop = np.random.randint(1, 10)
      if stop>=9:
        break
    hu_list.append(curr_hu)

  return hu_list


def rdsearch(num_sets, rd_seed, max_num_hidden_layers, max_hidden_units, min_largest = 50, min_hu = 2):
  hu_list = []
  np.random.seed(rd_seed)

  for k in range(num_sets):
    #randomly sample number of hidden layers
    num_hl = np.random.randint(1, max_num_hidden_layers+1)
    #initialize empty list
    curr_hu = np.zeros(num_hl)
    
    #assign position of largest hidden layer
    #if network has only one layer, assign to first layer
    if num_hl < 2:
      pos_largest = 0
    #else, put largest layer in first half of network
    else:
      pos_largest = np.random.randint(0, (num_hl//2) + 1)
    
    #size of largest layer
    largest_hu = np.random.randint(min_largest, max_hidden_units+1)
    #assign to its position
    curr_hu[pos_largest] = largest_hu


    #now, go through the layers before and after and sample their width
    #principle: continuoulsy rising width before largest layer,
    #continuously declining width after largest layer
    
    #first part
    curr_max = largest_hu
    for i in range(pos_largest):
      if curr_max <= min_hu:
        break
      curr_max = np.random.randint(curr_max // 2, curr_max)
      curr_hu[pos_largest-i-1] = curr_max
    
    #second part
    curr_max = largest_hu
    maxind = num_hl - pos_largest
    for i in range(maxind-1):
      if curr_max <= min_hu:
        break
      curr_max = np.random.randint(curr_max // 2, curr_max)
      curr_hu[pos_largest+i+1] = curr_max
    
    curr_hu = curr_hu[curr_hu != 0]

    hu_list.append(curr_hu)

  return hu_list



def find_val_min(batch_valid):
    res = np.zeros(len(batch_valid))
    for k, mod_results in enumerate(batch_valid):
        valmin = np.min(mod_results)
        res[k] = valmin
    min_mod = np.argmin(res)
    return min_mod, res
    
def makehukey(spec_filename, hu_list, min_ind, min_losses):
    file_list = {"filename": [spec_filename for i in range(len(hu_list))]}
    hu_key = pd.DataFrame(data = file_list)
    hu_key['architecture'] = hu_list
    hu_key['min_val_loss'] = min_losses
    hu_key['is_min'] = 0
    hu_key.at[min_ind, 'is_min'] = 1
    return hu_key
  
#read in data and return training and test sets
def read_data(filename, kj, k):
    xcols = tuple(['x'+str(i+1) for i in range(k)])
    
    filepath = "simdata/data/" + filename + "_" + str(kj) + ".csv"
    dataset = pd.read_csv(filepath)
    mydat_train = dataset[dataset['testid']==0]
    mydat_test = dataset[dataset['testid']==1]
    
    x, x_test = mydat_train.loc[:,xcols], mydat_test.loc[:,xcols]
    y, y_test = mydat_train['y'], mydat_test['y']
    x, x_test = tf.convert_to_tensor(x), tf.convert_to_tensor(x_test)
    y, y_test = tf.convert_to_tensor(y), tf.convert_to_tensor(y_test)
    x_all = tf.convert_to_tensor(dataset.loc[:, xcols])
    
    return x, x_test, x_all, y, y_test, dataset