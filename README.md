# <img src="./.img/fidt_negative.png" width="500">

![Release-date](https://img.shields.io/github/release-date-pre/SergioAlias/fusariumid-train?display_date=published_at&label=Release+date)
[![Downloads](https://img.shields.io/github/downloads/SergioAlias/fusariumid-train/total.svg?label=Downloads)](https://github.com/SergioAlias/fusariumid-train/releases)
[![Snakemake](https://img.shields.io/badge/Snakemake-7.32.4-ffffff.svg)](https://snakemake.github.io)
[![QIIME 2](https://img.shields.io/badge/QIIME2-2024.10-0096FF.svg)](https://qiime2.org/)

⚙️ 🍄 **FUSARIUM-ID Naive Bayes classifiers for QIIME 2**

---

### [🎉 Pre-trained FUSAIRUM-ID classifiers available!](https://github.com/SergioAlias/fusariumid-train/releases)

---

A [Snakemake](https://snakemake.readthedocs.io/en/v7.32.2/) workflow to train [QIIME 2](https://qiime2.org/) taxonomic [Naive Bayes classifiers](https://resources.qiime2.org/#qiime-2-2024-5-present) for the [FUSARIUM-ID database](https://github.com/fusariumid/fusariumid). This database contains sequences of the Translation Elongation Factor 1 alpha (TEF1), which serves as a considerably better marker for species identification in the filamentous fungal genus [*Fusarium*](https://en.wikipedia.org/wiki/Fusarium) than [ITS](https://en.wikipedia.org/wiki/Internal_transcribed_spacer), the standard marker for all Fungi.

If you don't want to run the workflow, you can [pick one of the pre-computed classfiers here!](https://github.com/SergioAlias/fusariumid-train/releases)

>🐍 *This workflow uses Snakemake 7.32.4. Newer versions (8+) contain [backwards incompatible changes](https://snakemake.readthedocs.io/en/stable/getting_started/migration.html) that may result in this pipeline not working in a Slurm HPC queue system.*

This pipeline:

1. Parses the multi-FASTA headers searching metadata and saves it as a TSV file. You can read about how FUSARIUM-ID stores metadata in [this manual](https://github.com/fusariumid/fusariumid/blob/main/FUSARIUMID_BLAST_Tutorials.pdf) (Spanish version [here](https://github.com/fusariumid/fusariumid/blob/main/FUSARIUMID_BLAST_Tutoriales_Espan%CC%83ol.pdf)) and in the [FUSARIUM-ID publication](https://apsjournals.apsnet.org/doi/10.1094/PDIS-09-21-2105-SR).

2. Formats metadata to match SILVA and UNITE taxonomy style.

3. Imports taxonomy and sequences into QIIME 2.

4. Trains a Naive Bayes classfier that can be used in [`qiime feature-classifier classify-sklearn`](https://docs.qiime2.org/2024.10/plugins/available/feature-classifier/classify-sklearn/).

## Requisites

The only prerequisite is having Conda installed. In this regard, we **highly recommend** installing [Miniconda](https://docs.anaconda.com/free/miniconda/index.html) and then installing [Mamba](https://anaconda.org/conda-forge/mamba) (used by default by Snakemake) for a lightweight and fast experience.

## Usage

1. Clone the repository

2. Create a Screen (see section **Immediate submit and Screen**)

3. Run the following command to download (if needed) and activate the FUSARIUM-ID-train environment, and to set aliases for the main functions:
```bash
source init_fusariumid_train.sh
```
4. Download FUSARIUM-ID v3.0 FASTA file from [https://github.com/fusariumid/fusariumid](https://github.com/fusariumid/fusariumid) (`FUSARIUMID_v.3.0_TEF1.fas`).
   
5. Edit `config/config.yml` with your specific requirements. Variables annotated with #cluster# must also be updated in `config/cluster_config.yml`.

6. If needed, modify `time`, `ncpus` and `memory` variables in `config/cluster_config.yml`.

7. Run the following command to start the workflow:
```bash
fidt_run
```

## Immediate submit and Screen

FUSARIUM-ID-train inlcudes a command, `fidt_immediate`, that automatically sends all jobs to Slurm, correctly queued according to their dependencies. This is desirable e.g. when the runtime in the cluster login machine is very short, because it may kill Snakemake in the middle of the workflow. If your HPC queue system only allows a limited number of jobs submitted at once, change that number in `init_fusariumid_train.sh` and source it again (that also applies for `fidt_run`).

Please note that if the number of simultaneous jobs accepted by the queue system is less than the total number of jobs you need to submit, the workflow will fail. For such cases, we highly recommend not using `fidt_immediate`. Instead, use `fidt_run` inside a Screen. Screen is a multiplexer that lets you create multiple virtual terminal sessions. It is installed by default in most Linux HPC systems.

To create a screen, use `screen -S fusariumid_train`. Then, follow usage section there. You can dettach the screen with `Ctrl+a` and then `d`. You can attach the screen again with `screen -r fusariumid_train`. For more details about Screen usage, please check [this Gist](https://gist.github.com/jctosta/af918e1618682638aa82).

## Drawing DAGs and rule graphs

Since FUSARIUM-ID-train is built over Snakemake, you can generate DAGs, rule graphs and file graphs of the workflow. We provide three commands for this: `fidt_draw_dag`, `fidt_draw_rulegraph` and `fidt_draw_filegraph`.