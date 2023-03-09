% ============================================================================================================
% LISTA EXPLICATIVA DE RECURSOS ('FUNCTIONS')
% ------------------------------------------------------------------------------------------------------------
% [r, n, p] = fddcorrelacionar(x, y, s, t)
%
% C�lculo da correla��o excluindo preliminarmente registros vazios. Possui duas alternativas, a correla��o
%    linear (Pearson) e a correla��o n�o linear (Spearman).
%
% Entradas:
%  x: Vetor com a primeira s�rie de dados a correlacionar (linha ou coluna).
%  y: Vetor com a segunda s�rie de dados a correlacionar (linha ou coluna).
%  s: Instru��o para n�o emitir ('n' ou 0), ou emitir ('s' ou 1) os resultados, adotando 1 se n�o fornecida.
%  t: Alternativa de correla��o, linear (0) ou monot�nica (1). Se n�o fornecida, adota a linear (0).
%
% Sa�das:
%  r:  Correla��o solicitada.
%  n:  N�mero de registros v�lidos utilizado.
%  p:  p-valor, correspondendo � probabilidade bilateral de erro com a rejei��o da hip�tese H0, de que n�o
%      exista rela��o.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     13/06/2019 �s 12.06.

% ------------------------------------------------------------------------------------------------------------
% [Ja, Jr] = fdoamostragemsistematica(P, r, m, e, v, J)
%
% Sele��o de amostras solicitadas e identifica��o de amostras residuais da sele��o, ambas sem falhas, na 
%   s�rie correspondente de registros, pelo m�todo da amostragem sistem�tica do dom�nio, relacionados 
%   ou n�o a um ordenamento de origem fornecido ou criado.
%
% Entradas:
% P:   Matriz com as amostras existentes para a sele��o. Deve ser a matriz com todas as vari�veis 
%      (entrada e sa�da), sendo a(s) �ltima(s) linha(s) com a(s) vari�veis de sa�da do modelo.
% r:   Informa��o do n�mero definido, tentativo, de registros. Pode ser feita por um n�mero inteiro, ou
%      na forma de uma propor��o. Se n�o fornecida, adota a propor��o 0.1.
% m:   Modo da amostragem sistem�tica, com base em crit�rios aplicados sobre a vari�vel da linha final 
%      da matriz de dados, P, adotando-se 0 se n�o informado:
%        0: Produzir na sele��o, e, consequentemente, tamb�m na amostragem residual, a mesma distribui��o 
%           da s�rie original.
%        1: Reduzir as maiores frequ�ncias, em favor de valores mais altos do dom�nio, resultando uma
%           distribui��o da amostragem selecionada que tende � uniforme, podendo ser mais representativa
%           tamb�m de setores  menos favorecidos do dom�nio.
% e:    Indicador sobre registros com extremos de cada vari�vel representada, adotando-se 0 se n�o informado:
%         0: N�o for�ar a inclus�o de extremos na amostragem selecionada.
%         1: Incluir os registros extremos na sele��o.
% v:    Vari�vel selecionada para efetuar as an�lises, correspondendo a uma linha de P. Se n�o informada,
%       adota a �ltima linha.
% J:    Ordenamento de origem, ou seja, ordem dos dados considerados para sele��o, na matriz P. Se for 
%       informado, as respostas ser�o referenciadas na matriz original que deu origem a J. Se n�o 
%       informado, adota o ordenamento natural, 1:1:length(P), de toda a amostragem fornecida, e as 
%       respostas ser�o refenciadas ao ordenamento na matriz P fornecida.
%
% Sa�das:
% Ja:  Vetor com o ordenamento do subconjunto de J n�o NaN resultante da sele��o.
% Jr:  Vetor com o ordenamento do subconjunto de J n�o NaN remanescente da sele��o.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     16/12/2018 �s 11.29.

% ------------------------------------------------------------------------------------------------------------
% [Jm, Jx] = fdoidentificaregistrospelolimiar(P, limiar, linha, J)
%
% Identifica��o de amostras menores (Jm) e maiores ou iguais (Jx) a um limiar estabelecido, pelos valores da 
%   linha solicitada, em uma matriz M, onde cada coluna corresponde a um registro.
% A pesquisa � limitada aos registros com ordenamento J, se este for fornecido.
%
% Entradas:
% M:        Matriz ou Vetor num�rico com as amostras existentes para a pesquisa, dispostas em colunas.
% limiar:   Valor a ser adotado para a pesquisa. Se n�o fornecido, adota zero.
% linha:    Linha da matriz M a ser adotada para a pesquisa. Se n�o fornecida, adota a �ltima linha de M.
% J:        Vetor com os ordenamentos para a pesquisa em M.
%
% Saidas:
% Jm:  Vetor dos ordenamentos, em J, dos registros com valores menores que o limiar, na linha da pesquisa.
% Jx:  Vetor dos ordenamentos, em J, dos registros com valores maiores que o limiar, na linha da pesquisa.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     13/07/2019 �s 21.27.

% ------------------------------------------------------------------------------------------------------------
% [Js, Ps] = fdoregistrossemfalhas(P, J)
%
% Sele��o de amostras sem falhas na s�rie correspondente a uma vari�vel, mantendo o registro de ordem 
%   dos dados remanescentes, em rela��o a um ordenamento de origem, fornecido ou criado.
%   Se for necess�ria a sincroniza��o das entradas do modelo, deve ser usada depois daquela.
%
% Entradas:
% P:   Matriz ou Vetor com as amostras existentes para a sele��o.
% J:   Vetor com o ordenamento original. Se nao fornecido, adota o ordenamento de P.
%
% Saidas:
% Js:  Vetor com o ordenamento, em J, dos registros remanescentes ap�s a exclus�o dos NaNs.
% Ps:  Matriz ou Vetor com as amostras remanescentes ap�s a exclus�o dos NaNs.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     15/02/2019 �s 17.59.

