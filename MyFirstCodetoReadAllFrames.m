clc;    
close all;
imtool close all;
clear;
workspace;
fontSize = 22;
folder = fileparts(which('banamali1.avi'));
movieFullFileName = fullfile(folder, 'banamali1.avi');
if ~exist(movieFullFileName, 'file')
	strErrorMessage = sprintf('File not found:\n%s\nYou can choose a new one, or cancel', movieFullFileName);
	response = questdlg(strErrorMessage, 'File not found', 'OK - choose a new movie.', 'Cancel', 'OK - choose a new movie.');
	if strcmpi(response, 'OK - choose a new movie.')
		[baseFileName, folderName, FilterIndex] = uigetfile('*.avi');
		if ~isequal(baseFileName, 0)
			movieFullFileName = fullfile(folderName, baseFileName);
		else
			return;
		end
	else
		return;
	end
end

try
	videoObject = VideoReader(movieFullFileName)
	numberOfFrames = videoObject.NumberOfFrames;
	vidHeight = videoObject.Height;
	vidWidth = videoObject.Width;
	
	numberOfFramesWritten = 0;
	figure;
	set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
	promptMessage = sprintf('Do you want to save the individual frames out to individual disk files?');
    button = questdlg(promptMessage, 'Save individual frames?', 'Yes', 'No', 'Yes');
	if strcmp(button, 'Yes')
		writeToDisk = true;
		[folder, baseFileName, extentions] = fileparts(movieFullFileName);
		folder = pwd;  
		outputFolder = sprintf('%s/Movie Frames from %s', folder, baseFileName);
		if ~exist(outputFolder, 'dir')
			mkdir(outputFolder);
		end
	else
		writeToDisk = false;
	end
	meanGrayLevels = zeros(numberOfFrames, 1);
	meanRedLevels = zeros(numberOfFrames, 1);
	meanGreenLevels = zeros(numberOfFrames, 1);
	meanBlueLevels = zeros(numberOfFrames, 1);
	for frame = 1 : numberOfFrames
		thisFrame = read(videoObject, frame);
		hImage = subplot(2, 2, 1);
		image(thisFrame);
		caption = sprintf('Frame %4d of %d.', frame, numberOfFrames);
		title(caption, 'FontSize', fontSize);
		drawnow;
		if writeToDisk
			outputBaseFileName = sprintf('Frame %4.4d.png', frame);
			outputFullFileName = fullfile(outputFolder, outputBaseFileName);
			text(5, 15, outputBaseFileName, 'FontSize', 20);
			frameWithText = getframe(gca);
			imwrite(frameWithText.cdata, outputFullFileName, 'png');
		end
		grayImage = rgb2gray(thisFrame);
		meanGrayLevels(frame) = mean(grayImage(:));
		meanRedLevels(frame) = mean(mean(thisFrame(:, :, 1)));
		meanGreenLevels(frame) = mean(mean(thisFrame(:, :, 2)));
		meanBlueLevels(frame) = mean(mean(thisFrame(:, :, 3)));
        hPlot = subplot(2, 2, 2);
		hold off;
		plot(meanGrayLevels, 'k-', 'LineWidth', 2);
		hold on;
		plot(meanRedLevels, 'r-');
		plot(meanGreenLevels, 'g-');
		plot(meanBlueLevels, 'b-');
		grid on;
		title('Mean Gray Levels', 'FontSize', fontSize);
		if frame == 1
			xlabel('Frame Number');
			ylabel('Gray Level');
            [rows, columns, numberOfColorChannels] = size(thisFrame);
		end
		if writeToDisk
			progressIndication = sprintf('Wrote frame %4d of %d.', frame, numberOfFrames);
		else
			progressIndication = sprintf('Processed frame %4d of %d.', frame, numberOfFrames);
		end
		disp(progressIndication);
		numberOfFramesWritten = numberOfFramesWritten + 1;
		alpha = 0.5;
		if frame == 1
			Background = thisFrame;
		else
			Background = (1-alpha)* thisFrame + alpha * Background;
        end
        subplot(2, 2, 3);
		imshow(Background);
		title('Adaptive Background', 'FontSize', fontSize);
		differenceImage = thisFrame - uint8(Background);
		grayImage = rgb2gray(differenceImage); 
		thresholdLevel = graythresh(grayImage);
		binaryImage = im2bw( grayImage, thresholdLevel);
		subplot(2, 2, 4);
		imshow(binaryImage);
		title('Binarized Difference Image', 'FontSize', fontSize);
	end
	if writeToDisk
		finishedMessage = sprintf('Done!  It wrote %d frames to folder\n"%s"', numberOfFramesWritten, outputFolder);
	else
		finishedMessage = sprintf('Done!  It processed %d frames of\n"%s"', numberOfFramesWritten, movieFullFileName);
	end
	disp(finishedMessage); 
	uiwait(msgbox(finishedMessage)); 
	if ~writeToDisk
		return;
	end
	promptMessage = sprintf('Do you want to recall the individual frames\nback from disk into a movie?\n(This will take several seconds.)');
	button = questdlg(promptMessage, 'Recall Movie?', 'Yes', 'No', 'Yes');
	if strcmp(button, 'No')
		return;
    end
    writerObj = VideoWriter('NewRhinos.avi');
	open(writerObj);
	allTheFrames = cell(numberOfFrames,1);
	allTheFrames(:) = {zeros(vidHeight, vidWidth, 3, 'uint8')};
	allTheColorMaps = cell(numberOfFrames,1);
	allTheColorMaps(:) = {zeros(256, 3)};
	recalledMovie = struct('cdata', allTheFrames, 'colormap', allTheColorMaps)
	for frame = 1 : numberOfFrames
	outputBaseFileName = sprintf('Frame %4.4d.png', frame);
		outputFullFileName = fullfile(outputFolder, outputBaseFileName);
		thisFrame = imread(outputFullFileName);
		recalledMovie(frame) = im2frame(thisFrame);
		writeVideo(writerObj, thisFrame);
	end
	close(writerObj);
	delete(hImage);
	delete(hPlot);
	subplot(1, 3, 2);
	axis off;  
	title('Movie recalled from disk', 'FontSize', fontSize);
	movie(recalledMovie);
	msgbox('Done with this demo!');
	catch ME
	strErrorMessage = sprintf('Error extracting movie frames from:\n\n%s\n\nError: %s\n\n)', movieFullFileName, ME.message);
	uiwait(msgbox(strErrorMessage));
end
