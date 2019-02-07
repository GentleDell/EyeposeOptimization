
% optimize eyes' poses one by one in streaming
clear
close all

%% load parameters
run('load_parameters.m');

%% load data
eye_pose_all = importdata('.\data\abs_pupil_pose_rect.txt');

%% calculate threshold, jointly optimize eye pose and screen-face distance and pre-filtering: using physical contraints to cleaning data
if use_opt_field
    % assume screen is inside the optimal vision field (explained in the load_parameters.m)
    thres_diff_updown = 2*radius_eye*sind(opt_upward)*f/CamFace_dist;
    thres_diff_lefrig = 2*radius_eye* sind(opt_left) *f/CamFace_dist;
else
    % assume screen is inside the maximal vision field (explained in the load_parameters.m)
    thres_diff_updown = radius_eye*( sind(max_upward) + sind(max_downward) )*f/CamFace_dist;
    thres_diff_lefrig = 2*radius_eye* sind(max_left) *f/CamFace_dist;
end 

% Initialization of eyepose
eye_pose = eye_pose_all(1:initial_frames,:);
str_pose = [];

tic;
for ct = initial_frames+1 : size(eye_pose_all,1)
    
    % Streaming data
    eye_pose = [eye_pose; eye_pose_all(ct,:)];
    
    % Proc_time will be updated in every 10 frames
    window_size = ceil( (vanish_time + min_backforth)/Proc_time );
    
    [pose, time] = repair_outliers(eye_pose, thres_diff_updown, thres_diff_lefrig, window_size);

    [opt_pose, sc_face_dist] = joint_filter(pose, f, inter_pupil_dist, maxiters, learn_rate_pose_str, learn_rate_dist_str, gama_str);
    
    if ct == initial_frames+1
        str_pose = opt_pose;
    else
        str_pose.left_x = [str_pose.left_x; opt_pose.left_x(end)];
        str_pose.left_y = [str_pose.left_y; opt_pose.left_y(end)];
        str_pose.right_x = [str_pose.right_x; opt_pose.right_x(end)];
        str_pose.right_y = [str_pose.right_y; opt_pose.right_y(end)];
    end
    
    % delete the first data
    eye_pose(:, 2) = pose.left_x;
    eye_pose(:, 3) = pose.left_y;
    eye_pose(:, 4) = pose.right_x;
    eye_pose(:, 5) = pose.right_y;
    eye_pose(1, :)  = [];

end
t = toc;
fprintf('average time for each loop is %.2f s\n', t/size(eye_pose_all,1)); 

%% visulization
figure
hold on
grid on
plot(eye_pose_all(:,1), eye_pose_all(:,2), 'r')
plot(eye_pose_all(:,1), str_pose.left_x, 'b--')
plot(eye_pose_all(:,1), eye_pose_all(:,4), 'k')
plot(eye_pose_all(:,1), str_pose.right_x, 'g--')
legend('left_x', 'optimal left_x', 'right_x', 'optimal right_x')

figure
hold on
grid on
plot(eye_pose_all(:,1), eye_pose_all(:,3), 'r')
plot(eye_pose_all(:,1), str_pose.left_y, 'b--')
plot(eye_pose_all(:,1), eye_pose_all(:,5), 'k')
plot(eye_pose_all(:,1), str_pose.right_y, 'g--')
legend('left_y', 'optimal left_y', 'right_y', 'optimal right_y')

figure
hold on
grid on
plot(eye_pose_all(:,2), eye_pose_all(:,3), 'o-')
plot(eye_pose_all(:,4), eye_pose_all(:,5), '*-')
set(gca,'YDir','reverse')
legend('left eye', 'right_eye')

figure
hold on
grid on
plot(str_pose.left_x, str_pose.left_y, 'o-')
plot(str_pose.right_x,str_pose.right_y, '*-')
set(gca,'YDir','reverse')
legend('optimal left eye', 'optimal right_eye')

figure
hold on
grid on
plot( sqrt( (str_pose.left_x - str_pose.right_x).^2 + (str_pose.left_y - str_pose.right_y).^2 ) * CamFace_dist/f , 'g');
plot( sqrt( (eye_pose_all(:,2) - eye_pose_all(:,4)).^2 + (eye_pose_all(:,3) - eye_pose_all(:,5)).^2 ) * CamFace_dist/f  , 'r' );
legend('optimal eye distance', 'original eye distance');