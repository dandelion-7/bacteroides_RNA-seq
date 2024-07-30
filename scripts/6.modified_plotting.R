# Plot the RPKMs of defense genes of B.theta VPI-5482 from NC/Science paper
unique(read_count_tidy$condition)
defense_gene_for_modified_plotting <- read_count_tidy %>%
  filter(gene_name != "non-defense-gene") %>% 
  mutate(condition = case_when(
    condition == "dIDR colonization" ~ "Colonization, dIDR",
    condition == "WT colonization" ~ "Colonization",
    condition == "RNA-seq Comp" ~ "Culture, Complemented",
    condition == "RNA-seq KO" ~ "Culture, KO",
    condition == "RNA-seq WT" ~ "Culture",
    condition == "-TEX dRNA-seq WT ELP" ~ "Culture, early-log phase",
    condition == "-TEX dRNA-seq WT MLP" ~ "Culture, mid-log phase",
    condition == "-TEX dRNA-seq WT stat" ~ "Culture, stationary phase",
    condition == "+TEX dRNA-seq WT ELP" ~ "Culture, early-log phase, +TEX",
    condition == "+TEX dRNA-seq WT MLP" ~ "Culture, mid-log phase, +TEX",
    condition == "+TEX dRNA-seq WT stat" ~ "Culture, stationary phase, +TEX",
    ))

defense_gene_for_modified_plotting$sys_id_simplified <- defense_gene_for_modified_plotting$sys_id_simplified %>% 
  str_remove_all("Type_") %>% str_remove("Rst_")

defense_gene_for_modified_plotting %>% 
  filter(condition %in% c("Colonization", "Culture, early-log phase", "Culture, mid-log phase", "Culture, stationary phase")) %>%
  filter(gene_name != "non-defense-gene") %>% 
  ggplot(aes(x = gene_name_simplified, y = rpkm)) +
  geom_bar(aes(group = condition, fill = condition), stat = "summary", color = "black", position = position_dodge(), alpha = 0.8) +
  geom_point(aes(fill = condition, group = condition), position = position_dodge(width = 0.9), size = 2, shape = 21) +
  facet_grid(.~sys_id_simplified, scales = "free", space = "free_x") +
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 30, hjust = 1, vjust = 1, face = "bold", size = 10), axis.text.y = element_text(face = "bold", size = 10)) +
  # stat_compare_means(method = "wilcox.test", aes(group = setting), label = "p.signif") + 
  theme(axis.title.x = element_blank(), legend.title = element_blank()) + 
  theme(strip.text.x = element_text(face = "bold", size = 10)) +
  theme(legend.text = element_text(face = "bold", size = 10)) +
  theme(legend.position = "top") +
  theme(legend.box.spacing = unit(5, units = "mm")) +
  theme(axis.title.y = element_text(face = "bold", size = 10)) +
  labs(y = "RPKM") + 
  scale_y_continuous(breaks = c(0, 50, 100, 150, 200, 250)) +
  # scale_shape_manual(values = c(25, 21)) + 
  scale_fill_manual(values = c("#1a9850", "#fed976", "#fd8d3c", "#f03b20"))
# ~/crisprome/bacteroides_RNA-seq/intermediates/6.modified_plotting/6.NC_Science_defense_genes_RPKM.pdf, w17h5


# Plot the RPKMs of defense genes of B.uniformis ATCC-8492 from 2022 Cell Host paper.
defense_genes_read_count_BU_tidy <- read_count_BU_tidy %>% filter(gene_name != "non-defense-gene")
defense_genes_read_count_BU_tidy <- 
  defense_genes_read_count_BU_tidy$gene_name %>% as.data.frame() %>% separate(col = ".", into = c("system", "gene_name_simplified"), sep = "__") %>% select(-system) %>% as.matrix() %>% 
  cbind(defense_genes_read_count_BU_tidy)