% ------------------------------------------------------------------------------------------------------------
% [P, nomes] = fdoselecionavar(E, lista, col, Jo)
%
% Seleciona as vari�veis explicativas que far�o parte do modelo, pelos n�meros em lista, podendo ser
%   selecionado um conjunto espec�fico de registros, indicados pelo vetor de ordem, Jo.
%
% Entradas:
% E:                C�lulas com as amostras respectivas, nomes na segunda coluna e s�ries num�ricas em uma 
%                   coluna subsequente.
% lista [1 4 . .]:  Lista dos n�meros de linhas das vari�veis, na estrutura de celulas.
% col:              Coluna(s) para leitura dos dados solicitados em lista. Se informados dois valores
%                   escalares inteiros, o primeiro � a coluna que cont�m os nomes, e o segundo � a coluna que
%                   cont�m os vetores de dados correspondentes. Se fornecido apenas um escalar inteiro, 
%                   considera que a segunda coluna de 'E' cont�m os nomes das vari�veis e a coluna informada
%                   cont�m  os vetores correspondentes de dados. Se n�o informado, adota a coluna 2 para os 
%                   nomes das vari�veis, e a coluna 3 para os vetores de dados correspondentes. 
% Jo:               Vetor com o ordenamento dos dados solicitados. Se n�o informado, seleciona todas as 
%                   amostras.
%                   Caso a origem da sele��o de dados seja um per�odo entre duas datas, em uma s�rie temporal,
%                   o Jo pode ser previamente pesquisado, na linha de tempos (linhatempos) com o uso de:
%                   [Jo]=ftpvetordeordem(E, linhatempos, coluna, inicio, final).
%
% Sa�das:
% P:          Matrizes com as vari�veis selecionadas, na ordem de lista, uma em cada linha.
% nomes:      Nomes das vari�veis selecionadas, obtidas na segunda coluna de E.
% 
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     05/12/2018 �s 14.22.

% ------------------------------------------------------------------------------------------------------------
% [P, T, nomeent, nomesai]=fdosepararsaidas(M, saidas, nomevar, J)
%
% Separa em sa�das e entradas, os dados de uma matriz com, em cada linha, uma s�rie, com base nas 
%    informa��es fornecidas de quais sao as linhas que constituem sa�das, e qual � o subconjunto de 
%    registros da matriz original solicitado, com base em um vetor de ordenamentos.
%    Tamb�m separa os nomes das vari�veis representadas pelas s�ries, em nomes de entrada e de sa�da.
%
% Entradas:
% M:       Matriz com as s�ries originais, uma por linha.
% saidas:  Vetor com as posi��es, em M, das vari�veis que constituir�o as sa�das do modelo. Se n�o for 
%          fornecido, o programa selecionar� a �ltima vari�vel.
% nomevar: Nomes das vari�veis do modelo, uma por linha (dispens�vel se nomeent e nomesai n�o forem
%          solicitadas).
% J:       Vetor de posi��es dos registros da matriz original que ser�o identificados com as entradas e 
%          com as sa�das.
%
% Sa�das:
% P:       Matriz resultante, com os dados formatados segundo os deslocamentos temporais solicitados.
% T:       Matriz com a(s) saida(s) do modelo.
% nomeent: Nomes das vari�veis formatadas para constitu�rem as entradas do modelo, com a defasagem temporal 
%          (solicitada no vetor d) correspondente. Opcional.
% nomesai: Nomes das vari�veis formatadas para constitu�rem as sa�das do modelo, com a defasagem temporal 
%          (solicitada no vetor d) correspondente. Opcional.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     05/11/2018 �s 21.45.

% ------------------------------------------------------------------------------------------------------------
% [Xe, Xu]=fdpinspecionardominio(P, s)
%
% Inspeciona os dados e calcula os limites do dom�nio, fornecendo as matrizes Xe e Xu que atendem limites
%   expandidos com margem de 0.1 da amplitude observada. 
%   Pode-se aceit�-las, como entradas para treinamento, ou, com base nos valores obtidos, elaborar por 
%   conta pr�pria.
%   Se for necess�ria a sincroniza��o das entradas do modelo, deve ser usada depois daquela.
%
% Entradas:
% P:      Matriz com entradas e sa�das do modelo, na forma de uma linha para cada vari�vel.
% s:      Vetor com as linhas que correspondem a sa�das. Se n�o fornecido, sendo solicitados limites de sa�da, 
%         adota a �ltima linha de P como sa�da.
%
% Sa�das:
% Xe, Xu: Matrizes com os limites inferior e superior do dom�nio, respectivamente, das vari�veis de entrada
%         e de sa�da do modelo. 
%         Se solicitado apenas Xe, com uma entrada, n�o divide P em entradas e sa�das.
%         Se solicitado apenas Xe, com 2 entradas, divide P em entradas e sa�das, mas fornece apenas Xe.
% 
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     23/09/2018 �s 11.09.

% ------------------------------------------------------------------------------------------------------------
% fduemitir(vetor, nome, numax)
%
% Emiss�o de vetor de dados, em uma ou mais linhas.
%
% Entradas:
% vetor:   Vetor de dados, em forma de matriz-linha ou de matriz-coluna, ou n�mero individual.
% nome:    Nome do vetor, em caracteres alfanum�ricos. Se n�o fornecido, adota 'Vetor', ou 'Valor'.
% numax:   N�mero m�ximo de valores em cada linha. Se n�o fornecido, adota 12.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% Ultima atualizacao:     16/12/2018 �s 20.35.

