function [opt_pose, sc_face_dist] = joint_filter(pose, f, inter_pupil_dist, maxiters, init_rate_pose, init_rate_dist, Gama)
%joint_filter: jointly optimize screen-face distances and eyeposes
%   using gradient descent method to iteratively optimize eyepose and
%   screen-face distance, with a joint cost funtion.

N                = length(pose.left_x);   % number of data
total_loss       = zeros(1,maxiters);     % total loss
sc_face_dist     = 0.63 * ones(N,1);      % in general, the distance is in [40 - 70] cm
opt_pose.left_x  = pose.left_x;           % directly initialize poses with measurements
opt_pose.left_y  = pose.left_y;
opt_pose.right_x = pose.right_x;
opt_pose.right_y = pose.right_y;

for ct = 1:maxiters
    % implement adaptive learning rate to achieve better solution. Using
    % log function as the decaying factor.
    learn_rate_pose = init_rate_pose/(log(ct+exp(1))); 
    learn_rate_dist = init_rate_dist/(log(ct+exp(1)));
    
    % compute loss 
    Loss = compute_loss(opt_pose, pose, sc_face_dist, f, inter_pupil_dist, Gama);
    
    % compute gradients of eye pose and screen-face distance
    [grad_pose, grad_dist] = compute_gradient(opt_pose, pose, sc_face_dist, Loss.smTri_errs, Gama);
    
    % update eye pose and screen-face distance
    opt_pose.left_x  = opt_pose.left_x - learn_rate_pose * grad_pose.left_x;
    opt_pose.left_y  = opt_pose.left_y - learn_rate_pose * grad_pose.left_y;
    opt_pose.right_x  = opt_pose.right_x - learn_rate_pose * grad_pose.right_x;
    opt_pose.right_y  = opt_pose.right_y - learn_rate_pose * grad_pose.right_y;
    sc_face_dist = sc_face_dist - learn_rate_dist*grad_dist;
    
    % record total loss for visualization
    total_loss(ct) = Loss.total_loss;
    
    % if the differences between loss_t and loss t-1 are less than 0.005,
    % the loss will be treated as converged. 
    if ct >= 100 && abs(total_loss(ct) - total_loss(ct-1)) <= 0.005
        fprintf('The loss has converged.\n')
        break
    end
end

% figure
% hold on
% plot(1:maxiters, total_loss)
% set(gca, 'YScale', 'log')
% set(gca, 'XScale', 'log')
% grid on
% xlabel('iterations')
% ylabel('loss')
% title('decrease of loss')

end

