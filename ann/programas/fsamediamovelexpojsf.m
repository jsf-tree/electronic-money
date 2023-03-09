function [mv, def] = fsamediamovelexpojsf(P, T, maxmv, maxdef)
% Busca melhores parâmetros para aplicar o FMME em P que implique na maior
% correlação com T.
% (Adota aqueles que levam a maior coeficiente de pearson absoluto)
%
% Entradas: P, T,  maxfor, maxesc, maxdef, p
%   P:      Série sequencial a ser transformada.
%   T:      Série sequencial de ajuste, podendo ser níveis ou vazões no caso de transformação de chuvas.
%   maxmv:  Maxima meia vida pesquisada
%   maxdef: Maxima defasagem pesquisada
%   p:      Menor valor (precisão) dos pesos de ponderação da média móvel. Se não informado adota 0.01.
%
% Saida: 
%   mv:     Média móvel encontrada
%   def:    Defasagem do filtro encontrada
%
% Adaptado por Juliano Santos Finck
% 02/08/2019 às 17:28

% P=P(l, :); T=dT; maxmv=maxmei; maxdef=maxdef;

r0=0;
for MV=1:0.5:maxmv
    mm=fstmediamovelexpojsf(P, MV, 0); % Parametros selecionados, filtro aplicado, translada Target Data
    mm2=mm; T2=T;
    T2(isnan(mm2))=[]; mm2(isnan(mm2))=[];
    mm2(isnan(T2))=[]; T2(isnan(T2))=[]; 
    r=corrcoef(mm2,T2);r=r(1,2); 
        if abs(r)>abs(r0)
            r0=r;
            mv=MV;def=0;
        else
        end
    for DEF=1:maxdef
        mm2=[NaN mm2];mm2(end)=[];
        T2(isnan(mm2))=[]; mm2(isnan(mm2))=[];
        r=corrcoef(mm2,T2);r=r(1,2); 
        if abs(r)>abs(r0)
            r0=r;
            mv=MV;def=DEF;
        else
        end
    end
end
end

function [dados_chuva_FMME] = fstmediamovelexpojsf(dados_chuvas, mv, def)
% [dados_chuva] = filtrar_fmme(dados_chuvas, mv)
%
% Filtra com FMME de parâmetro mv a série declarada.
% ENTRADA: dados_chuva, mv
% SAIDA: dados_chuva_FMME
lambda=1-(0.5)^(1/mv);                                  % Aqui é definido o lambda, que depende do parâmetro mv (meia-vida), parâmetro importante do FMME
dados_chuva_FMME = zeros(1,size(dados_chuvas,2));       % Pré-alocar variável
cont=0;                                                 % Contador para saber o número de NaNs. É necessário porque queremos manter o filtro quando voltam a ter dados. 
dados_chuva_FMME(1)=lambda*dados_chuvas(1);             % Inicialização do FMME
    for i=2:size(dados_chuvas,2)
        if isnan(dados_chuvas(1,i))                     % Se houver NaN na célula "i" da série de chuva, 
            dados_chuva_FMME(1,i) = NaN;                % O FMME vai ser NaN
            cont=cont+1;                                % Vou contar que houve NaN
        elseif isnan(dados_chuvas(1,i-1)) && ~isnan(dados_chuvas(1,i))                                                  % VOLTOU A TER DADOS: na célula i-1 tem NaN e na célula i tem dado,
            if ~isnan(dados_chuva_FMME(1,i-1-cont))     % esse if é importante porque algumas séries começam com NaN e isso pode prejudicar todo o filtro
            dados_chuva_FMME(1,i) = (1-lambda)^(cont+1)* dados_chuva_FMME(1,i-1-cont) + lambda*dados_chuvas(1, i);      % Vou calcular o filtro, considerando o último filtro e o lapso de NaNs
            cont=0;                                                                                                     % Vou zerar o contador de NaNs. [Auto-explicativo]
            else
            dados_chuva_FMME(1,i) = lambda*dados_chuvas(1, i);      % Vou calcular o filtro, considerando o último filtro e o lapso de NaNs
            cont=0;                                                                                                     % Vou zerar o contador de NaNs. [Auto-explicativo]
            end
        elseif ~isnan(dados_chuvas(1,i-1)) && ~isnan(dados_chuvas(1,i))
            dados_chuva_FMME(1,i) = (1-lambda)* dados_chuva_FMME(1,i-1) + lambda*dados_chuvas(1, i);                    % Na célula i-1 e i tem dados; simplesmente calcular o FMME.
        else
        end
    end
    if def==0
    elseif def<0
        error('def menor que zero')
    else
       dados_chuva_FMME=[NaN(1,def) dados_chuva_FMME(1:end-def)];
    end
end