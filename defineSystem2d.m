function tform = defineSystem2d(origin,axCoord,axType)
% Defines a local coordinate system within a global system from coordinates
%    origin  - a vector of coordinates (2 or 3) that define the origin
%    axCoord - a vector of coordinates (2 or 3) defining an axis
%    axType  - defines which axis given by axVect ('x', 'y', or 'z' for 2D)
%               ('xy', 'xz', or 'yz' for 3D)
% Note: 3D coordinates not yet supported (Code needs to be tested)
%
% Code developed by McHenryLab at UC Irvine


%% Check inputs

% Define whether a 3D system
if length(origin)==3
    error('3D coordinates not yet supported');
    %threeD = 1;
else
    threeD = 0;
end

% Check dimensions of origin
if length(origin)~=2 && length(origin)~=3 
    error('Origin needs to have a length of 2 or 3')
end

% Check dimensions of axCoord
if length(axCoord)~=2 && length(axCoord)~=3 
    error('axCoord needs to have a length of 2 or 3')
end

% Check for same units
if length(axCoord)~=length(origin)
    error('Length of origin and axCoord need to be the same')
end

% Check input of axType for 2D
if ~threeD && ~strcmp(axType,'x') && ~strcmp(axType,'y') && ~strcmp(axType,'z')
    error('axType needs to be given as either "x", "y", or "z"')
end

% Check input of axType for 3D
if threeD && ~strcmp(axType,'xy') && ~strcmp(axType,'xz') && ...
             ~strcmp(axType,'yz') 
    error('axType needs to be given as either "xy", "xz", or "yz"')
end


%% Adjust dimensions

% Make origin a column vector
if size(origin,1)>size(origin,2)
    origin = origin';
end

% Make axCoord a column vector
if size(axCoord,1)>size(axCoord,2)
    axCoord = axCoord';
end

% Expand origin dimensions to 3 
if ~threeD
    origin  = [origin 0];
    axCoord = [axCoord 0];
end


%% Define system from x-axis coordinate

if strcmp(axType,'x')
    
    % Define xaxis
    xaxis = axCoord;
    
    % Normalize to create a unit vector
    xaxis = [[xaxis./norm(xaxis)] 0];
    
    % Define y-axis
    yaxis = [-xaxis(2) xaxis(1) 0];
    
    % Normalize to create a unit vector
    yaxis = yaxis./norm(yaxis);
     
    % Define z-axis
    zaxis = cross(xaxis,yaxis);
end


%% Define system from y-axis coordinate

if strcmp(axType,'y')
    
    % Define xaxis
    yaxis = axCoord;
    
    % Normalize to create a unit vector
    yaxis = [[yaxis./norm(yaxis)] 0];
    
    % Define x-axis
    xaxis = [yaxis(2) -yaxis(1) 0];
    
    % Normalize to create a unit vector
    yaxis = yaxis./norm(yaxis);
   
    % Define y-axis
    xaxis = [-xaxis(2) xaxis(1) 0];
 
    % Define z-axis
    zaxis = cross(xaxis,yaxis);
end


%% Package system

if threeD
    % Create rotation matrix (from inertial axes to local axes)
    R = [[xaxis 0]; [yaxis 0]; [zaxis 1]];

    % Format trans matrix for matlab
    tform = affine3d(R);
    
else
    % Create rotation matrix (from inertial axes to local axes)
    R = [xaxis; yaxis; zaxis];
    
    % Format trans matrix for matlab
    tform = affine2d(R);
end



% function ptsT = global_to_local(tform,pts)
% % Assumes column vectors for coordinates
% 
% % Check dimensions
% if tform.Dimensionality~=2
%     error('Code only handles 2D transformations')
% end
% 
% %pts = [x y];
% 
% % Translate
% pts(:,1) = pts(:,1) - tform.T(3,1);
% pts(:,2) = pts(:,2) - tform.T(3,2);
% 
% % Rotate points
% ptsT = [tform.T(1:2,1:2) * pts']';
% 
% % Extract columns of points
% %xT = ptsT(:,1);
% %yT = ptsT(:,2);
% end
% 
% function ptsT = local_to_global(tform,pts)
% % Assumes columns vectors for coordinates
% 
% % Check dimensions
% if tform.Dimensionality~=2
%     error('Code only handles 2D transformations')
% end
% 
% % Loop thru columns of coordinates
% i = 1;
%     
%     %pts = [x(:,i) y(:,i)];
%     
%     % Rotate points
%     ptsT = (tform.T(1:2,1:2) \ pts')';
%     
%     % Translate global coordinates wrt origin
%     ptsT(:,1) = ptsT(:,1) + tform.T(3,1);
%     ptsT(:,2) = ptsT(:,2) + tform.T(3,2);
%     
%     % Extract columns of points
%     xT(:,i) = ptsT(:,1);
%     yT(:,i) = ptsT(:,2);
%     
%     clear ptsT pts
% %end
% end