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