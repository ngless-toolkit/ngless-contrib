# About

This external module integrates: 

mOTUs version 2.0

## Citation

At the time of writing mOTU v2 lacks a publication, meanwhile please cite:

Sunagawa et al. - Metagenomic species profiling using universal phylogenetic marker genes  
Nature Methods 10, 1196-1199 (2013)

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

Returns `counts` compatible with `collect()`.

## Example

```
ngless "0.6"
import "motus" version "2.0"
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
        ofile='outputs/all_samples.motusv2.relabund.tsv')
```
