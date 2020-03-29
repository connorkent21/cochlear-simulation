clear all;
clc;

% Define variables
numBands = 8;

% Read in the sample
filename = 'KylieOut.mp3';
[sample, sr] = audioread(filename);

sound(sample, sr);

% Build an array of filtered sampples
[bank, centralFreqs] = createFilterBank(sr, numBands);

% Perform the Filtering
for i = 1:1:numBands
    filteredSamples(:,i) = filter(bank(i), sample);
end

% Plot the largest and smallest bands
dt = 1/sr;
t = 0:dt:(length(sample)*dt) - dt;

% Low
figure(1)
plot(t, filteredSamples(:,1)); xlabel('Time (s)'); ylabel('Amplitude'); title("Filtered Signal - Low");

% High
figure(2)
plot(t, filteredSamples(:,numBands)); xlabel('Time (s)'); ylabel('Amplitude'); title("Filtered Signal - High");


% Rectify Signal Array
filteredSamples = abs(filteredSamples);

%%% Create Envelope Array by Running Filtered Samples through LP %%
lpInit = fdesign.lowpass('N,F3db', 10, 400/(sr/2));
lpFilter = design(lpInit, 'butter');

for i = 1:1:numBands
    sampleEnvelopes(:,i) = filter(lpFilter, filteredSamples(:,i));
end

% Plot Envelopes of largest and smallest bands
% Low
figure(3)
plot(t, sampleEnvelopes(:,1)); xlabel('Time (s)'); ylabel('Amplitude'); title(" Filtered Signal Envelope - Low");

% High
figure(4)
plot(t, sampleEnvelopes(:,numBands)); xlabel('Time (s)'); ylabel('Amplitude'); title(" Filtered Signal Envelope - High");

% Generate Cosine waves for each band in the filter bank;
for i = 1:1:numBands
    cosineBank(:,i) = cos(2*pi*centralFreqs(i)*t);
end

% Amplitude modulate the samples using the corresponding cosine wave
for i = 1:1:numBands
    modulatedSignals(:,i) = modulate(sampleEnvelopes(:,i), centralFreqs(i), sr);
end

% Add all the signals tog;ether to generate output signal
disp(size(modulatedSignals, 1));
disp(size(modulatedSignals, 2));
clear sum;
outputSignal = sum(modulatedSignals, 2);
figure(6);
plot(t, outputSignal); xlabel('Time (s)'); ylabel('Amplitude'); title("Output Signal");
% Normalize the output signal
outputSignal = outputSignal * sqrt( max(outputSignal) ) / sqrt( sum( outputSignal.^2 ) );
disp(outputSignal)

% Play the output signal (and boost volume back up)
sound(80*outputSignal, sr);

% Write the altered signal to a wav file
audiowrite("KylieFiltered.wav", outputSignal, sr);


% Define function to create filter bank
function [filterBank, centralFreqs] = createFilterBank(sr, numBands)
    % Define low and high frequencies
    freqLow = 100;
    freqHigh = 7999;
    logDifference = (log10(freqHigh) - log10(freqLow))/numBands;
    
    for i = 1:1:numBands
        freqHigh = 10^(log10(freqLow) + logDifference);
        centralFreqs(i) = 10^((log10(freqHigh) + log10(freqLow))/2);
        fInit = fdesign.bandpass('N,F3dB1,F3dB2', 60, freqLow/(sr/2), freqHigh/(sr/2));
        filter = design(fInit, 'butter');
        filterBank(i) = filter;
        freqLow = freqHigh;
    end
end


