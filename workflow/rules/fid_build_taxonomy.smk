rule fid_build_taxonomy:
    input:
        metadata_dir("reduced_metadata.tsv")
    output:
        metadata_dir("taxonomy.tsv")
    shell:
        """
        time python3 workflow/scripts/build_taxonomy.py {input} {output}
        """