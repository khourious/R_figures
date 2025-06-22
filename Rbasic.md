---
title: "Básico de R - parte 1"
author: "Joyce"
output: html_document
---

# Introdução

"R é um software livre e vem sem GARANTIA ALGUMA.
Você pode redistribuí-lo sob certas circunstâncias.
Digite 'license()' ou 'licence()' para detalhes de distribuição."

## O Ciclo Natural da Programação: Ler, Entender e Escrever
Ao começar em R (ou em qualquer linguagem de programação), passamos por três habilidades fundamentais:

1. Ler Código:

No início, você vai se deparar com códigos prontos. 

Ler é o primeiro passo para se familiarizar com a lógica, os comandos e a forma como o R “fala”.
Exemplo: entender o que significa:  `mean(c(1, 2, 3))`.

2. Entender Código:

Aqui você começa a saber por que aquele código está ali, o que ele faz e como ele se conecta com os dados. 
Exemplo: perceber que `mean()` calcula a média e `c(1, 2, 3`) cria um vetor (e o que é um vetor?)

3. Escrever Código:

O ápice do aprendizado! 
Com prática, você começa a escrever seus próprios scripts e funções — seja para fazer gráficos, análises ou automatizar tarefas.
Exemplo: criar um gráfico com `plot(x, y)` e ajustar os parâmetros do jeito que você quiser.

## Objetivos do Curso

O curso é feito para iniciantes, então vamos focar no básico do R.
O objetivo é saber ler e executar o código, entender o que ele faz e fornecer diversos códigos para produção de gráficos com o máximo de comentários e explicações para que possa editar conforme necessite.
Codar exige prática, e programadores não têm problemas em compartilhar ou 'reaproveitar' códigos. Use os recursos disponíveis: IA (DeepSeek, Copilot, ChatGPT, Gemini), fóruns, GitHub etc.

## Entendendo a Sintaxe

Vou explicar como funciona a lógica de um código em R e como você deve "ler" essas informações.
É importante saber que R foi feito por matemáticos e estatísticos, então a sintaxe é bem direta e objetiva e não tem o mesmo padrão que outras linguagens de programação como Python ou JavaScript.
Conforme avançamos a leitura vai ficando mais complexa, mas a lógica é sempre a mesma:

## Código em R

1. Comentários
```{r}
# Tudo que começa com # é um comentário e não é executado
# Isso serve para explicar o que o código faz
# ou para deixar anotações ou lembretes
# ou para desativar uma linha de código
# ou para deixar um código mais legível ou organizado
```
2. Atribuição de Valores
```{r}
x <- 10  # A forma mais comum de atribuição
y = 20   # Também funciona
```

O que significa <-?

Essa seta é usada para atribuir um valor a um objeto. É como dizer: “coloque esse valor aqui dentro dessa caixinha”.
ou "x agora vale 10 e y agora vale 20". 

Mas a seta "<-" é a forma tradicional e mais usada pela comunidade R, especialmente em estatística e ciência de dados. É como uma tradição da linguagem — muitos dizem que a seta aponta de onde vem o valor e para onde ele vai.

No teclado, para fazer <-, você digita < e depois -, e o R automaticamente entende como uma atribuição.

3. Tipos de dados
```{r}
# Existem vários tipos de dados em R, mas os mais comuns são:
# Números
x <- 10.5  # Números decimais
y <- 5     # Números inteiros
# Texto (chamamos de "strings")
nome <- "meu nome é:"  # Texto entre aspas (complete com seu nome)
# Lógicos (booleanos)
verdadeiro <- TRUE  # Verdadeiro
falso <- FALSE  # Falso
# Vetores
idades <- c(25, 30, 35)  # Vetor de números
```
O que é um vetor em R? Um vetor é como uma fileirinha de valores do mesmo tipo. Ele é a estrutura mais simples e mais usada no R. 
Pensa nele como uma caixinha que guarda vários números, textos ou valores lógicos em sequência.
Ele é muito usado porque permite trabalhar com vários valores de uma vez só, facilitando operações matemáticas e manipulação de dados.

```{r}
# Criando um vetor de números
idade <- c(5, 10, 15)

# Criando um vetor de textos
nomes <- c("Ana", "Bruno", "Carlos")
```

O c() é uma função que significa "combine" ou "concatenate", usada para criar vetores.
Todos os elementos de um vetor devem ser do mesmo tipo. Se não utilizar o c(), o R não vai entender que você quer criar um vetor e vai dar erro.
Quando você usa c(), o R entende que você está juntando esses valores em um único objeto, formando um vetor.
Quando usar o c()?
Sempre que você quiser criar um vetor com VÁRIOS valores, seja números, textos ou lógicos.

R diferencia TUDO

Quando falamos ou escrevemos com outras pessoas, entedemos pequenos erros, variações de linguagem e escritas erradas. *O R não é assim.*

No R, "idade", "Idade", "idades" e "Idades" são nomes completamente diferentes. Isso porque a linguagem é case-sensitive (sensível a maiúsculas e minúsculas).
E cada variável deve ser única dentro do mesmo ambiente de trabalho, ou seja cada vez que eu escrevo de um jeito diferente, eu crio um objeto novo. Isso é importante porque evita confusões e garante que você saiba exatamente qual variável está usando.

Por isso, crie nomes de variáveis que façam sentido e sejam fáceis de lembrar e sejam diferentes o suficiente para que VOCÊ possa trabalhar

4. Variáveis

No R (e em praticamente todas as linguagens de programação), espaços em nomes de variáveis não são permitidos. Se você tentar escrever:
```{r}
idade do paciente <- 25
```
O R vai dar erro, porque ele vai entender que você está tentando usar a variável idade, chamar a função do, acessar paciente… uma confusão total.

Você pode usar o underline (_) ou o ponto (.) ou camelCase para separar palavras em nomes de variáveis, como:

```{r}
idade_do_paciente <- 25
idade.do.paciente <- 25
IdadeDoPaciente <- 25
```
 Ou seja, sempre que for criar uma variável, evite espaços e use caracteres permitidos.
  Perceba que mesmo cada jeito de escrever são aceitáveis, mas cada um cria uma variável diferente.

Outras dicas para nomes de variáveis:

* Comece com letra (nunca com número!)

* Evite acentos e caracteres especiais

* Seja descritivo, mas sem exagerar no tamanho

Escreva de forma simples e padronizada. Quanto mais clara for sua variável, mais fácil será reutilizá-la.

se_for_muito_longa_é_ruim_de_reutilizar

| Ícone | Verificação                                | Descrição                                                                 |
|:-----:|--------------------------------------------|---------------------------------------------------------------------------|
| 🔤    | Nomes claros e consistentes                | Evite abreviações confusas. Use nomes como `idade_total`, `dados_paciente`. |
| 🚫    | Sem espaços em variáveis                   | Use `_`, `.` ou `camelCase`. Ex: `idade_do_paciente` ou `IdadePaciente`.  |
| 🔠    | Maiúsculas e minúsculas importam           | `idade` ≠ `Idade`. O R diferencia tudo.                                   |
| 📦    | Use `c()` para criar vetores               | Junta vários valores num mesmo objeto.                                   |
| 📝    | Comente seu código com `#`                 | Explicações ajudam a lembrar e entender.                                  |
| ❓    | Peça ajuda quando precisar                 | Explore fóruns/IA.                                                        |
| 🧹    | Organize com seções e comentários          | Deixe seu script limpo e fácil de revisar depois.                         |

