% This script serves as an automatic tester for the classifier.
%   It loads the testing files sequentially and test them against the
%   classifier.
%   The files must be named in a correct manner:
%       * Open hand as open[i].jpg, where [i] = 1,2,...
%       * Fist as fist[i].jpg, where [i] = 1,2,...
%       * L-Sign as next[i].jpg, where [i] = 1,2,...
%       * Y-Sign as previous[i].jpg, where [i] = 1,2,...
%
%   We used this file to construct the confusion matrix.

%% Test open hand gestures
imageFiles = dir('images/testing/open*.jpg');

openHandPassed = 0;
openHandFailed = 0;

for i=1:size(imageFiles,1)
    image = imread(imageFiles(i).name);
    sign = classifier(image);
    if(sign == "start_stop")
        openHandPassed = openHandPassed+1;
    else
        openHandFailed = openHandFailed+1;
    end
end

%% Test Fist gestures
imageFiles = dir('images/testing/fist*.jpg');

fistPassed = 0;
fistFailed = 0;

for i=1:size(imageFiles,1)
    image = imread(imageFiles(i).name);
    sign = classifier(image);
    if(sign == "exit")
        fistPassed = fistPassed+1;
    else
        fistFailed = fistFailed+1;
    end
end

%% Test L-Sign gestures
imageFiles = dir('images/testing/next*.jpg');

nextPassed = 0;
nextFailed = 0;

for i=1:size(imageFiles,1)
    image = imread(imageFiles(i).name);
    sign = classifier(image);
    if(sign == "next")
        nextPassed = nextPassed+1;
    else
        nextFailed = nextFailed+1;
    end
end

%% Test Y-Sign Gestures

imageFiles = dir('images/testing/previous*.jpg');

previousPassed = 0;
previousFailed = 0;

for i=1:size(imageFiles,1)
    image = imread(imageFiles(i).name);
    sign = classifier(image);
    if(sign == "previous")
        previousPassed = previousPassed+1;
    else
        previousFailed = previousFailed+1;
    end
end