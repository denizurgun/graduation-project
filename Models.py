# -*- coding: utf-8 -*-
"""
Created on Wed May 12 22:06:10 2021

@author: 

GRADUATION PROJECT : DEEP LEARNING BASED DECODER IN MASSIVE MIMO CHANNELS

"""


import tensorflow.compat.v1 as tf
import numpy as np


def piecewise_linear_soft_sign(x):
    t = tf.Variable(0.1)
    psi = -1+tf.nn.relu(x+t)/(tf.abs(t)+0.00001)-tf.nn.relu(x-t)/(tf.abs(t)+0.00001)
    return psi

def ara_katman(x,input_size,output_size,Layer_num):
    W = tf.Variable(tf.random_normal([input_size, output_size], stddev=0.01))
    b = tf.Variable(tf.random_normal([1, output_size], stddev=0.01))
    y = tf.matmul(x, W)+b
    return y

def relu_katmani(x,input_size,output_size,Layer_num):
    y = tf.nn.relu(ara_katman(x,input_size,output_size,Layer_num))
    return y

def sign_katmani(x,input_size,output_size,Layer_num):
    y = piecewise_linear_soft_sign(ara_katman(x,input_size,output_size,Layer_num))
    return y


class Model:
    def __init__(self,Nt,v_size):
        
        self.HY = tf.placeholder(tf.float32,shape=[None,Nt])
        self.X = tf.placeholder(tf.float32,shape=[None,Nt])
        self.HH = tf.placeholder(tf.float32,shape=[None, Nt , Nt])
        
        self.batch_size = tf.shape(self.HY)[0] #equal to B parameter.
        self.X_LS = tf.matmul(tf.expand_dims(self.HY,1),tf.matrix_inverse(self.HH)) #Matris çarpımı yapılabilmesi için HY'nin boyutu 1 arttırıldı, 1 eksen eklendi. X_LS = HY*(HH')
        self.X_LS= tf.squeeze(self.X_LS,1)     #1 eksen kaldırır.
        self.loss_LS = tf.reduce_mean(tf.square(self.X - self.X_LS))  #LOSS Function Hesaplandı.
        self.ber_LS = tf.reduce_mean(tf.cast(tf.not_equal(self.X,tf.sign(self.X_LS)), tf.float32))
        
        self.S=[]
        self.S.append(tf.zeros([self.batch_size,Nt]))  #Xk+1
        self.V=[]
        self.V.append(tf.zeros([self.batch_size,v_size]))  #Vk+1
        self.LOSS=[]
        self.LOSS.append(tf.zeros([]))
        self.BER=[]
        self.BER.append(tf.zeros([]))

        
    def Det_Net(self,Nt, v_size, hidden_size, LOG_LOSS,L,residual_ft_alpha): #
        
        for i in range(1,L):
            temp_s = tf.matmul(tf.expand_dims(self.S[-1],1),self.HH)  
            temp_s= tf.squeeze(temp_s,1)
            Z = tf.concat([self.HY,self.S[-1],temp_s,self.V[-1]],1)
            ZZ = relu_katmani(Z,3*Nt + v_size , hidden_size,'relu'+str(i))
            self.S.append(sign_katmani(ZZ , hidden_size , Nt,'sign'+str(i)))
            self. S[i]=(1-residual_ft_alpha)*self.S[i]+residual_ft_alpha*self.S[i-1]  #residual feature
            self.V.append(ara_katman(ZZ , hidden_size , v_size,'aff'+str(i)))
            self.V[i]=(1-residual_ft_alpha)*self.V[i]+residual_ft_alpha*self.V[i-1]   #residual feature
            if LOG_LOSS == 1:
            	self.LOSS.append(np.log(i)*tf.reduce_mean(tf.reduce_mean(tf.square(self.X - self.S[-1]),1)/tf.reduce_mean(tf.square(self.X - self.X_LS),1)))  #X - Xk+1 -- (İletilen - tahmin edilen)^2 
            else:
                self.LOSS.append(tf.reduce_mean(tf.reduce_mean(tf.square(self.X - self.S[-1]),1)/tf.reduce_mean(tf.square(self.X - self.X_LS),1)))            # X_LS : the standard decorrelator decoder., S: Her adımda tahmin edilen xk
            self.BER.append(tf.reduce_mean(tf.cast(tf.not_equal(self.X,tf.sign(self.S[-1])), tf.float32))) #X in xk'ya eşit olmadığı yerlerde hata sayar.
        
        return self.LOSS



