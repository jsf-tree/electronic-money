% ============================================================================================================
% LISTA EXPLICATIVA DE RECURSOS ('FUNCTIONS')
% ------------------------------------------------------------------------------------------------------------
% [r, n, p] = fddcorrelacionar(x, y, s, t)
%
% Cálculo da correlação excluindo preliminarmente registros vazios. Possui duas alternativas, a correlação
%    linear (Pearson) e a correlação não linear (Spearman).
%
% Entradas:
%  x: Vetor com a primeira série de dados a correlacionar (linha ou coluna).
%  y: Vetor com a segunda série de dados a correlacionar (linha ou coluna).
%  s: Instrução para não emitir ('n' ou 0), ou emitir ('s' ou 1) os resultados, adotando 1 se não fornecida.
%  t: Alternativa de correlação, linear (0) ou monotônica (1). Se não fornecida, adota a linear (0).
%
% Saídas:
%  r:  Correlação solicitada.
%  n:  Número de registros válidos utilizado.
%  p:  p-valor, correspondendo à probabilidade bilateral de erro com a rejeição da hipótese H0, de que não
%      exista relação.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     13/06/2019 às 12.06.

% ------------------------------------------------------------------------------------------------------------
% [Ja, Jr] = fdoamostragemsistematica(P, r, m, e, v, J)
%
% Seleção de amostras solicitadas e identificação de amostras residuais da seleção, ambas sem falhas, na 
%   série correspondente de registros, pelo método da amostragem sistemática do domínio, relacionados 
%   ou não a um ordenamento de origem fornecido ou criado.
%
% Entradas:
% P:   Matriz com as amostras existentes para a seleção. Deve ser a matriz com todas as variáveis 
%      (entrada e saída), sendo a(s) última(s) linha(s) com a(s) variáveis de saída do modelo.
% r:   Informação do número definido, tentativo, de registros. Pode ser feita por um número inteiro, ou
%      na forma de uma proporção. Se não fornecida, adota a proporção 0.1.
% m:   Modo da amostragem sistemática, com base em critérios aplicados sobre a variável da linha final 
%      da matriz de dados, P, adotando-se 0 se não informado:
%        0: Produzir na seleção, e, consequentemente, também na amostragem residual, a mesma distribuição 
%           da série original.
%        1: Reduzir as maiores frequências, em favor de valores mais altos do domínio, resultando uma
%           distribuição da amostragem selecionada que tende à uniforme, podendo ser mais representativa
%           também de setores  menos favorecidos do domínio.
% e:    Indicador sobre registros com extremos de cada variável representada, adotando-se 0 se não informado:
%         0: Não forçar a inclusão de extremos na amostragem selecionada.
%         1: Incluir os registros extremos na seleção.
% v:    Variável selecionada para efetuar as análises, correspondendo a uma linha de P. Se não informada,
%       adota a última linha.
% J:    Ordenamento de origem, ou seja, ordem dos dados considerados para seleção, na matriz P. Se for 
%       informado, as respostas serão referenciadas na matriz original que deu origem a J. Se não 
%       informado, adota o ordenamento natural, 1:1:length(P), de toda a amostragem fornecida, e as 
%       respostas serão refenciadas ao ordenamento na matriz P fornecida.
%
% Saídas:
% Ja:  Vetor com o ordenamento do subconjunto de J não NaN resultante da seleção.
% Jr:  Vetor com o ordenamento do subconjunto de J não NaN remanescente da seleção.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     16/12/2018 às 11.29.

% ------------------------------------------------------------------------------------------------------------
% [Jm, Jx] = fdoidentificaregistrospelolimiar(P, limiar, linha, J)
%
% Identificação de amostras menores (Jm) e maiores ou iguais (Jx) a um limiar estabelecido, pelos valores da 
%   linha solicitada, em uma matriz M, onde cada coluna corresponde a um registro.
% A pesquisa é limitada aos registros com ordenamento J, se este for fornecido.
%
% Entradas:
% M:        Matriz ou Vetor numérico com as amostras existentes para a pesquisa, dispostas em colunas.
% limiar:   Valor a ser adotado para a pesquisa. Se não fornecido, adota zero.
% linha:    Linha da matriz M a ser adotada para a pesquisa. Se não fornecida, adota a última linha de M.
% J:        Vetor com os ordenamentos para a pesquisa em M.
%
% Saidas:
% Jm:  Vetor dos ordenamentos, em J, dos registros com valores menores que o limiar, na linha da pesquisa.
% Jx:  Vetor dos ordenamentos, em J, dos registros com valores maiores que o limiar, na linha da pesquisa.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Ùltima atualização:     13/07/2019 às 21.27.

% ------------------------------------------------------------------------------------------------------------
% [Js, Ps] = fdoregistrossemfalhas(P, J)
%
% Seleção de amostras sem falhas na série correspondente a uma variável, mantendo o registro de ordem 
%   dos dados remanescentes, em relação a um ordenamento de origem, fornecido ou criado.
%   Se for necessária a sincronização das entradas do modelo, deve ser usada depois daquela.
%
% Entradas:
% P:   Matriz ou Vetor com as amostras existentes para a seleção.
% J:   Vetor com o ordenamento original. Se nao fornecido, adota o ordenamento de P.
%
% Saidas:
% Js:  Vetor com o ordenamento, em J, dos registros remanescentes após a exclusão dos NaNs.
% Ps:  Matriz ou Vetor com as amostras remanescentes após a exclusão dos NaNs.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Ùltima atualização:     15/02/2019 às 17.59.

