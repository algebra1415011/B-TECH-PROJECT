clear;
i=2; %:5
 j=1;
m=num2str(i);
n=num2str(j);
load(strcat('C:\Users\algebra\Desktop\codesandthesis\code\mainfolder\','Codeword20','.mat'));
f9=v1;
 for i=9%:5
    for j=2:100
        m=num2str(i);
        n=num2str(j);
         load(strcat('C:\Users\algebra\Desktop\codesandthesis\code\mainfolder\','Codeword21','.mat'));
         
         v1=vertcat(word1,word1,word1,word1,word1);
        f9=v1;
         %save(strcat('E:\M.Tech work imple\concatemfcc\Typhoid\mfccall_10.mat'));
         %%save(strcat('E:\1 Work Implementation\MFCCSMALLDATA\ninemfcc\concatenine.mat'));
%          disp (f);
    end
end    

    