%function [topLeftX,topLeftY,boxWidth,boxHeight] = getCropRect(backgroundImage)
    % Calculates the coordinates, the  width and the height of the ROI 
    %   The region of intrest is the white box the black tape define
    %   (more info at the setup section of the paper)
    %
    %   Arguments: RGB Image of the setup
    %
    %   Returns:
    %       topLeftX - X Coordinate of the top left pixel in the ROI
    %       topLeftY - Y Coordinate of the top left pixel in the ROI
    %       boxWidth - The width of the ROI
    %       boxHeight - The height of the ROI
    
    % Convert the RGB image to grayscale and calculate the threshold
    backgroundImage = imread("images/bg.bmp");
    grayscaleImage = rgb2gray(backgroundImage);
    grayscaleLevel = graythresh(grayscaleImage);
    
    % Convert the image to black & white with thresholding
    bwImage = im2bw(grayscaleImage,grayscaleLevel);
    imshow(bwImage);
    
    % Apply a mild morphological correction
    bwImage = imopen(bwImage,strel('line',5,0));
    
    % Get the width and height of the image
    width = size(bwImage,1);
    height = size(bwImage,2);
    
    % Find the top left pixel where the ROI starts. This pixel has to be a
    % white with its left and top neighboor as black pixels.
    topLeftX = 1;
    topLeftY = 1;
    minimumSum = width/3 + height/3;
    for i = 2:width/3
        for j = 2:height/3
            if ((bwImage(i,j) == 1) && (bwImage(i-1,j) == 0) && (bwImage(i,j-1) == 0))
                % In case of multiple pixels with this features pick the 
                % smallest one (aka top-left pixel of ROI).
                if(i+j < minimumSum)
                    topLeftX = j;
                    topLeftY = i;
                    minimumSum = i+j;
                end
            end
        end
    end
    
    % Determine the width by checking every pixel in the same row as the 
    % found top-left pixel. If a black pixel is found then we hit a border.
    boxWidth = topLeftX;
    while(bwImage(topLeftY,boxWidth) == 1)
        boxWidth = boxWidth+1;
    end
    boxWidth = boxWidth-1;
    
    
    % Determine the width by checking every pixel in the same column as the 
    % found top-left pixel. If a black pixel is found then we hit a border.
    boxHeight = topLeftY;
    while(bwImage(boxHeight,topLeftX) == 1)
        boxHeight = boxHeight+1;
    end
    boxHeight = boxHeight-1;
