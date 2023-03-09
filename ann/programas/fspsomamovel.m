function fspsomamovel(Base, Col, LinhaT, LinhasP, DifeT, SomaP, MaxD)
% fspsomamovel(Base, Col, LinhaT, LinhasP, DifeT, SomaP, MaxD)
%
% Recursos necessários: 'fdoselecionavar', 'fstdifemovel', 'fstsomamovel', 'fsdcorrelograma'.
%
% Entradas:
% Base:    Células com as amostras respectivas, nomes na segunda coluna e séries numéricas em uma coluna 
%          subsequente.
% Col:     Coluna(s) da Base para leitura dos dados solicitados em lista. Se informados dois valores escalares
%          inteiros, o primeiro é a coluna que contém os nomes, e o segundo é a coluna que contém os vetores
%          de dados correspondentes. Se fornecido apenas um escalar inteiro, considera que a segunda coluna
%          contém os nomes das variáveis e a coluna informada contém  os vetores correspondentes de dados.
%          Se não informado, adota a coluna 2 para os nomes das variáveis, e a coluna 3 para os vetores de
%          dados correspondentes.
% LinhaT:  Linha onde está a variável com cujas diferenças serão confrontadas as somas móveis das demais.
% LinhasP: Linhas onde estão as variáveis cujas somas móveis serão experimentadas.
% DifeT:   Vetor com as diferenças de níveis com as quais as somas móveis serão correlacionadas.
% SomaP:   Vetor com os números de intervalos das somas móveis que serão experimentados.
% MaxD:    Máxima defasagem, em intervalos de dados, que será calculada em cada correlograma.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     07/12/2018 às 11.12.

global nomedorelatorio

[Base, Col, LinhaT, LinhasP, DifeT, SomaP, MaxD]=fnentradas(Base, Col, LinhaT, LinhasP, DifeT, SomaP, MaxD);

% Inicializações:
tempoini=clock;
    [T, nomet] = fdoselecionavar(Base, LinhaT, Col);
    forma='%s%5.3f\t\t%7.3f%s%5.3f\t\t%7.3f%s%5.3f\n';

    %  Inicialização do relatório:
    tempo=datevec(now); formato='%s%d%s%d%s%d\t%d%s%d\n';
    if ~isempty(nomedorelatorio), fid=fopen(nomedorelatorio, 'a');
    fprintf(fid, '%s\n',...
        '% ------------------------------------------------------------------------------------------------');
    fprintf(fid, '%s\n','% Pesquisa de relações das somas móveis de chuvas com diferenças móveis de níveis');
    fprintf(fid, '%s%s\n', '% Posto de ', nomet);
    fprintf(fid, formato, '% Em ', tempo(3), '/', tempo(2), '/', tempo(1), tempo(4), ':', tempo(5));
    fprintf(fid, '%s\n',...
        '% ------------------------------------------------------------------------------------------------');
    end

    % Programa principal:
    for dn=1:length(DifeT)
        fprintf('\n%s\n',...
                '% ----------------------------------------------------------------------------------------');
        fprintf('%s%d%s\n', '% Análise para diferença de níveis de ', DifeT(dn), ' intervalos')
        if ~isempty(nomedorelatorio)
            fprintf(fid, '\n%s\n',...
                '% ----------------------------------------------------------------------------------------');
            fprintf(fid, '%s%d%s\n', '% Análise para diferença de níveis de ', DifeT(dn), ' intervalos');
        end
        Td=fstdifemovel(T, DifeT(dn)); fox='\n%s%d%s\n\n';
        for sc=1:length(SomaP)
            M=NaN(length(LinhasP), length(T));
            fprintf(fox, '% Análise para somas móveis de chuvas de ', SomaP(sc), ' intervalos')
            if ~isempty(nomedorelatorio)
                fprintf(fid, fox, '% Análise para somas móveis de chuvas de ', SomaP(sc), ' intervalos');
            end
            for lp=1:length(LinhasP)
                [P, nomep]=fdoselecionavar(Base, LinhasP(lp), Col); nomep=nomep(1:length(nomep));
                Ps=fstsomamovel(P, SomaP(sc));
                [r, rmax, dmax]=fsdcorrelograma(Ps, Td, MaxD);
                fprintf('%s%s%s%s%s\n', '% ', nomep, ' x ', nomet, ':')
                fprintf(forma, '%  0: ', r(1), dmax, ': ', rmax, MaxD, ': ', r(end)), fprintf('\n')
                if ~isempty(nomedorelatorio)
                    fprintf(fid, '%s%s%s%s%s\n', '% ', nomep, ' x ', nomet, ':');
                    fprintf(fid, forma, '%  0: ', r(1), dmax, ': ', rmax, MaxD, ': ', r(end));
                    fprintf(fid, '\n'); M(lp, :)=Ps;
                end
            end
            m=fstoperavetores(M); nomep='Chuvas médias';
            [r, rmax, dmax]=fsdcorrelograma(m, Td, MaxD);
            fprintf('%s%s%s%s%s\n', '% ', nomep, ' x ', nomet, ':')
            fprintf(forma, '%  0: ', r(1), dmax, ': ', rmax, MaxD, ': ', r(end)), fprintf('\n')
            if ~isempty(nomedorelatorio)
                fprintf(fid, '%s%s%s%s%s\n', '% ', nomep, ' x ', nomet, ':');
                fprintf(fid, forma, '%  0: ', r(1), dmax, ': ', rmax, MaxD, ': ', r(end));
                fprintf(fid, '\n');
            end
        end
    end
