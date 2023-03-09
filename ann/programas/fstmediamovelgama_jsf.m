function [s_fmmg] = fstmediamovelgama_jsf(s, F, E, p)
% [dados_chuva] = filtrar_fmme(dados_chuvas, mv)
%
%   Media m�vel gama do Olavo, por�m desconsidera eventuais NaN
%
% Filtra com FMME de par�metro mv a s�rie declarada.
% ENTRADA: dados_chuva, mv
% SAIDA: dados_chuva_FMME
%
[w] = fscpesosmediamovelgama(F, E, p);
s_fmmg=nansum(s(end-size(w,2)+1:end).*w);

end