% ------------------------------------------------------------------------------------------------------------
% [P, nomes] = fdoselecionavar(E, lista, col, Jo)
%
% Seleciona as variáveis explicativas que farão parte do modelo, pelos números em lista, podendo ser
%   selecionado um conjunto específico de registros, indicados pelo vetor de ordem, Jo.
%
% Entradas:
% E:                Células com as amostras respectivas, nomes na segunda coluna e séries numéricas em uma 
%                   coluna subsequente.
% lista [1 4 . .]:  Lista dos números de linhas das variáveis, na estrutura de celulas.
% col:              Coluna(s) para leitura dos dados solicitados em lista. Se informados dois valores
%                   escalares inteiros, o primeiro é a coluna que contém os nomes, e o segundo é a coluna que
%                   contém os vetores de dados correspondentes. Se fornecido apenas um escalar inteiro, 
%                   considera que a segunda coluna de 'E' contém os nomes das variáveis e a coluna informada
%                   contém  os vetores correspondentes de dados. Se não informado, adota a coluna 2 para os 
%                   nomes das variáveis, e a coluna 3 para os vetores de dados correspondentes. 
% Jo:               Vetor com o ordenamento dos dados solicitados. Se não informado, seleciona todas as 
%                   amostras.
%                   Caso a origem da seleção de dados seja um período entre duas datas, em uma série temporal,
%                   o Jo pode ser previamente pesquisado, na linha de tempos (linhatempos) com o uso de:
%                   [Jo]=ftpvetordeordem(E, linhatempos, coluna, inicio, final).
%
% Saídas:
% P:          Matrizes com as variáveis selecionadas, na ordem de lista, uma em cada linha.
% nomes:      Nomes das variáveis selecionadas, obtidas na segunda coluna de E.
% 
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     05/12/2018 às 14.22.

% ------------------------------------------------------------------------------------------------------------
% [P, T, nomeent, nomesai]=fdosepararsaidas(M, saidas, nomevar, J)
%
% Separa em saídas e entradas, os dados de uma matriz com, em cada linha, uma série, com base nas 
%    informações fornecidas de quais sao as linhas que constituem saídas, e qual é o subconjunto de 
%    registros da matriz original solicitado, com base em um vetor de ordenamentos.
%    Também separa os nomes das variáveis representadas pelas séries, em nomes de entrada e de saída.
%
% Entradas:
% M:       Matriz com as séries originais, uma por linha.
% saidas:  Vetor com as posições, em M, das variáveis que constituirão as saídas do modelo. Se não for 
%          fornecido, o programa selecionará a última variável.
% nomevar: Nomes das variáveis do modelo, uma por linha (dispensável se nomeent e nomesai não forem
%          solicitadas).
% J:       Vetor de posições dos registros da matriz original que serão identificados com as entradas e 
%          com as saídas.
%
% Saídas:
% P:       Matriz resultante, com os dados formatados segundo os deslocamentos temporais solicitados.
% T:       Matriz com a(s) saida(s) do modelo.
% nomeent: Nomes das variáveis formatadas para constituírem as entradas do modelo, com a defasagem temporal 
%          (solicitada no vetor d) correspondente. Opcional.
% nomesai: Nomes das variáveis formatadas para constituírem as saídas do modelo, com a defasagem temporal 
%          (solicitada no vetor d) correspondente. Opcional.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     05/11/2018 às 21.45.

% ------------------------------------------------------------------------------------------------------------
% [Xe, Xu]=fdpinspecionardominio(P, s)
%
% Inspeciona os dados e calcula os limites do domínio, fornecendo as matrizes Xe e Xu que atendem limites
%   expandidos com margem de 0.1 da amplitude observada. 
%   Pode-se aceitá-las, como entradas para treinamento, ou, com base nos valores obtidos, elaborar por 
%   conta própria.
%   Se for necessária a sincronização das entradas do modelo, deve ser usada depois daquela.
%
% Entradas:
% P:      Matriz com entradas e saídas do modelo, na forma de uma linha para cada variável.
% s:      Vetor com as linhas que correspondem a saídas. Se não fornecido, sendo solicitados limites de saída, 
%         adota a última linha de P como saída.
%
% Saídas:
% Xe, Xu: Matrizes com os limites inferior e superior do domínio, respectivamente, das variáveis de entrada
%         e de saída do modelo. 
%         Se solicitado apenas Xe, com uma entrada, não divide P em entradas e saídas.
%         Se solicitado apenas Xe, com 2 entradas, divide P em entradas e saídas, mas fornece apenas Xe.
% 
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     23/09/2018 às 11.09.

