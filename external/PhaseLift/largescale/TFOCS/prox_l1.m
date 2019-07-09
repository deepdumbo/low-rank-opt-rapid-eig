function op = prox_l1( q )

%PROX_L1    L1 norm.
%    OP = PROX_L1( q ) implements the nonsmooth function
%        OP(X) = q * norm(X,1).
%    Q is optional; if omitted, Q=1 is assumed. But if Q is supplied,
%    then it must be a positive real scalar.

if nargin == 0,
	q = 1;
elseif ~isnumeric( q ) || ~isreal( q ) || numel( q ) ~= 1 || q <= 0,
	error( 'Argument must be positive.' );
end

% op = @(varargin)prox_l1_q( q, varargin{:} ); old method
op = tfocs_prox( @f, @prox_f ); % new method

function v = f(x)
    v = q*norm( x(:), 1 );
end

function x = prox_f(x,t)  
    tq = t * q;
    s  = 1 - tq ./ max( abs(x), tq );
    x  = x .* s;
end


end

% Old method:

% function [ v, x ] = prox_l1_q( q, x, t )
% if nargin < 2,
% 	error( 'Not enough arguments.' );
% end
% if nargin == 3,
% 	tq = t * q;
%     s  = 1 - tq ./ max( abs(x), tq );
%     x  = x .* s;
% elseif nargout == 2,
% 	error( 'This function is not differentiable.' );
% end
% v = q * norm( x(:), 1 );

% TFOCS v1.0a by Stephen Becker, Emmanuel Candes, and Michael Grant.
% Copyright 2010 California Institute of Technology and CVX Research.
% See the file TFOCS/license.{txt,pdf} for full license information.
