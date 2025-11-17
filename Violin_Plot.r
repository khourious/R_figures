#Violin plot

#instalação dos devidos pacotes necessários
install.packages("ggplot2")
install.packages("devtools")
install.packages("dlpyr")
install.packages ("reshape2")
install.packages ("tibble")
install.packages("tidyr")
devtools::install_github("slowkow/ggrepel")
install.packages("ggrepel")

#Após isso carregue os pacotes
# Tudo junto
library (c(ggplot2,dplyr,reshape2, devtools, tibble, tidyr, ggrepel))

# Ou seperado, caso algum esteja com problema
library(ggplot2)
library(dplyr)
library(reshape2)
library(devtools)
library(tibble)
library(tidyr)
library(ggrepel)

#defina qual é seu diretório de referência para trabalhar nesse gráfico
#é mais ágil para trabalhar
setwd("caminho/para/o/seu/diretório")

#alguns códigos úteis para trabalhar com diferentes datasets dentro da mesma tabela de informações

#este comando vai unir duas tabelas baseada na coluna em comum entre elas
unida <- left_join(tabela1, tabela2, by = "Coluna Comum a ambas")

#este comando remove uma coluna específica
unida$Coluna1 <- NULL

#este comando remove um conjunto de colunas específicas baseada na sua posição
unida [3:7] <- NULL

#é possível transferir colunas específicas para outro objeto no R
tabela3 <- unida [1:2]

#você pode ordenar sua tabela
# Ordenando os genes por log2FoldChange
unida <- unida %>% arrange(desc(log2FoldChange))

# Ordenando os genes por log2FoldChange, de forma decrescente
unida <- unida %>% arrange(desc(log2FoldChange))

#transforma uma das coluans em row.name
#pesquise para entender qual impacto disso em análise de dados do R
row.names(tabela1) <- tabela1$Coluna1

#Transforma um row name em uma coluna
#o nome da coluna é definido em "var"
tabela1 <- rownames_to_column(tabela1, var = "SampleId")

#modufica todos os valores NA por 0
#Pesquise o que significa NA no R
tabela1 <- tabela1 %>% mutate_all(coalesce, 0)

#transpõe as tabelas
#similar a função transpose no R
unida_transpose <- as.data.frame(t(unida))


### Se você estiver trabalhando com grupos na sua análise, você pode fazer uma condicional
#a interpretação básica de uma função condicional if else é:
# "eu quero que o meu código faça algo em determinadas condiçções
# SE (if) as condições necessárias não sejam atendidas,
# ENTÂo (else), eu específico para realizar outra coisa"
unida <- unida %>%
  mutate(Grupo = ifelse(grepl("^ZIKV", SampleId), "ZIKV", #grepel verifica se o valor na coluna SampleId começa com ZIKV
                        ifelse(grepl("^CTRL", SampleId), "CTRL", #grepel verifica se o valor na coluna SampleId começa com CTRL
                               ifelse(grepl("^CHIKV", SampleId), "CHIKV", #grepel verifica se o valor na coluna SampleId começa com CHIKV
                                      ifelse(grepl("^DENV", SampleId), "DENV", NA))))) %>% #grepel verifica se o valor na coluna SampleId começa com DENV. Caso contrário, atribui NA.
  mutate(Grupo = factor(Grupo, levels = c("CTRL", "CHIKV", "DENV", "ZIKV"))) #Converte a coluna Grupo em um fator (factor) com níveis ordenados: “CTRL”, “CHIKV”, “DENV”, “ZIKV”.

  # Em resumo, esse código classifica as amostras em grupos baseados no prefixo de SampleId e define a ordem dos níveis do fator Grupo.

#aqui define as cores do violin de cada grupo
vio <- c("CTRL" = "gray", "CHIKV" = "#fcc5c0", "DENV" = "#d4b9da", "ZIKV" = "#CAE1FF")

# aqui define as cores dos pontos de cada grupo
pontos <- c("CTRL" = "black", "CHIKV" = "#980043", "DENV" = "#54278f", "ZIKV" = "#1874CD")

#Por fim, o código para fazer o violin com diferentes grupos
# Vamos por partes
# Uso mais básido do ggplot para cricar um violin.
#cria um gráfico base definido por unida. Define que o eixo x será Grupo, o eixo y será Valor, e a cor de preenchimento (fill) será baseada no Grupo
vioplot <- ggplot(unida, aes(x = Grupo, y = Valor, fill = Grupo))

# Adiciona gráficos de violino, que mostram a distribuição dos dados para cada grupo.
vioplot <- ggplot(unida, aes(x = Grupo, y = Valor, fill = Grupo)) +
  geom_violin()

# Adiciona os pontos no gráfico
vioplot <- ggplot(unida, aes(x = Grupo, y = Valor, fill = Grupo)) +
  geom_violin() +
  geom_point(position = position_jitter(width = 0.1), aes(color = Grupo), alpha = 1) 

