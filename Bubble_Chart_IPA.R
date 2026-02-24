
setwd("C:/Users/joyce/OneDrive - FIOCRUZ/covid19/09_Enriquecimento_IPA/baço_LV_controle/FC1")
disease <- read.delim("C:/Users/joyce/OneDrive - FIOCRUZ/covid19/09_Enriquecimento_IPA/baço_LV_controle/FC1/disease.txt")

library(tidyverse)
library(ggplot2)

library(tidyverse)


disease_plot <- disease %>%
  mutate(
    # Corrigir separador decimal
    p.value = as.numeric(gsub(",", ".", p.value)),
    Activation.z.score = as.numeric(gsub(",", ".", Activation.z.score)),
    # Quebrar nomes longos das categorias
    MainCategory = str_wrap(str_extract(Categories, "^[^,]+"), width = 25),
    MoleculeCount = X..Molecules,
    # Quebrar nomes longos das vias
    Diseases.or.Functions.Annotation = str_wrap(Diseases.or.Functions.Annotation, width = 27)
  ) %>%
  filter(!is.na(Activation.z.score)) %>%
  arrange(p.value) %>%
  slice(1:25)   # top 25 pelo p-value

ggplot(disease_plot, aes(x = Activation.z.score,
                         y = fct_reorder(Diseases.or.Functions.Annotation, p.value),
                         size = MoleculeCount,
                         color = Activation.z.score)) +
  geom_point(alpha = 0.9) +
  scale_color_gradient2(low = "dodgerblue4", mid = "gray", high = "red3",
                        midpoint = 0, name = "Activation z-score") +
  scale_size(range = c(3, 14), name = "Nº Moléculas") +
  facet_wrap(~MainCategory, scales = "free_y") +
  theme_bw(base_size = 14) +
  theme( strip.background = element_rect(fill = "grey95", color = "black"), # caixa em torno das categorias 
         strip.text = element_text(face = "bold", size = 12), 
         axis.text.y = element_text(size = 10, face = "italic"), 
         axis.title.x = element_text(size = 12, face = "bold"), 
         axis.title.y = element_blank(), 
         panel.grid.major = element_blank(), # remove quadriculado 
         panel.grid.minor = element_blank(), legend.position = "right" ) +
  labs(x = "Activation z-score",
       title = "Disease and Biological Function")



# Vias canônicas
canonical <- read.delim2("C:/Users/joyce/OneDrive - FIOCRUZ/covid19/09_Enriquecimento_IPA/baço_LV_controle/FC1/canonical.txt")


canonical_plot <- canonical %>%
  mutate(
    X.log.p.value. = as.numeric(gsub(",", ".", X.log.p.value.)),
    Ratio = as.numeric(gsub(",", ".", Ratio)),
    z.score = as.numeric(gsub(",", ".", z.score)),
    MoleculeCount = str_count(Molecules, ",") + 1,
    Pathway = str_wrap(Ingenuity.Canonical.Pathways, width = 60) # quebra nomes longos
  ) %>%
  filter(!is.na(z.score)) %>%
  arrange(desc(X.log.p.value.)) %>%
  slice(1:25) %>%  arrange(X.log.p.value.)

ggplot(canonical_plot, aes(x = X.log.p.value.,
                           y = fct_reorder(Pathway, X.log.p.value.),
                           size = MoleculeCount,
                           color = z.score)) +
  geom_point(alpha = 0.9) +
  scale_color_gradient2(low = "dodgerblue4", mid = "white", high = "firebrick",
                        midpoint = 0, name = "z-score") +
  scale_size(range = c(3, 14), name = "Nº Molecules") +
  theme_linedraw(base_size = 14) +
  theme(
    strip.background = element_blank(),
    axis.text.y = element_text(size = 10, color = "black"),
    axis.title.x = element_text(size = 12, face = "bold", color = "black"),
    axis.title.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "right"
  ) +
  labs(x = "-log(p.value)",
       title = "Canonical Pathways")



# Upstream
upstream <- read.delim2("C:/Users/joyce/OneDrive - FIOCRUZ/covid19/09_Enriquecimento_IPA/baço_LV_controle/FC1/upstream.txt")

library(tidyverse)

library(tidyverse)

upstream_plot <- upstream %>%
  filter(!is.na(Predicted.Activation.State),
         !is.na(Activation.z.score)) %>%   # mantém só os com estado previsto e z-score válido
  mutate(
    p.value.of.overlap = as.numeric(p.value.of.overlap),
    Activation.z.score = as.numeric(Activation.z.score),
    MoleculeCount = str_count(Target.Molecules.in.Dataset, ",") + 1,
    Regulator = str_wrap(Upstream.Regulator, width = 25) # quebra nomes longos
  ) %>%
  arrange(desc(-log10(p.value.of.overlap))) %>%
  slice(1:11)   # top 25 reguladores mais significativos

library(tidyverse)

upstream_plot <- upstream %>%
  filter(Predicted.Activation.State %in% c("Activated", "Inhibited"),
         !is.na(Activation.z.score)) %>%   # mantém só os com estado previsto e z-score válido
  mutate(
    p.value.of.overlap = as.numeric(p.value.of.overlap),
    Activation.z.score = as.numeric(Activation.z.score),
    MoleculeCount = str_count(Target.Molecules.in.Dataset, ",") + 1,
    Regulator = str_wrap(Upstream.Regulator, width = 25) # quebra nomes longos
  ) %>%
  arrange(desc(-log10(p.value.of.overlap)))

ggplot(upstream_plot, aes(x = Predicted.Activation.State,
                          y = fct_reorder(Regulator, Activation.z.score),
                          size = MoleculeCount,
                          color = Activation.z.score)) +
  geom_point(alpha = 0.9, position = position_jitter(width = 0.2, height = 0)) +
  scale_color_gradient2(low = "dodgerblue4", mid = "white", high = "firebrick",
                        midpoint = 0, name = "Activation z-score") +
  scale_size(range = c(3, 14), name = "Target Molecules") +
  theme_classic(base_size = 14) +
  theme(
    axis.text.y = element_text(size = 10, color = "black"),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "right"
  ) +
  labs(title = "Upstream Regulators")





baco <- baco.lv.results

row.names(baco) <- baco$GeneSymbol

baco[1:7] <- NULL

write.table(baco,
            file = "tabela_normalizada_LV.tsv",
            sep = "\t",              # separador tab
            quote = FALSE,           # não colocar aspas
            row.names = TRUE)        # usar nomes de linha (genes)
