Explaining the files:
For each set, the lower files source (some of) the files above

1. For the NLL tables (Appendix Tables in report)
	- negloglik_new.R: contains functions to calculate the NLL for the normal
	and gamma distributions, and the mean squared error
	- extract_nll_withlin.R: for a given file, goes through the 10 datasets
	to extract the parameter predictions all models (DDL, cubic GAM, linear
	GAM) make and returns a dataframe that contains the NLL, CRPS and MSE
	values that the three models obtain; option to evaluate either on test
	or train set
	- master_maketable.R: goes through the three simulations (expgamma, expnormal,
	sinnormal) and saves a single latex table for each of them: option for train
	or test set (automatically changes the file name)

	--> saves the RDS files (_nll_res_filename_test/train.rds)

2. For the score table (Table 1 and 2 in report)
	- scoretable_withlin.R: goes through nll_tables from above and summarizes as 
	a relative score table by dividing the DDL scores by the GAM scores
	- master_scoretable.R: goes through the three simulations to make a single
	relative score table; option for train or test set

3. For the architecture table (Table 3 in report):
	- extract_hustats.R: goes through the hu_key files that the optimization
	in Python produced and (through some potentially awkward string manipulations)
	extracts the optimal architectures for the best 1 and best 5 (default values) 
	models for each simulation and returns as a dataframe
	- master_hustats.R: goes through the three simulations and rbinds the dataframes 

4. For the GAMS:
	- gam_fit.R: automatically fits GAMs for a given simulation (loops through the
	10 files) and saves the results in the results csv-file it read in. Thus, all 
	predictions (DDL, cubic GAM, linear GAM) are in the same csv-file (with of course
	different names). Options for this function are linear/cubic GAM and the outcome 
	distribution (gamma or normal)
	- master_gam.R: actually fits the GAMs using the above function
	contains A LOT of unnecessary (and commented-out) lines, because initially, this
	file also extracted the nll-stats (now in 1.), which was just stupid.
	
	