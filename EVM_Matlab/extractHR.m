tic
% filePath = '/Users/evachen/Library/Mobile Documents/com~apple~CloudDocs/Desktop/School/EE239AS/Papers/EVM_Matlab/ResultsSIGGRAPH2012/face-ideal-from-0.83333-to-1-alpha-50-level-4-chromAtn-1.avi';
% filePath = '/Users/evachen/Library/Mobile Documents/com~apple~CloudDocs/Desktop/School/EE239AS/Papers/EVM_Matlab/ResultsSIGGRAPH2012/4-butter-from-0.5-to-10-alpha-20-lambda_c-80-chromAtn-0.avi';
filePath = '/Users/evachen/Library/Mobile Documents/com~apple~CloudDocs/Desktop/School/EE239AS/Papers/EVM_Matlab/data/4.MOV';
vidObj = VideoReader(filePath);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
k = 1;

while hasFrame(vidObj)
    s(k).cdata = readFrame(vidObj);
    k = k+1;
end

% % delete every 2nd frame to reduce 
% thingsToDelete = [1:2:312];
% s(thingsToDelete) = [];
% thingsToDelete2 = [1:2:156];
% s(thingsToDelete2) = [];

%% turn into greyscale
s_grey = struct('cdata',zeros(vidHeight,vidWidth, 'uint8'), 'colormap',[]);
for iFrame = 1:length(s)
s_grey(iFrame).cdata = rgb2gray(s(iFrame).cdata);
end

%% get template
e = imshow(s_grey(1).cdata);

template = imcrop(e);



%% correlate template to image

%% find location of original template

totalImage = s_grey(1).cdata;
A = normxcorr2(template,totalImage);
[s_y1,s_x1] = find(A == max(A(:)));


%% find location of template on each frame 

s_new = struct('cdata',zeros(vidHeight,vidWidth, 'uint8'), 'colormap',[]);
s_xtotal = [];
s_ytotal = [];
shiftxtotal = [];
shiftytotal = [];
s_new(1).cdata = s(1).cdata;
for iFrame  = 2:length(s_grey)
    totalImage = s_grey(iFrame).cdata;
    A = normxcorr2(template,totalImage);
    [s_y,s_x] = find(A == max(A(:)));
    
    
    shiftx = (s_x1 - s_x);
    shifty = (s_y1 - s_y) ;
    
    s_xtotal(end+1) = s_x;
    s_ytotal(end+1) = s_y;
    
    shiftxtotal(end+1) = shiftx;
    shiftytotal(end+1) = shifty;
    
    
end %iframe


%% plot out y pixel shift vs time
Fs = vidObj.FrameRate;
T = 1/Fs;
L = length(s_ytotal);
t = (0:L-1)*T; 

% figure;
% shiftFig = plot(t,shiftytotal);
% xlabel('time (seconds)')
% ylabel('Y pixel shift');

% %% fft unfiltered signal
% Y = fft(shiftytotal);
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(L/2))/L;
% plot(f,P1) 
% title('Single-Sided Amplitude Spectrum of X(t) unfiltered')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')

%% bandpass for only heart rate between 50 and 120  
% physiological between 60 and 100 
wc1 = 50/60;
wc2 = 120/60;
shiftyfiltered = bandpass(shiftytotal, [wc1 wc2], Fs);

%% fft bp filtered signal
Y = fft(shiftyfiltered);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t) filtered')
xlabel('f (Hz)')
ylabel('|P1(f)|')



%% find peak of max signal
[M,I] = max(P1);
HR = f(I) * 60
toc
