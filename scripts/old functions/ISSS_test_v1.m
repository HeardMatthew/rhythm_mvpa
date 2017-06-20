%% ISSS_test.m
% A script to test if we can successfully use ISSS in an experimental
% setting. Last edited 6/16. Since then, code has changed. 
sca; clearvars; clc;
cd ..
direc = pwd; 
InitializePsychSound
%% Params
AudioDevice = PsychPortAudio('GetDevices', 3); 
% DETERMINE THESE PARAMS WHEN TESTING

p.TR = NaN;
p.runs = 2; 
p.eventsPerRun = 6; 
p.epiNum = 4; 

p.sliceTime = 4; 
p.epiTime = 4; 
p.silentTime = 1;
p.eventTime = p.sliceTime + p.epiTime + p.silentTime;
p.scanTime = p.eventTime * p.eventsPerRun * p.runs; 
triggerCode = KbName('5%');
% GET THESE TOO

StimuliLoc = [direc, '\stimuli'];
NumberOfStimuli = 9; % Update this in final code. 
ScriptsLoc = [direc, '\scripts'];
FuncsLoc = [ScriptsLoc, '\functions']; 
Instructions = 'ISSS_test.txt';
Results = 'results_ISSS_test.txt'; 

ScreenNumber = 0;
HeadphonesID = 0;
% DETERMINE THESE PARAMS WHEN TESTING

% Debugging
ConnectedToScanner = 0;

% Preallocating certain variables
runStart = cell(1, p.runs); 
runDuration = cell(1, p.runs);
eventKey = cell(1, p.runs); 
eventStart = NaN(p.runs, p.eventsPerRun); 
eventEnd = NaN(p.runs, p.eventsPerRun); 
eventDuration = NaN(p.runs, p.eventsPerRun); 

%% Test
% Open PTB screen on scanner
[wPtr, rect] = Screen('OpenWindow', ScreenNumber, 185);
frameDuration = Screen('GetFlipInterval', wPtr);
centerX = rect(3)/2;
centerY = rect(4)/2;

% Load Stimuli
cd(FuncsLoc)
[audio, fs] = LoadStimuli(StimuliLoc);
fs = fs{1}; 
cd(direc)

% "5Instructions"
cd(FuncsLoc)
DisplayInstructions(Instructions, wPtr)
cd(direc)

% Connected to scanner
% Do we get a first pulse in this paradigm? If not, we'll need another way
% to start the experiment. 
if ConnectedToScanner == 0
    DrawFormattedText(wPtr, 'Press 5 to continue', 'center', 'center');
    Screen('Flip', wPtr);
end
    cd(FuncsLoc)
    firstTrigger = WaitForScannerTrigger;
    cd(direc)

% Present audio stimuli
pahandle = PsychPortAudio('Open', [], [], [], fs); % replace elem 2 with HeadphonesID

for i = 1:p.runs
    
    temp = randperm(NumberOfStimuli); % Create a key of events
    eventKey = temp(1:p.eventsPerRun); 
    
    DrawFormattedText(wPtr, 'Presenting stimuli...', 'center', 'center');
    Screen('Flip', wPtr); 
    
    for j = eventKey
        PsychPortAudio('FillBuffer', pahandle, audio{j});
        PsychPortAudio('Start', pahandle);
        WaitSecs(p.sliceTime);
        PsychPortAudio('Stop', pahandle);
        
        k = 0; 
        while k < p.epiNum % Waits for 5 EPI to be taken ('5 5 5 5 5')
            [keyIsDown, triggerSecs, keyCode] = KbCheck(-1);
            if keyIsDown
                if find(keyCode) == triggerCode
                    k = k + 1;
                    WaitSecs(.1);% Is this going to cause timing problems?
                                 % Make sure this is shorter than time b/w
                                 % 5s from the scanner...
                end
            end
        end
    end
    WaitSecs(2)
    DrawFormattedText(wPtr, 'End of run. Press button to continue.',...
        'center', 'center');
    Screen('Flip', wPtr);
    
    while 1
        [keyIsDown, triggerSecs, keyCode] = KbCheck(-1);
        if keyIsDown
            break;
        end
    end
    
end

%% Closing down
Screen('CloseAll');
PsychPortAudio('Close'); 
cd(ScriptsLoc)
%% Saving relevant information
