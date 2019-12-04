%
% Conjunto de restri��es do problema
%
% b = base da viga em cm
% h = altura da viga em cm
% L = comprimento da viga em m
%
function c = restricoes(b, h, L)
    
    hm = h / 100; % m
    bm = b / 100; % m

    fck = 2; % 2 kN / cm� = 20 Mpa
    v = 0.552;
    % M�dulo de elasticidade secante do concreto
    Ecs = 2128.74; % kN / cm�
    fctf = 0.221; % kN / cm�
    n = 9.865;
    Es = 21000; % kN / cm�

    fyk = 50; % 50 kN / cm� = 500 Mpa
    % Carregamento permanente
    g = 22; % kN/m
    % Carregamento vari�vel
    q = 11; % kN/m
    Lcm = L * 100; % cm

    % Resist�ncia de c�lculo do concreto e do a�o
    fcd = fck / 1.4; % kN / cm�
    fcdm = fcd * 10000; % kN / m�

    % altura �til
    d = 0.9 * h; % cm
    dm = d / 100; % m

    % Carga do peso pr�prio
    gpp = hm * bm * 25; % kN/m

    % Carregamento
    p = 1.4 * ( gpp + g + q ); % kN / m

    % Armadura longitudinal
    % Momento de c�lculo
    Md = p * L * L / 8; % kNm
    Mdcm = Md * 100;

    % Momento limite
    Mdlim = 0.272 * bm * dm * dm * fcdm; % kNm

    % Restri��o 1 - para armadura simples
    c(1) = Md - Mdlim;

    % Altura da Linha neutra
    x = 1.25 * d * ( 1 - sqrt( 1 - ( Mdcm / ( 0.425 * b * d * d * fcd ) ) ) ); % cm

    % Restri��o 2 - verifica�ao da ductilidade das estruturas
    c(2) = x - 0.5 * d;
    
    % Armadura longitudinal
    Asl = asl(b, h, L);

    roB = 0.85 * fck * 0.85 / ( fyk * ( 1 + fyk / ( 0.003 * Es ) ) );

    % Restri��o 3 - verifica��o da armadura m�xima
    c(3) = Asl / ( b * d ) - 0.5 * roB;

    % Esfor�o cortante de c�lculo
    Vd = p * L / 2; % kN

    % For�a cortante de c�lculo m�xima resistida por compress�o das bielas
    Vrd2 = 0.45 * b * d * v * fcd; % kN

    % Restri��o 4 - verifica��o das bielas comprimidas
    c(4) = Vd - Vrd2;


    % Verifica��es no estado limite de servi�o
    % formulas.executarVerificacoes = ( Asl ) => {
    % Momento de in�rcia da sess�o bruta
    Ic = b * h * h * h / 12; % cm^4

    % Carregamento quase permanente
    Pqp = gpp + g + 0.4 * q; % kN / m
    Pqpcm = Pqp / 100; % kN / cm

    % Flecha el�stica        
    felastica = 5 * Pqpcm * Lcm * Lcm * Lcm * Lcm / ( 384 * Ecs * Ic ) * 10; % mm

    % Flecha imediata

    % Momento fletor da a��o quase permanente
    Mqp = Pqp * L * L / 8; % kNm
    Mqpcm = Mqp * 100; % kNcm

    % Momento fletor de fissura��o
    Mr = b * h * h / 6 * fctf; % kNcm

    %a1, a2, a3, x2, I2, Ie;
    if ( Mqpcm >= Mr ) % Est�dio II com fissura��o
        % Momento de in�rcia da sess�o no est�dio II ( para armadura simples )
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

    % Restri��o 5 - verifica��o da flecha total
    c(5) = fTotal - flimite;

    % Restri��o 6 - seguran�a a instabilidade da viga NBR 6118
    c(6) = -b + 2*L;
    % Restri��o 7 - ???????
    c(7) = -h + 25;
    % Restri��o 8 - seguran�a a instabilidade da viga NBR 6118
    c(8) = -b + 0.4*h;
    
end
