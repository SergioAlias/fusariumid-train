rule correct_format:
    input:
        os.path.join(config["db_dir"], config["db_file"])
    output:
        metadata_dir("corrected_db.fas")
    params:
        outdir = metadata_dir(),
        correction_filepath = correct_format_filepath
    shell:
        """
        mkdir -p {params.outdir}
        SED_SCRIPT=$(awk -F'\t' '{{print "s/" $1 "/" $2 "/g"}}' "{params.correction_filepath}")
        sed "$SED_SCRIPT" "{input}" > "{output}"
        """