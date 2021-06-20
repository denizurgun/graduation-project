# -*- coding: utf-8 -*-
"""
Created on Wed May 12 23:08:11 2021

@author: 

GRADUATION PROJECT : DEEP LEARNING BASED DECODER IN MASSIVE MIMO CHANNELS

"""
import numpy as np

def get_data(B,Nt,Nr,snr_low,snr_high):
    H_=np.random.randn(B,Nr,Nt)
    x_=np.sign(np.random.rand(B,Nt)-0.5) #transmitted BPSK signal 
    y_=np.zeros([B,Nr])
    n=np.random.randn(B,Nr) # gürültü
    Hy_=x_*0                            #0'a initiliaze
    HH_=np.zeros([B,Nt,Nt])               #0'a initiliaze
    SNR_= np.zeros([B])                 #0'a initiliaze
    for i in range(B):  #Batchsize boyutunda data oluşturulur
        SNR = np.random.uniform(low=snr_low,high=snr_high) #sınır SNR değerlerinde random SNR seçilir.
        H=H_[i,:,:]              #H(1,N,Nt) boyutunda her bir adımda alınarak işleme sokulur.
        snr_temp=(H.T.dot(H)).trace()/Nt
        H=H/np.sqrt(snr_temp)*np.sqrt(SNR)
        H_[i,:,:]=H
        y_[i,:]=(H.dot(x_[i,:])+n[i,:])  # y = H*x + n*(normalize güç) *np.sqrt(snr_temp)/np.sqrt(SNR)
        Hy_[i,:]=H.T.dot(y_[i,:])
        HH_[i,:,:]=H.T.dot( H_[i,:,:])
        SNR_[i] = SNR
    return y_,H_,Hy_,HH_,x_,SNR_