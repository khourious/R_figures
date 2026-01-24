# Instalar pacotes se necessário
install.packages("dplyr")
install.packages("tibble")
install.packages("tidyr")
install.packages("ggplot2")
install.packages("RColorBrewer")
install.packages("reshape2")
install.packages("ggpubr")
install.packages("rstatix")
install.packages("forcats")
install.packages("broom")

# Carregar pacotes
library(dplyr)
library(tibble)
library(tidyr)
library(ggplot2)
library(RColorBrewer)
library(reshape2)
library(ggpubr)
library(rstatix)
library(forcats)
library(ggpubr)
library(broom)

# --- Gráfico para dados oriundos de CIBERSORTx ---

# Importar tabelas
cibersort <- read.csv("C:/DOcuments/cibersortx/CIBERSORTx_Job28_Results.csv")
cibersort$Group <- "Grupo1"

# Tabela de metadados
info <- read.csv("C:/DOcuments/cibersortx/metadata_cibersort.csv")
info_cibersort <- info[info$Group %in% c("CHIKV", "CTRL"),]
info_chikv <- info_cibersort %>%
  select(SampleId, Group)

# É mais fácil se as colunas de metadados e do cibersort tiverem o mesmo nome
table_cibersort <- left_join(cibersort , info_chikv, by = "Mixture")

# Caso não tenham, use by = c() para juntar as tabelas
table_cibersort <- left_join(cibersort , info_chikv, by = c("Mixture" = "SampleId"))

# converter em data frame
dados <- as.data.frame(table_cibersort)

# Transformar em formato longo, selecionando colunas relevantes
dados_long <- dados %>%
  tidyr::pivot_longer(
    cols = -c(Mixture, Group, P.value, Correlation, RMSE),
    names_to = "CellType",
    values_to = "Fraction"
  )

# Selecione a ordem desejada para os tipos celulares
ordem_final <- c(
  "Neutrophils",
  "Monocytes",
  "B.cells.naive",
  "B.cells.memory",
  "Plasma.cells",
  "Dendritic.cells.activated",
  "Dendritic.cells.resting",
  "NK.cells.activated",
  "NK.cells.resting",
  "Macrophages.M0",
  "Macrophages.M1",
  "Macrophages.M2",
  "T.cells.CD8",
  "T.cells.CD4.memory.resting",
  "T.cells.CD4.naive",
  "T.cells.CD4.memory.activated",
  "T.cells.follicular.helper",
  "T.cells.gamma.delta",
  "T.cells.regulatory..Tregs.",
  "Mast.cells.activated",
  "Mast.cells.resting",
  "Eosinophils"
)

# Aplicar a ordem aos fatores
dados_long$CellType <- factor(dados_long$CellType, levels = ordem_final)

# Renomear os tipos celulares para nomes mais legíveis
# Exemplo de renomeação (ajuste conforme seus dados)
# Isso vai criar um vetor de mapeamento
nice_names <- c(
  "B.cells.naive" = "B cells (naive)",
  "B.cells.memory" = "B cells (memory)",
  "Plasma.cells" = "Plasma cells",
  "T.cells.CD8" = "T cells CD8+",
  "T.cells.CD4.naive" = "T cells CD4+ (naive)",
  "T.cells.CD4.memory.resting" = "T cells CD4+ (memory resting)",
  "T.cells.CD4.memory.activated" = "T cells CD4+ (memory activated)",
  "T.cells.follicular.helper" = "T cells CD4+ (follicular helper)",
  "T.cells.regulatory..Tregs." = "T cells Regulatory",
  "T.cells.gamma.delta" = "T cells (gamma delta)", 
  "NK.cells.resting" = "NK cells (resting)",
  "NK.cells.activated" = "NK cells (activated)",
  "Monocytes" = "Monocytes",
  "Macrophages.M0" = "Macrophages M0",
  "Macrophages.M1" = "Macrophages M1",
  "Macrophages.M2" = "Macrophages M2",
  "Dendritic.cells.resting" = "Dendritic cells (resting)",
  "Dendritic.cells.activated" = "Dendritic cells (activated)",
  "Mast.cells.resting" = "Mast cells (resting)",
  "Mast.cells.activated" = "Mast cells (activated)",
  "Neutrophils" = "Neutrophils",
  "Eosinophils" = "Eosinophils"
)

# Aplicar os novos nomes
# recorde usa o !!! para descompactar a lista de mapeamento
dados_long$CellType <- recode(dados_long$CellType, !!!nice_names)

# Definir a ordem dos grupos
dados_long$Group <- factor(dados_long$Group, levels = c("CHIKV", "CTRL"))

# Criar o gráfico de boxplot com pontos sobrepostos
ggplot(dados_long, aes(x = CellType, y = Fraction, fill = Group, colour = Group)) +
  geom_boxplot(width = 0.6,
               position = position_dodge(width = 0.8),
               outlier.shape = NA, alpha = 0.4) + # cria o boxplot
  geom_jitter(aes(color = Group),
              alpha = 0.6, size = 1.5,
              position = position_dodge(width = 0.8)) + # adiciona os pontos
  scale_fill_manual(values = c("CHKV" = "#FF0000", 
                               "CTRL" = "#7F7F7F")) + # preenchimento das caixas
  scale_colour_manual(values = c( "CHIKV" = "#8B0000", 
                                 "CTRL" = "#000000")) + # cor dos pontos
  labs(title = "Deconvolution",
       subtitle = "Estimated cell fractions (CIBERSORTx)",
       x = NULL, y = "Estimated fraction") + # rótulo dos eixos
  geom_vline(xintercept = c(1.5,2.5, 3.5, 4.5, 5.5,
                            6.5, 7.5, 8.5, 9.5, 10.5,
                            11.5, 12.5, 13.5, 14.5, 15.5,
                            16.5, 17.5, 18.5, 19.5, 20.5, 21.5),  
             linetype = "dashed", color = "grey50") + # criar linhas verticais para separar os tipos celulares
  theme_classic(base_size = 12) + # tema clássico
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5, color = "grey30"),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10, color = "black"),
    axis.text.y = element_text(size = 10, color = "black"),
    axis.title.y = element_text(size = 11, face = "bold"),
    legend.position = "top",
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    panel.grid = element_blank(),
    axis.line = element_line(size = 0.4, colour = "black"),
    panel.border = element_rect(fill = NA, colour = NA)
  ) + # Definir detalhes do gráfico
  stat_compare_means(method = "wilcox.test", 
                       label = "p.signif", 
                       hide.ns = TRUE, 
                       size = 6) # adicionar p-values ao gráfico


# Caso queira salvar o gráfico
ggsave("cibersort_deconvolution_boxplot.png", width = 10, height = 6, dpi = 300)
ggsave("cibersort_deconvolution_boxplot.pdf", width = 10, height = 6)

# Para executar testes estatísticos entre os grupos
# Rodar pairwise Wilcoxon para cada CellType
mann <- dados_long %>%
  group_by(CellType) %>%
  do({
    res <- wilcox.test(.$Fraction, .$Group, p.adjust.method = "fdr")
    # transformar matriz em tibble com nomes dos grupos
    mat <- res$p.value
    df <- as.data.frame(as.table(mat)) %>%
      filter(!is.na(Freq)) %>%
      rename(group1 = Var1, group2 = Var2, p.value = Freq)
    df
  }) %>%
  ungroup()

# Salvar resultados em CSV
posthoc_tidy <- mann %>%
  broom::tidy()
write.csv(posthoc_tidy, "wil_results.csv", row.names = FALSE)


