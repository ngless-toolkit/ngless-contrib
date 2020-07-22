# Mapping to the GMGCv1 using NGLess

We assume that you are familiar with basic NGLess usage for mapping/counting.
Please see the main documentation and, in particular, the chapter on [how to
use the IGC (integrated gene
catalog)](https://ngless.embl.de/tutorial-gut-metagenomics.html) for profiling
human gut metagenomes.

As this is not (at this time), a builtin module, you need to import is as a
local module.

    nlgess "1.2"
    local import "gmgc" version "1.0"

Note that NGLess 1.2 is _necessary_ to run this module (technically, NGLess 1.1
will be enough for mapping, but an error will be triggered if you attempt to
perform annotation).


## Catalogs and subcatalogs

The module contains several references, which can be mapped against. To map
against the full catalog, use the `gmgc` reference:

    mapped = map(reads, reference="gmgc")

This will work, but (1) indexing can take a long time (**>1 week!**) and (2)
mapping will take a lot of memory. Note that the performance of `bwa` degrades
very poorly if it needs to swap to disk (it will not just be a bit slower; it
will be **much** slower). A good alternative if you do not have access to the
high-memory machines required for the full catalog is to use a subcatalog.

The first type of subcatalog we will look at are the _per-habitat_ subcatalogs.
For example, you can use the subcatalog for the human gut like this:

    mapped = map(reads, reference="gmgc:human-gut")

See the list of available habitats below.

As described in the manuscript, most genes are rare and rare genes are
generally low abundance. Thus, you can remove the lowest prevalence 50% of the
genes without a big impact on mapping rates. These subcatalogs are accessed
with by adding `:no-rare` to the reference name:

    mapped = map(reads, reference="gmgc:no-rare")

You can combine also combine a habitat identifier with `no-rare` to obtain a
habitat-specific subcatalog with no rare genes:

    mapped = map(reads, reference="gmgc:human-gut:no-rare")

A final subcatalog we make available is a catalog containing only complete
genes (refered to as `gmgc:complete`). We do not currently make available
habitat-specific complete subcatalogs to avoid an explosion of possibilities
(we currently make 31 references available), but do [reach
out](https://groups.google.com/forum/#!forum/gmgc-users) if you see a use case
for them and we will add them to the next version.

Note that these are subsets of the full catalog and the identifiers are
preserved so that they always refer to the same sequence (for example, the gene
`GMGC10.004_033_409.UNKNOWN` is the first gene in the human gut subcatalog).

### List of available habitats

1. human-gut
2. mouse-gut
3. dog-gut
4. pig-gut
5. cat-gut
6. human-vagina
7. human-oral
8. human-skin
9. human-nose
10. soil
11. marine
12. built-environment
13. freshwater
14. wastewater
  
## Annotations

The references can be used not just for mapping, but for some functional
annotations as with other NGLess references:

    counts = count(mapped, features=['GOs'])

### Available annotations

1. GOs (Gene onthology)
2. EC (EC numbers)
3. KEGG\_ko
4. KEGG\_Module
5. KEGG\_Pathway
6. KEGG\_Reaction
7. KEGG\_rclass
8. BRITE
9. KEGG\_TC
10. CAZy
11. BiGG\_Reaction

## Complete example

Here's a complete example, mapping to the `human-gut:no-rare` subcatalog

    ngless "1.2"
    import "mocat" version "1.0"
    local import "gmgc" version "1.0"

    input = load_mocat_sample('sample')
    input = preprocess(input) using |r|:
        r = substrim(r, min_quality=25)
        if len(r) < 45:
            discard

    mapped = map(input, reference='gmgc:human-gut:no-rare')

    mapped = select(mapped) using |mr|:
        mr = mr.filter(min_match_size=45, min_identity_pc=95, action={unmatch})

    counts = count(mapped, features=['GOs'])

    write(counts, ofile='gene-ontology.tsv')

