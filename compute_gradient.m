function [grad_pose, grad_dist] = compute_gradient(opt_pose, pose, d, errs, Gama)
%compute_gradient: compute gradients of eye poses and screen-face distance

grad_dist  =   2*errs.*( 2*( (opt_pose.left_x - opt_pose.right_x).^2 + (opt_pose.left_y - opt_pose.right_y).^2 )).*d;

grad_pose.left_x  = 2*errs.*( 2*(opt_pose.left_x - opt_pose.right_x).*(d.^2) ) + 2*(opt_pose.left_x - pose.left_x)/length(d) + ...
                    Gama*( [0; diff(opt_pose.left_x)./(abs(diff(opt_pose.left_x) + eps))] ) - Gama*( [diff(opt_pose.left_x)./(abs(diff(opt_pose.left_x) + eps)); 0] );
           
grad_pose.right_x = 2*errs.*( -2*(opt_pose.left_x - opt_pose.right_x).*(d.^2)) + 2*(opt_pose.right_x - pose.right_x)/length(d) + ...
                    Gama*( [0; diff(opt_pose.right_x)./(abs(diff(opt_pose.right_x) + eps))] ) - Gama*([diff(opt_pose.right_x)./(abs(diff(opt_pose.right_x) + eps)); 0] );
                
grad_pose.left_y  = 2*errs.*( 2*(opt_pose.left_y - opt_pose.right_y).*(d.^2) ) + 2*(opt_pose.left_y - pose.left_y)/length(d) + ...
                    Gama*( [0; diff(opt_pose.left_y)./(abs(diff(opt_pose.left_y) + eps))] ) - Gama*( [diff(opt_pose.left_y)./(abs(diff(opt_pose.left_y) + eps)); 0] );
                
grad_pose.right_y = 2*errs.*( -2*(opt_pose.left_y - opt_pose.right_y).*(d.^2)) + 2*(opt_pose.right_y - pose.right_y)/length(d) + ...
                    Gama*( [0; diff(opt_pose.right_y)./(abs(diff(opt_pose.right_y) + eps))] ) - Gama*([diff(opt_pose.right_y)./(abs(diff(opt_pose.right_y) + eps)); 0] );   
           
end