defense_genes_read_count_BU_tidy$sys_id <- defense_genes_read_count_BU_tidy$sys_id %>% str_remove_all("Type_")
defense_genes_read_count_BU_tidy <- defense_genes_read_count_BU_tidy %>% 
  mutate(condition_detailed = case_when(
    condition == "BMM" ~ "Minimal medium", 
    condition == "Mucin" ~ "Minimal medium + mucin"
  ))

defense_genes_read_count_BU_tidy %>% 
  ggplot(aes(x = gene_name_simplified, y = rpkm)) +
  geom_bar(stat = "summary", aes(fill = condition_detailed, group = condition), color = "black", position = position_dodge(), width = 0.8, alpha = 0.8) + 
  geom_point(aes(fill = condition_detailed), shape = 21, size = 2, position = position_dodge(width = 0.9)) +
  facet_grid(.~sys_id, scales = "free_x", space = "free_x") + 
  scale_y_sqrt(breaks = c(0, 50, seq(100, 500, 100))) +
  scale_fill_manual(values = c("#fed976", "#f03b20")) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1, vjust = 1, face = "bold", size = 10), axis.text.y = element_text(face = "bold", size = 10)) +
  # stat_compare_means(method = "wilcox.test", aes(group = condition), label = "p.signif") +
  theme(axis.title.x = element_blank(), legend.title = element_blank()) +
  theme(axis.title.y = element_text(face = "bold", size = 10)) +
  theme(strip.text.x = element_text(face = "bold", size = 10), strip.text.y = element_text(face = "bold")) +
  theme(legend.text = element_text(face = "bold", size = 10)) + 
  labs(y = "RPKM")+
  guides(fill = guide_legend(position = "top"))
# ~/crisprome/bacteroides_RNA-seq/intermediates/6.modified_plotting/6.BU_CellHost_defense_genes_RPKM.pdf, w17h5

# Plot the RPKMs of defense genes of B.xylan XB1A from 2016 BMC Genomics.
defense_genes_read_count_BX_tidy <- read_count_BX_tidy %>% filter(gene_name != "non-defense-gene")
defense_genes_read_count_BX_tidy <- 
  defense_genes_read_count_BX_tidy$gene_name %>% as.data.frame() %>% separate(col = ".", into = c("system", "gene_name_simplified"), sep = "__") %>% select(-system) %>% as.matrix() %>% 
  cbind(defense_genes_read_count_BX_tidy)
defense_genes_read_count_BX_tidy$sys_id <- defense_genes_read_count_BX_tidy$sys_id %>% str_remove_all("Type_")
defense_genes_read_count_BX_tidy$Carbon_source <- defense_genes_read_count_BX_tidy$Carbon_source %>% str_replace_all(pattern = "[.]", replacement = " ")

defense_genes_read_count_BX_tidy %>% filter(Growth_stage == "LLP") %>% 
  ggplot(aes(x = gene_name_simplified, y = rpkm)) +
  geom_bar(stat = "summary", aes(fill = Carbon_source, group = Growth_Carbon), color = "black", position = position_dodge(), width = 0.8, alpha = 0.8) + 
  geom_point(aes(fill = Carbon_source), shape = 21, size = 2, position = position_dodge(width = 0.8)) +
  facet_grid(~sys_id, scales = "free_x", space = "free_x") + 
  scale_y_sqrt(breaks = c(0, 100, 250, 500, 1000, 1500)) +
  scale_fill_manual(values = c("#984ea3", "#74add1", "#1a9850", "#fed976", "#f03b20")) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1, vjust = 1, face = "bold", size = 10), axis.text.y = element_text(face = "bold", size = 10)) +
  # stat_compare_means(method = "wilcox.test", aes(group = condition), label = "p.signif") +
  theme(axis.title.x = element_blank(), legend.title = element_blank()) +
  theme(strip.text.x = element_text(face = "bold", size = 10), strip.text.y = element_text(face = "bold")) + 
  theme(legend.text = element_text(face = "bold", size = 10)) +
  labs(y = "RPKM") +
  guides(fill = guide_legend(position = "top"))
# ~/crisprome/bacteroides_RNA-seq/intermediates/6.modified_plotting/6.BX_BMCgenomics_defense_genes_RPKM.pdf, w17h5