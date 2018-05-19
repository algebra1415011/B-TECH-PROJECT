clear;
load 'C:\Users\algebra\Desktop\codesandthesis\code\joined11.mat';





s=size(Value11);
row=s(1,1);
column=s(1,2);



%normalization
ymax=1;  % The desired maximum normalized value.
ymin=0; % The desired minimum normalized value.

for i=1:(column-10)
    for j=1:row
        xmax=max(classbinary(:,i)); % xmax=The maximum value of all the input data
        xmin=min(classbinary(:,i)); % xmin=The minimum value of the all the input data
        dataset3(j,i)=((ymax-ymin)*(classbinary(j,i)-xmin)/(xmax-xmin))+ymin; 
    end
end


for j=1:row
   
      dataset3(j,column-9)=classbinary(j,column-1);
       dataset3(j,column-8)=classbinary(j,column-1);
        dataset3(j,column-7)=classbinary(j,column-1);
         dataset3(j,column-6)=classbinary(j,column-1);
          dataset3(j,column-5)=classbinary(j,column-1);
          dataset3(j,column-4)=classbinary(j,column-4);
           dataset3(j,column-3)=classbinary(j,column-3);
            dataset3(j,column-2)=classbinary(j,column-2);
             dataset3(j,column-1)=classbinary(j,column-1);
             dataset3(j,column)=classbinary(j,column);
end
clear s row column;
trainingnew(1:500,:)=dataset3(1:500,:);
testing(1:30,:)=dataset3(71:100,:)


P=trainingnew(:,1:10);
P=P';
T=trainingnew(:,11:20);
T=T';


net=newff(P,T,[100,80]);%two hidden layers, 24 nodes in first hidden layer and 8 nodes in second hidden layer
net.performFcn = 'mse';
net.trainFcn = 'traingdm';
net.layers{1}.transferFcn = 'logsig';  % Transfer function layer 1
net.layers{2}.transferFcn = 'logsig';
net.layers{3}.transferFcn = 'logsig';
%net.layers{3}.transferFcn = 'logsig';
%net.layers{5}.transferFcn = 'logsig';
% net.layers{3}.transferFcn = 'logsig';
net.trainParam.epochs=100;
[net,tr]=train(net,P,T);
pp=net(P);

P1=testing(:,1:10);
P1=P1';
T1=testing(:,11:20);
T1=T1';

y=sim(net,P1);
% save(strcat('E:\M.Tech work imple\datasetafterclass\trainingresult.mat'));
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
avg=((sum(accurate))/s(1,2))*100;
fprintf('testing accuracy = %f', avg);