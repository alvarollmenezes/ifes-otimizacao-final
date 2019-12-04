function f = asw(b, h, L)

    hm = h / 100; % altura em m
    bm = b / 100; % base em m

    fyk = 50; % 50 kN / cm² = 50 Mpa
    
    fctd = 0.1105; % kN / cm²
    % Módulo de elasticidade secante do concreto
    % Carregamento permanente
    g = 22; % kN/m
    % Carregamento variável
    q = 11; % kN/m

    % Resistência de cálculo do concreto e do aço
    fyd = fyk / 1.15; % kN / cm²
    
    % altura útil
    d = 0.9 * h; % cm

    % Carga do peso próprio
    gpp = hm * bm * 25; % kN/m

    % Carregamento
    p = 1.4 * ( gpp + g + q ); % kN / m

    % Esforço cortante de cálculo
    Vd = p * L / 2; % kN
    
    % Armadura transversal
    s = 100;

    % Força cortante resistida por outros mecanismos
    Vc = 0.6 * b * d * fctd; % kN
    
    % Armadura transversal
    Asw = ( Vd - Vc ) * s / ( 0.9 * d * fyd ); % cm² / m

    % Armadura transversal mínima
    AswMin = 0.088 / 100 * b * s; % cm² / m

    % Armadura transversal final
    f = max( Asw, AswMin ); 

end