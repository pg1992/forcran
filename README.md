# ForCran
ForCran é um compilador de códigos fortran 90 para C, com ele é possível compilar:
- [x] declaração de variáveis
- [x] prints, writes e reads
- [x] expressões matemáticas
- [x] expressões condicionais (if, else if, else)
- [x] loops (do)

Além disso o compilador conta com mensagens de erro para te ajudar.

## Usando o ForCran
O ForCran é um software livre, usa a licença GPL, assim qualquer pessoa pode utilizar o programa, seja para estudo ou demais fins próprios.

### Instruções para distribuições Linux (recomendamos o Ubuntu 16:04 ou 14)
Certifique-se de que já tenha o gcc em sua máquina.
Para usa-lo é necessário ter o Bison e o Flex instalados em sua máquina.

```
sudo apt-get update
sudo apt-get install flex
sudo apt-get install bison
```
Atualmente estamos usando as versões:
```
Bison 3.0.4
Flex 2.6.0
```
Em seguida basta copiar o projeto no diretório desejado e entrar no projeto.
Para compilar seu código em C digite:
```
COLOCAR OS COMANDOS DO TERMINAL
```
## Contribuições
Para contribuir com o ForCran faça um fork do projeto, aplique as mudanças desejadas e em seguida envie um pull request para a branch contribution com detalhes explicando sua colaboração e qual o obejtivo da mesma. Não esqueça de testar todos os métodos que você criou. Recomandamos que siga o template abaixo para funções tipo int, float, double e void (transforme a void em int).
### Criando testes
Para criar seus testes siga o template o template de testes abaixo:
```c
//We recomend you to use this template for your tests

void test_method_name() {
	total_tests++;
	int r=0;
	r = method_name();
	if (your_condition) {
		printf("%s\nmethod_name OK\n", KGRN);
		tests_ok++;
	}
	else {
		printf("%s\nmethod_name FAIL\n", KRED);
		tests_fail++;
	}
}

```
Claro que antes de enviar sua contribuição você deve executar os testes da aplicação com o comando: 
```
make tests
```
Ao final do comando é exibido no terminal quais testes passaram e quais falharam.
