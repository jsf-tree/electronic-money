function [rn_S , V_s , J_s , pr]=fntreinaval_jsf3( rn , Pt , Tt , Pl , Tl , ciclos , rep , c)
%% [rn_S,V_s,J_s,pr,desvio]=fntreinaval_jsf3(rn,Pt,Tt,Pl,Tl,ciclos,rep,c)
% Treinamento de rede neural de uma única camada interna, com taxa heuristica e validação Cruzada embutida
%
% Entradas:
%   rn      Estrutura da Rede Neural (composta de rn.ent rn.int rn.sai) 
%   Pt      Pattern entrada para o Treinamento 
%   Tt      Target saida para o Treinamento 
%   Pl      Pattern entrada para a Validacao 
%   Tl      Target saida para a Validacao 
%   rep     Número de repetições para buscar minimos relativos 
%   c       Critério adotado para seleção da melhor repetição
%           0 - Mínimo dos erros quadráticos da validação 
%           1 - Mediana dos erros quadráticos da validação 
%           2 - Máximo NS da validação 
%           3 - Mediana dos Ns da validação 
%           4 - Mínimo dos erros quadráticos da validação correspondentes aos 10% maiores valores de saida
% Saidas:
%   rn_S        Estrutura final da Rede Neural 
%   V_s         RMSE_t, Ea, Tx:
%                   Célula com os vetores {RMSE_t, Ev e Tx}, sendo,
%                   respectivamente, os erros quadráticos do treinamento,
%                   da validação, e as taxas de aprendizado durante o
%                   treinamento do modelo adotado.
%   J_s         Ciclo de Parada - Validação Cruzada 
%   metrica_rep Ev de cada repeitação 
%   pr          Performance das repetições
%                   Para cada rep (linha), 
%                         Ciclo de Parada     - 'Jx'                
%                         RMSE_t(ciclo)       - 'RMSE_t (ciclo)'
%                         RMSE_l (ciclo)      - 'RMSE_l (ciclo)'
%                         Tx_t   (ciclo)      - 'Tx_t   (ciclo)'
%                         NS_l (Jx)           - 'NS_l (Jx)'
%                         DistErro Validacao  - 'E10 E25 E50 E75 E90 MEA',
%                         RMSE_l_>atencao     - 'RMSE_l_atencao'
%                         Quantil_l_>atencao  - 'Quantil_l_>atencao',
%                         Estrutura rn        - 'rn'
%
% Juliano Finck Ultima atualização: 28/04/2020

%% Extração de informações da estrutura da RNA (rn):
    % Funções de Ativação e suas Derivadas %
    Ah=eval(rn.int.fat);                                                    % Leitura da função de ativação da camada interna (armazenada em string em forma de ponteiro) "@(n)1./(1+exp(-n))"
    Dh=eval(rn.int.der);                                                    % Leitura da derivada da função de ativação da camada interna (armazenada em string em forma de ponteiro) "@(a) max(a.*(1-a), 0.01)"¹
    As=eval(rn.sai.fat);                                                    % Leitura da função de ativação da camada de saida (armazenada em string em forma de ponteiro) "@(n)1./(1+exp(-n))"
    Ds=eval(rn.sai.der);                                                    % Leitura da derivada da função de ativação da camada de saida (armazenada em string em forma de ponteiro) "@(a) max(a.*(1-a), 0.01)"¹
    % NOTA: Explicação nomes: (A é Ativação; D é Derivada; h é hidden layer
    % (camada interna); s é cama de saída) *¹Nota: às vezes a derivada
    % retorna muito muito baixa, por isso é adicionado o minimo de 0.01
    nh=rn.int.num;                                                          % Número de neurônios internos
    % Funções de Escalonamento e Parâmetros de Escalonamento
    eesc=eval(rn.ent.esc);                                                  % Função de escalonamento para entrada (armazenada em string em forma de ponteiro) "@(v, par, u) (v-par(:, 1)*u)./(par(:, 2)*u)"
    epar=rn.ent.par;                                                        % Parâmetros utilizados para cada nó de entrada pela função de escalonamento de entrada
    sesc=eval(rn.sai.esc);                                                  % Função de escalonamento para saída (armazenada em string em forma de ponteiro) "@(v, par, u) (v-par(:, 1)*u)./(par(:, 2)*u)"
    spar=rn.sai.par;                                                        % Parâmetros utilizados para cada nó de saída pela função de escalonamento de saída
    
