function [rn_sai,V_sai,J_sai,metrica_rep,desvio]=fntreinaval_jsf(rn,Pt,Tt,Pl,Tl,ciclos,rep,barra)
%[rn,V,J]=fntreinaval(rn,Pt,Tt,Pl,Tl,ciclos,rep);
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
    
    
    
Er=100000;
metrica_rep.Eq_l=NaN(rep,1)';

fprintf('%s\n\n','% Em treinamento') 
tempo=clock;
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
    
    Eq_l=NaN(1,ciclos); Eq_l(1)=Eq_t(1); Ex=Eq_t(1).*10;J=1;
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
    Wh=Wh+mo*dwh ; Bh=Bh+mo*dbh; Ws=Ws+mo*dws; Bs=Bs+mo*dbs ;                   % Soma o momento de inércia aos pesos //Deveria ser a linha 71
    H=Ah(Wh*p+Bh*u); % H=1./(1+exp(-(Wh*p+Bh*u)));
    S=As(Ws*H+Bs*u); % S=1./(1+exp(-(Ws*H+Bs*u)));
    Es=t - S;                                 % Calcula o erro de saída
    Eq_t(ciclo)=sqrt(sum(sum(Es.^2))); Tx(ciclo)=taxa;                            % Armazena o Erro (Eq_t) e a Taxa (Tx) de aprendizado desse ciclo
        
        if Eq_t(ciclo) > Eq_t(ciclo-1)                                              % Se o erro aumentou, penaliza a taxa em 50%, zera o momento e treina novamente 
            taxa=max(taxa*0.5, 0.005*abs(randn)^3+0.005); Eq_t(ciclo)=Eq_t(ciclo-1); 
            mo=0; 
        else                                                                    % Se o erro diminuiu ou ficou igual, calcula-se o momento de inércia e aumenta a taxa
            dwh=Wh-wh; dbh=Bh-bh; dws=Ws-ws; dbs=Bs-bs; mo=mom;                 % Calcula-se o novo momento
            wh=Wh; bh=Bh; ws=Ws; bs=Bs; h=H; s=S; es=Es; taxa=taxa*1.1;
        end
     sl=As(ws*Ah(wh*pl+bh*ul)+bs*ul); % hl=1./(1+exp(-(wh*pl+bh*ul))); sl=1./(1+exp(-(ws*hl+bs*ul))); 
         
    el=tl-sl; Eq_l(ciclo)=sqrt(sum(sum(el.^2)));                  % Com o conjuntos de pesos calculados, é calculado o erro de saída para a amostra (pl,tl)
    if (Eq_l(ciclo-1)>Eq_l(ciclo)) && (Eq_l(ciclo)<Ex)            % Critério para selecionar os pesos sinápticos ideais
        Ex=Eq_l(ciclo);                                           % O erro precisa ter diminuido E ser o menor erro já registrado (Ex).
        wx=wh; bx=bh; wy=ws; by=bs; J=ciclo;                      % Os pesos sinápticos são armazenados; O número do ciclo é armazenado;
     
    end
    if ciclo>J+1000                                               % Critério de parada: Se já houve mais de 1000 ciclos depois do J dos pesos ideais encontrado, parar
    break
    end
    
end
    
    tl_mean=mean(tl);NS_val=1-(tl-sl)*(tl-sl)'/((tl-tl_mean)*(tl-tl_mean)');
    if J>0.9*ciclos  % Plota as metricas e informa se foi um treinamento inseguro ou não
        fprintf('%s%08.0f\t\t%s%1.6f\t%s%2.4f\t%s\n','J =',J,'NS_val = ',NS_val,'Eq_l = ',Eq_l(J),'(Inseguro!)');
    else
        fprintf('%s%08.0f\t\t%s%1.6f\t%s%2.4f\n','J =',J,'NS_val = ',NS_val,'Eq_l = ',Eq_l(J));
    end
        
    rn.int.sin=[wx bx]; rn.sai.sin=[wy by]; Eq_t(:,ciclo+1:end)=[]; Tx(:,ciclo+1:end)=[];
    Eq_l(:,ciclo+1:end)=[];V={Eq_t;Eq_l;Tx};

metrica_rep.Eq_l(r) = Eq_l(J);
metrica_rep.J(r) = J;
metrica_rep.NS_val(r) = NS_val;
if V{2,:}(J)<=Er,Er=V{2,:}(J);rn_sai=rn;V_sai=V;J_sai=J; end
 if barra==1,delete(barra_espera);else 
 end %barra_espera
end % for r=1:rep;
dt=etime(clock, tempo); 
       
       ind=find(min(metrica_rep.Eq_l)==metrica_rep.Eq_l);
       fprintf('\n%s\t%4.4f\n','% [min(Eq_l)-média]/std(Eq_l) = ',...
           (metrica_rep.Eq_l(ind)-mean(metrica_rep.Eq_l))/std(metrica_rep.Eq_l,0));
       fprintf('%s\t%4.4f\n\n','% [min(NS_l)-média]/std(NS_l) = ',...
           (metrica_rep.NS_val(ind)-mean(metrica_rep.NS_val))/std(metrica_rep.NS_val,0));    
       desvio=(metrica_rep.NS_val(ind)-mean(metrica_rep.NS_val))/std(metrica_rep.NS_val,0);
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
       fprintf(fid,'\n\n%s%i\n%s%i\n%s%i\n%s%i\n','% Numero de neuronios internos: ',rn.int.num,'% Numero de ciclos totais admitidos: ',ciclos,'% Numero de repetições do treinamento: ',rep,'% Ciclos da rede escolhida: ',metrica_rep.J(ind));
       fprintf(fid,'\n%s\t%4.4f\n','% [min(Eq_l)-média]/std(Eq_l) = ',(metrica_rep.Eq_l(ind)-mean(metrica_rep.Eq_l))/std(metrica_rep.Eq_l,0));
       fprintf(fid,'%s\t%4.4f\n\n','% [min(NS_l)-média]/std(NS_l) = ',(metrica_rep.NS_val(ind)-mean(metrica_rep.NS_val(:)))/std(metrica_rep.NS_val,0));
       for i=1:size(metrica_rep.Eq_l,2)
       fprintf(fid,'%s%i\t%s%08.0f\t\t%s%1.6f\t%s%2.4f\n','% rep = ',i,'J = ',metrica_rep.J(i),'NS_l =',metrica_rep.NS_val(i),'Eq_l = ',metrica_rep.Eq_l(i));
       end
             if dt<=60
                 fprintf(fid,'\n %s \t %4.1f %s \n', '% Tempo total dispendido:', dt, ' segundos');
                 elseif dt>60 && dt<=3600
                 fprintf(fid,'\n %s \t %4.1f %s \n', '% Tempo total dispendido:', dt/60, ' minutos');
                 elseif dt>3600 && dt<=86400
                 fprintf(fid,'\n %s \t %4.1f %s \n', '% Tempo total dispendido:', dt/3600, ' horas');
                 else
                 fprintf(fid,'\n %s \t %4.1f %s \n', '% Tempo total dispendido:', dt/86400, ' dias');
             end
        fclose(fid);
    else
    end
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
