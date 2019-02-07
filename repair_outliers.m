function [pose, time] = repair_outliers( eye_pose, thres_updown, thres_lefrig, window_size)
%repair_outliers: recover outliers using median value.
%   Calling the median_filter to detect and recover outliers.

% pick 4 data
time    = eye_pose(:,1) - eye_pose(1,1);
pose.left_x  = eye_pose(:,2);
pose.left_y  = eye_pose(:,3);
pose.right_x = eye_pose(:,4);
pose.right_y = eye_pose(:,5);

% % visualize original data
% figure
% hold on
% grid on
% plot(time, pose.left_x, 'r')
% plot(time, pose.right_x, 'k')
% plot(time, pose.left_y, 'b')
% plot(time, pose.right_y, 'c')
% xlabel('timestamp');
% ylabel('value in pixel');
% legend('origin left_x', 'origin right_x', 'origin left_y', 'origin right_y')

% correct positions
[ pose.left_x, pose.right_x ] = median_filter( pose.left_x, pose.right_x, window_size, thres_lefrig);
[ pose.left_y, pose.right_y ] = median_filter( pose.left_y, pose.right_y, window_size, thres_updown);

end