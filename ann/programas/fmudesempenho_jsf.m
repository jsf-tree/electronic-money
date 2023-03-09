function [NS, Mea, Mpea, Pbias, Me, E10, E25, E50, E75, E90, n]=fmudesempenho_jsf(T, S, g, e, nomes)
% [NS, Mea, Mpea, Pbias, Me, E10, E25, E50, E75, E90, n] = fmudesempenho(T, S, g, e, nomes)
% 
% Cálculo de estatísticas de desempenho de previsão ou de simulação.
%
% Entradas:
% T, S:   Séries de dados observados e de dados calculados, respectivamente.
% g:      Instrução para emissão de gráfico (adota 0 se não informado):
%           'n' ou 0: Não emite figura.
%           's' ou 1: Emite figura com dados observados e calculados.
% e:      Instrução para emissão de resultados (adota 1 se não informado):
%           'n' ou 0: Não emite resultados.
%           's' ou 1: Emite resultados em formato definido, adequado à dimensão de cada número.
% nomes:  Nome(s), opcional(is), da(s) variável(is) de saída, ou legenda da saída.
%
% Entrada global:
%    nomedorelatorio: Quando existente, proporciona a gravação do relatório, de forma automática.
%                     Se o arquivo já existe, grava na sequência.
%
% Saídas:
% NS:     Coeficiente de Nash-Suitcliffe.
% Mea:    Média dos erros absolutos.
% Mpea:   Média das proporções, em relaçao ao valor observado correspondente, dos erros absolutos.
% Pbias:  Estatística 100*sum(T-S)/sum(T).
% Me:     Média dos erros.
% E10:    Quantil 0.10 dos erros.
% E25:    Quantil 0.25 dos erros.
% E50:    Quantil 0.25 dos erros (mediana).
% E75:    Quantil 0.75 dos erros.
% E90:    Quantil 0.90 dos erros.
% n:      Número de registros válidos utilizados.
% 
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     17/11/2018 às 10.49.

global nomedorelatorio

% Testes do número de entradas:
switch nargin
    case 5
    case 4, nomes=[];
    case 3, e=[]; nomes=[];
    case 2, g=[]; e=[]; nomes=[];
    otherwise, error('% Numero inadequado de argumentos de entrada!')
end

% Testes das entradas:
% T, S:
[T, cT]=fntestevetor(T); [S, cY]=fntestevetor(S);
if cT ~= cY, error('% Vetores de entrada possuem dimensões diferentes!'), end
% g:
[g]=fntestesinal(g, 0);
% e:
[e]=fntestesinal(e, 1);
% nomes:
nomes=fntestanomes(nomes, T);

% Teste do nome do relatório:
if ~isempty(nomedorelatorio), fntestecaracteres(nomedorelatorio), end

