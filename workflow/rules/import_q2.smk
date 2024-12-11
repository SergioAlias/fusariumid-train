rule import_q2:
    input:
        i_sequences = metadata_dir("corrected_db.fas"),
        i_taxonomy = metadata_dir("taxonomy.tsv")
    output:
        o_sequences = qiime2_dir("imported", "fid_sequences.qza"),
        o_taxonomy = qiime2_dir("imported", "fid_taxonomy.qza")        
    params:
        outdir = qiime2_dir("imported")
    conda:
        conda_qiime2
    shell:
        """
        mkdir -p {params.outdir}
        >&2 printf "\nImport sequences:\n"
        time qiime tools import \
          --input-path {input.i_sequences} \
          --output-path {output.o_sequences} \
          --type FeatureData[Sequence] \
          --input-format MixedCaseDNAFASTAFormat
        >&2 printf "\nImport taxonomy:\n"
        time qiime tools import \
          --input-path {input.i_taxonomy} \
          --output-path {output.o_taxonomy} \
          --type FeatureData[Taxonomy] \
          --input-format HeaderlessTSVTaxonomyFormat 
        """