function [mm]= convoluir(w,P)
mm = ones(1,size(P,2)); w_size=size(w,2);
for i=1:w_size-1
    mm(1,i)=w*[ones(1,size(w,2)-i)*P(1,i) P(1,1:i)]';
end
sai=conv(fliplr(w),P); mm(1,w_size:end)=sai(1,size(w,2):end-size(w,2)+1);
end