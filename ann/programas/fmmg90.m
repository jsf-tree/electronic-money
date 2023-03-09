function [registros] = fmmg90(F,E)
% [registros] = fmmg90(F,E)
%
% Retorna o n�mero de registros necess�rios que somam 90% de import�ncia
% para o FMMG. 

for i=1:size(F,2)
    p=0.2;
    while sum(fscpesosmediamovelgama(F(i), E(i), p))<0.9
    p=p/1.1;
    end
registros(i)=size(fscpesosmediamovelgama(F(i), E(i), p),2);
end
end