% ------------------------------------------------------------------------------------------------------------
% [CEr, NS, NSa, RMQE, RMQEa, n]=fmucompara(T, Y, Ya, e, g, nomesmodelos)
% 
% Calcula o coeficiente de efici�ncia relativa entre dois modelos de previs�o ou de simula��o.
%   Tamb�m fornece os coeficientes de efici�ncia e as m�dias dos quadrados dos erros dos modelos. 
%
% Entradas:
% T, Y, Ya:  S�ries de dados observados e de dados calculados, pelo modelo principal e pelo modelo 
%            alternativo, respectivamente.
% e:         Instru��o para emiss�o (1) ou n�o (0) de Efici�ncias. Se n�o fornecida, adota 1.
% g:         Instru��o para emiss�o (1) ou n�o (0) de gr�ficos. Se n�o fornecida, adota 0.

% nomesmodelos: Nomes (opcionais) dos modelos comparados, no formato char.
%
% Entrada global:
%  nomedorelatorio: Quando existente, proporciona a grava��o do relat�rio, de forma autom�tica.
%                   Se o arquivo j� existe, grava na sequ�ncia.
%
% Sa�das:
% CEr:    Coeficiente de efici�ncia relativa do modelo principal em rela��o ao alternativo.
% NS:     Coeficiente de efici�ncia absoluta (Nash-Suitcliffe): propor��o da varian�a dos dados que �
%         explicada pelo modelo principal.
% NSa:    Coeficiente de efici�ncia absoluta (Nash-Suitcliffe): propor��o da varian�a dos dados que �
%         explicada pelo modelo alternativo.
% RMQE:   Raiz da m�dia dos quadrados dos erros do modelo principal.
% RMQEa:  Raiz da m�dia dos quadrados dos erros do modelo alternativo.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     07/01/2019 �s 10.27.

% ------------------------------------------------------------------------------------------------------------
% [NS, Mea, Mpea, Pbias, Me, E10, E25, E50, E75, E90, n] = fmudesempenho(T, S, g, e, nomes, p)
% 
% C�lculo de estat�sticas de desempenho de previs�o ou de simula��o.
%
% Entradas:
% T, S:   S�ries de dados observados e de dados calculados, respectivamente.
% g:      Instru��o para emiss�o de gr�fico (adota 0 se n�o informado):
%           'n' ou 0: N�o emite figura.
%           's' ou 1: Emite figura com dados observados e calculados.
% e:      Instru��o para emiss�o de resultados (adota 1 se n�o informado):
%           'n' ou 0: N�o emite resultados.
%           's' ou 1: Emite resultados em formato definido, adequado � dimens�o de cada n�mero.
% nomes:  Nome(s), opcional(is), da(s) vari�vel(is) de sa�da, ou legenda da sa�da.
% p:      N�mero de erros absolutos m�ximos considerados exp�rios: Se n�o informado, adota 0.
%
% Entrada global:
%    nomedorelatorio: Quando existente, proporciona a grava��o do relat�rio, de forma autom�tica.
%                     Se o arquivo j� existe, grava na sequ�ncia.
%
% Sa�das:
% NS:     Coeficiente de Nash-Suitcliffe.
% Mea:    M�dia dos erros absolutos.
% Mpea:   M�dia das propor��es, em rela�ao ao valor observado correspondente, dos erros absolutos.
% Pbias:  Estat�stica 100*sum(T-S)/sum(T).
% Me:     M�dia dos erros.
% E10:    Quantil 0.10 dos erros.
% E25:    Quantil 0.25 dos erros.
% E50:    Quantil 0.25 dos erros (mediana).
% E75:    Quantil 0.75 dos erros.
% E90:    Quantil 0.90 dos erros.
% n:      N�mero de registros v�lidos utilizados.
% 
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     17/11/2018 �s 10.49.

% ------------------------------------------------------------------------------------------------------------
% [Y]=fmuextrapolalinear(T, alc, def)
%
% Executa o modelo de extrapolacao linear, que adota, para o horizonte de previsao, o valor linearmente 
%     extrapolado, tomando-se o valor no tempo atual e o valor em um tempo anterior, ocorrido com a defasagem
%     def.
% 
% Entradas:
% T:    Vetor com os dados de entrada originais da vari�vel prevista.
% alc:  Alcance da previs�o, representado pelo n�mero de intervalos � frente.
% def:  Defasagem adotada para fazer a diferen�a a ser extrapolada. Se n�o fornecido, adota o alc.
%
% Sa�da:
% Y:  Valores previstos, por extrapola��o nos tempos atuais, dos registros correspondentes.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     07/01/2019 �s 16.34.

