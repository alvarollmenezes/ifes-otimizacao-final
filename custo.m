%
% Calculo do custo da viga (aço + concreto + forma)
%
% b = base da viga em cm
% h = altura da viga em cm
% L = comprimento da viga em m
%
function f = custo(b, h, L)
    Asl = asl(b, h, L);
    Asw = asw(b, h, L);

    %%% AÇO
    % Área do aço
    As = Asl + Asw / 100 * L; % cm²
    Asm = As / 10000; % m²

    % Peso específico do aço
    ROs = 7850; % kg/m³

    % Custo do aço (2017)
    Cs = 7.8; % R$/kg

    % Valor do aço por m
    Vs = Cs * ROs * Asm; % R$/m


    %%% CONCRETO
    % Área do concreto
    Ac = b * h; % cm²
    Acm = Ac / 10000; % m²

    % Custo do Concreto (2017)
    Cc = 314.66; % R$ / m³

    % Valor do concreto por m
    Vc = Acm * Cc; % R$ / m


    %%% FORMA
    % Perímetro da forma
    p = 2 * h + b; % cm
    pm = p / 100; % m

    % Custo da montagem e materiais da forma de madeira (2017)
    Cf = 70.88; % R$ / m²

    % Valor da forma por m
    Vf = pm * Cf; % R$ / m


    % Valor total
    f = Vc + Vs + Vf;
   
end
