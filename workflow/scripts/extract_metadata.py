#!/usr/bin/env python3

# Sergio Alías, 20241203
# Last modified 20241203

# Small script for extracting metadata from FASTA headings of FUSARIUM-ID v3.0 file

import sys

input_file = sys.argv[1]
output_file = sys.argv[2]

with open(input_file, 'r') as fasta_file, open(output_file, 'w') as tsv_file:
    for line in fasta_file:
        if line.startswith('>'):
            full_header = line[1:].strip()
            fields = full_header.split('|')
            while len(fields) < 7:
                fields.append('')
            tsv_file.write(full_header + '\t' + '\t'.join(fields) + '\n')
