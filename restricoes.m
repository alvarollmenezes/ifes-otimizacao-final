%
% Conjunto de restriùùes do problema
%
% b = base da viga em cm
% h = altura da viga em cm
% L = comprimento da viga em m
%
function c = restricoes(b, h, L)
    
    hm = h / 100; % m
    bm = b / 100; % m

    fck = 2; % 2 kN / cmù = 20 Mpa
    v = 0.552;
    % Mùdulo de elasticidade secante do concreto
    Ecs = 2128.74; % kN / cmù
    fctf = 0.221; % kN / cmù
    n = 9.865;
    Es = 21000; % kN / cmù

    fyk = 50; % 50 kN / cmù = 500 Mpa
    % Carregamento permanente
    g = 22; % kN/m
    % Carregamento variùvel
    q = 11; % kN/m
    Lcm = L * 100; % cm

    % Resistùncia de cùlculo do concreto e do aùo
    fcd = fck / 1.4; % kN / cmù
    fcdm = fcd * 10000; % kN / mù

    % altura ùtil
    d = 0.9 * h; % cm
    dm = d / 100; % m

    % Carga do peso prùprio
    gpp = hm * bm * 25; % kN/m

    % Carregamento
    p = 1.4 * ( gpp + g + q ); % kN / m

    % Armadura longitudinal
    % Momento de cùlculo
    Md = p * L * L / 8; % kNm
    Mdcm = Md * 100;

    % Momento limite
    Mdlim = 0.272 * bm * dm * dm * fcdm; % kNm

    % 4.4 Dimensionamento devido ao Momento Fletor
    % Restriùùo 1 - para armadura longitudinal simples
    c(1) = Md - Mdlim;

    % Altura da Linha neutra
    x = 1.25 * d * ( 1 - sqrt( 1 - ( Mdcm / ( 0.425 * b * d * d * fcd ) ) ) ); % cm

    % 4.4 Dimensionamento devido ao Momento Fletor
    % Restriùùo 2 - verificaùao da ductilidade das estruturas
    c(2) = x - 0.5 * d;
    
    % Armadura longitudinal
    Asl = asl(b, h, L);

    roB = 0.85 * fck * 0.85 / ( fyk * ( 1 + fyk / ( 0.003 * Es ) ) );

    % 4.1 FunÁıes restriÁıes
    % Restriùùo 3 - verificaùùo da armadura mùxima
    c(3) = Asl / ( b * d ) - 0.5 * roB;

    % Esforùo cortante de cùlculo
    Vd = p * L / 2; % kN

    % Forùa cortante de cùlculo mùxima resistida por compressùo das bielas
    Vrd2 = 0.45 * b * d * v * fcd; % kN

    % 4.5	Dimensionamento devido ao EsforÁo Cortante
    % Restriùùo 4 - verificaùùo das bielas comprimidas
    c(4) = Vd - Vrd2;


    % Verificaùùes no estado limite de serviùo
    % formulas.executarVerificacoes = ( Asl ) => {
    % Momento de inùrcia da sessùo bruta
    Ic = b * h * h * h / 12; % cm^4

    % Carregamento quase permanente
    Pqp = gpp + g + 0.4 * q; % kN / m
    Pqpcm = Pqp / 100; % kN / cm

    % Flecha elùstica        
    felastica = 5 * Pqpcm * Lcm * Lcm * Lcm * Lcm / ( 384 * Ecs * Ic ) * 10; % mm

    % Flecha imediata

    % Momento fletor da aùùo quase permanente
    Mqp = Pqp * L * L / 8; % kNm
    Mqpcm = Mqp * 100; % kNcm

    % Momento fletor de fissuraùùo
    Mr = b * h * h / 6 * fctf; % kNcm

    %a1, a2, a3, x2, I2, Ie;
    if ( Mqpcm >= Mr ) % Estùdio II com fissuraùùo
        % Momento de inùrcia da sessùo no estùdio II ( para armadura simples )
        a1 = b / 2;
        a2 = n * Asl;
        a3 = -n * Asl * d;
        x2 = ( -a2 + sqrt( a2 * a2 - 4 * a1 * a3 ) ) / ( 2 * a1 );
        I2 = b * x2 * x2 * x2 / 3 + n * Asl * ( d - x2 ) * ( d - x2 );

        divisaoIe = ( Mr / Mqpcm ) * ( Mr / Mqpcm ) * ( Mr / Mqpcm );

        Ie = divisaoIe * Ic + ( 1 - divisaoIe ) * I2;
    else
        Ie = Ic;
    end

    fimediata = felastica * ( Ic / Ie ); % mm

    % Flecha diferida

    % Para t0/t = 1 / 70 meses
    alfaF = 1.323;

    fdiferida = alfaF * fimediata; % mm

    % Flecha total
    fTotal = fimediata + fdiferida; % mm

    % Flecha limite
    flimite = L * 1000 / 250; % mm

    % 4.6 VerificaÁ„o de flecha
    % Restriùùo 5 - verificaùùo da flecha total
    c(5) = fTotal - flimite;

    % Restriùùo 6 - seguranùa a instabilidade da viga NBR 6118
    c(6) = -b + 2*L;
    % Restriùùo 7 - seguranùa a instabilidade da viga NBR 6118
    c(7) = -h + 25;
    % Restriùùo 8 - seguranùa a instabilidade da viga NBR 6118
    c(8) = -b + 0.4*h;
    
end
