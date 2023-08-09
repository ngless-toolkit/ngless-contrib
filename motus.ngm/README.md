# About

This external module integrates:

mOTUs version 3.1

## Citation

    Hans-Joachim Ruscheweyh, Alessio Milanese, Lucas Paoli, Nicolai Karcher,
    Quentin Clayssen, Marisa Isabell Metzger, Jakob Wirbel, Peer Bork,
    Daniel R. Mende, Georg Zeller & Shinichi Sunagawa. Reference
    genome-independent taxonomic profiling of microbiomes with mOTUs3;
    Microbiome (2022). doi: 10.1186/s40168-022-01410-z

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
ngless "1.0"
local import "motus" version "3.1"
import "parallel" version "0.6"
import "mocat" version "0.0"

samples = readlines("all_samples.txt")
sample = lock1(samples)
files = load_fastq_directory(sample)

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
