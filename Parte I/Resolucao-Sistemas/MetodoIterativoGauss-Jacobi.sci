clear(); clc()

printf("\n * MÉTODO ITERATIVO: GAUSS-JACOBI (REORDENAÇÃO GULOSA)*\N")

A = [0.1, 0.2, 1.0, 0.3; 
     0.3, 2.0, -0.3, -0.9; 
     4.0, 2.0, -0.3, 0.8; 
     0.6, 3.2, -1.8, 0.4]

B = [4.0; 7.5; 4.4; 10.0]

n = size(A, 1);
Nmax = 100;

epsilon = 1e-6; // Tolerância para convergência
X0 = zeros(n, 1); // Vetor inicial de aproximação
X = X0;
A_original = A;
B_original = B;
//..........................................................................
// Impressão dos dados
printf("\n Matriz A:\n"); 
disp(A_original);
printf("\n Vetor B:\n");
disp(B_original);


//..........................................................................
// Método Iterativo: Gauss-Jacobi

function [A_greedy, B_greedy, sucesso, ordem] = reordenar_greedy(A, B)
    n = size(A, 1);
    usados = zeros(n, 1);
    ordem = zeros(n, 1);
    sucesso = %T;

    for j = 1:n
        maior = -%inf;
        linha_melhor = -1;
        for i = 1:n
            if usados(i) == 0 then
                if abs(A(i, j)) > maior then
                    maior = abs(A(i, j));
                    linha_melhor = i;
                end
            end
        end
        if linha_melhor == -1 then
            sucesso = %F
            A_greedy = A
            B_greedy = B
            return;
        end
        ordem(j) = linha_melhor;
        usados(linha_melhor) = 1;
    end

    A_greedy = A(ordem, :)
    B_greedy = B(ordem)

endfunction

//.................................................
//Aplicando a reordenação gulosa
[A, B, sucesso, ordem_linhas] = reordenar_greedy(A, B)
if sucesso then
    printf("\n Reordenação gulosa bem-sucedida.\n")
    printf("\n Ordem das linhas: ")
    disp(ordem_linhas')

    printf("\n Matriz A reordenada:\n")
    disp(A);
    printf("\n Vetor B reordenado:\n")
    disp(B);
else 
    error("Não foi possível aplicar a reordenacao gulosa.")
end

//.................................................
// Iteração do método de Gauss-Jacobi
for k = 1:Nmax
    for i = 1:n 
        S = 0
        for j = 1:n 
            if i <> j then
                S = S + A(i, j) * X(j)
            end
        end
        X(i) = (B(i) - S) / A(i, i)
    end
    erro = max(abs(X - X0))
    if erro < epsilon then
        printf("\n Convergência alcançada após %d iterações.\n", k)
        break
    end
    X0 = X; // Atualiza o vetor de aproximação
end
//.................................................
// saida de resultados

printf("\n Numero de iterações: %d\n", k);
printf("\n Vetor solucao aproximada: \n");
mprintf(" x(%d)  = %.6f\n", [(1:n)', X])

//.................................................
//verificacao A*X aproximado = B
printf("\n Verificação: A * X = B\n");
for i = 1:n 
    s = 0
    for j = 1:n 
        s = s + A(i, j) * X(j)
        if j < n then
            printf(" %.1f*%.6f +", A(i, j), X(j))
        else
            printf(" %.1f*%.6f = ", A(i, j), X(j))
            printf("%.6f\n", s)
        end
    end
end
    