a=VideoReader('banamali.avi');
for img=1:a.NumberOfFrames;
    filename=strcat('BanamaliFrames\frames',num2str(img),'.jpg');
    b=read(a, img);
    imwrite(b,filename);
end