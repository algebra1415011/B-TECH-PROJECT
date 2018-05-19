clear all;
      obj=vision.VideoFileReader('manish.avi');
      for k=0:20
      videoFrame      = step(obj);
            FaceDetect = vision.CascadeObjectDetector;
  %To detect EYE
MouthDetect = vision.CascadeObjectDetector('Mouth');
%EYEDetector.MergeThreshold=100
BB=step(MouthDetect,videoFrame);
figure(2),
imshow(videoFrame); hold on
for i = 1:size(BB,1)
 rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
end
title('Mouth Detection');
hold off;
      %crop EYE and convert it to gray
      for i = 1:size(BB,1)
      J= imcrop(videoFrame,BB(i,:));
      I=rgb2gray(imresize(J,[292,376]));
      %save cropped EYE in folder
      %save(strcat('C:\Users\cs1\Desktop\PROJECT\zeromfcc\',m,'zeromfcc',n,'.jpg'));
      filename = [num2str(i+k*(size(BB,1))) '.jpg'];
          imwrite(I,filename);
      end
      end