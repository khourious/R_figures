install.packages("UpSetR")
install.packages("dplyr")
library(UpSetR)
library(dplyr)

#antes de tudo devemos configurar qual vai ser nossa pasta de trabalho
setwd("caminho/para/sua/pasta/de/trabalho")

#carregamos as tabelas com os genes DE de cada condição
tabela1 <- read.table("condicao_A_DEgenes.txt", header = TRUE)
tabela2 <- read.table("condicao_B_DEgenes.txt", header = TRUE)
tabela3 <- read.table("condicao_C_DEgenes.txt", header = TRUE)
tabela4 <- read.table("condicao_D_DEgenes.txt", header = TRUE)
tabela5 <- read.table("condicao_E_DEgenes.txt", header = TRUE)

#para fazer um upset plot é preciso de uma lista com os genes de cada condição
# para criart uma lista criamos o objeto x que armazena a informação
# colocamos list e dentro de list colocamos o nome de cada condição
# e os genes correspondentes a cada condição

x = list (
  "A" = (tabela1$GeneId),
  "B" = (tabela2$GeneId),
  "C" = (tabela3$GeneId),
  "D" = (tabela4$GeneId),
  "E" = (tabela5$GeneId)
)

# neste caso estamos pegando da coluna GeneId de cada tabela
rm(x)

# para fazer o gráfico usamos a função upset
# dentro da função upset usamos a função fromList que converte a lista x

#armazenamos o gráfico na variável p

p <- upset(fromList(x))
p
# para mostrar o gráfico usamos a variável p


# podemos personalizar o gráfico com vários parâmetros
# point.size: tamanho dos pontos
# line.size: tamanho das linhas
# order.by: ordenação das barras (neste caso pela frequência)
# main.bar.color: cor das barras principais
# mainbar.y.label: rótulo do eixo y das barras principais
# text.scale: escala do texto (vários valores para diferentes textos)
# keep.order: manter a ordem das condições como na lista
y <- upset(fromList(x), point.size = 2.5, line.size = 1, order.by = "freq", 
           main.bar.color = "#a50f15", mainbar.y.label = "List of Genes",
           text.scale = c(1.3, 1.3, 1, 1.5, 1.25, 1.75),
           keep.order = TRUE)

y

#para ver mais opções de personalização do gráfico consulte a documentação da função upset
?upset

# para salvar o gráfico em pdf usamos a função pdf
# dentro da função pdf colocamos o nome do arquivo, largura, altura e tamanho da fonte
pdf("upset_genes.pdf", 12, 8, pointsize=20)
y
dev.off()

# para salvar o gráfico em png usamos a função png
# dentro da função png colocamos o nome do arquivo, largura, altura e resolução
png("upset_genes.png", 1200, 800, res=150)
y
dev.off()

# assim podemos criar um upset plot para visualizar a interseção de genes entre diferentes condições