#define manualemnte as cores do gráfico
vioplot <- ggplot(unida, aes(x = Grupo, y = Valor, fill = Grupo)) +
  geom_violin() +
  geom_point(position = position_jitter(width = 0.1), aes(color = Grupo), alpha = 1) +
  scale_fill_manual(values = vio) +
  scale_color_manual(values = pontos)

# Adiciona identificação (rótulos) nos pontos
vioplot <- ggplot(unida, aes(x = Grupo, y = Valor, fill = Grupo)) +
  geom_violin() +
  geom_point(position = position_jitter(width = 0.1), aes(color = Grupo), alpha = 1) +
  scale_fill_manual(values = vio) +
  scale_color_manual(values = pontos) +
  geom_text_repel(aes(label = SampleId), position = position_jitter(width = 0.0), size = 3.5, color = "black") 
  #label é o texto a ser adicionado, position a posição, size o tamanho da fonte, color é a cor do rótulo

#Títulos e legendas
vioplot <- ggplot(unida, aes(x = Grupo, y = Valor, fill = Grupo)) +
  geom_violin() +
  geom_point(position = position_jitter(width = 0.1), aes(color = Grupo), alpha = 1) +
  scale_fill_manual(values = vio) +
  scale_color_manual(values = pontos) +
  geom_text_repel(aes(label = SampleId), position = position_jitter(width = 0.0), size = 3.5, color = "black") +
  labs(title = "TÍTULO",
       x = "LEGENDA EIXO X ",
       y = "LEGENDA EIXO Y")

#  Divide o gráfico em múltiplos gráficos menores, um para cada Gene, com escalas y independentes.
vioplot <- ggplot(unida, aes(x = Grupo, y = Valor, fill = Grupo)) +
  geom_violin() +
  geom_point(position = position_jitter(width = 0.1), aes(color = Grupo), alpha = 1) +
  scale_fill_manual(values = vio) +
  scale_color_manual(values = pontos) +
  geom_text_repel(aes(label = SampleId), position = position_jitter(width = 0.0), size = 3.5, color = "black") +
  labs(title = "TÍTULO",
       x = "LEGENDA EIXO X ",
       y = "LEGENDA EIXO Y") +
  facet_wrap(~ Gene, scales = "free_y")

#Aplica um tema claro ao gráfico, que ajusta a aparência geral.
#Tem outros, eu preferi esse

vioplot <- ggplot(unida, aes(x = Grupo, y = Valor, fill = Grupo)) +
  geom_violin() +
  geom_point(position = position_jitter(width = 0.1), aes(color = Grupo), alpha = 1) +
  scale_fill_manual(values = vio) +
  scale_color_manual(values = pontos) +
  geom_text_repel(aes(label = SampleId), position = position_jitter(width = 0.0), size = 3.5, color = "black") +
  labs(title = "TÍTULO",
       x = "LEGENDA EIXO X ",
       y = "LEGENDA EIXO Y") +
  facet_wrap(~ Gene, scales = "free_y") +
  theme_light()

# Personaliza vários aspectos do tema do gráfico, como cores, tamanhos e estilos dos textos dos eixos, título do gráfico e legenda.
vioplot <- ggplot(unida, aes(x = Grupo, y = Valor, fill = Grupo)) +
  geom_violin() +
  geom_point(position = position_jitter(width = 0.1), aes(color = Grupo), alpha = 1) +
  scale_fill_manual(values = vio) +
  scale_color_manual(values = pontos) +
  geom_text_repel(aes(label = SampleId), position = position_jitter(width = 0.0), size = 3.5, color = "black") +
  labs(title = "TÍTULO",
       x = "LEGENDA EIXO X ",
       y = "LEGENDA EIXO Y") +
  facet_wrap(~ Gene, scales = "free_y") +
  theme_light() +
  theme(strip.text = element_text(color = "black", size = 9, face = "bold"),
        axis.text.y = element_text(margin = margin(0, 10, 0, 0),color = "black", size = 10),  # Configurações dos rótulos do eixo y
        axis.title.x = element_text(color = "black", size = 12, face = "bold"),  # Configurações do texto do eixo x
        axis.text.x = element_text(color = "black", size = 10),  # Configurações dos rótulos do eixo x
        plot.title = element_text(margin = margin(b = 10), color = "black", size = 16, face = "bold"),  # Configurações do título do gráfico
        legend.title = element_text(color = "black", size = 12, face = "bold"),  # Configurações do título da legenda
        legend.text = element_text(color = "black", size = 10))
# Visualize o vioplot
print(vioplot)

# Salva o gráfico em formato PNG com alta resolução
ggsave("vioplot.png", plot = vioplot, width = 15, height = 10, dpi = 400)