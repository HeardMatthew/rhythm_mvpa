% test.m
% Let's test all the audio stimuli I made. 
sca; clearvars; clc;
PsychPortAudio('Close')
InitializePsychSound

direc = pwd;
StimuliLoc = [direc, '\stimuli'];
ScriptLoc = [direc, '\scripts'];
cd(ScriptLoc)
[AudioData, SamplingRate] = LoadStimuli(StimuliLoc);

ASIOdevice = PsychPortAudio('GetDevices', 3);
pahandle = PsychPortAudio('Open', [], [], [], SamplingRate{1}, 2); % ASIOdevice.DeviceIndex); 
for i = 1:length(AudioData)
PsychPortAudio('FillBuffer', pahandle, AudioData{i});
pause(1)
i
PsychPortAudio('Start', pahandle);
pause(4)
PsychPortAudio('Stop', pahandle); 
end
PsychPortAudio('Close', pahandle);