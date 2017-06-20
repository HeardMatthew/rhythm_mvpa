%% rhythm_mvpa.m
% Author: Matthew Heard
% The code used for the rhythm MVPA study
% 6/16 1:04pm This features a hard-coded loading of audio. Replaced with
% LoadAudio()

sca; 
clearvars; 
clc;
cd ..
direc = pwd; 

%% Set parameters and preferences

% Parameters
    % Make changes here to change parameters of the study (TR, # scans...)

% File locations and names
    % Change where files are located and called here. 
StimuliLoc = [direc, '\stimuli'];
ScriptsLoc = [direc, '\scripts']; 
Instructions = 'instructions.txt';

% PTB settings
    % Manipulate PTB settings by effecting this code. 
EnableAlphaBlending = 1;
ScreenNumber = 0;
    
% Preferences 
    % Make changes here to execute or bypass later code (useful for when
    % you're testing the script). 
SkipSyncTests = 0;
ShowInstructions = 1; 
ShowFixCross = 0; 

%% The Experiment
% Opening screen
if SkipSyncTests == 1
    Screen('Preference', 'SkipSyncTests', 1);
end

[wPtr, rect] = Screen('OpenWindow', ScreenNumber, 185);
frameDuration = Screen('GetFlipInterval', wPtr);
centerX = rect(3)/2;
centerY = rect(4)/2;
if EnableAlphaBlending == 1
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
else
    Screen('BlendFunction',wPtr,GL_ONE,GL_ZERO); 
end

% Prepare stimuli
    % Loading images and audio into PTB can take time. Prepare them before
    % the experiment to prevent file loading from making your timing
    % inaccurate. 
cd(StimuliLoc)
files = dir; 
audio = cell(1, length(files)-2); % Preallocate audio data cell
fs = cell(1, length(files)-2);    % Note the -2 above, due to files(1) &
for i = 3:length(files)           % files(2) being '.' and '..'
    [tempAudio, tempFs] = audioread(files(i).name);
    audio{i-2} = tempAudio';
    fs{i-2} = tempFs;
end
clear tempAudio
clear tempFs
cd(direc)

% Instructions
if ShowInstructions == 1
    cd(ScriptsLoc)
    DisplayInstructions(Instructions, wPtr)
    cd(direc)
end

% Drawing a fixation cross
if ShowFixCross == 1
    crossLength = 30;   % Set dimensions of the cross in these lines of code
    crossColor = 0;     % and they will update the next section automatically.
    crossWidth = 2;

    crossLines = [-crossLength/2, crossLength/2, 0, 0; ...
        0, 0, -crossLength/2, crossLength/2];
    Screen('DrawLines',wPtr, crossLines, crossWidth, crossColor, ...
        [centerX, centerY], 2);

    Screen('Flip',wPtr);
    pause(2);
end

% Closing screen
Screen('CloseAll');
if SkipSyncTests == 1
    Screen('Preference', 'SkipSyncTests', 0); % turns tests back on
end

% Displaying relevant information

