#!/usr/bin/python3

"""
preprocess.py: preprocess the breast cancer data.
Performs the following actions:
    o read in data.csv
    o drop empty/NaN columns
    o map non-numeric values to numeric values
    o normalise all columns by standard normal transform
    o remove columns that have almost-zero correlation with the target
    o save as new csv file for importing and using (save preprocessing every time).
For an interactive examination of each step, and explanation on certain choices,
see the jupyter notebook

            "1. The Wisconsin Breast Cancer Dataset - Preprocessing"

included in the linked git repository.
"""

import argparse
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import sys


parser = argparse.ArgumentParser()
parser.add_argument('--plot',type=bool,default=False,help="plot: True if wanting to display plots (default False)")
args = parser.parse_args()

#read in data as a Pandas data frame.
ds = pd.read_csv('data.csv')

#drop empty column
ds = ds.drop(['Unnamed: 32', 'id'], axis=1)

#currently, diagnosis columns is classified as "Malignant" or "Benign"
#transform into 1/0.
ds.diagnosis = ds.diagnosis.map(lambda x: 1 if x == 'M' else -1)

#check for NaN values; if present, replace with the column mean
if ds.isnull().values.any(): #i.e. there are NaNs
    ar = ds.values #2d array, containing table values.
    num_cols = ar.shape[1]
    for i in range(num_cols):
        m = np.nanmean(ar[i,:])
        for j in range(ar.shape[0]):
            if np.isnan(ar[i][j]):
                ar[i][j] = m

# normalise data
for col in ds.columns:
    if col == 'diagnosis': #i.e. target column
        continue
    mu = np.mean(ds[col])
    sigma = np.std(ds[col])
    ds[col] = ds[col].map(lambda x: (x-mu)/sigma)

# correlation and (if desired) heatmap
corr_col = ds.corr()['diagnosis']
if args.plot:
    plt.figure()
    heat_map = sns.heatmap([corr_col], square=True, cbar_kws=dict(use_gridspec=False, location="top"))
    heat_map.set_yticklabels(heat_map.get_yticklabels(), rotation=0)
    plt.show()
drop_index = []
for i in range(len(corr_col)):
    if corr_col[i] < 0.1: #consider the feature uncorrelated with target
        drop_index.append(i)
drop_list = [ds.columns[i] for i in drop_index]
ds = ds.drop(drop_list,axis=1)

print(f'New number of features (not including target): {ds.shape[1]-1}')

#save as new csv file for use in other files.
file = open("processed_data.csv", "w")
ds.to_csv(file, index=False)
file.close()


