
function [X, k] = gauss_jacobi_guloso(A, B, epsilon, Nmax)
    printf("*** MÉTODO ITERATIVO: GAUSS-JACOBI (REORDENAÇÃO GULOSA) ***\n");

    n = size(A,1);
    X0 = zeros(n,1);
    X = X0;
    A_original = A;
    B_original = B;

    printf("\n Matriz A original:\n");
    disp(A_original);
    printf("\n Vetor B original:\n");
    disp(B_original);
    printf("\n Entrada - Dimensão n da matriz quadrada: %d ", n);

    function [A_greedy, B_greedy, sucesso, ordem] = reordenar_greedy(A, B)
        n = size(A,1);
        usados = zeros(n,1);
        ordem = zeros(n,1);
        sucesso = %T;
        
        for j = 1:n
            maior = -%inf;
            linha_melhor = -1;
            for i = 1:n
                if usados(i) == 0 then
                    if abs(A(i,j)) > maior then
                        maior = abs(A(i,j));
                        linha_melhor = i;
                    end
                end
            end
            if linha_melhor == -1 then
                sucesso = %F;
                A_greedy = A;
                B_greedy = B;
                return;
            end
            ordem(j) = linha_melhor;
            usados(linha_melhor) = 1;
        end
        
        A_greedy = A(ordem, :);
        B_greedy = B(ordem);
    endfunction

    [A, B, sucesso, ordem_linhas] = reordenar_greedy(A, B);

    if sucesso then
        printf("\n Reordenação Gulosa aplicada com sucesso.\n");
        printf(" Ordem das linhas escolhida:\n");
        disp(ordem_linhas');
        printf("\n Matriz A após reordenação:\n");
        disp(A);
        printf("\n Vetor B após reordenação:\n");
        disp(B);
    else
        error(" Não foi possível aplicar a reordenação gulosa.");
    end

    // Iterações de Gauss-Jacobi
    for k = 1:Nmax
        for i = 1:n
            S = 0;
            for j = 1:n
                if i <> j then
                    S = S + A(i,j) * X0(j);
                end
            end
            X(i) = (B(i) - S) / A(i,i);
        end
        erro = max(abs(X - X0));
        if erro < epsilon then
            break;
        end
        X0 = X;
    end

    printf("\n Saída número de iterações: %d\n", k);
    printf("\n Saída - Vetor Solução aproximada:\n");
    mprintf(" x(%d) = %.6f\n", [(1:n)', X]);

    // Verificação A*X ≈ B
    printf("\n Verificação dos resultados (A*X ≈ B):\n");
    for i = 1:n
        s = 0;
        for j = 1:n
            s = s + A(i,j) * X(j);
            if j < n then
                printf(" (%.1f*%.6f) +", A(i,j), X(j));
            else
                printf(" (%.1f*%.6f) = ", A(i,j), X(j));
                printf("%.6f\n", s);
            end
        end
    end

    printf("\n***** ENCERRAMENTO DO GAUSS-JACOBI COM MÉTODO GULOSO *****\n");
endfunction
