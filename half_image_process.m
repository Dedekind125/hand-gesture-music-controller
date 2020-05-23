function [leftFormFactor,rightFormFactor] = half_image_process(bwImage)
    % Cut a black & white image in half with a single BLOB in it.
    %   This function is used to further analyze an L or Y sign by
    %   calculating the form factor of the left and right sub-images.
    %   See also: classifier
    %
    %   Arguments: Black & White with a single BLOB in it. 
    %
    %   Returns:
    %       leftFormFactor - The form factor of the left sub-image
    %       rightFormFactor - The form factor of the right sub-image

    % Use the Bounding Box feature to locate the hand location.
    [labels,~] = bwlabel(bwImage);
    stats = regionprops(labels, 'BoundingBox');
    box = stats(1).BoundingBox;
    
    % Have the black & white image with the hand center in the image
    bwImage = imcrop(bwImage, [box(1) box(2) box(3) box(4)]);
    
    % Calculate the center of the image and create the left & right images
    center = size(bwImage,2)/2+.5;
    leftBWImage = bwImage(:,1:center);
    rightBWImage= bwImage(:,center:size(bwImage,2));
    
    % Left side image
    [labels_left,~] = bwlabel(leftBWImage);
    leftStats = regionprops(labels_left, 'all');
    leftArea = leftStats(1).Area;
    perimeter_left = leftStats(1).Perimeter;
    leftFormFactor = 4*pi*leftArea/((perimeter_left)^2);
    
    % Right side image
    [labels_right,~] = bwlabel(rightBWImage);
    rightStats = regionprops(labels_right, 'all');
    rightArea = rightStats(1).Area;
    rightPerimeter = rightStats(1).Perimeter;
    rightFormFactor = 4*pi*rightArea/((rightPerimeter)^2);

