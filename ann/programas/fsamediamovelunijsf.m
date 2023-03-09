function [jan, def] = fsamediamovelunijsf(P, T, maxjan, maxdef)
% Busca melhores par�metros para aplicar o FMME em P que implique na maior
% correla��o com T.
% (Adota aqueles que levam a maior coeficiente de pearson absoluto)
%
% Entradas: P, T,  maxfor, maxesc, maxdef, p
%   P:      S�rie sequencial a ser transformada.
%   T:      S�rie sequencial de ajuste, podendo ser n�veis ou vaz�es no caso de transforma��o de chuvas.
%   maxmv:  Maxima meia vida pesquisada
%   maxdef: Maxima defasagem pesquisada
%   p:      Menor valor (precis�o) dos pesos de pondera��o da m�dia m�vel. Se n�o informado adota 0.01.
%
% Saida: 
%   mv:     M�dia m�vel encontrada
%   def:    Defasagem do filtro encontrada
%
% Adaptado por Juliano Santos Finck
% 02/08/2019 �s 17:41

r0=0;
for JAN=1:maxjan
    mm=fstmediamoveluni(P, JAN, 0);                                         % Transformar P com "MV"
    ha_dados=isnan(mm)+isnan(T)==0; mm=mm(ha_dados); T2=T(ha_dados);        % Eliminar NaN
    r=corrcoef(mm,T2);r=r(1,2);                                             % Pearson
        if abs(r)>abs(r0)                                                   % Se maior Pearson mais de todos
            r0=r;jan=JAN;def=0;                                             % Salvar Pearson, JAN e def
        else
        end
    for DEF=1:maxdef
        mm=[NaN mm(1:end-1)];                                               % Avan�a 1 step
        ha_dados=isnan(mm)+isnan(T2)==0; mm=mm(ha_dados); T2=T2(ha_dados);  % Eliminar NaN
        r=corrcoef(mm,T2);r=r(1,2);                                         % Pearson
        if abs(r)>abs(r0)
            r0=r;jan=JAN;def=DEF;
        else
        end
    end %DEF=1:maxdef
end %JAN=1:maxjan
end