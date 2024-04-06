from sklearn.model_selection import GridSearchCV
from keras.wrappers.scikit_learn import KerasClassifier
import sklearn
import tensorflow
import keras
from keras.models import Sequential
from keras.layers import LSTM, Dense, Dropout
from sklearn.model_selection import train_test_split
import ast
import os
from keras.utils import to_categorical
import numpy as np
#https://www.analyticsvidhya.com/blog/2021/06/tune-hyperparameters-with-gridsearchcv/



def Get_Dataset (dataset, labels):
    f = open("Dataset.txt", "r")
    f.readline()
    f.readline()
    
    for line in f:
        
        split_line = line.split(",",1)
        labels.append(split_line[0])
        dataset_line = split_line[1]
        list_of_tuples = ast.literal_eval(dataset_line)
        dataset.append( list_of_tuples[0] )
    f.close()   

dataset= []
labels = []
#Now we need to fill dataset and labels
Get_Dataset(dataset,labels)
print("got dataset")

numpy_dataset = np.array(dataset)

from sklearn.model_selection import train_test_split

labels_one_hot = to_categorical(labels, num_classes=31)


data_reshape = numpy_dataset.reshape(numpy_dataset.shape[0], numpy_dataset.shape[1], numpy_dataset.shape[2] * numpy_dataset.shape[3])

datasetTrain, datasetsplit, labelsTrain, labelssplit = sklearn.model_selection.train_test_split(data_reshape, labels_one_hot, test_size=0.2, random_state=42)

datasetValuation, datasetTest, labelValuation, labelTest = sklearn.model_selection.train_test_split(datasetsplit, labelssplit, test_size=0.5)

from keras.optimizers import Adam

def create_model(learning_rate=0.001, dropout_rate=0.2):
    model = Sequential([
        LSTM(128, input_shape=(10, 150)),
        Dense(64, activation='relu'),
        Dropout(dropout_rate),
        Dense(31, activation='softmax')
    ])
    optimizer = Adam(learning_rate=learning_rate)
    model.compile(loss='categorical_crossentropy', optimizer=optimizer, metrics=['accuracy'])
    return model

# Create a KerasClassifier
model = KerasClassifier(build_fn=create_model, epochs=10, batch_size=32, verbose=0)

# Define the parameter grid
param_grid = {
    'learning_rate': [0.001, 0.01, 0.1],
    'dropout_rate': [0.2, 0.3, 0.4]
}

# Instantiate GridSearchCV
grid_search = GridSearchCV(estimator=model, param_grid=param_grid, cv=3)

grid_result = grid_search.fit(datasetTrain, labelsTrain)

# Print results
print("Best: %f using %s" % (grid_result.best_score_, grid_result.best_params_))
 
best_model = create_model(grid_result.best_params_) 
loss, accuracy = best_model.evaluate(datasetTest, labelTest)
print(f'Test Loss: {loss}, Test Accuracy: {accuracy}')