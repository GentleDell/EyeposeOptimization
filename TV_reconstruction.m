function x = TV_reconstruction(x_cor, gama, order)
% Optimize total variation to find the optimzal x_cor
%    x      : positions of eye on a singal corrdinate
%    gama   : regularization parameter
%    order  : order of derivation (regularization term)
%    x_cor  : optimized positions of eye on a singal corrdinate

N = size(x_cor, 1);

% Denote decision variables by x, u and V.
x  = sdpvar(N, 1);

% define objective function
if order == 1
    % ||x - x_cor||_2 + gama*|D*x|_1
    objective = (x - x_cor)'*(x - x_cor) + gama * sum( abs( diff(x) )) ;
elseif order == 2
    % ||x - x_cor||_2 + gama*|D*x|_1
    objective = (x - x_cor)'*(x - x_cor) + gama * sum( abs( diff( diff(x) ))) ;
else
    print('unvalide order, using piecewise constant fitting in default.')
    objective = (x - x_cor)'*(x - x_cor) + gama * sum( abs( diff(x) )); 
end

% initialize constrains and define constraints related to r_p and r_n
constraints = [];

% specify solver settings
opt_settings = sdpsettings('solver', 'mosek', 'verbose', 0);

% run solver
diagnosis = optimize(constraints, objective, opt_settings);

% display solver report
disp('solver report:');
disp(diagnosis);

x = value(x);
end