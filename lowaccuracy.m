clear;
VideoPLay()
I = imread('C:\Users\algebra\Desktop\codesandthesis\code\manish.jpg');
imshow(I);
fprintf('The speech accuracy is ')
x1 =trainspeech()
fprintf('The facial accuracy is ')
x2 = 40
if((x1>=70 && x2>=70) || (x2>=75))
    fprintf('The person is authenticated');
else 
    fprintf('The person is denied');
end    