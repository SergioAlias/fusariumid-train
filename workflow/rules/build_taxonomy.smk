rule build_taxonomy:
    input:
        metadata_dir("metadata.tsv")
    output:
        metadata_dir("taxonomy.tsv")
    params:
    shell:
        """
        time awk -F'\t' 'BEGIN {{ OFS="\t" }} {{ print $1, $4 "__" $5 }}' {input} > {output}
        """