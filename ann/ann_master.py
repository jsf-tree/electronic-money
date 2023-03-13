"""
% ESPECIFICAÇÃO, TREINAMENTO E AVALIAÇÃO
epar=[Xe(:, 1) Xe(:, 2)-Xe(:, 1)]; spar=[Xs(:, 1) Xs(:, 2)-Xs(:, 1)];
rn=fnuconfigurar([size(Pt, 1) nni 1], enom, [], epar, [], [], snom,[], [], [], [], spar);
%% Treinamento do modelo:
for rep=REPS
    [rn, ~, J, dtrep]=fntreinaval_jsf3(rn,Pt,Tt,Pl,Tl,ciclos,rep,c);
    if sum(cell2mat(dtrep(2:end,7))>0.1)>0, break, else, end
end
%% Testes absolutos de desempenho:
[St] = fnuexecutar(rn, Pt); fmudesempenho_jsf(Tt, St, 0, 1, snom);
[Sl] = fnuexecutar(rn, Pl); [NS, Mea, Mpea, Pbias, Me, E10, E25, E50, E75, E90, n]=fmudesempenho_jsf(Tl, Sl, 0, 1, snom);
[Sv] = fnuexecutar(rn, Pv); fmudesempenho_jsf(Tv, Sv, 0, 1, snom);


THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

licença -> GNU, BSD, ou MIT
"""
import numpy as np
from typing import List, Callable, Dict, Tuple, Set
import time
import inspect


def create_ann(
        struct: List[int],
        enom: List[str] = None,
        eesc: Callable = None,
        epar: List[float] = None,
        ifat: Callable = None,
        ider: Callable = None,
        snom: List[str] = None,
        sfat: Callable = None,
        srec: Callable = None,
        spar: List[float] = None,
        sder: Callable = None,
        sesc: Callable = None,
):
    """
     Create 1-hidden layer ANN structure. Default scaling functions are
       linear and activation functions unipolar sigmoids.
     INPUTS:
       struct  ANN's architecture vector [nº inputs, nº hidden, nº outputs]
       enom    Input names. Nonexistent => 'X1', ..., 'Xn'.
       eesc    Scaling function handle (as char).
       epar    Parameters for input scaling function. Nonexistent => [Min, Max].
       ifat    Hidden activation function handle, string form, hidden activation function
                     Ex: ifat='@(n) 1./(1+exp(-n))';
       ider    Derivative of hidden activation function handle (as char)
       snom    Input names. Nonexistent => 'Y'.
       sfat    Output activation function handle (as char) Function Handle, string form, output activation function
       sder    Derivative of output activation function handle (as char)
       sesc    Scaling function handle (as char).
       srec    Descaling function handle (as char).
       spar    Parameters for output scaling function. Nonexistent => [Min, Max].
     OUTPUT:
       rn   One hidden layer ANN structure, with following fields:
               .ent: num(nº input nodes), nom(input names),
                   esc(input scaling function), par(corresponding parameters),
               .int: num(nº hidden neurons), sin(hidden weights),
                   fat(activation function), der(derivative activation function),
               .sai: num(nº output neurons), nom(output names), sin(output weights),
                   fat(activation function), der(derivative activation function),
                   esc(scaling function, rec(descaling function), par(corresponding parameters).

       Copyright: None, Open Source!
       Juliano Finck - Ultima atualização: 25/08/2020
    """

    # Architecture vector - I had to check it was a line-vector
    if len(struct) != 3: raise ValueError('Architecture vector is not 1 x 3')

    # Function handles
    # todo Transpose with .T could be wrong
    if eesc is None: eesc = lambda v, par, u: (v - par[:, 0] * u) / ((par[:, 1] - par[:, 0]) * u).T  # Transpose
    if ifat is None: ifat = lambda n: 1. / (1 + np.exp(-n)).T  # Transpose
    if ider is None: ider = lambda a: np.maximum(a * (1 - a), 0.01).T  # Transpose
    if sfat is None: sfat = lambda n: 1. / (1 + np.exp(-n)).T  # Transpose
    if sder is None: sder = lambda a: np.maximum(a * (1 - a), 0.01).T  # Transpose
    if sesc is None: sesc = lambda v, par, u: (v - par[:, 0] * u) / (par[:, 1] - par[:, 0]) * u.T  # Transpose
    if srec is None: srec = lambda s, par, u: ((par[:, 2] - (par[:, 1]) * u) * s + par[:, 1] * u).T  # Transpose

    afuncts = {0: 'eesc', 1: 'ifat', 2: 'ider', 3: 'sfat', 4: 'sder', 5: 'sesc', 6: 'srec', }
    for i, afunct in enumerate([eesc, ifat, ider, sfat, sder, sesc, srec, ]):
        if not callable(afunct):
            raise ValueError(f'{afuncts[i]} is not a function')

    if enom is None:
        enom = np.array([f'X{_ + 1}' for _ in range(struct[0])], dtype='U10')
    else:
        if len(enom) != struct[0]:
            raise ValueError(f"Dimensions don't match!\nsize(enom,1)={len(enom)} struct(1)={struct[0]}")

    if snom is None:
        snom = np.array([f'Y{_ + 1}' for _ in range(struct[0])], dtype='U10')
    else:
        if len(snom) != struct[2]:
            raise ValueError(f"Dimensions don't match!\nsize(snom,1)={len(snom)} struct(3)={struct[0]}")

    rn = {}

    return rn


