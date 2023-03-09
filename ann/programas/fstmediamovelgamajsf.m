function [mm]=fstmediamovelgamajsf(P, f, e, p)
% Aplicar FMMG em P usando 'f' e 'e'

% [w] = fscpesosmediamovelgamajsf(f, e, p);
% [mm]= convoluir(w,P);
x=0:1:50; w=gampdf(x,f,e); w=w/sum(w); w=w(w>p); w=w/sum(w);
mm = ones(1,size(P,2)); w_size=size(w,2);
for i=1:w_size-1
    mm(1,i)=fliplr(w)*[ones(1,size(w,2)-i)*P(1,i) P(1,1:i)]';
end
sai=conv(w,P); mm(1,w_size:end)=sai(1,size(w,2):end-size(w,2)+1);
end

% function [w] = fscpesosmediamovelgamajsf(f, e, p)
% x=0:1:50; w=gampdf(x,f,e); w=w/sum(w); w=fliplr(w); w=w(w>p); w=w/sum(w);
% end
% 
% function [mm]= convoluir(w,P)
% mm = ones(1,size(P,2)); w_size=size(w,2);
% for i=1:w_size-1
%     mm(1,i)=w*[ones(1,size(w,2)-i)*P(1,i) P(1,1:i)]';
% end
% sai=conv(fliplr(w),P); mm(1,w_size:end)=sai(1,size(w,2):end-size(w,2)+1);
% end