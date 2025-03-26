rule extract_primers:
    input:
        i_sequences = qiime2_dir("merged", "merged_sequences.qza"),
        i_taxonomy = qiime2_dir("merged", "merged_taxonomy.qza")
    output:
        o_extracted_seqs_qza = qiime2_dir("extracted", "extracted_no_derep_sequences.qza"),
        o_extracted_seqs_qzv = qiime2_dir("extracted", "extracted_no_derep_sequences.qzv"),
        o_sequences_qza = qiime2_dir("extracted", "EFseqF350_EFseqR_sequences.qza"),
        o_sequences_qzv = qiime2_dir("extracted", "EFseqF350_EFseqR_sequences.qzv"),
        o_taxonomy = qiime2_dir("extracted", "EFseqF350_EFseqR_taxonomy.qza")        
    params:
        outdir = qiime2_dir("extracted"),
        primer_f = primer_seq_f,
        primer_r = primer_seq_r,
        nthreads = config["extract_n_threads"]
    conda:
        conda_qiime2
    shell:
        """
        mkdir -p {params.outdir}
        >&2 printf "\nExtract amplicon with PCR primers:\n"
        time qiime feature-classifier extract-reads \
          --i-sequences {input.i_sequences} \
          --p-f-primer {params.primer_f} \
          --p-r-primer {params.primer_r} \
          --p-n-jobs {params.nthreads} \
          --o-reads {output.o_extracted_seqs_qza}
        >&2 printf "\nQZV generation:\n"
        time qiime feature-table tabulate-seqs \
          --i-data {output.o_extracted_seqs_qza} \
          --o-visualization {output.o_extracted_seqs_qzv}
        >&2 printf "\nDereplicate amplicon sequences:\n"
        time qiime rescript dereplicate \
          --i-sequences {output.o_extracted_seqs_qza} \
          --i-taxa {input.i_taxonomy} \
          --p-mode 'uniq' \
          --o-dereplicated-sequences {output.o_sequences_qza} \
          --o-dereplicated-taxa {output.o_taxonomy}
        >&2 printf "\nQZV generation:\n"
        time qiime feature-table tabulate-seqs \
          --i-data {output.o_sequences_qza} \
          --o-visualization {output.o_sequences_qzv}
        """