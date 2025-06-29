---
title: "Dados no R"
author: "Joyce"
output: html_document
---

# Introdução

Pacotes no R são como “caixinhas de ferramentas” que outras pessoas criaram para facilitar a vida de quem programa em R.

Por padrão, o R vem com várias funções básicas. Mas se você quiser fazer gráficos bonitos, importar arquivos do Excel ou analisar textos, vai precisar instalar pacotes específicos.

Já vimos pacotes anteriormente, aqui iremos explorar melhor

# Relembrando

Como instalar e carregar:

```{r}
# Instala o pacote (só precisa fazer uma vez)
install.packages("ggplot2")

# Carrega o pacote para usar (toda vez que abrir o R)
library(ggplot2)
```

instalar um pacote é como baixar um aplicativo no celular. Carregar o pacote com `library()` é como abrir esse aplicativo para usar.

Normalmente, as dúvidas sobre os pacotes são sobre como encontrar qual eu preciso e como entender, vamos tentar ajudar com isso.

# Buscando pacotes

você pos buscar no seu navegador coisas como:
* "heatmap in R"
* "create graphic in R"
* "how to make a heatmap in R"
* "Packages for heatmap in R"

ou pedir para alguma IA te forncer o código para fazer o seu mapa de calor, vou te dar os exemplos de alguns prompts:

* "Quero fazer um heatmap no R. Gere o código completo e explique cada linha" > Dessa maneira ele não só vai te fornecer o código, como você vai poder entender cada etapa e alterar conforme deseja
* "Me mostre pacotes para fazer graficos de mapa de calor no R" > assim ele te fornece uma lista dos pacotes mais usados
* "Estou trabalhando com ggplot2 no R, quero fazer um mapa de calor, me explique como fazer sabendo que no eixo x estão os dias da semana e no eixo y estão os horários" > dessa maneira você direciona melhor para que o código seja mais próximo de como você quer que seja o seu gráfico

# ggplot2

O ggplot2 é um pacote do R usado para criar gráficos de forma poderosa e elegante. Ele segue a chamada “gramática dos gráficos”, ou seja: você monta o gráfico peça por peça, como se estivesse escrevendo frases com sentido.

Esse pacote se destaca porque te dá controle total sobre o gráfico: você decide cada parte — eixos, cores, tipos de visualização, títulos, legendas… tudo pode ser adicionado e ajustado com camadas. Isso torna seus gráficos mais personalizados e informativos.

o PDF da documentação:
https://cran.r-project.org/web/packages/ggplot2/ggplot2.pdf

Aqui o link para o site:
https://ggplot2.tidyverse.org/

E aqui o link para o livro:
https://ggplot2-book.org/

Nesse documento iremos explicar um pouco sobre o pacote, mas primeiro:

## Como ler uma documentação de um pacote do R

Assim como dissertações, teses e artigos científicos tem seções do texto bem definidas, documentos do R também tem:

1. Title page (primeira página)

Mostra o nome do pacote, a versão, autores, data da documentação, dependências

2. Índice (Table of Contents)
Lista todas as funções do pacote em ordem alfabética. Cada uma terá uma seção específica com a documentação detalhada.

3. Documentação de cada função
Cada página seguinte descreve uma função. A estrutura segue sempre este padrão:


|Seção	| Explicação|
|:-------:|--------|
|Name       	|Nome da função|
|Description |O que a função faz, em uma ou duas frases|
|Usage   	|A sintaxe (como você escreve a função no R)|
|Arguments	| Explicação de cada argumento da função|
|Details	| Explicações adicionais, regras específicas, contexto|
|Value	    | O que a função retorna ao final|
|Examples	| Exemplos práticos de uso com código R|

Algumas funções terão também See `Also`, `Author`, `Note`, `References`.

### Como usar esse PDF na prática
Use Ctrl + F (ou Command + F no Mac) para buscar uma função específica, como geom_point.

Leia primeiro a Description e os Examples para entender rápido.

Se tiver dúvidas sobre um argumento, vá na seção Arguments — geralmente é muito direto.

Se quiser estudar a fundo, vale ver a seção Details, que costuma explicar a “filosofia” da função.

### Exemplo: geom_boxplot

