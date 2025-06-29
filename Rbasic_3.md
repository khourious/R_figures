---
title: "Dados no R"
author: "Joyce"
output: html_document
---

# Introdução

aqui nós veremos os tipos de dados mais comuns de trabalhar no R.

## O que são dados?

No R, os dados geralmente são organizados em tabelas (data frames), que parecem planilhas de Excel. Cada coluna representa uma variável (idade, nome, altura...) e cada linha representa uma observação (uma pessoa, um animal, um experimento...).

Você pode criar dados manualmente:

|Tipo	  |Exemplo	                            | Descrição                                                                 |
|:-------:|-------------------------------------|---------------------------------------------------------------------------|
|Numérico |	x <- 3.14                           | Números com ou sem decimais (ex: 10, 2.5)                                 |
|Inteiro  |	x <- 5L	                            | Números inteiros (o L indica "integer")                                   |
|Caracter |	cidade <- "Salvador"                | Texto (também chamado de string)                                          |
|Lógico   |	ativo <- TRUE                       | Verdadeiro ou falso (TRUE ou FALSE)                                       |
|Fator    |	sexo <- factor(c("F", "M", "F"))    | Valores categóricos (muito usados em estatística)                         |
|Complexo |	z <- 2 + 3i	                        | Números complexos com parte imaginária                                    |
|Data     |	hoje <- as.Date("2025-06-21")       | Datas reconhecidas como tipo próprio                                      |

Já vimos alguns desses, mas e sobre tabelas? São todas a mesma coisa?

Se você já trabalhou com o R sabe que não

# Data frame

Um data.frame é como uma planilha de Excel: cada coluna é uma variável e cada linha é uma observação.
Você pode importar do seus dados pessoais ou construir dentro do R.

Para importar:
```{r}
#instalar um pacote de leitura de dados de excel
install.packages("readxl") #lembre das aspas

#carregar a biblioteca
library(readxl)

#importar
tabela_01 <- read_excel("tabela_01.xlsx")
```
Se o arquivo for em .csv (separado por vírgulas), não precisa de muito esforço:

```{r}
tabela_01 <- read.csv("tabela_01.csv")
```
Você também pode usar:

```{r}
tabela_01 <- read.csv2("meuarquivo.csv", sep = ";")  # quando o separador é ponto e vírgula
```

Para construir:

```{r}
tabela_01 <- data.frame(
  nome = c("Ana", "Bruno", "Carlos"),
  idade = c(25, 30, 28),
  altura = c(1.65, 1.82, 1.74)
)
```

vai aparecer um data frame tipo assim:

| nome    | idade  | altura |
|:-------:|--------|--------|
| Ana     |   25   |  1.65  |
| Bruno   |   30   |  1.82  |
| Carlos  |   28   |  1.74  |

Normalmente, anotamos data frames como `df`.

### Preciso lembrar de todos os códigos? 
Na verdade, não.

Conforme vai usando, você vai se lembrar das coisas que mais usa, sempre pode perguntar a uma IA como fazer essas coisas ou voltar a esse material para se lembrar.

Importar dados é uma atividade rotineira, você vai lembrar de algum caminho.

# Matriz
Uma matriz é uma tabela só de números (ou de um único tipo de dado), organizada em linhas e colunas, como em matemática.

```{r}
m <- matrix(1:9, nrow = 3, ncol = 3)
```

# Lista
Uma lista é um “bolsão” que pode guardar qualquer coisa: números, textos, vetores, data.frames, até funções!

Pense numa lista de compras:
1. Sabão
2. Amacianete
3. Maçã
4. Laranja
5. Biscoito
6. Pão
7. Azeite
8. Frango
9. Shampoo
10. Sabonete

Perceba que os itens não fazem parte das mesmas categorias (comida, itens de limpeza, produtos de higiene), mas todos estão na mesma lista. 

Funciona de forma similar no R:

```{r}
minha_lista <- list(Cidade = "Salvador", idade = 476, Praias = c(Barra, Itapuã, Piatã, Ribeira))
```
# Fator
Um fator é usado para representar variáveis categóricas, como “sexo”, “estado civil”, “resposta: sim/não”. Por trás, o R trata esses valores como níveis numéricos com nomes.

```{r}
genero <- factor(c("Feminino", "Masculino", "Feminino"))
```

O R entende isso como uma variável com dois níveis: “Feminino” e “Masculino”.

Fatores são essenciais em análises estatísticas porque eles tratam categorias como níveis diferenciados, e não apenas texto qualquer.

# Resumo

|Tipo de Estrutura	| O que é	|Exemplo simples |
|:-------:|--------|---------|
|Data frame	|Tabela com colunas (variáveis) e linhas (observações)	 | dados <- data.frame(nome, idade)|
|Matriz	|Tabela com apenas um tipo de dado (tudo número, por exemplo) |	matrix(1:6, nrow = 2)|
|Lista	|Uma coleção de objetos diferentes (texto, vetores, funções…) |	lista <- list(nome, idade, notas)|
|Fator	|Variável categórica com níveis definidos |	factor(c("sim", "não", "sim"))|

## Por que é importante?

Existem alguns motivos:

Determinadas funções só funcionam com um tipo especifico de dados

A forma de usar os dados muda de acordo com o formato deles

```{r}
minha_lista@

tabela_01$nome #vai mostrar a tabela e a coluna nome
```

## Como mudar o formato?

A gente usa funções como `as.data.frame`

```{r}
m #nossa matriz

dataframe_m <- as.data.frame(m) 

dataframe_m #transformei matriz em tabela
```

funciona de forma similar com:

`as.matriz`

```{r}
matriz <- as.matrix(df)
```
`as.factor`

```{r}
respostas <- c("sim", "não", "sim", "talvez")
respostas_fator <- as.factor(respostas)
```
A saída será algo como:

```{r}
[1] sim    não    sim    talvez
Levels: não sim talvez
```

Isso é muito importante em análises estatísticas porque o R trata fatores de forma especial, como variáveis categóricas com níveis ordenados ou não, o que afeta como elas aparecem em gráficos, tabelas, e modelos estatísticos.

# Como ver meus dados? 

```{r}
str(tabela_01)
summary(tabela_01)
head(tabela_01)
tail(tabela_01)
```

A saída do `str(tabela_01)` mostra a estrutura interna do objeto. Indica o tipo de cada coluna, o número de observações e uma amostra dos dados.

```{r}
'data.frame':   3 obs. of  3 variables:
 $ nome  : chr  "Ana" "Bruno" "Carlos"
 $ idade : num  25 30 28
 $ altura: num  1.65 1.82 1.74
```

Você vê que `nome` é caractere (chr), e que idade e altura são numéricos (num).

A saída do `summary(tabela_01)` é perfeito pra entender rapidamente como estão distribuídos os dados.

```{r}
     nome              idade         altura     
 Length:3           Min.   :25.0   Min.   :1.650  
 Class :character   1st Qu.:26.5   1st Qu.:1.695  
 Mode  :character   Median :28.0   Median :1.740  
                    Mean   :27.7   Mean   :1.737  
                    3rd Qu.:29.0   3rd Qu.:1.780  
                    Max.   :30.0   Max.   :1.820 
```
`head(tabela_01)` mostra as primeiras linhas da tabela (por padrão, as 6 primeiras linhas; no seu caso, mostra todas porque há só 3) e `tail(tabela_01)` mostra as últimas linhas da tabela:

```{r}
   nome idade altura
1   Ana    25   1.65
2 Bruno    30   1.82
3 Carlos   28   1.74
```

É útil pra espiar os dados sem precisar mostrar tudo de uma vez.