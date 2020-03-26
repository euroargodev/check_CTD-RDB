function lim = wmosquare(w)
% WMOSQUARE	Find lon,lat limits/ranges of any given wmo-square.
% 
% lim = wmosquare(wmo_number)
%
% wmo_number = The number to the WMO-square to find the ranges of.
%
% lim     = [longitude_min longitude_max latitude_min latitude_max]
%           four point vector describing limits of rectangle.
% 
% If you want to draw the square on a (non-Mercator) map, I recommend
% transfering the output to a densely drawn polygon, using ERECT with
% option 't'ight, e.g.,
%
%	[lo,la]=erect(wmosquare(1806),'t'); m_line(lo,la);
% 
% See also FINDWMO ERECT

error(nargchk(1,1,nargin));
if ~isscalar(w), error('Scalar input only!'); end

% Digits:
d1=floor(w/1000)*1000;
d2=floor((w-d1)/100)*100;
d34=w-d1-d2;

% Factors and offsets [lon lat lon lat]:
switch d1 
 case 1000, fo=[ 10  10 0 0];	% 1=NE
 case 3000, fo=[ 10 -10 0 1];	% 3=SE
 case 5000, fo=[-10 -10 1 1];	% 5=SW 
 case 7000, fo=[-10  10 1 0];	% 7=NW
end

lim(1)=fo(1)*(d34+fo(3));	lim(2)=lim(1)+10;
lim(3)=fo(2)*(d2/100+fo(4));	lim(4)=lim(3)+10;

if lim(1)<-180 | 180<lim(2) | lim(3)<-90 | 90<lim(4)
  error('Non-existent wmo number entered!');
end
