function [dfMU,dnMU,dfEN,dnEN,M]=filtroparametros(M,local,filtro)
% Transformar M com o filtro selecionado
%   Detailed explanation goes here
if strcmp(local,'ENC')
    if strcmp(filtro,'mmg')
        % Parametros
        ePT=ENC.pPT.FMMG.escala(alc); fPT=ENC.pPT.FMMG.forma(alc); dpPT=ENC.pPT.FMMG.def(alc); 
        ePV=ENC.pPV.FMMG.escala(alc); fPV=ENC.pPV.FMMG.forma(alc); dpPV=ENC.pPV.FMMG.def(alc);
        ePI=ENC.pPI.FMMG.escala(alc); fPI=ENC.pPI.FMMG.forma(alc); dpPI=ENC.pPI.FMMG.def(alc); 
        eSC=ENC.pSC.FMMG.escala(alc); fSC=ENC.pSC.FMMG.forma(alc); dpSC=ENC.pSC.FMMG.def(alc);
        eMU=ENC.pMU.FMMG.escala(alc); fMU=ENC.pMU.FMMG.forma(alc); dpMU=ENC.pMU.FMMG.def(alc); 
        eEN=ENC.pEN.FMMG.escala(alc); fEN=ENC.pEN.FMMG.forma(alc); dpEN=ENC.pEN.FMMG.def(alc);
        % Filtrar
        M(1, :)=fstmediamovelgama(M(1, :), fPT, ePT, 0.01);
        M(2, :)=fstmediamovelgama(M(2, :), fPV, ePV, 0.01);
        M(3, :)=fstmediamovelgama(M(3, :), fPI, ePI, 0.01);
        M(4, :)=fstmediamovelgama(M(4, :), fSC, eSC, 0.01);
        M(5, :)=fstmediamovelgama(M(5, :), fMU, eMU, 0.01);
        M(6, :)=fstmediamovelgama(M(6, :), fEN, eEN, 0.01);
        elseif strcmp(filtro,'mmu')
        % Parametros
        jnPT=ENC.pPT.FMMU.jan(alc); dpPT=ENC.pPT.FMMU.def(alc); 
        jnPV=ENC.pPV.FMMU.jan(alc); dpPV=ENC.pPV.FMMU.def(alc);
        jnPI=ENC.pPI.FMMU.jan(alc); dpPI=ENC.pPI.FMMU.def(alc); 
        jnSC=ENC.pSC.FMMU.jan(alc); dpSC=ENC.pSC.FMMU.def(alc);
        jnMU=ENC.pMU.FMMU.jan(alc); dpMU=ENC.pMU.FMMU.def(alc); 
        jnEN=ENC.pEN.FMMU.jan(alc); dpEN=ENC.pEN.FMMU.def(alc);
        % Filtrar
        M(1, :)=fstmediamoveluni(M(1, :), jnPT, dpPT);
        M(2, :)=fstmediamoveluni(M(2, :), jnPV, dpPV);
        M(3, :)=fstmediamoveluni(M(3, :), jnPI, dpPI);
        M(4, :)=fstmediamoveluni(M(4, :), jnSC, dpSC);
        M(5, :)=fstmediamoveluni(M(5, :), jnMU, dpMU);
        M(6, :)=fstmediamoveluni(M(6, :), jnEN, dpEN);
        elseif strcmp(filtro,'mme')
        % Parametros
        mvPT=ENC.pPT.FMME.mv(alc); dpPT=ENC.pPT.FMME.def(alc); 
        mvPV=ENC.pPV.FMME.mv(alc); dpPV=ENC.pPV.FMME.def(alc);
        mvPI=ENC.pPI.FMME.mv(alc); dpPI=ENC.pPI.FMME.def(alc); 
        mvSC=ENC.pSC.FMME.mv(alc); dpSC=ENC.pSC.FMME.def(alc);
        mvMU=ENC.pMU.FMME.mv(alc); dpMU=ENC.pMU.FMME.def(alc); 
        mvEN=ENC.pEN.FMME.mv(alc); dpEN=ENC.pEN.FMME.def(alc);

        % Filtrar
        M(1, :)=fstmediamovelexpo(M(1, :), mvPT, dpPT);
        M(2, :)=fstmediamovelexpo(M(2, :), mvPV, dpPV);
        M(3, :)=fstmediamovelexpo(M(3, :), mvPI, dpPI);
        M(4, :)=fstmediamovelexpo(M(4, :), mvSC, dpSC);
        M(5, :)=fstmediamovelexpo(M(5, :), mvMU, dpMU);
        M(6, :)=fstmediamovelexpo(M(6, :), mvEN, dpEN);
    else
    end
else
    error('\n%s','Função só serve para ENC')
end
dfMU=ENC.fMU.FDM.dif(alc); dnMU=ENC.fMU.FDM.def(alc); 
dfEN=ENC.fEN.FDM.dif(alc); dnEN=ENC.fEN.FDM.def(alc);
end