% ------------------------------------------------------------------------------------------------------------
% fduemitir(vetor, nome, numax)
%
% Emissão de vetor de dados, em uma ou mais linhas.
%
% Entradas:
% vetor:   Vetor de dados, em forma de matriz-linha ou de matriz-coluna, ou número individual.
% nome:    Nome do vetor, em caracteres alfanuméricos. Se não fornecido, adota 'Vetor', ou 'Valor'.
% numax:   Número máximo de valores em cada linha. Se não fornecido, adota 12.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Ultima atualizacao:     16/12/2018 às 20.35.

% ------------------------------------------------------------------------------------------------------------
% [CEr, NS, NSa, RMQE, RMQEa, n]=fmucompara(T, Y, Ya, e, g, nomesmodelos)
% 
% Calcula o coeficiente de eficiência relativa entre dois modelos de previsão ou de simulação.
%   Também fornece os coeficientes de eficiência e as médias dos quadrados dos erros dos modelos. 
%
% Entradas:
% T, Y, Ya:  Séries de dados observados e de dados calculados, pelo modelo principal e pelo modelo 
%            alternativo, respectivamente.
% e:         Instrução para emissão (1) ou não (0) de Eficiências. Se não fornecida, adota 1.
% g:         Instrução para emissão (1) ou não (0) de gráficos. Se não fornecida, adota 0.

% nomesmodelos: Nomes (opcionais) dos modelos comparados, no formato char.
%
% Entrada global:
%  nomedorelatorio: Quando existente, proporciona a gravação do relatório, de forma automática.
%                   Se o arquivo já existe, grava na sequência.
%
% Saídas:
% CEr:    Coeficiente de eficiência relativa do modelo principal em relação ao alternativo.
% NS:     Coeficiente de eficiência absoluta (Nash-Suitcliffe): proporção da variança dos dados que é
%         explicada pelo modelo principal.
% NSa:    Coeficiente de eficiência absoluta (Nash-Suitcliffe): proporção da variança dos dados que é
%         explicada pelo modelo alternativo.
% RMQE:   Raiz da média dos quadrados dos erros do modelo principal.
% RMQEa:  Raiz da média dos quadrados dos erros do modelo alternativo.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     07/01/2019 às 10.27.

% ------------------------------------------------------------------------------------------------------------
% [NS, Mea, Mpea, Pbias, Me, E10, E25, E50, E75, E90, n] = fmudesempenho(T, S, g, e, nomes, p)
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
% p:      Número de erros absolutos máximos considerados expúrios: Se não informado, adota 0.
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

% ------------------------------------------------------------------------------------------------------------
% [Y]=fmuextrapolalinear(T, alc, def)
%
% Executa o modelo de extrapolacao linear, que adota, para o horizonte de previsao, o valor linearmente 
%     extrapolado, tomando-se o valor no tempo atual e o valor em um tempo anterior, ocorrido com a defasagem
%     def.
% 
% Entradas:
% T:    Vetor com os dados de entrada originais da variável prevista.
% alc:  Alcance da previsão, representado pelo número de intervalos à frente.
% def:  Defasagem adotada para fazer a diferença a ser extrapolada. Se não fornecido, adota o alc.
%
% Saída:
% Y:  Valores previstos, por extrapolação nos tempos atuais, dos registros correspondentes.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     07/01/2019 às 16.34.

