import numpy as np
import pandas as pd
from utils import utils

def opt_hu(hu_list, filenumber, filename, k, modeltype, 
            activation_fun, loss_fun, optimer,
            lr, batch_size, max_num_epochs , 
            schedule, earlystop, pat,
            distr = "gamma"):
  
  x, x_test, x_all, y, y_test, dataset = utils.read_data(filename, filenumber, k) 
  
  batch_train_losses = []
  batch_valid_losses = []
  batch_train_mses = []
  batch_valid_mses = []
  print("in opt_hu" + distr)
  
  if distr == "normal":
      predictions_loc = []
      predictions_scale = []
  
  if distr == "gamma":
      predictions_con = []
      predictions_rate = []


  for hu in hu_list:
    model = modeltype.DDR_MLP(
      num_hidden_layers = len(hu),
      num_hidden_units = hu,
      activation_fun = activation_fun,
      input_dim = k
    )
    print(hu)
    model, mfit_history = utils.run_training(model = model,
                                      x=x,
                                      y=y,
                                      loss_fun=loss_fun,
                                      num_epochs=max_num_epochs,
                                      batch_size=batch_size,
                                      lr=lr,
                                      optim=optimer, 
                                      schedule = schedule,
                                      earlystop = earlystop,
                                      pat = pat)
    
    #append metrics to result arrays
    batch_train_losses.append(mfit_history.history['loss'])
    batch_valid_losses.append(mfit_history.history['val_loss'])
    batch_train_mses.append(mfit_history.history['mean_squared_error'])
    batch_valid_mses.append(mfit_history.history['val_mean_squared_error'])
    
    if distr == "normal":
      locs = np.array(model(x_all).loc)
      scales = np.array(model(x_all).scale)
      predictions_loc.append(locs)
      predictions_scale.append(scales)


    if distr == "gamma":
      cons = np.array(model(x_all).concentration)
      rates = np.array(model(x_all).rate)
      predictions_con.append(cons)
      predictions_rate.append(rates)

  
  min_ind, min_losses = utils.find_val_min(batch_valid_losses)

  #if hu_key is None:
  spec_filename = filename + "_" + str(filenumber)
  hu_key = utils.makehukey(spec_filename, hu_list, min_ind, min_losses)
  #hu_key.to_csv("results/" + "hu_key_" + filename + ".csv")
  
  
  if distr == "normal":
    dataset['pred_mean'] = predictions_loc[min_ind]
    dataset['pred_std'] = predictions_scale[min_ind]

  if distr == "gamma":
    dataset['pred_con'] = predictions_con[min_ind]
    dataset['pred_rate'] = predictions_rate[min_ind]
    dataset['pred_scale'] = (1/predictions_rate[min_ind])

  dataset.to_csv("results/"+ spec_filename +".csv")
  
  if distr == "normal":
      return batch_train_losses, batch_valid_losses, batch_train_mses, batch_valid_mses, predictions_loc, predictions_scale, hu_key
  
  if distr == "gamma":
      return batch_train_losses, batch_valid_losses, batch_train_mses, batch_valid_mses, predictions_con, predictions_rate, hu_key
  
  

def fitsimdat(num_sets, max_num_hidden_layers, 
            max_hidden_units, rdseed,
            filename, num_files, k, modeltype, 
            activation_fun, loss_fun, optimer,
            lr, batch_size, max_num_epochs, 
            schedule, earlystop, pat,
            distr = "gamma", save = True, startkj = 0):
  
  hu_list = utils.rdsearch(num_sets, rdseed, max_num_hidden_layers, max_hidden_units)
  hu_key_all = []

  for kj in range(startkj, (startkj+num_files)):
    kj += 1
    print("doing " + str(kj) + "th dataset")
    
    print(modeltype)
    print("in fitsimdat:" + distr)
    
    if distr == "normal":
        batch_train_losses, batch_valid_losses, batch_train_mses, batch_valid_mses, predictions_loc, predictions_scale, hu_key = opt_hu(
            hu_list = hu_list, filenumber = kj, filename = filename, k = k, modeltype = modeltype, 
            activation_fun = activation_fun, loss_fun = loss_fun, optimer = optimer,
            lr = lr, batch_size = batch_size, max_num_epochs = max_num_epochs, 
            schedule = schedule, earlystop = earlystop, pat = pat, distr = distr)
            
    if distr == "gamma":
        batch_train_losses, batch_valid_losses, batch_train_mses, batch_valid_mses, predictions_con, predictions_rate, hu_key = opt_hu(
            hu_list = hu_list, filenumber = kj, filename = filename, k = k, modeltype = modeltype, 
            activation_fun = activation_fun, loss_fun = loss_fun, optimer = optimer,
            lr = lr, batch_size = batch_size, max_num_epochs = max_num_epochs, 
            schedule = schedule, earlystop = earlystop, pat = pat, distr = distr)
    
    hu_key_all.append(hu_key)

    if save:
      valid_losses = pd.DataFrame(batch_valid_losses).transpose()
      valid_mse = pd.DataFrame(batch_valid_mses).transpose()
      train_losses = pd.DataFrame(batch_train_losses).transpose()
      train_mse = pd.DataFrame(batch_train_mses).transpose()
      valid_losses.to_csv("results/trainmetrics/" + "valid_losses_" + filename + "_" + str(kj) + ".csv")
      valid_mse.to_csv("results/trainmetrics/" + "valid_mses_" + filename + "_" + str(kj) + ".csv")
      train_losses.to_csv("results/trainmetrics/" + "train_losses_" + filename + "_" + str(kj) + ".csv")
      train_mse.to_csv("results/trainmetrics/" + "train_mses_" + filename + "_" + str(kj) + ".csv")
      
      if distr == "normal":
          print("in fitsimdat2:" + distr)
          preds_loc = pd.DataFrame(np.squeeze(predictions_loc)).transpose()
          preds_scale = pd.DataFrame(np.squeeze(predictions_scale)).transpose()
          preds_loc.to_csv("results/trainmetrics/" + "preds_loc_" + filename + "_" + str(kj) + ".csv")
          preds_scale.to_csv("results/trainmetrics/" + "preds_scale_" + filename + "_" + str(kj) + ".csv")
      
      if distr == "gamma":
          preds_con = pd.DataFrame(np.squeeze(predictions_con)).transpose()
          preds_rate = pd.DataFrame(np.squeeze(predictions_rate)).transpose()
          preds_con.to_csv("results/trainmetrics/" + "preds_con_" + filename + "_" + str(kj) + ".csv")
          preds_rate.to_csv("results/trainmetrics/" + "preds_rate_" + filename + "_" + str(kj) + ".csv")
          

  hu_key = pd.concat(hu_key_all)
  hu_key.to_csv("results/" + "hu_key_" + filename + ".csv")

  return hu_key