# Eye Tracking for computer-user interaction
This repository is a matlab implementation of joint optimization on pupils tracking and screen-to -face distance estimation. The optimization can be performed in realtime. The pupils trakcing is based on [Tristan Hume](https://github.com/trishume)'s [eyelike](https://github.com/trishume/eyeLike).

## Research questions
1. How to recover outliers caused by blinking?
2. How to denoise the eye poses while keeping the real movements?
3. How to estimate the distance between face and screen? 

## What the projet have done
1. A 'median filter' (implemented in _median_filter.m_) is designed and outliers can be accurately detected and efficiently recovered. In order to compute the thresholds for outliers detection, some physical constraints are considered, such as the optimum eye rotations and average binking time (can be found in the _load_parameters.m_). 
<p float="left">
  <img src="" title="raw pose data" width="400" />
  <img src="" title="after filtering" width="400" /> 
</p>

2. Inspired by the Total Variance norm, which preserves structure information of images, an optimzaition algorithm is implemented to estimate the eyes' poses while keeping pupils' movements. In order to jointly optimize the screen-to-face distance and eyes' poses, the perspective geometry of cameras is also considered as a part of loss funtion. 
<p float="left">
  <img src="" title="raw pose data" width="400" />
  <img src="" title="after filtering" width="420" /> 
</p>

## Codes structure
- main: the main function for overall optimziation;
- main_streaming: the main function for streaming optimzation;  
- other files have been commented in detail.

## Future works
To embed this optimization aplgorithm with [eyelike](https://github.com/trishume/eyeLike), we will convert the codes to C++ and reorganize codes structure of eyelike.