library(ggplot2)
library(dplyr)
library(tidyr)

# --- Exemplo de dados (ajuste para os seus nomes) ---
# Resultado do CIBERSORT: linhas = amostras, colunas = tipos celulares
# primeira coluna = Sample
# Ex: Sample,Monocytes,Tcells,Bcells,...
#     S1,0.2,0.5,0.3,...
#     S2,0.1,0.6,0.3,...

CIBERSORTx <- CIBERSORTx_Job34_Results[, -c(24:26)]
# Juntar com metadados
dados <- CIBERSORTx  %>%
  pivot_longer(-Mixture, names_to = "CellType", values_to = "Proportion") %>%
  left_join(metadata, by = c("Mixture" = "SampleId"))

dados$Group <- factor(dados$Group, levels = c("SYMPT", "ASYMPT", "CTRL"))

# Plot estilo "Prism"
ggplot(dados, aes(x = Group, y = Proportion, fill = Group)) +
  geom_violin(width = 0.8, trim = FALSE, alpha = 0.6, color = NA) + 
  geom_boxplot(width = 0.15, outlier.shape = NA, alpha = 0.8, color = "black") +
  geom_jitter(width = 0.15, size = 1, alpha = 0.7) +
  facet_wrap(~ CellType, scales = "free_y") +
  scale_fill_manual(
    values = c(
      "SYMPT" = "#cb181d",
      "ASYMPT" = "#6a51a3",
      "CTRL" = "#1d91c0"
    )
  ) +
  theme_classic(base_size = 14) +
  theme(
    axis.text.x = element_text(angle = 30, hjust = 1),
    strip.background = element_rect(fill = "white", color = "black"),
    legend.position = "none"
  )
