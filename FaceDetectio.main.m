clear all;
      obj=vision.VideoFileReader('banamali.avi');
      for k=0:5
      videoFrame      = step(obj);
            FaceDetect = vision.CascadeObjectDetector;
  %FaceDetectclc;
           BB = step(FaceDetect,videoFrame);
            %BB
             figure(2),
             imshow(videoFrame);
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