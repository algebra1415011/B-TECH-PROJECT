clear all;
      obj=vision.VideoFileReader('manish.avi');
      for k=0:15
      videoFrame      = step(obj);
            FaceDetect = vision.CascadeObjectDetector;
  %To detect Nose
NoseDetect = vision.CascadeObjectDetector('Nose')
BB=step(NoseDetect,videoFrame);
figure(2),
imshow(videoFrame); hold on
for i = 1:size(BB,1)
 rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
end
title('Nose Detection');
hold off;
      %crop Noses and convert it to gray
      for i = 1:size(BB,1)
      J= imcrop(videoFrame,BB(i,:));
      I=rgb2gray(imresize(J,[292,376]));
      %save cropped Noses in folder
      filename = [num2str(i+k*(size(BB,1))) '.jpg'];
          imwrite(I,filename);
      end
      end