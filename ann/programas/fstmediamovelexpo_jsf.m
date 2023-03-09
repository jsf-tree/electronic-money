function [dados_chuva_FMME] = fstmediamovelexpo_jsf(dados_chuvas, mv, def)
% [dados_chuva] = filtrar_fmme(dados_chuvas, mv)
%
% Filtra com FMME de parâmetro mv a série declarada.
% ENTRADA: dados_chuva, mv
% SAIDA: dados_chuva_FMME
%
lambda=1-(0.5)^(1/mv);                                  % Aqui é definido o lambda, que depende do parâmetro mv (meia-vida), parâmetro importante do FMME
dados_chuva_FMME = zeros(1,size(dados_chuvas,2));       % Pré-alocar variável
cont=0;                                                 % Contador para saber o número de NaNs. É necessário porque queremos manter o filtro quando voltam a ter dados. 
dados_chuva_FMME(1)=lambda*dados_chuvas(1);             % Inicialização do FMME
    for i=2:size(dados_chuvas,2)
        if isnan(dados_chuvas(1,i))                     % Se houver NaN na série de chuva, 
            dados_chuva_FMME(1,i) = NaN;                % O FMME vai ser NaN
            cont=cont+1;                                % Vou contar que houve NaN
        elseif isnan(dados_chuvas(1,i-1)) && ~isnan(dados_chuvas(1,i))                                                  % Se voltar a ter dados,
            dados_chuva_FMME(1,i) = (1-lambda)^(cont+1)* dados_chuva_FMME(1,i-1-cont) + lambda*dados_chuvas(1, i);      % Vou calcular o filtro, considerando o último filtro e o lapso de NaNs
            cont=0;                                                                                                     % Vou zerar o contador de NaNs. [Auto-explicativo]
        else
            dados_chuva_FMME(1,i) = (1-lambda)* dados_chuva_FMME(1,i-1) + lambda*dados_chuvas(1, i);                    % Se não há nada de NaN acontecendo, simplesmente calcular o FMME.
        end
    end

    if def==0
    elseif def<0
        error('def menor que zero')
    else
       dados_chuva_FMME=[NaN(1,def) dados_chuva_FMME(1:end-def)];
    end
end