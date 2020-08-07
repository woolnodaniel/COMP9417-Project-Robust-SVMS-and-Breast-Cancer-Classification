# COMP9417-Project-Robust-SVMS-and-Breast-Cancer-Classification

A summary of (a) all code files, and (b) how to use them, is provided here. All code is divided into folders, organised by section corresponding to the report. 

### Section 1: Data Preprocessing

Two csv files are contained in this folder: ``data.csv`` (the original Breast Cancer dataset, available [here](https://www.kaggle.com/uciml/breast-cancer-wisconsin-data), and ``processed_data.csv``, which is the processed dataset. 
The processed dataset is constructed by running the file ``preprocess.py``. The optional command line argument ``--plot True`` can be added to obtain a heatmap correlation plot of the dataset.

### Section 2: Basic Model Comparison
The ``processed_data.csv`` dataset is included here again for ease, as this is required to run the comparison. The only other code in this section is ``basic_models.py``. This file takes several different command line inputs:
- ``--split splitVal``: use this to input your own testset split value for the dataset (default 0.2).
- ``--model m``: type string, one of ``'DT', 'GNB', 'NN', 'SVM', 'ALL'`` to test a particular model on the dataset (default ``'ALL'``). 
