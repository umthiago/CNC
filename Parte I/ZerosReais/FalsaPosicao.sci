//-------TRABALHO 1 - ZEROS REAIS DE FUNÇÕES REAIS----------------
//Alunos: Pedro Miotto Mujica, Thiago Oliveira Dupim, Vinicius Castaman, Gabriel Costa
//Resolvendo usando o Método da Falsa Posição

clear();
h = 300; F = 0.8; D = 14; C = 1200; //constantes exercicio 2.2
d = 10 //constante exercicio 2.3
O = 5 //constante exercicio 2.4

printf("*** APROXIMAÇÃO PELO MÉTODO DA FALSA-POSIÇÃO ***\n\n")

function [xk, k] = falsa_posicao(f, a, b, epsilon1, epsilon2, nMax)
    k = 0;
    xk = (a * f(b) - b * f(a)) / (f(b) - f(a));
    
    printf(" k  |     xk     | abs(b-a)   |    f(xk)   |\n");
    
    while (k < nMax) & (abs(b - a) > epsilon1) & (abs(f(xk)) > epsilon2)
        xk = (a * f(b) - b * f(a)) / (f(b) - f(a));
        k = k + 1;
        printf(" %2.2i | %10.6f | %10.6f | %10.6f |\n", k, xk, abs(b - a), f(xk));
        
        if f(a) * f(xk) < 0 then
            b = xk;
        else
            a = xk;
        end
    end
    
    // Exibir resultado final
    printf("\nAproximação ""%8.6f"" à raiz, com ""%2.2i"" iterações\n", xk, k);
endfunction

//-------------Problema 1.1: Obter uma aproximação às raízes das funções----------------
//1. 𝐟(𝐱) = 𝐱^𝟐 − 𝟑 no intervalo [𝟏; 𝟐], com 𝛜 = 𝟏𝟎**-6
//printf("PROBLEMA 1.1 NÚMERO 1\n");
//deff('y=f(x)', 'y=x^2-3');
//[xk, k] = falsa_posicao(f, 1.0, 2.0, 1e-6, 1e-6, 100);

//2. g(𝐱) = 𝐱^𝟐 + 𝐥𝐧(𝐱) no intervalo [𝟎,𝟓; 𝟏], com 𝛜 = 𝟏𝟎^−𝟓
//printf("PROBLEMA 1.1 NÚMERO 2\n");
//deff('y = g(x)', 'y = x^2 + log(x)');   
//[xk,k] = falsa_posicao(g, 0.5, 1.0, 1e-5, 1e-5, 100);


//-------------Problema 1.2: Obter uma aproximação para primeira raiz positiva da função:----------------
//1. 𝐟(𝐱) = 𝐞^−𝐱 − 𝐬𝐞𝐧(𝐱), com 𝛜 = 𝟏𝟎^−𝟓
//printf("PROBLEMA 1.2 NÚMERO 1\n");
//deff('y = f(x)', 'y = exp(-x)-sin(x)')
//[xk,k] = falsa_posicao(f, 0.5, 1.0, 1e-5, 1e-5, 100)

//2. 𝐟(𝐱) = 𝐱 𝐥𝐧(𝐱) − 𝟑.𝟐 no intervalo [𝟐, 𝟑], com 𝛜 = 𝟏𝟎^−𝟔
//printf("PROBLEMA 1.2 NÚMERO 2\n");
//deff('y = f(x)', 'y = x * log(x) - 3.2')
//[xk, k] = falsa_posicao(f, 2, 3, 1e-6, 1e-6, 100)

//-------------Problema 1.3: Obter uma aproximação às raízes das funções:---------------------------------
//1. 𝐟(𝐱) = 𝐜𝐨𝐬(𝐱) + 𝐱 no intervalo [−𝟏, 𝟎], com 𝛜 = 𝟏𝟎^−𝟓
//printf("PROBLEMA 1.3 NÚMERO 1\n");
//deff('y = f(x)', 'y = cos(x) + x')
//[xk, k] = falsa_posicao(f, -1, 0, 1e-5, 1e-5, 100)
//2. g(𝐱) = 𝐞^𝐱 + 𝐱 no intervalo [−𝟏, 𝟎], com 𝛜 = 𝟏𝟎^−𝟓
//printf("PROBLEMA 1.3 NÚMERO 2\n");
//deff('y = g(x)', 'y = exp(x)+x')
/* DEU DIFERENTE 
*/
//[xk, k] = falsa_posicao(g, -1.0, 0.0, 1e-5, 1e-5, 100)

//-------------Problema 1.4: Obter uma aproximação às raízes----------------
//1. A raiz cúbica de 𝐟(𝐱) = 𝐱^𝟑 − 𝟓, com 𝛜 = 𝟏𝟎^−𝟔
//printf("PROBLEMA 1.4 NÚMERO 1\n");
//deff('y = f(x)', 'y = x^3-5')
//[xk, k] = falsa_posicao(f, 1.0, 2.0, 1e-6, 1e-6, 100)

