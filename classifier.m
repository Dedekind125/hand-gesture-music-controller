function sign = classifier(image)
    % Classifies an RBG Image into four classes of hand gestures.
    %   The classifier uses up to three features of the hand image and
    %   according to them it classifies the image as:
    %       * fist gesture
    %       * Open hand gesture
    %       * L-Sign gesture
    %       * Y-Sign gesture
    %
    %   Arguments: RBG Image
    %   
    %   Returns: A string (sign) with 5 possible values: exit, start_stop, 
    %            next, previous, none, which are used by the main program
    %            as signals for the music player.
    %   
    %   See also: process_image
    
    % Calls the process_image function to get the feature of the hand.
    [formFactor,solidity,extent,bwImage] = process_image(image);
    
    % Fist
    if (formFactor > 0.62 && formFactor < 0.83)
        sign = "exit";
    
    % L or Y Sign
    elseif ((0.30 < formFactor  && formFactor  < 0.37) && ...
            (0.69 < solidity    && solidity    < 0.75) && ...
            (0.4  < extent      && extent      < 0.5 ))
        
        % Reprocess the image
        [leftFormFactor,rightFormFactor] = half_image_process(bwImage);
        
        % Classify according to the new features of the left & right side 
        % of the hand.
        if(abs(leftFormFactor-rightFormFactor) > 0.2)
            sign = "next";
        elseif (abs(leftFormFactor-rightFormFactor) < 0.1)
            sign = "previous";
        else
            if (leftFormFactor < 0.31 || rightFormFactor < 0.31)
                sign = "next";
            else
                sign = "previous";
            end
        end
    
    % L sign
    elseif ((0.26 < formFactor  && formFactor  < 0.37) && ...
            (0.65 < solidity    && solidity    < 0.75) && ...
            (0.4  < extent      && extent      < 0.5))
        sign = "next";
    
    % Y sign
    elseif ((0.30 < formFactor  && formFactor  < 0.42) && ...
            (0.69 < solidity   && solidity     < 0.8)  && ...
            (0.4  < extent      && extent      < 0.54))
        sign = "previous";
    
    % Open hand
    elseif (formFactor > 0.12 && formFactor < 0.25)
        sign = "start_stop";
        
    else
        sign = "None";
    end