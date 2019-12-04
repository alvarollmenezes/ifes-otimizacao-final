function f = asw(b, h, L)

    hm = h / 100; % altura em m
    bm = b / 100; % base em m

    fyk = 50; % 50 kN / cm� = 50 Mpa
    
    fctd = 0.1105; % kN / cm�
    % M�dulo de elasticidade secante do concreto
    % Carregamento permanente
    g = 22; % kN/m
    % Carregamento vari�vel
    q = 11; % kN/m

    % Resist�ncia de c�lculo do concreto e do a�o
    fyd = fyk / 1.15; % kN / cm�
    
    % altura �til
    d = 0.9 * h; % cm

    % Carga do peso pr�prio
    gpp = hm * bm * 25; % kN/m

    % Carregamento
    p = 1.4 * ( gpp + g + q ); % kN / m

    % Esfor�o cortante de c�lculo
    Vd = p * L / 2; % kN
    
    % Armadura transversal
    s = 100;

    % For�a cortante resistida por outros mecanismos
    Vc = 0.6 * b * d * fctd; % kN
    
    % Armadura transversal
    Asw = ( Vd - Vc ) * s / ( 0.9 * d * fyd ); % cm� / m

    % Armadura transversal m�nima
    AswMin = 0.088 / 100 * b * s; % cm� / m

    % Armadura transversal final
    f = max( Asw, AswMin ); 

end