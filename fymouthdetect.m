clear all;
      obj=vision.VideoFileReader('manish.avi');
      for k=0:5
      videoFrame      = step(obj);
            FaceDetect = vision.CascadeObjectDetector;
            MouthDetect = vision.CascadeObjectDetector('Mouth')
            BB=step(MouthDetect,videoFrame);
figure(2),
imshow(videoFrame); 
hold on
for i = 1+2:size(BB,1)
 rectangle('Position',BB(i-2,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
end
title('Mouth Detection');
hold off;
      end