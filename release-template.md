# FUSARIUM-ID v3.0 for QIIME 2 version 2024.2

> ⚠️ I am not affiliated to the FUSARIUM-ID team. Classifiers are provided _as is_, without any guarantees or warranties.

Naive Bayes Classifiers for [FUSARIUM-ID v3.0](https://github.com/fusariumid/fusariumid/releases/tag/v.3.0) trained for QIIME 2 version [2024.2](https://docs.qiime2.org/2024.2/install/).



## 📝 Changelog 

- First release! 🎉
- Updated FUSARIUM-ID to version 3.0.
- Updated TEF1 sequences of non-*Fusarium* fungi and other eukaryotes: downloaded **93,977 sequences** from NCBI GenBank on **March 26, 2025** using the [query](https://github.com/SergioAlias/fusariumid-train/blob/main/resources/query.txt).

## 📊 Classifiers

We provide different classifiers according to whether we extract the amplicon region with PCR primers:

- `full_length` **(not recommended!)**: Full length sequences as they were downloaded from NCBI GenBank and FUSARIUM-ID. Note that sequences in the range of 100-3000 bp were downloaded from GenBank (see the [query](https://github.com/SergioAlias/fusariumid-train/blob/main/resources/query.txt), `(100[SLEN]:3000[SLEN])`).

- Amplicon region extracted with primer sequences, ideally the same primer sequences that you used for your PCR / sequencing:
  - `EFseqF350_EFseqR`:  Amplicon region extracted with custom primers we use in the lab.

  - `EF1-F2_EF1-R3`: Amplicon region extracted with primers used in [Boutigny et al. (2019)](https://doi.org/10.1371/journal.pone.0207988).

  - 🤔 Should I add other common primers? [Open an issue!](https://github.com/SergioAlias/fusariumid-train/issues/new?title=Add%20pre-computed%20classifiers%20with%20primer%20set:%20)

You can check primer sequences [here](https://github.com/SergioAlias/fusariumid-train/blob/main/resources/TEF1_primers.tsv?plain=1).

We also provide two types of classifiers according to the information we keep from FUSARIUM-ID metadata:

- `until_sp`: *Fusarium* taxonomy only contains the species name in the `s__` level.

- `all_info`: *Fusarium* taxonomy contains the species name and the [Species Complex](https://doi.org/10.1016/j.funbio.2024.07.004) in the `s__` level.

<details>
<summary>🔍 Why is this relevant? (click to show)</summary>
<br>

> FUSARIUM-ID contains some undescribed *Fusarium* entries. These are annotated at the species level with the Species Complex to which the sequence belongs inmediately followed by the string "undesc" (e.g. FFSCundesc). However, when available, informal *ad hoc* nomenclature (Species Complex designation followed by a number) is included for those undescribed species (e.g. FSAMSC1).
>
> If you plan to collapse your ASV table at the species level, you may want to consider all the undescribed *Fusarium* from a given Species Complex as the same "species" (using `until_sp` classifiers) or you may want to keep the *ad hoc* separation made by FUSARIUM-ID curators (i.e., use `all_info` classifiers). If you work at the ASV level, also note that sequences may vary slightly between these classifiers because there is a de-replication step that may remove undescribed sequences from the same Species Complex that are 100% identical.

</details>

## 🤝 References

If you use the classifiers, you should cite the following papers (click to show each section):

<details>
<summary>⚙️ Workflow methods</summary>
<br>

> Bokulich, N. A., Kaehler, B. D., Rideout, J. R., Dillon, M., Bolyen, E., Knight, R., Huttley, G. A., & Caporaso, J. G. (2018). Optimizing taxonomic classification of marker-gene amplicon sequences with QIIME 2’s q2-feature-classifier plugin. Microbiome, 6(1), 90. https://doi.org/10.1186/s40168-018-0470-z
>
> Bolyen, E., Rideout, J. R., Dillon, M. R., Bokulich, N. A., Abnet, C. C., Al-Ghalith, G. A., Alexander, H., Alm, E. J., Arumugam, M., Asnicar, F., Bai, Y., Bisanz, J. E., Bittinger, K., Brejnrod, A., Brislawn, C. J., Brown, C. T., Callahan, B. J., Caraballo-Rodríguez, A. M., Chase, J., … Caporaso, J. G. (2019). Reproducible, interactive, scalable and extensible microbiome data science using QIIME 2. Nature Biotechnology, 37(8), 852–857. https://doi.org/10.1038/s41587-019-0209-9
>
> Pedregosa, F., Varoquaux, G., Gramfort, A., Michel, V., Thirion, B., Grisel, O., Blondel, M., Prettenhofer, P., Weiss, R., Dubourg, V., Vanderplas, J., Passos, A., Cournapeau, D., Brucher, M., Perrot, M., & Duchesnay, É. (2011). Scikit-learn: Machine learning in Python. Journal of Machine Learning Research, 12(Oct), 2825–2830.
>
> Robeson, M. S., O'Rourke, D. R., Kaehler, B. D., Ziemski, M., Dillon, M. R., Foster, J. T., & Bokulich, N. A. (2021). RESCRIPt: Reproducible sequence taxonomy reference database management. PLoS Computational Biology. https://doi.org/10.1371/journal.pcbi.1009581
>
> Rognes, T., Flouri, T., Nichols, B., Quince, C., & Mahé, F. (2016). VSEARCH: a versatile open source tool for metagenomics. PeerJ, 4, e2584. https://doi.org/10.7717/peerj.2584
> 
> Wes McKinney. (2010). Data Structures for Statistical Computing in Python . In S. van der Walt & Jarrod Millman (Eds.), Proceedings of the 9th Python in Science Conference (pp. 51–56).

</details>

<details>
<summary>🧬 NCBI GenBank</summary>
<br>

> Benson, D. A., Cavanaugh, M., Clark, K., Karsch-Mizrachi, I., Lipman, D. J., Ostell, J., & Sayers, E. W. (2012). GenBank. Nucleic Acids Research, 41(D1), D36–D42.
>
> Coordinators, N. R. (2018). Database resources of the national center for biotechnology information. Nucleic Acids Research, 46(D1), D8–D13. https://doi.org/10.1093/nar/gkx1095

</details>

<details>
<summary>🍄 FUSARIUM-ID v3.0</summary>
<br>

> Torres-Cruz, T. J., Whitaker, B. K., Proctor, R. H., Broders, K., Laraba, I., Kim, H. S., ... & Geiser, D. M. (2022). FUSARIUM-ID v. 3.0: An updated, downloadable resource for *Fusarium* species identification. Plant disease, 106(6), 1610-1616. https://doi.org/10.1094/PDIS-09-21-2105-SR

</details>

