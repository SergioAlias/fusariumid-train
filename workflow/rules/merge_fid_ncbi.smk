rule merge_fid_ncbi:
    input:
        i_ncbi_seq = qiime2_dir("filtered", "ncbi_sequences_full_length.qza"),
        i_ncbi_tax = qiime2_dir("filtered", "ncbi_taxonomy_full_length.qza"),
        i_fid_seq = qiime2_dir("imported", "fid_sequences.qza"),
        i_fid_tax = fid_taxonomy_qza

    output:
        o_sequences_qza = qiime2_dir("merged", "merged_sequences.qza"),
        o_sequences_qzv = qiime2_dir("merged", "merged_sequences.qzv"),
        o_taxonomy = merged_taxonomy_qza        
    params:
        outdir = qiime2_dir("merged")
    conda:
        conda_qiime2
    shell:
        """
        mkdir -p {params.outdir}
        >&2 printf "\nMerge sequences:\n"
        time qiime feature-table merge-seqs \
          --i-data {input.i_ncbi_seq} {input.i_fid_seq} \
          --o-merged-data {output.o_sequences_qza}
        >&2 printf "\nMerge taxonomy:\n"
        time qiime feature-table merge-taxa \
          --i-data {input.i_ncbi_tax} {input.i_fid_tax} \
          --o-merged-data {output.o_taxonomy}
        >&2 printf "\nQZV generation:\n"
        time qiime feature-table tabulate-seqs \
          --i-data {output.o_sequences_qza} \
          --o-visualization {output.o_sequences_qzv}
        """