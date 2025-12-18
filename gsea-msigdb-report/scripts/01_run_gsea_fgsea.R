#!/usr/bin/env Rscript
suppressPackageStartupMessages({
  library(optparse)
  library(readr)
  library(dplyr)
  library(msigdbr)
  library(fgsea)
  library(tibble)
})

option_list <- list(
  make_option(c("--ranked"), type="character", help="Path to ranked_genes.csv (gene, score)"),
  make_option(c("--species"), type="character", default="Homo sapiens", help="Species name for msigdbr"),
  make_option(c("--collection"), type="character", default="H", help="MSigDB category: H=Hallmark, C2, C5, etc."),
  make_option(c("--minSize"), type="integer", default=15),
  make_option(c("--maxSize"), type="integer", default=500),
  make_option(c("--nperm"), type="integer", default=10000)
)
opt <- parse_args(OptionParser(option_list=option_list))

dir.create("outputs", recursive = TRUE, showWarnings = FALSE)

ranked <- readr::read_csv(opt$ranked, show_col_types = FALSE) %>%
  rename(gene = 1, score = 2) %>%
  filter(!is.na(gene), !is.na(score))

ranks <- ranked$score
names(ranks) <- ranked$gene
ranks <- sort(ranks, decreasing = TRUE)

msig <- msigdbr::msigdbr(species = opt$species, category = opt$collection)
pathways <- msig %>% split(x = .$gene_symbol, f = .$gs_name)

fg <- fgsea::fgsea(
  pathways = pathways,
  stats = ranks,
  minSize = opt$minSize,
  maxSize = opt$maxSize,
  nperm = opt$nperm
) %>% as_tibble() %>% arrange(padj)

readr::write_csv(fg, "outputs/gsea_results.csv")
readr::write_csv(fg %>% slice_head(n = 30), "outputs/gsea_top30.csv")

capture.output(sessionInfo(), file = "outputs/sessionInfo_gsea.txt")
message("✅ GSEA complete: outputs/gsea_results.csv")
