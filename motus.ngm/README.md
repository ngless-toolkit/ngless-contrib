# About

This external module integrates:

mOTUs version 2.6

## Citation

    Alessio Milanese, Daniel R Mende, Lucas Paoli, Guillem Salazar,
    Hans-Joachim Ruscheweyh, Miguelangel Cuenca, Pascal Hingamp, Renato Alves,
    Paul I Costea, Luis Pedro Coelho, Thomas S B Schmidt, Alexandre Almeida,
    Alex L Mitchell, Robert D Finn, Jaime Huerta-Cepas, Peer Bork, Georg Zeller
    & Shinichi Sunagawa. Microbial abundance, activity and population genomic
    profiling with mOTUs2; Nature Communications 10, Article number: 1014
    (2019). doi: 10.1038/s41467-019-08844-4


# Usage

Functions provided:

* `motus`

Arguments for `motus`:

| Argument | Type | Required | Default | Options |
| --- | --- | --- | --- | --- |
| `sample` | str | true |   |   |
| `specI_only` | flag | false | false |   |
| `relative_abundance` | flag | false | false |   |
| `taxonomic_level` | option | false | `mOTU` | `kingdom`, `phylum`, `class`, `order`, `family`, `genus`, `mOTU` |
| `no_marker_genes` | option | false | `3` | `1..10` |
| `length_alignment` | option | false | `75` |  |

Returns `counts` compatible with `collect()`.

## Example

```
ngless "0.6"
local import "motus" version "2.6"
import "parallel" version "0.6"
import "mocat" version "0.0"

samples = readlines("all_samples.txt")
sample = lock1(samples)
files = load_mocat_sample(sample)

files = preprocess(files, keep_singles=False) using |read|:
    read = substrim(read, min_quality=25)
    if len(read) < 45:
        discard

count = motus(files,
              sample=sample,
              relative_abundance=true)

collect(count,
        current=sample,
        allneeded=samples,
        ofile='all_samples.motusv2.relabund.tsv')
```
