function [ x, out, opts ] = phrec( smoothF, projectorF, Pattern, x0, opts )

% [ x, out, opts ] = tfocs_AT( smoothF, affineF, nonsmoothF, x0, opts )
%   Implements Auslender & Teboulle's method.
%   A variety of calling sequences are supported; type 
%      help tfocs_help
%   for a full explanation.

% Initialization
alg = 'AT';
algorithm = 'Auslender & Teboulle''s single-projection method';
alpha = 0; beta = 0; mu = 0; % Do not remove: necessary because of a MATLAB quirk

U = x0;

dimx = size(x0,1);
Af = @(X) FactoredIllumination(X,Pattern);
ApplyZhandle = @(v,U,g_Ay,stepsize) ApplyZ(v,U,Af,Pattern,g_Ay,stepsize,lambda,W);

tfocs_initialize
if nargin == 0,	return; end

while true,
    
      x_old =   x;
    A_x_old = A_x;
      z_old =   z;
    A_z_old = A_z;
    
    % The backtracking loop
    L_old      = L;
   	L          = L * alpha;
    theta_old  = theta;
    while true,
        
        % Acceleration
        theta = advance_theta( theta_old, L, L_old );

		% Next iterate
        if theta < 1,
            y   = ( 1 - theta ) *   x_old + theta *   z_old;
            A_y = ( 1 - theta ) * A_x_old + theta * A_z_old;
            f_y = Inf; g_Ay = []; g_y = [];
        end
        
        % Compute the function value if it is not already
        if isempty( g_y ),
            if isempty( g_Ay ), [ f_y, g_Ay ] = apply_smooth( A_y ); end
            g_y = g_Ay;
      %      g_y = apply_linear( g_Ay, 2 );
        end
        
        % Scaled gradient
        step = 1 / ( theta * L );
        [ C_z, z ] = proj_tsvd( ApplyZhandle, dimx );
        A_z = z;
       % A_z = apply_linear( z, 1 );
        
        % New iterate
        if theta == 1,
            x   = z; 
            A_x = A_z;
            C_x = C_z;
        else
            x   = ( 1 - theta ) *   x_old + theta *   z;
            A_x = ( 1 - theta ) * A_x_old + theta * A_z;
            C_x = Inf;
        end
        f_x = Inf; g_Ax = []; g_x = [];
        
        % Perform backtracking tests
        tfocs_backtrack
        
    end
    
    % Collect data, evaluate stopping criteria, and print status
    %tfocs_iterate
    
end

% Final processing
%tfocs_cleanup

% TFOCS v1.0a by Stephen Becker, Emmanuel Candes, and Michael Grant.
% Copyright 2010 California Institute of Technology and CVX Research.
% See the file TFOCS/license.{txt,pdf} for full license information.

