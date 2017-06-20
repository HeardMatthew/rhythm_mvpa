%% ISSS_test.m
% A script to test if we can successfully use ISSS in an experimental
% setting. Author - Matt Heard
%% Startup
sca; PsychPortAudio('Close'); clearvars; clc;
codeStart = GetSecs(); 
cd ..
direc = pwd; 
InitializePsychSound
%% Parameters
% Many of these parameters need to be determined while testing. 
AudioDevice = PsychPortAudio('GetDevices', 3); 
    % Is this PsychPortAudio call correct? I want to call all ASIO devices
    % on the Windows computer. In the lab and on my laptop, there is only
    % one. Are there multiple in CCBBI? If so, then I'll have to change
    % which device is called. 

p.TR = 1.000;               % 1.000
p.runs = 2;                 % 2
p.eventsPerRun = 30;        % 30
p.epiNum = 10;              % 10 (1/sec, 10sec)
p.silentTime = 4.000;       % 4 (shows some msec variation in the code)
p.epiTime = 10.000;         % 10 seconds

% Estimates to compare later
p.eventTime = p.silentTime + p.epiTime;
p.runDuration = p.eventTime * p.eventsPerRun; 

triggerCode = KbName('5%'); % This is the trigger recieved from the MRI. 
subjResponseCode = KbName('1!'); % This is the button box. 

NumberOfStimuli = 6; % Update this in final code, fine for now. 
StimuliLoc = [direc, '\stimuli'];
ScriptsLoc = [direc, '\scripts'];
FuncsLoc = [ScriptsLoc, '\functions']; 
Instructions = 'instructions_ISSS_test.txt';
Results = 'results_ISSS_test.txt'; 
Variables = 'variables_ISSS_test.mat'; 

    % Determine these params when testing. 
ScreenNumber = 0; % Which screen does the subject see?
HeadphonesID = 2; % What is the ID of the MRI-safe headphones?

% Debugging
ConnectedToScanner = 0;
ShowInstructions = 1;

% Preallocating certain variables, and preparing the event and jitter keys. 
runStart = cell(1, p.runs);
runEnd= cell(1, p.runs);
runDuration = cell(1, p.runs);
jitterKey = cell(1, p.runs);
eventKey = cell(1, p.runs);
eventStart = NaN(p.runs, p.eventsPerRun); 
eventEnd = NaN(p.runs, p.eventsPerRun); 
epiEnd = NaN(p.runs, p.eventsPerRun); 

%%% This section of code will not be in the final product, this is a
%%% temporary way of making a long enough event key to run the
%%% experiment. We have only prepared six stimuli but want to run 30
%%% trials. By concatenating 5 randperm vectors of length 6, this
%%% creates an event key of length 30. 
for i = 1:p.runs
    jitterKey{i} = rand(1, p.eventsPerRun); 
    temp = cell(1, 5); 
    for m = 1:5 
        temp{m} = randperm(NumberOfStimuli);
        eventKey{i} = horzcat(eventKey{i}, temp{m});
    end
end
%%%

%% Prepare test
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

% Instructions
if ShowInstructions == 1
    cd(FuncsLoc)
    DisplayInstructions(Instructions, wPtr, subjResponseCode); 
    cd(direc)
end

% Open audio connection
pahandle = PsychPortAudio('Open', HeadphonesID, [], [], fs);

% Waiting for first pulse
cd(FuncsLoc)
WaitForScannerTrigger_ISSS(ConnectedToScanner, wPtr, triggerCode);
    % This function waits for a single pulse before continuing. 
% WaitSecs(p.epiTime) % Uncomment if first pulse is multiple EPIs
cd(direc)

