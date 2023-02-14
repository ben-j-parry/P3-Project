deviceReader = audioDeviceReader('Driver', 'DirectSound');

%frameLength = 1024;
%fileReader = dsp.AudioFileReader('RockDrums-44p1-stereo-11secs.mp3','SamplesPerFrame',frameLength);
deviceWriter = audioDeviceWriter('SampleRate',fileReader.SampleRate);

equalizer = graphicEQ('SampleRate',fileReader.SampleRate,'Gains',[0,10,-10,5,-5,2,-2,1,-1,0]);
visualize(equalizer)

parameterTuner(equalizer)

while ~isDone(fileReader)
    audioIn = fileReader();
    audioOut = equalizer(audioIn);
    deviceWriter(audioOut);
    drawnow limitrate % required to update parameter
end

release(deviceWriter)
release(fileReader)
release(equalizer)