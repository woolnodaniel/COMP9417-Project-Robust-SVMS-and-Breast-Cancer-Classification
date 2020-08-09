# COMP9417-Project-Robust-SVMS-and-Breast-Cancer-Classification

A summary of (a) all code files, and (b) how to use them, is provided here. All code is divided into folders, organised by section corresponding to the report. 

### Section 1: Data Preprocessing

Two csv files are contained in this folder: ``data.csv`` (the original Breast Cancer dataset, available [here](https://www.kaggle.com/uciml/breast-cancer-wisconsin-data)), and ``processed_data.csv``, which is the processed dataset. 
The processed dataset is constructed by running the file ``preprocess.py``. The optional command line argument ``--plot True`` can be added to obtain a heatmap correlation plot of the dataset.

### Section 2: Basic Model Comparison
The ``processed_data.csv`` dataset is included here again for ease, as this is required to run the comparison. The only other code in this section is ``basic_models.py``. This file takes several different command line inputs:
- ``--split splitVal``: type float, use this to input your own testset split value for the dataset (default 0.2).
- ``--model m``: type string, one of ``'DT', 'GNB', 'NN', 'SVM', 'ALL'`` to test a particular model on the dataset (default ``'ALL'``). 
- ``--search b``: type bool, set to ``True`` if wanting to run a grid search for hyperparameter optimisation on the SVM model. 
- ``disable_warnings b``: type bool, default ``True``; set to ``False`` if wanting to see the warnings given by ``sklearn``. 
- ``average n``: type int (default 1); run ``n`` simulations and output the per-simulation and average results. 
- ``--verbose b``: type bool (default ``False``): set to ``True`` if want to see output of every simulation; otherwise, only the first five simulation results are given.

### Section 3: Different SVM Implementations
This section defines three different type of MATLAB files:
- ``model_svm.m``: MATLAB function that takes as input the training set, the test set, and any other hyperparameters, and returns the weights and bias for that particular type of SVM (SVM type given by ``model``, which is one of: ``standard``, ``l1``, ``dr``, or ``rob``). 
- ``visualise.m`` and ``visualise_robust.m``: MATLAB functions to nicely display the SVM classifier determined from the previous functions. See ``svm_example.m`` for usage.
- ``svm_example``: MATLAB script that creates a simple dataset and runs each of the classifiers on it. Generates MATLAB figures for each (as seen in the report). 

### Section 4: Robust Comparison on Breast Cancer Dataset
The processed dataset and the previous model functions are included again in this folder for ease. New MATLAB files are:
- ``SVM.m``: a basic MATLAB class definition for an SVM model. Specialised classes are derived from this.
- ``standardSVM.m``, ``L1SVM.m``, ``DrSVM.m``, ``robustSVM.m``: specialised MATLAB classes for the four methods. Associated methods include ``fit``, ``predict``, ``retune`` and ``run``. 
- ``accuracy.m`` and ``f1_score.m``: functions to return the accuracy and F1-score for a prediction vector. Inputs: target vector, prediction vector.
- ``kfolds_index.m``: function that, given a training set and a number of folds ``kf_splits``, returns a cell of arrays, each containing indices for the training/test set to be split into for ``kf_splits``-folds cross validation.
- ``parameter_tune.m``: function that takes as input the model, the number of folds, ``X_train`` and ``y_train``, and performs k-folds cross validation to determine the optimal value of the hyperparameter for that model (note: particularly for the robust model, this function can take a very long time to run). 
- ``test_robustness.m``: MATLAB script that tests each of the models in the face of data uncertainty. Simply run the file in MATLAB or, if desired, you can alter some of the parameters defined within (e.g. the number of simnulations, the split value for training/test set, the degree of uncertainty, etc). 

**For any further clarity, please see the Jupyter notebooks included in this Github repo, for step by step examples. For notebooks 3 and 4, DO NOT RUN unless you have a working MATLAB kernel for Jupyter.** 
