function [mv, def] = fsamediamovelexpojsf(P, T, maxmv, maxdef)
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
% 02/08/2019 �s 17:28

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
% Filtra com FMME de par�metro mv a s�rie declarada.
% ENTRADA: dados_chuva, mv
% SAIDA: dados_chuva_FMME
lambda=1-(0.5)^(1/mv);                                  % Aqui � definido o lambda, que depende do par�metro mv (meia-vida), par�metro importante do FMME
dados_chuva_FMME = zeros(1,size(dados_chuvas,2));       % Pr�-alocar vari�vel
cont=0;                                                 % Contador para saber o n�mero de NaNs. � necess�rio porque queremos manter o filtro quando voltam a ter dados. 
dados_chuva_FMME(1)=lambda*dados_chuvas(1);             % Inicializa��o do FMME
    for i=2:size(dados_chuvas,2)
        if isnan(dados_chuvas(1,i))                     % Se houver NaN na c�lula "i" da s�rie de chuva, 
            dados_chuva_FMME(1,i) = NaN;                % O FMME vai ser NaN
            cont=cont+1;                                % Vou contar que houve NaN
        elseif isnan(dados_chuvas(1,i-1)) && ~isnan(dados_chuvas(1,i))                                                  % VOLTOU A TER DADOS: na c�lula i-1 tem NaN e na c�lula i tem dado,
            if ~isnan(dados_chuva_FMME(1,i-1-cont))     % esse if � importante porque algumas s�ries come�am com NaN e isso pode prejudicar todo o filtro
            dados_chuva_FMME(1,i) = (1-lambda)^(cont+1)* dados_chuva_FMME(1,i-1-cont) + lambda*dados_chuvas(1, i);      % Vou calcular o filtro, considerando o �ltimo filtro e o lapso de NaNs
            cont=0;                                                                                                     % Vou zerar o contador de NaNs. [Auto-explicativo]
            else
            dados_chuva_FMME(1,i) = lambda*dados_chuvas(1, i);      % Vou calcular o filtro, considerando o �ltimo filtro e o lapso de NaNs
            cont=0;                                                                                                     % Vou zerar o contador de NaNs. [Auto-explicativo]
            end
        elseif ~isnan(dados_chuvas(1,i-1)) && ~isnan(dados_chuvas(1,i))
            dados_chuva_FMME(1,i) = (1-lambda)* dados_chuva_FMME(1,i-1) + lambda*dados_chuvas(1, i);                    % Na c�lula i-1 e i tem dados; simplesmente calcular o FMME.
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