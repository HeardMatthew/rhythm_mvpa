% DisplayInstructions.m
% Subfunction called to display instructions on screen from a .txt file.
% Keep the .txt file in the same folder as this script. Author - Matt H
function DisplayInstructions(filename, windowPointer, fwrdkey)
font = 'Cambria'; 
size = 36; 
fid = fopen(filename, 'r'); 
i = 1; 
instructions{i} = fgetl(fid); % Creates a cell array with each line of 
                              % instructions as an element. 
while ischar(instructions{i})
    i = i + 1;
    instructions{i} = fgetl(fid); 
end
fclose(fid); 

for i = 1:length(instructions)-1 % Last element is empty
    WaitSecs(0.5);
    if i == 1 % Welcome screen
        Screen('TextFont', windowPointer, font); 
        Screen('TextSize', windowPointer, size);
        Screen('TextStyle', windowPointer, 2);
        DrawFormattedText(windowPointer, instructions{i}, 'center', 'center');
        Screen('Flip',windowPointer);
    elseif i == length(instructions)-1 % Final prompt
        Screen('TextFont', windowPointer, font); 
        Screen('TextSize', windowPointer, size);
        Screen('TextStyle', windowPointer, 1);
        DrawFormattedText(windowPointer, instructions{i}, 'center', 'center');
        Screen('Flip',windowPointer);
    else % Instructions
        Screen('TextFont', windowPointer, font); 
        Screen('TextSize', windowPointer, size);
        Screen('TextStyle', windowPointer, 0);
        DrawFormattedText(windowPointer, instructions{i}, 'center', 'center');
        Screen('Flip',windowPointer);
    end
while 1 % Waits for subject to press button before advancing instructions
    [keyIsDown, ~, keyCode] = KbCheck(-1);
    if keyIsDown
        if find(keyCode) == fwrdkey
            break
        end
    end
end
end
    