def fntreinaval_jsf3(rn, Pt, Tt, Pl, Tl, ciclos, rep, c) -> Dict:
    """
      [rn_S,V_s,J_s,pr,desvio]=fntreinaval_jsf3(rn,Pt,Tt,Pl,Tl,ciclos,rep,c)
     Treinamento de rede neural de uma única camada interna, com taxa heuristica e validação Cruzada embutida

     Entradas:
       rn      Estrutura da Rede Neural (composta de rn.ent rn.int rn.sai)
       Pt      Pattern entrada para o Treinamento
       Tt      Target saida para o Treinamento
       Pl      Pattern entrada para a Validacao
       Tl      Target saida para a Validacao
       rep     Número de repetições para buscar minimos relativos
       c       Critério adotado para seleção da melhor repetição
               0 - Mínimo dos erros quadráticos da validação
               1 - Mediana dos erros quadráticos da validação
               2 - Máximo NS da validação
               3 - Mediana dos Ns da validação
               4 - Mínimo dos erros quadráticos da validação correspondentes aos 10% maiores valores de saida
     Saidas:
       rn_S        Estrutura final da Rede Neural
       V_s         RMSE_t, Ea, Tx:
                       Célula com os vetores {RMSE_t, Ev e Tx}, sendo,
                       respectivamente, os erros quadráticos do treinamento,
                       da validação, e as taxas de aprendizado durante o
                       treinamento do modelo adotado.
       J_s         Ciclo de Parada - Validação Cruzada
       metrica_rep Ev de cada repeitação
       pr          Performance das repetições
                       Para cada rep (linha),
                             Ciclo de Parada     - 'Jx'
                             RMSE_t(ciclo)       - 'RMSE_t (ciclo)'
                             RMSE_l (ciclo)      - 'RMSE_l (ciclo)'
                             Tx_t   (ciclo)      - 'Tx_t   (ciclo)'
                             NS_l (Jx)           - 'NS_l (Jx)'
                             DistErro Validacao  - 'E10 E25 E50 E75 E90 MEA',
                             RMSE_l_>atencao     - 'RMSE_l_atencao'
                             Quantil_l_>atencao  - 'Quantil_l_>atencao',
                             Estrutura rn        - 'rn'

     Juliano Finck Ultima atualização: 28/04/2020
     """

    def fniniciais(nh, p, t) -> List[np.ndarray]:
        """
        Inicialização dos pesos sinápticos aleatoriamente

        Args:
        nh (int): número de neurônios na camada oculta
        p (numpy.ndarray): matriz de entrada
        t (numpy.ndarray): matriz de saída desejada

        Returns:
        wh (numpy.ndarray): matriz de pesos entre a camada de entrada e a camada oculta
        bh (numpy.ndarray): vetor de bias da camada oculta
        ws (numpy.ndarray): matriz de pesos entre a camada oculta e a camada de saída
        bs (numpy.ndarray): vetor de bias da camada de saída
        """
        # Inicializar pesos sinápticos
        np.random.seed()
        pmed = np.mean(np.abs(p))
        natr, nvar = p.shape
        nsai, _ = t.shape
        wh = (np.random.rand(nh, natr) * 2 - 1) / (nvar * pmed)
        bh = (np.random.rand(nh, 1) * 2 - 1) / (nvar * pmed)
        ws = (np.random.rand(nsai, nh) * 2 - 1) / nh
        bs = (np.random.rand(nsai, 1) * 2 - 1) / nh
        return wh, bh, ws, bs

    def fnatualiza(wh, bh, ws, bs, p, h, s, es, Dh, Ds, taxa, u):
        """
        A Rotina de Atualização dos Pesos segundo o erro (é feita uma interação)
        [Wh, Bh, Ws, Bs]=fnatualiza(wh, bh, ws, bs, p, h, s, es, Dh, Ds, taxa, u)
        """
        eh = ws.T @ (es * Ds(s))  # Rumelhardt (1986) - Erro interno = erro saida * Ds(s) * Pesos de saida
        Ws = ws + taxa * ((es * Ds(s)) @ h.T)
        Bs = bs + taxa * ((es * Ds(s)) @ u.T)
        Wh = wh + taxa * ((eh * Dh(h)) @ p.T)
        Bh = bh + taxa * ((eh * Dh(h)) @ u.T)
        return Wh, Bh, Ws, Bs

    # Extração de informações da estrutura da RNA (rn):
    # Funções de Ativação e suas Derivadas
    Ah = rn.hidden.fat  # Leitura da função de ativação da camada interna (armazenada em string em forma de ponteiro) "@(n)1./(1+exp(-n))"
    Dh = rn.hidden.der  # Leitura da derivada da função de ativação da camada interna (armazenada em string em forma de ponteiro) "@(a) max(a.*(1-a), 0.01)"¹
    As = rn.output.fat  # Leitura da função de ativação da camada de saida (armazenada em string em forma de ponteiro) "@(n)1./(1+exp(-n))"
    Ds = rn.output.der  # Leitura da derivada da função de ativação da camada de saida (armazenada em string em forma de ponteiro) "@(a) max(a.*(1-a), 0.01)"¹
    # A é Ativação; D é Derivada; h é hidden layer (camada interna); s é cama de saída)
    # ¹Nota: às vezes a derivada retorna muito muito baixa, por isso é adicionado o minimo de 0.01

    nh = rn.hidden.num  # Número de neurônios internos

    # Funções de Escalonamento e Parâmetros de Escalonamento
    eesc = rn.input.esc  # Função de escalonamento para entrada (armazenada em string em forma de ponteiro) "@(v, par, u) (v-par(:, 1)*u)./(par(:, 2)*u)"
    epar = rn.input.par  # Parâmetros utilizados para cada nó de entrada pela função de escalonamento de entrada
    sesc = rn.output.esc  # Função de escalonamento para saída (armazenada em string em forma de ponteiro) "@(v, par, u) (v-par(:, 1)*u)./(par(:, 2)*u)"
    spar = rn.output.par  # Parâmetros utilizados para cada nó de saída pela função de escalonamento de saída

    # Escalonar os registros de entrada e saída para treinamento (Pt, Tt) e validação-cruzada (Pl, Tl)

    u = np.ones([1, Pt.shape[
        1]])  # Inicializar um vetor-base para multiplicar os parâmetros de escalonamento, serão usados nas funções de escalonamento
    ul = np.ones([1, Pl.shape[
        1]])  # Inicializar um vetor-base para multiplicar os parâmetros de escalonamento, serão usados nas funções de escalonamento
    # todo se for unidimensional, adicionar dimensão para operações
    if len(Tt.shape) == 1:
        Tt = Tt.reshape(-1, 1).T
    if len(epar.shape) == 1:
        epar = epar.reshape(-1, 1).T
    if len(Tl.shape) == 1:
        Tl = Tl.reshape(-1, 1).T
    if len(spar.shape) == 1:
        spar = spar.reshape(-1, 1).T

    p = eesc(Pt, epar)  # Entradas dos registros de treinamento (Padrões)
    t = sesc(Tt, spar)  # Saída dos registros de treinamento (Alvos)

    pl = eesc(Pl, epar)  # Entradas dos registros de validação (Padrões)
    tl = sesc(Tl, spar)  # Saída dos registros de validação (Alvos)
    # (P é o padrão de entrada; T é o alvo de saída da rede; t é treinamento; l é validação cruzada)

    # Pronto para inicializar o treinamento
    print('\n% Em treinamento\n')
    tempo = time.perf_counter()  # Declara início do treinamento no console e armazena tinicial
    c = 0 if c is None else c  # Critério clássico do grupo se C é empty

    pr = {'rep': [], 'Jx': [], 'RMSE_t (ciclo)': [], 'RMSE_l (ciclo)': [], 'Tx_t (ciclo)': [], 'NS_l (Jx)': [],
          'E10 E25 E50 E75 E90 MEA': [], 'RMSE_l_>atencao': [], 'Quantil_l_>atencao': [], 'rn': [], }

    for r in range(rep):
        print(f'Repetition:{r + 1:>3} | ', end='')  # Declara início do treinamento da respectiva repetição
        # Pré-Treinamento:
        # Iniciar pesos sinápticos aleatórios
        wh, bh, ws, bs = fniniciais(nh, p,
                                    t)  # (Neurônios Internos X Tamanho da Entrada X Tamanho da Saída -> pesos sinápticos aleatórios)

        # Propagar o sinal de entrada (p - padrão) até a saída (s), passando pela camada interna (h)
        h = Ah(wh @ p + bh @ u).T  # h=1./(1+exp(-(wh*p+bh*u)));        % Sinal para camada interna
        s = As(ws @ h + bs @ u).T  # s=1./(1+exp(-(ws*h+bs*u)));        % Sinal para camada de saida

        # Erro calculado para primeira iteração
        es = t - s
        RMSE_t, Tx = (np.zeros(ciclos), np.zeros(ciclos))
        RMSE_t[0] = np.sqrt(np.sum(np.square(es)))  # Guarda o erro quadrático para o primeiro ciclo
        taxa, mom, ciclo = (0.05, 0.96, 0)  # Define taxa de treinamento e o momento inicial
        Tx[0], mo = (taxa, mom)
        dwh = np.zeros_like(wh)
        dbh = np.zeros_like(bh)
        dws = np.zeros_like(ws)
        dbs = np.zeros_like(bs)  # Inicia vetores para variação dos pesos sinápticos (Todos começam zerados)

        RMSE_l = np.zeros(ciclos)
        RMSE_l[0] = RMSE_t[0]
        RMSE_lx = RMSE_t[
                      0] * 10  # Incializar parâmetros de ótimo para caso o treinamento estagne logo no início (caso raro)
        Jx = 1
        whx = wh
        bhx = bh
        wsx = ws
        bsx = bs
        ciclo += 1

        # Iniciar os ciclos de treinamento
        while ciclo < ciclos and ciclo <= Jx + 1000:
            # Parar se Nº max ciclos ou tolerância de ciclos piores atingido.
            # RETROPROPAGAÇÃO PURA
            Wh, Bh, Ws, Bs = fnatualiza(wh, bh, ws, bs, p, h, s, es, Dh, Ds, taxa,
                                        u)  # Retropropaga o erro, atualizando os novos pesos sinápticos

            # TAXA CONJUGADA (MOMENTO+HEURISTICA)
            # Adiciona o momento de inércia aos pesos
            Wh += mo * dwh
            Bh += mo * dbh
            Ws += mo * dws
            Bs += mo * dbs

            # Feedforward com novos pesos
            H = Ah(Wh @ p + Bh @ u).T
            S = As(Ws @ H + Bs @ u).T

            # Calcula o erro de saída
            Es = t - S

            # Armazena o Erro (RMSE_t) e a Taxa (Tx) de aprendizado desse ciclo
            RMSE_t[ciclo] = np.sqrt(np.sum(np.square(Es)))
            Tx[ciclo] = taxa

            # AVALIAR ITERAÇÃO - Foi uma iteração de sucesso para o treinamento?
            if RMSE_t[ciclo] > RMSE_t[ciclo - 1]:
                # PIOROU! Se o erro aumentou, penaliza a taxa em 50%, zera o momento e treina novamente
                taxa = max(taxa * 0.5, 0.005 * abs(np.random.normal()) ** 3 + 0.005)
                RMSE_t[ciclo] = RMSE_t[ciclo - 1]
                mo = 0
            else:
                # MELHOROU! Se o erro diminuiu ou ficou igual, calcula-se o momento de inércia e aumenta a taxa
                dwh = Wh - wh
                dbh = Bh - bh
                dws = Ws - ws
                dbs = Bs - bs
                mo = mom
                # Calcula-se o passo do momento E reinicializa o momento com mom (0.96) - Isso quer dizer que haverá uma tendência dos pesos continuarem na mesma direção anterior
                wh = Wh
                bh = Bh
                ws = Ws
                bs = Bs
                h = H
                s = S
                es = Es
                taxa *= 1.1

            # VALIDAÇÃO CRUZADA - Será que a capacidade de generalização está sendo comprometida?
            hl = Ah(wh @ pl + bh @ ul).T
            sl = As(ws @ hl + bs @ ul).T
            el = tl - sl
            RMSE_l[ciclo] = np.sqrt(np.sum(np.square(el)))

            # AVALIAR ITERAÇÃO - Foi um ciclo bom para validação?
            if RMSE_l[ciclo - 1] > RMSE_l[ciclo] and RMSE_l[ciclo] < RMSE_lx:
                # Se (1) RMSE_l diminuiu E 2. RMSE_l nunca foi tão baixo,
                Jx = ciclo
                RMSE_lx = RMSE_l[Jx]
                whx = wh
                bhx = bh
                wsx = ws
                bsx = bs
            ciclo += 1

        # Alocar os pesos encontrados na rede e limpar excesso de variáveis pré-alocadas
        rn.hidden.sin = [whx, bhx]
        rn.output.sin = [wsx, bsx]
        RMSE_t = RMSE_t[:ciclo]
        Tx = Tx[:ciclo]
        RMSE_l = RMSE_l[:ciclo]
        # Declaração do Ciclo de Parada pela Validação Cruzada
        # Feedforward com wx da validacão cruzada
        hl = Ah(whx @ pl + bhx @ ul).T
        sl = As(wsx @ hl + bsx @ ul).T  # Não usar fnexecutar porque sl ficará escalonado
        tl_mean = np.mean(tl)
        el = tl - sl
        NS_val = 1 - np.sum(el ** 2) / ((tl - tl_mean) @ (tl - tl_mean).T)  # Calcular NS_val
        # Faltaram ciclos? Performance de validação no console.
        print(f'J={Jx:>8} | NS_val={float(NS_val):.6f} | RMSE_val={RMSE_lx:>.6f} ', end='\t')
        if Jx > ciclos - 1000:
            print('(Inseguro!)')
        else:
            print('')
        # FIM DOS CICLOS DE TREINAMENTO
        # Performance na Validação dessa repetição
        # Armazena as performances
        pr['rep'].append(r)
        pr['Jx'].append(Jx)
        pr['RMSE_t (ciclo)'].append(RMSE_t)
        pr['RMSE_l (ciclo)'].append(RMSE_l)
        pr['Tx_t (ciclo)'].append(Tx)
        pr['NS_l (Jx)'].append(NS_val)
        el = tl - sl
        pr['E10 E25 E50 E75 E90 MEA'] = np.concatenate(
            (np.quantile(el, [0.10, 0.25, 0.50, 0.75, 0.90]), [np.mean(np.abs(el))]))
        I_500 = np.where(Tl >= 500)[0]
        tl_atencao = np.quantile(tl, 1 - I_500.size / Tl.size)
        RMSE_l_atencao = np.sqrt(np.sum(np.sum((tl[I_500] - sl[I_500]) ** 2)))
        pr['RMSE_l_>atencao'].append(RMSE_l_atencao)
        pr['Quantil_l_>atencao'].append(1 - I_500.size / Tl.size)
        pr['rn'].append(rn)

    # SELECIONAR A MELHOR REPETIÇÃO
    RMSE_l_x = np.zeros((rep, 1))
    NS_l_rep = np.zeros((rep, 1))
    NS_l_x = np.zeros((rep, 1))
    RMSE_l_atencaox = np.zeros((rep, 1))

    for i2 in range(rep):
        RMSE_l_x[i2] = pr['RMSE_l (ciclo)'][i2][pr['Jx'][i2]]  # 'RMSE_l (Jx)'
        NS_l_x[i2] = np.mean(pr['NS_l (Jx)'][i2])  # todo Pq a média? isso é para ser um valor único (PORQUE É UM VETOR)
        RMSE_l_atencaox[i2] = pr['RMSE_l_>atencao'][i2]

    # Print da repetição escolhida (ind) e o critério
    if c == 0:  # RMSE_l mínimo
        ind = np.argmin(RMSE_l_x)
        print(f'# Chosen repetition: {ind} (RMSE_l mínimo)')
    elif c == 1:  # RMSE_l mediano
        ind = np.where(RMSE_l_x == np.median(np.sort(RMSE_l_x)))[0]
        print(f'# Chosen repetition: {ind} (RMSE_l mediano)')
    elif c == 2:  # NS_l max
        ind = np.where(NS_l_x == np.max(NS_l_x))[0][0]
        print(f'# Chosen repetition: {ind} (NS_l max)')
    elif c == 3:  # NS_l mediano
        ind = np.where(NS_l_x == np.median(np.sort(NS_l_x)))[0][0]
        print(f'# Chosen repetition: {ind} (NS_l mediano)')
    elif c == 4:  # RMSE_l mínimo das saidas extremas: 90%-100%
        ind = np.where(RMSE_l_atencaox == np.min(RMSE_l_atencaox))[0][0]
        print(f'# Chosen repetition: {ind} (RMSE_l mínimo das saidas extremas: 90%-100%)')

    # Preparar a rede de saida - [rn_S,V_s,J_s,pr]=fntreinaval_jsf3(...)
    rn_S = pr['rn'][ind]  # Rede escolhida
    V_s = [pr['RMSE_t (ciclo)'][ind], pr['Tx_t (ciclo)'][ind], pr['NS_l (Jx)'][ind]]
    J_s = pr['Jx'][ind]

    print(f'\n# Desvio Padrão (Rep Escolhida vs Reps)'
          f'\n#\tRMSE_l\t{float((RMSE_l_x[ind] - np.mean(RMSE_l_x)) / np.std(RMSE_l_x, ddof=0)):.4f}'
          f'\n#\tNS_l  \t{float((NS_l_x[ind] - np.mean(NS_l_x)) / np.std(NS_l_x, ddof=0)):.4f}', end='\n\n')
    dt = time.perf_counter() - tempo

    # Print time elapsed for training repetitions
    if dt > 60 and dt <= 3600:
        print('\n%s\t%4.1f%s\n' % ('% Tempo total dispendido:', dt / 60, ' minutos'))
    elif dt > 3600 and dt <= 86400:
        print('\n%s\t%4.1f%s\n' % ('% Tempo total dispendido:', dt / 3600, ' horas'))
    elif dt <= 60:
        print('\n%s\t%4.1f%s\n' % ('% Tempo total dispendido:', dt, ' segundos'))
    else:
        print('\n%s\t%4.3f%s\n' % ('% Tempo total dispendido:', dt / 86400, ' dias'))

    return rn_S, V_s, J_s, pr


