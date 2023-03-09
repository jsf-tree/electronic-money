function [r] =fddcorrelacionar_jsf(mm, dT)
% [r] =fddcorrelacionar_jsf(mm, dT)
% Foi montada apenas para substituir a função do Prof. Olavo porque a dele
% plotava certos dados que eu quis evitar.
%
a=[mm;dT];
a(:,find(isnan(a(1,:))))=[];
a(:,find(isnan(a(2,:))))=[];
r=corrcoef(a(1,:),a(2,:));
r=r(1,2);
end

