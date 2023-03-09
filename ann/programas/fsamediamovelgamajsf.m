function [F, E, def] = fsamediamovelgamajsf(P, T,  maxfor, maxesc, maxdef, p)
% Otimiza par�metros para o Filtro Gama, maximizando a correla��o entre P e T
% (Maior coeficiente de Pearson absoluto)
%
% Entradas: P, T,  maxfor, maxesc, maxdef, p
%   P:      S�rie sequencial a ser transformada.
%   T:      S�rie sequencial de ajuste, podendo ser n�veis ou vaz�es no caso de transforma��o de chuvas.
%   maxfor: Maximo fator de forma  pesquisado.  Se maxfor=[], maxfor=80.
%   maxesc: Maximo fator  de escala  pesquisado. Se maxesc=[], maxfor=50.
%   maxdef: M�xima defasagem pesquisada
%   p:      Menor valor (precis�o) dos pesos de pondera��o da m�dia m�vel. Se n�o informado adota 0.01.
%
% Saida: 
%   F:      Fator de forma encontrado
%   E:      Fator de escala encontrado
%   def:    Defasagem do filtro encontrada
%
% Poss�veis melhoras:   � ":0.5:" - Poderia aumentar a procura
%                       � Manter os pesos em x=0 e retirar somente aqueles que se estendem ao infinito p>0.01;
% Adaptado por Juliano Santos Finck
% 26/04/2020 �s 21:55
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
            mm=[NaN mm(1:end-1)];                                               % Avan�a 1 step
            ha_dados=isnan(mm)+isnan(T2)==0; mm=mm(ha_dados); T2=T2(ha_dados);  % Eliminar NaN
            r=corrcoef(mm,T2);r=r(1,2);                                         % Pearson
            if abs(r)>abs(r0)                                                   % Se maior Pearson mais de todos
                r0=r; F=f; E=e; def=DEF;                                        % Salvar Pearson, F e E
            end
        end
    end %e=1:maxesc
end %f=1:maxfor
end