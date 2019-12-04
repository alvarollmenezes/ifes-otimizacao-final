function f = asl(b, h, L)

    hm = h / 100; % m
    bm = b / 100; % m

    fck = 2; % 2 kN / cm� = 20 Mpa
    fyk = 50; % 50 kN / cm� = 50 Mpa
    
    % Carregamento permanente
    g = 22; % kN/m
    % Carregamento vari�vel
    q = 11; % kN/m

    % Resist�ncia de c�lculo do concreto e do a�o
    fcd = fck / 1.4; % kN / cm�
    fyd = fyk / 1.15; % kN / cm�

    % altura �til
    d = 0.9 * h; % cm

    % Carga do peso pr�prio
    gpp = hm * bm * 25; % kN/m

    % Carregamento
    p = 1.4 * ( gpp + g + q ); % kN / m

    % Armadura longitudinal
    % Momento de c�lculo
    Md = p * L * L / 8; % kNm
    Mdcm = Md * 100;

    % Altura da Linha neutra
    x = 1.25 * d * ( 1 - sqrt( 1 - ( Mdcm / ( 0.425 * b * d * d * fcd ) ) ) ); % cm
    
    % Armadura longitudinal
    Asl = 0.68 * b * x * fcd / fyd; % cm�

    % Armadura longitudinal m�nima
    Aslmin = 0.15 / 100 * b * h;

    % Armadura longitudinal final
    f = max( Asl, Aslmin );

end