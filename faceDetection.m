     clear all;
      obj=vision.VideoFileReader('test.avi');
      for k=0:99
      videoFrame      = step(obj);
            FaceDetect = vision.CascadeObjectDetector;
  %FaceDetectclc;
           BB = step(EyePairBig,videoFrame);
            %BB
             figure(2),imshow(videoFrame);
      for i = 1:size(BB,1)
            rectangle('Position',BB(i,:),'LineWidth',3,'LineStyle','-','EdgeColor','r');
      end
      %crop faces and convert it to gray
      for i = 1:size(BB,1)
      J= imcrop(videoFrame,BB(i,:));
      I=rgb2gray(imresize(J,[292,376]));
      %save cropped faces in folder
      filename = [num2str(i+k*(size(BB,1))) '.jpg'];
          imwrite(I,filename);
      end
      end
%To detect Mouth
%MouthDetect = vision.CascadeObjectDetector('Nose')
%BB=step(MouthDetect,videoFrame)
%figure(2),
%imshow(videoFrame); 
%for i = 1:size(BB,1)
   %rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
%end
%for i = 1:size(BB,1)
     % J= imcrop(videoFrame,BB(i,:));
      %I=rgb2gray(imresize(J,[292,376]));
%filename = [num2str(i+k*(size(BB,1))) '.jpg'];
          %imwrite(I,filename);
%title('Mouth Detection');
%hold off;      
      
      
      