% Procedimento principal:
for i=1:size(T, 1)
    [NS, Mea, Mpea, Pbias, Me, E10, E25, E50, E75, E90, n]=fndesempenho(T, S);
    f='%s%9.3f%s%9.3f%s%9.3f%s%8.3f%s%8.3f\n';
    if g == 1
        figure, plot(T, 'b'), hold on, plot(S, 'r'), legend('Observados', 'Calculados')
        if (size(T, 1) ~= 1), title(nomes(i, :)), else title('Valores de Saida'), end
    end
    if e == 1
       fprintf('%s%s%s%d%s\n','% Desempenho ', nomes, ' (', n, ' registros válidos utilizados):');
       fprintf('%s', '% ');
       forma=['%s' fnformatonumero(E10)]; fprintf(forma, 'E10 = ', E10);
       forma=['%s' fnformatonumero(E25)]; fprintf(forma, ' E25  = ', E25);
       forma=['%s' fnformatonumero(E50)]; fprintf(forma, ' E50 = ', E50);
       forma=['%s' fnformatonumero(E75)]; fprintf(forma, ' E75   = ', E75);
       forma=['%s' fnformatonumero(E90)]; fprintf(forma, 'E90 = ', E90);
       fprintf('\n%s', '% ');
       forma=['%s' fnformatonumero(Mea)]; fprintf(forma, 'Mea = ', Mea);
       forma=['%s' fnformatonumero(Mpea)]; fprintf(forma, ' Mpea = ', Mpea);
       forma=['%s' fnformatonumero(Me)]; fprintf(forma, ' Me  = ', Me);
       forma=['%s' fnformatonumero(Pbias)]; fprintf(forma, ' Pbias = ', Pbias);
       forma=['%s' fnformatonumero(NS)]; fprintf(forma, 'NS  = ', NS);
       fprintf('\n\n');
    end
    if ~isempty(nomedorelatorio), fid=fopen(['relatos\' nomedorelatorio], 'a');
       fprintf(fid, '%s%s%s%d%s\n','% Desempenho ', nomes, ' (', n, ' registros válidos utilizados):');
       fprintf(fid, '%s', '% ');
       forma=['%s' fnformatonumero(E10)]; fprintf(fid, forma, 'E10 = ', E10);
       forma=['%s' fnformatonumero(E25)]; fprintf(fid, forma, ' E25  = ', E25);
       forma=['%s' fnformatonumero(E50)]; fprintf(fid, forma, ' E50 = ', E50);
       forma=['%s' fnformatonumero(E75)]; fprintf(fid, forma, ' E75   = ', E75);
       forma=['%s' fnformatonumero(E90)]; fprintf(fid, forma, 'E90 = ', E90);
       fprintf(fid, '\n%s', '% ');
       forma=['%s' fnformatonumero(Mea)]; fprintf(fid, forma, 'Mea = ', Mea);
       forma=['%s' fnformatonumero(Mpea)]; fprintf(fid, forma, ' Mpea = ', Mpea);
       forma=['%s' fnformatonumero(Me)]; fprintf(fid, forma, ' Me  = ', Me);
       forma=['%s' fnformatonumero(Pbias)]; fprintf(fid, forma, ' Pbias = ', Pbias);
       forma=['%s' fnformatonumero(NS)]; fprintf(fid, forma, 'NS  = ', NS);
       fprintf(fid, '\n\n');
       fclose(fid);
    end
end % for i=1:size(T, 1)

end % procedimento principal

% ------------------------------------------------------------------------------------------------------------
% RECURSOS AUXILIARES
% ------------------------------------------------------------------------------------------------------------
function nomes=fntestanomes(nomes, T)
if isempty(nomes)
    for i=1:size(T, 1), nomes(i, :)=['saida ' int2str(i)]; end
else
    if ~ischar(nomes), error('% Nomes fornecidos inadequados!'), end
    if size(nomes, 1) ~= size(T, 1), error('% Nomes não coincidem com número de entradas!'), end
end
end
% ------------------------------------------------------------------------------------------------------------
function [T, cT]=fntestevetor(T)
    if isempty(T), error('% Vetor de entrada está vazio!'), end
    if ~isvector(T), error('% Entrada não é um vetor!'), end
    [i, j]=size(T); if i > j, T=T'; end, cT=size(T, 2);
end
% ------------------------------------------------------------------------------------------------------------
function s=fntestesinal(f, g)
    if isempty(f), s=g;
    elseif ischar(f)
        if f=='s', s=1;
        elseif f=='n', s=0;
        else error('% Sinal de emissão/gravação inadequado!')
        end
    elseif isscalar(f)&&((f==0)||(f==1)), s=f;
    else error('% Sinal de emissão/gravação inadequado!')
    end
end
% ------------------------------------------------------------------------------------------------------------
function forma=fnformatonumero(num)
    if abs(num) < 0.01, forma='%7.4f\t';
    elseif abs(num) < 1, forma='%7.3f\t';
    elseif abs(num) < 10, forma='%7.2f\t';
    elseif abs(num) < 1000, forma='%7.1f\t';
    else forma='%7.0f\t';
    end
end
%-------------------------------------------------------------------------------------------------------------
function fntestecaracteres(nomearq)
    f=strfind(nomearq, '"'); if ~isempty(f), error('% Caractere indeferido em nomes de arquivos!'), end
    f=strfind(nomearq, '*'); if ~isempty(f), error('% Caractere indeferido em nomes de arquivos!'), end
    f=strfind(nomearq, ':'); if ~isempty(f), error('% Caractere indeferido em nomes de arquivos!'), end
    f=strfind(nomearq, '<'); if ~isempty(f), error('% Caractere indeferido em nomes de arquivos!'), end
    f=strfind(nomearq, '>'); if ~isempty(f), error('% Caractere indeferido em nomes de arquivos!'), end
    f=strfind(nomearq, '?'); if ~isempty(f), error('% Caractere indeferido em nomes de arquivos!'), end
    %f=strfind(nomearq, '\'); if ~isempty(f), error('% Caractere indeferido em nomes de arquivos!'), end
    f=strfind(nomearq, '|'); if ~isempty(f), error('% Caractere indeferido em nomes de arquivos!'), end
end
% ------------------------------------------------------------------------------------------------------------
function [NS, Mea, Mpea, Pbias, Me, E10, E25, E50, E75, E90, n]=fndesempenho(T, S)
    [~, j]=find(isnan([T; S])); T(:, j)=[]; S(:, j)=[]; n=length(S); e=T-S;
    eabs=abs(e);
    E25=quantile(e, 0.25, 2); E50=quantile(e, 0.5, 2); E75=quantile(e, 0.75, 2);
    E10=quantile(e, 0.1, 2); E90=quantile(e, 0.9, 2);
    TM=mean(T); Mea=mean(eabs); Me=mean(e);
    M=[eabs; T]; [~, j]=find(T==0); M(:, j)=[]; Mpea=mean(M(1, :)./M(2, :));
    Pbias=100*sum(T-S)/sum(T);
    num=(T-S)*(T-S)'; den=(T-TM)*(T-TM)'; NS=1-num/den;
end


