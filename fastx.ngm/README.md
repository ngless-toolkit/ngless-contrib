# About

This external module integrates: 

fastx version 0.0.13 as fastx module 0.1.0.

## Citation

Fastx is developed by Assaf Gordon and can be found at
http://hannonlab.cshl.edu/fastx_toolkit/

# Usage

Function(s) provided:

* `fastx_quality_stats` - computes per-base quality stats on FASTQ files

This function accepts the following arguments:

| Argument | Type | Required | Default | Options |
| --- | --- | --- | --- | --- |
| `oprefix` | str | true |   |   |

Produces one output, for every input.  
That is if the sample is paired-end, two stats files are generated.

The function appends `pair.1`, `pair.2` or `single` to the filename with same semantics as `write()`

## Example

```
ngless "0.8"
local import "fastx" version "0.1.0"

sample = paired("1.fq", "2.fq")
fastx_quality_stats(sample, oprefix="sample_raw")

bam = map(sample, fafile="reference.fasta")
mapped = select(bam, keep_if=[{mapped}])
fastx_quality_stats(as_reads(mapped), oprefix="sample_mapped")
```

Will create `sample_raw.pair.1.fxstats`, `sample_raw.pair.2.fxstats`, `sample_mapped.pair.1.fxstats` and `sample_mapped.pair.2.fxstats`.
