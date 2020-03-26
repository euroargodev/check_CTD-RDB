function [ wmo_boxes ] = pos2wmo( pos_lat , pos_lon )
%
% [ wmo_boxes ] = pos2wmo( pos_lat , pos_lon )
%
%   calculates for every given position
%   the corresponding wmo box number
% 
%
% by L.Boehme, IfM Kiel
% lboehme@ifm.uni-kiel.de
%
% last modification: 10/2003
% last modificiation cc : 02/2007

if nargin < 2
    disp('Not enough input!');
    return
end

[n,m]=size(pos_lon);
if n==1
    pos_lon=pos_lon';
end
[n,m]=size(pos_lat);
if n==1
    pos_lat=pos_lat';
end


% generate output
wmo_boxes = ones(size(pos_lat))*nan;

% longitude in right format??
I=find(pos_lon>180);
pos_lon(I)=pos_lon(I)-360;

% look for hemisphere;
I=find(pos_lon < 0 & pos_lat < 0);
hem(I)=5;
I=find(pos_lon <= 0 & pos_lat >= 0);
hem(I)=7;
%I=find(pos_lon > 0 & pos_lat < 0);
I=find(pos_lon >= 0 & pos_lat <= 0);
hem(I)=3;
I=find(pos_lon > 0 & pos_lat > 0);
hem(I)=1;

% latitude at 90°
I=find(pos_lat==90);
pos_lat(I)=pos_lat(I)-0.001;

% longitude at 180°
I=find(pos_lon==180);
pos_lon(I)=pos_lon(I)-0.001;


% generate number
wmo_boxes = hem'.*1000 + floor(floor(abs(pos_lat))/10).*100 + floor(floor(abs(pos_lon))/10);

