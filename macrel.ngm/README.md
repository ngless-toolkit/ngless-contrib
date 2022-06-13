# About

This external module integrates `macrel` into NGLess (See [Macrel
docs](https://macrel.readthedocs.io/en/latest/install/) for how to install
macrel).



## Citation

> Santos-Júnior CD, Pan S, Zhao X, Coelho LP. 2020. Macrel: antimicrobial
> peptide screening in genomes and metagenomes. PeerJ 8:e10555
> [DOI:10.7717/peerj.10555](https://doi.org/10.7717/peerj.10555)

# Usage

Functions provided:

* `macrel_amps_to` - performs `macrel contigs` (_i.e._, takes contigs and produces AMPs)
* `macrel_smorfs_to` - performs `macrel get-smorfs`

As of version `1.2.0`, both of these functions have a sub-optimal interface in that they take an argument specifying


Example

    ngless "1.4"
    local import "macrel" version "1.2.0"

    inputs = paired('input1.fq.gz', 'inputs2.fq.gz')
    contigs = assemble(inputs)
    macrel_smorfs_to(contigs,  ofile='smorfs.fna')
    macrel_amps_to(contigs,  output='outputs')


