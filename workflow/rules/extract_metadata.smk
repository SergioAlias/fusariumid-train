rule extract_metadata:
    input:
        os.path.join(config["db_dir"], config["db_file"])
    output:
        metadata_dir("metadata.tsv")
    params:
        outdir = metadata_dir()
    shell:
        """
        time python3 workflow/scripts/extract_metadata.py {input} {output} {params.outdir}
        """