def fnuexecutar(rn, Pt: np.ndarray) -> np.ndarray:
    Ah = rn.hidden.fat
    Dh = rn.hidden.der
    As = rn.output.fat
    Ds = rn.output.der
    nh = rn.hidden.num

    # Funções de Escalonamento e Parâmetros de Escalonamento
    eesc = rn.input.esc  # Função de escalonamento para entrada (armazenada em string em forma de ponteiro) "@(v, par, u) (v-par(:, 1)*u)./(par(:, 2)*u)"
    epar = rn.input.par  # Parâmetros utilizados para cada nó de entrada pela função de escalonamento de entrada
    sesc = rn.output.esc  # Função de escalonamento para saída (armazenada em string em forma de ponteiro) "@(v, par, u) (v-par(:, 1)*u)./(par(:, 2)*u)"
    spar = rn.output.par  # Parâmetros utilizados para cada nó de saída pela função de escalonamento de saída

    # Escalonar os registros de entrada e saída para treinamento (Pt, Tt) e validação-cruzada (Pl, Tl)
    u = np.ones(Pt.shape[
                    1])  # Inicializar um vetor-base para multiplicar os parâmetros de escalonamento, serão usados nas funções de escalonamento
    p = eesc(Pt, epar, u)  # Entradas dos registros de treinamento (Padrões)

    # Propagar o sinal de entrada (p - padrão) até a saída (s), passando pela camada interna (h)
    h = Ah(
        rn.hidden.sin[0] @ p + rn.hidden.sin[1] @ u)  # h=1./(1+exp(-(wh*p+bh*u)));        % Sinal para camada interna
    s = As(
        rn.output.sin[0] @ h + rn.output.sin[1] @ u)  # s=1./(1+exp(-(ws*h+bs*u)));        % Sinal para camada de saida
    return s


