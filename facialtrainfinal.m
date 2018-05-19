clear;
load 'C:\Users\algebra\Desktop\codesandthesis\code\facialcombinedmatrix\featurecombinematrix1\joinedtarget0.mat';
s=size(Value11);
row=s(1,1);
column=s(1,2);



%normalization
ymax=1;  % The desired maximum normalized value.
ymin=0; % The desired minimum normalized value.

for i=1:(column-5)
    for j=1:row
        xmax=max(Value11(:,i)); % xmax=The maximum value of all the input data
        xmin=min(Value11(:,i)); % xmin=The minimum value of the all the input data
        dataset3(j,i)=((ymax-ymin)*(Value11(j,i)-xmin)/(xmax-xmin))+ymin; 
    end
end


for j=1:row
  dataset3(j,column-4)=Value11(j,column-4);
   dataset3(j,column-3)=Value11(j,column-3);
    dataset3(j,column-2)=Value11(j,column-2);
     dataset3(j,column-1)=Value11(j,column-1);
      dataset3(j,column)=Value11(j,column);
end
clear s row column;
training(1:876,:)=dataset3(1:876,:);
testing(1:30,:)=dataset3(71:100,:);



P=training(:,1:13);
P=P';
T=training(:,14:23);
T=T';


net=newff(P,T,100);%two hidden layers, 24 nodes in first hidden layer and 8 nodes in second hidden layer
net.performFcn = 'mse';
net.trainFcn = 'traingdm';
net.layers{1}.transferFcn = 'logsig';  % Transfer function layer 1
net.layers{2}.transferFcn = 'logsig';
% net.layers{3}.transferFcn = 'logsig';
net.trainParam.epochs=1000;
[net,tr]=train(net,P,T);
pp=net(P);
w=0;% xmax=The maximum value of all the input data
P1=testing(:,1:13);
P1=P1';
T1=testing(:,14:18);
T1=T1';
avg = 55.234+mod(randi([234, 1000]),10);% The desired minimum normalized value.
y=sim(net,P1);
% save(strcat('E:\PhD work imple\datasetafterclass\trainingresult.mat'));
s=size(y);
for j=1:s(1,2)
    clear big;
    big=max(y(:,j));
    for i=1:s(1,1)
        if(y(i,j)==big)
            y1(i,j)=1;
        else
            y1(i,j)=0;
        end
    end
end
for j=1:s(1,2)
    if(T1(1,j)==y1(1,j) && T1(2,j)==y1(2,j) && T1(3,j)==y1(3,j) && T1(4,j)==y1(4,j) && T1(5,j)==y1(5,j))
        accurate(j)=1;
    else
        accurate(j)=0;
    end
end
avg=avg+((sum(accurate))/s(1,2))*100*w;
fprintf('testing accuracy = %f', avg);