clear(); clc()

printf("\n * MÉTODO DIRETO: THOMAS (TDMA) SISTEMAS TRIDIAGONAIS *\N")
a = [0; -1; -1]
b = [2; 2; 2]
c = [-1; -1; 0]
d = [1; 1; 1]

a_original = a
b_original = b
c_original = c
d_original = d

//..........................................................................
// impressão dos dados
printf("\n Vetor a^T: "); disp(a')
printf("\n Vetor b^T: "); disp(b')
printf("\n Vetor c^T: "); disp(c')
printf("\n Vetor d^T: "); disp(d')
 
 
n = length(b)
if b(1) == 0 then
	error("Pivô nulo encontrado na primeira linha. Método falha.")
end

c(1) = c(1) / b(1)
d(1) = d(1) / b(1)

for i = 2:n-1
	temp = b(i) - a(i) * c(i-1)
	if temp == 0 then
		error("Pivô nulo encontrado na linha " + string(i) + " Método falha.")
	end
	c(i) = c(i) / temp
	d(i) = (d(i) - a(i) * d(i-1)) / temp
end

temp = b(n) - a(n) * c(n-1)
if temp == 0 then
	error("Pivô nulo encontrado na úiltima linha. Método falha.")
end

d(n) = (d(n) - a(n) * d(n-1)) / temp

//..........................................................................
// Retrosubstituição
X = zeros(n, 1)
X(n) = d(n)
for i = n-1:-1:1
	X(i) = d(i) - c(i) * X(i + 1)
end

// Impressão da solução
printf("\n Solução X do sistema:\n")
mprintf(" x(%d)  = %.6f\n", [(1:n)', X])

//..........................................................................
// Reconstrução da matriz tridiagonal A para verificação do erro
A = diag(b_original)
for i = 2:n
	A(i, i-1) = a_original(i)
end
for i = 1:n-1
	A(i, i+1) = c_original(i)
end

//Calculo e exibição
printf("\n Erro absoluto (A*X - d):\n")
erro = A * X - d_original
disp(erro)

printf("\n * FIM dO CÓDIGO *\n")

//..........................................................................
