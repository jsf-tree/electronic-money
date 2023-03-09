function [registros] = fmme90(mv)
% [registros] = fmme90(mv)
%
% Retorna o n�mero de registros necess�rios que somam 90% de import�ncia
% para o FMME. 

for i=1:size(mv,2)
    p=0.2;
    while sum(fscpesosmediamovelexpo(mv(i),p))<0.9
    p=p/1.1;
    end
registros(i)=size(fscpesosmediamovelexpo(mv(i),p),2);
end
end
