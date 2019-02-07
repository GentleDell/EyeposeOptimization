%% Given parameters
% average radius of eyeballs
radius_eye = 0.012; % meters

% optimum eye rotation
% opt means:"placement of objects in one¡¯s visual field for best
% recognition should take into account that optimum eye rotation"
% ref: [1] Human Dimension & Interior Space, 1979.
%      [2] http://www.hazardcontrol.com/factsheets/humanfactors/visual-acuity-and-line-of-sight
% Here we assume that people prefre to place screen in their optimal field
use_opt_field = true;
opt_upward    = 15;
opt_downward  = 15;
opt_left      = 15;
opt_right     = 15;
max_upward    = 25;
max_downward  = 30;
max_left      = 35;
max_right     = 35;

% interpupillary distance
% ref: Interpupillary Distance Measurements among Students in the Kumasi Metropolis
inter_pupil_dist = 0.063; % [ 59 - 67 mm]

% binking time
% ref: https://core.ac.uk/download/pdf/37456352.pdf
blinking_freq = 20;    % times per minutes, during conversation: 3-5 seconds; reading/watching: 5-10 seconds;
blinking_time = 0.3;   % time for blinking, seconds
vanish_time = blinking_time/2;   % loss only in a part of time

% initiatial distance between camera and face
% will be updated 
CamFace_dist = 0.65;

%% Measured parameters
% time ( in seconds ) to capture an image from cameras, given by Cpp codes
Proc_time = 0.06;    
FPS = 1/Proc_time;

% focal length ( in pixel ) of the front camera of my laptop, given by opencv camera calibration codes
f =  785.61928174049433;

% parameters that still need supports from researches
min_backforth = 0.2; % seconds for returning move, my eyes, if continuously move the max freq should be lower I guess
avg_eyespeed  = 0.5; % my eyes, when I focus on something.  

%% Hyperparameters
% hyperparameters to be adjusted by hand
% initial frames for streaming
initial_frames = 15;

% max iterations
maxiters = 1000;

% regularization parameter
gama = 5;  % regularization parameter
gama_str = 300; 

% learning rate for eye pose and screen-face distance
% -- for GD, all data optimized together
learn_rate_pose = 0.01;    % pixel 
learn_rate_dist = 0.00001; % meter
% -- for SGD and streaming optimization
learn_rate_pose_str = 0.0002;    % pixel 
learn_rate_dist_str = 0.0000002; % meter