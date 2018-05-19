clear;
load classbinary.mat;


s1=size(classbinary);
row=s1(1,1);
column=s1(1,2);



%normalization
ymax=1;  % The desired maximum normalized value.
ymin=0; % The desired minimum normalized value.

for i=1:(column-138)
    for j=1:row
        xmax=max(classbinary(:,i)); % xmax=The maximum value of all the input data
        xmin=min(classbinary(:,i)); % xmin=The minimum value of the all the input data
        dataset3(j,i)=((ymax-ymin)*(classbinary(j,i)-xmin)/(xmax-xmin))+ymin; 
    end
end


for j=1:row
    dataset3(j,column-9)=classbinary(j,column-9);
        dataset3(j,column-9)=classbinary(j,column-9);
       dataset3(j,column-8)=classbinary(j,column-8);
        dataset3(j,column-7)=classbinary(j,column-7);
         dataset3(j,column-6)=classbinary(j,column-6);
          dataset3(j,column-5)=classbinary(j,column-5);
          dataset3(j,column-4)=classbinary(j,column-4);
           dataset3(j,column-3)=classbinary(j,column-3);
            dataset3(j,column-2)=classbinary(j,column-2);
             dataset3(j,column-1)=classbinary(j,column-1);
             dataset3(j,column)=classbinary(j,column);
end

sp=round((70/100) * row);%sp means 70 percent of dataset
trainingnew(1:sp,:)=dataset3(1:sp,:);
testing(1:(row-sp),:)=dataset3((sp+1):row,:);

clear s row column;
P=trainingnew(:,1:128);
P=P';
T=trainingnew(:,129:138);
T=T';


net=network;            % An empty network
% Initialize network parameters
net.numInputs = 1;      % Number of vector of inputs
net.inputs{1}.size = 128;    % Number of input
net.numLayers = 2;          % Number of layers (hidden layer and output layer)
net.layers{1}.size = 30;    % Number of neurons in hidden layer
net.layers{2}.size = 10;     % Number of neuron in hidden layer
net.inputConnect(1)= 1;
net.layerConnect(2,1) = 1;
net.outputConnect(2)=1;
net.layers{1}.transferFcn = 'logsig';  % Transfer function layer 1
net.layers{2}.transferFcn = 'logsig';  % Transfer function layer 2
net.initFcn = 'initlay';    % Network initialiazation function
net.layers{1}.initFcn = 'initnw';
net.layers{2}.initFcn = 'initnw';
net = init(net);      
net.inputWeights{1,1}.initFcn = 'rands';    % Weight initiliazation function
net.layerWeights{2,1}.initFcn = 'rands';     
net.trainFcn = 'trainlm';      % Training function
net.performFcn = 'mse';         % Perfermance measure function

[net,tr]=train(net,P,T);

%%training accuracy

y2=sim(net,P);

s1=size(y2);
for j=1:s1(1,2)
    clear big1;
    big1=max(y2(:,j));
    for i=1:s1(1,1)
        if(y2(i,j)==big1)
            y3(i,j)=1;
        else
            y3(i,j)=0;
        end
    end
end
for j=1:s1(1,2)
    if(T(1,j)==y3(1,j) && T(2,j)==y3(2,j) && T(3,j)==y3(3,j) && T(4,j)==y3(4,j) && T(5,j)==y3(5,j)&& T(6,j)==y3(6,j)&& T(7,j)==y3(7,j)&& T(8,j)==y3(8,j)&& T(9,j)==y3(9,j)&& T(10,j)==y3(10,j))
        accurate1(j)=1;
    else
        accurate1(j)=0;
    end
end
avg1=((sum(accurate1))/s1(1,2))*100;
fprintf('training accuracy = %f\n', avg1);





% % %testing accuracy
P1=testing(:,1:128);
P1=P1';
T1=testing(:,128:138);
T1=T1';

y=sim(net,P1);

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
    if(T1(1,j)==y1(1,j) && T1(2,j)==y1(2,j) && T1(3,j)==y1(3,j) && T1(4,j)==y1(4,j) && T1(5,j)==y1(5,j)&& T1(6,j)==y1(6,j)&& T1(7,j)==y1(7,j)&& T1(8,j)==y1(8,j)&& T1(9,j)==y1(9,j)&& T1(10,j)==y1(10,j))
        accurate(j)=1;
    else
        accurate(j)=0;
    end
end
avg=((sum(accurate))/s(1,2))*100;
fprintf('testing accuracy = %f', avg);