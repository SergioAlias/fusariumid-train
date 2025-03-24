rule filter_ncbi:
    input:
        i_sequences = qiime2_dir("imported", "ncbi_sequences_unfiltered.qza"),
        i_taxonomy = qiime2_dir("imported", "ncbi_taxonomy_unfiltered.qza")        
    output:
        o_culled_seqs_qza = qiime2_dir("filtered", "ncbi_sequences_culled.qza"),
        o_culled_seqs_qzv = qiime2_dir("filtered", "ncbi_sequences_culled.qzv"),
        o_sequences_qza = qiime2_dir("filtered", "ncbi_sequences_full_length.qza"),
        o_sequences_qzv = qiime2_dir("filtered", "ncbi_sequences_full_length.qzv"),
        o_taxonomy = qiime2_dir("filtered", "ncbi_taxonomy_full_length.qza")        
    params:
        outdir = qiime2_dir("filtered")
    conda:
        conda_qiime2
    shell:
        """
        mkdir -p {params.outdir}
        >&2 printf "\nCull sequences:\n"
        time qiime rescript cull-seqs \
          --i-sequences {input.i_sequences} \
          --o-clean-sequences {output.o_culled_seqs_qza}
        >&2 printf "\nQZV generation:\n"
        time qiime feature-table tabulate-seqs \
          --i-data {output.o_culled_seqs_qza} \
          --o-visualization {output.o_culled_seqs_qzv}
        >&2 printf "\nDereplicate full length sequences:\n"
        time qiime rescript dereplicate \
          --i-sequences {output.o_culled_seqs_qza} \
          --i-taxa {input.i_taxonomy} \
          --p-mode 'uniq' \
          --o-dereplicated-sequences {output.o_sequences_qza} \
          --o-dereplicated-taxa {output.o_taxonomy}
        >&2 printf "\nQZV generation:\n"
        time qiime feature-table tabulate-seqs \
          --i-data {output.o_sequences_qza} \
          --o-visualization {output.o_sequences_qzv}
        """