classdef MusicPlayer < handle
    % MusicPlayer A music player that uses MATLAB audioplayer
    %   This music player has 4 basic features:
    %       * Start
    %       * Stop
    %       * Go to next song
    %       * Go to previous song
    %
    % Public Methods:
    %   start - Starts or resumes the music player
    %   stop - Pauses the music player
    %   nextSong - The player loads the next song and plays it
    %   previousSong - The player loads the next song and plays it
    %   isPlaying - Returns the status of the music player
    %
    % Private Methods:
    %   loadMusicDB - Loads the music files location into the musicDB array
    %   randomSong - Loads a random songs out the the DB into the player
    %   stopCallback - Callback function when the audioplayer stops.

    properties (Access = private)
        player          % Audioplayer object
        musicDB         % Array with the songs titles as strings
        currentSong     % The index number of the current song in the MusicDB
        paused = true;  % The state of the player as boolean
    end
    
    methods (Access = public)
        function obj = MusicPlayer()
            obj.loadMusicDB();
            obj.randomSong();
        end 
        
        function start(obj)
            obj.paused = false;
            obj.player.resume();
        end
        
        function stop(obj)
            obj.paused = true;
            obj.player.pause();
        end
        
        function status = isPlaying(obj)          
            status = obj.player.isplaying();
        end
        
        function obj = nextSong(obj)
            obj.stop();
            
            obj.currentSong = mod(obj.currentSong, size(obj.musicDB,2))+1;
            songName = obj.musicDB{obj.currentSong};
            
            [data,Fs] = audioread(songName);
            obj.player = audioplayer(data,Fs);
            obj.player.StopFcn = @obj.stopCallback;
            
            obj.start();
        end
        
        function obj = previousSong(obj)            
            obj.stop();
            
            if (obj.currentSong == 1)
                obj.currentSong = size(obj.musicDB,2);
            else
                obj.currentSong = obj.currentSong-1;
            end
            songName = obj.musicDB{obj.currentSong};
            
            [data,Fs] = audioread(songName);
            obj.player = audioplayer(data,Fs);
            obj.player.StopFcn = @obj.stopCallback;
            
            obj.start();
        end
    end 
     
     methods (Access = private)
        function obj = loadMusicDB(obj)
            musicFiles = dir('music/*.mp3');
            obj.musicDB = {musicFiles.name};
        end
        
        function obj = randomSong(obj)
            obj.currentSong = randi(size(obj.musicDB,2));
            songName = obj.musicDB{obj.currentSong};
            
            [data,Fs] = audioread(songName);
            obj.player = audioplayer(data,Fs);
            obj.player.StopFcn = @obj.stopCallback;
        end
        
        function stopCallback(obj,~,~)
            %   It helps the music player to play then next song if the 
            %   current song finishes (without the interference of the user).
            
            if(obj.paused == false)
                obj.nextSong();
                obj.start();
            end
        end
     end
end

