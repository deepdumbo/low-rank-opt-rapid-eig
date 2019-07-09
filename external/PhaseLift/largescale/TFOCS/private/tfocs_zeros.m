function z = tfocs_zeros( y )
switch class( y ),
    case 'double',
        % SRB: this was the old code.  This function was intended
        % to be called as   tfocs_zeros( size(y) )
        % But, for packSVD, I'd prefer to call it as tfocs_zeros(y)
        %   so that we can look at the type of y and pass it off
        %   accordingly (see 'packSVD' section below).
        % This would break old code.  But, it appears that all
        % calls of this use the { [n1,n2], [m1,m2] } form of sz
        %   (as opposed to the [m1,n1] convention), so
        % I don't think this will break anything.
        
        % Old code:
        %     	z = zeros( y );

        % New code:
        % Try to catch cases where we thing y = [m,n] is a size:
        if numel(y) == 2 && isint(y(1)) && isint(y(2))
            z = zeros( y );
        else
            z = zeros( size(y) );
        end

    case 'cell',
        if isa( y{1}, 'function_handle' ),
            z = y{1}( y{2:end} );
        else
            for k = 1 : numel(y),
                y{k} = tfocs_zeros( y{k} );
            end
            z = tfocs_tuple( y );
        end
    case 'packSVD'
        %z = packSVD>tfocs_zeros(y);
        z = packSVD_zeros(y);
    otherwise
        error('TFOCS_ZEROS: cannot handle this type of object');
end

function h = isint(y)
h = abs( round(y) - y ) < 10*abs(y)*eps;

% TFOCS v1.0a by Stephen Becker, Emmanuel Candes, and Michael Grant.
% Copyright 2010 California Institute of Technology and CVX Research.
% See the file TFOCS/license.{txt,pdf} for full license information.

 