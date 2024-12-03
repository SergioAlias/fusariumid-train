#!/bin/bash

echo "🍄 Running init_fusariumid_train.sh"

while [[ $CONDA_DEFAULT_ENV ]]; do
    echo "🍄 Deactivating current Conda environment: $CONDA_DEFAULT_ENV"
    conda deactivate
done

if { conda env list | grep 'fidt-main'; } >/dev/null 2>&1; then
  echo "🍄 Environment fidt-main is already installed."
else
  echo "🍄 Installing environment fidt-main...."
  conda env create --file config/smk_conda.yml
  echo "🍄 Environment fidt-main installed successfully."
fi

echo "🍄 Activating environment..."
conda activate fidt-main

echo "🍄 Setting aliases..."

## Default njobs is 30. Feel free to change it in fidt_run and fidt_inmediate

alias fidt_run='snakemake --use-conda --cluster "sbatch -J {cluster.jobname} -t {cluster.time} --mem {cluster.memory} -c {cluster.ncpus} -o {cluster.output} -e {cluster.error}" --cluster-config config/cluster_config.yml --jobs 30'
alias fidt_immediate='snakemake --use-conda --cluster-config config/cluster_config.yml --jobs 30 -pr --immediate-submit --notemp --cluster "python3 workflow/scripts/immediate_submit.py {dependencies}"'
alias fidt_draw_dag='snakemake -f --dag | dot -Tpdf > dag.pdf'
alias fidt_draw_rulegraph='snakemake -f --rulegraph | dot -Tpdf > rulegraph.pdf'
alias fidt_draw_filegraph='snakemake -f --filegraph | dot -Tpdf > filegraph.pdf'


echo "🍄 FUSARIUM-ID-train loaded successfully!"
echo "    ⚙️  Use fidt_run to run FUSARIUM-ID-train in a Slurm HPC queue system"
echo "    ⚙️  Use fidt_immediate to run FUSARIUM-ID-train and send all jobs to the queue system at once (not recommended)"
echo "    ⚙️  Use fidt_draw_dag to draw a DAG of the workflow in dag.pdf"
echo "    ⚙️  Use fidt_draw_rulegraph to draw a rule graph of the workflow in rulegraph.pdf"
echo "    ⚙️  Use fidt_draw_filegraph to draw a file graph of the workflow in filegraph.pdf"