def systematicsampling(registros, num_registros, m=0, extremes=0, output_i=None):
    if output_i is None:
        output_i = -1

    # j_extremos = { maxfor i in registros}
    # Find the indices of the minimum and maximum values in each column
    min_indices = np.apply_along_axis(np.argmin, axis=1, arr=registros)
    max_indices = np.apply_along_axis(np.argmax, axis=1, arr=registros)

    # Find the unique columns that have a line with a minimum or maximum value
    cols_with_minmax = np.unique(np.concatenate([min_indices, max_indices]))

    # Sort in ascending order
    reference_row2sort = registros[output_i]

    # Extract the last row and sort it in ascending order
    sorted_indexes = np.argsort(reference_row2sort)
    sorted = registros[:, sorted_indexes]

    j = list(range(0, registros.shape[1]))
    for _ in cols_with_minmax[::-1]:
        j.pop(_)

    step = len(j) / (num_registros + 1 - len(cols_with_minmax))

    js = []
    i = round(step)
    while i < len(j):
        js.append(round(i))
        i += step
    jr = np.concatenate([js, cols_with_minmax])
    jr = jr[np.argsort(jr)]
    ja = np.array([_ for _ in list(range(0, registros.shape[1])) if _ not in jr])
    return ja, jr


class MLP:
    def __init__(
            self,
            struct=None,
            enom: List[str] = None,
            epar: np.ndarray = None,
            snom: List[str] = None,
            spar: np.ndarray = None,
            eesc: Callable = None,
            ifat: Callable = None,
            ider: Callable = None,
            sfat: Callable = None,
            sder: Callable = None,
            sesc: Callable = None,
            srec: Callable = None,
    ):
        struct = struct if struct is not None else [1, 3, 1]

        # check inputs
        self.check_inputs(struct=struct, enom=enom, epar=epar, snom=
        snom, spar=spar, eesc=eesc, ifat=ifat, ider=ider, sfat=sfat, sder=sder, sesc=sesc,
                          srec=srec)

        self.input = self.InputLayer(num=struct[0], par=epar, esc=eesc)
        self.hidden = self.HiddenLayer(num=struct[1], sin=MLP.randomize_sinaptic_weights(struct[0], struct[1]))
        self.output = self.OutputLayer(num=struct[2], par=spar, esc=sesc)

    @staticmethod
    def check_inputs(struct=None, enom=None, epar=None, snom=None, spar=None, eesc=None, ifat=None, ider=None,
                     sfat=None, sder=None, sesc=None, srec=None, ):
        if enom is None:
            enom = {f'X{_}' for _ in range(struct[0])}
        if snom is None:
            snom = {f'Y{_}' for _ in range(struct[0])}
        if struct[0] != len(enom):
            raise ValueError('The number of input nodes and that of input nodes name must match')
        return struct, enom, epar, snom, spar, eesc, ifat, ider, sfat, sder, sesc, srec

    class InputLayer:
        def __init__(self, num, par, nom=None, esc=None):
            self.num: int = num
            if nom is None:
                self.nom = {f'X{_}' for _ in range(num)}
            else:
                self.nom = set(nom)
            if esc is None:
                self.esc = MLP.minmax_scale()
            else:
                self.esc = esc
            self.par = par

    class HiddenLayer:
        def __init__(self, num, sin, fat=None, der=None):
            self.num: int = num
            self.sin: np.ndarray = sin
            if fat is None:
                self.fat: Callable = MLP.sigmoid()
            else:
                self.fat: Callable = fat
            if fat is None:
                self.der: Callable = MLP.sigmoid_der()
            else:
                self.der: Callable = der

    class OutputLayer:
        def __init__(self, num, par, nom=None, esc=None, fat=None, der=None):
            self.num: int = 0
            if nom is None:
                self.nom = {f'Y{_}' for _ in range(num)}
            else:
                self.nom = set(nom)
            self.sin: np.ndarray = np.array([None])
            if fat is None:
                self.fat: Callable = MLP.sigmoid()
            else:
                self.fat: Callable = fat
            if fat is None:
                self.der: Callable = MLP.sigmoid_der()
            else:
                self.der: Callable = der
            if esc is None:
                self.esc = MLP.minmax_scale()
            else:
                self.esc = esc
            self.rec: Callable = lambda x: None
            self.par = par

    @staticmethod
    def sigmoid() -> Callable:
        return lambda n: 1. / (1 + np.exp(-n)).T

    @staticmethod
    def sigmoid_der() -> Callable:
        return lambda a: np.maximum(a * (1 - a), 0.01)

    @staticmethod
    def minmax_scale():
        return lambda v, par: (v - (np.ones(v.shape).T * par[:, 0]).T) / (par[:, 1, np.newaxis] - par[:, 0, np.newaxis])

    @staticmethod
    def minmax_descale():
        return lambda v, par, u: (v - par[:, 0] * u) / ((par[:, 1] - par[:, 0]) * u).T

    @staticmethod
    def check_nodes_per_layer(nodes_per_layer):
        if len(nodes_per_layer) < 3:
            raise ValueError("The number of layers must be greater than or equal to 3.")
        elif not all([isinstance(_, int) and _ > 0 for _ in nodes_per_layer]):
            raise ValueError("Each layer must have at least one node.")
        else:
            print(f'Creating ANN with following architecture: {nodes_per_layer!s}')

    @staticmethod
    def randomize_sinaptic_weights(n_layer, n_previous_layer):
        np.random.seed()
        return np.random.randn(n_layer, n_previous_layer + 1)


