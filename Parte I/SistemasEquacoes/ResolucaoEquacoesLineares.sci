//-------TRABALHO 1-P2-RESOLUÇÃO DE SISTEMAS DE EQUAÇÕES LINEARES----------------
//Alunos: Pedro Miotto Mujica, Thiago Oliveira Dupim, Vinicius Castaman, Gabriel Costa
//Resolvendo Sistemas de Equações Lineares
funcprot(0);
clear(); clc();

//printf("*** RESOLUÇÃO DE SISTEMAS DE EQUAÇÕES LINEARES ***\n")

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

function X = gauss_seidel_guloso(A_original, B_original, epsilon, Nmax)
    printf("*** MÉTODO ITERATIVO: GAUSS-SEIDEL (REORDENAÇÃO GULOSA) ***\n");

    n = size(A_original,1);
    X0 = zeros(n,1);
    //printf("\n Entrada - dimensão n da matriz quadrada:\n %d .\n", n);
    X = X0;
    
    printf("\n Matriz A original:\n");
    disp(A_original);
    printf("\n Vetor B original:\n");
    disp(B_original);
    printf("\n Entrada - Dimensão n da matriz quadrada: %d ", n);

    // Subfunção de reordenação gulosa
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

    [A, B, sucesso, ordem_linhas] = reordenar_greedy(A_original, B_original);

    if sucesso then
        printf("\n Reordenação Gulosa aplicada com sucesso.\n");
        printf(" Ordem das linhas escolhida:\n");
        disp(ordem_linhas');
        printf("\n Matriz A após reordenação:\n");
        disp(A);
        printf("\n Vetor B após ordenação:\n");
        disp(B);
    else
        error(" Não foi possível aplicar a reordenação gulosa.");
    end

    // Método de Gauss-Seidel
    for k = 1:Nmax
        for i = 1:n
            S1 = 0; S2 = 0;
            for j = 1:i-1
                S1 = S1 + A(i,j) * X(j);
            end
            for j = i+1:n
                S2 = S2 + A(i,j) * X0(j);
            end
            X(i) = (B(i) - S1 - S2) / A(i,i);
        end
        erro = max(abs(X - X0));
        if erro < epsilon then
            break;
        end
        X0 = X;
    end

    printf("\n Número de iterações: %d\n", k);
    printf("\n Vetor solução aproximada:\n");
    mprintf(" x(%d) = %.6f\n", [(1:n)', X]);

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

    printf("\n***** ENCERRAMENTO DO GAUSS-SEIDEL COM MÉTODO GULOSO *****\n");
endfunction

function X = tdma_thomas(a, b, c, d)
    printf("*** MÉTODO DIRETO: THOMAS (TDMA) - SISTEMAS TRIDIAGONAIS ***\n");

    // Guarda cópias dos vetores originais para cálculo do erro
    a_original = a;
    b_original = b;
    c_original = c;
    d_original = d;

    printf("\n Vetor a^T:"); disp(a');
    printf("\n Vetor b^T:"); disp(b');
    printf("\n Vetor c^T:"); disp(c');
    printf("\n Vetor d^T:"); disp(d');

    n = length(b);
    if b(1) == 0 then
        error("Pivô nulo encontrado na primeira linha. Método falha.");
    end

    // Etapa de eliminação direta
    c(1) = c(1) / b(1);
    d(1) = d(1) / b(1);

    for i = 2:n-1
        temp = b(i) - a(i) * c(i-1);
        if temp == 0 then
            error("Pivô nulo encontrado na linha " + string(i) + ". Método falha.");
        end
        c(i) = c(i) / temp;
        d(i) = (d(i) - a(i) * d(i-1)) / temp;
    end

    temp = b(n) - a(n) * c(n-1);
    if temp == 0 then
        error("Pivô nulo encontrado na última linha. Método falha.");
    end
    d(n) = (d(n) - a(n) * d(n-1)) / temp;

    // Substituição regressiva
    X = zeros(n,1);
    printf("\nO sistema possui %d variáveis (dimensão da raiz x).\n", n);
    X(n) = d(n);
    for i = n-1:-1:1
        X(i) = d(i) - c(i) * X(i+1);
    end

    printf("\n Solução X do sistema:\n");
    mprintf("  x(%d) = %.6f\n", [(1:n)', X]);

    // Construção da matriz A para verificação
    A = diag(b_original);
    for i = 2:n
        A(i, i-1) = a_original(i);
    end
    for i = 1:n-1
        A(i, i+1) = c_original(i);
    end

    // Verificação dos resultados (AX ≈ d)
    printf("\nVerificação dos resultados (A*X ≈ d):\n");
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
    

    printf("\n Erro absoluto (A*X - d):\n");
    erro = A * X - d_original;
    disp(erro);

    printf("\n ********** TDMA FINALIZADO **********\n");
endfunction

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

// Problema 1.1 - Resolver os sistemas por 1) Método de Gauss: e 2) LU:
//------------------------------Sistemas----------------------------
// Sistema S₃ - Exemplo 1
// x1 + x2 + x3 = 1
// 2x1 + x2 − x3 = 0
// 2x1 + 2x2 + x3 = 1

//A = [1.0, 1.0, 1.0;     2.0, 1.0, -1.0; 2.0, 2.0, 1.0];
//B = [1.0; 0.0; 1.0];
//sistemaS3111 =gauss_sem_pivoteamento(A,B); //chamada de funções
//sistemaS3111 = lu_crout(A,B); //chamada de metódos

// Sistema S₃ - Exemplo 2
// x1 + x2 + x3 = −2
// 2x1 + x2 − x3 = 1
// 2x1 − x2 + x3 = 3

//A = [1.0, 1.0, 1.0;     2.0, 1.0, -1.0;     2.0, -1.0, 1.0];
//B = [-2.0; 1.0; 3.0];
//sistemaS3112 =gauss_sem_pivoteamento(A,B); //chamada de funções
//sistemaS3112 = lu_crout(A,B); //chamada de metódos

// Sistema S₃ - Exemplo 3
// x1 + 10x2 + 3x3 = 27
// 4x1 + x3 = 6
// 2x1 + x2 + 4x3 = 12

//A = [1.0, 10, 3.0;     4.0, 1.0, 0.0;     2.0, 1.0, 4.0];
//B = [27.0; 6.0; 12.0];
//sistemaS3113 =gauss_sem_pivoteamento(A,B); //chamada de funções
//sistemaS3113 = lu_crout(A,B); //chamada de metódos

// Sistema S₄
// 1,0x1 + 0,2x2 + 1,0x3 + 0,3x4 = 4,0
// 0,3x1 + 2,0x2 − 0,3x3 − 0,9x4 = 7,5
// 0,0x1 + 2,0x2 − 0,3x3 + 0,8x4 = 4,4
// 0,6x1 + 3,2x2 − 1,8x3 + 0,4x4 = 10

//A = [0.1, 0.2, 1.0,0.3;   0.3, 2.0, -0.3,-0.9;   4.0, 2.0, -0.3, 0.8;  0.6, 3.2, -1.8, 0.4];
//B = [4.0; 7.5; 4.4; 10.0];
//sistemaS3114 =gauss_sem_pivoteamento(A,B); //chamada de funções
//sistemaS3114 = lu_crout(A,B); //chamada de metódos

// Problema 1.2 - Resolver sistemas tridiagonais pelo método de Thomas (TDMA)
//------------------------------Sistemas----------------------------
// Sistema S₄ - Exemplo 1
// 20x1 − 5x2           = 1100
// −5x1 + 15x2 − 5x3     = 100
//       −5x2 + 15x3 − 5x4 = 100
//             −5x3 + 19x4 = 100
//a = [0; -5; -5; -5]; // começa com zero
//b = [20; 15; 15; 19];
//c = [-5; -5; -5; 0]; // termina com zero
//d = [1100; 100; 100; 100];
//sistemaS4121 = tdma_thomas(a,b,c,d); //chamada de funções

// Sistema S₄ - Exemplo 2
// −x1 + 3x2 − x3     = 1
// −x2 + 3x3 − x4     = 1
// −x3 + 3x4          = 2
//a = [0; -1; -1; -1];
//b = [3; 3; 3; 3];
//c = [-1; -1; -1; 0];
//d = [2; 1; 1; 2];
//sistemaS4122 = tdma_thomas(a,b,c,d); //chamada de funções

// Problema 1.3 - Resolver sistemas com métodos iterativos Gauss-Jacobi e Gauss-Seidel as soluções com 6 casas decimais de precisão:
// Sistema S₃ - Exemplo 1
// 10x + y + z     = 12
// x + 5y + 9z     = 15
// 2x + 8y − 4z    = 6
//A = [10, 1.0, 1.0;   1.0, 5.0, 9.0;   2.0, 8.0, -4.0];
//B = [12; 15; 6.0];
//sistema131 = gauss_jacobi_guloso(A, B, 1e-6, 100)
//sistema131 = gauss_seidel_guloso(A, B, 1e-6, 100)


// Sistema S₃ - Exemplo 2
// 6x − y + z      = 7
// x + 8y − z      = 16
// x + y + 5z      = 18
//A = [6.0, -1.0, 1.0;   1.0, 8.0, -1.0;   1.0, 1.0, 5.0];
//B = [7; 16; 18];
//sistema132 = gauss_jacobi_guloso(A, B, 1e-6, 100)
//sistema132 = gauss_seidel_guloso(A, B, 1e-6, 100)


// Sistema S₃ - Exemplo 3
// x₁ + 10x₂ + 3x₃ = 27
// 4x₁ + x₃        = 6
// 2x₁ + x₂ + 4x₃  = 12
//A = [1.0, 10.0, 3.0;   4.0, 0.0, 1.0;   2.0, 1.0, 4.0];
//B = [27; 6; 12];
//sistema133 = gauss_jacobi_guloso(A, B, 1e-6, 100)
//sistema133 = gauss_seidel_guloso(A, B, 1e-6, 100)


// Sistema S₃ - Exemplo 4
// 7x + y − z      = 13
// x + 8y + z      = 30
// 2x − y + 5z     = 21
//A = [7.0, 1.0, -1.0;   1.0, 8.0, 1.0;   2.0, -1.0, 5.0];
//B = [13; 30; 21];
//sistema134 = gauss_jacobi_guloso(A, B, 1e-6, 100)
//sistema134 = gauss_seidel_guloso(A, B, 1e-6, 100)

// Sistema S₂
// 5x − y          = 13
// 2x + 4y         = 14
//A = [5.0, -1.0;   2.0, 4.0];
//B = [13; 14];
//sistema135 = gauss_jacobi_guloso(A, B, 1e-6, 100)
//sistema135 = gauss_seidel_guloso(A, B, 1e-6, 100)


//Sistema S₄ (repetido da imagem anterior)
// 0,1x₁ + 0,2x₂ + 1,0x₃ + 0,3x₄ = 4,0
// 0,3x₁ + 2,0x₂ − 0,3x₃ − 0,9x₄ = 7,5
// 4,0x₁ + 2,0x₂ − 0,3x₃ + 0,8x₄ = 4,4
// 0,6x₁ + 3,2x₂ − 1,8x₃ + 0,4x₄ = 10
//A = [0.1, 0.2, 1.0, 0.3; 0.3, 2.0, -0.3, -0.9; 4.0, 2.0, -0.3, 0.8; 0.6, 3.2, -1.8, 0.4];
//B = [4.0; 7.5; 4.4; 10.0];
// sistema136 = gauss_jacobi_guloso(A, B, 1e-6, 100)
// sistema136 = gauss_seidel_guloso(A, B, 1e-6, 100)

// Problema 2.1 - Dieta de vitaminas:
//     - Sistema baseado em 3 alimentos (I, II e III) com vitaminas A, B e C
//     - Ingerir combinação que satisfaça 170u A, 180u B, 140u C
//     - Resolver o sistema por todos os métodos (Gauss, LU, TDMA se aplicável, Jacobi, Seidel)
// 1x₁ + 9x₂ + 2x₃ = 170
// 10x₁ + 1x₂ + 2x₃ = 180
// 1x₁ + 0x₂ + 5x₃  = 140
// A = [1.0, 9.0, 2.0; 10.0, 1.0, 2.0; 1.0, 0, 5.0];
// B = [170; 180; 140];
// sistema21 = gauss_sem_pivoteamento(A, B)
// sistema21 = lu_crout(A, B)
// sistema21 = gauss_jacobi_guloso(A, B, 1e-6, 100)
// sistema21 = gauss_seidel_guloso(A, B, 1e-6, 100)
//O TDMA não pode ser aplicado neste caso pois a matriz do sistema não é tridiagonal e existem elementos significativos fora das três diagonais centrais. O método TDMA é projetado especificamente para sistemas com padrão tridiagonal estrito, o que não se aplica neste caso.

// Problema 2.2 - Produção de 4 tipos de PCs com restrições de recursos:
//3x₁ +  4x₂ +  7x₃ + 20x₄ = 504      (mão de obra)  
//20x₁ + 25x₂ + 40x₃ + 50x₄ = 1970    (metais)  
//10x₁ + 15x₂ + 20x₃ + 22x₄ = 970     (plásticos)  
//10x₁ +  8x₂ + 10x₃ + 15x₄ = 601     (componentes)

//A = [3, 4, 7, 20;     20, 25, 40, 50;     10, 15, 20, 22;    10, 8, 10, 15];
//B = [504; 1970; 970; 601];

//sistemaS3112 =gauss_sem_pivoteamento(A,B); 
//sistemaS3112 = lu_crout(A,B); //chamada de metódos
//gauss-jacobi não converge porque a matriz não é nem pode se tornar diagonal dominante
//gauss-seidel não converge porque a matriz não é nem pode se tornar diagonal dominante
//O método TDMA (Thomas Algorithm) é uma solução eficiente e direta para sistemas lineares cuja matriz dos coeficientes é tridiagonal, ou seja, possui elementos diferentes de zero apenas na diagonal principal, na diagonal abaixo e na diagonal acima dela. 
//nesse exemplo 2.2 possui diversos elementos fora dessas três diagonais principais. Isso descaracteriza a matriz como tridiagonal. Portanto: Não atende ao pré-requisito estrutural do método TDMA.

// Problema 2.3 - Transporte de cargas por 3 tipos de caminhões (C1, C2, C3)
// 1x₁ + 1x₂ + 1x₃ = 12     (Carga A)
// 0x₁ + 1x₂ + 2x₃ = 10     (Carga B)
// 2x₁ + 1x₂ + 1x₃ = 16     (Carga C)

//A = [ 1, 1, 1; 0, 1, 2; 2, 1, 1];
//B = [12; 10; 16];
//sistemaTransp = gauss_sem_pivoteamento(A,B); 
//sistemaTransp = lu_crout(A,B);
//sistemaTransp = gauss_seidel_guloso(A,B,0.000001,100);
//sistemaTransp = gauss_jacobi_guloso(A,B,0.000001,100);
//TDMA não se aplica aqui pois a matriz A não é tridiagonal.
//Os métodos Gauss-Jacobi e Gauss-Seidel também não são aplicados, pois não existem permutações que transforme ele em diagonal dominante, para aplicar o Critério das Linhas.
//O método TDMA não se aplica aqui pois a matriz A não é tridiagonal.

// Problema 2.4 - Estoque de ferramentas:
// 3m + 2c -  a +  s = 10
// 2m - 2c + 4a - 3s = 6
//  m +  c +  a -  s = 7
// 2m + 3c +  a + 4s = 15

A = [3,  2, -1,  1; 2, -2,  4, -3; 1,  1,  1, -1; 2,  3,  1,  4]
B = [10; 6; 7; 15]

//x = gauss_sem_pivoteamento(A,B)
x = lu_crout(A,B)
//Métodos iterativos de Gauss-Jacobi e Gauss-Seidel não convergem pois o sistema não possui diagonal dominante, mesmo após a reordenação gulosa. 
//gauss-seidel não converge porque a matriz não é nem pode se tornar diagonal dominante
//gauss-jacobi não converge porque a matriz não é nem pode se tornar diagonal dominante