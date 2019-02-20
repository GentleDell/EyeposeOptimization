# Eye Tracking for computer-user interaction
This repository is a Matlab implementation of joint optimization on pupils tracking and screen-to -face distance estimation. The optimization can be performed in real-time. The eye tracking data is from [Tristan Hume](https://github.com/trishume)'s [eyelike](https://github.com/trishume/eyeLike).

## Research questions
1. How to recover outliers caused by blinking?
2. How to denoise the eye poses while keeping the real movements?
3. How to estimate the distance between face and screen? 

## What the projet have done
1. A 'median filter' (implemented in _median_filter.m_) is designed and outliers can be accurately detected and efficiently recovered. In order to compute the thresholds for outliers detection, some physical constraints are considered, such as the optimum eye rotations and average blinking time (can be found in the _load_parameters.m_). The following are the raw data from [eyelike](https://github.com/trishume/eyeLike) (left) and the filtered data from the _median_filter_ (right).
<p float="left">
  <img src="https://github.com/GentleDell/EyeposeOptimization/blob/master/data/original_data.png" title="raw pose data" width="400" />
  <img src="https://github.com/GentleDell/EyeposeOptimization/blob/master/data/deoutlier_data.png" title="after filtering" width="400" /> 
</p>

2. Inspired by the Total Variance norm, which preserves structure information of images, an optimization algorithm is implemented to estimate the eyes' poses while keeping pupils' movements. In order to jointly optimize the screen-to-face distance and eyes' poses, the perspective geometry of cameras is also considered as a part of the loss function. The average time of optimization over 485 pose data is 0.1 seconds. The left figure below is the raw eye poses from [eyelike](https://github.com/trishume/eyeLike) while the right is the eye poses after joint optimization.
<p float="left">
  <img src="https://github.com/GentleDell/EyeposeOptimization/blob/master/data/raw_eyepose.png" title="raw pose data" width="400" />
  <img src="https://github.com/GentleDell/EyeposeOptimization/blob/master/data/jointlyoptimal_eyepose_0_11s.png" title="after filtering" width="400" /> 
</p>

3. Since data come one by one from the [eyelike](https://github.com/trishume/eyeLike), a "streaming" version of optimization is provided, which can optimize data one by one. The average time of each optimization is around 0.03 seconds, decided by the number of data that will be optimized together, the max iterations and the value of the regularization term (in the loss function, Gama). The left figure is the results of streaming optimization with the average time of 0.05s per data and the right is the results that with the average time of 0.07s per data.
<p float="left">
  <img src="https://github.com/GentleDell/EyeposeOptimization/blob/master/data/jointlyoptimal_eyepose_streaming_0_05.png" title="avg time = 0.05s" width="400" />
  <img src="https://github.com/GentleDell/EyeposeOptimization/blob/master/data/jointlyoptimal_eyepose_streaming_0_07s.png" title="avg time = 0.07s" width="400" /> 
</p>

4. We implemented the streaming optimization algorithm in Cpp and the optimized eyeposes are shown below. The left figure corresponds to maxiteration of 1000 while the maxiteration of the left figure is 300. However, the fastest version in Cpp takes around 0.1 ms per data, which is much slower than Matlab codes. Therefore, the next step is to accelerate the Cpp codes.
<p float="left">
  <img src="https://github.com/GentleDell/EyeposeOptimization/blob/master/data/jointlyoptimal_eyepose_streaming_0_38sCpp.png" title="maxiteration = 1000" width="400" />
  <img src="https://github.com/GentleDell/EyeposeOptimization/blob/master/data/jointlyoptimal_eyepose_streaming_0_1sCpp.png" title="maxiteration = 300" width="400" /> 
</p>

## Codes structure
- main: the main function for overall optimziation;
- main_streaming: the main function for streaming optimzation;  

## Future works
To embed this optimization algorithm to [eyelike](https://github.com/trishume/eyeLike), we will convert the codes to C++ and reorganize codes structure of eyelike.
