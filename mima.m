function [r1,r2]=mima(varargin)
% MIMA         total [min max] of multiple numeric objects (incl. arrays)
% One or more numeric objects of different shapes (up to 3D arrays) are
% scanned for their overall extremal values.  
%
% [r1,r2] = mima(varargin)
%
% varargin   = any sequence of number-, vector-, matrix- or cell-input 
%              (comma-separated)
% r1 (alone) = two element vector [min max]
% r1,r2      = min and max
%
% Example:
%           XLIM(MIMA(xdata)); % tightens the x-axes around the data
%
% See also MIN MAX MINMAX

%Time-stamp:<Last updated on 08/02/26 at 11:47:57 by even@nersc.no>
%File:</Users/even/matlab/evenmat/mima.m>

va={};		% scan through varargin for multiple-cell entries
for i=1:length(varargin)
  if iscell(varargin{i})
    varargin{i};  va=[va ans(:)'];		% pull out level 1
  else
    va=[va varargin(i)];			% just add 
  end
end

r=[min(min(min(min(min(min(va{1})))))), ...
   max(max(max(max(max(max(va{1}))))))];	% first argin to initiate r

for i=2:length(va)				% loop through the rest
  [min(min(min(min(min(min(va{i})))))), ...
   max(max(max(max(max(max(va{i}))))))];	% 3D min and max
  r=[min([r ans]) max([r ans])];		% new vs. resident
end

if nargout==2
  r1=r(1); r2=r(2);
else
  r1=r;
end