Escolhi aleatoriamente o geom_boxplot do meu index da documentação do R. Aparece assim:

 |geom_boxplot *A box and whiskers plot (in the style of Tukey)*|
 

 **Description**

 The boxplot compactly displays the distribution of a continuous variable. It visualises five summary
 statistics (the median, two hinges and two whiskers), and all "outlying" points individually

 *Tradução*:

 **Descrição**

O boxplot exibe de forma compacta a distribuição de uma variável contínua. Ele visualiza cinco estatísticas resumidas
(a mediana, duas dobradiças e dois bigodes) e todos os pontos "extraordinariamente" individualmente.

#### Até ai nada novo sobre box plots, certo?

 **Usage**

```{r}
geom_boxplot(
 mapping = NULL,
 data = NULL,
 stat = "boxplot",
 position = "dodge2",
 ...,
 outliers = TRUE,
 outlier.colour = NULL,
 outlier.color = NULL,
 outlier.fill = NULL,
 outlier.shape = 19,
 outlier.size = 1.5,
 outlier.stroke = 0.5,
 outlier.alpha = NULL,
 notch = FALSE,
 notchwidth = 0.5,
 staplewidth = 0,
 varwidth = FALSE,
 na.rm = FALSE,
 orientation = NA,
 show.legend = NA,
 inherit.aes = TRUE
 )
 ```

 ### E agora?

 Bem, é nesse momento que acontece o desespero e as pessoas geralmente fecham o R.

 Vou tentar traduzir.

Todos esses itens que aparecem entre parênteses são **opções (argumentos)** que você pode usar ao construir o gráfico com `geom_boxplot()`. Nenhum deles é obrigatório, mas todos estão ali para você personalizar o gráfico do seu jeito — cores, formas, tamanho dos pontos, presença de outliers e assim por diante.

Se você respirar fundo e for explorando a documentação com calma, vai perceber que logo abaixo da sintaxe vem a seção chamada **Arguments**. Ali está a explicação detalhada de cada um desses parâmetros — o que eles fazem e quais valores aceitam. Basta um pouco de atenção e curiosidade para começar a entender o que faz sentido para o seu gráfico e o que pode ser ignorado.

Um detalhe bom: esses argumentos são bastante parecidos entre as funções gráficas do ggplot2. Ou seja, se você aprende como funciona no `geom_boxplot()`, já terá meio caminho andado para usar `geom_violin()`, `geom_point()`, `geom_bar()` etc.

Se estiver com pressa, cansado ou sem paciência para interpretar tudo sozinho, uma dica prática é: copie esse pedaço da documentação e cole em uma IA como esta aqui. Você pode pedir algo como:

> "Explique cada argumento do geom_boxplot()" > 

> "Crie um gráfico de boxplot com minhas variáveis X e Y e destaque os outliers com cor vermelha."



## Como entender o site de um pacote do R

Se tiver sorte, o pacote que você quer usar vai ter um site mais amigavél e simples de entender que seguem alguns padrões, aqui algumas dicas de como navegar:

1. Title / Description
Um resumo do que o pacote faz.

* Exemplo (ggplot2): *“Create Elegant Data Visualisations Using the Grammar of Graphics.”*

2. Overview
* Pequeno resumo do pacote e seu obejtivo

3. Index
Uma lista com todas as funções e datasets internos disponíveis no pacote.

* Clicável: você pode explorar as funções uma a uma a partir daqui.

* Se você não sabe o nome da função ainda, aqui é o melhor lugar pra fuçar.

4. Installation
* Essa seção explica como instalar o pacote no seu R.

```{r}
# The easiest way to get ggplot2 is to install the whole tidyverse:
install.packages("tidyverse")

# Alternatively, install just ggplot2:
install.packages("ggplot2")

# Or the development version from GitHub:
# install.packages("pak")
pak::pak("tidyverse/ggplot2")
```
5. Usage

* Aqui o foco é mostrar como usar o pacote. Pode incluir funções principais, estrutura básica ou exemplos simples. Exemplo:

```{r}
library(ggplot2)

ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point()
```

6. Vignettes ou Get Started

* São tutoriais prontos mostrando como usar o pacote na prática.

# O que é o *Help* dentro do R?