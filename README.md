# <img src="./.img/fidt_negative.png" width="500">

[![Release-date](https://img.shields.io/github/release-date-pre/SergioAlias/fusariumid-train?display_date=published_at&label=Release+date)](https://github.com/SergioAlias/fusariumid-train/releases)
[![Downloads](https://img.shields.io/github/downloads/SergioAlias/fusariumid-train/total.svg?label=Downloads)](https://github.com/SergioAlias/fusariumid-train/releases)
[![Snakemake](https://img.shields.io/badge/Snakemake-7.32.4-ffffff.svg)](https://snakemake.github.io)
[![QIIME 2](https://img.shields.io/badge/QIIME2-2024.2-0096FF.svg)](https://qiime2.org/)

⚙️ 🍄 **FUSARIUM-ID Naive Bayes classifiers for QIIME 2**

---

### [🎉 Pre-trained FUSARIUM-ID classifiers available here!](https://github.com/SergioAlias/fusariumid-train/releases)

---

A [Snakemake](https://snakemake.readthedocs.io/en/v7.32.2/) workflow to train [QIIME 2](https://qiime2.org/) taxonomic [Naive Bayes classifiers](https://resources.qiime2.org/#qiime-2-2024-5-present) for the [FUSARIUM-ID database](https://github.com/fusariumid/fusariumid). This database contains sequences of the Translation Elongation Factor 1 alpha (TEF1, also known as EF1α), which serves as a considerably better marker for species identification in the filamentous fungal genus [*Fusarium*](https://en.wikipedia.org/wiki/Fusarium) than [ITS](https://en.wikipedia.org/wiki/Internal_transcribed_spacer), the standard marker for all Fungi.

If you don't want to run the workflow, you can [pick one of the pre-computed classfiers here!](https://github.com/SergioAlias/fusariumid-train/releases).

>🐍 *This workflow uses Snakemake 7.32.4. Newer versions (8+) contain [backwards incompatible changes](https://snakemake.readthedocs.io/en/stable/getting_started/migration.html) that may result in this pipeline not working in a Slurm HPC queue system.*

This pipeline:

1. Parses the FUSARIUM-ID multi-FASTA headers searching metadata and saves it as a TSV file (rules `fid_correct_format`, `fid_extract_metadata` and `fid_reduce_metadata`). You can read about how FUSARIUM-ID stores metadata in [this manual](https://github.com/fusariumid/fusariumid/blob/main/FUSARIUMID_BLAST_Tutorials.pdf) (Spanish version [here](https://github.com/fusariumid/fusariumid/blob/main/FUSARIUMID_BLAST_Tutoriales_Espan%CC%83ol.pdf)) and in the [FUSARIUM-ID publication](https://apsjournals.apsnet.org/doi/10.1094/PDIS-09-21-2105-SR).

2. Formats metadata to match SILVA and UNITE taxonomy style (rule `fid_build_taxonomy`).
   
3. Imports taxonomy and sequences into QIIME 2 (rule `fid_import_q2`).

4. Downloads TEF1 sequences from GenBank for non-*Fusarium* fungi and other eukaryotes using a modified version of a query used in [Boutigny et al. (2019)](https://doi.org/10.1371/journal.pone.0207988) (rule `download_ncbi`).

5. Filters and dereplicates NCBI GenBank sequences (rule `filter_ncbi`).

6. Merges FUSARIUM-ID and NCBI GenBank sequences (rule `merge_fid_ncbi`).

7. Optionally, extracts the amplicon region using PCR primers and dereplicates again (rule `extract_primers`).

8. Trains a Naive Bayes classfier that can be used in [`qiime feature-classifier classify-sklearn`](https://docs.qiime2.org/2024.2/plugins/available/feature-classifier/classify-sklearn/) (rule `train`).

## Requisites

The only prerequisite is having Conda installed. In this regard, we **highly recommend** installing [Miniconda](https://docs.anaconda.com/free/miniconda/index.html) and then installing [Mamba](https://anaconda.org/conda-forge/mamba) (used by default by Snakemake) for a lightweight and fast experience.

## Usage

1. Clone the repository

2. Create a Screen (see section [**Immediate submit and Screen**](#immediate-submit-and-screen))

3. Run the following command to download (if needed) and activate the FUSARIUM-ID-train environment, and to set aliases for the main functions:
```bash
source init_fusariumid_train.sh
```
4. Download FUSARIUM-ID v3.0 FASTA file from [https://github.com/fusariumid/fusariumid](https://github.com/fusariumid/fusariumid) (`FUSARIUMID_v.3.0_TEF1.fas`).
   
5. Edit `config/config.yml` with your specific requirements. Variables annotated with #cluster# must also be updated in `config/cluster_config.yml`.

6. If needed, modify `time`, `ncpus` and `memory` variables in `config/cluster_config.yml`.

7. Run `fidt_run` to start the workflow. You can also run it until some key steps (using `--until rule_name`) to check the results before continuing and to change parameters if necessary (recommended). For example, a possible workflow split could be (see [**Drawing DAGs and rule graphs**](#drawing-dags-and-rule-graphs) for a visual workflow including all rule names):

```bash
fidt_run --until download_ncbi     # download sequences from NCBI GenBank (read the warning below)
fidt_run --until filter_ncbi       # quality filtering and dereplication of NCBI sequences
fidt_run                           # rest of workflow


# Tip: add the flag -n to perform a dry-run. You will see how many jobs 
# will be executed without actually running the workflow.

# Example:

# fidt_run --until download_ncbi -n
```
> ⚠️ **Before downloading sequences from NCBI GenBank**, please be aware of the **NCBI Disclaimer and Copyright notice** ([Policies and Disclaimers - NCBI](https://www.ncbi.nlm.nih.gov/home/about/policies/)), particularly *"run retrieval scripts on weekends or between 9 pm and 5 am Eastern Time weekdays for any series of more than 100 requests"*. As a rule of thumb, if you are downloading **more than 125,000 sequences**, only run this method at those times.


## Immediate submit and Screen

FUSARIUM-ID-train inlcudes a command, `fidt_immediate`, that automatically sends all jobs to Slurm, correctly queued according to their dependencies. This is desirable e.g. when the runtime in the cluster login machine is very short, because it may kill Snakemake in the middle of the workflow. If your HPC queue system only allows a limited number of jobs submitted at once, change that number in `init_fusariumid_train.sh` and source it again (that also applies for `fidt_run`).

Please note that if the number of simultaneous jobs accepted by the queue system is less than the total number of jobs you need to submit, the workflow will fail. For such cases, we highly recommend not using `fidt_immediate`. Instead, use `fidt_run` inside a Screen. Screen is a multiplexer that lets you create multiple virtual terminal sessions. It is installed by default in most Linux HPC systems.

To create a screen, use `screen -S fusariumid_train`. Then, follow usage section there. You can dettach the screen with `Ctrl+a` and then `d`. You can attach the screen again with `screen -r fusariumid_train`. For more details about Screen usage, please check [this Gist](https://gist.github.com/jctosta/af918e1618682638aa82).

## Drawing DAGs and rule graphs

Since FUSARIUM-ID-train is built over Snakemake, you can generate DAGs, rule graphs and file graphs of the workflow. We provide three commands for this: `fidt_draw_dag`, `fidt_draw_rulegraph` and `fidt_draw_filegraph`. These commands create `dag.pdf`, `rulegraph.pdf` and `filegraph.pdf` in the code directory.