Generated on 6/15/17 by Matt. 
6/19 update: Preparing to share code with Xangrui. 

By copying and pasting this script into another location or computer, this
code should be able to run without any problems. I tested this locally
(transferred code from Desktop to Documents) and across computers 
(transferred code from lab computer to my laptop) without any problems. 

Folders:
  
  Dev scripts: has a few developer tools I designed to test different parts
  of code. Should not be needed to run experiment, I just don't feel 
  comfortable throwing out code. 
  
  Notes: contains documents relevant to experiment, such as stimulus prep. 
  
  scripts: contains every .m file required to run the experiment. 
    
    functions: contains every function called within the main script. 
    
    old functions: contains outdated versions of functions I wrote. Again,
    I can't bring myself to toss out old code. 
    
  stimuli: contains .wav files that we use as stimulus. Right now there are 
  only six files, but we will add more. 

Relevant files:
  
  rhythm_mvpa\scripts\ISSS_test.m is the script to run. 
  
  rhythm_mvpa\results_ISSS_test.txt is created after running a test
  and contains relevant timing information generated in the script. 
  
  rhythm_mvpa\variables_ISSS_test.mat contains al MATLAB variables generated. 

Known bugs and shortcomings:
  
  Keeping non-stimuli files in the stimuli folder will break the code. 

  Subject instructions should be kept in the scripts\functions folder. 
  
  For PsychHID to work, all devices must be plugged into computer BEFORE 
  starting MATLAB. 
  
  If p.numberOfEvents is not 30, output file looks a little weird. This is a 
  minor enough bug that I didn't feel the need to fix this. 

Currently using Stimuli V4 (6/19/2017)