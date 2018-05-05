# About

This external module integrates: 

Salmon version 0.9.1

## Citation

Patro, R., Duggal, G., Love, M. I., Irizarry, R. A., & Kingsford, C.
Salmon provides fast and bias-aware quantification of transcript expression.
Nature Methods (2017), doi:10.1038/nmeth.4197

# Usage

Functions provided:

* `salmon_reads` - performs `salmon quant` in quasi mapping mode using reads
                   automatically indexes the provided transcripts file
* `salmon_alignment` - performs `salmon quant` using a bam/sam file

Common arguments:

| Argument | Type | Required | Default | Options |
| --- | --- | --- | --- | --- |
| `transcripts` | str | true |   |   |
| `libtype` | str | false | A |   |
| `sequence_bias_correction` | flag | false | false |   |
| `metagenomics` | flag | false | false |   |

Arguments for `salmon_reads`:

| Argument | Type | Required | Default | Options |
| --- | --- | --- | --- | --- |
| `kmer` | int | false | 31 |   |
| `discard_orphans` | flag | false | false |   |

Arguments for `salmon_alignment`:

* Currently no additional options

Returns `counts` compatible with `collect()`.

## Example

```
ngless "0.6"
local import "salmon" version "0.9.1"
import "parallel" version "0.6"
import "mocat" version "0.0"

DB = "transcripts_of_interest.fasta"

samples = readlines("all_samples.txt")
sample = lock1(samples)
files = load_mocat_sample(sample)

files = preprocess(files, keep_singles=False) using |read|:
    read = substrim(read, min_quality=25)
    if len(read) < 45:
        discard

count = salmon_reads(files,
                     transcripts=DB,
                     metagenomics=true)

collect(count,
        current=sample,
        allneeded=samples,
        ofile='all_samples.salmon.quasimap.tsv')

bam = map(files, fafile=DB)
count = salmon_alignment(bam,
                         transcripts=DB,
                         metagenomics=true)

collect(count,
        current=sample,
        allneeded=samples,
        ofile='all_samples.salmon.bamcounts.tsv')
```
