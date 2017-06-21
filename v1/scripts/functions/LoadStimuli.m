% LoadStimuli.m
function [audiodata, samplingrate] = LoadStimuli(fileloc) 
% Loads audio data from stimuli.wav into two cell arrays; one for the
% waveform (audiodata) and one for the sampling rate (samplingrate). Keep
% all stimuli ALONE in fileloc. Placing any other file into the stimuli
% folder breaks this script, as it calls elements directly from dir. Author
% - Matt H
cd(fileloc)
files = dir; 
audiodata = cell(1, length(files)-2);   % Preallocate audio data cell
samplingrate = cell(1, length(files)-2);% Note the -2 above, due to 
for i = 3:length(files)                 % files(1), files(2) = '.' , '..'
    [tempAudio, tempFs] = audioread(files(i).name);
    audiodata{i-2} = tempAudio';
    samplingrate{i-2} = tempFs;
end
clear tempAudio
clear tempFs
