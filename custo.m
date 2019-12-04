%
% Calculo do custo da viga (a�o + concreto + forma)
%
% b = base da viga em cm
% h = altura da viga em cm
% L = comprimento da viga em m
%
function f = custo(b, h, L)
    Asl = asl(b, h, L);
    Asw = asw(b, h, L);

    %%% A�O
    % �rea do a�o
    As = Asl + Asw / 100 * L; % cm�
    Asm = As / 10000; % m�

    % Peso espec�fico do a�o
    ROs = 7850; % kg/m�

    % Custo do a�o (2017)
    Cs = 7.8; % R$/kg

    % Valor do a�o por m
    Vs = Cs * ROs * Asm; % R$/m


    %%% CONCRETO
    % �rea do concreto
    Ac = b * h; % cm�
    Acm = Ac / 10000; % m�

    % Custo do Concreto (2017)
    Cc = 314.66; % R$ / m�

    % Valor do concreto por m
    Vc = Acm * Cc; % R$ / m


    %%% FORMA
    % Per�metro da forma
    p = 2 * h + b; % cm
    pm = p / 100; % m

    % Custo da montagem e materiais da forma de madeira (2017)
    Cf = 70.88; % R$ / m�

    % Valor da forma por m
    Vf = pm * Cf; % R$ / m


    % Valor total
    f = Vc + Vs + Vf;
   
end