% ------------------------------------------------------------------------------------------------------------
% [rn, V, J] = fnavalcruz(rn, Pt, Tt, Pa, Ta, ciclos, rep, pesos)
%
% Treinamento de redes neurais de uma camada interna de neur�nios, usando a valida��o cruzada e as heur�sticas
%   conjugadas.
%   A condi��o de finaliza��o � quando � esgotado o potencial de incremento da capacidade de generaliza��o, o
%   que pode ser detectado pela estagna��o do aumento do desempenho de valida��o em certo n�mero de ciclos,
%   com ou sem a ocorr�ncia de sobreajustamento.
%   Repeti��es s�o executadas para conferir robustez, adotando-se o melhor resultado obtido na valida��o.
%
% Entradas:
%  rn:      Rede neural previamente configurada (com 'fnuconfigurar').
%  Pt, Tt:  Dados de vari�veis explicativas e explicadas de treinamento, uma vari�vel por linha.
%  Pa, Ta:  Dados de vari�veis explicativas e explicadas de valida��o, uma vari�vel por linha.
%  ciclos:  N�mero m�ximo de ciclos em cada repeti��o. Se n�o informado ('[]'), faz ciclos=100000.
%  rep:     N�mero de repeti��es do procedimento para contornar a falta de robustez, adotando-se o melhor
%           resultado obtido na valida��o. Se n�o informado ('[]'), faz sem repeti��es.
%  pesos:   Valores a serem adotados, para cada registro, para a pondera��o dos erros de treinamento de cada.
%           Se n�o informados, usa pondera��o uniforme.
%
% Sa�das:
%  rn: Rede neural de tr�s camadas, mantendo a estrutura definida por 'fnuinicializar', com os campos:
%      ent: num(n�mero de entradas), nom(nome das entradas),
%           esc(fun��o de escalonamento), par(par�metros da fun��o de escalonamento),
%      int: num(n�mero de neur�nios), sin(matriz de pesos sin�pticos),
%           fat(fun��o de ativa��o), der(derivada da fun��o de ativa��o),
%      sai: num(n�mero de sa�das), nom(nome das sa�das), sin(matriz de pesos sin�pticos),
%           fat(fun��o de ativa��o), der(derivada da fun��o de ativa��o),
%           esc(fun��o de escalonamento, rec(fun��o recupera��o de escala), par(par�metros de escalonamento). 
%
%   V: C�lula com os vetores {Eq, Ev e Tx}, sendo, respectivamente, os erros quadr�ticos de treinamento 
%      e valida��o e as taxas de aprendizado durante o treinamento do modelo adotado.
%   J: Ciclo cujo treinamento foi adotado para o modelo resultante, pelo desempenho da amostra de valida��o.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     16/11/2018 �s 23:46.

% ------------------------------------------------------------------------------------------------------------
% [Ev] = fnpcomplexidade(rn, Pt, Tt, Pa, Ta, H, proxi, ciclos, rep, pesos, f)
%
% Pesquisa da complexidade para redes neurais com duas camadas de neur�nios, representada pelo n�mero m�nimo
%   de neur�nios na camada interna com capacidade de aproxima��o semelhante � de uma rede propositadamente
%   superdimensionada sem ocorr�ncia de sobreajustamento.
%   O procedimento baseia-se na valida��o com repeti��es, seja utilizando-se a valida��o cruzada simples ou
%   fazendo-se uso da valida��o por reamostragem.
%   O resultado � um vetor de estat�sticas de desempenho, para cada complexidade, para an�lise e decis�o:
%     No caso da valida��o cruzada, cada valor deste vetor � o menor (entre as repeti��es) erro quadr�tico
%     m�nimo obtido com a s�rie de valida��o durante os ciclos de treinamento.
%     No cado da valida��o por reamoatragem, cada valor deste vetor � o valor mediano ( entre as repeti��es)
%     dos erros m�dios na valida��o de cada repeti��o.
%
% Programas auxiliares necess�rios: 'fn@valcruz' e 'fn@reamostragem'.
%
% Entradas:
%  Pt, Tt:  Matrizes com as amostragens da vari�veis explicativas e explicada para treinamento.
%  Pa, Ta:  Matrizes com as amostragens da vari�veis explicativas e explicada para valida��o. Se n�o
%           fornecidas ('[]'), � realizada a valida��o por reamostragem.
%  H:       Vetor com as complexidades (n�mero de neur�nios internos) que deseja-se analisar.
%  proxi:   Vetor de proximidades a experimentar, na escala reduzida, para uso do m�todo de pesquisa com
%           reamostragem. Se n�o informado ('[]'), realiza a pesquisa com a valida��o cruzada (se fornecidos 
%           os 'Pa' e 'Ta'), ou adota um vetor padr�o (supondo amplitude de sa�da igual a 1), com propor��o
%           do maior erro m�dio sendo 0.1 do dom�nio:
%           [0.1 0.08 0.06 0.05 0.045 0.04 0.035 0.03 0.025 0.02 0.018 0.015 0.012 0.01 0.008 0.005 0.003].
%  ciclos:  N�mero m�ximo de ciclos em cada itera��o. Se n�o informado, faz ciclos=100000.
%  rep:     N�mero de repeti��es do procedimento para contornar a falta de robustez. Adota 5, se n�o
%           informado.
%  pesos:   �ndice para a pondera��o dos erros de treinamento. Se n�o informado, adota pesos uniformes.
%  f:       Indicativo da estat�stica de decis�o (0: mediana; 1: m�dia; 2: m�nimo), entre os erros m�dios de
%           cada repeti��o, para o uso na valida��o por reamostragem. Se n�o informado, adota o '0'(mediana).
%
% Sa�das:
%  Ev:       Vetor com as estat�sticas de erros, resultantes na escala reduzida, para a amostragem de
%            valida��o, em cada complexidade analisada. Para a valida��o cruzada, correspondem ao melhor
%            resultado das somas do quadrado dos erros, entre as repeti��es realizadas. Para a valida��o por
%            reamostragem, s�o calculadas as estat�sticas (mediana, m�dia ou m�nimo) entre os erros
%            absolutos m�dios de cada repeti��o.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     15/01/2019 �s 08.29.

% ------------------------------------------------------------------------------------------------------------
% rn=fnuconfigurar(n, enom, eesc, epar, ifat, ider, snom, sfat, sder, sesc, srec, spar);
%
% Inicializa��o da estrutura de uma rede neural de tr�s camadas. Se n�o informadas as fun��es de escalonamento
%   e de ativa��o, adota a fun��o linear para os escalonamentos e a fun��o sigm�ide unipolar para as fun��es
%   de ativa��o, e as respectivas fun��es de recupera��o e derivadas.
%
% Entradas:
%  n:      Vetor com as dimens�es da rede (n�mero de entradas, de neur�nios internos e de sa�das): [ne ni ns].
%  enom:   Nomes, opcionais, das variaveis de entrada. Se ausentes, adota 'X1', ..., 'Xn'.
%  eesc:   Fun��o an�nima, em forma textual, de escalonamento das entradas.
%  epar:   Par�metros das fun��es de escalonamento das entradas, um conjunto (linha) de valores
%          para cada vari�vel. Se n�o fornecidos, adota valores sem efeito, considerando fun��es lineares.
%  ifat:   Fun��o an�nima, em forma textual, de ativa��o dos neur�nios da camada interna.
%          Exemplo: ifat='@(n) 1./(1+exp(-n))';
%  ider:   Fun��o an�nima, em forma textual, para a derivada de ativa��o dos neur�nios da camada interna.
%  snom:   Nomes, opcionais, das variaveis de saida. Se ausentes, adota 'Y'.
%  sfat:   Fun��o an�nima, em forma textual, de ativa��o dos neur�nios da camada de sa�da.
%  sder:   Fun��o an�nima, em forma textual, para a derivada de ativa��o dos neur�nios da camada de sa�da.
%  sesc:   Fun��o an�nima, em forma textual, de escalonamento das sa�das.
%  srec:   Fun��o an�nima, em forma textual, de recupera��o da escala original das sa�das.
%  spar:   Par�metros das fun��es de escalonamento das sa�das, um conjunto (linha) de valores
%          para cada vari�vel. Se n�o fornecidos, adota valores sem efeito, considerando fun��es lineares.
%  
% Sa�da:
%  rn: Rede neural de tr�s camadas, estruturada segundo os campos a seguir.
%      ent: num(n�mero de entradas), nom(nome das entradas),
%           esc(fun��o de escalonamento), par(par�metros da fun��o de escalonamento),
%      int: num(n�mero de neur�nios), sin(matriz de pesos sin�pticos),
%           fat(fun��o de ativa��o), der(derivada da fun��o de ativa��o),
%      sai: num(n�mero de sa�das), nom(nome das sa�das), sin(matriz de pesos sin�pticos),
%           fat(fun��o de ativa��o), der(derivada da fun��o de ativa��o),
%           esc(fun��o de escalonamento, rec(fun��o recupera��o de escala), par(par�metros de escalonamento). 
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     15/09/2018 �s 15.17.

% ------------------------------------------------------------------------------------------------------------
% [Y] = fnuexecutar(rn, P, op)
% 
% Executa modelos generalizados com redes neurais de uma camada interna.
% 
% Entradas:
% rn:   Rede neural de tr�s camadas, na forma estruturada.
% P:    Vari�veis explicativas, uma por linha de P, sendo cada coluna um registro.
% op:   Instru��o para as alternativas opcionais de execu��o, na forma de escalares inteiros:
%       0: Aceita os resultados da rede neural.
%       1: Faz Y=0 quando todos os abs(P)'s do registro forem < 0.01.
%       2: Faz Y=0 quando o valor calculado deste resultar < 0.01.
%       3: Faz Y=0 quando todos os abs(P)'s forem < 0.01 ou quando Y calculado resultar < 0.01.
%
% Sa�da:
% Y:    Sa�das calculadas, uma linha para cada vari�vel, e uma coluna para cada registro.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     22/09/2018 �s 09.46.

% ------------------------------------------------------------------------------------------------------------
% fnuilustrar(rn)
% 
% Realiza a figura de uma rede neural com tr�s camadas, condicionado a que esta seja na forma estruturada.
%   As linhas representam as conex�es, cujas expessuras est�o relacionadas com a magnitude destas. Tamb�m, as
%   cores representam os sinais destas (ou seja, dos pesos sin�pticos), sendo positivos em vermelho e
%   negativos em verde.
% 
% Entradas:
%   rn: Rede neural de tr�s camadas, na forma estruturada.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     18/08/2018 �s 21.43.

% ------------------------------------------------------------------------------------------------------------
% [dif, def] = fsadifemovel(P, T, maxdif, maxdef, Jo)
%
% Ajuste do par�metro do n�mero de intervalos anteriores para cada diferen�a, bem como da defasagem, no 
%   c�lculo da diferen�a m�vel, que resulta na s�rie sequencial de diferen�as com melhor correla��o com uma 
%   outra s�rie sequencial, que corresponde a uma s�rie de ajuste.
%
% Entradas:
% P:      S�rie sequencial a ser transformada.
% T:      S�rie sequencial de ajuste, podendo ser n�veis ou vaz�es no caso de transforma��o de chuvas.
% maxdif: M�ximo valor a ser pesquisado para a o n�mero de intervalos. Se n�o informado, adota 30.
% maxdef: M�ximo valor a ser pesquisado para o retardo temporal. Se n�o informado, adota 30.
% Jo:     Vetor linha com n�meros de ordem da s�rie T, considerando-se que esta seja constitu�da de parte dos
%         registros de P. Se n�o informado, considera que a s�rie � de mesma extens�o da s�rie P.
%
% Sa�das:
% dif:    Diferen�a, em intervalos de tempo da sequ�ncia.
% def:    Deslocamento temporal da s�rie transformada, sendo negativo em dire��o ao passado.
%         Se n�o solicitado, realiza a pesquisa para def=0.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     26/04/2019 �s 08.04.

% ------------------------------------------------------------------------------------------------------------
% [mei, def] = fsamediamovelexpo(P, T, maxmei, maxdef, Jo)
%
% Ajuste dos par�metros para a fun��o de decaimento exponencial para a m�dia m�vel dos valores passados
%   correspondentes de uma s�rie sequencial, podendo admitir, al�m da meia-vida, uma defasagem temporal.
%
% Entradas:
% P:      S�rie sequencial a ser transformada.
% T:      S�rie sequencial de ajuste, podendo ser n�veis ou vaz�es no caso de transforma��o de chuvas.
% maxmei: M�ximo valor a ser pesquisado para a meia-vida. Se n�o informado, adota 30.
% maxdef: M�ximo valor a ser pesquisado para o retardo temporal. Se n�o informado, adota 50.
% Jo:     Vetor linha com n�meros de ordem da s�rie T, considerando-se que esta seja constitu�da de parte dos
%         registros de P. Se n�o informado, considera que a s�rie � de mesma extens�o da s�rie P.
%
% Sa�das:
% mei:    Meia-vida, em intervalos de tempo da sequ�ncia, com precis�o de meio intervalo.
% def:    Retardo temporal do efeito da s�rie transformada sobre a s�rie de ajuste. Se n�o solicitado, 
%         realiza a pesquisa para def=0.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     26/12/2018 �s 10.48.

% ------------------------------------------------------------------------------------------------------------
% [F, E] = fsamediamovelgama(P, T, maxfor, maxesc, p, mo, Jo)
%
% Ajuste dos par�metros para a fun��o gama para o c�lculo da m�dia m�vel dos valores passados correspondentes
%    de uma s�rie sequencial.
%
% Entradas:
% P:      S�rie sequencial a ser transformada.
% T:      S�rie sequencial de ajuste, podendo ser n�veis ou vaz�es no caso de transforma��o de chuvas.
% maxfor: Maior valor a ser pesquisado para o par�metro de forma.  Se n�o informado adota 80.
% maxesc: Maior valor a ser pesquisado para o par�metro de escala. Se n�o informado adota 50. 
% p:      Menor valor (precis�o) dos pesos de pondera��o da m�dia m�vel. Se n�o informado adota 0.01.
% mo:     Modo de pesquisa, pela otimiza��o por procura exaustiva (0), ou com uso do recurso 'fminunc' (1).
%         Se n�o informado, adota a alternativa 0.
% Jo:     Vetor linha com n�meros de ordem da s�rie T, considerando-se que esta seja constitu�da de parte dos
%         registros de P. Se n�o informado, considera que a s�rie T � da mesma extens�o da s�rie P.
%
% Sa�das:
% F: Par�metro de forma,  F=(E(x)^2)/Var(x).
% E: Par�metro de escala, E=Var(x)/E(x). Ent�o, E(x)=F*E.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     04/01/2019 �s 10.47.

% ------------------------------------------------------------------------------------------------------------
% [jan, def] = fsamediamoveluni(P, T, maxjan, maxdef, f, Jo)
%
% Ajuste dos par�metros (extens�o da janela e defasagem) para a fun��o de m�dia m�vel com pesos uniformes 
%   dos valores de uma s�rie sequencial.
%
% Entradas:
% P:      S�rie sequencial a ser transformada.
% T:      S�rie sequencial de ajuste, podendo ser n�veis ou vaz�es no caso de transforma��o de chuvas.
% maxjan: M�ximo valor a ser pesquisado para a extens�o da janela. Se n�o informado, adota 30.
% maxdef: M�ximo valor a ser pesquisado para o retardo temporal. Se n�o informado, adota 30.
% f:      Instru��o se a m�dia m�vel deve ser aplicada simetricamente em torno de cada tempo atual (f=0) ou
%         aos valores anteriores (f=1). Se n�o informado, adota f=1.
% Jo:     Vetor linha com n�meros de ordem da s�rie T, considerando-se que esta seja constitu�da de parte dos
%         registros de P. Se n�o informado, considera que a s�rie � de mesma extens�o da s�rie P.
%
% Sa�das:
% jan:    Extens�o da janela m�vel, em intervalos de tempo da sequ�ncia.
% def:    Retardo temporal do efeito da s�rie transformada sobre a s�rie de ajuste. Se n�o solicitado, 
%         realiza a pesquisa para def=0.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     04/01/2019 �s 17.17.

% ------------------------------------------------------------------------------------------------------------
% [w] = fscpesosmediamovelexpo(mei, p)
% 
% Gera��o de pesos exponencialmente decrescentes em dire��o ao passado, para o c�lculo da m�dia m�vel
%   ponderada exponencialmente das chuvas passadas.
% 
% Entradas:
% mei: Meia-vida, sendo uma quantidade positiva, real ou inteira, de intervalos de dados considerados.
% p:   Menor peso considerado significativo, a resultar para o temp t-q. Se n�o informado, adota p=0.001.
%
% Sa�da:
% w:   Pesos gerados, constituindo um vetor-linha, com os pesos maiores em dire��o ao presente (t).
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     05/01/2019 �s 10.09.

% ------------------------------------------------------------------------------------------------------------
% [w] = fscpesosmediamovelgama(F, E, p)
%
% Gera��o de pesos para a pondera��o, para o c�lculo da m�dia m�vel de valores passados, usando a fun��o GAMA2
%   de densidade de probabilidade.
% 
% Entradas:
% F, E:   Par�metros, de forma (>=1) e de escala (>=1/2), da fdp GAMA2.
% p:      Menor peso considerado significativo, a resultar para o temp t-q. Se n�o informado, adota p=0.001.
%
% Sa�da:
% w:   Pesos gerados, constituindo um vetor-linha, com os pesos maiores em dire��o ao presente (t).
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     10/07/2019 �s 18.27.

% ------------------------------------------------------------------------------------------------------------
% [r, rmax, dmax, n] = fsdcorrelograma(x, y, def, m, g)
%
% C�lculo de intercorrelogramas. Para autocorrelogramas, repetir a primeira s�rie (x) no lugar da segunda (y).
%
% Entradas:
% x:     Vetor (linha ou coluna) com a s�rie temporal causal atual (t), a qual � emparelhada com a s�rie
%        consequente, a cada defasagem testada, mediante seu deslocamento do passado (t) para a posi��o
%        temporal da s�rie consequente (t + defasagem d).
% y:     Vetor (linha ou coluna) com a s�rie temporal consequente.
% def:   Posi��o (inteira e positiva) m�xima das defasagens (d = 0. . .def).
% m:     Informa��o para emiss�o de resultados (0 se n�o informado):
%           0:  N�o emite resultados.
%           1:  Emite todas as correla��es, em ordem crescente das defasagens.
%           2:  Emite o resumo, com as correla��es da defasagem 0, a m�xima absoluta (com a defasagem) e a
%               �ltima.
% g:     Informa��o para emiss�o de gr�ficos (0 se n�o informado):
%           0: N�o emite gr�ficos.
%           1, 2, . . .:  Emite correla��es das defasagens pesquisadas, em figura com este n�mero, criando-a, 
%                          se n�o existe, ou adicionando a esta o novo correlograma.
%                          No Matlab, correlogramas na mesma figura dependem de 'hold on' fora da fun��o.
%
% Sa�das:
%  r:      Vetor com as intercorrela��es solicitadas, incluindo a defasagem zero.
%  rmax:   Correla��o m�xima ocorrida nas defasagens pesquisadas.
%  dmax:   Defasagem correspondente � correla��o m�xima obtida.
%  n:      N�mero de registros emparelhados v�lidos.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     05/12/2018 �s 16.22.

% ------------------------------------------------------------------------------------------------------------
% [v]=fsiexcel(nomeler, plan, fila, limites, dataini)
%
% Importa��o de uma s�rie de dados num�ricos de uma fila (linha ou coluna), em limites especificados de linha
%   ou de coluna, do Excel, que � acomodada em um vetor-linha.
%   Se a s�rie for de tempos (dd/mm/aaaa hh:mm), esta deve ser previamente convertida, no Excel, para a forma
%   num�rica. Neste caso, � recomend�vel a entrada adicional da data inicial (dataini), para corre��es
%   eventualmente necess�rias da convers�o do tempo.
% 
% Entradas:
% nomeler:  Nome do arquivo Excel, inclusive a termina��o, para a leitura de dados. Se n�o for inclu�da a
%           termina��o, � adotada a '.xlsx'.
% plan:     N�mero da planilha a ser lida. Se n�o fornecida, adota 1.
% fila:     Indica��o da fila a ser lida. Se for um n�mero inteiro, est� sendo solicitada uma linha, e se for 
%           uma ou mais letras (ex.: 'a', 'ab'), est� sendo solicitada uma coluna. � indispens�vel.
% limites:  Vetor com as posi��es iniciais e finais da fila solicitada. Se esta for uma coluna, devem ser os 
%           n�meros inteiros correspondentes �s linhas (ex.: [1; 1023]. Se a fila solicitada for uma linha, os
%           limites devem ser as colunas correspondentes (ex.: char('d', 'aih').
% dataini:  Tempo correspondente ao primeiro registro, a ser fornecido somente se a coluna lida for de tempos
%           [dia/mes/ano hor:min:seg], recomend�vel para correcoes de diferen�as de formatos de convers�o para
%           a forma num�rica. Deve ser informado no formato [ano mes dia hora minuto segundo].
%
% Sa�da:
% v:        Vetor, na forma de um vetor-linha, que cont�m a s�rie num�rica lida na coluna especificada.
%           Se a s�rie for de tempos, os valores de v serao os n�meros que representam os tempos, que o Matlab
%           pode converter em [ano mes dia hora minuto segundo], com uso do datevec.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     20/10/2018 �s 15.46.

% ------------------------------------------------------------------------------------------------------------
% [m, nomespos] = fsosincronizar(M, d, nomes)
%
% Sincroniza��o de s�ries, fornecidas em registros (colunas) especificados de uma matriz, sendo uma s�rie 
%   por linha desta matriz.
%
% Entradas:
% M:     Matriz com as vari�veis originais, uma por linha.
% d:     Vetor indicativo do deslocamento temporal desejado para cada vari�vel, ou seja, um n�mero por linha.
%        Condi��es:
%          - Se o valor for > 0: Os valores ser�o deslocados para a direita (em dire��o ao futuro).
%          - Se o valor for = 0: Os valores n�o ser�o deslocados temporalmente.
%          - Se o sinal for < 0: Os valores ser�o deslocados para a esquerda (em dire��o ao passado).
% nomes: Nomes das vari�veis que ser�o sincronizadas, para acr�scimo da posi��o temporal.
%
% Sa�das:
% m:        Matriz resultante, com as s�ries sincronizadas segundo os deslocamentos solicitados.
% nomespos: Nomes das vari�veis, com o indicativo da posi��o temporal, no passado (-) ou futuro (+).
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     07/01/2019 �s 17.29.

% ------------------------------------------------------------------------------------------------------------
% [Vd]=fstdefasarserie(V, def)
% 
% Deslocamento dos valores de uma s�rie sequencial, suposta representante de uma s�rie temporal.
%
% Entradas:
% V:     S�rie sequencial original.
% def:   Escalar, com o n�mero e o sinal do deslocamento solicitado, segundo a conven��o:
%        Se positivo, desloca o vetor para a direita, avan�ando no tempo.
%        Se negativo, desloca o vetor para a esquerda, ou seja, recuando no tempo.
%
% Sa�da:
% Vd:    S�rie sequencial de respostas, com os dados da s�rie deslocados no tempo.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     24/05/2019 �s 16.40.

% ------------------------------------------------------------------------------------------------------------
% [dm] = fstdifemovel(V, dif, def)
% 
% Realiza a diferen�a dos registros com respeito aos dif intervalos anteriores, e atribui esta diferen�a na
%    posi��o final deste intervalo, resultando um vetor de mesmo n�mero de registros do vetor original.
%    O vetor original deve ser com espa�os temporais uniformes.
%
% Entradas:
% V:    Vetor de dados ordenados temporalmente, suposto com espa�amento temporal constante.
% dif:  N�mero inteiro de intervalos anteriores para cada diferen�a.
% def:  Deslocamento temporal da s�rie transformada, sendo negativo em dire��o ao passado.
%       Se n�o fornecido, realiza a transforma��o para def=0.
%
% Sa�da:
% dm:   Vetor de diferen�as m�veis resultante, com a mesma dimens�o do vetor de entrada.
% 
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     26/04/2019 �s 07.59.

% ------------------------------------------------------------------------------------------------------------
% [mm] = fstmediamovel(V, w, f)
%
% Aplica��o da m�dia m�vel, na forma de vetor de pesos, atuando sobre valores sim�tricos em torno do tempo
%   atual, ou sobre valores antecedentes ao tempo atual.
% 
% Entradas:
% V:  Vetor com a s�rie sequencial original.
% w:  Vetor com os pesos a aplicar.
% f:  Instru��o sobre o modo de aplica��o, se simetricamente em torno de cada tempo atual (f=0) ou
%     aos valores anteriores (f=1). Se n�o informado, adota f=1;
%
% Sa�da:
% mm: Vetor com a s�rie sequencial resultante.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     05/01/2019 �s 11.29.

% ------------------------------------------------------------------------------------------------------------
% [mm] = fstmediamovelexpo(vo, mei, def)
% 
% Aplica filtro de m�dia m�vel em uma s�rie sequencial, na forma de um vetor com espa�amentos supostos
%    uniformes, com decaimento exponencial em dire��o ao passado, admitindo defasagem temporal do efeito da
%    m�dia m�vel sobre uma vari�vel de ajuste.
%    Decaimento exponencial: y(t) = (1 - alfa)*y(t-1) + alfa*(x(t)), com alfa = 1 - 0.5.^(1./mei)
%    mei = meia-vida (quantidade de intervalos anteriores que ponderam 0,5).
%
% Entradas:
% vo:   Vetor de dados ordenados temporalmente, suposto com espa�amento temporal constante, original.
% mei:  Meia-vida.
% def:  Retardo m�ximo admitido. Se n�o informado, adota def=0.
% 
%
% Saida:
% mm: Vetor de m�dias m�veis resultante, com a mesma dimens�o do vetor de entrada, suposto com espa�amento
%     temporal constante.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     05/01/2019 �s 10.02.

% ------------------------------------------------------------------------------------------------------------
% [mm] = fstmediamovelgama(V, F, E, p)
% 
% Aplica filtro de m�dia m�vel dos valores passados com pondera��o Gama2 em uma s�rie sequencial, na forma de
%   um vetor com espa�amentos supostos uniformes.
%
% Entradas:
% V:  Vetor de dados ordenados temporalmente, suposto com espa�amento temporal constante, original.
% F:  Par�metro de forma,  F=(E(V)^2)/Var(V).
% E:  Par�metro de escala, E=Var(V)/E(V). Ent�o, E(V)=F*E.
% p:  Menor peso considerado significativo, a resultar para o temp t-q. Se n�o informado, adota p=0.01.
%
% Sa�da:
% mm: Vetor de somas m�veis resultante, com a mesma dimens�o do vetor de entrada, suposto com espa�amento
%     temporal constante.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     10/07/2019 �s 18.31.

% ------------------------------------------------------------------------------------------------------------
% [mm] = fstmediamoveluni(V, jan, def, f)
% 
% Aplica filtro de m�dia m�vel com pondera��o uniforme em uma s�rie sequencial, na forma de um vetor com
%    espa�amentos supostos uniformes, admitindo defasagem temporal do efeito da m�dia m�vel sobre uma vari�vel
%    de ajuste.
%
% Entradas:
% V:   Vetor de dados ordenados temporalmente, suposto com espa�amento temporal constante, original.
% jan: Extens�o, em intervalos, da janela temporal adotada.
% def: Retardo temporal do efeito da s�rie transformada. Se n�o fornecido, adota def=0.
% f:   Instru��o se a m�dia m�vel deve ser aplicada simetricamente em torno de cada tempo atual (f=0) ou
%      aos valores anteriores (f=1). Se n�o informado, adota f=1;
%
% Sa�da:
% mm: Vetor de somas m�veis resultante, com a mesma dimens�o do vetor de entrada, suposto com espa�amento
%     temporal constante.
%
% Olavo Correa Pedrollo - Universidade Federal do Rio Grande do Sul - IPH
% �ltima atualiza��o:     05/01/2019 �s 09.52.

% ============================================================================================================
% Sistem�tica para os c�digos dos nomes dos programas:
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

