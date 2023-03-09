function [rn_sai,V_sai,J_sai,arm_peso_metrica,desvio,ciclos_da_repeticao_escolhida]=fntreinaval_jsf2(rn,Pt,Tt,Pl,Tl,ciclos,rep,barra,mediana)
% [rn_sai,V_sai,J_sai,metrica_rep,desvio]=fntreinaval_jsf2(rn,Pt,Tt,Pl,Tl,ciclos,rep,barra)
% Semelhante a fntreinaval_jsf, mas essa pega a repetição de Eq_l mediano
%
% Validação Cruzada embutida; A série de dados é repartida em Treinamento, Validação e Verificação
%
% Entradas:
%   rn   Estrutura da Rede Neural
%   Pt   Pattern entrada para o Treinamento
%   Tt   Target saida para o Treinamento 
%   Pl   Pattern entrada para a Validacao
%   Tl   Target saida para a Validacao 
%   rep  Número de repetições para buscar minimos relativos
%
% Saidas: 
%   rn_sai        Estrutura final da Rede Neural
%   V_sai         Eq_t, Ea, Tx:
%                   Célula com os vetores {Eq_t, Ev e Tx}, sendo, respectivamente,
%                   os erros quadráticos do treinamento, da validação, e as taxas 
%                   de aprendizado durante o treinamento do modelo adotado.
%   J_sai           Ciclo de Parada - Validação Cruzada
%   metrica_rep     Ev de cada repeitação
%
%
% Treinamento de rede neural de uma única camada interna, com taxa heuristica
% Juliano Finck
% Ultima atualização: 07/05/2019

% Extração de informações da rn e transformações das entradas:
    Ah=eval(rn.int.fat); Dh=eval(rn.int.der); As=eval(rn.sai.fat); Ds=eval(rn.sai.der); nh=rn.int.num;  % Funções de ativação (Ah - Ativação hidden layer; Ds - Derivada saida)
    eesc=eval(rn.ent.esc); epar=rn.ent.par; sesc=eval(rn.sai.esc); spar=rn.sai.par;                     % Funções de Escalonamento e Parâmetros de Escalolamento
    u=ones(1, size(Pt, 2));p=eesc(Pt,epar,u);t=sesc(Tt,spar,u);                                         % Escalonamento dos registros de entrada e saida (Pt e Tt)
    ul=ones(1,size(Pl,2));pl=eesc(Pl,epar,ul);tl=sesc(Tl,spar,ul);                                      % Escalonamento dos registros de entrada e saida (Pl e Tl)
    
fprintf('%s\n\n','% Em treinamento') 
tempo=clock;
arm_peso_metrica=cell(rep,1); %Armazena pesos sinápticos e métricas da repetição
% arm_peso_metrica{rep,1}
% arm_peso_metrica{rep,1}{1}=Ex
% arm_peso_metrica{rep,1}{2}=wx
% arm_peso_metrica{rep,1}{3}=bx
% arm_peso_metrica{rep,1}{4}=wy
% arm_peso_metrica{rep,1}{5}=by
% arm_peso_metrica{rep,1}{6}=J
% arm_peso_metrica{rep,1}{7}=Eq_l
% arm_peso_metrica{rep,1}{8}=NS_l

for r=1:rep

    fprintf('%s %i\t','% rep =',r);
% Pré-Treinamento:
    [wh, bh, ws, bs]=fniniciais(nh, p, t);          % Iniciar pesos aleatórios
    h=Ah(wh*p+bh*u);                                % h=1./(1+exp(-(wh*p+bh*u)));        % Sinal para camada interna
    s=As(ws*h+bs*u);                                % s=1./(1+exp(-(ws*h+bs*u)));        % Sinal para camada de saida
    es=t-s;                                         % Erro inicial 
    Eq_t=NaN(1,ciclos); Tx=NaN(1,ciclos);                                                                   % Prealocar as variáveis
    Eq_t(1)=sqrt(sum(sum(es.^2))); taxa=0.05; Tx(1)=taxa; mom=0.96; mo=mom; ciclo=1;                        % Define taxa e momento inicial
    dwh=0.*wh ; dbh=0.*bh ; dws=0.*ws ; dbs=0.*bs ;                                                         % Começa zerando todos os passos e aproveitando as dimensões
    
    Eq_l=NaN(1,ciclos); Eq_l(1)=Eq_t(1); arm_peso_metrica{r,1}{1}=Eq_t(1).*10;J=1;
