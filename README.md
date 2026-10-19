# DSE1101 HDB resale price project

Predicting 2021 HDB resale prices. Report due Fri 13 Nov 2026.

## How to run
1. Open `hdb-project.Rproj` in RStudio.
2. Run `main.R`. It runs every script in `R/` in report order.

## Who owns what
| Script | Owner |
|---|---|
| `R/01_import_clean.R` | A |
| `R/02_eda.R` | C + A |
| `R/03_cv_helpers.R` | C |
| `R/04_linear.R` | B |
| `R/05_clustering.R` | A |
| `R/06_knn_tree.R` | C |
| `R/07_pcr.R` | B |
| `R/08_test_eval.R` | C |
| `main.R` | A |

## Rules
1. Pull before you start.
2. Only edit files you own; message the owner otherwise.
3. Push only code that runs.
4. Relative paths only (`data/...`), and `set.seed()` before anything random.
5. Log every AI chat in `appendix_ai.txt`.
