rule fid_extract_metadata:
    input:
        metadata_dir("corrected_db.fas")
    output:
        metadata_dir("metadata.tsv")
    shell:
        """
        time python3 workflow/scripts/extract_metadata.py {input} {output}
        """