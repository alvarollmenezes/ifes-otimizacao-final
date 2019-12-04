function resp = app(L)

    x0 = [3*L, 10*L];
    % x0 = [-1, 1];
    lb = [ ]; % No lower bounds
    ub = [ ]; % No upper bounds
    
    objfungrad(x0);
    
    options = optimoptions(@fmincon,'Algorithm','sqp');
    [x1, fval1, exitflag1, output1] = fmincon(@objfungrad,x0,[],[],[],[],...
        lb,ub,@confungrad,options);

    options = optimoptions(@fmincon,'Algorithm','...');
    [x2, fval2, exitflag2, output2] = fmincon(@objfungrad,x0,[],[],[],[],...
        lb,ub,@confungrad,options);
    
    options = optimoptions(@fmincon,'Algorithm','...');
    [x3, fval3, exitflag3, output3] = fmincon(@objfungrad,x0,[],[],[],[],...
        lb,ub,@confungrad,options);

    function f = objfungrad(x)
        f = custo(x(1), x(2), L);
    end

    function [c,ceq] = confungrad(x)
       c = restricoes(x(1), x(2), L);
       ceq = [];
    end

    resp.x = x;
    resp.fval = fval;
    resp.exitflag = exitflag;
    resp.output = output;
    
    resp
    output
    valorTotal = fval * L
end

