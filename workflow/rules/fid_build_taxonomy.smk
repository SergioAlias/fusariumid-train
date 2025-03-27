rule fid_build_taxonomy:
    input:
        metadata_dir("reduced_metadata.tsv")
    output:
        fid_taxonomy_tsv
    params:
        keep_metadata = config["keep_metadata"]
    shell:
        """
        time python3 workflow/scripts/build_taxonomy.py {input} {output} {params.keep_metadata}
        """