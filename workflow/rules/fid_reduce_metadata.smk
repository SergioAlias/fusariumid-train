rule fid_reduce_metadata:
    input:
        metadata_dir("metadata.tsv")
    output:
        metadata_dir("reduced_metadata.tsv")
    shell:
        """
        time awk -F'\t' 'BEGIN {{ OFS="\t" }} {{ print $1, $4 "__" $5 }}' {input} > {output}
        """