% ------------------------------------------------------------------------------------------------------------
% [rn, V, J] = fnavalcruz(rn, Pt, Tt, Pa, Ta, ciclos, rep, pesos)
%
% Treinamento de redes neurais de uma camada interna de neurônios, usando a validação cruzada e as heurísticas
%   conjugadas.
%   A condição de finalização é quando é esgotado o potencial de incremento da capacidade de generalização, o
%   que pode ser detectado pela estagnação do aumento do desempenho de validação em certo número de ciclos,
%   com ou sem a ocorrência de sobreajustamento.
%   Repetições são executadas para conferir robustez, adotando-se o melhor resultado obtido na validação.
%
% Entradas:
%  rn:      Rede neural previamente configurada (com 'fnuconfigurar').
%  Pt, Tt:  Dados de variáveis explicativas e explicadas de treinamento, uma variável por linha.
%  Pa, Ta:  Dados de variáveis explicativas e explicadas de validação, uma variável por linha.
%  ciclos:  Número máximo de ciclos em cada repetição. Se não informado ('[]'), faz ciclos=100000.
%  rep:     Número de repetições do procedimento para contornar a falta de robustez, adotando-se o melhor
%           resultado obtido na validação. Se não informado ('[]'), faz sem repetições.
%  pesos:   Valores a serem adotados, para cada registro, para a ponderação dos erros de treinamento de cada.
%           Se não informados, usa ponderação uniforme.
%
% Saídas:
%  rn: Rede neural de três camadas, mantendo a estrutura definida por 'fnuinicializar', com os campos:
%      ent: num(número de entradas), nom(nome das entradas),
%           esc(função de escalonamento), par(parâmetros da função de escalonamento),
%      int: num(número de neurônios), sin(matriz de pesos sinápticos),
%           fat(função de ativação), der(derivada da função de ativação),
%      sai: num(número de saídas), nom(nome das saídas), sin(matriz de pesos sinápticos),
%           fat(função de ativação), der(derivada da função de ativação),
%           esc(função de escalonamento, rec(função recuperação de escala), par(parâmetros de escalonamento). 
%
%   V: Célula com os vetores {Eq, Ev e Tx}, sendo, respectivamente, os erros quadráticos de treinamento 
%      e validação e as taxas de aprendizado durante o treinamento do modelo adotado.
%   J: Ciclo cujo treinamento foi adotado para o modelo resultante, pelo desempenho da amostra de validação.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     16/11/2018 às 23:46.

% ------------------------------------------------------------------------------------------------------------
% [Ev] = fnpcomplexidade(rn, Pt, Tt, Pa, Ta, H, proxi, ciclos, rep, pesos, f)
%
% Pesquisa da complexidade para redes neurais com duas camadas de neurônios, representada pelo número mínimo
%   de neurônios na camada interna com capacidade de aproximação semelhante à de uma rede propositadamente
%   superdimensionada sem ocorrência de sobreajustamento.
%   O procedimento baseia-se na validação com repetições, seja utilizando-se a validação cruzada simples ou
%   fazendo-se uso da validação por reamostragem.
%   O resultado é um vetor de estatísticas de desempenho, para cada complexidade, para análise e decisão:
%     No caso da validação cruzada, cada valor deste vetor é o menor (entre as repetições) erro quadrático
%     mínimo obtido com a série de validação durante os ciclos de treinamento.
%     No cado da validação por reamoatragem, cada valor deste vetor é o valor mediano ( entre as repetições)
%     dos erros médios na validação de cada repetição.
%
% Programas auxiliares necessários: 'fn@valcruz' e 'fn@reamostragem'.
%
% Entradas:
%  Pt, Tt:  Matrizes com as amostragens da variáveis explicativas e explicada para treinamento.
%  Pa, Ta:  Matrizes com as amostragens da variáveis explicativas e explicada para validação. Se não
%           fornecidas ('[]'), é realizada a validação por reamostragem.
%  H:       Vetor com as complexidades (número de neurônios internos) que deseja-se analisar.
%  proxi:   Vetor de proximidades a experimentar, na escala reduzida, para uso do método de pesquisa com
%           reamostragem. Se não informado ('[]'), realiza a pesquisa com a validação cruzada (se fornecidos 
%           os 'Pa' e 'Ta'), ou adota um vetor padrão (supondo amplitude de saída igual a 1), com proporção
%           do maior erro médio sendo 0.1 do domínio:
%           [0.1 0.08 0.06 0.05 0.045 0.04 0.035 0.03 0.025 0.02 0.018 0.015 0.012 0.01 0.008 0.005 0.003].
%  ciclos:  Número máximo de ciclos em cada iteração. Se não informado, faz ciclos=100000.
%  rep:     Número de repetições do procedimento para contornar a falta de robustez. Adota 5, se não
%           informado.
%  pesos:   Índice para a ponderação dos erros de treinamento. Se não informado, adota pesos uniformes.
%  f:       Indicativo da estatística de decisão (0: mediana; 1: média; 2: mínimo), entre os erros médios de
%           cada repetição, para o uso na validação por reamostragem. Se não informado, adota o '0'(mediana).
%
% Saídas:
%  Ev:       Vetor com as estatísticas de erros, resultantes na escala reduzida, para a amostragem de
%            validação, em cada complexidade analisada. Para a validação cruzada, correspondem ao melhor
%            resultado das somas do quadrado dos erros, entre as repetições realizadas. Para a validação por
%            reamostragem, são calculadas as estatísticas (mediana, média ou mínimo) entre os erros
%            absolutos médios de cada repetição.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     15/01/2019 às 08.29.

% ------------------------------------------------------------------------------------------------------------
% rn=fnuconfigurar(n, enom, eesc, epar, ifat, ider, snom, sfat, sder, sesc, srec, spar);
%
% Inicialização da estrutura de uma rede neural de três camadas. Se não informadas as funções de escalonamento
%   e de ativação, adota a função linear para os escalonamentos e a função sigmóide unipolar para as funções
%   de ativação, e as respectivas funções de recuperação e derivadas.
%
% Entradas:
%  n:      Vetor com as dimensões da rede (número de entradas, de neurônios internos e de saídas): [ne ni ns].
%  enom:   Nomes, opcionais, das variaveis de entrada. Se ausentes, adota 'X1', ..., 'Xn'.
%  eesc:   Função anônima, em forma textual, de escalonamento das entradas.
%  epar:   Parâmetros das funções de escalonamento das entradas, um conjunto (linha) de valores
%          para cada variável. Se não fornecidos, adota valores sem efeito, considerando funções lineares.
%  ifat:   Função anônima, em forma textual, de ativação dos neurônios da camada interna.
%          Exemplo: ifat='@(n) 1./(1+exp(-n))';
%  ider:   Função anônima, em forma textual, para a derivada de ativação dos neurônios da camada interna.
%  snom:   Nomes, opcionais, das variaveis de saida. Se ausentes, adota 'Y'.
%  sfat:   Função anônima, em forma textual, de ativação dos neurônios da camada de saída.
%  sder:   Função anônima, em forma textual, para a derivada de ativação dos neurônios da camada de saída.
%  sesc:   Função anônima, em forma textual, de escalonamento das saídas.
%  srec:   Função anônima, em forma textual, de recuperação da escala original das saídas.
%  spar:   Parâmetros das funções de escalonamento das saídas, um conjunto (linha) de valores
%          para cada variável. Se não fornecidos, adota valores sem efeito, considerando funções lineares.
%  
% Saída:
%  rn: Rede neural de três camadas, estruturada segundo os campos a seguir.
%      ent: num(número de entradas), nom(nome das entradas),
%           esc(função de escalonamento), par(parâmetros da função de escalonamento),
%      int: num(número de neurônios), sin(matriz de pesos sinápticos),
%           fat(função de ativação), der(derivada da função de ativação),
%      sai: num(número de saídas), nom(nome das saídas), sin(matriz de pesos sinápticos),
%           fat(função de ativação), der(derivada da função de ativação),
%           esc(função de escalonamento, rec(função recuperação de escala), par(parâmetros de escalonamento). 
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     15/09/2018 às 15.17.

% ------------------------------------------------------------------------------------------------------------
% [Y] = fnuexecutar(rn, P, op)
% 
% Executa modelos generalizados com redes neurais de uma camada interna.
% 
% Entradas:
% rn:   Rede neural de três camadas, na forma estruturada.
% P:    Variáveis explicativas, uma por linha de P, sendo cada coluna um registro.
% op:   Instrução para as alternativas opcionais de execução, na forma de escalares inteiros:
%       0: Aceita os resultados da rede neural.
%       1: Faz Y=0 quando todos os abs(P)'s do registro forem < 0.01.
%       2: Faz Y=0 quando o valor calculado deste resultar < 0.01.
%       3: Faz Y=0 quando todos os abs(P)'s forem < 0.01 ou quando Y calculado resultar < 0.01.
%
% Saída:
% Y:    Saídas calculadas, uma linha para cada variável, e uma coluna para cada registro.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     22/09/2018 às 09.46.

% ------------------------------------------------------------------------------------------------------------
% fnuilustrar(rn)
% 
% Realiza a figura de uma rede neural com três camadas, condicionado a que esta seja na forma estruturada.
%   As linhas representam as conexões, cujas expessuras estão relacionadas com a magnitude destas. Também, as
%   cores representam os sinais destas (ou seja, dos pesos sinápticos), sendo positivos em vermelho e
%   negativos em verde.
% 
% Entradas:
%   rn: Rede neural de três camadas, na forma estruturada.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     18/08/2018 às 21.43.

% ------------------------------------------------------------------------------------------------------------
% [dif, def] = fsadifemovel(P, T, maxdif, maxdef, Jo)
%
% Ajuste do parâmetro do número de intervalos anteriores para cada diferença, bem como da defasagem, no 
%   cálculo da diferença móvel, que resulta na série sequencial de diferenças com melhor correlação com uma 
%   outra série sequencial, que corresponde a uma série de ajuste.
%
% Entradas:
% P:      Série sequencial a ser transformada.
% T:      Série sequencial de ajuste, podendo ser níveis ou vazões no caso de transformação de chuvas.
% maxdif: Máximo valor a ser pesquisado para a o número de intervalos. Se não informado, adota 30.
% maxdef: Máximo valor a ser pesquisado para o retardo temporal. Se não informado, adota 30.
% Jo:     Vetor linha com números de ordem da série T, considerando-se que esta seja constituída de parte dos
%         registros de P. Se não informado, considera que a série é de mesma extensão da série P.
%
% Saídas:
% dif:    Diferença, em intervalos de tempo da sequência.
% def:    Deslocamento temporal da série transformada, sendo negativo em direção ao passado.
%         Se não solicitado, realiza a pesquisa para def=0.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     26/04/2019 às 08.04.

% ------------------------------------------------------------------------------------------------------------
% [mei, def] = fsamediamovelexpo(P, T, maxmei, maxdef, Jo)
%
% Ajuste dos parâmetros para a função de decaimento exponencial para a média móvel dos valores passados
%   correspondentes de uma série sequencial, podendo admitir, além da meia-vida, uma defasagem temporal.
%
% Entradas:
% P:      Série sequencial a ser transformada.
% T:      Série sequencial de ajuste, podendo ser níveis ou vazões no caso de transformação de chuvas.
% maxmei: Máximo valor a ser pesquisado para a meia-vida. Se não informado, adota 30.
% maxdef: Máximo valor a ser pesquisado para o retardo temporal. Se não informado, adota 50.
% Jo:     Vetor linha com números de ordem da série T, considerando-se que esta seja constituída de parte dos
%         registros de P. Se não informado, considera que a série é de mesma extensão da série P.
%
% Saídas:
% mei:    Meia-vida, em intervalos de tempo da sequência, com precisão de meio intervalo.
% def:    Retardo temporal do efeito da série transformada sobre a série de ajuste. Se não solicitado, 
%         realiza a pesquisa para def=0.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     26/12/2018 às 10.48.

% ------------------------------------------------------------------------------------------------------------
% [F, E] = fsamediamovelgama(P, T, maxfor, maxesc, p, mo, Jo)
%
% Ajuste dos parâmetros para a função gama para o cálculo da média móvel dos valores passados correspondentes
%    de uma série sequencial.
%
% Entradas:
% P:      Série sequencial a ser transformada.
% T:      Série sequencial de ajuste, podendo ser níveis ou vazões no caso de transformação de chuvas.
% maxfor: Maior valor a ser pesquisado para o parâmetro de forma.  Se não informado adota 80.
% maxesc: Maior valor a ser pesquisado para o parâmetro de escala. Se não informado adota 50. 
% p:      Menor valor (precisão) dos pesos de ponderação da média móvel. Se não informado adota 0.01.
% mo:     Modo de pesquisa, pela otimização por procura exaustiva (0), ou com uso do recurso 'fminunc' (1).
%         Se não informado, adota a alternativa 0.
% Jo:     Vetor linha com números de ordem da série T, considerando-se que esta seja constituída de parte dos
%         registros de P. Se não informado, considera que a série T é da mesma extensão da série P.
%
% Saídas:
% F: Parâmetro de forma,  F=(E(x)^2)/Var(x).
% E: Parâmetro de escala, E=Var(x)/E(x). Então, E(x)=F*E.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     04/01/2019 às 10.47.

% ------------------------------------------------------------------------------------------------------------
% [jan, def] = fsamediamoveluni(P, T, maxjan, maxdef, f, Jo)
%
% Ajuste dos parâmetros (extensão da janela e defasagem) para a função de média móvel com pesos uniformes 
%   dos valores de uma série sequencial.
%
% Entradas:
% P:      Série sequencial a ser transformada.
% T:      Série sequencial de ajuste, podendo ser níveis ou vazões no caso de transformação de chuvas.
% maxjan: Máximo valor a ser pesquisado para a extensão da janela. Se não informado, adota 30.
% maxdef: Máximo valor a ser pesquisado para o retardo temporal. Se não informado, adota 30.
% f:      Instrução se a média móvel deve ser aplicada simetricamente em torno de cada tempo atual (f=0) ou
%         aos valores anteriores (f=1). Se não informado, adota f=1.
% Jo:     Vetor linha com números de ordem da série T, considerando-se que esta seja constituída de parte dos
%         registros de P. Se não informado, considera que a série é de mesma extensão da série P.
%
% Saídas:
% jan:    Extensão da janela móvel, em intervalos de tempo da sequência.
% def:    Retardo temporal do efeito da série transformada sobre a série de ajuste. Se não solicitado, 
%         realiza a pesquisa para def=0.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     04/01/2019 às 17.17.

% ------------------------------------------------------------------------------------------------------------
% [w] = fscpesosmediamovelexpo(mei, p)
% 
% Geração de pesos exponencialmente decrescentes em direção ao passado, para o cálculo da média móvel
%   ponderada exponencialmente das chuvas passadas.
% 
% Entradas:
% mei: Meia-vida, sendo uma quantidade positiva, real ou inteira, de intervalos de dados considerados.
% p:   Menor peso considerado significativo, a resultar para o temp t-q. Se não informado, adota p=0.001.
%
% Saída:
% w:   Pesos gerados, constituindo um vetor-linha, com os pesos maiores em direção ao presente (t).
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     05/01/2019 às 10.09.

% ------------------------------------------------------------------------------------------------------------
% [w] = fscpesosmediamovelgama(F, E, p)
%
% Geração de pesos para a ponderação, para o cálculo da média móvel de valores passados, usando a função GAMA2
%   de densidade de probabilidade.
% 
% Entradas:
% F, E:   Parâmetros, de forma (>=1) e de escala (>=1/2), da fdp GAMA2.
% p:      Menor peso considerado significativo, a resultar para o temp t-q. Se não informado, adota p=0.001.
%
% Saída:
% w:   Pesos gerados, constituindo um vetor-linha, com os pesos maiores em direção ao presente (t).
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     10/07/2019 às 18.27.

% ------------------------------------------------------------------------------------------------------------
% [r, rmax, dmax, n] = fsdcorrelograma(x, y, def, m, g)
%
% Cálculo de intercorrelogramas. Para autocorrelogramas, repetir a primeira série (x) no lugar da segunda (y).
%
% Entradas:
% x:     Vetor (linha ou coluna) com a série temporal causal atual (t), a qual é emparelhada com a série
%        consequente, a cada defasagem testada, mediante seu deslocamento do passado (t) para a posição
%        temporal da série consequente (t + defasagem d).
% y:     Vetor (linha ou coluna) com a série temporal consequente.
% def:   Posição (inteira e positiva) máxima das defasagens (d = 0. . .def).
% m:     Informação para emissão de resultados (0 se não informado):
%           0:  Não emite resultados.
%           1:  Emite todas as correlações, em ordem crescente das defasagens.
%           2:  Emite o resumo, com as correlações da defasagem 0, a máxima absoluta (com a defasagem) e a
%               última.
% g:     Informação para emissão de gráficos (0 se não informado):
%           0: Não emite gráficos.
%           1, 2, . . .:  Emite correlações das defasagens pesquisadas, em figura com este número, criando-a, 
%                          se não existe, ou adicionando a esta o novo correlograma.
%                          No Matlab, correlogramas na mesma figura dependem de 'hold on' fora da função.
%
% Saídas:
%  r:      Vetor com as intercorrelações solicitadas, incluindo a defasagem zero.
%  rmax:   Correlação máxima ocorrida nas defasagens pesquisadas.
%  dmax:   Defasagem correspondente à correlação máxima obtida.
%  n:      Número de registros emparelhados válidos.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     05/12/2018 às 16.22.

% ------------------------------------------------------------------------------------------------------------
% [v]=fsiexcel(nomeler, plan, fila, limites, dataini)
%
% Importação de uma série de dados numéricos de uma fila (linha ou coluna), em limites especificados de linha
%   ou de coluna, do Excel, que é acomodada em um vetor-linha.
%   Se a série for de tempos (dd/mm/aaaa hh:mm), esta deve ser previamente convertida, no Excel, para a forma
%   numérica. Neste caso, é recomendável a entrada adicional da data inicial (dataini), para correções
%   eventualmente necessárias da conversão do tempo.
% 
% Entradas:
% nomeler:  Nome do arquivo Excel, inclusive a terminação, para a leitura de dados. Se não for incluída a
%           terminação, é adotada a '.xlsx'.
% plan:     Número da planilha a ser lida. Se não fornecida, adota 1.
% fila:     Indicação da fila a ser lida. Se for um número inteiro, está sendo solicitada uma linha, e se for 
%           uma ou mais letras (ex.: 'a', 'ab'), está sendo solicitada uma coluna. É indispensável.
% limites:  Vetor com as posições iniciais e finais da fila solicitada. Se esta for uma coluna, devem ser os 
%           números inteiros correspondentes às linhas (ex.: [1; 1023]. Se a fila solicitada for uma linha, os
%           limites devem ser as colunas correspondentes (ex.: char('d', 'aih').
% dataini:  Tempo correspondente ao primeiro registro, a ser fornecido somente se a coluna lida for de tempos
%           [dia/mes/ano hor:min:seg], recomendável para correcoes de diferenças de formatos de conversão para
%           a forma numérica. Deve ser informado no formato [ano mes dia hora minuto segundo].
%
% Saída:
% v:        Vetor, na forma de um vetor-linha, que contém a série numérica lida na coluna especificada.
%           Se a série for de tempos, os valores de v serao os números que representam os tempos, que o Matlab
%           pode converter em [ano mes dia hora minuto segundo], com uso do datevec.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     20/10/2018 às 15.46.

% ------------------------------------------------------------------------------------------------------------
% [m, nomespos] = fsosincronizar(M, d, nomes)
%
% Sincronização de séries, fornecidas em registros (colunas) especificados de uma matriz, sendo uma série 
%   por linha desta matriz.
%
% Entradas:
% M:     Matriz com as variáveis originais, uma por linha.
% d:     Vetor indicativo do deslocamento temporal desejado para cada variável, ou seja, um número por linha.
%        Condições:
%          - Se o valor for > 0: Os valores serão deslocados para a direita (em direção ao futuro).
%          - Se o valor for = 0: Os valores não serão deslocados temporalmente.
%          - Se o sinal for < 0: Os valores serão deslocados para a esquerda (em direção ao passado).
% nomes: Nomes das variáveis que serão sincronizadas, para acréscimo da posição temporal.
%
% Saídas:
% m:        Matriz resultante, com as séries sincronizadas segundo os deslocamentos solicitados.
% nomespos: Nomes das variáveis, com o indicativo da posição temporal, no passado (-) ou futuro (+).
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     07/01/2019 às 17.29.

% ------------------------------------------------------------------------------------------------------------
% [Vd]=fstdefasarserie(V, def)
% 
% Deslocamento dos valores de uma série sequencial, suposta representante de uma série temporal.
%
% Entradas:
% V:     Série sequencial original.
% def:   Escalar, com o número e o sinal do deslocamento solicitado, segundo a convenção:
%        Se positivo, desloca o vetor para a direita, avançando no tempo.
%        Se negativo, desloca o vetor para a esquerda, ou seja, recuando no tempo.
%
% Saída:
% Vd:    Série sequencial de respostas, com os dados da série deslocados no tempo.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     24/05/2019 às 16.40.

% ------------------------------------------------------------------------------------------------------------
% [dm] = fstdifemovel(V, dif, def)
% 
% Realiza a diferença dos registros com respeito aos dif intervalos anteriores, e atribui esta diferença na
%    posição final deste intervalo, resultando um vetor de mesmo número de registros do vetor original.
%    O vetor original deve ser com espaços temporais uniformes.
%
% Entradas:
% V:    Vetor de dados ordenados temporalmente, suposto com espaçamento temporal constante.
% dif:  Número inteiro de intervalos anteriores para cada diferença.
% def:  Deslocamento temporal da série transformada, sendo negativo em direção ao passado.
%       Se não fornecido, realiza a transformação para def=0.
%
% Saída:
% dm:   Vetor de diferenças móveis resultante, com a mesma dimensão do vetor de entrada.
% 
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     26/04/2019 às 07.59.

% ------------------------------------------------------------------------------------------------------------
% [mm] = fstmediamovel(V, w, f)
%
% Aplicação da média móvel, na forma de vetor de pesos, atuando sobre valores simétricos em torno do tempo
%   atual, ou sobre valores antecedentes ao tempo atual.
% 
% Entradas:
% V:  Vetor com a série sequencial original.
% w:  Vetor com os pesos a aplicar.
% f:  Instrução sobre o modo de aplicação, se simetricamente em torno de cada tempo atual (f=0) ou
%     aos valores anteriores (f=1). Se não informado, adota f=1;
%
% Saída:
% mm: Vetor com a série sequencial resultante.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     05/01/2019 às 11.29.

% ------------------------------------------------------------------------------------------------------------
% [mm] = fstmediamovelexpo(vo, mei, def)
% 
% Aplica filtro de média móvel em uma série sequencial, na forma de um vetor com espaçamentos supostos
%    uniformes, com decaimento exponencial em direção ao passado, admitindo defasagem temporal do efeito da
%    média móvel sobre uma variável de ajuste.
%    Decaimento exponencial: y(t) = (1 - alfa)*y(t-1) + alfa*(x(t)), com alfa = 1 - 0.5.^(1./mei)
%    mei = meia-vida (quantidade de intervalos anteriores que ponderam 0,5).
%
% Entradas:
% vo:   Vetor de dados ordenados temporalmente, suposto com espaçamento temporal constante, original.
% mei:  Meia-vida.
% def:  Retardo máximo admitido. Se não informado, adota def=0.
% 
%
% Saida:
% mm: Vetor de médias móveis resultante, com a mesma dimensão do vetor de entrada, suposto com espaçamento
%     temporal constante.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     05/01/2019 às 10.02.

% ------------------------------------------------------------------------------------------------------------
% [mm] = fstmediamovelgama(V, F, E, p)
% 
% Aplica filtro de média móvel dos valores passados com ponderação Gama2 em uma série sequencial, na forma de
%   um vetor com espaçamentos supostos uniformes.
%
% Entradas:
% V:  Vetor de dados ordenados temporalmente, suposto com espaçamento temporal constante, original.
% F:  Parâmetro de forma,  F=(E(V)^2)/Var(V).
% E:  Parâmetro de escala, E=Var(V)/E(V). Então, E(V)=F*E.
% p:  Menor peso considerado significativo, a resultar para o temp t-q. Se não informado, adota p=0.01.
%
% Saída:
% mm: Vetor de somas móveis resultante, com a mesma dimensão do vetor de entrada, suposto com espaçamento
%     temporal constante.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     10/07/2019 às 18.31.

% ------------------------------------------------------------------------------------------------------------
% [mm] = fstmediamoveluni(V, jan, def, f)
% 
% Aplica filtro de média móvel com ponderação uniforme em uma série sequencial, na forma de um vetor com
%    espaçamentos supostos uniformes, admitindo defasagem temporal do efeito da média móvel sobre uma variável
%    de ajuste.
%
% Entradas:
% V:   Vetor de dados ordenados temporalmente, suposto com espaçamento temporal constante, original.
% jan: Extensão, em intervalos, da janela temporal adotada.
% def: Retardo temporal do efeito da série transformada. Se não fornecido, adota def=0.
% f:   Instrução se a média móvel deve ser aplicada simetricamente em torno de cada tempo atual (f=0) ou
%      aos valores anteriores (f=1). Se não informado, adota f=1;
%
% Saída:
% mm: Vetor de somas móveis resultante, com a mesma dimensão do vetor de entrada, suposto com espaçamento
%     temporal constante.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Última atualização:     05/01/2019 às 09.52.

% ============================================================================================================
% Sistemática para os códigos dos nomes dos programas:
% ------------------------------------------------------------------------------------------------------------
% Primeira letra: f (de funcao), serve para procura no cadastro, em conjunto com as outras duas letras. As
%                 combinacoes f* passam a ser "palavras reservadas".

% ------------------------------------------------------------------------------------------------------------
% Segunda letra: Especificacao do tipo de dado ou de modelo (melhor ser consoante e nao vogal).

% a: ajustes ou treinamentos.
% d: dados gerais, podem ou nao ser sequenciais.
% s: series sequenciais (importa a ordem dentro da mesma serie).
% t: series temporais (forma st.t/st.d), ou series cujos dados estao associados a tempos e o uso das funcoes
%    depende das informacoes disponiveis dos tempos (dia/mes/ano hora:minuto:segundo) de cada registro.
% m: modelo geral.
% li: modelo linear.
% p: modelo neural com uma camada de neuronios (perceptron).
% n: modelo neural estruturado com duas camadas de neuronios.
% v: modelo de combinacoes de redes neurais estruturadas, agrupadas em celulas, indexadas pelas combinacoes de
%    entradas possiveis de serem solicitadas.
% z: aplicativos para logica fuzzy.

% ------------------------------------------------------------------------------------------------------------
% Terceira letra: Tipo de acao.

% d: descreve dados e series.
% o: organiza ou seleciona dados e arquivos, implicando em movimento.
% p: pesquisa informacoes em funcoes dadas, ou em dados numericos.
% t: transforma dados e series de dados.
% e: exporta dados ou modelos para outro meio, como o excel.
% i: importa dados ou modelos de outro meio, como o excel.
% h: teste de hipotese.
% t: treinamento ou ajuste de modelos, neurais ou lineares, respectivamente.
% u: utilitarios (avaliar desempenho, executar, ilustrar, adicionar probabilidade, etc.).

