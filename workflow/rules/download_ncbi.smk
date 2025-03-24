rule download_ncbi:
    output:
        o_sequences_qza = qiime2_dir("imported", "ncbi_sequences_unfiltered.qza"),
        o_sequences_qzv = qiime2_dir("imported", "ncbi_sequences_unfiltered.qzv"),
        o_taxonomy = qiime2_dir("imported", "ncbi_taxonomy_unfiltered.qza")        
    params:
        outdir = qiime2_dir("imported"),
        query = ncbi_query,
        njobs = config["download_njobs"]
    conda:
        conda_qiime2
    shell:
        """
        mkdir -p {params.outdir}
        >&2 printf "\nDownload TEF1 sequences from NCBI:\n"
        time qiime rescript get-ncbi-data \
          --p-query "{params.query}" \
          --p-rank-propagation \
          --p-logging-level 'INFO' \
          --p-n-jobs {params.njobs} \
          --o-sequences {output.o_sequences_qza} \
          --o-taxonomy {output.o_taxonomy} \
          --verbose
        >&2 printf "\nQZV generation:\n"
        time qiime feature-table tabulate-seqs \
          --i-data {output.o_sequences_qza} \
          --o-visualization {output.o_sequences_qzv}
        """