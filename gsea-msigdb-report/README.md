# gsea-msigdb-report

Template to run **GSEA** using **MSigDB gene sets** (Hallmarks by default) and generate an **HTML report**.
Works from a ranked gene list.

## Inputs
- `data/ranked_genes.csv` with columns: `gene`, `score`

## Outputs
- `outputs/gsea_results.csv`
- `outputs/gsea_report.html`

## Run
```bash
Rscript scripts/01_run_gsea_fgsea.R --ranked data/ranked_genes.csv --species "Homo sapiens" --collection H
Rscript scripts/02_render_report.R
```
