function Loss = compute_loss(opt_pose, pose, d, f, L, Gama)
%compute_loss: compute the loss function and errors caused by perspective
%geometry.
%   The loss function involves three part: perspective geometry, noises and
%   1-norm regularization. The 1 norm regularization term is implemented on
%   the first order derivatives of eye poses to denoise, which performs
%   like a Total Variation term for an image.

% Errors from perspective geometry
error_tri = ((opt_pose.left_x - opt_pose.right_x).^2 + (opt_pose.left_y - opt_pose.right_y).^2).*( d.^2 ) - f^2 * L^2 ;

% Loss from measurements noise
Loss_mea = (opt_pose.left_x  -  pose.left_x)'*(opt_pose.left_x - pose.left_x) + ...
           (opt_pose.left_y  -  pose.left_y)'*(opt_pose.left_y - pose.left_y) + ...
           (opt_pose.right_x - pose.right_x)'*(opt_pose.right_x - pose.right_x) + ...
           (opt_pose.right_y - pose.right_y)'*(opt_pose.right_y - pose.right_y);
       
% Loss from regularization terms
Loss_reg = Gama * ( sum(abs( diff(opt_pose.left_x))) + sum(abs( diff(opt_pose.right_x))) + ...
                    sum(abs( diff(opt_pose.left_y))) + sum(abs( diff(opt_pose.right_y))));
                
                
Loss.total_loss = (error_tri'*error_tri + Loss_mea) / length(d) + Loss_reg;
Loss.smTri_errs = error_tri/length(d);

end

