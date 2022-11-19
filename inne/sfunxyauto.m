function [sys, x0, str, ts] = sfunxyauto(t,x,u,flag,ax,varargin)
%SFUNXYAUTO S-function that acts as an X-Y scope using MATLAB plotting functions.
%   This M-file works exactly the same as SFUNXY, except that it autoscales
%   the axes on each time step.
%
%   This M-file is designed to be used in a Simulink S-function block.
%   It draws a line from the previous input point, which is stored using
%   discrete states, and the current point.  It then stores the current
%   point for use in the next invocation.
%
%   See also SFUNXY, SFUNXYS, LORENZS.

%   This user-contributed S-function is not supported by The MathWorks.

%   Greg Aloe
%   Version 1.0
%   4-24-2002

switch flag

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0
    [sys,x0,str,ts] = mdlInitializeSizes(ax,varargin{:});
    SetBlockCallbacks(gcbh);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2
    sys = mdlUpdate(t,x,u,flag,ax,varargin{:});

  %%%%%%%%%
  % Start %
  %%%%%%%%%
  case 'Start'
    LocalBlockStartFcn

  %%%%%%%%
  % Stop %
  %%%%%%%%
  case 'Stop'
    LocalBlockStopFcn

  %%%%%%%%%%%%%%
  % NameChange %
  %%%%%%%%%%%%%%
  case 'NameChange'
    LocalBlockNameChangeFcn

  %%%%%%%%%%%%%%%%%%%%%%%%
  % CopyBlock, LoadBlock %
  %%%%%%%%%%%%%%%%%%%%%%%%
  case { 'CopyBlock', 'LoadBlock' }
    LocalBlockLoadCopyFcn

  %%%%%%%%%%%%%%%
  % DeleteBlock %
  %%%%%%%%%%%%%%%
  case 'DeleteBlock'
    LocalBlockDeleteFcn

  %%%%%%%%%%%%%%%%
  % DeleteFigure %
  %%%%%%%%%%%%%%%%
  case 'DeleteFigure'
    LocalFigureDeleteFcn

  %%%%%%%%%%%%%%%%
  % Unused flags %
  %%%%%%%%%%%%%%%%
  case { 3, 9 }
    sys = [];

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    if ischar(flag),
      errmsg=sprintf('Unhandled flag: ''%s''', flag);
    else
      errmsg=sprintf('Unhandled flag: %d', flag);
    end

    error(errmsg);

end

% end sfunxyauto

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts] = mdlInitializeSizes(ax,varargin)

if length (ax)~=4
  error(['Axes limits must be defined.'])
end

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 0;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);

x0 = [];

str = [];

%
% initialize the array of sample times, note that in earlier
% versions of this scope, a sample time was not one of the input
% arguments, the varargs checks for this and if not present, assigns
% the sample time to -1 (inherited)
%
if ~isempty(varargin) > 0
  ts = [varargin{1} 0];
else
  ts = [-1 0];
end

% end mdlInitializeSizes

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u,flag,ax,varargin)

%
% always return empty, there are no states...
%
sys = [];

%
% Locate the figure window associated with this block.  If it's not a valid
% handle (it may have been closed by the user), then return.
%
FigHandle=GetSfunXYFigure(gcbh);
if ~ishandle(FigHandle),
   return
end

%
% Get UserData of the figure.
%
ud = get(FigHandle,'UserData');
if isempty(ud.XData),
  x_data = [u(1) u(1)];
  y_data = [u(2) u(2)];
else
  x_data = [ud.XData u(1)];
  y_data = [ud.YData u(2)];
end

% plot the input lines
set(ud.XYAxes, ...
    'Visible','on',...
    'Xlim', ax(1:2),...
    'Ylim', ax(3:4));
set(ud.XYLine,...
    'Xdata',x_data,...
    'Ydata',y_data,...
    'LineStyle','-');
set(ud.XYTitle,'String','X Y Plot');
set(FigHandle,'Color',get(FigHandle,'Color'));

%
% update the X/Y stored data points
%
ud.XData(end+1) = u(1);
ud.YData(end+1) = u(2);

%
% autoscale the axes
%
axis(ud.XYAxes,'auto')

set(FigHandle,'UserData',ud);
drawnow

% end mdlUpdate

%
%=============================================================================
% LocalBlockStartFcn
% Function that is called when the simulation starts.  Initialize the
% XY Graph scope figure.
%=============================================================================
%
function LocalBlockStartFcn

%
% get the figure associated with this block, create a figure if it doesn't
% exist
%
FigHandle = GetSfunXYFigure(gcbh);
if ~ishandle(FigHandle),
  FigHandle = CreateSfunXYFigure;
end

ud = get(FigHandle,'UserData');
set(ud.XYLine,'XData',[],'YData',[]);
set(ud.XYLine,'XData',0,'YData',0);
ud.XData = [];
ud.YData = [];
set(FigHandle,'UserData',ud);

% end LocalBlockStartFcn

%
%=============================================================================
% LocalBlockStopFcn
% At the end of the simulation, set the line's X and Y data to contain
% the complete set of points that were acquire during the simulation.
% Recall that during the simulation, the lines are only small segments from
% the last time step to the current one.
%=============================================================================
%
function LocalBlockStopFcn

FigHandle=GetSfunXYFigure(gcbh);
if ishandle(FigHandle),
  %
  % Get UserData of the figure.
  %
  ud = get(FigHandle,'UserData');
  set(ud.XYLine,...
      'Xdata',ud.XData,...
      'Ydata',ud.YData,...
      'LineStyle','-');

end

% end LocalBlockStopFcn

