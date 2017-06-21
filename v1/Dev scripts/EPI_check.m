k = 0; 
keyIsDown = false;
while k < 5 % Waits for 5 EPI to be taken ('5 5 5 5 5')
    [keyIsDown, triggerSecs, keyCode] = KbCheck(-1);
    if keyIsDown
        if find(keyCode) == KbName('5%')
            k = k + 1
            WaitSecs(.05);
        end
    end
end