%% Present audio stimuli
% I have coded for the program to present the stimuli and wait. 
for i = 1:p.runs
    
    DrawFormattedText(wPtr, 'Presenting stimuli...', 'center', 'center');
    [~, runStart{i}] = Screen('Flip', wPtr); 
    
    for j = 1:p.eventsPerRun
        PsychPortAudio('FillBuffer', pahandle, audio{eventKey{i}(j)});
        eventStart(i, j) = GetSecs(); 
        
        WaitSecs(jitterKey{i}(j)); 
        PsychPortAudio('Start', pahandle);
        WaitSecs(p.silentTime - jitterKey{i}(j));
        PsychPortAudio('Stop', pahandle, 1);
        eventEnd(i, j) = GetSecs();
        
        WaitSecs(p.epiTime); 
        epiEnd(i, j) = GetSecs(); 

%%% Old idea, wait for certain # of EPIs to be taken. According to
%%% Xiangrui, not required. Scanner simply sends one '5%' per TR. He
%%% suggests simply synchronizing by time instead. 
%         k = 0; 
%         while k < p.epiNum % Waits for p.epiNum EPIs to be taken
%             [keyIsDown, triggerSecs, keyCode] = KbCheck(-1);
%             if keyIsDown
%                 if find(keyCode) == triggerCode
%                     k = k + 1;
%                     WaitSecs(.1);
%                 end
%             end
%         end
%       epiEnd(i, j) = triggerSecs;
    
    end
    
    if i~= p.runs
        DrawFormattedText(wPtr, 'End of run. Press button to continue.',...
            'center', 'center'); % End of run prompt. Gives break to subjects. 
        [~, runEnd{i}] = Screen('Flip', wPtr);

        while 1 % Wait for subject to press button to advance. 
            [keyIsDown, ~, keyCode] = KbCheck(-1);
            if keyIsDown
                if find(keyCode) == subjResponseCode
                    break
                end
            end
        end

        cd(FuncsLoc)
        WaitForScannerTrigger_ISSS(ConnectedToScanner, wPtr, triggerCode);
        % WaitSecs(p.epiTime) % Uncomment if first pulse is multiple EPIs
        cd(direc)
    else
        DrawFormattedText(wPtr, 'End of experiment.', 'center', 'center');
        [~, runEnd{i}] = Screen('Flip', wPtr);
        WaitSecs(3); 
    end

end

%% Saving relevant timing information
eventDuration = eventEnd - eventStart;
epiStart = eventEnd;
epiDuration = epiEnd - epiStart; 
totalDuration = eventDuration + epiDuration; 

fid = fopen(Results, 'w');    
dstring = ''; 
fstring = '';

for i = 1:p.eventsPerRun
    dstring = strcat(dstring, ' %d '); 
    fstring = strcat(fstring, ' %f ');
end

for i = 1:p.runs
    runDuration{i} = runEnd{i} - runStart{i};     
    fprintf(fid, 'DATA FOR RUN %d ---------- \n', i);
    
    fprintf(fid, 'Run started %6.2f after code started \n', ...
        runStart{i} - codeStart); 
    
    fprintf(fid, 'Run duration: %6.2f \n', runDuration{i});
    fprintf(fid, 'Expected run duration: %6.2f \n', p.runDuration); 

    keystring = ['Event key: ', dstring, '\n'];
    fprintf(fid, keystring, eventKey{i});
    
    jitterstring = ['Jitter key (msec): ', fstring, '\n']; 
    fprintf(fid, jitterstring, (jitterKey{i} * 1000)); 
    
    eventdurationstring = ['Silence durations: ', fstring, '\n'];
    fprintf(fid, eventdurationstring, eventDuration(i,:));
    
    epidurationstring = ['EPI durations: ', fstring, '\n'];
    fprintf(fid, epidurationstring, epiDuration(i, :));
    
    totaldurationstring = ['Total durations: ', fstring, '\n'];
    fprintf(fid, totaldurationstring, totalDuration(i, :));
    
    fprintf(fid, 'Expected event duration: %f \n', p.eventTime); 
    
    fprintf(fid, '\n'); 
end

fclose(fid); 
save(Variables); 

%% Closing down
Screen('CloseAll');
PsychPortAudio('Close'); 
cd(ScriptsLoc)