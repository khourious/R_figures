#Baixar e carregar bibliotecas
library(ggplot2)


# Carregar dados

tabela1.results <- read.csv("caminho/até/sua/pasta/tabela1-results.csv")

#Tem que se parecer com isso

head(tabela1.results)
                GeneSymbol log2FoldChange     lfcSE         stat    pvalue      padj
1        MTND2P28  4.19776 0.2028471  0.974936420 0.3295918 0.6714443
2        MTATP6P1  2.00945 0.2275045  0.041568231 0.9668429 0.9896811
3           NOC2L -2.00175 0.1803044 -0.009751421 0.9922196 0.9972435
4            AGRN  3.14302 0.1866087  0.766627832 0.4433028 0.7571559
5 ENSG00000291156 -5.15687 0.2007976 -0.781342157 0.4346013 0.7519092
6        TNFRSF18  1.17188 0.2342967  0.733532734 0.4632336 0.7737059

# Criando categorias de significância
# Classificando genes por significância e direção
tabela1.results$Categoria <- "Não significativo" #cria coluna e insere "Não significativo" como valor padrão em tudo

#Teste lógico
#Se pvalue < 0.05 e log2FoldChange > 0, insere "Up" na coluna Categoria
tabela1.results$Categoria[tabela1.results$pvalue < 0.05 & tabela1.results$log2FoldChange > 0] <- "Up"
#Se pvalue < 0.05 e log2FoldChange < 0, insere "Down" na coluna Categoria
tabela1.results$Categoria[tabela1.results$pvalue < 0.05 & tabela1.results$log2FoldChange < 0] <- "Down"

# Plotando o gráfico simples
#Função ggplot: tabela1.results, aes define os eixos x e y
# -log10: converte os valores de p-value (eixo y) para -log10(p-value)
# as cores são definidas pela coluna Categoria
ggplot(tabela1.results, aes(x = log2FoldChange, y = -log10(pvalue), color = Categoria)) +
  geom_point(size = 2, alpha = 0.7) + #geom_point: adiciona os pontos ao gráfico, alpha define a transparência
  scale_color_manual(values = c("Up" = "#f16913", "Down" = "#2b8cbe", "Não significativo" = "gray")) + #scale_color_manual: define as cores para cada categoria
  theme_gray() + #theme_gray: define o tema do gráfico
  labs(title = "Volcano Plot Simples", 
       x = "log2 Fold Change",
       y = "-log10(p-value)") #labs: adiciona título e rótulos aos eixos

# Se eu quiser adicionar linhas de corte?

# Plotando o gráfico simples com linhas de corte
ggplot(tabela1.results, aes(x = log2FoldChange, y = -log10(pvalue), color = Categoria)) +
  geom_point(size = 2, alpha = 0.7) +
  scale_color_manual(values = c("Up" = "#f16913", "Down" = "#2b8cbe", "Não significativo" = "gray")) +
  geom_vline(xintercept = 0 , linetype = "dashed", color = "red") + #geom_vline: adiciona linha vertical no x=0
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "red") + #geom_hline: adiciona linha horizontal no y=-log10(0.05)
  theme_gray() +
  labs(title = "Volcano Plot Simples com Linhas de Corte",
       x = "log2 Fold Change",
       y = "-log10(p-value)")

# Se eu quiser adicionar rótulos aos pontos mais significativos?

#carregar biblioteca específica para isso
library(ggrepel)

# Teste lógico para criar coluna de rótulos
# Olha a coluna Significativo e se for "Significativo", insere o GeneSymbol na coluna label, senão insere NA
tabela1.results$label <- ifelse(tabela1.results$Significativo == "Significativo",
                             tabela1.results$GeneSymbol, NA)

# Plotando o gráfico com rótulos e linhas de corte
# Color é definido pela coluna Significativo
# Label é definido pela coluna label
ggplot(tabela1.results, aes(x = log2FoldChange, y = -log10(pvalue), color = Significativo, label = label)) +
  geom_point(size = 2, alpha = 0.7) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "black") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "black") +
  geom_text_repel(max.overlaps = Inf, size = 3) + #geom_text_repel: adiciona rótulos aos pontos, max.overlaps evita sobreposição
  scale_color_manual(values = c("gray", "darkgreen")) + #scale_color_manual: define as cores para cada categoria
  theme_minimal() +
  labs(title = "Volcano Plot com Rótulos e Linhas de Corte",
       x = "log2 Fold Change",
       y = "-log10(p-value)")

# Se eu quiser destacar a partir do foldchange?
# Quero escolher ver os 20 maiores Up-regulated e 20 maiores Down-regulated
library(dplyr)
library(ggrepel)
library(ggplot2)

# Classificação por categoria
tabela1.results$Categoria <- "Não significativo"

#Teste lógico para definir categorias
#Se pvalue < 0.05 e log2FoldChange > 0, insere "Up" na coluna Categoria
tabela1.results$Categoria[tabela1.results$pvalue < 0.05 & tabela1.results$log2FoldChange > 0] <- "Up"
#Se pvalue < 0.05 e log2FoldChange < 0, insere "Down" na coluna Categoria
tabela1.results$Categoria[tabela1.results$pvalue < 0.05 & tabela1.results$log2FoldChange < 0] <- "Down"

# Selecionar os 20 maiores Up e 20 menores Down
# top_up > nome do data frame que vai armazenar os rótulos
top_up <- tabela1.results %>% # tabela1.results é o nome do data frame original
  filter(Categoria == "Up") %>% # 'filter' filtra as linhas que atendem à condição
  arrange(desc(log2FoldChange)) %>% # 'arrange' ordena as linhas por log2FoldChange e 'desc' organiza em ordem decrescente
  slice(1:20) # 'slice' seleciona as primeiras 20 linhas

