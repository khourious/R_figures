# instalar pacotes se necessário
install.packages("ggplot2")
install.packages("tidyverse")
install.packages("dplyr")
install.packages("tidyr")
install.packages("readr")
install.packages("ggpubr")
install.packages("RColorBrewer")
install.packages("cowplot")
install.packages("ggsci")
install.packages("viridis")
install.packages("scales")
install.packages("ggthemes")
install.packages("extrafont")
install.packages("data.table")
install.packages("forcats")
install.packages("stringr")
install.packages("reshape2")
install.packages("patchwork")
install.packages("ggrepel")
install.packages("openxlsx")
install.packages("janitor")
install.packages("Polychrome")
install.packages("paletteer")

# carregar pacotes
library(ggplot2)
library(tidyverse)
library(dplyr)
library(tidyr)
library(readr)
library(ggpubr)
library(RColorBrewer)
library(cowplot)
library(ggsci)
library(viridis)
library(scales)
library(ggthemes)
library(extrafont)
library(data.table)
library(forcats)
library(stringr)
library(reshape2)
library(patchwork)
library(ggrepel)
library(paletteer)

library(Polychrome)

# --- Stackered bar plots CIBERSORT ---

# Gráfico para os dados baseados na matrix LM22 do Cib

CIBERSORT <- read.delim("C:/Documents/LM22/CIBERSORTx_Job39_Results.txt")

# Definir set de cores
# quiser outras cores olhe: https://r-graph-gallery.com/color-palette-finder
cores1 <- as.character(paletteer_d("rcartocolor::Antique"))
cores2 <- as.character(paletteer_d("MexBrewer::Atentado"))
cores3 <- as.character(paletteer_d("nbapalettes::cavaliers_retro"))

# Unir as cores e limitar a 22
cores_22 <- c(cores1, cores2)[1:22]  # garante que sejam 22 cores

# Associar os tipos celulares as cores
names(cores_22) <- levels(factor(CIBERSORT_long$CellType))

# Importar tabela de metadados
sampleTable <- read.csv("metadata.txt", sep = ",")

# Definir sampleId como nome das linhas
rownames(sampleTable) <- sampleTable$SampleId

# Transformas colunas em fatores
sampleTable$sampleId<- as.factor(sampleTable$sampleId)
sampleTable$clinical <- as.factor(sampleTable$clinical)
sampleTable$meio <- as.factor(sampleTable$meio)

# Selecionar que as amostras do CIBERSORT sejam as mesmas do sampleTable
ciber <- CIBERSORT[CIBERSORT$Mixture %in% sampleTable$sampleId, ]

# Unir as anotações
CIBERSORT_annot <- left_join(ciber, sampleTable, by = c("Mixture" = "sampleId"))

# Converter em dados longo selecionando as colunas de interesse
CIBERSORT_long <- tidyr::pivot_longer(
  CIBERSORT_annot[, !(names(CIBERSORT_annot) %in% c("P.value", "Correlation", "RMSE"))],
  cols = !c("Mixture", "meio", "clinical"),
  names_to = "CellType",
  values_to = "Fraction"
)

# Ordenar os níveis dos grupos
CIBERSORT_long$meio <- factor(CIBERSORT_long$meio, levels = c("meio1", "meio2", "meio3"))

# Gráfico de barras empilhadas
ggplot(CIBERSORT_long, aes(x = Mixture, y = Fraction, fill = CellType)) +
  geom_bar(stat = "identity", position = "stack") +  
  facet_wrap(~ meio, ncol = 3, scales = "free_x") + # define quantas facetas quer
  scale_fill_manual(values = cores_22) + # quais cores quer usar
  theme_classic(base_size = 14) +
  labs(title = "",
       x = "Samples",
       y = "Estimated Cell Fraction",
       fill = "Cell Type") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))