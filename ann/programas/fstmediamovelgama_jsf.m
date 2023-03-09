function [s_fmmg] = fstmediamovelgama_jsf(s, F, E, p)
% [dados_chuva] = filtrar_fmme(dados_chuvas, mv)
%
%   Media móvel gama do Olavo, porém desconsidera eventuais NaN
%
% Filtra com FMME de parâmetro mv a série declarada.
% ENTRADA: dados_chuva, mv
% SAIDA: dados_chuva_FMME
%
[w] = fscpesosmediamovelgama(F, E, p);
s_fmmg=nansum(s(end-size(w,2)+1:end).*w);

end