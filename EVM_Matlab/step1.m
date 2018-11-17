clear;

dataDir = './data';
resultsDir = 'ResultsSIGGRAPH2012';

mkdir(resultsDir);

%% face
% fileName = 'face.mp4';
% inFile = fullfile(dataDir,fileName);
% fprintf('Processing %s\n', inFile);
% amplify_spatial_Gdown_temporal_ideal(inFile,resultsDir,50,4, ...
%                      50/60,60/60,30, 1);


%% face2
fileName = '4.MOV';
inFile = fullfile(dataDir,fileName);
vidObj = VideoReader(inFile);
fprintf('Processing %s\n', inFile);

tic
% Motion
amplify_spatial_lpyr_temporal_butter(inFile,resultsDir,20,80, ...
                                     0.5,10,vidObj.FrameRate, 0);
                                 toc
%% Color
% amplify_spatial_Gdown_temporal_ideal(inFile,resultsDir,50,6, ...
%                                      50/60,60/60,30, 1);