# Instalar pacote se necessário
install.packages("pheatmap")
install.packages("ggplot2")
install.packages("tidyverse")

# Carregar pacote
library(pheatmap)
library(ggplot2)
library(tidyverse)

#impotar tabelas
canonical <- read.csv("ipa_canonical_pathways.csv", header = TRUE, sep = "\t")

# selecionar top 25 vias
top_25 <- canonical[1:25,]

# visualizar as primeiras linhas do data frame
head(top_25)

# selecionar colunas relevantes
colnames(top_25)
selected_columns <- c("Canonical.Pathways",
                      "coluna1", "coluna2")

# Filtrar e transformar os dados para formato longo
df_long <- top_25 %>%
  select(all_of(selected_columns)) %>%
  pivot_longer(cols = -Canonical.Pathways,
               names_to = "Condition",
               values_to = "Zscore")

# Converter Zscore para numérico
df_long <- df_long %>%
  mutate(Zscore = as.numeric(Zscore))


# Caso precise substituir os nomes das condições
# mutate substitui os nomes das condições
# case_when é uma condicional que verifica o padrão no início da string
# str_detect() verifica se a string na coluna Condition começa com "SR"
# ^ significa “início da string” (regex).
# Se for verdade, a nova coluna Group recebe "WR". E assim em diante para os outros grupos
df_long <- df_long %>%
  mutate(Group = case_when(
    str_detect(Condition, "^SR") ~ "WR",
    str_detect(Condition, "^RR") ~ "RR",
    str_detect(Condition, "^ENL") ~ "ENL"
  ))

# Ordenar vias de cima para baixo
df_long <- df_long %>%
  mutate(Canonical.Pathways = factor(Canonical.Pathways,
                                     levels = rev(unique(Canonical.Pathways))))

# modificar os nomes das condições para algo mais legível
df_long <- df_long %>%
  mutate(Condition = recode(Condition,
                            "SR_rSM29_WS"   = "(SR) rSM29 vs Medium",
                            "SR_rSM29_ML"   = "(SR) rSM29 vs M. Leprae"
  ))

# Criar o heatmap com ggplot2
# se quiser para vários grupos, usar facet_grid
ggplot(df_long, aes(x = Condition, y = Canonical.Pathways, fill = Zscore)) + 
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0) + # modifique cores como quiser
  facet_grid(. ~ Group, scales = "free_x", space = "free_x") +
  theme_bw() + # modifique tema como quiser
  theme(axis.text.x = element_text(size = 7, angle = 45, hjust = 1, color = "black"),
        axis.text.y = element_text(size = 10, color = "black"),
        strip.background = element_rect(fill = "gray90", color = "black"),
        strip.text = element_text(face = "bold", size = 10)) +
  labs(title = "",
       x = "",
       y = "",
       fill = "Z-score")


# Criar o heatmap com ggplot2
# se não quiser vários grupos, não usar facet_grid
ggplot(df_long, aes(x = Condition, y = Canonical.Pathways, fill = Zscore)) + 
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0) + # modifique cores como quiser
  theme_bw() + # modifique tema como quiser
  theme(axis.text.x = element_text(size = 7, angle = 45, hjust = 1, color = "black"),
        axis.text.y = element_text(size = 10, color = "black"),
        strip.background = element_rect(fill = "gray90", color = "black"),
        strip.text = element_text(face = "bold", size = 10)) +
  labs(title = "",
       x = "",
       y = "",
       fill = "Z-score")



# --- Disease and Biological Functions ---

#impotar tabelas
disease <- read.csv("ipa_disease_biological.csv", header = TRUE, sep = "\t")

# selecionar top 25 vias
top_25 <- disease[1:25,]

# visualizar as primeiras linhas do data frame
head(top_25)

# selecionar colunas relevantes
colnames(top_25)
selected_columns <- c("Diseases.and.Bio.Functions",
                      "coluna1", "coluna2")

# Filtrar e transformar os dados para formato longo
df_long <- top_25 %>%
  select(all_of(selected_columns)) %>%
  pivot_longer(cols = -Diseases.and.Bio.Functions,
               names_to = "Condition",
               values_to = "Zscore")

# Converter Zscore para numérico
df_long <- df_long %>%
  mutate(Zscore = as.numeric(Zscore))


# Caso precise substituir os nomes das condições
# mutate substitui os nomes das condições
# case_when é uma condicional que verifica o padrão no início da string
# str_detect() verifica se a string na coluna Condition começa com "SR"
# ^ significa “início da string” (regex).
# Se for verdade, a nova coluna Group recebe "WR". E assim em diante para os outros grupos
df_long <- df_long %>%
  mutate(Group = case_when(
    str_detect(Condition, "^SR") ~ "WR",
    str_detect(Condition, "^RR") ~ "RR",
    str_detect(Condition, "^ENL") ~ "ENL"
  ))

