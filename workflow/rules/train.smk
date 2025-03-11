rule train:
    input:
        i_sequences = qiime2_dir("imported", "fid_sequences.qza"),
        i_taxonomy = qiime2_dir("imported", "fid_taxonomy.qza") 
    output:
        o_classifier = qiime2_dir("classifier", "fid_classifier.qza")      
    params:
        outdir = qiime2_dir("classifier")
    conda:
        conda_qiime2
    shell:
        """
        mkdir -p {params.outdir}
        >&2 printf "\nTrain classifier:\n"
        time qiime feature-classifier fit-classifier-naive-bayes \
          --i-reference-reads {input.i_sequences} \
          --i-reference-taxonomy {input.i_taxonomy} \
          --o-classifier {output.o_classifier}
        """