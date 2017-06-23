% WaitForScannerTrigger.m
function firstTrigger = WaitForScannerTrigger
% Pretty self-explanatory. First image is taken when scanner sends a 5 to
% the computer. So, write a script to pause the rest of the experiment from
% starting until then. 
% Adapted from Jonas Kaplan fMRI tutorial

WaitSecs(.5); 

% Find the key code for the fMRI scanner
triggerCode = KbName('5%'); 
keyIsDown = 0; %#ok<NASGU>sca


% Make sure no keys are disabled for key check
DisableKeysForKbCheck([]); 

% Get the time when program starts to wait
startToWait = GetSecs(); 

% Wait for the first trigger
while 1
    [keyIsDown, triggerSecs, keyCode] = KbCheck(-1);
    if keyIsDown
        if find(keyCode) == triggerCode
            firstTrigger = triggerSecs - startToWait; 
            break;
        end
    end
end

% Now, ignore 5 for the rest of the experiment. I don't think we want this.
% Shouldn't we instead write each trigger to another file? Let's write
% another function to handle that. 
% DisableKeysForKbCheck([triggerCode]);
end