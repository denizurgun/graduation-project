# -*- coding: utf-8 -*-
"""
Created on Fri May 14 22:04:36 2021

@author: 

GRADUATION PROJECT : DEEP LEARNING BASED DECODER IN MASSIVE MIMO CHANNELS

"""

import numpy as np
import time as tm
import math
import sys
import pickle as pkl
import tensorflow.compat.v1 as tf
from generate_data import get_data
from Models import Model,__init__
import matplotlib.pyplot as plt


sess = tf.InteractiveSession()
tf.disable_v2_behavior() 
#parameters
Nt = 20 # 2
Nr = 30 # 3
SNRdB_low = 7.0
SNRdB_high = 14.0
SNR_low = 10.0 ** (SNRdB_low/10.0)
SNR_high = 10.0 ** (SNRdB_high/10.0)
L=30
v_size = 2*Nt #4
hidden_size = 8*Nt #16
LearningRate = 0.0001
decay_rate = 0.97
decay_size = 1000
training_iteration = 10000
train_batch_size = 5000
test_iteration= 10000
test_batch_size = 1000
LOG_LOSS = 1
residual_ft_alpha=0.9
snr_no = 14
SNRdB_low_test=1.0
SNRdB_high_test=14.0


model = Model(Nt,v_size)
loss = model.Det_Net(Nt, v_size, hidden_size, LOG_LOSS,L,residual_ft_alpha)
# loss = model.Det_Net(Nt, v_size, hidden_size, LOG_LOSS,L)
TOTAL_LOSS=tf.add_n(loss)

global_step = tf.Variable(0, trainable=False)
decayLR= tf.train.exponential_decay(LearningRate, global_step, decay_size, decay_rate, staircase=True)  #Learning rate en başta yüksek verilip giderek azaltılmıştır.
train_step = tf.train.AdamOptimizer(decayLR).minimize(TOTAL_LOSS)  #Train aşaması



init_op=tf.initialize_all_variables()
sess.run(init_op) #tensorflow session'ı başlatılır

loss_array = []
loss_array1 = []
loss_array2 = []

#Training DetNet
for i in range(training_iteration): #num of train iter
    batchY, batchH, batchHY, batchHH, batchX , SNR1= get_data(train_batch_size,Nt,Nr,SNR_low,SNR_high)
    train_step.run(feed_dict={model.HY: batchHY, model.HH: batchHH, model.X: batchX})  #training 
    if i % 100 == 0 :
        batchY, batchH, batchHY, batchHH, batchX ,SNR1= get_data(train_batch_size,Nt,Nr,SNR_low,SNR_high)  #update values -- perform mini batch update her 100 iterasyonda bir 
        results = sess.run([model.loss_LS, model.LOSS[L-1], model.ber_LS, model.BER[L-1]], {model.HY: batchHY, model.HH: batchHH, model.X: batchX})                    # parametreleri güncelle.
        loss_array.append(results[0])
        loss_array1.append(results[1]) #LOSS List
        loss_array2.append(results[3]) #Ber list for each layer
        


Xr_ = np.zeros([snr_no,test_iteration,test_batch_size,Nt])
Xt_ = np.zeros([snr_no,test_iteration,test_batch_size,Nt])

#Testing the trained model
SNRdB_list = np.linspace(SNRdB_low_test,SNRdB_high_test,snr_no)
SNR_list = 10.0 ** (SNRdB_list/10.0)
BERS = np.zeros((1,snr_no))
TIME = np.zeros((1,snr_no))
temp_bers= np.zeros((1,test_iteration))
temp_times = np.zeros((1,test_iteration))
for j in range(snr_no):
    for jj in range(test_iteration):
        batchY, batchH, batchHY, batchHH, batchX ,SNR1= get_data(test_batch_size , Nt,Nr,SNR_list[j],SNR_list[j])
        Xt_[j,jj,:,:] = batchX
        tic = tm.time()
        [temp_bers[:,jj], Xr_[j,jj,:,:]] = np.array(sess.run([model.BER[L-1],model.S[L-1]], {model.HY: batchHY, model.HH: batchHH, model.X: batchX}))    
        toc = tm.time()
        temp_times[0][jj] = toc - tic
    BERS[0][j] = np.mean(temp_bers,1)
    TIME[0][j] = np.mean(temp_times[0])/test_batch_size

print('SNRdB_list')
print(SNRdB_list)
print('BERS')
print(BERS)
print('TIME')
print(TIME)        
    
#%% Plot Graph

plt.plot(np.arange(len(loss_array1)), loss_array1)
# plt.plot(np.arange(len(loss_array2)), loss_array2)

#%% Save the data
import csv

with open('XT.csv', 'w', newline='') as file:
    for j in range(snr_no):
        for jj in range(test_iteration):
            for k in range(test_batch_size):
                        mywriter = csv.writer(file, delimiter=',')
                        mywriter.writerow(Xt_[j,jj,k,:])
                        
with open('XR.csv', 'w', newline='') as file:
    for j in range(snr_no):
        for jj in range(test_iteration):
            for k in range(test_batch_size):
                        mywriter1 = csv.writer(file, delimiter=',')
                        mywriter1.writerow(Xr_[j,jj,k,:])
    
with open('loss_20x30.csv', 'w', newline='') as file:
    mywriter = csv.writer(file, delimiter=',')
    mywriter.writerow(loss_array1)
    
with open('ber_list_layers_20x30.csv', 'w', newline='') as file:
    mywriter = csv.writer(file, delimiter=',')
    mywriter.writerow(loss_array2)
    
with open('snrdblist_20x30.csv', 'w', newline='') as file:
    mywriter = csv.writer(file, delimiter=',')
    mywriter.writerow(SNRdB_list)       

with open('bers_20x30.csv', 'w', newline='') as file:
    mywriter = csv.writer(file, delimiter=',')
    mywriter.writerow(BERS)      
    
with open('times_20x30.csv', 'w', newline='') as file:
    mywriter = csv.writer(file, delimiter=',')
    mywriter.writerow(TIME)  







