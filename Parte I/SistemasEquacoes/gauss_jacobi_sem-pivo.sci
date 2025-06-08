
function x = gauss_sem_pivoteamento(A_original, B_original)
    printf("*** MÉTODO DIRETO: GAUSS (ELIMINAÇÃO GAUSSIANA) SEM PIVOTEAMENTO ***\n\n");

    // Exibe entradas
    printf("Entrada - Matriz A (original):\n");
    disp(A_original);
    printf("Entrada - Vetor B (original):\n");
    disp(B_original);

    A_copia = A_original;
    B_copia = B_original;
    n = length(B_copia);

    // Eliminação
    for k = 1:n-1
        if A_copia(k,k) == 0 then
            error("Pivô nulo encontrado. Método sem pivoteamento falha");
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

    //Substituição regressiva
    x = zeros(n,1);
    printf("\n---------------------------")
    printf("\n****Dimensão de n: %d variáveis\n****", n);
    printf("-----------------------------")

    printf("\n****Matriz A triangularizada:****")

    disp(A_copia)

    printf("****Vetor B escalonado:****")

    disp(B_copia)

    x(n) = B_copia(n) / A_copia(n,n);
    for k = n-1:-1:1
        soma = 0;
        for j = k+1:n
            soma = soma + A_copia(k,j) * x(j);
        end
        x(k) = (B_copia(k) - soma) / A_copia(k,k);
    end

    // Saída da solução
    printf("\nSolução X do Sistema:\n");
    for i = 1:n
        mprintf(" x(%d) = %.6f\n", i, x(i));
    end

    // Verificação
    printf("\nVerificação dos resultados (AX = B):\n");
    for i = 1:n
        s = 0;
        for j = 1:n
            s = s + A_original(i,j) * x(j);
            if j < n then
                printf(" (%d*%.6f) + ", A_original(i,j), x(j));
            else
                printf(" (%d*%.6f) = ", A_original(i,j), x(j));
                printf(" %.6f\n", s);
            end
        end
    end

    // Erro
    printf("\nErro absoluto (AX - B):\n");
    erro = A_original * x - B_original;
    disp(erro);

    printf("\n ********** ELIMINAÇÃO GAUSSIANA FINALIZADA **********\n");
endfunction
