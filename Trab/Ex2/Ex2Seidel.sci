//..................................................................
clear(); clc()                                        //Limpa variáveis e console
printf("\n **** MÉTODO ITERATIVO: GAUSS-SEIDEL (REORDENAÇÃO GULOSA)****\n")
//..................................................................
// dados de entrada - Matriz dos coeficientes e vetor dos termos indep.
A = [6.0, -1.0, 1.0; 
     1.0, 8.0, -1.0
     1.0, 1.0, 5.0];

B = [7.0; 16.0; 18.0];

//..................................................................
n = size(A, 1);
Nmax = 100;

epsilon = 1e-6; 
X0 = zeros(n, 1); 
X = X0;
A_original = A;
B_original = B;
//..................................................................
// Exibe os dados originais
printf("\n Matriz A original:\n"); 
disp(A_original);
printf("\n Vetor B original:\n");
disp(B_original);

//..................................................................
// Função gulosa: tenta alinhar os maiores coeficientes com a diagonal
function [A_greedy, B_greedy, sucesso, ordem] = reordenar_greedy(A, B)
    n = size(A, 1);
    usados = zeros(n, 1);            // marca as linhas já escolhidas
    ordem = zeros(n, 1);             // nova ordem de linha
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
//..................................................................
// Aplicação da ordenação gulosa
[A, B, sucesso, ordem_linhas] = reordenar_greedy(A, B)

if sucesso then
    printf("\n Reordenação Gulosa aplicada com sucesso \n")
    printf("\ Ordem das linhas escolhidas: ")
    disp(ordem_linhas');
    
    printf("\n Matriz A após reordenação")
    disp(A);
    printf("\n Vetor B após reordenação")
    disp(B);
else
    error("Não foi possível aplicar a reordenação gulosa")
end
//Algoritmo de Gauss-Seidel
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
    X0 = X; 
end
//..................................................................
// Saída de resultados 
printf("\n Numero de iterações: %d\n", k);
printf("\n Vetor solucao aproximada: \n");
mprintf(" x(%d)  = %.6f\n", [(1:n)', X])

//..................................................................
// Verificação A*X = B
printf("\n Verificação: A * X = B\n");
for i = 1:n 
    s = 0
    for j = 1:n 
        s = s + A(i, j) * X(j);
        if j < n then
            printf(" %.1f*%.6f +", A(i, j), X(j))
        else
            printf(" %.1f*%.6f = ", A(i, j), X(j))
            printf("%.6f\n", s)
        end
    end
end
//..................................................................
printf("\n***** ENCERRAMENTO DO GAUSS-SEIDEL COM MÉTODO GULOSO *****\n");
//..................................................................