%% Escalonar os registros de entrada e saída para treinamento (Pt, Tt) e validação-cruzada (Pl, Tl)
    u=ones(1, size(Pt, 2));                                                 % Inicializar um vetor-base para multiplicar os parâmetros de escalonamento, serão usados nas funções de escalonamento
    p=eesc(Pt,epar,u);                                                      % Entradas dos registros de treinamento (Padrões)
    t=sesc(Tt,spar,u);                                                      % Saída dos registros de treinamento (Alvos)
    
    ul=ones(1,size(Pl,2));                                                  % Inicializar um vetor-base para multiplicar os parâmetros de escalonamento, serão usados nas funções de escalonamento
    pl=eesc(Pl,epar,ul);                                                    % Entradas dos registros de validação (Padrões)
    tl=sesc(Tl,spar,ul);                                                    % Saída dos registros de validação (Alvos)
    % Nota: Explicação nomes: (P é o padrão de entrada; T é o alvo de saída
    % da rede; t é treinamento; l é validação cruzada)
    
%% Pronto para inicializar o treinamento
    fprintf('\n%s\n','% Em treinamento');tempo=clock;                         % Declara início do treinamento no console e armazena tinicial
    if isempty(c),c=0; end                                                  % Critério clássico do grupo se C é empty
    pr(1,2:11)={'rep','Jx','RMSE_t (ciclo)','RMSE_l (ciclo)','Tx_t (ciclo)','NS_l (Jx)','E10 E25 E50 E75 E90 MEA','RMSE_l_>atencao','Quantil_l_>atencao','rn'};
    for i=1:rep+1, pr{i,1}=i; end                                           % Prealocar pr
%% TREINAMENTO    
for r=1:rep
    fprintf('%s %i\t','% rep =',r);                                         % Declara início do treinamento da respectiva repetição
% Pré-Treinamento:
    % Iniciar pesos sinápticos aleatórios
    [wh, bh, ws, bs]=fniniciais(nh, p, t);                                  % (Neurônios Internos X Tamanho da Entrada X Tamanho da Saída -> pesos sinápticos aleatórios)
    
    % Propagar o sinal de entrada (p - padrão) até a saída (s), passando
    % pela camada interna (h)
    h=Ah(wh*p+bh*u);                                                        % h=1./(1+exp(-(wh*p+bh*u)));        % Sinal para camada interna
    s=As(ws*h+bs*u);                                                        % s=1./(1+exp(-(ws*h+bs*u)));        % Sinal para camada de saida
    
    % Erro calculado para primeira iteração
    es=t-s;                                                                
    RMSE_t=NaN(1,ciclos); Tx=NaN(1,ciclos);                                  % Prealocar as variáveis para armazenar o Erro Quadrático e a Taxa (Diminui o tempo de processamento)
    RMSE_t(1)=sqrt(sum(sum(es.^2)));                                         % Guarda o erro quadrático para o primeiro ciclo
    taxa=0.05; Tx(1)=taxa; mom=0.96; mo=mom; ciclo=1;                        % Define taxa de treinamento e o momento inicial
    dwh=0.*wh ; dbh=0.*bh ; dws=0.*ws ; dbs=0.*bs ;                          % Inicia vetores para variação dos pesos sinápticos (Todos começam zerados)
    
    RMSE_l=NaN(1,ciclos); RMSE_l(1)=RMSE_t(1); RMSE_lx=RMSE_t(1).*10;        % Incializar parâmetros de ótimo para caso o treinamento estagne logo no início (caso raro)
    Jx=1; whx=wh; bhx=bh; wsx=ws; bsx=bs;                                   
    %% Iniciar os ciclos de treinamento
