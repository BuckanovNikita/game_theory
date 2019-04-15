function res=HandleSameDates(inputArray)
res=[inputArray(1,1) 0];
for i=1:size(inputArray,1)
    res(2)=res(2)+inputArray(i,2);
end