# Selecionar 20 menores Down
# top_down > nome do data frame que vai armazenar os rótulos
top_down <- tabela1.results %>% # tabela1.results é o nome do data frame original
  filter(Categoria == "Down") %>% # 'filter' filtra as linhas que atendem à condição
  arrange(log2FoldChange) %>% # 'arrange' ordena as linhas por log2FoldChange e 'desc' organiza em ordem decrescente
  slice(1:20) # 'slice' seleciona as primeiras 20 linhas

# Combinar os rótulos
#junta os dois data frames em um só por linhas
labels_df <- bind_rows(top_up, top_down)

# Plotando o gráfico com rótulos e linhas de corte
# Color é definido pela coluna Categoria
ggplot(tabela1.results, aes(x = log2FoldChange, y = -log10(pvalue), color = Categoria)) +
  geom_point(size = 2, alpha = 0.7) +
  geom_text_repel(data = labels_df, #usando o data frame combinado com os rótulos
                  aes(label = GeneSymbol), #definindo que os rótulos são os GeneSymbol
                  size = 3, #tamanho da fonte
                  max.overlaps = Inf, #permite sobreposição infinita
                  box.padding = 0.5, #espaçamento entre o rótulo e o ponto
                  segment.color = "gray50") + #cor da linha que conecta o rótulo ao ponto
  scale_color_manual(values = c("Up" = "#f16913", "Down" = "#2b8cbe", "Não significativo" = "gray")) +
  geom_vline(xintercept = 0 , linetype = "dashed", color = "black") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "black") +
  theme_bw() +
  labs(title = "Volcano Plot com Rótulos e Linhas de Corte",
       x = "log2 Fold Change",
       y = "-log10(p-value)")


# Se eu quiser mudar o tema?
# Temas disponíveis: theme_gray(), theme_bw(), theme_classic(), theme_minimal(), theme_light(), theme_dark(), theme_void()
# Vou usar o theme_light()

# Se eu quiser os top 15 genes com maior |log2FC| e menor p-valor?

#Carregar bibliotecas
library(dplyr)
library(ggplot2)
library(ggrepel)

# Classificação por categoria
#Teste lógico
#Se pvalue < 0.05 e log2FoldChange > 0, insere "Up" na coluna Categoria
tabela1.results$Categoria[tabela1.results$pvalue < 0.05 & tabela1.results$log2FoldChange > 0] <- "Up"
#Se pvalue < 0.05 e log2FoldChange < 0, insere "Down" na coluna Categoria
tabela1.results$Categoria[tabela1.results$pvalue < 0.05 & tabela1.results$log2FoldChange < 0] <- "Down"

# Selecionar os 15 genes com maior |log2FC| e menor p-valor
top_genes <- tabela1.results %>% # tabela1.results é o nome do data frame original
  arrange(pvalue, desc(abs(log2FoldChange))) %>% # 'arrange' ordena as linhas por pvalue e log2FoldChange, 'desc'  orgnizar em ordem decrescente
  slice(1:20) # 'slice' seleciona as primeiras 15 linhas

# plotando o gráfico com rótulos e linhas de corte
# Color é definido pela coluna Categoria
ggplot(tabela1.results, aes(x = log2FoldChange, y = -log10(pvalue), color = Categoria)) +
  geom_point(alpha = 0.7) +
  geom_text_repel(data = top_genes, #usando o data frame com os rótulos
                  aes(label = GeneSymbol), #definindo que os rótulos são os GeneSymbol
                  size = 3, #tamanho da fonte
                  color = "black", #  Rótulos em preto
                  max.overlaps = Inf, #permite sobreposição infinita
                  box.padding = 0.5, #espaçamento entre o rótulo e o ponto
                  segment.color = "gray50") + #cor da linha que conecta o rótulo ao ponto
  scale_color_manual(values = c("Up" = "#f16913", "Down" = "#2b8cbe", "Não significativo" = "gray")) +
  geom_vline(xintercept = 0 , linetype = "dashed", color = "black") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "black") +
  theme_light() +
  labs(title = "Volcano Plot com Rótulos e Linhas de Corte",
       x = "log2(Fold Change)",
       y = "-log10(p-value)")

# Se eu quiser salvar o gráfico?
# Usar ggsave() para salvar o gráfico
volcano_plot <- ggplot(tabela1.results, aes(x = log2FoldChange, y = -log10(pvalue), color = Categoria)) +
  geom_point(alpha = 0.7) +
  geom_text_repel(data = top_genes, #usando o data frame com os rótulos
                  aes(label = GeneSymbol), #definindo que os rótulos são os GeneSymbol
                  size = 3, #tamanho da fonte
                  color = "black", #  Rótulos em preto
                  max.overlaps = Inf, #permite sobreposição infinita
                  box.padding = 0.5, #espaçamento entre o rótulo e o ponto
                  segment.color = "gray50") + #cor da linha que conecta o rótulo ao ponto
  scale_color_manual(values = c("Up" = "#f16913", "Down" = "#2b8cbe", "Não significativo" = "gray")) +
  geom_vline(xintercept = 0 , linetype = "dashed", color = "black") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "black") +
  theme_light() +
  labs(title = "Volcano Plot com Rótulos e Linhas de Corte",
       x = "log2(Fold Change)",
       y = "-log10(p-value)")

ggsave("volcano_plot.png", width = 8, height = 6, dpi = 300)
# Parâmetros: nome do arquivo, largura, altura, resolução (dpi)
# Formatos suportados: .png, .jpg, .tiff, .pdf, .eps
# O formato é determinado pela extensão do arquivo no nome
# Vai salvar na pasta de trabalho atual
# Para ver a pasta de trabalho atual, use getwd()