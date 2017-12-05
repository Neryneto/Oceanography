# -*- coding: utf-8 -*-
"""
Created by Nery Contti Neto 
on Sun Nov 19 19:08:30 2017

PhD Candidate at University of Western Australia
School of Earth and Sciences.

This function excludes spike noise from Acoustic Doppler Velocity (ADP) using 
the phase-space method by Goring and Nikora (2002). Based on Nobuhito Mori
Matlab Algorithm

The method combines three assumptions:
   1. differentiation enhances the high frequency portion of a signal
   2. the expected maximum of a random series is given by the Universal 
      threshold from Donoho and Johnstone (1994)
   3. good data clusters in a dense cloud in phase space or Poincare maps. 
 
These concepts are used to construct an ellipsoid in three-dimensional 
phase space with points lying outside the ellipsoid are designated as 
spikes. 

 SYNTAX: cleandata = PhaseSpaceDespike(rawdata, varargin)

 INPUT:
   velx    : input x-direction velocity component
   vely    : input y-direction velocity component
   velz    : input z-direction velocity component
   
Spikes are returned as nan values
"""

import numpy as np
import math

def ExcludeOutlierEllipsoid3D (xi,yi,zi,theta,universalThreshold):
    #This function excludes the points outside of ellipsoid in 2D domain
    #xi,yi,zi are input x, y and z data
    #theta is the angle between xi and zi

    if theta == 0:
        X = xi
        Y = yi
        Z = zi
    else:
        X = xi*math.cos(theta) + zi*(math.sin(theta))
        Y = yi
        Z = xi*((-1)*math.sin(theta)) + zi*(math.cos(theta))

    a = universalThreshold * np.nanstd(X,ddof=1)
    b = universalThreshold * np.nanstd(Y,ddof=1)
    c = universalThreshold * np.nanstd(Z,ddof=1)
    m = 0

    x2 = [a * b * c * X[i]/np.sqrt((a * c * Y[i])**2 + b**2 * (c**2*(X[i])**2+a**2*(Z[i])**2)) for i in range(len(X))]
    y2 = [a * b * c * Y[i]/np.sqrt((a * c * Y[i])**2 + b**2 * (c**2*X[i]**2+a**2*Z[i]**2)) for i in range(len(X))]
    zt = c**2*(1 - (x2/a)**2 - (y2/b)**2)
    i=0
    z2=[]
    for i in range(len(Z)):
        z2.append((-1 if Z[i]<0 else 1) * np.sqrt(zt[i]))
       
    #check outlier for the ellipsoid
    distance = (np.square(x2) + np.square(y2) + np.square(z2)) - (np.square(xi) + np.square(yi) + np.square(zi))

    ind = np.argwhere(distance < 0)
    m = len(ind)
    xp = [] 
    yp = []
    zp = []
    coef = [a,b,c]
    xp.append (xi[ind])
    yp.append (yi[ind])
    zp.append (zi[ind])

    return (xp,yp,zp,m,ind,coef)

def PhaseSpaceDespike1d(vel):
    #This function exclude spike noises in ADV
    numberMaxIteration = 20
    numberLoop = 1
    f_mean = 0
    n_out = 999
    
    universalThreshold = np.sqrt(2*np.log(len(vel)))  

    while  (n_out > 0 & numberLoop <= numberMaxIteration):

        #Step 0 - accumulate offset value at each step
        f_mean = f_mean + np.nanmean(vel)
        vel = vel - np.nanmean(vel)

        #Step 1 - First and second derivative (central differences method)
        firstDerivative = np.gradient(vel)
        secondDerivative = np.gradient(firstDerivative)
    
        #Step 2 - Estimate angle between first and second Derivatives
        if numberLoop == 1:
            theta = np.arctan2(np.nansum(vel*secondDerivative), np.nansum([i**2 for i in vel]))
            
        #Step 3 - checking outlier in the 3D phase space
        excludedXx,excludedXy,excludedXz,m,ind,coef = ExcludeOutlierEllipsoid3D (vel,firstDerivative, secondDerivative, theta, universalThreshold)
        
        #Step 4 - Attribute nan values to the array
        n_nan_1 = sum(np.isnan(vel))
        vel[ind] = None
        n_nan_2 = sum(np.isnan(vel))
        n_out = n_nan_2 - n_nan_1
        
        #End of the loop
        numberLoop +=1
        print ("Number of iteration = ", numberLoop-1)

    vel = vel + f_mean
    
    return (firstDerivative, secondDerivative, vel, theta, universalThreshold)

firstDerivativeX, secondDerivativeX, velx, thetaX, universalThreshold = PhaseSpaceDespike1d(velx)
firstDerivativeY, secondDerivativeY, vely, thetaY, universalThreshold = PhaseSpaceDespike1d(vely)
firstDerivativeZ, secondDerivativeZ, velz, thetaZ, universalThreshold = PhaseSpaceDespike1d(velz)