if __name__ == '__main__':
    # Pattern and Target
    conc = [np.array([[float(0)], [float(0)]]), np.array([np.linspace(0, 10, 111), np.linspace(0, 10, 111)])]
    P = np.concatenate(conc, axis=1)
    T = np.array(list(map(lambda x: x ** 2, P[0])))
    T += np.random.rand(len(T))
    M = np.concatenate([P, [T]], axis=0)

    # Systematic sampling
    ja, jr = systematicsampling(registros=M, num_registros=20, m=0, extremes=1, output_i=-1, )

    min_values = np.amin(M, axis=1)
    max_values = np.amax(M, axis=1)
    esc_par = np.array([min_values, max_values - min_values]).T

    rn = MLP(
        struct=[2, 5, 1],
        epar=esc_par[:-1],
        spar=esc_par[-1],
    )

    result = P[:, jr] - rn.input.par[:, 0, np.newaxis]
    print(rn.hidden.sin.shape)
    rn, _, J, dtrep = fntreinaval_jsf3(
        rn,
        Pt=P[:, jr],
        Tt=T[jr],
        Pl=P[:, ja],
        Tl=T[ja],
        ciclos=1_000_000,
        rep=5,
        c=0,
    )
    # [NS, Mea, Mpea, Pbias, Me, E10, E25, E50, E75, E90, n]=fmudesempenho_jsf(Tl, Sl, 0, 1, snom)
