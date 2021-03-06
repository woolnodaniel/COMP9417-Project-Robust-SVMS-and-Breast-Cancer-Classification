#!/usr/bin/python3

"""
basic_models.py: create and test several base models on the (preprocessed) breast
    cancer dataset.
"""

import pandas as pd
import numpy as np
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--split',type=float,default=0.2,help='float: dataset to test split proportion')
parser.add_argument('--model',type=str,default='ALL',help='string: {DT, GNB, NN, SVM, ALL}: model to test')
parser.add_argument('--search',type=bool,default=False,help='bool: set True if wanting to see results of \
            grid search for regularisation parameter for SVM (default False)')
parser.add_argument('--disable_warnings',type=bool,default=True,help='bool: set to False if warnings are desired.')
parser.add_argument('--average',type=int,default=1,help='int: take an average over that many simulations (default 1).')
parser.add_argument('--verbose',type=bool,default=False,help='bool: set true if want to see output of each simulation. \
            If false, display only first 5 simulations results, and the final averages.')
args = parser.parse_args()

DT, GNB, NN, SVM = False, False, False, False
if args.model == 'ALL':
    DT, GNB, NN, SVM = True, True, True, True
elif args.model == 'DT':
    DT = True
elif args.model == 'GNB':
    GNB = True
elif args.model == 'NN':
    NN = True
elif args.model == 'SVM':
    SVM = True

if args.disable_warnings:
    def warn(*args, **kwargs):
        pass
    import warnings
    warnings.warn = warn

from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, f1_score
from sklearn.tree import DecisionTreeClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.neural_network import MLPClassifier
from sklearn.svm import SVC

# import preprocessed dataset
ds = pd.read_csv('processed_data.csv')

DT_accs, GNB_accs, NN_accs, SVM_accs = [], [], [], []
DT_f1, GNB_f1, NN_f1, SVM_f1 = [], [], [], []

for i in range(args.average):

    # split into features/target and training/test set
    X = ds.drop('diagnosis', axis=1)
    y = ds['diagnosis']
    X_train, X_test, y_train, y_test = train_test_split(X,y,test_size=args.split)
    num_training_items = X_train.shape[0]
    num_test_items = X_test.shape[0]

    # Decision Tree
    if DT:
        tree = DecisionTreeClassifier(criterion='entropy', min_samples_leaf=round(0.02*num_training_items))
        tree.fit(X_train,y_train)
        pred = tree.predict(X_test)
        acc = accuracy_score(y_test, pred)
        f1 = f1_score(y_test, pred)
        DT_accs.append(acc)
        DT_f1.append(f1)
        if args.verbose or i < 5:
            print(f'i = {i}: Decision Tree Accuracy: {acc:.4}; F1 Score: {f1:.4}')


    # Gaussian Naive Bayes
    if GNB:
        features_to_keep = ['radius_worst', 'texture_worst', 'perimeter_worst', 'area_worst', 'smoothness_worst', \
                      'compactness_worst', 'concavity_worst', 'concave points_worst', 'symmetry_worst', 'fractal_dimension_worst']
        X_train_NB = X_train[features_to_keep]
        X_test_NB = X_test[features_to_keep]
        gnb = GaussianNB()
        gnb.fit(X_train_NB,y_train)
        pred = gnb.predict(X_test_NB)
        acc = accuracy_score(y_test, pred)
        f1 = f1_score(y_test, pred)
        GNB_accs.append(acc)
        GNB_f1.append(f1)
        if args.verbose or i < 5:
            print(f'i = {i}: Gaussian NB Accuracy: {acc:.4}; F1 Score: {f1:.4}')

    if NN:
        num_features = X_train.shape[1]
        nn = MLPClassifier(hidden_layer_sizes=(2*num_features,), activation='tanh', \
                           solver='sgd', learning_rate='adaptive', learning_rate_init=0.1)
        nn.fit(X_train,y_train)
        pred = nn.predict(X_test)
        acc = accuracy_score(y_test, pred)
        f1 = f1_score(y_test, pred)
        NN_accs.append(acc)
        NN_f1.append(f1)
        if args.verbose or i < 5:
            print(f'i = {i}: Neural Network Accuracy: {acc:.4}; F1 Score: {f1:.4}')

    if SVM:
        svm = SVC(C=0.05, kernel='linear', gamma='scale')
        svm.fit(X_train, y_train)
        pred = svm.predict(X_test)
        acc = accuracy_score(y_test, pred)
        f1 = f1_score(y_test, pred)
        SVM_accs.append(acc)
        SVM_f1.append(f1)
        if args.verbose or i < 5:
            print(f'i = {i}: Support Vector Machine Accuracy: {acc:.4}; F1 Score: {f1:.4}')

if args.average > 1:
    if DT:
        print(f'Decision Tree Accuracy: {np.mean(DT_accs):.4}; F1 Score: {np.mean(DT_f1):.4}')
    if GNB:
        print(f'Gaussian NB Accuracy: {np.mean(GNB_accs):.4}; F1 Score: {np.mean(GNB_f1):.4}')
    if NN:
        print(f'Neural Network Accuracy: {np.mean(NN_accs):.4}; F1 Score: {np.mean(NN_f1):.4}')
    if SVM:
        print(f'Support Vector Machine Accuracy: {np.mean(SVM_accs):.4}; F1 Score: {np.mean(SVM_f1):.4}')

if args.search:
    print('----------------------------------------------')
    print(f'Performing Grid Search for SVM Regularisation:')
    regs = np.arange(0,1.01,0.05)
    regs[0] = 0.01
    best_acc = 0.0
    best_r = 0
    for r in regs:
        svm = SVC(C=r, kernel='sigmoid', gamma='scale')
        _ = svm.fit(X_train, y_train)
        acc = svm.score(X_test, y_test)
        if acc > best_acc:
            best_acc = acc
            best_r = r
    print(f'>>> Highest Accuracy of {best_acc} achieved by r = {best_r}')














