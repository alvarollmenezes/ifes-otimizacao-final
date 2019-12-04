%
% Conjunto de restrições do problema
%
% b = base da viga em cm
% h = altura da viga em cm
% L = comprimento da viga em m
%
function c = restricoes(b, h, L)
    
    hm = h / 100; % m
    bm = b / 100; % m

    fck = 2; % 2 kN / cm² = 20 Mpa
    v = 0.552;
    % Módulo de elasticidade secante do concreto
    Ecs = 2128.74; % kN / cm²
    fctf = 0.221; % kN / cm²
    n = 9.865;
    Es = 21000; % kN / cm²

    fyk = 50; % 50 kN / cm² = 500 Mpa
    % Carregamento permanente
    g = 22; % kN/m
    % Carregamento variável
    q = 11; % kN/m
    Lcm = L * 100; % cm

    % Resistência de cálculo do concreto e do aço
    fcd = fck / 1.4; % kN / cm²
    fcdm = fcd * 10000; % kN / m²

    % altura útil
    d = 0.9 * h; % cm
    dm = d / 100; % m

    % Carga do peso próprio
    gpp = hm * bm * 25; % kN/m

    % Carregamento
    p = 1.4 * ( gpp + g + q ); % kN / m

    % Armadura longitudinal
    % Momento de cálculo
    Md = p * L * L / 8; % kNm
    Mdcm = Md * 100;

    % Momento limite
    Mdlim = 0.272 * bm * dm * dm * fcdm; % kNm

    % Restrição 1 - para armadura simples
    c(1) = Md - Mdlim;

    % Altura da Linha neutra
    x = 1.25 * d * ( 1 - sqrt( 1 - ( Mdcm / ( 0.425 * b * d * d * fcd ) ) ) ); % cm

    % Restrição 2 - verificaçao da ductilidade das estruturas
    c(2) = x - 0.5 * d;
    
    % Armadura longitudinal
    Asl = asl(b, h, L);

    roB = 0.85 * fck * 0.85 / ( fyk * ( 1 + fyk / ( 0.003 * Es ) ) );

    % Restrição 3 - verificação da armadura máxima
    c(3) = Asl / ( b * d ) - 0.5 * roB;

    % Esforço cortante de cálculo
    Vd = p * L / 2; % kN

    % Força cortante de cálculo máxima resistida por compressão das bielas
    Vrd2 = 0.45 * b * d * v * fcd; % kN

    % Restrição 4 - verificação das bielas comprimidas
    c(4) = Vd - Vrd2;


    % Verificações no estado limite de serviço
    % formulas.executarVerificacoes = ( Asl ) => {
    % Momento de inércia da sessáo bruta
    Ic = b * h * h * h / 12; % cm^4

    % Carregamento quase permanente
    Pqp = gpp + g + 0.4 * q; % kN / m
    Pqpcm = Pqp / 100; % kN / cm

    % Flecha elástica        
    felastica = 5 * Pqpcm * Lcm * Lcm * Lcm * Lcm / ( 384 * Ecs * Ic ) * 10; % mm

    % Flecha imediata

    % Momento fletor da ação quase permanente
    Mqp = Pqp * L * L / 8; % kNm
    Mqpcm = Mqp * 100; % kNcm

    % Momento fletor de fissuração
    Mr = b * h * h / 6 * fctf; % kNcm

    %a1, a2, a3, x2, I2, Ie;
    if ( Mqpcm >= Mr ) % Estádio II com fissuração
        % Momento de inércia da sessão no estádio II ( para armadura simples )
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

    % Restrição 5 - verificação da flecha total
    c(5) = fTotal - flimite;

    % Restrição 6 - segurança a instabilidade da viga NBR 6118
    c(6) = -b + 2*L;
    % Restrição 7 - ???????
    c(7) = -h + 25;
    % Restrição 8 - segurança a instabilidade da viga NBR 6118
    c(8) = -b + 0.4*h;
    
end
