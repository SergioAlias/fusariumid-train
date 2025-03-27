rule train:
    input:
        i_sequences = train_input_seqs,
        i_taxonomy = train_input_taxa 
    output:
        o_classifier = classifier_filename      
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