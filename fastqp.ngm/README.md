# About

This external module integrates: 

fastqp version 0.3.2

## Citation

Fastqp is developed by Matthew Shirley and can be found at
https://github.com/mdshw5/fastqp

# Usage

Functions provided:

* `plot_qc_reads` - performs QC plots from raw or processed reads
* `plot_qc_mapped` - performs QC plots from SAM/BAM files

Both functions accept the same arguments:

| Argument | Type | Required | Default | Options |
| --- | --- | --- | --- | --- |
| `oprefix` | str | true |   |   |
| `name` | str | false |   |   |
| `sample_size` | int | false | 2000000 |   |
| `aligned_only` | flag | false | false |   |
| `unaligned_only` | flag | false | false |   |
| `count_duplicates` | flag | false | false |   |

Produces a zip file containing plots, for every input.  
`oprefix` specifies the output prefix to use for filenames.  
`plot_qc_reads` produces between 1 and 3 outputs depending on if you have forward, reverse and single reads.  
A suffix will be appended to `oprefix` matching the input.

## Example

```
ngless "0.6"
local import "fastqp" version "0.3.2"
import "mocat" version "0.0"

DB = "reference.fasta"

samples = readlines("all_samples.txt")
sample = lock1(samples)
files = load_mocat_sample(sample)

# Will create zip files containing images.
# One zip file per read pair (pair.1, pair.2, single) is created
plot_qc_reads(files, oprefix="plot_qc_raw_reads")

files = preprocess(files, keep_singles=False) using |read|:
    read = substrim(read, min_quality=25)
    if len(read) < 45:
        discard

plot_qc_reads(files, oprefix="plot_qc_processed_reads")

bam = map(files, fafile=DB)
plot_qc_mapped(bam, oprefix="plot_qc_mapped")
```