%% Barra de Espera
if barra==1
barra_espera=waitbar(0,'Iterando...');
set(barra_espera,'Name',['Progresso - (Repetição ' num2str(r) '/' num2str(rep) ')']);
else
end

%% Começam os Ciclos de Treinamento
while (ciclo < ciclos), ciclo=ciclo+1;
    %% Atualização da Barra de Espera sempre que ciclo é múltiplo de 1% do ciclos
    if barra==1
        if (mod(ciclo,0.01*ciclos)==0)                                                      
        waitbar(ciclo/ciclos,barra_espera,['Iterando...   ' num2str(ciclo/(0.01*ciclos)) '% dos ciclos máximos']);
        end
    else
    end
    %% RETROPROPAGAÇÃO PURA
    [Wh, Bh, Ws, Bs]= fnatualiza(wh, bh, ws, bs, p, h, s, es, Dh, Ds, taxa, u); 
    %% TAXA CONJUGADA (MOMENTO+HEURISTICA)
    Wh=Wh+mo*dwh ; Bh=Bh+mo*dbh; Ws=Ws+mo*dws; Bs=Bs+mo*dbs ;                       % Soma o momento de inércia aos pesos
    H=Ah(Wh*p+Bh*u);                                                                % H=1./(1+exp(-(Wh*p+Bh*u)));
    S=As(Ws*H+Bs*u);                                                                % S=1./(1+exp(-(Ws*H+Bs*u)));
    Es=t - S;                                                                       % Calcula o erro de saída
    Eq_t(ciclo)=sqrt(sum(sum(Es.^2))); Tx(ciclo)=taxa;                              % Armazena o Erro (Eq_t) e a Taxa (Tx) de aprendizado desse ciclo
        
        if Eq_t(ciclo) > Eq_t(ciclo-1)                                              % Se o erro aumentou, penaliza a taxa em 50%, zera o momento e treina novamente 
            taxa=max(taxa*0.5, 0.005*abs(randn)^3+0.005); Eq_t(ciclo)=Eq_t(ciclo-1); 
            mo=0; 
        else                                                                        % Se o erro diminuiu ou ficou igual, calcula-se o momento de inércia e aumenta a taxa
            dwh=Wh-wh; dbh=Bh-bh; dws=Ws-ws; dbs=Bs-bs; mo=mom;                     % Calcula-se o novo momento
            wh=Wh; bh=Bh; ws=Ws; bs=Bs; h=H; s=S; es=Es; taxa=taxa*1.1;
        end
     sl=As(ws*Ah(wh*pl+bh*ul)+bs*ul);                                               % hl=1./(1+exp(-(wh*pl+bh*ul))); sl=1./(1+exp(-(ws*hl+bs*ul))); 
         
    el=tl-sl; Eq_l(ciclo)=sqrt(sum(sum(el.^2)));                                    % Com o conjuntos de pesos calculados, é calculado o erro de saída para a amostra (pl,tl)
    if (Eq_l(ciclo-1)>Eq_l(ciclo)) && (Eq_l(ciclo)<arm_peso_metrica{r,1}{1})      % Critério para selecionar os pesos sinápticos ideais
        J=ciclo;
        arm_peso_metrica{r,1}{1}=Eq_l(ciclo);                                     % O erro precisa ter diminuido E ser o menor erro já registrado (Ex).
        arm_peso_metrica{r,1}{2}=wh;                                              % Os pesos sinápticos são armazenados; O número do ciclo é armazenado;
        arm_peso_metrica{r,1}{3}=bh; 
        arm_peso_metrica{r,1}{4}=ws; 
        arm_peso_metrica{r,1}{5}=bs; 
        arm_peso_metrica{r,1}{6}=J;                                        
        
    end
    if ciclo>J+1000                                                                 % Critério de parada: Se fazem mais de 1000 ciclos que o J (último ciclo de Eq_l mínimo) não é atualizado, então parar
    break
    end
    
