% SaveResults.m
% Saves results in a (kind of) easy to parse txt file
fid = fopen(filename, 'w'); 
for i = 1:p.runs
    fprintf(fid, 'DATA FOR RUN %d ---------- \n', i);
    
    fprintf(fid, 'Run duration: %6.2f \n', runDuration{i});
    
    dstring = ''; 
    fstring = '';
    for j = 1:p.eventsPerRun
        dstring = strcat(dstring, ' %d '); 
        fstring = strcat(fstring, ' %f ');
    end
    keystring = ['Event key: ', dstring, '\n'];  
    fprintf(fid, keystring, eventKey{i});
    
    eventdurationstring = ['Event durations: ', fstring];
    fprintf(fid, eventdurationstring, eventDuration(i,:)); 
    fprintf(fid, '\n\n'); 
end
fclose(fid); 
end