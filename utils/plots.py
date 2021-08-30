import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

def hists(preds, true, single = True):
	if single == False:
		fig, axes = plt.subplots(1, 2, figsize=(15, 5), sharey=True)
		# predictions
		sns.histplot(ax=axes[0], x = preds)
		axes[0].set_title('Model predictions')

		# true values
		sns.histplot(ax=axes[1], x = true)
		axes[1].set_title('True Values')
	else:
		fig, axes = plt.subplots(figsize=(15, 5))
		bins = np.linspace(np.min(np.array([np.min(preds), np.min(true)])), 
	    	                np.max(np.array([np.max(preds), np.max(true)])), 100)
		sns.histplot(x = true, label="true", alpha=1, bins=bins)
		sns.histplot(x = preds, label="pred", color="orange", alpha=0.6, bins=bins)
		plt.legend()
		
		
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