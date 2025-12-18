#!/usr/bin/env Rscript
suppressPackageStartupMessages({
  library(quarto)
})
dir.create("outputs", recursive = TRUE, showWarnings = FALSE)
quarto::quarto_render("report/gsea_report.qmd", output_dir = "outputs")
message("✅ Report rendered to outputs/")