end
    
    % Escreve as métricas da repetição e informa se houve treinamento seguro
    % [Parou em número de ciclos menor que 90% dos ciclos máximos.
    tl_mean=mean(tl);NS_val=1-(tl-sl)*(tl-sl)'/((tl-tl_mean)*(tl-tl_mean)');
    if J>0.9*ciclos                                                                 
        fprintf('%s%08.0f\t\t%s%1.6f\t%s%2.4f\t%s\n','J =',J,'NS_val = ',NS_val,'Eq_l = ',Eq_l(J),'(Inseguro!)');
    else
        fprintf('%s%08.0f\t\t%s%1.6f\t%s%2.4f\n','J =',J,'NS_val = ',NS_val,'Eq_l = ',Eq_l(J));
    end
    
    % Limpa excesso de variáveis pré-alocadas
    Eq_t(:,ciclo+1:end)=[]; Tx(:,ciclo+1:end)=[];
    Eq_l(:,ciclo+1:end)=[];
    
    % Salva os ciclos e os erros
    V={Eq_t;Eq_l;Tx};
    
    % Armazena as performances
    arm_peso_metrica{r,1}{6} = J;
    arm_peso_metrica{r,1}{7}=Eq_l;
    arm_peso_metrica{r,1}{8}=NS_val;
    arm_peso_metrica{r,1}{9}=V;
    
 if barra==1,delete(barra_espera);else 
 end %barra_espera
end % for r=1:rep;

% Encontrar qual o indice da repetição que teve performance Eq_l mediana
Eq_l_rep=zeros(rep,1);
NS_l_rep=zeros(rep,1);
for i2=1:rep
    Eq_l_rep(i2,1)=arm_peso_metrica{i2,1}{7}(end);
    NS_l_rep(i2,1)=arm_peso_metrica{i2,1}{8}(end);
end
if mediana==1
    ind=sort(Eq_l_rep);ind=find(Eq_l_rep==ind(ceil(size(ind,1)/2),1));% 
elseif mediana==0
    ind=find(Eq_l_rep==min(Eq_l_rep));
else
    error('mediana = 1 para pegar a repetição mediana OU mediana = 0 para pegar a repetição minima');
end

% Preparar a rede de saida
    rn.int.sin=[arm_peso_metrica{ind,1}{2} arm_peso_metrica{ind,1}{3}]; rn.sai.sin=[arm_peso_metrica{ind,1}{4} arm_peso_metrica{ind,1}{5}]; 
    rn_sai=rn;
    V_sai=arm_peso_metrica{ind,1}{9};
    J_sai=arm_peso_metrica{ind,1}{6}; 