while (ciclo < ciclos && ciclo<=Jx+1000) , ciclo=ciclo+1;                          % Parar se Nº max ciclos ou tolerência de ciclos piores atingido.
    %% RETROPROPAGAÇÃO PURA
    [Wh, Bh, Ws, Bs]= fnatualiza(wh, bh, ws, bs, p, h, s, es, Dh, Ds, taxa, u);     % Retropropaga o erro, atualizando os novos pesos sinápticos
    %% TAXA CONJUGADA (MOMENTO+HEURISTICA)
    % Adiciona o momento de inércia aos pesos
    Wh=Wh+mo*dwh ; Bh=Bh+mo*dbh; Ws=Ws+mo*dws; Bs=Bs+mo*dbs ;
    
    % Feedforward com novos pesos
    H=Ah(Wh*p+Bh*u); S=As(Ws*H+Bs*u);                                                                
    % Calcula o erro de saída
    Es=t - S;
    % Armazena o Erro (RMSE_t) e a Taxa (Tx) de aprendizado desse ciclo
    RMSE_t(ciclo)=sqrt(sum(sum(Es.^2))); Tx(ciclo)=taxa;                              
    
    % AVALIAR ITERAÇÃO - Foi uma iteração de sucesso para o treinamento?
        
    if RMSE_t(ciclo) > RMSE_t(ciclo-1)% PIOROU! Se o erro aumentou, penaliza a taxa em 50%, zera o momento e treina novamente                                              
            taxa=max(taxa*0.5, 0.005*abs(randn)^3+0.005); RMSE_t(ciclo)=RMSE_t(ciclo-1); 
            mo=0; 
        
    else% MELHOROU! Se o erro diminuiu ou ficou igual, calcula-se o momento de inércia e aumenta a taxa                                                                        
            dwh=Wh-wh; dbh=Bh-bh; dws=Ws-ws; dbs=Bs-bs; mo=mom;             % Calcula-se o passo do momento E reinicializa o momento com mom (0.96) - Isso quer dizer que haverá uma tendência dos pesos continuarem na mesma direção anterior
            wh=Wh; bh=Bh; ws=Ws; bs=Bs; h=H; s=S; es=Es; taxa=taxa*1.1;     % A taxa é aumentada
    end
    
%% VALIDAÇÃO CRUZADA - Será que a capacidade de generalização está sendo comprometida?
    hl=Ah(wh*pl+bh*ul); sl=As(ws*hl+bs*ul);                                 % Feedforward com w desse ciclo
    el=tl-sl; RMSE_l(ciclo)=sqrt(sum(sum(el.^2)));                          % Armazena o RMSE_l desse ciclo
    % AVALIAR ITERAÇÃO - Foi um ciclo bom para validação?
    if (RMSE_l(ciclo-1)>RMSE_l(ciclo)) && (RMSE_l(ciclo)<RMSE_lx)           % Se (1) RMSE_l diminuiu E 2. RMSE_l nunca foi tão baixo,
        Jx=ciclo; RMSE_lx=RMSE_l(Jx);whx=wh; bhx=bh; wsx=ws; bsx=bs;        % Amazenar ciclo, RMSE e pesos do ciclo da validação cruzada.          
        else
    end
end % while (ciclo < ciclos && ciclo<=Jx+1000) , ciclo=ciclo+1; LIN 119     
    % Alocar os pesos encontrados na rede e limpar excesso de variáveis pré-alocadas
    rn.int.sin=[whx bhx];   rn.sai.sin=[wsx bsx];
    RMSE_t(:,ciclo+1:end)=[]; Tx(:,ciclo+1:end)=[]; RMSE_l(:,ciclo+1:end)=[]; 
