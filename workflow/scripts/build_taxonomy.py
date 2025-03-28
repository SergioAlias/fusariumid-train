#!/usr/bin/env python3

# Sergio Alías, 20241203
# Last modified 20250327

# Small script for building a taxonomy file with the UNITE format

import csv, sys

input_file = sys.argv[1]
output_file = sys.argv[2]
keep_metadata = str(sys.argv[3])

with open(input_file, 'r') as infile, open(output_file, 'w', newline='') as outfile:
    reader = csv.reader(infile, delimiter='\t')
    writer = csv.writer(outfile, delimiter='\t')
    for row in reader:
        second_col = row[1]
        if second_col.startswith("Outgroup_Nectriaceae__"):
            rest = second_col.replace("Outgroup_Nectriaceae__", "")
            genus, specific_epithet = rest.split("_", 1)
            taxonomy = (
                f"k__Fungi;p__Ascomycota;c__Sordariomycetes;o__Hypocreales;"
                f"f__Nectriaceae;g__{genus};s__{specific_epithet}"
            )
        else:
            genus_species = second_col.split("__")
            if len(genus_species) == 2:
                genus = "Fusarium"
                specific_epithet = genus_species[1].replace("'", "") # oxysporum is quoted for some reason
                if keep_metadata == "True":
                    strain_name = genus_species[0]
                    specific_epithet = f"{specific_epithet}_{strain_name}"
                taxonomy = (
                    f"k__Fungi;p__Ascomycota;c__Sordariomycetes;o__Hypocreales;"
                    f"f__Nectriaceae;g__{genus};s__{specific_epithet}"
                )
            else:
                taxonomy = "FIDT-error: Unexpected format"
        writer.writerow([row[0], taxonomy])