delta=etime(clock, tempoini);

% Finalização:
if delta > 3600
    fprintf('%s%5.2f%s\n\n', '% Tempo total dispendido: ', delta/3600, ' horas');
elseif delta > 60
    fprintf('%s%4.1f%s\n\n', '% Tempo total dispendido: ', delta/60, ' minutos');
else
    fprintf('%s%4.1f%s\n\n', '% Tempo total dispendido: ', delta, ' segundos');
end

if ~isempty(nomedorelatorio)
    fprintf(fid, '\n%s\n',...
        '% ------------------------------------------------------------------------------------------------');
    if (delta>3600)
        fprintf(fid, '%s%5.2f%s\n\n', '% Tempo total dispendido: ', delta/3600, ' horas');
    elseif (delta>60)
        fprintf(fid, '%s%4.1f%s\n\n', '% Tempo total dispendido: ', delta/60, ' minutos');
    else
        fprintf(fid, '%s%4.1f%s\n\n', '% Tempo total dispendido: ', delta, ' segundos');
    end
    fclose(fid);
end

end
% ============================================================================================================
% RECURSOS AUXILIARES:
% ------------------------------------------------------------------------------------------------------------
function [T] = fstoperavetores(P)
    [~, cP]=size(P); T=NaN(1, cP);
    for j=1:cP
        [i,~]=find(~isnan(P(:, j)));
        if ~isempty(i), T(1, j)=mean(P(i, j)); end
    end
end
% ------------------------------------------------------------------------------------------------------------
function [Base, Col, LinhaT, LinhasP, DifeT, SomaP, MaxD]=fnentradas(Base, ...
    Col, LinhaT, LinhasP, DifeT, SomaP, MaxD)
% Base:
if isempty(Base), error('% A entrada correspondente à estrutura contendo a base de dados não foi fornecida!')
else
    if ~iscell(Base), error('% A estrutura de dados fornecida não é de células!'), end
end
% Col:
if isempty(Col), coln=2; colv=3;
else
    if isnumeric(Col)
        if isscalar(Col)
            coln=2; colv=Col;
        elseif isvector(Col)
            if size(Col, 1) > size(Col, 2), Col=Col'; end
            if size(Col, 2) == 2
                coln=Col(1, 1); colv=Col(1, 2);
            else error('% A entrada correspondente às colunas possui mais de dois valores!')
            end
        end
    else error('% A entrada correspondente à(s) coluna(s) não é numérica!')
    end
end
Col=[coln colv];
% LinhaT:
if isempty(LinhaT)
    error('% A linha da base que corresponde ao vetor das diferenças móveis não foi informado!')
end
% LinhasP:
if isempty(LinhaT)
    error('% As linhas da base que correspondem aos vetores das somas móveis não foi informado!')
end
% 

end
% ============================================================================================================
% HISTÓRICO DE ALTERAÇÕES:
% Em 19/11/2018:
% - Origem, a partir de programa 'Analises_somachuvas_x_difniveis', feito para o Emanuel, em 13/05/2018.
% Em 07/12/2018:
% - Melhoramentos das explicações das entradas e saídas.


