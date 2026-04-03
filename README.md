# Whose Values? — ICWSM 2026 supplementary materials

This repository holds code and sample data associated with the paper **Whose Values? Measuring the (Subjective) Expression of Basic Human Values in Social Media**, accepted at the [International AAAI Conference on Web and Social Media (ICWSM)](https://www.icwsm.org/) 2026.

## Paper

The work studies how [Schwartz](https://en.wikipedia.org/wiki/Theory_of_basic_human_values)-style **basic human values** show up in social media posts, and how subjective those judgments are when many people label the same content. It introduces a **personalized calibration** approach so models can align value predictions with individual annotators using a small number of calibration labels.

- **arXiv:** [https://arxiv.org/abs/2511.08453](https://arxiv.org/abs/2511.08453)

If you use this repository or build on the ideas in the paper, please cite:

```bibtex
@inproceedings{epstein2026whose,
  title     = {Whose Values? Measuring the (Subjective) Expression of Basic Human Values in Social Media},
  author    = {Epstein, Ziv and Jahanbakhsh, Farnaz and Piccardi, Tiziano and Gallegos, Isabel and Zhao, Dora and Ugander, Johan and Bernstein, Michael},
  booktitle = {Proceedings of the International AAAI Conference on Web and Social Media},
  year      = {2026}
}
```

(You can also cite the arXiv version: `arXiv:2511.08453`.)

## What is in this repository

| Path | Description |
|------|-------------|
| [`data/test_data.csv`](data/test_data.csv) | Example tabular export: one row per (post, participant). Columns include post identifiers (`fid`), participant IDs (`PROLIFIC_PID`), human value ratings at multiple granularities (`val3_*`, `val2_*`, …), model outputs (e.g. base and fine-tuned GPT-style columns, `Rating_*_SCHWARTZ`), and calibrated predictions (`*_yhat`). |
| [`results.R`](results.R) | R script that aggregates **human–human**, **human–consensus**, and **human–model** agreement (Spearman/Pearson correlations and MAE-style summaries) per post, then summarizes means. It also includes optional code to plot average Spearman correlations with error bars; set the PDF path in that block before exporting. |

The CSV is suitable for reproducing the **evaluation logic** sketched in the script (see Figure 5, not the full data collection or model training pipeline). Replace `data/test_data.csv` with your full export if you have access to the complete study data.

## Running the analysis


1. From the repository root:

   ```bash
   Rscript results.R
   ```

2. The script prints column means of the evaluation matrix. To generate the figure, edit the `pdf("path/to/file/export.pdf", ...)` line in `results.R` to a real path, then re-run.

## License

The full dataset is available via a Data Rights Agreement (DRA) to other researchers on a one by one basis. Please contact us (find email address in paper) if you want access to the data.