%
%=============================================================================
% LocalBlockNameChangeFcn
% Function that handles name changes on the Graph scope block.
%=============================================================================
%
function LocalBlockNameChangeFcn

%
% get the figure associated with this block, if it's valid, change
% the name of the figure
%
FigHandle = GetSfunXYFigure(gcbh);
if ishandle(FigHandle),
  set(FigHandle,'Name',get_param(gcbh,'Name'));
end

% end LocalBlockNameChangeFcn

%
%=============================================================================
% LocalBlockLoadCopyFcn
% This is the XYGraph block's LoadFcn and CopyFcn.  Initialize the block's
% UserData such that a figure is not associated with the block.
%=============================================================================
%
function LocalBlockLoadCopyFcn

SetSfunXYFigure(gcbh,-1);

% end LocalBlockLoadCopyFcn

%
%=============================================================================
% LocalBlockDeleteFcn
% This is the XY Graph block'DeleteFcn.  Delete the block's figure window,
% if present, upon deletion of the block.
%=============================================================================
%
function LocalBlockDeleteFcn

%
% Get the figure handle associated with the block, if it exists, delete
% the figure.
%
FigHandle=GetSfunXYFigure(gcbh);
if ishandle(FigHandle),
  delete(FigHandle);
  SetSfunXYFigure(gcbh,-1);
end

% end LocalBlockDeleteFcn

%
%=============================================================================
% LocalFigureDeleteFcn
% This is the XY Graph figure window's DeleteFcn.  The figure window is
% being deleted, update the XY Graph block's UserData to reflect the change.
%=============================================================================
%
function LocalFigureDeleteFcn

%
% Get the block associated with this figure and set it's figure to -1
%
ud=get(gcbf,'UserData');
SetSfunXYFigure(ud.Block,-1)

% end LocalFigureDeleteFcn

%
%=============================================================================
% GetSfunXYFigure
% Retrieves the figure window associated with this S-function XY Graph block
% from the block's parent subsystem's UserData.
%=============================================================================
%
function FigHandle=GetSfunXYFigure(block)

if strcmp(get_param(block,'BlockType'),'S-Function'),
  block=get_param(block,'Parent');
end

FigHandle=get_param(block,'UserData');
if isempty(FigHandle),
  FigHandle=-1;
end

% end GetSfunXYFigure

%
%=============================================================================
% SetSfunXYFigure
% Stores the figure window associated with this S-function XY Graph block
% in the block's parent subsystem's UserData.
%=============================================================================
%
function SetSfunXYFigure(block,FigHandle)

if strcmp(get_param(bdroot,'BlockDiagramType'),'model'),
  if strcmp(get_param(block,'BlockType'),'S-Function'),
    block=get_param(block,'Parent');
  end

  set_param(block,'UserData',FigHandle);
end

% end SetSfunXYFigure

%
%=============================================================================
% CreateSfunXYFigure
% Creates the figure window associated with this S-function XY Graph block.
%=============================================================================
%
function FigHandle=CreateSfunXYFigure

%
% the figure doesn't exist, create one
%
FigHandle = figure('Units',          'pixel',...
                   'Position',       [100 100 400 300],...
                   'Name',           get_param(gcbh,'Name'),...
                   'Tag',            'SIMULINK_XYGRAPH_FIGURE',...
                   'NumberTitle',    'off',...
                   'IntegerHandle',  'off',...
                   'Toolbar',        'none',...
                   'Menubar',        'none',...
                   'DeleteFcn',      'sfunxyauto([],[],[],''DeleteFigure'')',...
                   'DoubleBuffer',   'on');
%
% store the block's handle in the figure's UserData
%
ud.Block=gcbh;

%
% create various objects in the figure
%
ud.XYAxes   = axes;
ud.XYLine   = plot(0,0);
ud.XYXlabel = xlabel('X Axis');
ud.XYYlabel = ylabel('Y Axis');
ud.XYTitle  = get(ud.XYAxes,'Title');
ud.XData    = [];
ud.YData    = [];
set(ud.XYAxes,'Visible','off');

%
% Associate the figure with the block, and set the figure's UserData.
%
SetSfunXYFigure(gcbh,FigHandle);
set(FigHandle,'HandleVisibility','callback',...
              'UserData',ud);

% end CreateSfunXYFigure

%
%=============================================================================
% SetBlockCallbacks
% This sets the callbacks of the block if it is not a reference.
%=============================================================================
%
function SetBlockCallbacks(block)

%
% the actual source of the block is the parent subsystem
%
block=get_param(block,'Parent');

%
% if the block isn't linked, issue a warning, and then set the callbacks
% for the block so that it has the proper operation
%
if strcmp(get_param(block,'LinkStatus'),'none'),
  warnmsg=sprintf(['The XY Graph Autoscale scope ''%s'' should be replaced ' ...
                   'with a new version from the block library'],...
                   block);
  warning(warnmsg);

  callbacks={
    'CopyFcn',       'sfunxyauto([],[],[],''CopyBlock'')' ;
    'DeleteFcn',     'sfunxyauto([],[],[],''DeleteBlock'')' ;
    'LoadFcn',       'sfunxyauto([],[],[],''LoadBlock'')' ;
    'StartFcn',      'sfunxyauto([],[],[],''Start'')' ;
    'StopFcn',       'sfunxyauto([],[],[],''Stop'')' ;
    'NameChangeFcn', 'sfunxyauto([],[],[],''NameChange'')' ;
  };

  for i=1:length(callbacks),
    if ~strcmp(get_param(block,callbacks{i,1}),callbacks{i,2}),
      set_param(block,callbacks{i,1},callbacks{i,2})
    end
  end
end

% end SetBlockCallbacksg