# Ordenar vias de cima para baixo
df_long <- df_long %>%
  mutate(Diseases.and.Bio.Functions = factor(Diseases.and.Bio.Functions,
                                     levels = rev(unique(Diseases.and.Bio.Functions))))

# modificar os nomes das condições para algo mais legível
df_long <- df_long %>%
  mutate(Condition = recode(Condition,
                            "SR_rSM29_WS"   = "(SR) rSM29 vs Medium",
                            "SR_rSM29_ML"   = "(SR) rSM29 vs M. Leprae"
  ))

# Heatmap com vários grupos
ggplot(df_long, aes(x = Condition, y = Diseases.and.Bio.Functions, fill = Zscore)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", 
                       midpoint = 0, na.value = "white") +
  facet_grid(. ~ Group, scales = "free_x", space = "free_x") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 7, angle = 45, hjust = 1, color = "black"),
        axis.text.y = element_text(size = 9, color = "black"),
        strip.background = element_rect(fill = "gray90", color = "black"),
        strip.text = element_text(face = "bold", size = 10)) +
  labs(title = "",
       x = "",
       y = "",
       fill = "")

# Heatmap sem vários grupos
ggplot(df_long, aes(x = Condition, y = Diseases.and.Bio.Functions, fill = Zscore)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", 
                       midpoint = 0, na.value = "white") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 7, angle = 45, hjust = 1, color = "black"),
        axis.text.y = element_text(size = 9, color = "black"),
        strip.background = element_rect(fill = "gray90", color = "black"),
        strip.text = element_text(face = "bold", size = 10)) +
  labs(title = "",
       x = "",
       y = "",
       fill = "")


# --- Upstream Regulators ---

# impotar tabelas
upstream <- read.csv("ipa_upstream_regulators.csv", header = TRUE, sep = "\t")

# selecionar top 25 vias
top_25 <- upstream[1:25,]

# visualizar as primeiras linhas do data frame
head(top_25)

# selecionar colunas relevantes
colnames(top_25)
selected_columns <- c("Upstream.Regulators",
                      "coluna1", "coluna2")

# Filtrar e transformar os dados para formato longo
df_long <- top_25 %>%
  select(all_of(selected_columns)) %>%
  pivot_longer(cols = -Upstream.Regulators,
               names_to = "Condition",
               values_to = "Zscore")

# Converter Zscore para numérico
df_long <- df_long %>%
  mutate(Zscore = as.numeric(Zscore))

# Caso precise substituir os nomes das condições
# mutate substitui os nomes das condições
# case_when é uma condicional que verifica o padrão no início da string
# str_detect() verifica se a string na coluna Condition começa com "SR"
# ^ significa “início da string” (regex).
# Se for verdade, a nova coluna Group recebe "WR". E assim em diante para os outros grupos
df_long <- df_long %>%
  mutate(Group = case_when(
    str_detect(Condition, "^SR") ~ "WR",
    str_detect(Condition, "^RR") ~ "RR",
    str_detect(Condition, "^ENL") ~ "ENL"
  ))

# Ordenar vias de cima para baixo
df_long <- df_long %>%
  mutate(Upstream.Regulators = factor(Upstream.Regulators,
                                             levels = rev(unique(Upstream.Regulators))))

# modificar os nomes das condições para algo mais legível
df_long <- df_long %>%
  mutate(Condition = recode(Condition,
                            "SR_rSM29_WS"   = "(SR) rSM29 vs Medium",
                            "SR_rSM29_ML"   = "(SR) rSM29 vs M. Leprae"
  ))

# Heatmap com vários grupos
ggplot(df_long, aes(x = Condition, y = Upstream.Regulators, fill = Zscore)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", 
                       midpoint = 0, na.value = "white") +
  facet_grid(. ~ Group, scales = "free_x", space = "free_x") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 8, angle = 45, hjust = 1, color = "black"),
        axis.text.y = element_text(size = 11, color = "black"),
        strip.background = element_rect(fill = "gray90", color = "black"),
        strip.text = element_text(face = "bold", size = 10)) +
  labs(title = "",
       x = "",
       y = "",
       fill = "")

# Heatmap sem vários grupos
ggplot(df_long, aes(x = Condition, y = Upstream.Regulators, fill = Zscore)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", 
                       midpoint = 0, na.value = "white") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 8, angle = 45, hjust = 1, color = "black"),
        axis.text.y = element_text(size = 11, color = "black"),
        strip.background = element_rect(fill = "gray90", color = "black"),
        strip.text = element_text(face = "bold", size = 10)) +
  labs(title = "",
       x = "",
       y = "",
       fill = "")