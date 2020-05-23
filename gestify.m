%% Gestify A hand gesture music controller
%  This file is the main file of the application

% Clear everything at the workspace at start up.
clear all;

% Create Music Player object
musicPlayer = MusicPlayer();

% Initialize Video
video = videoinput('winvideo',1);
set(video,'ReturnedColorSpace','rgb');

% Start the video feed
start(video);

% Determine the coordinates for cropping
snapshot = getsnapshot(video);
[x,y,width,height] = getCropRect(snapshot);

% Main Loop
while true
    % Gets the snapsho and crop it 
    snapshot = getsnapshot(video);
    handImageRGB = imcrop(snapshot, [x y width height]);
    
    % Classify the hand gesture
    sign = classifier(handImageRGB);
    
    % Use the hand gesture sign to contol the music player object
    if (sign == "exit")
        stop(video);
        musicPlayer.stop();
        break;
        
    elseif (sign == "next")
        musicPlayer.nextSong();
        pause(1);
        
    elseif (sign == "previous")
        musicPlayer.previousSong();
        pause(1);
    
    elseif (sign == "start_stop")
        if (musicPlayer.isPlaying())
            musicPlayer.stop();
        else
            musicPlayer.start();
        end
        pause(1);
    end
    
    pause(0.3);
end
 