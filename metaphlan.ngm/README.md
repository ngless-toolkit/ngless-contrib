# About

This external module integrates: 

metaphlan version 2 (aka metaphlan2)

## Citation

Truong et al. - MetaPhlAn2 for enhanced metagenomic taxonomic profiling
Nature Methods 12, 902–903 (2015)

# Usage

Functions provided:

* `metaphlan`

Arguments for `metaphlan`:

| Argument | Type | Required | Default | Options |
| --- | --- | --- | --- | --- |
| `ignore_viruses` | flag | false | false |   |
| `ignore_eukaryotes` | flag | false | false |   |
| `ignore_archaea` | flag | false | false |   |
| `ignore_bacteria` | flag | false | false |   |
| `taxonomic_level` | option | false | `a` | `a`, `k`, `p`, `c`, `o`, `f`, `g`, `s`
| `analysis_type` | option | false | `rel_ab` | `rel_ab`, `rel_ab_w`, `reads_mapzxc`, `clade_profiles`, `marker_ab_table`, `marker_counts` |

Returns `counts` compatible with `collect()`.

## Example

```
ngless "0.6"
local import "metaphlan" version "2.0"
import "parallel" version "0.6"
import "mocat" version "0.0"

samples = readlines("all_samples.txt")
sample = lock1(samples)
files = load_mocat_sample(sample)

files = preprocess(files, keep_singles=False) using |read|:
    read = substrim(read, min_quality=25)
    if len(read) < 45:
        discard

count = metaphlan(files,
                  ignore_eukaryotes=true)

collect(count,
        current=sample,
        allneeded=samples,
        ofile='outputs/all_samples.metaphlan2.tsv')

```
