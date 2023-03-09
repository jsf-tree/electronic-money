function festruturar(local,nome,filtro,alc,r,def,par1,par2,par3,par4)
%   FUNÇÃO:         festruturar(local,nome,filtro,alc,r,def,par1,par2)
%   OBJETIVO:       Montar codigo para estrutura
%
%
%   Exemplo:
% local = 'ENC' 
% nome = 'Passo Tainhas P'
% filtro = 'fmme'
% alc = 6
% r = 0.6364
% def = 8
% par1 = 4
% par2 = 12

nome=nome(~isspace(nome));

if strcmp(nome,'PassoTainhasP')
    niv='pPT';
elseif strcmp(nome,'VacariaP')
    niv='pPV';
elseif strcmp(nome,'IbiraiarasP')
    niv='pPI';
elseif strcmp(nome,'SerafinaCorrêaP')
    niv='pSC';
elseif strcmp(nome,'LinhaJJúlioP')
    niv='pLJJ';
elseif strcmp(nome,'LinhaJJúlioF')
    niv='fLJJ';
elseif strcmp(nome,'MuçumP')
    niv='pMU';
elseif strcmp(nome,'MuçumF')
    niv='fMU';
elseif strcmp(nome,'EncantadoP')
    niv='pEN';
elseif strcmp(nome,'EncantadoF')
    niv='fEN';
elseif strcmp(nome,'EstrelaP')
    niv='pES';
elseif strcmp(nome,'EstrelaF')
    niv='fES';
elseif strcmp(nome,'PortoMarianteF')
    niv='fPM';
elseif strcmp(nome,'TaquariP')
    niv='pTA';
elseif strcmp(nome,'TaquariF')
    niv='fTA';
else
end



switch filtro
    case 'FMMU' 
        fid=fopen([local '.m'], 'a');
        fprintf(fid,'%s%i%s%s%s%s%s%1.4f%s%s%s%s%s%4.4f%s%s%s%s%s%4.4f%s\n',...
            'alc=',alc,'; ',local,'.',niv,'.FMMU.r(alc)=',r,'; ',...
            local,'.',niv,'.FMMU.def(alc)=',def,'; ',...
            local,'.',niv,'.FMMU.jan(alc)=',par1,'; ');
    case 'FMME'
        fid=fopen([local '.m'], 'a');
        fprintf(fid,'%s%i%s%s%s%s%s%1.4f%s%s%s%s%s%4.4f%s%s%s%s%s%4.4f%s\n',...
            'alc=',alc,'; ',local,'.',niv,'.FMME.r(alc)=',r,'; ',...
            local,'.',niv,'.FMME.def(alc)=',def,'; ',...
            local,'.',niv,'.FMME.mv(alc)=',par1,'; ');
    case 'FMMG'
        fid=fopen([local '.m'], 'a');
        fprintf(fid,'%s%i%s%s%s%s%s%1.4f%s%s%s%s%s%4.4f%s%s%s%s%s%4.4f%s%s%s%s%s%4.4f%s%s%s%s%s%4.4f%s%s%s%s%s%4.4f%s\n',...
            'alc=',alc,'; ',local,'.',niv,'.FMMG.r(alc)=',r,'; ',...
            local,'.',niv,'.FMMG.def(alc)=',def,'; ',...
            local,'.',niv,'.FMMG.forma(alc)=',par1,'; ',...
            local,'.',niv,'.FMMG.escala(alc)=',par2,'; ',...
            local,'.',niv,'.FMMG.w(alc)=',par3,'; ',...
            local,'.',niv,'.FMMG.w_max(alc)=',par4,'; ');
    case 'FDM'
        fid=fopen([local '.m'], 'a');
        fprintf(fid,'%s%i%s%s%s%s%s%1.4f%s%s%s%s%s%4.4f%s%s%s%s%s%4.4f%s%s%s%s%s%4.4f%s\n',...
            'alc=',alc,'; ',local,'.',niv,'.FDM.r(alc)=',r,'; ',...
            local,'.',niv,'.FDM.def(alc)=',def,'; ',...
            local,'.',niv,'.FDM.dif(alc)=',par1,'; ',...
            local,'.',niv,'.FDM.reg(alc)=',par2,'; ');        
end
fclose(fid);
end

