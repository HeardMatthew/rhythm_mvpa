%% rhythm_mvpa.m
% Author: Matthew Heard
% The code used for the rhythm MVPA study
% This is a temp copy I used to develop PsychPortAudio and LoadStimuli()
sca; clearvars; clc;
cd ..
direc = pwd; 
InitializePsychSound
AudioDevice = PsychPortAudio('GetDevices', 3); 
    % The 3 calls for the ASIO-compatible device. Check out notes in
    % help InitializePsychAudio and PsychPortAudio('GetDevices?') for more
    % details. This may need to be changed on another computer. 

%% Set parameters and preferences

% Parameters
    % Make changes here to change parameters of the study (TR, # scans...)
p.TR = NaN;
p.blockSecs = NaN;
p.nRepeats = NaN;

% File locations and names
    % Change where files are located and called here. 
StimuliLoc = [direc, '\stimuli'];
ScriptsLoc = [direc, '\scripts'];
FuncsLoc = [ScriptsLoc, '\functions']; 
Instructions = 'instructions.txt';

% PTB settings
    % Manipulate PTB settings by effecting this code. 
EnableAlphaBlending = 1;
ScreenNumber = 0;
    
% Preferences 
    % Make changes here to execute or bypass later code (useful for when
    % you're testing the script). 
SkipSyncTests = 0;
ShowInstructions = 0; 
ShowFixCross = 1; 
ConnectedToScanner = 0;

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
cd(FuncsLoc)
[audio, fs] = LoadStimuli(StimuliLoc);
cd(direc)

% Instructions
if ShowInstructions == 1
    cd(FuncsLoc)
    DisplayInstructions(Instructions, wPtr)
    cd(direc)
end

if ConnectedToScanner == 1
    cd(FuncsLoc)
    WaitForScannerTrigger
    cd(direc)
else
    DrawFormattedText(wPtr, 'Press 5 to continue', 'center', 'center');
    Screen('Flip', wPtr);
    cd(FuncsLoc)
    WaitForScannerTrigger
    DisableKeysForKbCheck([KbName('5%')])
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

% Closing down
Screen('CloseAll');
PsychPortAudio('Close'); 
if SkipSyncTests == 1
    Screen('Preference', 'SkipSyncTests', 0); % turns tests back on
end

% Displaying relevant information

