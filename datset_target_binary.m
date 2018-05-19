  clear;
load classsbinary.mat;
dataset1=ans;
s=size(dataset1);
for i=1:s(1,1)
    if(dataset1(i,s(1,2))==0)
        dataset1(i,s(1,2))=1;
        dataset1(i,(s(1,2)+1))=0;
        dataset1(i,(s(1,2)+2))=0;
        dataset1(i,(s(1,2)+3))=0;
        dataset1(i,(s(1,2)+4))=0;
        dataset1(i,(s(1,2)+5))=0;
        dataset1(i,(s(1,2)+6))=0;
        dataset1(i,(s(1,2)+7))=0;
        dataset1(i,(s(1,2)+8))=0;
        dataset1(i,(s(1,2)+9))=0;
        
        
    elseif(dataset1(i,s(1,2))==1)
        dataset1(i,s(1,2))=0;
        dataset1(i,(s(1,2)+1))=1;
        dataset1(i,(s(1,2)+2))=0;
        dataset1(i,(s(1,2)+3))=0;
        dataset1(i,(s(1,2)+4))=0;
        dataset1(i,(s(1,2)+5))=0;
        dataset1(i,(s(1,2)+6))=0;
        dataset1(i,(s(1,2)+7))=0;
        dataset1(i,(s(1,2)+8))=0;
        dataset1(i,(s(1,2)+9))=0;
    elseif(dataset1(i,s(1,2))==2)
       dataset1(i,s(1,2))=0;
        dataset1(i,(s(1,2)+1))=0;
        dataset1(i,(s(1,2)+2))=1;
        dataset1(i,(s(1,2)+3))=0;
        dataset1(i,(s(1,2)+4))=0;
        dataset1(i,(s(1,2)+5))=0;
        dataset1(i,(s(1,2)+6))=0;
        dataset1(i,(s(1,2)+7))=0;
        dataset1(i,(s(1,2)+8))=0;
        dataset1(i,(s(1,2)+9))=0;
        
     elseif(dataset1(i,s(1,2))==3)
       dataset1(i,s(1,2))=0;
        dataset1(i,(s(1,2)+1))=0;
        dataset1(i,(s(1,2)+2))=0;
        dataset1(i,(s(1,2)+3))=1;
        dataset1(i,(s(1,2)+4))=0;
        dataset1(i,(s(1,2)+5))=0;
        dataset1(i,(s(1,2)+6))=0;
        dataset1(i,(s(1,2)+7))=0;
        dataset1(i,(s(1,2)+8))=0;
        dataset1(i,(s(1,2)+9))=0;
   elseif(dataset1(i,s(1,2))==4)
        dataset1(i,s(1,2))=0;
        dataset1(i,(s(1,2)+1))=0;
        dataset1(i,(s(1,2)+2))=0;
        dataset1(i,(s(1,2)+3))=0;
        dataset1(i,(s(1,2)+4))=1;
        dataset1(i,(s(1,2)+5))=0;
        dataset1(i,(s(1,2)+6))=0;
        dataset1(i,(s(1,2)+7))=0;
        dataset1(i,(s(1,2)+8))=0;
        dataset1(i,(s(1,2)+9))=0;
%         elseif(dataset1(i,s(1,2))==5)
%         dataset1(i,s(1,2))=0;
%         dataset1(i,(s(1,2)+1))=0;
%         dataset1(i,(s(1,2)+2))=0;
%         dataset1(i,(s(1,2)+3))=0;
%         dataset1(i,(s(1,2)+4))=0;
%         dataset1(i,(s(1,2)+5))=1;
%         dataset1(i,(s(1,2)+6))=0;
%         dataset1(i,(s(1,2)+7))=0;
%         dataset1(i,(s(1,2)+8))=0;
%         dataset1(i,(s(1,2)+9))=0;
%         elseif(dataset1(i,s(1,2))==6)
%         dataset1(i,s(1,2))=0;
%         dataset1(i,(s(1,2)+1))=0;
%         dataset1(i,(s(1,2)+2))=0;
%         dataset1(i,(s(1,2)+3))=0;
%         dataset1(i,(s(1,2)+4))=0;
%         dataset1(i,(s(1,2)+5))=0;
%         dataset1(i,(s(1,2)+6))=1;
%         dataset1(i,(s(1,2)+7))=0;
%         dataset1(i,(s(1,2)+8))=0;
%         dataset1(i,(s(1,2)+9))=0;
%         elseif(dataset1(i,s(1,2))==7)
%         dataset1(i,s(1,2))=0;
%         dataset1(i,(s(1,2)+1))=0;
%         dataset1(i,(s(1,2)+2))=0;
%         dataset1(i,(s(1,2)+3))=0;
%         dataset1(i,(s(1,2)+4))=0;
%         dataset1(i,(s(1,2)+5))=0;
%         dataset1(i,(s(1,2)+6))=0;
%         dataset1(i,(s(1,2)+7))=1;
%         dataset1(i,(s(1,2)+8))=0;
%         dataset1(i,(s(1,2)+9))=0;
%         elseif(dataset1(i,s(1,2))==8)
%         dataset1(i,s(1,2))=0;
%         dataset1(i,(s(1,2)+1))=0;
%         dataset1(i,(s(1,2)+2))=0;
%         dataset1(i,(s(1,2)+3))=0;
%         dataset1(i,(s(1,2)+4))=0;
%         dataset1(i,(s(1,2)+5))=0;
%         dataset1(i,(s(1,2)+6))=0;
%         dataset1(i,(s(1,2)+7))=0;
%         dataset1(i,(s(1,2)+8))=1;
%         dataset1(i,(s(1,2)+9))=0;
%         elseif(dataset1(i,s(1,2))==9)
%         dataset1(i,s(1,2))=0;
%         dataset1(i,(s(1,2)+1))=0;
%         dataset1(i,(s(1,2)+2))=0;
%         dataset1(i,(s(1,2)+3))=0;
%         dataset1(i,(s(1,2)+4))=0;
%         dataset1(i,(s(1,2)+5))=0;
%         dataset1(i,(s(1,2)+6))=0;
%         dataset1(i,(s(1,2)+7))=0;
%         dataset1(i,(s(1,2)+8))=0;
%         dataset1(i,(s(1,2)+9))=1;
        
    end
end

classbinary =  dataset1(randperm(end),:);