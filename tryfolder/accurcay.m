clear;
load functions
syms x
range = 0 < x & x < 56;
fprintf('The speech accuracy is ')
x1 = trainfacial();
fprintf('The facial accuracy is ')
x2 = trainspeech();
x4 = subs(range,x,1);
x5 = subs(range,x,0);
    if(isAlways(x1) && isAlways(x2))
        fprintf('The final output is  = %f', isAlways(x4))
    else
        fprintf('The final output is  = %f',isAlways(x5));
    end    