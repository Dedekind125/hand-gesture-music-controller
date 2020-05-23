function [formFactor,solidity,extent,bwImage] = process_image(image)
    % Process the image with adaptive thresholding.
    %   With this function we are trying to find the hand gesture as a
    %   single Binary Large OBject
    %   More info: http://homepages.inf.ed.ac.uk/rbf/HIPR2/adpthrsh.htm
    %   
    %   Arguments: RGB Image with the hand gesture
    %
    %   Returns:
    %       formFactor: The form factor of the hand BLOB (0 if not found)
    %       solidity: The solidity of the hand BLOB (0 if not found)
    %       extent: The extent of the hand BLOB (0 if not found)
    %       bwImage: The post process b&w image 
    
    % Convert the RGB hand image to grayscale
    grayscaleImage = rgb2gray(image);
    
    % Try the adaptive thresholding with different windows sizes
    for windowSize = 5:2:17
        % Adaptive thersholding
        filteredImage = imfilter(image,fspecial('average',windowSize),'replicate');
        filteredImage = filteredImage-grayscaleImage-windowSize;
        
        % Convert the image to black and white
        bwImage = im2bw(filteredImage,0);
        
        % Apply a mild morphological correction
        bwImage = imopen(bwImage,strel('disk',12));
        
        [labels,numLabels]=bwlabel(bwImage);
        if (numLabels == 1)
            break;
        end
    end

    % Get the features of the hand BLOB if found, else return 0 values.
    if (numLabels == 1)
        stats = regionprops(labels, 'all');
        
        area = stats(1).Area;
        perimeter = stats(1).Perimeter;
        
        formFactor = 4*pi*area/((perimeter)^2);
        solidity = stats(1).Solidity;
        extent = stats(1).Extent;
    else
        formFactor = 0;
        solidity = 0;
        extent = 0;
    end