//2. A raiz negativa de g(𝐱) = 𝐱^𝟑 − 𝟓𝐱^𝟐 + 𝐱 + 𝟑, com 𝛜 = 𝟏𝟎^−𝟔
//printf("PROBLEMA 1.4 NÚMERO 2\n");
//deff('y = g(x)','y = x^3-5*x^2+x+3')
//[xk, k] = falsa_posicao(g, -2.0, 0.0, 1e-6, 1e-6, 100)

//-------------Problema 1.5: Obter uma aproximação à raiz de----------------
//1. 𝐟(𝐱) = 𝐬𝐞𝐧(𝐱) − 𝐭𝐠(𝐱) no intervalo [𝟑, 𝟒], com 𝛜 = 𝟏𝟎^−𝟓
//printf("PROBLEMA 1.5 NÚMERO 1\n");
//deff('y = f(x)','y = sin(x)-tan(x)')
//[xk, k] = falsa_posicao(f, 3.0, 4.0, 1e-5, 1e-5, 100)


//2. 𝐟(𝐱) = 𝐞^−𝐱^𝟐 − 𝐜𝐨𝐬(𝐱) no intervalo [𝟏, 𝟐], com 𝛜 = 𝟏𝟎^−𝟓
//printf("PROBLEMA 1.5 NÚMERO 2\n");
//deff('y = f(x)','y = exp(-x^2) - cos(x)')
//[xk, k] = falsa_posicao(f, 1.0, 2.0, 1e-5, 1e-5, 100)

//-------------Problema 1.6: Obter uma aproximação às raízes das funções----------------
//1. 𝐠(𝐱) = 𝐱^𝟑 − 𝐱 − 𝟏 no intervalo [𝟏, 𝟐], com 𝛜 = 𝟏𝟎^−𝟔
//printf("PROBLEMA 1.6 NÚMERO 1\n");
//deff('y = g(x)','y = x^3 - x - 1')
//[xk, k] = falsa_posicao(g, 1.0, 2.0, 1e-6, 1e-6, 100)

//2. 𝐡(𝐱) = 𝟒𝐬𝐞𝐧(𝐱) − 𝐞^𝐱 no intervalo [𝟎, 𝟏], com 𝛜 = 𝟏𝟎^−𝟓
//printf("PROBLEMA 1.6 NÚMERO 2\n");
//deff('y = h(x)','y = 4*sin(x) - exp(x)')
//[xk, k] = falsa_posicao(h, 0.0, 1.0, 1e-5, 1e-5, 100)
//////////////////////////////////////////////////////////////////////////////////////
//------------------------------ PARTE 2 --------------------------------------------
//////////////////////////////////////////////////////////////////////////////////////

//-------------Problema 2.1: Discuta a função 𝐟(𝐱) = 𝟐𝟑𝟎𝐱^𝟒 + 𝟏𝟖𝐱^𝟑 + 𝟗𝐱^𝟐 − 𝟐𝟐𝟏𝐱 − 9----------------
//Intervalo: [-0.3, 1.1]
//printf("PROBLEMA 2.1\n");
//deff('y = f(x)','y = 230*x^4+18*x^3+9*x^2-221*x-9')
//[xk, k] = falsa_posicao(f, -0.3, 0.0, 1e-5, 1e-5, 100)


//-------------Problema 2.2: Função de captação de energia solar----------------
//y = f(A)', 'y = (%pi*(h/cos(A))^2 * F / (0.5*%pi*D^2*(1 + sin(A) - 0.5*cos(A))) - C
//printf("PROBLEMA 2.2\n");
//𝐡 = 𝟑𝟎𝟎𝒎; 𝐅 = 𝟎.𝟖; 𝐃 =𝟏𝟒𝒎; 𝐂 = 𝟏𝟐𝟎0
// Intervalo: 0 ≤ A ≤ %pi/25 (~0.1257 rad)
//deff('y = f(A)', 'y = (%pi * (h/cos(A))^2 * F) / (0.5 * %pi * D^2 * (1 + sin(A) - 0.5 * cos(A))) - C')
//[xk,k] = falsa_posicao(f, 0.0, %pi/25, 1e-5, 1e-5, 100)

//-------------Problema 2.3: Movimento de material perigoso----------------
//d=10; 'y = p(t)', 'y = 7*(2.0 - 0.9^t) - d'
//printf("PROBLEMA 2.3\n");
//deff('y = p(t)', 'y = 7*(2.0 - 0.9^t) - d');
//[xk, k] = falsa_posicao(p, 0, 10, 1e-5, 1e-5, 100);

//-------------Problema 2.4: Nível de oxigênio em rio----------------
//O = 5; deff('y = C(d)', 'y = 10 - 20*(exp(-0.2*d) - exp(-0.75*d)) - O');
//printf("PROBLEMA 2.4\n");
//deff('y = C(d)', 'y = 10 - 20*(exp(-0.2*d) - exp(-0.75*d)) - O');
//[xk, k] = falsa_posicao(C, 0, 1, 1e-5, 1e-5, 100);
