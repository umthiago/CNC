//////////////////////////////////////////////////////
clear(); clc()//LIMPA AS VARIAVEIS e LIMPA O CONSOLE
//////////////////////////////////////////////////////
printf("\n**** APROXIMAÇÃO PELO MÉTODO DE NEWTON-RAPHSON*****\n")
//////////////////////////////////////////////////////
deff('y = f(x)','y=x^3-9*x+3')                      //Definição da função f(x)
x0 = 0.0
x1 = 1.0
epsilon1 = 1e-05
epsilon2 = 1e-05
k = 0
nMax = 100
xk = x1 - f(x1)*(x1 - x0)/(f(x1) - f(x0)) //
//................
printf("k  |    xk     | abs(xk-x1) |   f(xk)    |  f1(xk)   |\n")
 while (k < nMax) & (abs(xk - x1) > epsilon1) & (abs(f(xk)) > epsilon2)
    x0 = x1
    x1 = xk
    xk = x1 - f(x1)*(x1 - x0)/(f(x1) - f(x0))
    k = k + 1
    printf("%2.2i |%10.6f | %10.6f | %10.6f |\n", k, xk, abs(xk - x1), f(xk))
end
printf("Aprox. ""%8.6f"" à raiz, com ""%2.2i"" iterações", xk, k)

