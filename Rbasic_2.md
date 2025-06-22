---
title: "Básico de R - parte 2"
author: "Joyce"
output: html_document
---

## o que são pacotes (ou bibliotecas)?

Pacotes são coleções de funções prontas que ajudam a fazer tarefas específicas. Por exemplo:

* ggplot2 — para gráficos elegantes

* dplyr — para manipular dados

* readr — para ler arquivos

Antes de usar um pacote, você precisa:

1. Instalar (apenas uma vez):
```{r}
install.packages("ggplot2")
```
2. Carregar (toda vez que vocês for usar):
```{r}
library(ggplot2)
```

## o que são funções?

Funções são comandos prontos que fazem alguma coisa pra você. Elas seguem a estrutura:

```{r}
nome_da_função(argumento1, argumento2, ...)
```

Por exemplo:

```{r}
mean(c(1, 2, 3, 4))  # calcula a média de 1, 2, 3 e 4
```
mean é o nome da função.

c(1, 2, 3, 4) é o argumento (um vetor de números).

As funções economizam tempo e organizam o que você precisa fazer. Há centenas delas no R — e você pode até criar as suas próprias ou usar de outras pessoas

## O que são argumentos de uma função?

Quando usamos uma função no R, precisamos passar para ela as informações necessárias para que ela saiba o que fazer. Essas informações são chamadas de argumentos — pense nelas como as etapas de um experimento.
```{r}
round(3.14159, digits = 2)
```
Nesta linha de código:

* round() é a função que arredonda números.

* 3.14159 é o número que será arredondado.

* digits = 2 diz à função que queremos 2 casas decimais no resultado.

### Argumentos por posição
Você também pode passar os argumentos pela ordem esperada pela função:
```{r}
round(3.14159, 2)
```

* O R entende que o primeiro valor (3.14159) é o número a ser arredondado.

* O segundo valor (2) é o número de casas decimais.

Isso funciona porque estamos seguindo a ordem padrão que a função espera.

round(digits = 2, x = 3.14159)

### Argumentos nomeados
Você também pode escrever os nomes dos argumentos explicitamente — e nesse caso, a ordem não importa:

```{r}
round(digits = 2, x = 3.14159)
```
Esse exemplo faz exatamente a mesma coisa, só que agora está mais claro o que significa cada valor:

digits = 2 → número de casas decimais

x = 3.14159 → o número a ser arredondado

Por que essa diferença importa?
Quando estamos aprendendo funções novas — especialmente as que têm vários argumentos — é muito mais seguro e claro usar argumentos nomeados. Isso ajuda a:

* entender melhor o que cada parte do código faz

* evitar confusões se esquecermos a ordem exata

* deixar o script mais legível para outras pessoas (ou para nós no futuro!).