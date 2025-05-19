clear; clc; clf;

printf("*** MÉTODO DIRETO: GAUSS (ELIMINAÇÃO GAUSSIANA) SEM PIVOTEAMENTO ***\n\n");

// Definindo a matriz A e o vetor B
A_original = [3, 2, 4; 1, 1, 2; 4, 3, -2];
B_original = [1; 2; 3];

printf("Entrada - Matriz A (original):\n");
disp(A_original);

printf("Entrada - Vetor B (original):\n");
disp(B_original);

// Criando cópias para a triangularização
A_copia = A_original;
B_copia = B_original;

// Algoritmo de triangularização (eliminação direta)
n = length(B_copia);

for k = 1:n-1
    if A_copia(k,k) == 0
        error("Elemento nulo na diagonal principal");
    end
    for i = k+1:n
        m = A_copia(i,k) / A_copia(k,k);
        A_copia(i,k) = 0;
        for j = k+1:n
            A_copia(i,j) = A_copia(i,j) - m * A_copia(k,j);
        end
        B_copia(i) = B_copia(i) - m * B_copia(k);
    end
end

// Resolução do sistema triangular superior (substituição retroativa)
x = zeros(n,1);
x(n) = B_copia(n) / A_copia(n,n);
for k = n-1:-1:1
    soma = 0;
    for j = k+1:n
        soma = soma + A_copia(k,j) * x(j);
    end
    x(k) = (B_copia(k) - soma) / A_copia(k,k);
end

printf("\nSolução X do Sistema:\n");
for i = 1:n
    mprintf(" x(%d) = %.6f\n", i, x(i));
end

// Verificação dos resultados (A_original * x = B_original)
printf("\nVerificação dos resultados (A*X = B):\n");
for i = 1:n
    s = 0;
    for j = 1:n
        s = s + A_original(i,j) * x(j);
        if j < n
            printf(" (%d*%.6f) + ", A_original(i,j), x(j));
        else
            printf(" (%d*%.6f) = ", A_original(i,j), x(j));
            printf(" %.6f\n", s);
        end
    end
end

// Cálculo e exibição do erro absoluto
printf("\nErro absoluto (A*X - B):\n");
erro = A_original * x - B_original;
disp(erro);

printf("\n********************* ELIMINAÇÃO DE GAUSS FINALIZADA ****************\n");