% Declaração do Ciclo de Parada pela Validação Cruzada
    % Feedforward com wx da validacão cruzada
    hl=Ah(whx*pl+bhx*ul); sl=As(wsx*hl+bsx*ul);                                   % Não usar fnexecutar porque sl ficará escalonado
    tl_mean=mean(tl); el=tl-sl; NS_val=1-sum(el.^2)/((tl-tl_mean)*(tl-tl_mean)'); % Calcular NS_val
    % Faltaram ciclos? Performance de validação no console. 
    forma='%s%08i\t\t%s%01.6f   \t\t%s%01.6f'; fprintf(forma,'J = ',Jx,'NS_val = ',NS_val,'RMSE_l = ',RMSE_lx);
    if Jx>ciclos-1000, fprintf('%s\n','(Inseguro!)'); else, fprintf('\n'); end
% FIM DOS CICLOS DE TREINAMENTO
%% Performance na Validação dessa repetição
    % Armazena as performances
    pr{r+1,2}= r;              pr{r+1,3}= Jx;                          pr{r+1,4}= RMSE_t;  
    pr{r+1,5}= RMSE_l;         pr{r+1,6}= Tx;                          pr{r+1,7}= NS_val; el=tl-sl;  
    pr{r+1,8}= [quantile(el',[0.10 0.25 0.50 0.75 0.90])'; mean(abs(el))]'; 
    I_500=find(Tl>=500); tl_atencao=quantile(tl,1-size(I_500,2)/size(Tl,2)); RMSE_l_atencao = sqrt(sum(sum((tl(I_500)-sl(I_500)).^2)));
    pr{r+1,9}= RMSE_l_atencao; pr{r+1,10}= 1-size(I_500,2)/size(Tl,2); pr{r+1,end} = rn;
end % for r=1:rep;
% FIM DOS CICLOS DE REPETIÇÕES
%% SELECIONAR A MELHOR REPETIÇÃO
RMSE_l_x=zeros(rep,1); NS_l_rep=zeros(rep,1);
for i2=1:rep
    RMSE_l_x(i2,1)=pr{i2+1,5}(pr{i2+1,3}); % 'RMSE_l (Jx)'
    NS_l_x(i2,1)=mean(pr{i2+1,7});         % Pq a média? isso é para ser um valor único
    RMSE_l_atencaox(i2,1)=pr{i2+1,9};
end
%% Printf da repetição escolhida (ind) e o critério
switch c
    case 0 %RMSE_l mínimo
        ind=find(RMSE_l_x==min(RMSE_l_x),1);
        fprintf('\n%s%i%s','% Escolhida a repetição ',ind,' (RMSE_l mínimo)');
    case 1 %RMSE_l mediano
        ind=sort(RMSE_l_x); ind=find(RMSE_l_x==ind(ceil(size(ind,1)/2),1),1);
        fprintf('\n%s%i%s','% Escolhida a repetição ',ind,' (RMSE_l mediano)');
    case 2 %NS_l max
        ind=find(NS_l_x==max(NS_l_x),1);
        fprintf('\n%s%i%s','% Escolhida a repetição ',ind,' (NS_l max)');
    case 3 %NS_l mediano
        ind=sort(NS_l_x); ind=find(NS_l_x==ind(ceil(size(ind,1)/2),1),1);
        fprintf('\n%s%i%s','% Escolhida a repetição ',ind,' (NS_l mediano)');
    case 4 %RMSE_l mínimo das saidas extremas: 90%-100%
        ind=find(RMSE_l_atencaox==min(RMSE_l_atencaox),1);
        fprintf('\n%s%i%s','% Escolhida a repetição ',ind,' (RMSE_l mínimo das saidas extremas: 90%-100%)');
    otherwise
end
%% Preparar a rede de saida - [rn_S,V_s,J_s,pr]=fntreinaval_jsf3(...)
if ~isempty(ind)
    rn_S=pr{ind+1,end};                         % Rede escolhida
    V_s=[pr{ind+1,4};pr{ind+1,5};pr{ind+1,6}];  % [RMSE_t (ciclo);RMSE_l (ciclo);Tx_t (ciclo)] da Rede escolhida
    J_s=pr{ind+1,3};                            % Jx da rede escolhida
    dt=etime(clock, tempo); 
    fprintf('\n%s\n%s\t%s\t%4.4f\n%s\t%s\t%4.4f\n\n','% Desvio Padrão (Rep Escolhida vs Reps)',...
    '% ','RMSE_l = ',(RMSE_l_x(ind,1)-mean(RMSE_l_x))/std(RMSE_l_x,0),'% ','NS_l   = ',(NS_l_x(ind,1)-mean(NS_l_x))/std(NS_l_x,0));  % Desvio do RMSE_l_x da rep escolhida
else
    rn_S=pr{2,end}; V_s=[pr{2,4};pr{2,5};pr{2,6}];
    J_s=pr{2,3}; dt=etime(clock, tempo); 
end
%% Informar o tempo decorrido para treinar as repetições
    if dt>60 && dt<=3600
        fprintf('\n%s\t%4.1f%s\n', '% Tempo total dispendido:', dt/60, ' minutos')
        elseif dt>3600 && dt<=86400
        fprintf('\n%s\t%4.1f%s\n', '% Tempo total dispendido:', dt/3600, ' horas')
        elseif dt<=60
        fprintf('\n%s\t%4.1f%s\n', '% Tempo total dispendido:', dt, ' segundos')
        else
        fprintf('\n%s\t%4.3f%s\n', '% Tempo total dispendido:', dt/86400, ' dias')
    end
%% Escrever relatorio de treinamento
    global nomedorelatorio; global nomes;
    if ~isempty(nomedorelatorio) 
       fid=fopen(['relatos\' nomedorelatorio], 'a');
       fprintf(fid, '\n%s\n\n','%-------------------------------------------------------------------------%');
       fprintf(fid, '%s\n%s\n','% Treinamento com Validação Cruzada', ['% Em: ' datestr(clock,7) '/' datestr(clock,5) ' ' datestr(clock,13)]);
       fprintf(fid, '%s\n%s\n', '% Descrição da rede','%            Entradas:');
       for i=1:size(nomes,1)-1
       fprintf(fid,'%s%i%s\t%s \t%s\n','%     [',i,']    ','- ',nomes(i,:));
       end
       fprintf(fid, '%s\n', '%            Saidas:');
       fprintf(fid,'%s%i%s\t%s \t%s\n','%     [',size(nomes,1),']    ','- ',nomes(size(nomes,1),:));
       fprintf(fid,'\n\n%s%i\n%s%i\n%s%i\n%s%i\n','% Numero de neuronios internos: ',rn.int.num,'% Numero de ciclos totais admitidos: ',ciclos,'% Numero de repetições do treinamento: ',rep,'% Ciclos da rede escolhida: ',pr{ind+1,3});
       if isempty(c) || c == 0
           fprintf(fid,'\n%s%i%s','% Escolhida a repetição ',ind,' (RMSE_l mínimo)');
       elseif c == 1
           fprintf(fid,'\n%s%i%s','% Escolhida a repetição ',ind,' (RMSE_l mediano)');
       elseif c == 2
           fprintf(fid,'\n%s%i%s','% Escolhida a repetição ',ind,' (NS_l max)');
       elseif c == 3
           fprintf(fid,'\n%s%i%s','% Escolhida a repetição ',ind,' (NS_l mediano)');
       elseif c == 4
           fprintf(fid,'\n%s%i%s','% Escolhida a repetição ',ind,' (RMSE_l mínimo das saidas extremas: >atencao)');
       else
       end     
        
       fprintf(fid,'\n%s\t%4.4f\n','% [(RMSE_l)-média(RMSE_l)]/std(RMSE_l) = ',(RMSE_l_x(ind,1)-mean(RMSE_l_x))/std(RMSE_l_x,0));
       fprintf(fid,'%s\t%4.4f\n\n','% [(NS_l)-média]/std(NS_l) = ',(NS_l_x(ind,1)-mean(NS_l_x))/std(NS_l_x,0)); 
       for i=1:size(RMSE_l_x,1)
       fprintf(fid,'%s%i\t%s%08.0f\t\t%s%1.6f\t%s%2.4f\n','% rep = ',i,'J = ',pr{i+1,3},'NS_l =',NS_l_x(i,1),'RMSE_l = ',RMSE_l_x(i,1));
       end
             if dt<=60
                 fprintf(fid,'\n%s \t %4.1f %s \n', '% Tempo total dispendido:', dt, ' segundos');
                 elseif dt>60 && dt<=3600
                 fprintf(fid,'\n%s \t %4.1f %s \n', '% Tempo total dispendido:', dt/60, ' minutos');
                 elseif dt>3600 && dt<=86400
                 fprintf(fid,'\n%s \t %4.1f %s \n', '% Tempo total dispendido:', dt/3600, ' horas');
                 else
                 fprintf(fid,'\n%s \t %4.1f %s \n', '% Tempo total dispendido:', dt/86400, ' dias');
             end
        fclose(fid);
    else
    end
end % function

%% Programas Auxiliares:
function [wh, bh, ws, bs]=fniniciais(nh, p, t)
% [wh, bh, ws, bs]=fniniciais(nh, p, t)
% Inicialização dos pesos sinápticos aleatoriamente
rng('shuffle'); % time=clock; rand('seed', time(end)*1000*rand)
% 'seed', 'state' and 'twister' are different RNG; The first two are flawed
pmed=mean(mean(abs(p)));
natr=size(p, 1); nsai=size(t, 1);
wh=(rand(nh, natr).*2-1)./(natr*pmed);
bh=(rand(nh, 1).*2-1)./(natr*pmed);
ws=(rand(nsai, nh).*2-1)./(nh);
bs=(rand(nsai, 1).*2-1)./(nh);
end
function [Wh, Bh, Ws, Bs]=fnatualiza(wh, bh, ws, bs, p, h, s, es, Dh, Ds, taxa, u)
% A Rotina de Atualização dos Pesos segundo o erro (é feita uma interação)
%[Wh, Bh, Ws, Bs]=fnatualiza(wh, bh, ws, bs, p, h, s, es, Dh, Ds, taxa, u)
eh=ws'*(es.*Ds(s)) ;                                    % Rumelhardt (1986) - Erro interno = erro saida * Ds(s) * Pesos de saida
Ws=ws+taxa*(es.*Ds(s))*h'; Bs=bs+taxa*(es.*Ds(s))*u';
Wh=wh+taxa*(eh.*Dh(h))*p'; 
Bh=bh+taxa*(eh.*Dh(h))*u';
end