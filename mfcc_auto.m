function best_fit = mfcc_auto( data1, num, fs )
%MFCC correlation calculation
max = 0;
second_fit = 0;
third_fit = 0;
best_fit = 0;
%Create database of bird calls
database_entry = strvcat('C:\Users\cs1\Desktop\PROJECT\modified data waves\');
%Find the size of the database
S = size(database_entry);
%Compare the MFCC correlation vectors of each bird call
% with the unknown bird call to find the best fit
for i = 1:S(1)
 compared(i) = mean(x(2:num));
 if compared(i) > max
 max = compared(i);
 third_fit = second_fit;
 second_fit = best_fit;
 best_fit = database_entry(i,:);
 end
end
%Output the best fit
third_fit
second_fit
max
mfcc(data1,best_fit,num,fs);
end
%MFCC Comparison Code
function x = mfcc_nooutput( data1, data2, num, fs )
%MFCC correlation calculation
%Read in the wave files
y1 = wavread(data1);
y2 = wavread(data2);
%Calculate MFCCs
86
z1 = kannumfcc(num,y1,fs);
z2 = kannumfcc(num,y2,fs);
%Find the size of the MFCCs
[s1,q] = size(z1);
[s2,q] = size(z2);
%Compare the sizes to fix any differences in size
% between the two files
if(s1 ~= s2)
 if(s1 > s2)
 z2 = padarray(z2,(s1-s2),0,'post');
 end
 if(s1 < s2)
 z1 = padarray(z1,(s2-s1),0,'post');
 s1 = s2;
 end
end
%Go through each MFCC infividually and find their
% cross correlation values
s = size(z1);
for i=2:num
 [C,I] = max(xcorr(z1(:,i),z2(:,i)));
 g(:,i) = xcorr(z1(:,i),z2(:,i));
 if(I < (s1))
 w1(1:(s+(s1-I)),i) = padarray(z1(:,i),((s1)-I),0,'pre');
 w2(1:(s+(s1-I)),i) = padarray(z2(:,i),((s1)-I),0,'post');
 end
 if(I > (s1))
 w1(1:(s+(I-s1)),i) = padarray(z1(:,i),(I-(s1)),0,'post');
 w2(1:(s+(I-s1)),i) = padarray(z2(:,i),(I-(s1)),0,'pre');
 end
 if(I == (s1))
 w1 = z1;
 w2 = z2;
 end
end
%Output the correlation vector for comparison
for i=1:num
 x(i) = corr(w1(:,i),w2(:,i));
end
end