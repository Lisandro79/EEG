
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TO RUN THE PREPROCESS FIRST WE MUST CONVERT THE BDF TO .SET (Juan does this right now from Bs As). I DO THIS BY HAND AND TAKING CHANNEL 133 AS REFERENCE. 
THEN WE RUN THE RUNBDF2ICA_BSAS WITHOUT PERFORMING THE AVERAGE REFERENCE IN THE END, SO THAT WE CAN TAKE AWAY THE ARTIFACTS AND THE RE-REFERENCE EVERYTHING (TO AVOID ANY POSSIBLE CONTAMINATION FROM BAD CHANNELS TO ALL OTHER CHANNELS).
NOTE: ICA is not working in the server with the version 7.1.5 because we still have to edit icadefs.m

FILES TO RUN ALL PREPROCESSING:

1-  batch_runICA.m > readBdf2ICA_BsAs.m  % transforms bdf to .set, Adds channel location, applies filters, runs ICA.

2-  batch_analyze_Comp_Interp_AvRef_Notch  >  analyze_Comp_Interp_AvRef_Notch.m  % removes components, interpolates, average reference, notch filter at 50hz. 

3- removeDataFromDataset  % removes continuous portions of the dataset if necessary -to 

The files run_*.txt are for running processes in the server


EPOCH DATA: (folder Epoching)

3-  batch_extractEpochsBash_BsAs.m   >   extractEpochsBash_BsAs.m  % Main function to extract epochs and run automatic artifact rejection. See explanation inside the help.

AFTER THE EPOCHING IS MUCH MUCHO EASIER TO DETECT ARTIFACTS BY EYE.

AUTOMATIC ARTIFACT REJECTION:

autoArtiDetection.m  % Call the automatic process. Need an epoched dataset to work on. This function is called from inside 'extractEpochsBash_BsAs.m'


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FILES TO PERFORM ERPS:



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TIME-FREQUENCY ANALYSIS:



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

UTILITY FUNCTIONS:

Contains:

--Parallel Port: functions to deal with triggering.
--renameEpochsExp.m : function to rename epochs.
--sampling.m : some tests on sampling populations -playing with statistics-








