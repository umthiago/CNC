
function X = lu_crout(A, B)
    printf("***** MÉTODO DIRETO: FATORAÇÃO LU por CROUT *****\n")

    // Armazena cópias originais
    A_original = A;
    B_original = B;

    printf("Entrada - Matriz A (original):")
    disp(A_original)

    printf("\nEntrada - Vetor B (original):")
    disp(B_original)

    n = length(B);
    L = zeros(n, n);
    U = eye(n, n); // U com diagonal principal 1 (Crout)

    //Fatoração LU
    for j = 1:n
        for i = j:n
            soma = 0;
            for k = 1:j-1
                soma = soma + L(i,k) * U(k,j);
            end
            L(i,j) = A(i,j) - soma;
        end

        if L(j,j) == 0 then
            error("Pivô nulo encontrado. Método sem pivoteamento falha.");
        end

        for i = j+1:n
            soma = 0;
            for k = 1:j-1
                soma = soma + L(j,k) * U(k,i);
            end
            U(j,i) = (A(j,i) - soma) / L(j,j);
        end
    end

    // Resolvendo LY = B (substituição progressiva)
    Y = zeros(n,1);
    for i = 1:n
        soma = 0;
        for j = 1:i-1
            soma = soma + L(i,j) * Y(j);
        end
        Y(i) = (B(i) - soma) / L(i,i);
    end
    printf("\n---------------------------")
    printf("\n****Dimensão de n: %d variáveis****", n);
    printf("\n-----------------------------")

    //mostrar Matriz triangularizada e vetor B escalonado
    printf("\n*****FATOR L:*****")
    disp(L)

    printf("\n*****FATOR U:*****")
    disp(U)

    printf("\nSolução Y de LY=B:")
    disp(Y)

    // Resolvendo UX = Y (substituição regressiva)
    X = zeros(n,1);
    for i = n:-1:1
        soma = 0;
        for j = i+1:n
            soma = soma + U(i,j) * X(j);
        end
        X(i) = (Y(i) - soma) / U(i,i); // U(i,i) = 1 para Crout, mas mantido para generalidade
    end

    printf("\nSolução X (UX = Y):\n")
    mprintf(" x(%d) = %.6f\n", [(1:n)', X]);

    // Verificação AX ≈ B
    printf("\nVerificação dos resultados (A*X ≈ B):\n")
    for i = 1:n
        s = 0;
        for j = 1:n
            s = s + A_original(i,j) * X(j);
            if j < n then
                printf("(%d*%.6f) + ", A_original(i,j), X(j));
            else
                printf("(%d*%.6f) = ", A_original(i,j), X(j));
                printf("%.6f\n", s);
            end
        end
    end

    printf("\nErro absoluto (AX - B):\n")
    erro = A_original * X - B_original;
    disp(erro)

    printf("\n ********** FATORAÇÃO LU FINALIZADA **********\n")
endfunction
