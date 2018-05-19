%To detect Mouth
clc;
      clear all;
      obj=vision.VideoFileReader('test.avi');
      for k=0:99
      videoFrame      = step(obj);
            
MouthDetect = vision.CascadeObjectDetector('Nose');
BB=step(MouthDetect,I);
figure,
imshow(I); hold on
for i = 1:size(BB,1)
 rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
end
title('Mouth Detection');
hold off;