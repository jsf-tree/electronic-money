function [F, E, def] = fsamediamovelgamajsf(P, T,  maxfor, maxesc, maxdef, p)
% Otimiza parâmetros para o Filtro Gama, maximizando a correlação entre P e T
% (Maior coeficiente de Pearson absoluto)
%
% Entradas: P, T,  maxfor, maxesc, maxdef, p
%   P:      Série sequencial a ser transformada.
%   T:      Série sequencial de ajuste, podendo ser níveis ou vazões no caso de transformação de chuvas.
%   maxfor: Maximo fator de forma  pesquisado.  Se maxfor=[], maxfor=80.
%   maxesc: Maximo fator  de escala  pesquisado. Se maxesc=[], maxfor=50.
%   maxdef: Máxima defasagem pesquisada
%   p:      Menor valor (precisão) dos pesos de ponderação da média móvel. Se não informado adota 0.01.
%
% Saida: 
%   F:      Fator de forma encontrado
%   E:      Fator de escala encontrado
%   def:    Defasagem do filtro encontrada
%
% Possíveis melhoras:   ¹ ":0.5:" - Poderia aumentar a procura
%                       ² Manter os pesos em x=0 e retirar somente aqueles que se estendem ao infinito p>0.01;
% Adaptado por Juliano Santos Finck
% 26/04/2020 às 21:55
r0=0; 
for f=1:maxfor          
    for e=1:maxesc      
        mm=fstmediamovelgamajsf(P, f, e, p);                                    % Transformar P com "f" e "e"
        ha_dados=isnan(mm)+isnan(T)==0; mm=mm(ha_dados); T2=T(ha_dados);        % Eliminar NaN
        r=corrcoef(mm,T2);r=r(1,2);                                             % Pearson
        if abs(r)>abs(r0)                                                       % Se maior Pearson mais de todos
            r0=r; F=f;E=e; def=0;                                               % Salvar Pearson, F e E
        end
        for DEF=1:maxdef
            mm=[NaN mm(1:end-1)];                                               % Avança 1 step
            ha_dados=isnan(mm)+isnan(T2)==0; mm=mm(ha_dados); T2=T2(ha_dados);  % Eliminar NaN
            r=corrcoef(mm,T2);r=r(1,2);                                         % Pearson
            if abs(r)>abs(r0)                                                   % Se maior Pearson mais de todos
                r0=r; F=f; E=e; def=DEF;                                        % Salvar Pearson, F e E
            end
        end
    end %e=1:maxesc
end %f=1:maxfor
end