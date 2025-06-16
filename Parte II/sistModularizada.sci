clear();clc();clf();

printf('\n INTERPOLAÇÃO POR SISTEMA DE EQUAÇÕES - Ver. MODULARIZADA \n\n');

// [0] carregamento das funcoes modularizadas

//gauss                             //resolucao de sistemas lineares por eliminação de Gauss
//vander_matrix                     // construcao da matriz de Vandermonde
//avaliar_polinomio                 // avaliacao de polinomios em um ponto especifico       
// plotar_interpolador               // geracao do grafico com pontos e polinomio

exec("Gauss.sce", -1);
exec("Vander_matrix.sce", -1);
exec("avaliar_polinomio.sce", -1);

// [1] entrada de dados

X = [0,1,2,3];     //abscissas dos pontos (xi)
Y = [1,6,5,-8];     // ordenadas dos pontos (yi)
n = length(X);      // numero de pontos
grau_polinomio = n - 1;

printf("\n[1] TABELA DE DADOS\n");
for i = 1:n
    printf("   x = %.6f; f(x) = %.6f\n", X(i), Y(i));
end

// [2] construcao da matriz de Vandermonde
printf("\n[2] MATRIZ DE VANDERMONDE\n");
disp(Vander);

// [3] resolucao do sistema de equacoes via Gauss

COEF = Gauss(vander, Y);

printf("\n[3] COEFICIENTES DO POLINOMIO \n");
coef_labels = ["a0", "a1", "a2", "a3", "a4", "a5"]; // labels for coefficients
for i = 1:n 
    mprintf("   %s = %.6f\n", coef_labels(i), COEF(i));
end

// [4] construcao do polinomio interpolador

Pol = poly(COEF, 'x', 'c');
printf("\n[4] POLINOMIO INTERPOLADOR \n");

disp(Pol);

// [5] avaliacao do polinomio interpolador em um ponto especifico

ponto = 3.0;
valor_real = -8;
[valor_aprox, erro_percentual] = avaliar_polinomio(Pol, ponto, valor_real);

printf("\n[5] VALOR APROXIMADO: p(%.2f) = %.6f\n", ponto, valor_aprox);
printf("\n[6] ERRO PERCENTUAL: %.4f%%\n", erro_percentual);

// [6] plotagem do grafico com pontos e polinomio

plotar_interpolador(X, Y, COEF);

printf("\n\n FIM DE INTERPOLAÇÃO POR SISTEMAS DE EQUAÇÕES \n\n");