dt=etime(clock, tempo); 
       if mediana ==1
           fprintf('\n%s%i%s','% Escolhida a repetição ',ind,' (Mediana)');
       elseif mediana==0
           fprintf('\n%s%i%s','% Escolhida a repetição ',ind,' (Mínima)');
       else
           error('mediana = 1 para pegar a repetição mediana OU mediana = 0 para pegar a repetição minima');
       end

       fprintf('\n%s\t%4.4f\n','% [(Eq_l)-média(Eq_l)]/std(Eq_l) = ',...
           (Eq_l_rep(ind,1)-mean(Eq_l_rep))/std(Eq_l_rep,0));
       fprintf('%s\t%4.4f\n\n','% [(NS_l)-média]/std(NS_l) = ',...
           (NS_l_rep(ind,1)-mean(NS_l_rep))/std(NS_l_rep,0));    
       desvio=(NS_l_rep(ind,1)-mean(NS_l_rep))/std(NS_l_rep,0);
    if dt<=60
        fprintf('\n%s\t%4.1f%s\n', '% Tempo total dispendido:', dt, ' segundos')
        elseif dt>60 && dt<=3600
        fprintf('\n%s\t%4.1f%s\n', '% Tempo total dispendido:', dt/60, ' minutos')
        elseif dt>3600 && dt<=86400
        fprintf('\n%s\t%4.1f%s\n', '% Tempo total dispendido:', dt/3600, ' horas')
        else
        fprintf('\n%s\t%4.1f%s\n', '% Tempo total dispendido:', dt/86400, ' dias')
    end

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
       fprintf(fid,'\n\n%s%i\n%s%i\n%s%i\n%s%i\n','% Numero de neuronios internos: ',rn.int.num,'% Numero de ciclos totais admitidos: ',ciclos,'% Numero de repetições do treinamento: ',rep,'% Ciclos da rede escolhida: ',arm_peso_metrica{ind,1}{6});
       if mediana ==1
           fprintf(fid,'\n%s%i%s','% Escolhida a repetição ',ind,' (Mediana)');
       elseif mediana==0
           fprintf(fid,'\n%s%i%s','% Escolhida a repetição ',ind,' (Mínima)');
       else
           error('mediana = 1 para pegar a repetição mediana OU mediana = 0 para pegar a repetição minima');
       end
       fprintf(fid,'\n%s\t%4.4f\n','% [min(Eq_l)-média]/std(Eq_l) = ',(Eq_l_rep(ind,1)-mean(Eq_l_rep))/std(Eq_l_rep,0));
       fprintf(fid,'%s\t%4.4f\n\n','% [min(NS_l)-média]/std(NS_l) = ',(NS_l_rep(ind,1)-mean(NS_l_rep))/std(NS_l_rep,0));
       for i=1:size(Eq_l_rep,1)
       fprintf(fid,'%s%i\t%s%08.0f\t\t%s%1.6f\t%s%2.4f\n','% rep = ',i,'J = ',arm_peso_metrica{i,1}{6},'NS_l =',NS_l_rep(i,1),'Eq_l = ',Eq_l_rep(i,1));
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
    % Últimas operações do "arm_peso_metrica" 
    % botar nome
    arm_peso_metrica{size(arm_peso_metrica,1)+1,1}={'Ex','wx','bx','wy','by','J','Eq_l','NS_l','Eq_l;Eq_l;Tx'};
    
    ciclos_da_repeticao_escolhida=arm_peso_metrica{ind,1}{6};
    
end
%---------------------------------%
% Programas Auxiliares:

% Inicialização dos pesos sinápticos aleatoriamente
function [wh, bh, ws, bs]=fniniciais(nh, p, t)
time=clock; rand('seed', time(end)*1000*rand);
pmed=mean(mean(abs(p)));
natr=size(p, 1); nsai=size(t, 1);
wh=(rand(nh, natr).*2-1)./(natr*pmed);
bh=(rand(nh, 1).*2-1)./(natr*pmed);
ws=(rand(nsai, nh).*2-1)./(nh);
bs=(rand(nsai, 1).*2-1)./(nh);
end

% A Rotina de Atualização dos Pesos segundo o erro (é feita uma interação)
function [Wh, Bh, Ws, Bs]=fnatualiza(wh, bh, ws, bs, p, h, s, es, Dh, Ds, taxa, u)
%[Wh, Bh, Ws, Bs]=fnatualiza(wh, bh, ws, bs, p, h, s, es, Dh, Ds, taxa, u)
eh=ws'*(es.*Ds(s)) ;                                    % Rumelhardt (1986) - Erro interno = erro saida * Ds(s) * Pesos de saida
Ws=ws+taxa*(es.*Ds(s))*h'; Bs=bs+taxa*(es.*Ds(s))*u';
Wh=wh+taxa*(eh.*Dh(h))*p'; 
Bh=bh+taxa*(eh.*Dh(h))*u';
end
