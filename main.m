clear all;
close all
clc;
word=[];
word5=[];
%str1='C:\Users\Nilima\Desktop\code\mainfolder\s1faces\img001.jpg';
i=1;
T=[];
for i=1 % No. of objects
    l=i-1;
    a='C:\Users\algebra\Desktop\codesandthesis\code\mainfolder\';% Enter path of the database;
    b=char('s1faces'); % My path contains folder names img001..so..
    b(i,:) % Track Training
    str=strcat(a,b(i,:));
   for j=1:50 % No. of images used to train..My database contains 200 images with names img001,img011,img111...
        if(j/10<1)
            f='00';
            str1=strcat(str,'\','img',f,num2str(j),'.jpg');
        else if(j/10<10)
                f='0';
                str1=strcat(str,'\','img',f,num2str(j),'.jpg');
            else
                str1=strcat(str,'\','img',num2str(j),'.jpg');
            end
    end
       % disp(i)
       % if(find(rej==i)>0)
        %continue;
        %end
        %str1=strcat(num2str(i),'.jpg');
        %str1=strcat('C:\Users\Desktop\tech_geek_files\All DB\',str1);
        im=imread(str1); % Read image
        info=imfinfo(str1);
        if(strcmp(info.ColorType,'truecolor'))
            im=rgb2gray(im);% Conver image to grayscale if it is not
        end
        sigma=4; % Input values to harris
        thresh=3000;
        radius=3;
        disp=0;
        [cim, r, c] = harris(im, sigma, thresh, radius, disp);
        %[cim, r, c] = harris(thresh, radius, disp);
        k=[r c];
        a=insertMarker(im,k);
        imshow(a);
        sift_radius=6; % Radius around the corners to be considered for calculating SIFT vector
        circles=zeros([size(c,1),3]);
        circles(:,1)=c;
        circles(:,2)=r;
        circles(:,3)=sift_radius*ones([size(c,1),1]);
        sift_arr = find_sift(im, circles, 1.5); % Find sift vector around the corner
        s_values= svd(sift_arr);        
        s_values=s_values(1:10,:)';
        if(l==0)  
        T=[T;[1 0]];
        else
            T=[T;[0 1]]
         end
        if(i<=2)
           Codeword1=[Codeword1;sift_arr]; % Store that vector in to a matrix
        else
            word5=[word5;s_values]; % To avoid 'Out of memory problem'
        end
    end
end

%X=[Codeword1;Codeword2];% Combine both codewords..to avoid 'Out of memory' problem
%X=X(:);
% save('modified_4_3000_3_6.mat','X');% Just save for experimenting
% X=X';
% CX=vgg_kmeans(X,16);% Clustering
% CX=CX';
% [idx,centers]=kmeans(X,500,'MaxIter',1000);
% save( 'centers.mat','centers');