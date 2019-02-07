
% optimize all data together
clear
close all

%% load parameters
run('load_parameters.m');

%% load data
eye_pose = importdata('.\data\abs_pupil_pose_rect.txt');
tic;

%% pre-filtering: using physical contraints to cleaning data
if use_opt_field
    % assume screen is inside the optimal vision field (explained in the load_parameters.m)
    thres_diff_updown = 2*radius_eye*sind(opt_upward)*f/CamFace_dist;
    thres_diff_lefrig = 2*radius_eye* sind(opt_left) *f/CamFace_dist;
else
    % assume screen is inside the maximal vision field (explained in the load_parameters.m)
    thres_diff_updown = radius_eye*( sind(max_upward) + sind(max_downward) )*f/CamFace_dist;
    thres_diff_lefrig = 2*radius_eye* sind(max_left) *f/CamFace_dist;
end 

% the width of the window to filter data = (the vanish time during every
% blinking + shortest time for eyes moving back and forth ) / (sample rate)
window_size = ceil( (vanish_time + min_backforth)/Proc_time );

% filter data and recover outliers with median value of the data within the window
[pose, time] = repair_outliers(eye_pose, thres_diff_updown, thres_diff_lefrig, window_size);

%% jointly optimize eye pose and screen-face distance
% Since the screen-face distance decides the thresholds for the filter
% above, which will affect the pose data, we believe that jointly optimize
% the two variables will improve the performance. If this doesn't work well,
% it is very easy to optimize the eye pose only. In addition, this joint
% filter is much faster than mosek and gurobi.
[opt_pose, sc_face_dist] = joint_filter(pose, f, inter_pupil_dist, maxiters, learn_rate_pose, learn_rate_dist, gama);

%% optimize eye pose using third party optimizer, such as mosek or gurobi.
% % Using third party optimizer costs a lot of time and it doesn't outperform
% % our joint filter above. So, we don't use it.
% opt_pose.left_x  = TV_reconstruction(pose.left_x , gama, 1);
% opt_pose.left_y  = TV_reconstruction(pose.left_y , gama, 1);
% opt_pose.right_x = TV_reconstruction(pose.right_x, gama, 1);
% opt_pose.right_y = TV_reconstruction(pose.right_y, gama, 1);

%% visulization
t = toc;
fprintf('The time for overall optimization is %.2f seconds. \n', t);

figure
hold on
grid on
plot(time, pose.left_x, 'r')
plot(time, opt_pose.left_x, 'b--')
plot(time, pose.right_x, 'k')
plot(time, opt_pose.right_x, 'g--')
legend('left_x', 'optimal left_x', 'right_x', 'optimal right_x')

figure
hold on
grid on
plot(time, pose.left_y, 'r')
plot(time, opt_pose.left_y, 'b--')
plot(time, pose.right_y, 'k')
plot(time, opt_pose.right_y, 'g--')
legend('left_y', 'optimal left_y', 'right_y', 'optimal right_y')

figure
hold on
grid on
plot(pose.left_x, pose.left_y, 'o-')
plot(pose.right_x, pose.right_y, '*-')
set(gca,'YDir','reverse')
legend('left eye', 'right_eye')

figure
hold on
grid on
plot(opt_pose.left_x, opt_pose.left_y, 'o-')
plot(opt_pose.right_x,opt_pose.right_y, '*-')
set(gca,'YDir','reverse')
legend('optimal left eye', 'optimal right_eye')

figure
hold on
grid on
plot(time, sc_face_dist)
xlabel('timestamps');
ylabel('distances');

figure
hold on
grid on
plot( sqrt( (opt_pose.left_x - opt_pose.right_x).^2 + (opt_pose.left_y - opt_pose.right_y).^2 ) * CamFace_dist/f , 'g');
plot( sqrt( (pose.left_x - pose.right_x).^2 + (pose.left_y - pose.right_y).^2 ) * CamFace_dist/f  , 'r' );
legend('optimal eye distance', 'original eye distance');